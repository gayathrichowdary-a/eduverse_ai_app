import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../onboarding/onboarding_student_information.dart';
import '../teacher/teacher_portal_hub.dart';
import '../parent/parent_home_dashboard.dart';
import '../admin/admin_dashboard.dart';
import '../school/school_dashboard.dart';

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
  State<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState
    extends State<OtpVerificationPage> {

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

  final SupabaseClient _supabase =
      Supabase.instance.client;

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
  // VERIFY OTP & RENDER TO PERSONAL PAGE
  // =========================

  Future<void> _verifyOtp() async {
    final otp = otpControllers
        .map((controller) => controller.text.trim())
        .join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter all 6 digits',
          ),
        ),
      );
      return;
    }

    setState(() {
      isVerifying = true;
    });

    try {
      // 1. Verify the real email OTP in Supabase
      final AuthResponse response =
          await _supabase.auth.verifyOTP(
        email: widget.email,
        token: otp,
        type: OtpType.email,
      );

      final User? user =
          response.user ?? _supabase.auth.currentUser;

      if (user == null) {
        throw const AuthException(
          'OTP verification failed. Please check the code and try again.',
        );
      }

      // 2. Save / Upsert the user profile with their selected role
      await _supabase.from('profiles').upsert({
        'id': user.id,
        'email': widget.email,
        'full_name': widget.profileData['full_name'] ?? '',
        'role': widget.role,
        ...widget.profileData,
      });

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

      // 3. Render directly to the user's dedicated screen based on their role!
      final String rawRole = (widget.role.trim().isNotEmpty 
              ? widget.role 
              : (widget.profileData['role'] ?? user.userMetadata?['role'] ?? ''))
          .toString()
          .toLowerCase()
          .trim();

      debugPrint('EduVerse Routing triggered with rawRole: "$rawRole"');

      Widget destination;

      if (rawRole.contains('teacher')) {
        destination = const TeacherPortalHub();
      } else if (rawRole.contains('parent')) {
        destination = const ParentHomeDashboard();
      } else if (rawRole.contains('school')) {
        destination = const SchoolDashboard();
      } else if (rawRole.contains('admin')) {
        destination = const AdminDashboard();
      } else {
        // ONLY genuine Students go to Onboarding!
        destination = const OnboardingStudentInformation();
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => destination,
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
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Verification failed: $e',
          ),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 4),
        ),
      );

      _clearOtp();
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
      // Resend the 6-digit OTP code to email
      await _supabase.auth.signInWithOtp(
        email: widget.email,
        shouldCreateUser: false,
      );

      if (!mounted) return;

      _clearOtp();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'A new 6-digit OTP has been sent to your email.',
          ),
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
          content: Text(
            'Could not resend OTP: $e',
          ),
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

  // =========================
  // CLEAR OTP
  // =========================

  void _clearOtp() {
    for (final controller in otpControllers) {
      controller.clear();
    }

    if (otpFocusNodes.isNotEmpty) {
      FocusScope.of(context)
          .requestFocus(otpFocusNodes[0]);
    }
  }

  // =========================
  // OTP BOX INPUT
  // =========================

  void _onOtpChanged(
    String value,
    int index,
  ) {
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(
        otpFocusNodes[index + 1],
      );
    }

    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(
        otpFocusNodes[index - 1],
      );
    }

    // Automatically verify when all 6 digits are entered
    final otp = otpControllers
        .map((controller) => controller.text)
        .join();

    if (otp.length == 6 && !isVerifying) {
      _verifyOtp();
    }
  }

  // =========================
  // UI
  // =========================

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
              padding:
                  const EdgeInsets.fromLTRB(
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
                    color:
                        const Color(0xFFE8ECEF),
                    width: 1.5,
                  ),
                ),

                child: Align(
                  alignment:
                      Alignment.centerLeft,

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
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 46,
                  ),

                  child: Column(
                    children: [

                      const SizedBox(
                        height: 120,
                      ),

                      // =========================
                      // EMAIL ICON
                      // =========================

                      Container(
                        width: 152,
                        height: 152,

                        decoration:
                            const BoxDecoration(
                          color: green,
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons
                              .mark_email_read_outlined,
                          color: Colors.white,
                          size: 88,
                        ),
                      ),

                      const SizedBox(
                        height: 80,
                      ),

                      // =========================
                      // TITLE
                      // =========================

                      const Text(
                        'Verify Your Account',

                        textAlign:
                            TextAlign.center,

                        style: TextStyle(
                          color: navy,
                          fontSize: 42,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      // =========================
                      // SUBTITLE
                      // =========================

                      Text(
                        'Enter the 6-digit code sent to\n${widget.email}',

                        textAlign:
                            TextAlign.center,

                        style:
                            const TextStyle(
                          color: subtitleBlue,
                          fontSize: 24,
                          height: 1.45,
                        ),
                      ),

                      const SizedBox(
                        height: 60,
                      ),

                      // =========================
                      // OTP BOXES
                      // =========================

                      Row(
                        children:
                            List.generate(
                          6,
                          (index) {
                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 4,
                                ),

                                child: SizedBox(
                                  height: 70,

                                  child:
                                      TextField(
                                    controller:
                                        otpControllers[
                                            index],

                                    focusNode:
                                        otpFocusNodes[
                                            index],

                                    keyboardType:
                                        TextInputType
                                            .number,

                                    textAlign:
                                        TextAlign.center,

                                    maxLength: 1,

                                    style:
                                        const TextStyle(
                                      color: navy,
                                      fontSize: 28,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),

                                    onChanged:
                                        (value) {
                                      _onOtpChanged(
                                        value,
                                        index,
                                      );
                                    },

                                    decoration:
                                        InputDecoration(
                                      counterText:
                                          '',

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
                                          color:
                                              brandRed,
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

                      const SizedBox(
                        height: 65,
                      ),

                      // =========================
                      // VERIFY BUTTON
                      // =========================

                      SizedBox(
                        width: double.infinity,
                        height: 92,

                        child:
                            ElevatedButton(
                          onPressed:
                              isVerifying
                                  ? null
                                  : _verifyOtp,

                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                brandRed,
                            elevation: 0,

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                50,
                              ),
                            ),
                          ),

                          child: isVerifying
                              ? const SizedBox(
                                  width: 26,
                                  height: 26,

                                  child:
                                      CircularProgressIndicator(
                                    color:
                                        Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'Verify',

                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white,
                                    fontSize: 24,
                                    fontWeight:
                                        FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(
                        height: 40,
                      ),

                      // =========================
                      // RESEND OTP
                      // =========================

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                        children: [

                          Flexible(
                            child: Text(
                              "Didn't receive the code?",

                              style:
                                  const TextStyle(
                                color:
                                    subtitleBlue,
                                fontSize: 20,
                              ),

                              overflow:
                                  TextOverflow
                                      .ellipsis,
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          TextButton(
                            onPressed:
                                isResending
                                    ? null
                                    : _resendOtp,

                            child: isResending
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,

                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth:
                                          2,
                                      color:
                                          brandRed,
                                    ),
                                  )
                                : const Text(
                                    'Resend OTP',

                                    style:
                                        TextStyle(
                                      color:
                                          brandRed,
                                      fontSize: 20,
                                      fontWeight:
                                          FontWeight
                                              .w600,
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
              padding:
                  EdgeInsets.only(
                bottom: 35,
              ),

              child: Text(
                'Secure verification powered by EduVerse AI',

                style: TextStyle(
                  color: navy,
                  fontSize: 20,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}