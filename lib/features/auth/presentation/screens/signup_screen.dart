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
import 'login_screen.dart';
import 'otp_verification_screen.dart';

class SignupScreen extends StatefulWidget {
  final LocaleController localeController;
  final AuthService authService;

  const SignupScreen({super.key, required this.localeController, required this.authService});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _c = {
    'name': TextEditingController(),
    'identifier': TextEditingController(),
    'phone': TextEditingController(),
    'school': TextEditingController(),
    'class': TextEditingController(),
    'section': TextEditingController(),
    'studentId': TextEditingController(),
    'parentName': TextEditingController(),
    'childName': TextEditingController(),
    'childClass': TextEditingController(),
    'employeeId': TextEditingController(),
    'subject': TextEditingController(),
    'schoolCode': TextEditingController(),
    'organization': TextEditingController(),
    'adminId': TextEditingController(),
    'password': TextEditingController(),
    'confirm': TextEditingController(),
  };

  UserRole _role = UserRole.student;
  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  bool _isGoogleSigningIn = false;
  bool _isGithubSigningIn = false;

  StreamSubscription<AuthState>? _authSubscription;

  TextEditingController get cName => _c['name']!;
  TextEditingController get cIdentifier => _c['identifier']!;
  TextEditingController get cPhone => _c['phone']!;
  TextEditingController get cSchool => _c['school']!;
  TextEditingController get cClass => _c['class']!;
  TextEditingController get cSection => _c['section']!;
  TextEditingController get cStudentId => _c['studentId']!;
  TextEditingController get cParentName => _c['parentName']!;
  TextEditingController get cChildName => _c['childName']!;
  TextEditingController get cChildClass => _c['childClass']!;
  TextEditingController get cEmployeeId => _c['employeeId']!;
  TextEditingController get cSubject => _c['subject']!;
  TextEditingController get cSchoolCode => _c['schoolCode']!;
  TextEditingController get cOrganization => _c['organization']!;
  TextEditingController get cAdminId => _c['adminId']!;
  TextEditingController get cPassword => _c['password']!;
  TextEditingController get cConfirm => _c['confirm']!;

  @override
  void initState() {
    super.initState();
    // Catch Google & GitHub redirects
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
        _navigateAfterOAuth();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    for (final controller in _c.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _navigateAfterOAuth() {
    if (!mounted) return;

    final user = Supabase.instance.client.auth.currentUser;
    final userEmail = user?.email ?? cIdentifier.text.trim();
    final displayName = (user?.userMetadata?['full_name'] as String?) ??
        (user?.userMetadata?['user_name'] as String?) ??
        (user?.userMetadata?['name'] as String?) ??
        (userEmail.isNotEmpty ? userEmail.split('@').first : 'User');

    try {
      Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'role': _role.name}),
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

  String _title() => switch (_role) {
        UserRole.student => 'Create your student account',
        UserRole.parent => 'Create your parent account',
        UserRole.teacher => 'Create your teacher account',
        UserRole.school => 'Register your school',
        UserRole.admin => 'Create an admin account',
      };

  String _subtitle() => switch (_role) {
        UserRole.student => 'Tell us about the learner so EduVerse can personalize classes, practice and progress.',
        UserRole.parent => 'Connect your child safely and receive learning progress, attendance and parent updates.',
        UserRole.teacher => 'Create your teaching profile to manage classes, assignments, assessments and student progress.',
        UserRole.school => 'Register your institution to manage teachers, students, classes, academics and school analytics.',
        UserRole.admin => 'Set up a platform administration account for controlled EduVerse management.',
      };

  InputDecoration _decoration(String label, String hint, IconData icon) => InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF8F9FC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE5E8F1))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE5E8F1))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF5B55E8), width: 1.5)),
      );

  Widget _field(TextEditingController controller, String label, String hint, IconData icon, {TextInputType? keyboard, String? Function(String?)? validator}) {
    return TextFormField(controller: controller, keyboardType: keyboard, decoration: _decoration(label, hint, icon), validator: validator ?? _required);
  }

  String? _required(String? value) => (value?.trim().isEmpty ?? true) ? 'Required' : null;
  String? _email(String? value) {
    if ((value?.trim().isEmpty ?? true)) return 'Required';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value!.trim())) return 'Enter a valid email';
    return null;
  }

  Widget _two(Widget a, Widget b, BoxConstraints constraints) {
    if (constraints.maxWidth < 560) return Column(children: [a, const SizedBox(height: 14), b]);
    return Row(children: [Expanded(child: a), const SizedBox(width: 14), Expanded(child: b)]);
  }

  List<Widget> _roleFields(BoxConstraints constraints) {
    final fields = <Widget>[];
    switch (_role) {
      case UserRole.student:
        fields.add(_field(cName, 'Student full name', 'e.g. Aarav Sharma', Icons.person_outline));
        fields.add(const SizedBox(height: 14));
        fields.add(_field(cIdentifier, 'Student email', 'student@school.com', Icons.mail_outline, keyboard: TextInputType.emailAddress, validator: _email));
        fields.add(const SizedBox(height: 14));
        fields.add(_two(_field(cPhone, 'Parent mobile', '10-digit mobile', Icons.phone_outlined, keyboard: TextInputType.phone), _field(cStudentId, 'Student ID', 'EVS-1024', Icons.badge_outlined), constraints));
        fields.add(const SizedBox(height: 14));
        fields.add(_two(_field(cSchool, 'School name', 'Your school', Icons.apartment_outlined), _field(cSchoolCode, 'School code', 'SCHOOL-1024', Icons.qr_code_2_rounded), constraints));
        fields.add(const SizedBox(height: 14));
        fields.add(_two(_field(cClass, 'Class', '1–12', Icons.menu_book_outlined), _field(cSection, 'Section', 'A', Icons.groups_2_outlined), constraints));
      case UserRole.parent:
        fields.add(_field(cName, 'Parent / Guardian name', 'Your full name', Icons.person_outline));
        fields.add(const SizedBox(height: 14));
        fields.add(_field(cIdentifier, 'Parent email', 'parent@email.com', Icons.mail_outline, keyboard: TextInputType.emailAddress, validator: _email));
        fields.add(const SizedBox(height: 14));
        fields.add(_two(_field(cPhone, 'Mobile number', '10-digit mobile', Icons.phone_outlined, keyboard: TextInputType.phone), _field(cChildName, 'Child name', 'Student full name', Icons.child_care_outlined), constraints));
        fields.add(const SizedBox(height: 14));
        fields.add(_two(_field(cSchoolCode, 'School code', 'SCHOOL-1024', Icons.qr_code_2_rounded), _field(cChildClass, 'Child class', '1–12', Icons.menu_book_outlined), constraints));
      case UserRole.teacher:
        fields.add(_field(cName, 'Teacher full name', 'Your full name', Icons.person_outline));
        fields.add(const SizedBox(height: 14));
        fields.add(_field(cIdentifier, 'Official school email', 'teacher@school.com', Icons.mail_outline, keyboard: TextInputType.emailAddress, validator: _email));
        fields.add(const SizedBox(height: 14));
        fields.add(_two(_field(cPhone, 'Mobile number', '10-digit mobile', Icons.phone_outlined, keyboard: TextInputType.phone), _field(cEmployeeId, 'Employee ID', 'EMP-1024', Icons.badge_outlined), constraints));
        fields.add(const SizedBox(height: 14));
        fields.add(_two(_field(cSchoolCode, 'School code', 'SCHOOL-1024', Icons.qr_code_2_rounded), _field(cSubject, 'Primary subject', 'Mathematics', Icons.auto_stories_outlined), constraints));
      case UserRole.school:
        fields.add(_field(cSchool, 'School / Institution name', 'e.g. EduVerse Public School', Icons.apartment_outlined));
        fields.add(const SizedBox(height: 14));
        fields.add(_field(cIdentifier, 'Official school email', 'school@domain.com', Icons.mail_outline, keyboard: TextInputType.emailAddress, validator: _email));
        fields.add(const SizedBox(height: 14));
        fields.add(_two(_field(cPhone, 'School contact number', 'Office mobile/landline', Icons.phone_outlined, keyboard: TextInputType.phone), _field(cSchoolCode, 'School code', 'SCHOOL-1024', Icons.qr_code_2_rounded), constraints));
        fields.add(const SizedBox(height: 14));
        fields.add(_field(cName, 'Authorized contact person', 'Principal / authorized representative', Icons.person_outline));
      case UserRole.admin:
        fields.add(_field(cName, 'Admin full name', 'Your full name', Icons.person_outline));
        fields.add(const SizedBox(height: 14));
        fields.add(_field(cIdentifier, 'Admin email', 'admin@eduverse.ai', Icons.mail_outline, keyboard: TextInputType.emailAddress, validator: _email));
        fields.add(const SizedBox(height: 14));
        fields.add(_two(_field(cOrganization, 'Organization', 'EduVerse / School group', Icons.business_center_outlined), _field(cAdminId, 'Admin ID / Invite code', 'ADM-1024', Icons.admin_panel_settings_outlined), constraints));
      }
    return fields;
  }

  Future<void> _createAccount() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    
    setState(() => _loading = true);

    try {
      final supabase = Supabase.instance.client;

      // 1. Create the user in Supabase Auth
      final authResponse = await supabase.auth.signUp(
        email: cIdentifier.text.trim(),
        password: cPassword.text,
        data: {
          'display_name': _role == UserRole.school ? cSchool.text.trim() : cName.text.trim(),
          'role': _role.name,
        },
      );

      final user = authResponse.user;
      if (user == null) {
        throw Exception('Signup failed: No user returned');
      }

      // 2. Save all details into your profiles table
      await supabase.from('profiles').upsert({
        'id': user.id,
        'email': cIdentifier.text.trim(),
        'parent_mobile': cPhone.text.trim(),
        'student_id': cStudentId.text.trim(),
        'school_name': cSchool.text.trim(),
        'school_code': cSchoolCode.text.trim(),
        'class': cClass.text.trim(),
        'section': cSection.text.trim(),
        'role': _role.name,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Please sign in.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate to Login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginScreen(
            localeController: widget.localeController,
            authService: widget.authService,
          ),
        ),
      );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
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
                ? 'Connecting Google...'
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
      eyebrow: 'CREATE • ${_role.key.toUpperCase()}',
      title: _title(),
      subtitle: _subtitle(),
      topAction: Row(mainAxisSize: MainAxisSize.min, children: [
        TextButton(onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen(localeController: widget.localeController, authService: widget.authService))), child: Text(s.signupTop)),
        LanguageSelector(controller: widget.localeController, compact: true),
      ]),
      child: LayoutBuilder(builder: (context, constraints) {
        return Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.role, style: const TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w800, fontSize: 13)),
            const SizedBox(height: 10),
            RoleSelector(
              selected: _role,
              onChanged: (r) => setState(() => _role = r),
              labels: {UserRole.student: s.student, UserRole.parent: s.parent, UserRole.teacher: s.teacher, UserRole.school: s.school, UserRole.admin: s.admin},
            ),
            const SizedBox(height: 20),
            ..._roleFields(constraints),
            const SizedBox(height: 14),
            AuthField(
              controller: cPassword,
              label: s.password,
              hint: 'At least 8 characters',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscure,
              onVisibilityTap: () => setState(() => _obscure = !_obscure),
              textInputAction: TextInputAction.next,
              validator: (v) => (v?.length ?? 0) < 8 ? s.weakPassword : null,
            ),
            const SizedBox(height: 14),
            AuthField(
              controller: cConfirm,
              label: s.confirmPassword,
              hint: 'Re-enter your password',
              icon: Icons.verified_user_outlined,
              obscureText: _obscureConfirm,
              onVisibilityTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
              textInputAction: TextInputAction.done,
              validator: (v) => v != cPassword.text ? s.passwordMismatch : null,
            ),
            const SizedBox(height: 20),
            AuthButton(label: s.createAccount, onPressed: _createAccount, loading: _loading && !_isGoogleSigningIn && !_isGithubSigningIn),
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
            // Google Sign-In
            _googleSignInButton(),
            const SizedBox(height: 10),
            // GitHub Sign-In (Now clear and visible!)
            _githubSignInButton(),
            const SizedBox(height: 18),
            Center(child: AuthLink(prefix: s.alreadyAccount, action: s.signIn, onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen(localeController: widget.localeController, authService: widget.authService))))),
          ]),
        );
      }),
    );
  }
}