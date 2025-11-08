import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _taskController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.teal[50],
        title: const Text('Add New Task'),
        content: TextField(
          controller: _taskController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Your task',
            prefixIcon: Icon(Icons.check_box_outlined),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _taskController.clear();
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add"),
            onPressed: () {
              final text = _taskController.text.trim();
              if (text.isNotEmpty) {
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(user!.uid)
                    .collection('todos')
                    .add({'task': text, 'done': false, 'created': Timestamp.now()});
                _taskController.clear();
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(DocumentSnapshot todoDoc, CollectionReference todosRef) async {
    final TextEditingController editController = TextEditingController(text: todoDoc['task']);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.teal[50],
        title: const Text('Edit Task'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Task'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(editController.text.trim());
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      await todosRef.doc(todoDoc.id).update({'task': result});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(child: Text("Please log in."));
    }
    final todosRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .collection('todos');

    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
        backgroundColor: Colors.teal[700],
        elevation: 4,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF64B5F6), Color(0xFF00897B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.add),
        label: const Text("Add Task"),
        elevation: 6,
        onPressed: _showAddDialog,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal[50]!, Colors.blue[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: StreamBuilder<QuerySnapshot>(
            stream: todosRef.orderBy('created', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong!\n${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inbox, color: Colors.teal, size: 55),
                      const SizedBox(height: 12),
                      Text(
                        "No tasks yet!",
                        style: TextStyle(fontSize: 19, color: Colors.teal[800], fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text("Click the + Add Task button to begin.", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                );
              }
              final docs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, i) {
                  var todo = docs[i];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeIn,
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          Container(
                            width: 7,
                            height: 60,
                            decoration: BoxDecoration(
                              color: todo['done'] ? Colors.teal[300] : Colors.teal[700],
                              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              leading: Checkbox(
                                value: todo['done'],
                                activeColor: Colors.teal,
                                onChanged: (v) => todosRef.doc(todo.id).update({'done': v}),
                              ),
                              title: Text(
                                todo['task'],
                                style: TextStyle(
                                  fontSize: 18,
                                  decoration: todo['done'] ? TextDecoration.lineThrough : null,
                                  color: todo['done'] ? Colors.grey : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                todo['created'] != null
                                    ? (todo['created'] as Timestamp).toDate().toString().substring(0, 16)
                                    : '',
                                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                    onPressed: () => _showEditDialog(todo, todosRef),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () => todosRef.doc(todo.id).delete(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
