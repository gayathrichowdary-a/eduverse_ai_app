import 'package:flutter/material.dart';

class LectureNotesScreen extends StatefulWidget {
  const LectureNotesScreen({super.key});

  @override
  State<LectureNotesScreen> createState() => _LectureNotesScreenState();
}

class _LectureNotesScreenState extends State<LectureNotesScreen> {
  static const Color navy = Color(0xFF1F355C);

  // Dummy Data - later this will come from your database / file storage
  final List<Map<String, String>> notes = [
    {"title": "Chapter 1 - Newton's Laws.pdf", "date": "Uploaded 2 Aug 2026"},
    {"title": "Chapter 2 - Thermodynamics.pdf", "date": "Uploaded 5 Aug 2026"},
  ];

  final TextEditingController titleController = TextEditingController();

  void _addNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Add Lecture Note", style: TextStyle(color: navy, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: "File name", hintText: "e.g. Chapter 3 - Optics.pdf"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: navy),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  notes.add({
                    "title": titleController.text,
                    "date": "Uploaded just now",
                  });
                });
                titleController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: navy,
        title: const Text("Lecture Notes", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: notes.isEmpty
          ? const Center(child: Text("No notes uploaded yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: const Icon(Icons.description, color: Colors.blue, size: 32),
                    title: Text(notes[index]['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(notes[index]['date']!),
                    trailing: const Icon(Icons.download_rounded, color: navy),
                    onTap: () {
                      // Later: open/preview the actual file here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Opening ${notes[index]['title']}...")),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: navy,
        onPressed: _addNoteDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}