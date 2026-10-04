import 'package:flutter/material.dart';
import 'topic_screen.dart'; // exports TopicListScreen
import 'materials_screen.dart';


final List<BoxShadow> _softShadow = [
  BoxShadow(
    color: const Color(0xFF0B2F63).withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 6),
  ),
];

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

  static const Color navy = Color(0xFF0B2F63);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color cardBg = Color(0xFFF0EEFB);

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
        backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: const Color(0x1A0B2F63),
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(22))),
        iconTheme: const IconThemeData(color: navy),
        titleTextStyle: const TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.w800),
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
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2),
              boxShadow: _softShadow,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFFF12C68),
                  child: const Icon(Icons.layers, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: navy),
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
            color: Colors.white,
            elevation: 2,
            shadowColor: const Color(0x140B2F63),
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: Color(0xFFE6E2F7), width: 1.2),
            ),
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
            color: Colors.white,
            elevation: 2,
            shadowColor: const Color(0x140B2F63),
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: Color(0xFFE6E2F7), width: 1.2),
            ),
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
          const Text("Students", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: navy)),
          const SizedBox(height: 8),
          ...dummyStudents.map(
            (name) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: Colors.white,
            elevation: 2,
            shadowColor: const Color(0x140B2F63),
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: Color(0xFFE6E2F7), width: 1.2),
            ),
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