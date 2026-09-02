import 'package:flutter/material.dart';
import '../onboarding/onboarding_student_information.dart';
// ================= IMPORTS ADDED HERE =================
import '../teacher/teacher_portal_hub.dart';
import '../parent/parent_home_dashboard.dart';
import '../admin/admin_dashboard.dart';
import '../school/school_dashboard.dart';

class SuccessPage extends StatelessWidget {
  // ================= ROLE ADDED HERE =================
  final String role;

  const SuccessPage({super.key, required this.role});

  // =========================
  // COLORS
  // =========================

  static const Color navy = Color(0xFF1D3B64);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFEF3340);

  // =========================================================
  // ROUTE TO THE CORRECT DASHBOARD BASED ON ROLE
  // =========================================================

  void _continueToDashboard(BuildContext context) {
    Widget destination;

    switch (role) {
      case 'Teacher':
        destination = const TeacherPortalHub();
        break;
      case 'Parent':
        destination = const ParentHomeDashboard();
        break;
      case 'Student':
        destination = const OnboardingStudentInformation();
        break;
      case 'Administrator':
        destination = const AdminDashboard();
        break;
      case 'School':
        destination = const SchoolDashboard();
        break;
      default:
        // Unrecognized role: no screen exists yet.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$role dashboard is not built yet — hook this up to your next screen.',
            ),
          ),
        );
        return;
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

                // =========================
                // SUCCESS ICON
                // =========================

                const SizedBox(height: 180),

                Container(
                  width: 225,
                  height: 225,

                  decoration: const BoxDecoration(
                    color: Color(0xFFE6F4F0),
                    shape: BoxShape.circle,
                  ),

                  child: Center(
                    child: Container(
                      width: 125,
                      height: 125,

                      decoration: const BoxDecoration(
                        color: navy,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.check,
                        color: Color(0xFFE6F4F0),
                        size: 90,
                      ),
                    ),
                  ),
                ),

                // =========================
                // TITLE
                // =========================

                const SizedBox(height: 55),

                const Text(
                  'Welcome to EduVerse AI!',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: navy,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),

                // =========================
                // DESCRIPTION
                // =========================

                const SizedBox(height: 28),

                const Text(
                  "Your account has been created successfully. Let's\n"
                  "personalize your learning experience.",

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: subtitleBlue,
                    fontSize: 22,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 180),

                // =========================
                // CONTINUE BUTTON
                // =========================

                SizedBox(
                  width: double.infinity,
                  height: 92,

                  child: ElevatedButton(
                    onPressed: () => _continueToDashboard(context),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandRed,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),

                    child: const Text(
                      'Continue',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                // =========================
                // TAKE A TOUR
                // =========================

                const SizedBox(height: 35),

                GestureDetector(
                  onTap: () {
                    // App tour will be connected here
                  },

                  child: const Text(
                    'Take a tour',

                    style: TextStyle(
                      color: brandRed,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 65),
              ],
            ),
          ),
        ),
      ),
    );
  }
}