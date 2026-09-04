import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'role_selection_page.dart';
import 'forgot_password_page.dart';
import 'success_page.dart'; // <-- Added to navigate to next page

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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final SupabaseClient _supabase = Supabase.instance.client;

  bool obscurePassword = true;
  bool isLoading = false;

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

      // Get user's role from metadata or default to Student
      final role = res.user?.userMetadata?['role'] as String? ?? 'Student';

      // Navigate to the next page!
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessPage(role: role),
        ),
      );
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

  // =========================
  // GOOGLE LOGIN
  // =========================

  void _googleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google login selected'),
      ),
    );
  }

  // =========================
  // GITHUB LOGIN
  // =========================

  void _githubLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('GitHub login selected'),
      ),
    );
  }

  @override
  void dispose() {
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

                const SizedBox(height: 90),

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

                const SizedBox(height: 55),

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

                const SizedBox(height: 35),

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

                const SizedBox(height: 70),

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

                const SizedBox(height: 55),

                // =========================
                // SOCIAL LOGIN BUTTONS
                // =========================

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    _socialButton(
                      child: const Text(
                        'G',
                        style: TextStyle(
                          color: navy,
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: _googleLogin,
                    ),

                    _socialButton(
                      child: const Icon(
                        Icons.code,
                        color: navy,
                        size: 34,
                      ),
                      onTap: _githubLogin,
                    ),
                  ],
                ),

                const SizedBox(height: 300),

                // =========================
                // CREATE ACCOUNT
                // =========================

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Flexible(
                      child: Text(
                        "Don't have an account?",
                        style: const TextStyle(
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