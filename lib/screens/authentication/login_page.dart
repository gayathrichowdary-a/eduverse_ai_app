import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'role_selection_page.dart';
import 'forgot_password_page.dart';
import '../onboarding/onboarding_student_information.dart';
import '../teacher/teacher_portal_hub.dart';
import '../parent/parent_home_dashboard.dart';
import '../school/school_dashboard.dart';
import '../admin/admin_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color navy = Color(0xFF1D3B64);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFEF3340);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final SupabaseClient _supabase = Supabase.instance.client;
  StreamSubscription<AuthState>? _authSubscription;
  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _listenToAuthChanges();
  }

  void _routeUserByRole(String? rawRole) {
    final String cleanRole = (rawRole ?? '').toLowerCase().trim();

    debugPrint('Routing authenticated user with role: "$cleanRole"');

    Widget destination;
    if (cleanRole.contains('teacher')) {
      destination = const TeacherPortalHub();
    } else if (cleanRole.contains('parent')) {
      destination = const ParentHomeDashboard();
    } else if (cleanRole.contains('school')) {
      destination = const SchoolDashboard();
    } else if (cleanRole.contains('admin')) {
      destination = const AdminDashboard();
    } else if (cleanRole.contains('student')) {
      destination = const OnboardingStudentInformation();
    } else {
      // First-time Google user: go straight to select role!
      destination = const RoleSelectionPage();
    }

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => destination),
      (route) => false,
    );
  }

  Future<String?> _getUserRole(User user) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      if (data != null && data['role'] != null) {
        final dbRole = data['role'].toString().trim();
        if (dbRole.isNotEmpty) return dbRole;
      }
    } catch (e) {
      debugPrint('Error fetching role: $e');
    }

    final String? metaRole = user.userMetadata?['role'] as String?;
    if (metaRole != null && metaRole.trim().isNotEmpty) {
      return metaRole.trim();
    }

    return null;
  }

  void _listenToAuthChanges() {
    _authSubscription = _supabase.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if ((event == AuthChangeEvent.signedIn ||
              event == AuthChangeEvent.tokenRefreshed) &&
          session != null) {
        final user = session.user;
        final String? existingRole = await _getUserRole(user);
        _routeUserByRole(existingRole);
      }
    });
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = res.user;
      if (user == null) {
        throw const AuthException('Login failed. Please try again.');
      }

      final String? role = await _getUserRole(user);
      _routeUserByRole(role);
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ==========================================
  // REAL GOOGLE OAUTH SIGN-IN (OPENS GOOGLE)
  // ==========================================
  Future<void> _googleLogin() async {
    setState(() => isLoading = true);

    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? null : 'io.supabase.eduverse://login-callback',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in error: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _githubLogin() async {
    setState(() => isLoading = true);
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: kIsWeb ? null : 'io.supabase.eduverse://login-callback',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('GitHub sign-in error: $e'), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back, color: navy, size: 28),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Welcome Back',
                            style: TextStyle(
                              color: navy,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Continue your learning journey.',
                            style: TextStyle(
                              color: subtitleBlue,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 28),
                          const Text(
                            'Email or Mobile Number',
                            style: TextStyle(
                              color: navy,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: emailController,
                            style: const TextStyle(color: navy, fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Enter your credentials',
                              hintStyle: const TextStyle(color: Color(0xFFA6DDE2), fontSize: 16),
                              prefixIcon: const Icon(Icons.person_outline, color: navy, size: 22),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: navy, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: brandRed, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Password',
                            style: TextStyle(
                              color: navy,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            style: const TextStyle(color: navy, fontSize: 16),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              hintStyle: const TextStyle(color: Color(0xFFA6DDE2), fontSize: 18),
                              prefixIcon: const Icon(Icons.lock_outline, color: navy, size: 22),
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => obscurePassword = !obscurePassword),
                                icon: Icon(
                                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: navy,
                                  size: 22,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: navy, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: brandRed, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: brandRed,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: brandRed,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: const [
                              Expanded(child: Divider(color: Color(0xFFE5E7EB), thickness: 1)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('OR', style: TextStyle(color: subtitleBlue, fontSize: 15)),
                              ),
                              Expanded(child: Divider(color: Color(0xFFE5E7EB), thickness: 1)),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _socialButton(
                                child: const Text(
                                  'G',
                                  style: TextStyle(
                                    color: Color(0xFF4285F4),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onTap: isLoading ? () {} : _googleLogin,
                              ),
                              _socialButton(
                                child: const Icon(
                                  Icons.code,
                                  color: navy,
                                  size: 26,
                                ),
                                onTap: isLoading ? () {} : _githubLogin,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(color: subtitleBlue, fontSize: 15),
                            ),
                            const SizedBox(width: 5),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const RoleSelectionPage()),
                                );
                              },
                              child: const Text(
                                'Create Account',
                                style: TextStyle(color: brandRed, fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _socialButton({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE9EDF0), width: 1.5),
        ),
        child: Center(child: child),
      ),
    );
  }
}