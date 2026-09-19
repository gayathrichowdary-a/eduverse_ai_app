import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/authentication/splash_screen.dart';
import 'screens/authentication/role_selection_page.dart';
import 'screens/onboarding/onboarding_student_information.dart';
import 'screens/teacher/teacher_portal_hub.dart';
import 'screens/parent/parent_home_dashboard.dart';
import 'screens/school/school_dashboard.dart';
import 'screens/admin/admin_dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vhinpqngeownrpjnsuay.supabase.co',
    anonKey: 'sb_publishable_BDYE5Y74y2J_2FhJkEykEw_YnKto2fR',
  );

  runApp(const EduVerseAI());
}

class EduVerseAI extends StatelessWidget {
  const EduVerseAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduVerse AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEF3340),
        ),
        useMaterial3: true,
      ),
      home: const InitialRouter(),
    );
  }
}

class InitialRouter extends StatefulWidget {
  const InitialRouter({super.key});

  @override
  State<InitialRouter> createState() => _InitialRouterState();
}

class _InitialRouterState extends State<InitialRouter> {
  final SupabaseClient _supabase = Supabase.instance.client;
  Widget? _targetScreen;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkRedirectOrStart();
  }

  Future<void> _checkRedirectOrStart() async {
    // 1. Check if returning from Google OAuth redirect (URL has 'code=' or 'access_token')
    final String currentUrl = kIsWeb ? Uri.base.toString() : '';
    final bool isOAuthRedirect = currentUrl.contains('code=') || currentUrl.contains('access_token=');

    if (isOAuthRedirect) {
      // Wait briefly for Supabase to exchange the code for a session
      int attempts = 0;
      while (_supabase.auth.currentSession == null && attempts < 15) {
        await Future.delayed(const Duration(milliseconds: 200));
        attempts++;
      }

      final user = _supabase.auth.currentUser;
      if (user != null) {
        final screen = await _destinationForUser(user);
        if (mounted) {
          setState(() {
            _targetScreen = screen;
            _isLoading = false;
          });
        }
        return;
      }
    }

    // 2. Normal first-time startup: show Splash Screen
    if (mounted) {
      setState(() {
        _targetScreen = const SplashScreen();
        _isLoading = false;
      });
    }
  }

  Future<Widget> _destinationForUser(User user) async {
    String? role;
    try {
      final profile = await _supabase
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      if (profile != null && profile['role'] != null) {
        final r = profile['role'].toString().trim();
        if (r.isNotEmpty) role = r;
      }
    } catch (e) {
      debugPrint('Error fetching role in InitialRouter: $e');
    }

    role ??= user.userMetadata?['role'] as String?;
    final cleanRole = (role ?? '').toLowerCase().trim();

    if (cleanRole.contains('teacher')) {
      return const TeacherPortalHub();
    } else if (cleanRole.contains('parent')) {
      return const ParentHomeDashboard();
    } else if (cleanRole.contains('school')) {
      return const SchoolDashboard();
    } else if (cleanRole.contains('admin')) {
      return const AdminDashboard();
    } else if (cleanRole.contains('student')) {
      return const OnboardingStudentInformation();
    } else {
      // Direct jump to Role Selection! No splash, no welcome page loop!
      return const RoleSelectionPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFEF3340),
          ),
        ),
      );
    }

    return _targetScreen ?? const SplashScreen();
  }
}