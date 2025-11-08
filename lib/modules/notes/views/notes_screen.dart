import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _noteController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.amber[50],
        title: const Text('Add New Note'),
        content: TextField(
          controller: _noteController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Your note',
            prefixIcon: Icon(Icons.note),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _noteController.clear();
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add"),
            onPressed: () {
              final text = _noteController.text.trim();
              if (text.isNotEmpty) {
                FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user!.uid)
                  .collection('notes')
                  .add({'note': text, 'timestamp': Timestamp.now()});
                _noteController.clear();
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(DocumentSnapshot noteDoc, CollectionReference notesRef) async {
    final TextEditingController editController = TextEditingController(text: noteDoc['note']);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.amber[50],
        title: const Text('Edit Note'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Note'),
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
      await notesRef.doc(noteDoc.id).update({'note': result});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) return const Center(child: Text("Please log in."));
    final notesRef = FirebaseFirestore.instance
      .collection('Users')
      .doc(user!.uid)
      .collection('notes');

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        backgroundColor: Colors.amber[800],
        elevation: 4,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8B500), Color(0xFFFEE440)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.amber[700],
        icon: const Icon(Icons.add),
        label: const Text("Add Note"),
        elevation: 6,
        onPressed: _showAddNoteDialog,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.amber[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: StreamBuilder<QuerySnapshot>(
            stream: notesRef.orderBy('timestamp', descending: true).snapshots(),
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
                      Icon(Icons.sticky_note_2, color: Colors.amber[800], size: 55),
                      const SizedBox(height: 12),
                      Text(
                        "No notes yet!",
                        style: TextStyle(fontSize: 19, color: Colors.amber[800], fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text("Click the + Add Note button to begin.", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                );
              }
              final docs = snapshot.data!.docs;
              return MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                itemCount: docs.length,
                itemBuilder: (context, i) {
                  var note = docs[i];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeIn,
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      elevation: 5,
                      color: Colors.amber[50],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF8B500),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:12, right:10, top:10, bottom:2),
                              child: Text(
                                note['note'],
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12, right: 10, bottom: 4),
                              child: Text(
                                note['timestamp'] != null
                                    ? (note['timestamp'] as Timestamp).toDate().toString().substring(0, 16)
                                    : '',
                                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                  onPressed: () => _showEditDialog(note, notesRef),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => notesRef.doc(note.id).delete(),
                                ),
                              ],
                            ),
                          ],
                        ),
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
