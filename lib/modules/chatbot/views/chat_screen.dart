import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const Color burntOrange = Color(0xFFCC5500);
const Color lightBackground = Color(0xFFFDFDFD);

const String apiKey = 'AIzaSyDiBK0wOHrIrzEgmWDsrtQVqN1_Qh2mh5g';
const String geminiUrl = 'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$apiKey';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<_Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('chatHistory', json.encode(_messages.map((msg) => {
      'text': msg.text,
      'isUser': msg.isUser,
      'timestamp': msg.timestamp.toIso8601String(),
    }).toList()));
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('chatHistory');
    if (saved != null) {
      final decoded = json.decode(saved) as List<dynamic>;
      setState(() {
        _messages.clear();
        _messages.addAll(decoded.map((e) => _Message(
          e['text'],
          e['isUser'],
          DateTime.parse(e['timestamp']),
        )));
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() {
        _error = "Type a valid message.";
      });
      return;
    }
    setState(() {
      _messages.add(_Message(text, true));
      _isLoading = true;
      _error = null;
    });
    _controller.clear();
    _scrollToBottom();
    _saveMessages();

    try {
      final response = await http.post(
        Uri.parse(geminiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'contents': [
            {
              'parts': [
                {'text': text}
              ]
            }
          ]
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '[Empty reply]';
        setState(() {
          _messages.add(_Message(content, false));
        });
        _scrollToBottom();
        _saveMessages();
      } else {
        final errorText = json.decode(response.body)['error']?['message'] ?? 'Server error';
        setState(() {
          _error = errorText;
          _messages.add(_Message('[Error: $errorText]', false));
        });
        _scrollToBottom();
        _saveMessages();
      }
    } catch (e) {
      setState(() {
        _error = "Failed to connect: ${e.toString()}";
        _messages.add(_Message('[Network error]', false));
      });
      _scrollToBottom();
      _saveMessages();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildChatBubble(_Message msg) {
    return Row(
      mainAxisAlignment: msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!msg.isUser)
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: CircleAvatar(
              child: Icon(Icons.smart_toy, color: burntOrange),
              backgroundColor: Colors.grey[300],
              radius: 18,
            ),
          ),
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 270),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
            decoration: BoxDecoration(
              color: msg.isUser ? burntOrange.withOpacity(0.92) : Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  msg.text,
                  style: TextStyle(
                    color: msg.isUser ? Colors.white : Colors.black87,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
        if (msg.isUser)
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: CircleAvatar(
              child: Icon(Icons.person, color: burntOrange),
              backgroundColor: Colors.grey[300],
              radius: 18,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ask Gemini Bot"),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              itemCount: _messages.length,
              itemBuilder: (c, i) => _buildChatBubble(_messages[i]),
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
            ),
          SafeArea(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !_isLoading,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : Icon(Icons.send, color: burntOrange),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: lightBackground,
    );
  }
}

class _Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  _Message(this.text, this.isUser, [DateTime? t])
      : timestamp = t ?? DateTime.now();
}
