import 'package:flutter/material.dart';
import 'teacher_analytics.dart';
import 'generate_report.dart';
import 'assign_practice.dart';
import 'gaps_detail.dart';
import 'students_detail.dart';
import 'exam_compiler.dart';
import 'agile_board_ide.dart';
import 'virtual_meet.dart';
import '../learning/ai_media_studio_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

class TeacherPortalHub extends StatelessWidget {
  const TeacherPortalHub({super.key});

  static const Color navy = Color(0xFF0B2F63); // CHANGED: matches video navy
  static const Color yellow = Color(0xFFFFD52E); // no longer used in the UI
  static const Color red = Color(0xFFEF3340);

  // NEW: colors taken from the video
  static const Color pageBg = Color(0xFFF6F5FD);
  static const Color softBorder = Color(0xFFE6E2F7);
  static const Color gradStart = Color(0xFF4F46E5);
  static const Color gradEnd = Color(0xFFF12C68);

  Future<void> _confirmLogout(BuildContext context) async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white, // CHANGED
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // CHANGED
        ),
        title: const Text(
          "Log out?",
          style: TextStyle(color: navy, fontWeight: FontWeight.bold),
        ),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel", style: TextStyle(color: navy)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              "Log out",
              style: TextStyle(color: red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
  await Supabase.instance.client.auth.signOut();
  if (!context.mounted) return;

  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}
  }

  // NEW: small round header button (back / logout) in the video style
  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: softBorder, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: navy.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: navy, size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg, // CHANGED: lavender bg
      body: SafeArea(
        child: Column(
          children: [

            //================ HEADER =================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              decoration: BoxDecoration(
                color: Colors.white, // CHANGED: yellow -> white
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: navy.withValues(alpha: 0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // LEFT: back button
                  _circleButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    "Teacher Portal",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800, // CHANGED: bold -> w800
                      color: navy,
                    ),
                  ),
                  const Spacer(),
                  // RIGHT: logout button
                  _circleButton(
                    icon: Icons.logout_rounded,
                    onTap: () => _confirmLogout(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            //================ MODULE LIST =================

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16), // CHANGED: 18 -> 16
                child: Column(
                  children: [
                    // AI Media Studio Launcher
                    SizedBox(
                      width: double.infinity,
                      child: DecoratedBox(
                        // CHANGED: gradient pill like the Sign In button
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [gradStart, gradEnd],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gradEnd.withValues(alpha: 0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AIMediaStudioScreen()),
                            );
                          },
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text('Manage & Synthesize AI Curricula'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, // CHANGED
                            shadowColor: Colors.transparent, // CHANGED
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ), // CHANGED
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

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

  static const Color navy = Color(0xFF0B2F63); // CHANGED

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
          // CHANGED: thick navy border -> thin soft border + shadow
          border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: navy.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
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
                      fontSize: 12.5, // CHANGED: 12 -> 12.5
                      color: Color(0xFF7B8798), // CHANGED: grey -> blue-grey
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9AA3B5), // CHANGED: softer chevron
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}