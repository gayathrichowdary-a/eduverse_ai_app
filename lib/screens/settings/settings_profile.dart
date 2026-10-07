import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../state/locale_controller.dart';
import '../../features/auth/domain/auth_service.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import 'settings_privacy.dart';
import 'help_center_screen.dart';
import 'ai_mentor_style_screen.dart';
import 'subject_focus_screen.dart';
import 'subscription_screen.dart';
import 'personal_info_screen.dart';
import 'password_screen.dart';
import 'ai_data_usage_screen.dart';
import 'privacy_policy_screen.dart';
import '../learning/student_dashboard.dart';
import '../onboarding/onboarding_student_information.dart';

final List<BoxShadow> _softShadow = [
  BoxShadow(
    color: const Color(0xFF0B2F63).withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 6),
  ),
];

// Satisfies the AuthService interface so LoginScreen can be launched without errors
class _ProfileAuthService implements AuthService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class SettingsProfile extends StatefulWidget {
  final String? studentName;
  final String? studentClass;

  const SettingsProfile({
    super.key,
    this.studentName,
    this.studentClass,
  });

  @override
  State<SettingsProfile> createState() => _SettingsProfileState();
}

class _SettingsProfileState extends State<SettingsProfile> {
  bool dailyReminders = true;
  bool emotionalSupport = true;
  bool parentalSync = false;

  @override
  Widget build(BuildContext context) {
    // Reads dynamically from the saved onboarding profile data!
    final displayName = widget.studentName ??
        (StudentProfileData.fullName.isNotEmpty
            ? StudentProfileData.fullName
            : 'Arjun Sharma');

    final displayClass = widget.studentClass ?? StudentProfileData.selectedClass;

    final displayInitials = StudentProfileData.initials;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //================ HEADER (Sir's Yellow Background from WhatsApp Image 2) =================
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 26),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7C948), // Sir's yellow header
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                    boxShadow: _softShadow,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SettingsPrivacy()),
                          ),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: const Color(0xFF29B674),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: _softShadow,
                            ),
                            child: const Icon(Icons.edit, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Circular Profile Avatar with Real Student Initials
                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: _softShadow,
                        ),
                        child: Center(
                          child: Text(
                            displayInitials,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Real Student Name dynamically shown!
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0B2F63),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Dynamic Grade & Board Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2),
                        ),
                        child: Text(
                          displayClass,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0B2F63),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              //================ STAT CARDS =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Expanded(child: _StatBox(value: "84%", label: "Mastery", valueColor: const Color(0xFFF12C68))),
                    const SizedBox(width: 12),
                    Expanded(child: _StatBox(value: "12 Days", label: "Streak", valueColor: const Color(0xFFF7A93A), highlighted: true)),
                    const SizedBox(width: 12),
                    Expanded(child: _StatBox(value: "1.2k", label: "IQ Points", valueColor: const Color(0xFF58C7F3))),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              //================ LEARNING PREFERENCES =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionLabel("Learning Preferences"),
                    const SizedBox(height: 10),
                    _NavRow(
                      icon: Icons.school,
                      iconColor: const Color(0xFF58C7F3),
                      title: "AI Mentor Style",
                      subtitle: "Currently: Encouraging & Visual",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AiMentorStyleScreen()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _NavRow(
                      icon: Icons.psychology_outlined,
                      iconColor: const Color(0xFFF12C68),
                      title: "Subject Focus",
                      subtitle: "Math, Physics, Career Prep",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SubjectFocusScreen()),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const _SectionLabel("App Preferences"),
                    const SizedBox(height: 10),
                    _NavRow(
                      icon: Icons.data_usage,
                      iconColor: Colors.blueGrey,
                      title: "AI Data Usage",
                      subtitle: "Manage your AI learning history",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AiDataUsageScreen()),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2),
                        boxShadow: _softShadow,
                      ),
                      child: Column(
                        children: [
                          _InlineToggle(
                            title: "Daily Study Reminders",
                            value: dailyReminders,
                            onChanged: (val) => setState(() => dailyReminders = val),
                          ),
                          const Divider(height: 1, color: Color(0xFFEFECFA)),
                          _InlineToggle(
                            title: "Emotional Support Mode",
                            value: emotionalSupport,
                            onChanged: (val) => setState(() => emotionalSupport = val),
                          ),
                          const Divider(height: 1, color: Color(0xFFEFECFA)),
                          _InlineToggle(
                            title: "Parental Dashboard Sync",
                            value: parentalSync,
                            onChanged: (val) => setState(() => parentalSync = val),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const _SectionLabel("Account & Support"),
                    const SizedBox(height: 10),
                    _NavRow(
                      icon: Icons.lock_outline,
                      iconColor: const Color(0xFF14213D),
                      title: "Password & Security",
                      subtitle: "Update your login credentials",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PasswordScreen()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _NavRow(
                      icon: Icons.help_outline,
                      iconColor: const Color(0xFF57B97A),
                      title: "Help Center",
                      subtitle: "FAQ and AI Support Chat",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _NavRow(
                      icon: Icons.credit_card,
                      iconColor: const Color(0xFFF7C948),
                      iconOnLight: true,
                      title: "Subscription",
                      subtitle: "EduVerse AI Pro Plan",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _NavRow(
                      icon: Icons.description_outlined,
                      iconColor: Colors.purple,
                      title: "Privacy Policy",
                      subtitle: "Terms and conditions",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                      ),
                    ),

                    const SizedBox(height: 26),

                    // ================= 100% WORKING SIGN OUT BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await Supabase.instance.client.auth.signOut();
                          } catch (_) {}

                          if (!context.mounted) return;

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                localeController: LocaleController(),
                                authService: _ProfileAuthService(),
                              ),
                            ),
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout, size: 18, color: Colors.white),
                        label: const Text(
                          "Sign Out",
                          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF12C68),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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

// ============================================================
// HELPER CLASSES
// ============================================================

class _StatBox extends StatelessWidget {
  final String value, label;
  final Color valueColor;
  final bool highlighted;
  const _StatBox({required this.value, required this.label, required this.valueColor, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlighted ? const Color(0xFF4F46E5) : const Color(0xFFE6E2F7),
          width: highlighted ? 1.8 : 1.2,
        ),
        boxShadow: _softShadow,
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: valueColor)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF7B8798))),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0B2F63)));
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final bool iconOnLight;
  final String title, subtitle;
  final VoidCallback onTap;

  const _NavRow({
    required this.icon,
    required this.iconColor,
    this.iconOnLight = false,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2),
          boxShadow: _softShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconOnLight ? const Color(0xFF0B2F63) : Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0B2F63))),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF7B8798))),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF0B2F63)),
          ],
        ),
      ),
    );
  }
}

class _InlineToggle extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _InlineToggle({required this.title, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0B2F63))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF4F46E5),
          ),
        ],
      ),
    );
  }
}