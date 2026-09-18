import 'package:flutter/material.dart';
import '../onboarding/onboarding_student_information.dart';
import '../teacher/teacher_portal_hub.dart';
import '../parent/parent_home_dashboard.dart';
import '../admin/admin_dashboard.dart';
import '../school/school_dashboard.dart';

class SuccessPage extends StatelessWidget {
  final String role;

  const SuccessPage({
    super.key,
    this.role = 'Student',
  });

  static const Color navy = Color(0xFF1D3B64);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFEF3340);

  void _continueToDashboard(BuildContext context) {
    Widget destination;

    final normalizedRole = role.toLowerCase().trim();

    if (normalizedRole.contains('teacher')) {
      destination = const TeacherPortalHub();
    } else if (normalizedRole.contains('parent')) {
      destination = const ParentHomeDashboard();
    } else if (normalizedRole.contains('admin')) {
      destination = const AdminDashboard();
    } else if (normalizedRole.contains('school')) {
      destination = const SchoolDashboard();
    } else {
      // Student has detailed information onboarding!
      destination = const OnboardingStudentInformation();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 46),
            child: Column(
              children: [
                const SizedBox(height: 120),
                Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE6F4F0),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: navy,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Color(0xFFE6F4F0),
                        size: 70,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Welcome to EduVerse AI, $role!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  normalizedRoleIsStudent(role)
                      ? "Your account has been verified! Let's personalize your student learning experience."
                      : "Your $role account has been verified successfully. Let's get started.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: subtitleBlue,
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 80),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () => _continueToDashboard(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandRed,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      normalizedRoleIsStudent(role) ? 'Personalize Learning Profile' : 'Enter Dashboard',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool normalizedRoleIsStudent(String r) {
    return r.toLowerCase().trim().contains('student');
  }
}