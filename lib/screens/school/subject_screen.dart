import 'package:flutter/material.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  // Project Colors (Navy and Blue)
  static const Color navy = Color(0xFF1F355C);
  static const Color lightBlue = Color(0xFFE3F2FD);

  // Dummy Data - Later this will come from your database
  final List<Map<String, String>> subjects = [
    {"name": "Mathematics", "code": "MATH101", "teacher": "Dr. Smith"},
    {"name": "Physics", "code": "PHYS202", "teacher": "Prof. Arjun"},
    {"name": "Chemistry", "code": "CHEM303", "teacher": "Ms. Ananya"},
  ];

  Future<void> _showSubjectDialog({Map<String, String>? existing, int? index}) async {
    final nameCtrl = TextEditingController(text: existing?['name'] ?? '');
    final codeCtrl = TextEditingController(text: existing?['code'] ?? '');
    final teacherCtrl = TextEditingController(text: existing?['teacher'] ?? '');

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(existing == null ? "Add Subject" : "Edit Subject"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Subject name"),
              ),
              TextField(
                controller: codeCtrl,
                decoration: const InputDecoration(labelText: "Code"),
              ),
              TextField(
                controller: teacherCtrl,
                decoration: const InputDecoration(labelText: "Teacher"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                Navigator.pop(ctx, {
                  "name": nameCtrl.text.trim(),
                  "code": codeCtrl.text.trim(),
                  "teacher": teacherCtrl.text.trim(),
                });
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        if (index != null) {
          subjects[index] = result;
        } else {
          subjects.add(result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navy,
        title: const Text("Manage Subjects"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: lightBlue, child: Icon(Icons.book, color: navy)),
              title: Text(subjects[index]['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Code: ${subjects[index]['code']} | ${subjects[index]['teacher']}"),
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: () => _showSubjectDialog(existing: subjects[index], index: index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: navy,
        onPressed: () => _showSubjectDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}