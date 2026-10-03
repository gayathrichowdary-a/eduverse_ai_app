import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import '../../../../screens/onboarding/onboarding_student_information.dart';
import '../../../../state/locale_controller.dart';
import '../../../../widgets/language_selector.dart';
import '../../domain/auth_models.dart';
import '../../domain/auth_service.dart';
import '../auth_strings.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_link.dart';
import '../widgets/auth_shell.dart';
import '../widgets/role_selector.dart';
import 'auth_success_screen.dart';
import 'forgot_password_screen.dart';
import 'otp_verification_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  final LocaleController localeController;
  final AuthService authService;

  const LoginScreen({
    super.key,
    required this.localeController,
    required this.authService,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  UserRole _role = UserRole.student;
  bool _obscure = true;
  bool _loading = false;
  bool _isGoogleSigningIn = false;
  bool _isGithubSigningIn = false;

  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    // Catch OAuth session (Google & GitHub) when returning from browser
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if ((event == AuthChangeEvent.signedIn ||
              event == AuthChangeEvent.tokenRefreshed) &&
          session != null &&
          (_isGoogleSigningIn || _isGithubSigningIn)) {
        _isGoogleSigningIn = false;
        _isGithubSigningIn = false;
        if (mounted) {
          setState(() => _loading = false);
        }
        _navigateAfterLogin();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  void _navigateAfterLogin() {
    if (!mounted) return;

    final user = Supabase.instance.client.auth.currentUser;
    final userEmail = user?.email ?? _identifier.text.trim();
    final displayName = (user?.userMetadata?['full_name'] as String?) ??
        (user?.userMetadata?['user_name'] as String?) ??
        (user?.userMetadata?['name'] as String?) ??
        (userEmail.isNotEmpty ? userEmail.split('@').first : 'User');

    try {
      Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'role': _role.key}),
      );
    } catch (_) {}

    if (_role == UserRole.student) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const OnboardingStudentInformation(),
        ),
        (route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => AuthSuccessScreen(
            user: AuthUser(
              id: user?.id ?? 'user-id',
              name: displayName,
              identifier: userEmail,
              role: _role,
              profile: AuthProfile(
                displayName: displayName,
                identifier: userEmail,
              ),
            ),
            localeController: widget.localeController,
          ),
        ),
        (route) => false,
      );
    }
  }

  String _label(AuthStrings s) => switch (_role) {
        UserRole.student => 'Student email / Student ID',
        UserRole.parent => 'Parent email / Mobile number',
        UserRole.teacher => 'Teacher email / Employee ID',
        UserRole.school => 'School email / School code',
        UserRole.admin => 'Admin email / Admin ID',
      };

  String _hint() => switch (_role) {
        UserRole.student => 'student@school.com or EVS-1024',
        UserRole.parent => 'parent@email.com or 10-digit mobile',
        UserRole.teacher => 'teacher@school.com or EMP-1024',
        UserRole.school => 'school@email.com or SCHOOL-1024',
        UserRole.admin => 'admin@eduverse.ai or ADM-1024',
      };

  // ------------------------------------------------------------
  // OTP-Based Login Method
  // ------------------------------------------------------------
  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);

    try {
      String emailInput = _identifier.text.trim();
      if (!emailInput.contains('@')) {
        emailInput = '$emailInput@eduverse.ai';
      }

      // Send 6-digit OTP code to the email
      await Supabase.instance.client.auth.signInWithOtp(
        email: emailInput,
        shouldCreateUser: true,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('6-digit OTP sent to $emailInput!'),
          backgroundColor: const Color(0xFF1D9445),
        ),
      );

      // 👉 Go to OTP Verification Screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            role: _role.key,
            email: emailInput,
            localeController: widget.localeController,
            profileData: {
              'email': emailInput,
              'role': _role.key,
            },
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ------------------------------------------------------------
  // Google Sign-In
  // ------------------------------------------------------------
  Future<void> _signInWithGoogle() async {
    try {
      setState(() {
        _loading = true;
        _isGoogleSigningIn = true;
      });

      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.eduverse://login-callback',
      );
    } on AuthException catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _isGoogleSigningIn = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _isGoogleSigningIn = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign-In failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ------------------------------------------------------------
  // GitHub Sign-In
  // ------------------------------------------------------------
  Future<void> _signInWithGithub() async {
    try {
      setState(() {
        _loading = true;
        _isGithubSigningIn = true;
      });

      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: 'io.supabase.eduverse://login-callback',
      );
    } on AuthException catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _isGithubSigningIn = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _isGithubSigningIn = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('GitHub Sign-In failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _googleSignInButton() {
    return OutlinedButton(
      onPressed: _loading ? null : _signInWithGoogle,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        side: const BorderSide(color: Color(0xFFE5E8F1), width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
            height: 22,
            width: 22,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.g_mobiledata, size: 28, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Text(
            _loading && _isGoogleSigningIn
                ? 'Signing in...'
                : 'Continue with Google',
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _githubSignInButton() {
    return OutlinedButton(
      onPressed: _loading ? null : _signInWithGithub,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        side: const BorderSide(color: Color(0xFFE5E8F1), width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.code_rounded,
            size: 22,
            color: Color(0xFF181717),
          ),
          const SizedBox(width: 12),
          Text(
            _loading && _isGithubSigningIn
                ? 'Connecting GitHub...'
                : 'Continue with GitHub',
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AuthStrings.of(context);
    return AuthShell(
      eyebrow: 'SECURE ACCESS • ${_role.key.toUpperCase()}',
      title: 'Welcome back to EduVerse.',
      subtitle:
          'Login to your ${_role.key} space and continue your personalized EduVerse experience.',
      topAction: Row(mainAxisSize: MainAxisSize.min, children: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => SignupScreen(
              localeController: widget.localeController,
              authService: widget.authService,
            ),
          )),
          child: Text(s.signupTop),
        ),
        LanguageSelector(controller: widget.localeController, compact: true),
      ]),
      child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.role,
              style: const TextStyle(
                  color: Color(0xFF334155),
                  fontWeight: FontWeight.w800,
                  fontSize: 13)),
          const SizedBox(height: 10),
          RoleSelector(
            selected: _role,
            onChanged: (r) => setState(() => _role = r),
            labels: {
              UserRole.student: s.student,
              UserRole.parent: s.parent,
              UserRole.teacher: s.teacher,
              UserRole.school: s.school,
              UserRole.admin: s.admin,
            },
          ),
          const SizedBox(height: 18),
          AuthField(
            controller: _identifier,
            label: _label(s),
            hint: _hint(),
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (v) =>
                (v?.trim().isEmpty ?? true) ? s.fillRequired : null,
          ),
          const SizedBox(height: 14),
          AuthField(
            controller: _password,
            label: s.password,
            hint: s.passwordHint,
            icon: Icons.lock_outline_rounded,
            obscureText: _obscure,
            onVisibilityTap: () => setState(() => _obscure = !_obscure),
            textInputAction: TextInputAction.done,
            validator: (v) => (v?.length ?? 0) < 6 ? 'Password must be at least 6 characters' : null,
            onSubmitted: (_) => _login(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ForgotPasswordScreen(
                  localeController: widget.localeController,
                  authService: widget.authService,
                  initialRole: _role,
                ),
              )),
              child: Text(s.forgotPassword),
            ),
          ),
          AuthButton(
            label: 'Login',
            onPressed: _login,
            loading: _loading && !_isGoogleSigningIn && !_isGithubSigningIn,
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(child: Divider(color: Color(0xFFE2E8F0))),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('OR',
                    style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
              Expanded(child: Divider(color: Color(0xFFE2E8F0))),
            ],
          ),
          const SizedBox(height: 16),
          _googleSignInButton(),
          const SizedBox(height: 10),
          _githubSignInButton(),
          const SizedBox(height: 18),
          Center(
            child: AuthLink(
              prefix: s.newHere,
              action: s.createAccount,
              onTap: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => SignupScreen(
                  localeController: widget.localeController,
                  authService: widget.authService,
                ),
              )),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text('Demo: demo@eduverse.ai / Password123',
                style: TextStyle(fontSize: 11, color: Color(0xFF98A2B3))),
          ),
        ]),
      ),
    );
  }
}