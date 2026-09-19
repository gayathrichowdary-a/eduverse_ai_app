import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'welcome_screen.dart';
import 'role_selection_page.dart';
import '../onboarding/onboarding_student_information.dart';
import '../teacher/teacher_portal_hub.dart';
import '../parent/parent_home_dashboard.dart';
import '../school/school_dashboard.dart';
import '../admin/admin_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);

  @override
  void initState() {
    super.initState();
    _handleRouting();
  }

  Future<void> _handleRouting() async {
    // 1. Check if returning from Google sign-in (URL has 'code=' or 'access_token=')
    final String currentUrl = kIsWeb ? Uri.base.toString() : '';
    final bool isGoogleRedirect = currentUrl.contains('code=') || currentUrl.contains('access_token=');

    if (isGoogleRedirect) {
      // Wait for Supabase to parse the token from the URL
      int attempts = 0;
      while (Supabase.instance.client.auth.currentSession == null && attempts < 20) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await _routeDirectly(user);
        return;
      }
    }

    // 2. Check if already has an active session
    final existingUser = Supabase.instance.client.auth.currentUser;
    if (existingUser != null) {
      await _routeDirectly(existingUser);
      return;
    }

    // 3. ONLY if brand new visitor: wait 2 seconds and show WelcomeScreen
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  Future<void> _routeDirectly(User user) async {
    String? role;
    try {
      final profile = await Supabase.instance.client
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();
      if (profile != null && profile['role'] != null) {
        role = profile['role'].toString().trim();
      }
    } catch (_) {}

    role ??= user.userMetadata?['role'] as String?;
    final cleanRole = (role ?? '').toLowerCase().trim();

    Widget target;
    if (cleanRole.contains('teacher')) {
      target = const TeacherPortalHub();
    } else if (cleanRole.contains('parent')) {
      target = const ParentHomeDashboard();
    } else if (cleanRole.contains('school')) {
      target = const SchoolDashboard();
    } else if (cleanRole.contains('admin')) {
      target = const AdminDashboard();
    } else if (cleanRole.contains('student')) {
      target = const OnboardingStudentInformation();
    } else {
      // Jump directly to Role Selection! ZERO welcome screens, ZERO walkthroughs!
      target = const RoleSelectionPage();
    }

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => target),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: brandRed,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.auto_stories_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'EduVerse AI',
              style: TextStyle(
                color: navy,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Loading your experience...',
              style: TextStyle(
                color: Color(0xFF4D86AD),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}