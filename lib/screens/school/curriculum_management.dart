import 'package:flutter/material.dart';
// These imports match your sidebar exactly
import 'subject_screen.dart'; 
import 'course_screen.dart';    
import 'topic_screen.dart';     
import 'materials_screen.dart'; 

class CurriculumManagement extends StatelessWidget {
  const CurriculumManagement({super.key});

  static const Color navy = Color(0xFF1F355C);
  static const Color blue = Color(0xFF58C7F3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Curriculum Management",
          style: TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerCard(),
            const SizedBox(height: 24),
            const Text(
              "Curriculum Overview",
              style: TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            
            _module(
              Icons.menu_book_rounded,
              blue,
              "Subjects",
              "Manage school subjects",
              () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SubjectListScreen()));
              },
            ),
            
            _module(
              Icons.layers_rounded,
              const Color(0xFFE94A56),
              "Courses",
              "Manage course structure",
              () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CourseListScreen()));
              },
            ),

            _module(
              Icons.topic_rounded,
              const Color(0xFF57B97A),
              "Topics",
              "Organize chapters and topics",
              () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TopicListScreen()));
              },
            ),

            _module(
              Icons.edit_note_rounded,
              const Color(0xFFF7C948),
              "Learning Materials",
              "Manage study materials",
              () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MaterialsScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(22)),
      child: const Row(
        children: [
          CircleAvatar(radius: 28, backgroundColor: Colors.white, child: Icon(Icons.menu_book_rounded, color: navy, size: 28)),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Curriculum", style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
                Text("Edit subjects and course structure", style: TextStyle(color: Color(0xFFB9C6D6), fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _module(IconData icon, Color color, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: navy, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: navy, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: navy),
          ],
        ),
      ),
    );
  }
}