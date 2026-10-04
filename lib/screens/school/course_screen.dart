import 'package:flutter/material.dart';
import 'course_detail_screen.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  static const Color navy = Color(0xFF0B2F63);

  // 1. THIS IS YOUR LIST (Now it can be changed)
  final List<Map<String, String>> courses = [
    {"name": "Advanced Physics", "id": "PH-01", "students": "45 Students"},
    {"name": "Calculus II", "id": "MA-05", "students": "32 Students"},
  ];

  // 2. CONTROLLERS TO GRAB TEXT FROM THE POPUP
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  // 3. FUNCTION TO SHOW THE "ADD" POPUP
  void _showAddCourseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Add New Course", style: TextStyle(color: navy, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Course Name", hintText: "e.g. Biology"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: "Course ID", hintText: "e.g. BIO-10"),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: navy),
              onPressed: () {
                if (nameController.text.isNotEmpty && idController.text.isNotEmpty) {
                  // 4. ADD THE NEW DATA TO THE LIST
                  setState(() {
                    courses.add({
                      "name": nameController.text,
                      "id": idController.text,
                      "students": "0 Students", // New course starts with 0
                    });
                  });
                  nameController.clear();
                  idController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text("Add Course", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: const Color(0x1A0B2F63),
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(22))),
        iconTheme: const IconThemeData(color: navy),
        titleTextStyle: const TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.w800),
        title: const Text("Courses"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Colors.white,
            elevation: 2,
            shadowColor: const Color(0x140B2F63),
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: Color(0xFFE6E2F7), width: 1.2),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFF12C68), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.layers_rounded, color: Colors.white),
              ),
              title: Text(courses[index]['name']!, style: const TextStyle(fontWeight: FontWeight.bold, color: navy)),
              subtitle: Text("${courses[index]['id']} • ${courses[index]['students']}"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CourseDetailScreen(
                      courseName: courses[index]['name']!,
                      courseCode: courses[index]['id']!,
                      studentsText: courses[index]['students']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      // 5. THE PLUS BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: navy,
        onPressed: _showAddCourseDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}