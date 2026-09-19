import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../onboarding/onboarding_student_information.dart';
import '../teacher/teacher_portal_hub.dart';
import '../parent/parent_home_dashboard.dart';
import '../admin/admin_dashboard.dart';
import '../school/school_dashboard.dart';

class SuccessPage extends StatelessWidget {
  final String role;

  const SuccessPage({
    super.key,
    required this.role,
  });

  static const Color navy = Color(0xFF1D3B64);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFEF3340);

  void _continueToDashboard(BuildContext context) {
    final String cleanRole = role.toLowerCase().trim();

    debugPrint('SuccessPage routing role: "$cleanRole"');

    Widget destination;

    // 1. TEACHER -> Teacher Dashboard
    if (cleanRole.contains('teacher')) {
      destination = const TeacherPortalHub();
    }
    // 2. SCHOOL -> School Dashboard
    else if (cleanRole.contains('school')) {
      destination = const SchoolDashboard();
    }
    // 3. ADMIN -> Admin Dashboard
    else if (cleanRole.contains('admin')) {
      destination = const AdminDashboard();
    }
    // 4. PARENT -> Parent Dashboard
    else if (cleanRole.contains('parent')) {
      destination = const ParentHomeDashboard();
    }
    // 5. STUDENT -> Student Onboarding Process
    else {
      destination = const OnboardingStudentInformation();
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => destination),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cleanRole = role.toLowerCase().trim();
    final bool isStudent = cleanRole.contains('student');
    final String displayRole = role.isNotEmpty ? role : 'Student';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 140,
                        height: 140,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE6F4F0),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: navy,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Color(0xFFE6F4F0),
                              size: 55,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Welcome to EduVerse AI, $displayRole!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isStudent
                            ? "Your student account has been verified! Let's personalize your learning experience."
                            : "Your $displayRole account has been verified successfully. Let's enter your dashboard.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: subtitleBlue,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 48),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
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
                            isStudent
                                ? 'Personalize Learning Profile'
                                : 'Enter $displayRole Dashboard',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}