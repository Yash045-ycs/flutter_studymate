import 'package:flutter/material.dart';
import '../../todo/views/todo_screen.dart';
import '../../notes/views/notes_screen.dart';
import '../../chatbot/views/chat_screen.dart';

const Color burntOrange = Color(0xFFC95C27);
const Color titleBrown = Color(0xFF5B3F30);

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('StudyMate Dashboard', style: TextStyle(color: titleBrown)),
      //   backgroundColor: Colors.white,
      //   centerTitle: true,
      //   elevation: 2,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _mainButton(
              context,
              icon: Icons.check_box,
              label: 'To-Do List',
              color: Colors.teal[200]!,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TodoScreen()),
              ),
            ),
            const SizedBox(height: 32),
            _mainButton(
              context,
              icon: Icons.note,
              label: 'Notes',
              color: Colors.amber[200]!,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotesScreen()),
              ),
            ),
            const SizedBox(height: 32),
            _mainButton(
              context,
              icon: Icons.smart_toy,
              label: 'Chatbot',
              color: burntOrange.withOpacity(0.9),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatScreen()),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(15, 201, 92, 39),
    );
  }

  Widget _mainButton(BuildContext context,
      {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 38, color: Colors.white),
        label: Text(label, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 6,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        ),
        onPressed: onTap,
      ),
    );
  }
}