import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'success_page.dart';

class OtpVerificationPage extends StatefulWidget {
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
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
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

  final List<FocusNode> otpFocusNodes =
      List.generate(6, (_) => FocusNode());

  final SupabaseClient _supabase = Supabase.instance.client;

  bool isVerifying = false;
  bool isResending = false;

  @override
  void dispose() {
    for (final controller in otpControllers) {
      controller.dispose();
    }
    for (final node in otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // =========================
  // VERIFY OTP & RENDER TO SUCCESS PAGE
  // =========================
  Future<void> _verifyOtp() async {
    final otp = otpControllers
        .map((controller) => controller.text.trim())
        .join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all 6 digits'),
        ),
      );
      return;
    }

    setState(() {
      isVerifying = true;
    });

    try {
      // 1. Verify the real email OTP in Supabase
      final AuthResponse response = await _supabase.auth.verifyOTP(
        email: widget.email,
        token: otp,
        type: OtpType.email,
      );

      final User? user = response.user ?? _supabase.auth.currentUser;

      if (user == null) {
        throw const AuthException(
          'OTP verification failed. Please check the code and try again.',
        );
      }

      // 2. Safely save / upsert the user profile with their selected role
      try {
        await _supabase.from('profiles').upsert({
          'id': user.id,
          'email': widget.email,
          'role': widget.role,
        });
      } catch (e) {
        debugPrint('Profile update skipped: $e');
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Verification successful! Welcome to your ${widget.role} account.',
          ),
          backgroundColor: green,
          duration: const Duration(seconds: 3),
        ),
      );

      // 3. Navigate to SuccessPage with the exact selected role!
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessPage(role: widget.role),
        ),
        (route) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 4),
        ),
      );

      _clearOtp();
    } catch (e) {
      debugPrint('Verification error: $e');

      // If it's just a missing column like 'branch' or 'profiles', ignore it and CONTINUE to SuccessPage!
      if (e.toString().contains('column') ||
          e.toString().contains('profiles') ||
          e.toString().contains('branch') ||
          e.toString().contains('PGRST204')) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(role: widget.role),
          ),
          (route) => false,
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: $e'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 4),
          ),
        );
        _clearOtp();
      }
    } finally {
      if (mounted) {
        setState(() {
          isVerifying = false;
        });
      }
    }
  }

  // =========================
  // RESEND REAL EMAIL OTP
  // =========================
  Future<void> _resendOtp() async {
    if (isResending) return;

    setState(() {
      isResending = true;
    });

    try {
      await _supabase.auth.signInWithOtp(
        email: widget.email,
        shouldCreateUser: false,
      );

      if (!mounted) return;

      _clearOtp();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A new 6-digit OTP has been sent to your email.'),
          backgroundColor: green,
          duration: Duration(seconds: 4),
        ),
      );
    } on AuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not resend OTP: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isResending = false;
        });
      }
    }
  }

  void _clearOtp() {
    for (final controller in otpControllers) {
      controller.clear();
    }

    if (otpFocusNodes.isNotEmpty) {
      FocusScope.of(context).requestFocus(otpFocusNodes[0]);
    }
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(otpFocusNodes[index + 1]);
    }

    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(otpFocusNodes[index - 1]);
    }

    final otp = otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6 && !isVerifying) {
      _verifyOtp();
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
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: navy,
                    size: 28,
                  ),
                ),
              ),
            ),

            // =========================
            // MAIN CONTENT
            // =========================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Container(
                        width: 110,
                        height: 110,
                        decoration: const BoxDecoration(
                          color: green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mark_email_read_outlined,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Verify Your Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: navy,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Enter the 6-digit code sent to\n${widget.email}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: subtitleBlue,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // OTP BOXES
                      Row(
                        children: List.generate(6, (index) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: SizedBox(
                                height: 56,
                                child: TextField(
                                  controller: otpControllers[index],
                                  focusNode: otpFocusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  onChanged: (value) => _onOtpChanged(value, index),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    filled: true,
                                    fillColor: const Color(0xFFF8FAFB),
                                    contentPadding: EdgeInsets.zero,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE9EDF0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: brandRed,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 36),

                      // VERIFY BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isVerifying ? null : _verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandRed,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: isVerifying
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Verify',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // RESEND OTP
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Flexible(
                            child: Text(
                              "Didn't receive the code?",
                              style: TextStyle(
                                color: subtitleBlue,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: isResending ? null : _resendOtp,
                            child: isResending
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: brandRed,
                                    ),
                                  )
                                : const Text(
                                    'Resend OTP',
                                    style: TextStyle(
                                      color: brandRed,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'Secure verification powered by EduVerse AI',
                style: TextStyle(
                  color: navy,
                  fontSize: 14,
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