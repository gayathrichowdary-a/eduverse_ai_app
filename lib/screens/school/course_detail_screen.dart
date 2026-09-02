import 'package:flutter/material.dart';
import 'topic_screen.dart'; // exports TopicListScreen
import 'materials_screen.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseName;
  final String courseCode;
  final String studentsText;

  const CourseDetailScreen({
    super.key,
    required this.courseName,
    required this.courseCode,
    required this.studentsText,
  });

  static const Color navy = Color(0xFF1F355C);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color cardBg = Color(0xFFFCE4E4);

  @override
  Widget build(BuildContext context) {
    // Dummy students - later this will come from your database, filtered by course
    final List<String> dummyStudents = [
      "Aarav Mehta",
      "Diya Sharma",
      "Kabir Singh",
      "Ishita Rao",
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: navy,
        title: Text(courseName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header card - repeats identity from the list screen
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.red[400],
                  child: const Icon(Icons.layers, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: navy),
                    ),
                    const SizedBox(height: 4),
                    Text("$courseCode • $studentsText"),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Topics
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: const Icon(Icons.menu_book, color: navy),
              title: const Text("Topics", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("View chapters and lessons"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TopicListScreen()),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Materials
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: const Icon(Icons.folder, color: navy),
              title: const Text("Materials", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Notes, PDFs and resources"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MaterialsScreen()),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Students
          const Text("Students", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: navy)),
          const SizedBox(height: 8),
          ...dummyStudents.map(
            (name) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: lightBlue, child: Icon(Icons.person, color: navy)),
                title: Text(name),
              ),
            ),
          ),
        ],
      ),
    );
  }
}