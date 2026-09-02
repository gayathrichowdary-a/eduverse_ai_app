import 'package:flutter/material.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // =========================
  // COLORS
  // =========================

  static const Color navy = Color(0xFF1D3B64);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color hintColor = Color(0xFFA6DDE2);

  final emailController = TextEditingController();

  bool linkSent = false;
  bool isSending = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // =========================
  // SEND RESET LINK
  // =========================

  void _sendResetLink() async {
    final email = emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid registered email'),
        ),
      );
      return;
    }

    setState(() {
      isSending = true;
    });

    // TODO: Hook up actual reset-link API call here.
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      isSending = false;
      linkSent = true;
    });
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

                const SizedBox(height: 20),

                // =========================
                // BACK BUTTON
                // =========================

                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: navy,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 25),

                // =========================
                // TITLE
                // =========================

                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: navy,
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 15),

                // =========================
                // SUBTITLE
                // =========================

                Text(
                  linkSent
                      ? 'A password reset link has been sent to your registered email.'
                      : 'Enter your registered email address and we\'ll send you a link to reset your password.',
                  style: const TextStyle(
                    color: subtitleBlue,
                    fontSize: 20,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 55),

                if (!linkSent) ...[

                  // =========================
                  // EMAIL LABEL
                  // =========================

                  const Text(
                    'Registered Email',
                    style: TextStyle(
                      color: navy,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // =========================
                  // EMAIL FIELD
                  // =========================

                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,

                    style: const TextStyle(
                      color: navy,
                      fontSize: 20,
                    ),

                    decoration: InputDecoration(
                      hintText: 'email@example.com',

                      hintStyle: const TextStyle(
                        color: hintColor,
                        fontSize: 22,
                      ),

                      prefixIcon: const Icon(
                        Icons.email_outlined,
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
                  // SEND LINK BUTTON
                  // =========================

                  SizedBox(
                    width: double.infinity,
                    height: 92,

                    child: ElevatedButton(
                      onPressed: isSending ? null : _sendResetLink,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandRed,
                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),

                      child: isSending
                          ? const SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              'Send Reset Link',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),

                ] else ...[

                  // =========================
                  // SUCCESS STATE
                  // =========================

                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: brandRed.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.mark_email_read_outlined,
                            color: brandRed,
                            size: 55,
                          ),
                        ),

                        const SizedBox(height: 45),

                        SizedBox(
                          width: double.infinity,
                          height: 92,

                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: brandRed,
                              elevation: 0,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),

                            child: const Text(
                              'Back to Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        TextButton(
                          onPressed: () {
                            setState(() {
                              linkSent = false;
                            });
                          },
                          child: const Text(
                            'Resend link',
                            style: TextStyle(
                              color: subtitleBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}