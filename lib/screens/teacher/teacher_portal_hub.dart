import 'package:flutter/material.dart';
import 'teacher_analytics.dart';
import 'generate_report.dart';
import 'assign_practice.dart';
import 'gaps_detail.dart';
import 'students_detail.dart';
import 'exam_compiler.dart';
import 'agile_board_ide.dart';
import 'virtual_meet.dart';

class TeacherPortalHub extends StatelessWidget {
  const TeacherPortalHub({super.key});

  static const Color navy = Color(0xFF1F355C);
  static const Color yellow = Color(0xFFFFD52E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [

            //================ HEADER =================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              decoration: const BoxDecoration(
                color: yellow,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all(color: navy, width: 2),
                      ),
                      child: const Icon(Icons.arrow_back, color: navy, size: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    "Teacher Portal",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            //================ MODULE LIST =================

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    _TeacherModuleTile(
                      icon: Icons.bar_chart_rounded,
                      color: const Color(0xFF58C7F3),
                      title: "Analytics",
                      subtitle: "Class performance overview",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TeacherAnalytics(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _TeacherModuleTile(
                      icon: Icons.quiz_rounded,
                      color: const Color(0xFF7C6FF0),
                      title: "Exam Compiler",
                      subtitle: "Create & publish exams",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExamCompilerScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _TeacherModuleTile(
                      icon: Icons.integration_instructions_rounded,
                      color: const Color(0xFFF29E4C),
                      title: "Agile Board",
                      subtitle: "Review student projects",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AgileBoardIde(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _TeacherModuleTile(
                      icon: Icons.videocam_rounded,
                      color: const Color(0xFF4EA8DE),
                      title: "Virtual Meet",
                      subtitle: "Online classes & meetings",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VirtualMeet(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _TeacherModuleTile(
                      icon: Icons.groups_rounded,
                      color: const Color(0xFFE94A56),
                      title: "Students Needing Help",
                      subtitle: "Students flagged for support",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StudentsDetail(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _TeacherModuleTile(
                      icon: Icons.trending_down_rounded,
                      color: const Color(0xFFF7C948),
                      title: "Learning Gaps",
                      subtitle: "Weak topics by subject",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GapsDetail(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _TeacherModuleTile(
                      icon: Icons.assignment_rounded,
                      color: const Color(0xFF57B97A),
                      title: "Assign Practice",
                      subtitle: "Send a practice set to students",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AssignPractice(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _TeacherModuleTile(
                      icon: Icons.description_rounded,
                      color: const Color(0xFF9BE3A6),
                      title: "Generate Report",
                      subtitle: "Export a class report",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GenerateReport(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class _TeacherModuleTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TeacherModuleTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const Color navy = Color(0xFF1F355C);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: navy, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
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