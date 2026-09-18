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

  Future<void> _continueToDashboard(BuildContext context) async {
    String cleanRole = role.toLowerCase().trim();

    // If role is somehow missing, check Supabase user metadata or database
    if (cleanRole.isEmpty || cleanRole == 'student') {
      try {
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          final metaRole = user.userMetadata?['role']?.toString().trim();
          if (metaRole != null && metaRole.isNotEmpty) {
            cleanRole = metaRole.toLowerCase().trim();
          } else {
            final profile = await Supabase.instance.client
                .from('profiles')
                .select('role')
                .eq('id', user.id)
                .maybeSingle();
            if (profile != null && profile['role'] != null) {
              cleanRole = profile['role'].toString().toLowerCase().trim();
            }
          }
        }
      } catch (e) {
        debugPrint('Error retrieving fallback role in SuccessPage: $e');
      }
    }

    debugPrint('SuccessPage ROUTING NOW TO ROLE: "$cleanRole"');

    Widget destination;

    // 1. Check ADMIN first
    if (cleanRole.contains('admin')) {
      destination = const AdminDashboard();
    }
    // 2. Check SCHOOL
    else if (cleanRole.contains('school')) {
      destination = const SchoolDashboard();
    }
    // 3. Check TEACHER
    else if (cleanRole.contains('teacher')) {
      destination = const TeacherPortalHub();
    }
    // 4. Check PARENT
    else if (cleanRole.contains('parent')) {
      destination = const ParentHomeDashboard();
    }
    // 5. Check STUDENT (Only genuine students go to onboarding)
    else {
      destination = const OnboardingStudentInformation();
    }

    if (!context.mounted) return;

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
                  isStudent
                      ? "Your account has been verified! Let's personalize your student learning experience."
                      : "Your $role account has been verified successfully. Let's enter your dashboard.",
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
                      isStudent ? 'Personalize Learning Profile' : 'Enter $role Dashboard',
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
}