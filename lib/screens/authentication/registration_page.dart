import 'package:flutter/material.dart';
import 'login_page.dart';
import 'otp_verification_page.dart';

class RegistrationPage extends StatefulWidget {
  // ================= ROLE ADDED HERE =================
  final String role;

  const RegistrationPage({super.key, required this.role});

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
  // ROLE HELPERS
  // =========================
  // Matches roles.title strings in role_selection_page.dart:
  // "Student", "Parent", "Teacher", "School", "Administrator"

  String get _role => widget.role;

  bool get _isStudent => _role.toLowerCase() == 'student';
  bool get _isParent => _role.toLowerCase() == 'parent';
  bool get _isTeacher => _role.toLowerCase() == 'teacher';
  bool get _isSchool => _role.toLowerCase() == 'school';
  bool get _isAdministrator => _role.toLowerCase() == 'administrator';

  // =========================
  // CONTROLLERS (shared)
  // =========================

  final nameController = TextEditingController(); // Student / Parent / Teacher / Administrator name
  final emailController = TextEditingController(); // Email / School email / Teacher email / Platform email
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // =========================
  // CONTROLLERS (role-specific)
  // =========================

  final schoolNameController = TextEditingController(); // Student + School
  final uniqueCodeController = TextEditingController(); // School + Teacher + Administrator
  final childCodeController = TextEditingController(); // Parent only — links to their child's student code

  DateTime? dateOfBirth; // Student only
  String? selectedBranch; // Student only

  static const List<String> branches = [
    'Computer Science',
    'AI & ML',
    'Information Technology',
    'ECE',
    'Data Science',
  ];

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool acceptedTerms = false;

  @override
  void dispose() {
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
  // TITLE / SUBTITLE PER ROLE
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

  // =========================
  // GOOGLE LOGIN
  // =========================

  void _googleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google sign-up selected'),
      ),
    );
  }

  // =========================
  // GITHUB LOGIN
  // =========================

  void _githubLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('GitHub sign-up selected'),
      ),
    );
  }

  // =========================
  // DATE OF BIRTH PICKER
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
      setState(() {
        dateOfBirth = picked;
      });
    }
  }

  String get _formattedDob {
    if (dateOfBirth == null) return '';
    final d = dateOfBirth!;
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  // =========================
  // VALIDATION PER ROLE
  // =========================

  String? _validateRoleFields() {
    if (_isStudent) {
      if (nameController.text.trim().isEmpty) return 'Please enter your name';
      if (emailController.text.trim().isEmpty) return 'Please enter your email';
      if (schoolNameController.text.trim().isEmpty) return 'Please enter your school/college name';
      if (dateOfBirth == null) return 'Please select your date of birth';
      if (selectedBranch == null) return 'Please select your branch';
    } else if (_isParent) {
      if (nameController.text.trim().isEmpty) return 'Please enter your name';
      if (emailController.text.trim().isEmpty) return 'Please enter your email';
      if (childCodeController.text.trim().isEmpty) return "Please enter your child's student code";
    } else if (_isTeacher) {
      if (nameController.text.trim().isEmpty) return 'Please enter your name';
      if (emailController.text.trim().isEmpty) return 'Please enter your school email';
      if (uniqueCodeController.text.trim().isEmpty) return 'Please enter the unique code';
    } else if (_isSchool) {
      if (schoolNameController.text.trim().isEmpty) return 'Please enter school name';
      if (emailController.text.trim().isEmpty) return 'Please enter school email';
      if (uniqueCodeController.text.trim().isEmpty) return 'Please enter the unique code';
    } else if (_isAdministrator) {
      if (uniqueCodeController.text.trim().isEmpty) return 'Please enter the platform unique code';
      if (emailController.text.trim().isEmpty) return 'Please enter your email';
      if (nameController.text.trim().isEmpty) return 'Please enter your name';
    }
    return null;
  }

  // =========================
  // CREATE ACCOUNT
  // =========================

  void _createAccount() {
    final roleError = _validateRoleFields();
    if (roleError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(roleError)),
      );
      return;
    }

    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a password')),
      );
      return;
    }

    if (!acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms and Privacy Policy'),
        ),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
        ),
      );
      return;
    }

    // Navigate to OTP Verification Page
    // ================= ROLE PASSED FORWARD HERE =================
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpVerificationPage(role: widget.role),
      ),
    );
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

                const SizedBox(height: 35),

                // =========================
                // TITLE
                // =========================

                Text(
                  _pageTitle,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 46,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 15),

                // =========================
                // SUBTITLE
                // =========================

                Text(
                  _pageSubtitle,
                  style: const TextStyle(
                    color: subtitleBlue,
                    fontSize: 24,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 65),

                // =========================
                // ROLE-SPECIFIC FIELDS
                // =========================

                ..._buildRoleFields(),

                const SizedBox(height: 40),

                // =========================
                // PASSWORD
                // =========================

                _buildLabel('Password'),

                const SizedBox(height: 12),

                _buildPasswordField(
                  controller: passwordController,
                  hintText: 'Create a strong password',
                  obscureText: obscurePassword,
                  onToggle: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),

                const SizedBox(height: 40),

                // =========================
                // CONFIRM PASSWORD
                // =========================

                _buildLabel('Confirm Password'),

                const SizedBox(height: 12),

                _buildPasswordField(
                  controller: confirmPasswordController,
                  hintText: 'Repeat your password',
                  obscureText: obscureConfirmPassword,
                  onToggle: () {
                    setState(() {
                      obscureConfirmPassword =
                          !obscureConfirmPassword;
                    });
                  },
                ),

                const SizedBox(height: 45),

                // =========================
                // TERMS CHECKBOX
                // =========================

                Row(
                  children: [

                    Checkbox(
                      value: acceptedTerms,
                      activeColor: brandRed,
                      shape: const CircleBorder(),
                      onChanged: (value) {
                        setState(() {
                          acceptedTerms = value ?? false;
                        });
                      },
                    ),

                    const Expanded(
                      child: Text(
                        'I agree to the Terms and Privacy Policy',
                        style: TextStyle(
                          color: navy,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // =========================
                // CREATE ACCOUNT BUTTON
                // =========================

                SizedBox(
                  width: double.infinity,
                  height: 92,

                  child: ElevatedButton(
                    onPressed: _createAccount,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandRed,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),

                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 55),

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
                          color: navy,
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

                const SizedBox(height: 45),

                // =========================
                // GOOGLE AND GITHUB BUTTONS
                // =========================

                Row(
                  children: [

                    Expanded(
                      child: _socialButton(
                        onTap: _googleLogin,

                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          children: const [

                            Text(
                              'G',
                              style: TextStyle(
                                color: Color(0xFF4285F4),
                                fontSize: 40,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(width: 15),

                            Text(
                              'Google',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: _socialButton(
                        onTap: _githubLogin,

                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          children: const [

                            Icon(
                              Icons.code,
                              color: navy,
                              size: 34,
                            ),

                            SizedBox(width: 15),

                            Text(
                              'GitHub',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // =========================
                // LOGIN LINK
                // =========================

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                    Flexible(
                      child: Text(
                        'Already have an account?',
                        style: const TextStyle(
                          color: subtitleBlue,
                          fontSize: 20,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(width: 10),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LoginPage(),
                          ),
                        );
                      },

                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: brandRed,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  // =========================
  // ROLE FIELD BUILDER
  // =========================
  // Student:        Name, Email, School Name, DOB, Branch
  // Parent:         Name, Email, Child's Student Code   [not in doc — added]
  // Teacher:        Name, School Email, Unique Code
  // School:         School Name, School Email, Unique Code
  // Administrator:  Unique Code, Platform Email, Name

  List<Widget> _buildRoleFields() {
    if (_isStudent) {
      return [
        _buildLabel('Full Name'),
        const SizedBox(height: 12),
        _buildTextField(
          controller: nameController,
          hintText: 'Enter your full name',
          icon: Icons.person_outline,
        ),

        const SizedBox(height: 40),

        _buildLabel('Email Address'),
        const SizedBox(height: 12),
        _buildTextField(
          controller: emailController,
          hintText: 'email@example.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 40),

        _buildLabel('School / College Name'),
        const SizedBox(height: 12),
        _buildTextField(
          controller: schoolNameController,
          hintText: 'Enter your school or college name',
          icon: Icons.school_outlined,
        ),

        const SizedBox(height: 40),

        _buildLabel('Date of Birth'),
        const SizedBox(height: 12),
        _buildDateField(),

        const SizedBox(height: 40),

        _buildLabel('Branch'),
        const SizedBox(height: 12),
        _buildBranchDropdown(),
      ];
    }

    if (_isParent) {
      return [
        _buildLabel('Full Name'),
        const SizedBox(height: 12),
        _buildTextField(
          controller: nameController,
          hintText: 'Enter your full name',
          icon: Icons.person_outline,
        ),

        const SizedBox(height: 40),

        _buildLabel('Email Address'),
        const SizedBox(height: 12),
        _buildTextField(
          controller: emailController,
          hintText: 'email@example.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 40),

        _buildLabel("Child's Student Code"),
        const SizedBox(height: 12),
        _buildTextField(
          controller: childCodeController,
          hintText: "Enter your child's student code",
          icon: Icons.link,
        ),
      ];
    }

    if (_isTeacher) {
      return [
        _buildLabel('Teacher Name'),
        const SizedBox(height: 12),
        _buildTextField(
          controller: nameController,
          hintText: 'Enter your full name',
          icon: Icons.person_outline,
        ),

        const SizedBox(height: 40),

        _buildLabel('School Email'),
        const SizedBox(height: 12),
        _buildTextField(
          controller: emailController,
          hintText: 'you@school.edu',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 40),

        _buildLabel('Unique Code'),
        const SizedBox(height: 12),
        _buildTextField(
          controller: uniqueCodeController,
          hintText: 'Code provided by school',
          icon: Icons.vpn_key_outlined,
        ),
      ];
    }

    if (_isSchool) {
      return [
        _buildLabel('School Name'),
        const SizedBox(height: 12),
        _buildTextField(
          controller: schoolNameController,
          hintText: 'Enter school name',
          icon: Icons.account_balance_outlined,
        ),

        const SizedBox(height: 40),

        _buildLabel('School Email'),
        const SizedBox(height: 12),
        _buildTextField(
          controller: emailController,
          hintText: 'school@example.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 40),

        _buildLabel('Unique Code'),
        const SizedBox(height: 12),
        _buildTextField(
          controller: uniqueCodeController,
          hintText: 'Code provided by Administrator',
          icon: Icons.vpn_key_outlined,
        ),
      ];
    }

    if (_isAdministrator) {
      return [
        _buildLabel('Unique Code'),
        const SizedBox(height: 12),
        _buildTextField(
          controller: uniqueCodeController,
          hintText: 'Code provided by platform',
          icon: Icons.vpn_key_outlined,
        ),

        const SizedBox(height: 40),

        _buildLabel('Email Address'),
        const SizedBox(height: 12),
        _buildTextField(
          controller: emailController,
          hintText: 'you@company.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 40),

        _buildLabel('Full Name'),
        const SizedBox(height: 12),
        _buildTextField(
          controller: nameController,
          hintText: 'Enter your full name',
          icon: Icons.person_outline,
        ),
      ];
    }

    // Fallback (role not recognized) — behaves like Student form.
    return [
      _buildLabel('Full Name'),
      const SizedBox(height: 12),
      _buildTextField(
        controller: nameController,
        hintText: 'Enter your full name',
        icon: Icons.person_outline,
      ),

      const SizedBox(height: 40),

      _buildLabel('Email Address'),
      const SizedBox(height: 12),
      _buildTextField(
        controller: emailController,
        hintText: 'email@example.com',
        icon: Icons.email_outlined,
        keyboardType: TextInputType.emailAddress,
      ),
    ];
  }

  // =========================
  // LABEL
  // =========================

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: navy,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // =========================
  // NORMAL TEXT FIELD
  // =========================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,

      style: const TextStyle(
        color: navy,
        fontSize: 20,
      ),

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: const TextStyle(
          color: hintColor,
          fontSize: 22,
        ),

        prefixIcon: Icon(
          icon,
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
    );
  }

  // =========================
  // DATE OF BIRTH FIELD
  // =========================

  Widget _buildDateField() {
    return GestureDetector(
      onTap: _pickDateOfBirth,
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(text: _formattedDob),
          style: const TextStyle(
            color: navy,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            hintText: 'DD/MM/YYYY',
            hintStyle: const TextStyle(
              color: hintColor,
              fontSize: 22,
            ),
            prefixIcon: const Icon(
              Icons.cake_outlined,
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
      ),
    );
  }

  // =========================
  // BRANCH DROPDOWN
  // =========================

  Widget _buildBranchDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedBranch,
      icon: const Icon(Icons.keyboard_arrow_down, color: navy),
      style: const TextStyle(
        color: navy,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        hintText: 'Select your branch',
        hintStyle: const TextStyle(
          color: hintColor,
          fontSize: 22,
        ),
        prefixIcon: const Icon(
          Icons.menu_book_outlined,
          color: navy,
          size: 30,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
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
      items: branches
          .map(
            (branch) => DropdownMenuItem(
              value: branch,
              child: Text(branch),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedBranch = value;
        });
      },
    );
  }

  // =========================
  // PASSWORD FIELD
  // =========================

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,

      style: const TextStyle(
        color: navy,
        fontSize: 20,
      ),

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: const TextStyle(
          color: hintColor,
          fontSize: 22,
        ),

        prefixIcon: const Icon(
          Icons.lock_outline,
          color: navy,
          size: 30,
        ),

        suffixIcon: IconButton(
          onPressed: onToggle,

          icon: Icon(
            obscureText
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
        height: 100,

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(25),

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