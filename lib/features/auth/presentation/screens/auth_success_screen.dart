import 'package:flutter/material.dart';

import '../../../../screens/onboarding/onboarding_student_information.dart';
import '../../../../state/locale_controller.dart';
import '../../../../widgets/language_selector.dart';
import '../../domain/auth_models.dart';

class AuthSuccessScreen extends StatelessWidget {
  final AuthUser user;
  final LocaleController? localeController;

  const AuthSuccessScreen({
    super.key,
    required this.user,
    this.localeController,
  });

  void _proceedToRoleDestination(BuildContext context) {
    switch (user.role) {
      case UserRole.student:
        // 👉 Student goes to Onboarding Process
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const OnboardingStudentInformation(),
          ),
          (route) => false,
        );
        break;

      case UserRole.parent:
        // 👉 Parent goes to Parent Dashboard
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => _RoleDashboardPlaceholder(
              roleName: 'Parent',
              user: user,
              themeColor: const Color(0xFF12B76A),
              icon: Icons.family_restroom_rounded,
            ),
          ),
          (route) => false,
        );
        break;

      case UserRole.teacher:
        // 👉 Teacher goes to Teacher Dashboard
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => _RoleDashboardPlaceholder(
              roleName: 'Teacher',
              user: user,
              themeColor: const Color(0xFF0086C9),
              icon: Icons.cast_for_education_rounded,
            ),
          ),
          (route) => false,
        );
        break;

      case UserRole.school:
        // 👉 School goes to School Institution Dashboard
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => _RoleDashboardPlaceholder(
              roleName: 'School',
              user: user,
              themeColor: const Color(0xFF7F56D9),
              icon: Icons.apartment_rounded,
            ),
          ),
          (route) => false,
        );
        break;

      case UserRole.admin:
        // 👉 Admin goes to Admin Command Center
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => _RoleDashboardPlaceholder(
              roleName: 'Admin',
              user: user,
              themeColor: const Color(0xFFF79009),
              icon: Icons.admin_panel_settings_rounded,
            ),
          ),
          (route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = switch (user.role) {
      UserRole.student => 'Student',
      UserRole.parent => 'Parent',
      UserRole.teacher => 'Teacher',
      UserRole.school => 'School',
      UserRole.admin => 'Admin',
    };

    final buttonLabel = user.role == UserRole.student
        ? 'Start Student Onboarding ➔'
        : 'Proceed to $role Dashboard ➔';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    child: Padding(
                      padding: EdgeInsets.all(width < 500 ? 24 : 42),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text.rich(TextSpan(children: [
                                TextSpan(
                                    text: 'EduVerse',
                                    style: TextStyle(
                                        color: Color(0xFF12366D),
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900)),
                                TextSpan(
                                    text: ' AI',
                                    style: TextStyle(
                                        color: Color(0xFFF12C68),
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900)),
                              ])),
                              const Spacer(),
                              if (localeController != null)
                                LanguageSelector(
                                    controller: localeController!,
                                    compact: true),
                            ],
                          ),
                          const SizedBox(height: 45),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [
                                Color(0xFF5146D8),
                                Color(0xFFF12C68)
                              ]),
                            ),
                            child: const Icon(Icons.auto_awesome_rounded,
                                color: Colors.white, size: 48),
                          ),
                          const SizedBox(height: 22),
                          const Text('You’re in!',
                              style: TextStyle(
                                  color: Color(0xFF0B2F63),
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 10),
                          Text(
                            'Welcome ${user.name}. Your ${role.toLowerCase()} space is verified and ready for launch.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Color(0xFF68778F),
                                fontSize: 15,
                                height: 1.55),
                          ),
                          const SizedBox(height: 28),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F6FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.verified_user_outlined,
                                    color: Color(0xFF5146D8)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.identifier,
                                        style: const TextStyle(
                                            color: Color(0xFF334155),
                                            fontWeight: FontWeight.w800),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Verified Role: $role',
                                        style: const TextStyle(
                                            color: Color(0xFF5146D8),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 26),

                          // 👉 Primary Action Button: Takes user to Onboarding or their respective Dashboard!
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _proceedToRoleDestination(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1D3B64),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                buttonLabel,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.arrow_back_rounded,
                                  size: 18),
                              label: const Text('Back to Login'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF5146D8),
                                side: const BorderSide(
                                    color: Color(0xFFCBC9F4)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Fallback role dashboard container for Parent/Teacher/School/Admin if custom screen is not yet linked
class _RoleDashboardPlaceholder extends StatelessWidget {
  final String roleName;
  final AuthUser user;
  final Color themeColor;
  final IconData icon;

  const _RoleDashboardPlaceholder({
    required this.roleName,
    required this.user,
    required this.themeColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '$roleName Space • EduVerse AI',
          style: const TextStyle(
              color: Color(0xFF1D3B64),
              fontSize: 17,
              fontWeight: FontWeight.w800),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: themeColor, size: 48),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome, ${user.name}!',
                style: const TextStyle(
                    color: Color(0xFF1D3B64),
                    fontSize: 24,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'You are successfully signed in as $roleName (${user.identifier})',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color(0xFF667085), fontSize: 14),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE4E7EC)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: Color(0xFF12B76A), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '$roleName Dashboard Live & Active',
                      style: const TextStyle(
                          color: Color(0xFF1D3B64),
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}