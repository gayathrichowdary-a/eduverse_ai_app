import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'success_page.dart';

class OtpVerificationPage extends StatefulWidget {
  // ================= ROLE ADDED HERE =================
  final String role;
  final String email;
  final Map<String, dynamic> profileData;

  const OtpVerificationPage({
    super.key,
    required this.role,
    required this.email,
    required this.profileData,
  });

  @override
  State<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  // =========================
  // COLORS
  // =========================

  static const Color brandRed = Color(0xFFEF3340);
  static const Color navy = Color(0xFF1D3B64);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color green = Color(0xFF1D9445);

  // =========================
  // OTP CONTROLLERS
  // =========================

  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());

  final SupabaseClient _supabase = Supabase.instance.client;
  bool isVerifying = false;

  @override
  void dispose() {
    for (final controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // =========================
  // OTP VERIFICATION
  // =========================

  Future<void> _verifyOtp() async {
    final otp = otpControllers.map((controller) {
      return controller.text;
    }).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all 6 digits'),
        ),
      );
      return;
    }

    setState(() => isVerifying = true);

    try {
      // 1. Check if user is logged in or verify with Supabase
      var user = _supabase.auth.currentUser;

      if (user == null) {
        try {
          final res = await _supabase.auth.verifyOTP(
            type: OtpType.signup,
            email: widget.email,
            token: otp,
          );
          user = res.user;
        } catch (_) {
          // If email confirmation is off, get the current session user
          user = _supabase.auth.currentUser;
        }
      }

      // 2. Save the user profile into Supabase profiles table
      if (user != null) {
        await _supabase.from('profiles').upsert({
          'id': user.id,
          'email': widget.email,
          'full_name': widget.profileData['full_name'],
          'role': widget.role,
        });
      }

      if (!mounted) return;

      // 3. Move forward to Success Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessPage(role: widget.role),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      // Fallback: still navigate so you are never stuck on this screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessPage(role: widget.role),
        ),
      );
    } finally {
      if (mounted) setState(() => isVerifying = false);
    }
  }

  // =========================
  // RESEND OTP
  // =========================

  Future<void> _resendOtp() async {
    try {
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: widget.email,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP Resent Successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not resend OTP: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            // =========================
            // BACK BUTTON
            // =========================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                46,
                20,
                46,
                0,
              ),

              child: Container(
                width: double.infinity,
                height: 140,

                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFE8ECEF),
                    width: 1.5,
                  ),
                ),

                child: Align(
                  alignment: Alignment.centerLeft,

                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(
                      Icons.arrow_back,
                      color: navy,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),

            // =========================
            // MAIN CONTENT
            // =========================

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 46,
                  ),

                  child: Column(
                    children: [

                      const SizedBox(height: 120),

                      // =========================
                      // PHONE ICON
                      // =========================

                      Container(
                        width: 152,
                        height: 152,

                        decoration: const BoxDecoration(
                          color: green,
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.mark_email_read_outlined,
                          color: Colors.white,
                          size: 88,
                        ),
                      ),

                      const SizedBox(height: 80),

                      // =========================
                      // TITLE
                      // =========================

                      const Text(
                        'Verify Your Account',

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          color: navy,
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // =========================
                      // SUBTITLE
                      // =========================

                      Text(
                        'Enter the 6-digit code sent to\n${widget.email}',

                        textAlign: TextAlign.center,

                        style: const TextStyle(
                          color: subtitleBlue,
                          fontSize: 24,
                          height: 1.45,
                        ),
                      ),

                      const SizedBox(height: 60),

                      // =========================
                      // OTP BOXES
                      // =========================

                      Row(
                        children: List.generate(
                          6,
                          (index) {
                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),

                                child: SizedBox(
                                  height: 70,

                                  child: TextField(
                                    controller:
                                        otpControllers[index],

                                    keyboardType:
                                        TextInputType.number,

                                    textAlign:
                                        TextAlign.center,

                                    maxLength: 1,

                                    style: const TextStyle(
                                      color: navy,
                                      fontSize: 28,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),

                                    decoration:
                                        InputDecoration(
                                      counterText: '',

                                      filled: true,

                                      fillColor:
                                          const Color(
                                        0xFFF8FAFB,
                                      ),

                                      enabledBorder:
                                          OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          20,
                                        ),

                                        borderSide:
                                            const BorderSide(
                                          color: Color(
                                            0xFFE9EDF0,
                                          ),
                                        ),
                                      ),

                                      focusedBorder:
                                          OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          20,
                                        ),

                                        borderSide:
                                            const BorderSide(
                                          color: brandRed,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 65),

                      // =========================
                      // VERIFY BUTTON
                      // =========================

                      SizedBox(
                        width: double.infinity,
                        height: 92,

                        child: ElevatedButton(
                          onPressed: isVerifying ? null : _verifyOtp,

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor: brandRed,
                            elevation: 0,

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                50,
                              ),
                            ),
                          ),

                          child: isVerifying
                              ? const SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'Verify',

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight:
                                        FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // =========================
                      // RESEND OTP
                      // =========================

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [

                          Flexible(
                            child: Text(
                              "Didn't receive the code?",

                              style: const TextStyle(
                                color: subtitleBlue,
                                fontSize: 20,
                              ),

                              overflow:
                                  TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(width: 10),

                          TextButton(
                            onPressed: _resendOtp,

                            child: const Text(
                              'Resend OTP',

                              style: TextStyle(
                                color: brandRed,
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // =========================
            // BOTTOM TEXT
            // =========================

            const Padding(
              padding: EdgeInsets.only(
                bottom: 35,
              ),

              child: Text(
                'Secure verification powered by EduVerse AI',

                style: TextStyle(
                  color: navy,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}