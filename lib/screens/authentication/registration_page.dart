import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';
import 'otp_verification_page.dart';
import 'success_page.dart';

class RegistrationPage extends StatefulWidget {
  final String role;

  const RegistrationPage({
    super.key,
    required this.role,
  });

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // =========================
  // COLORS
  // =========================

  static const Color navy = Color(0xFF1D3B64);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color hintColor = Color(0xFFA6DDE2);

  // =========================
  // GOOGLE OAUTH CLIENT ID
  // =========================
  static const String _webClientId =
      '562258769343-djt08qk2cg68p997l0j2lnhg8kovv81v.apps.googleusercontent.com';

  // =========================
  // ROLE HELPERS
  // =========================

  String get _role => widget.role.trim();

  bool get _isStudent => _role.toLowerCase().contains('student');
  bool get _isParent => _role.toLowerCase().contains('parent');
  bool get _isTeacher => _role.toLowerCase().contains('teacher');
  bool get _isSchool => _role.toLowerCase().contains('school');
  bool get _isAdministrator => _role.toLowerCase().contains('admin');

  // =========================
  // SHARED CONTROLLERS
  // =========================

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // =========================
  // ROLE-SPECIFIC CONTROLLERS
  // =========================

  final schoolNameController = TextEditingController();
  final uniqueCodeController = TextEditingController();
  final childCodeController = TextEditingController();

  DateTime? dateOfBirth;
  String? selectedBranch;

  static const List<String> branches = [
    'Computer Science',
    'AI & ML',
    'AI & DSS',
    'Information Technology',
    'ECE',
    'Data Science',
  ];

  // =========================
  // STATE
  // =========================

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool acceptedTerms = false;
  bool isSubmitting = false;

  final SupabaseClient _supabase = Supabase.instance.client;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSubscription = _supabase.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        final provider = session.user.appMetadata['provider'];
        if (provider == 'github' || provider == 'google') {
          try {
            await _supabase.auth.updateUser(
              UserAttributes(
                data: {
                  'role': _role,
                  'full_name': nameController.text.trim().isNotEmpty 
                      ? nameController.text.trim() 
                      : (session.user.userMetadata?['full_name'] ?? ''),
                },
              ),
            );

            await _supabase.from('profiles').upsert({
              'id': session.user.id,
              'email': session.user.email,
              'full_name': nameController.text.trim().isNotEmpty 
                  ? nameController.text.trim() 
                  : (session.user.userMetadata?['full_name'] ?? ''),
              'role': _role,
            });
          } catch (_) {}

          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessPage(role: _role),
            ),
          );
        }
      }
    });
  }

  // =========================
  // DISPOSE
  // =========================

  @override
  void dispose() {
    _authSubscription?.cancel();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    schoolNameController.dispose();
    uniqueCodeController.dispose();
    childCodeController.dispose();

    super.dispose();
  }

  // =========================
  // TITLE & SUBTITLE
  // =========================

  String get _pageTitle {
    if (_isParent) return 'Join as a Parent';
    if (_isTeacher) return 'Join as Teacher';
    if (_isSchool) return 'Register Your School';
    if (_isAdministrator) return 'Admin Registration';
    return 'Join EduVerse AI';
  }

  String get _pageSubtitle {
    if (_isParent) {
      return 'Stay connected to your child\'s learning\njourney and progress.';
    }
    if (_isTeacher) {
      return 'Empower your students with your personal AI\nteaching assistant.';
    }
    if (_isSchool) {
      return 'Set up your school on EduVerse AI to manage\nteachers and students.';
    }
    if (_isAdministrator) {
      return 'Manage the platform with full administrative\naccess.';
    }
    return 'Empower your learning journey with your personal AI\nmentor.';
  }

  // ============================================================
  // GOOGLE LOGIN WITH SUPABASE
  // ============================================================

  Future<void> _googleLogin() async {
    setState(() => isSubmitting = true);

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: _webClientId,
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        setState(() => isSubmitting = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw const AuthException('Could not retrieve Google ID token.');
      }

      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (!mounted) return;

      if (response.user != null) {
        await _supabase.auth.updateUser(
          UserAttributes(
            data: {
              'full_name': googleUser.displayName ?? '',
              'role': _role,
            },
          ),
        );

        try {
          await _supabase.from('profiles').upsert({
            'id': response.user!.id,
            'email': response.user!.email,
            'full_name': googleUser.displayName ?? '',
            'role': _role,
          });
        } catch (_) {}

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(role: _role),
          ),
        );
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in error: $e'), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  // ============================================================
  // GITHUB LOGIN WITH SUPABASE
  // ============================================================

  Future<void> _githubLogin() async {
    setState(() => isSubmitting = true);

    try {
      final bool launched = await _supabase.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: 'io.supabase.eduverse://login-callback',
      );

      if (!launched) {
        throw const AuthException('Could not launch GitHub sign-in.');
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('GitHub sign-in error: $e'), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  // =========================
  // DATE OF BIRTH
  // =========================

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1970),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: brandRed,
              onPrimary: Colors.white,
              onSurface: navy,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => dateOfBirth = picked);
    }
  }

  String get _formattedDob {
    if (dateOfBirth == null) return '';
    final d = dateOfBirth!;
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  // =========================
  // VALIDATION
  // =========================

  String? _validateRoleFields() {
    final email = emailController.text.trim();

    if (email.isEmpty) return 'Please enter your email';
    if (!email.contains('@') || !email.contains('.')) return 'Please enter a valid email address';

    if (_isStudent) {
      if (nameController.text.trim().isEmpty) return 'Please enter your name';
      if (schoolNameController.text.trim().isEmpty) return 'Please enter your school/college name';
      if (dateOfBirth == null) return 'Please select your date of birth';
      if (selectedBranch == null) return 'Please select your branch';
    } else if (_isParent) {
      if (nameController.text.trim().isEmpty) return 'Please enter your name';
      if (childCodeController.text.trim().isEmpty) return "Please enter your child's student code";
    } else if (_isTeacher) {
      if (nameController.text.trim().isEmpty) return 'Please enter your name';
      if (uniqueCodeController.text.trim().isEmpty) return 'Please enter the unique code';
    } else if (_isSchool) {
      if (schoolNameController.text.trim().isEmpty) return 'Please enter school name';
      if (uniqueCodeController.text.trim().isEmpty) return 'Please enter the unique code';
    } else if (_isAdministrator) {
      if (uniqueCodeController.text.trim().isEmpty) return 'Please enter the platform unique code';
      if (nameController.text.trim().isEmpty) return 'Please enter your name';
    } else {
      if (nameController.text.trim().isEmpty) return 'Please enter your name';
    }

    return null;
  }

  // ============================================================
  // CREATE ACCOUNT -> ALWAYS SENDS OTP & ALWAYS OPENS OTP PAGE
  // ============================================================

  Future<void> _createAccount() async {
    final roleError = _validateRoleFields();
    if (roleError != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(roleError)));
      return;
    }

    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a password')));
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password must be at least 6 characters')));
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    if (!acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please accept the Terms and Privacy Policy')));
      return;
    }

    final email = emailController.text.trim().toLowerCase();

    final Map<String, dynamic> extraProfileData = {
      'full_name': nameController.text.trim(),
      'role': _role,
      if (_isStudent) ...{
        'school_name': schoolNameController.text.trim(),
        'date_of_birth': dateOfBirth?.toIso8601String(),
        'branch': selectedBranch,
      },
      if (_isParent) ...{
        'child_code': childCodeController.text.trim(),
      },
      if (_isTeacher) ...{
        'unique_code': uniqueCodeController.text.trim(),
      },
      if (_isSchool) ...{
        'school_name': schoolNameController.text.trim(),
        'unique_code': uniqueCodeController.text.trim(),
      },
      if (_isAdministrator) ...{
        'unique_code': uniqueCodeController.text.trim(),
      },
    };

    setState(() => isSubmitting = true);

    try {
      // 1. Sign up / initiate OTP with the user's metadata & role
      await _supabase.auth.signInWithOtp(
        email: email,
        shouldCreateUser: true,
        data: extraProfileData,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A 6-digit OTP has been sent to your email!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
        ),
      );

      // 2. ALWAYS NAVIGATE TO THE OTP VERIFICATION PAGE WITH THE EXACT ROLE!
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationPage(
            role: _role,
            email: email,
            profileData: extraProfileData,
          ),
        ),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration error: $e'), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

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
                const SizedBox(height: 35),
                Text(
                  _pageTitle,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _pageSubtitle,
                  style: const TextStyle(
                    color: subtitleBlue,
                    fontSize: 18,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 40),
                ..._buildRoleFields(),
                const SizedBox(height: 30),
                _buildLabel('Password'),
                const SizedBox(height: 10),
                _buildPasswordField(
                  controller: passwordController,
                  hintText: 'Create a strong password',
                  obscureText: obscurePassword,
                  onToggle: () => setState(() => obscurePassword = !obscurePassword),
                ),
                const SizedBox(height: 25),
                _buildLabel('Confirm Password'),
                const SizedBox(height: 10),
                _buildPasswordField(
                  controller: confirmPasswordController,
                  hintText: 'Repeat your password',
                  obscureText: obscureConfirmPassword,
                  onToggle: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Checkbox(
                      value: acceptedTerms,
                      activeColor: brandRed,
                      shape: const CircleBorder(),
                      onChanged: (value) => setState(() => acceptedTerms = value ?? false),
                    ),
                    const Expanded(
                      child: Text(
                        'I agree to the Terms and Privacy Policy',
                        style: TextStyle(color: navy, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : _createAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandRed,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                          )
                        : Text(
                            'Create $_role Account',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 35),
                Row(
                  children: const [
                    Expanded(child: Divider(color: Color(0xFFE5E7EB), thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text('OR', style: TextStyle(color: navy, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(child: Divider(color: Color(0xFFE5E7EB), thickness: 1)),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: _socialButton(
                        onTap: isSubmitting ? () {} : _googleLogin,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('G', style: TextStyle(color: Color(0xFF4285F4), fontSize: 30, fontWeight: FontWeight.bold)),
                            SizedBox(width: 10),
                            Text('Google', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _socialButton(
                        onTap: isSubmitting ? () {} : _githubLogin,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.code, color: navy, size: 26),
                            SizedBox(width: 10),
                            Text('GitHub', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?', style: TextStyle(color: subtitleBlue, fontSize: 16)),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text('Login', style: TextStyle(color: brandRed, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ROLE FIELDS
  // ============================================================

  List<Widget> _buildRoleFields() {
    if (_isStudent) {
      return [
        _buildLabel('Full Name'),
        const SizedBox(height: 8),
        _buildTextField(controller: nameController, hintText: 'Enter your full name', icon: Icons.person_outline),
        const SizedBox(height: 20),
        _buildLabel('Email Address'),
        const SizedBox(height: 8),
        _buildTextField(controller: emailController, hintText: 'email@example.com', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 20),
        _buildLabel('School / College Name'),
        const SizedBox(height: 8),
        _buildTextField(controller: schoolNameController, hintText: 'Enter your school or college name', icon: Icons.school_outlined),
        const SizedBox(height: 20),
        _buildLabel('Date of Birth'),
        const SizedBox(height: 8),
        _buildDateField(),
        const SizedBox(height: 20),
        _buildLabel('Branch'),
        const SizedBox(height: 8),
        _buildBranchDropdown(),
      ];
    }

    if (_isParent) {
      return [
        _buildLabel('Full Name'),
        const SizedBox(height: 8),
        _buildTextField(controller: nameController, hintText: 'Enter your full name', icon: Icons.person_outline),
        const SizedBox(height: 20),
        _buildLabel('Email Address'),
        const SizedBox(height: 8),
        _buildTextField(controller: emailController, hintText: 'email@example.com', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 20),
        _buildLabel("Child's Student Code"),
        const SizedBox(height: 8),
        _buildTextField(controller: childCodeController, hintText: "Enter your child's student code", icon: Icons.link),
      ];
    }

    if (_isTeacher) {
      return [
        _buildLabel('Teacher Name'),
        const SizedBox(height: 8),
        _buildTextField(controller: nameController, hintText: 'Enter your full name', icon: Icons.person_outline),
        const SizedBox(height: 20),
        _buildLabel('School Email'),
        const SizedBox(height: 8),
        _buildTextField(controller: emailController, hintText: 'you@school.edu', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 20),
        _buildLabel('Unique Code'),
        const SizedBox(height: 8),
        _buildTextField(controller: uniqueCodeController, hintText: 'Code provided by school', icon: Icons.vpn_key_outlined),
      ];
    }

    if (_isSchool) {
      return [
        _buildLabel('School Name'),
        const SizedBox(height: 8),
        _buildTextField(controller: schoolNameController, hintText: 'Enter school name', icon: Icons.account_balance_outlined),
        const SizedBox(height: 20),
        _buildLabel('School Email'),
        const SizedBox(height: 8),
        _buildTextField(controller: emailController, hintText: 'school@example.com', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 20),
        _buildLabel('Unique Code'),
        const SizedBox(height: 8),
        _buildTextField(controller: uniqueCodeController, hintText: 'Code provided by Administrator', icon: Icons.vpn_key_outlined),
      ];
    }

    if (_isAdministrator) {
      return [
        _buildLabel('Unique Code'),
        const SizedBox(height: 8),
        _buildTextField(controller: uniqueCodeController, hintText: 'Code provided by platform', icon: Icons.vpn_key_outlined),
        const SizedBox(height: 20),
        _buildLabel('Email Address'),
        const SizedBox(height: 8),
        _buildTextField(controller: emailController, hintText: 'you@company.com', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 20),
        _buildLabel('Full Name'),
        const SizedBox(height: 8),
        _buildTextField(controller: nameController, hintText: 'Enter your full name', icon: Icons.person_outline),
      ];
    }

    return [
      _buildLabel('Full Name'),
      const SizedBox(height: 8),
      _buildTextField(controller: nameController, hintText: 'Enter your full name', icon: Icons.person_outline),
      const SizedBox(height: 20),
      _buildLabel('Email Address'),
      const SizedBox(height: 8),
      _buildTextField(controller: emailController, hintText: 'email@example.com', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
    ];
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.w600));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: navy, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: hintColor, fontSize: 16),
        prefixIcon: Icon(icon, color: navy, size: 24),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: navy, width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: brandRed, width: 2)),
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: _pickDateOfBirth,
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(text: _formattedDob),
          style: const TextStyle(color: navy, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'DD/MM/YYYY',
            hintStyle: const TextStyle(color: hintColor, fontSize: 16),
            prefixIcon: const Icon(Icons.cake_outlined, color: navy, size: 24),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: navy, width: 1.5)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: brandRed, width: 2)),
          ),
        ),
      ),
    );
  }

  Widget _buildBranchDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedBranch,
      icon: const Icon(Icons.keyboard_arrow_down, color: navy),
      style: const TextStyle(color: navy, fontSize: 16),
      decoration: InputDecoration(
        hintText: 'Select your branch',
        hintStyle: const TextStyle(color: hintColor, fontSize: 16),
        prefixIcon: const Icon(Icons.menu_book_outlined, color: navy, size: 24),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: navy, width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: brandRed, width: 2)),
      ),
      items: branches
          .map((branch) => DropdownMenuItem<String>(value: branch, child: Text(branch)))
          .toList(),
      onChanged: (value) => setState(() => selectedBranch = value),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: navy, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: hintColor, fontSize: 16),
        prefixIcon: const Icon(Icons.lock_outline, color: navy, size: 24),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: navy, size: 24),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: navy, width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: brandRed, width: 2)),
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