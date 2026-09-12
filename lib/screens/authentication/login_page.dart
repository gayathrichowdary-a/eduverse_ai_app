import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'role_selection_page.dart';
import 'forgot_password_page.dart';
import 'success_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // =========================
  // COLORS
  // =========================

  static const Color navy = Color(0xFF1D3B64);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFEF3340);

  // =========================
  // GOOGLE WEB CLIENT ID
  // =========================
  static const String _webClientId =
      '562258769343-djt08qk2cg68p997l0j2lnhg8kovv81v.apps.googleusercontent.com';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final SupabaseClient _supabase = Supabase.instance.client;

  StreamSubscription<AuthState>? _authSubscription;
  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Listen for OAuth deep link callbacks (specifically for GitHub login)
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSubscription = _supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        final user = session.user;
        final String? existingRole = user.userMetadata?['role'] as String?;

        if (!mounted) return;

        // Solution 1 Check:
        // Existing user with role -> SuccessPage
        // New user without role -> RoleSelectionPage
        if (existingRole != null && existingRole.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessPage(role: existingRole),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const RoleSelectionPage(),
            ),
          );
        }
      }
    });
  }

  // =========================
  // EMAIL / PASSWORD LOGIN
  // =========================

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

      if (res.user == null) {
        throw const AuthException('Login failed. Please try again.');
      }

      if (!mounted) return;

      // Check user's role from metadata
      final String? role = res.user?.userMetadata?['role'] as String?;

      if (role == null || role.isEmpty) {
        // If no role set, prompt role selection
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const RoleSelectionPage(),
          ),
        );
      } else {
        // Navigate to the next page!
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(role: role),
          ),
        );
      }
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

  // ============================================================
  // GOOGLE LOGIN WITH INTELLIGENT ROLE DETECTION (SOLUTION 1)
  // ============================================================

  Future<void> _googleLogin() async {
    setState(() => isLoading = true);

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: _webClientId,
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        setState(() => isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw const AuthException(
          'Could not retrieve Google ID token.',
        );
      }

      // Sign in to Supabase using Google ID Token
      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (!mounted) return;

      if (response.user != null) {
        final userMetadata = response.user!.userMetadata;
        final String? existingRole = userMetadata?['role'] as String?;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Welcome, ${googleUser.displayName ?? googleUser.email}!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Solution 1 Check:
        if (existingRole != null && existingRole.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessPage(role: existingRole),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const RoleSelectionPage(),
            ),
          );
        }
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google sign-in error: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ============================================================
  // GITHUB LOGIN WITH INTELLIGENT ROLE DETECTION (SOLUTION 1)
  // ============================================================

  Future<void> _githubLogin() async {
    setState(() => isLoading = true);

    try {
      final bool launched = await _supabase.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: 'io.supabase.eduverse://login-callback',
      );

      if (!launched) {
        throw const AuthException('Could not launch GitHub sign-in.');
      }

      // The _listenToAuthChanges stream will automatically capture the login
      // and redirect to SuccessPage (if role exists) or RoleSelectionPage!
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('GitHub sign-in error: $e'),
          backgroundColor: Colors.redAccent,
        ),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 30),

                // =========================
                // BACK BUTTON
                // =========================

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: navy,
                    size: 32,
                  ),
                ),

                const SizedBox(height: 30),

                // =========================
                // TITLE
                // =========================

                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: navy,
                    fontSize: 50,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 15),

                // =========================
                // SUBTITLE
                // =========================

                const Text(
                  'Continue your learning journey.',
                  style: TextStyle(
                    color: subtitleBlue,
                    fontSize: 25,
                  ),
                ),

                const SizedBox(height: 70),

                // =========================
                // EMAIL LABEL
                // =========================

                const Text(
                  'Email or Mobile Number',
                  style: TextStyle(
                    color: navy,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 15),

                // =========================
                // EMAIL FIELD
                // =========================

                TextField(
                  controller: emailController,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your credentials',
                    hintStyle: const TextStyle(
                      color: Color(0xFFA6DDE2),
                      fontSize: 22,
                    ),

                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: navy,
                      size: 30,
                    ),

                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 20,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: navy,
                        width: 2,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: brandRed,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 45),

                // =========================
                // PASSWORD LABEL
                // =========================

                const Text(
                  'Password',
                  style: TextStyle(
                    color: navy,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 15),

                // =========================
                // PASSWORD FIELD
                // =========================

                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    hintStyle: const TextStyle(
                      color: Color(0xFFA6DDE2),
                      fontSize: 24,
                    ),

                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: navy,
                      size: 30,
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: navy,
                        size: 30,
                      ),
                    ),

                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 20,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: navy,
                        width: 2,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: brandRed,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // =========================
                // FORGOT PASSWORD
                // =========================

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: brandRed,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // =========================
                // LOGIN BUTTON
                // =========================

                SizedBox(
                  width: double.infinity,
                  height: 92,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandRed,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 50),

                // =========================
                // OR DIVIDER
                // =========================

                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Color(0xFFE5E7EB),
                        thickness: 1,
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: subtitleBlue,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    const Expanded(
                      child: Divider(
                        color: Color(0xFFE5E7EB),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // =========================
                // SOCIAL LOGIN BUTTONS
                // =========================

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Google Button
                    _socialButton(
                      child: const Text(
                        'G',
                        style: TextStyle(
                          color: Color(0xFF4285F4),
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: isLoading ? () {} : _googleLogin,
                    ),

                    // GitHub Button
                    _socialButton(
                      child: const Icon(
                        Icons.code,
                        color: navy,
                        size: 34,
                      ),
                      onTap: isLoading ? () {} : _githubLogin,
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // =========================
                // CREATE ACCOUNT
                // =========================

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Flexible(
                      child: Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: subtitleBlue,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(width: 5),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const RoleSelectionPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          color: brandRed,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // SOCIAL BUTTON
  // =========================

  Widget _socialButton({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE9EDF0),
            width: 1.5,
          ),
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}