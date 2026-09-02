import 'package:flutter/material.dart';
import 'settings_privacy.dart';
import 'help_center_screen.dart';
import 'ai_mentor_style_screen.dart';
import 'subject_focus_screen.dart';
import 'subscription_screen.dart';
// --- ADDING MISSING IMPORTS ---
import 'personal_info_screen.dart';
import 'password_screen.dart';
import 'ai_data_usage_screen.dart';
import 'privacy_policy_screen.dart';
import '../learning/student_dashboard.dart';

class SettingsProfile extends StatefulWidget {
  const SettingsProfile({super.key});

  @override
  State<SettingsProfile> createState() => _SettingsProfileState();
}

class _SettingsProfileState extends State<SettingsProfile> {
  bool dailyReminders = true;
  bool emotionalSupport = true;
  bool parentalSync = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
                    //================ HEADER =================
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalInfoScreen())),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 26),
                        decoration: const BoxDecoration(color: Color(0xFFFFD52E)),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPrivacy())),
                                child: Container(
                                  width: 34, height: 34,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF57B97A),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFF1F355C), width: 1.5),
                                  ),
                                  child: const Icon(Icons.edit, size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: 92, height: 92,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3D3D3D),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF1F355C), width: 2),
                              ),
                              child: const Center(
                                child: Text("learning\nschool", textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 11, fontStyle: FontStyle.italic)),
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text("Arjun Sharma", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1F355C))),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF1F355C), width: 1.5)),
                              child: const Text("Grade 10 • CBSE", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1F355C))),
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
                          Expanded(child: _StatBox(value: "84%", label: "Mastery", valueColor: const Color(0xFFE94A56))),
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
                          _NavRow(icon: Icons.school, iconColor: const Color(0xFF58C7F3), title: "AI Mentor Style", subtitle: "Currently: Encouraging & Visual", 
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AiMentorStyleScreen()))),
                          const SizedBox(height: 12),
                          _NavRow(icon: Icons.psychology_outlined, iconColor: const Color(0xFFE94A56), title: "Subject Focus", subtitle: "Math, Physics, Career Prep", 
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SubjectFocusScreen()))),
                          
                          const SizedBox(height: 24),

                          const _SectionLabel("App Preferences"),
                          const SizedBox(height: 10),
                          _NavRow(icon: Icons.data_usage, iconColor: Colors.blueGrey, title: "AI Data Usage", subtitle: "Manage your AI learning history", 
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AiDataUsageScreen()))),
                          const SizedBox(height: 12),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1F355C), width: 2)),
                            child: Column(
                              children: [
                                _InlineToggle(title: "Daily Study Reminders", value: dailyReminders, onChanged: (val) => setState(() => dailyReminders = val)),
                                const Divider(height: 1, color: Color(0xFFEFEFEF)),
                                _InlineToggle(title: "Emotional Support Mode", value: emotionalSupport, onChanged: (val) => setState(() => emotionalSupport = val)),
                                const Divider(height: 1, color: Color(0xFFEFEFEF)),
                                _InlineToggle(title: "Parental Dashboard Sync", value: parentalSync, onChanged: (val) => setState(() => parentalSync = val)),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          const _SectionLabel("Account & Support"),
                          const SizedBox(height: 10),
                          _NavRow(icon: Icons.lock_outline, iconColor: const Color(0xFF14213D), title: "Password & Security", subtitle: "Update your login credentials", 
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PasswordScreen()))),
                          const SizedBox(height: 12),
                          _NavRow(icon: Icons.help_outline, iconColor: const Color(0xFF57B97A), title: "Help Center", subtitle: "FAQ and AI Support Chat", 
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpCenterScreen()))),
                          const SizedBox(height: 12),
                          _NavRow(icon: Icons.credit_card, iconColor: const Color(0xFFF7C948), iconOnLight: true, title: "Subscription", subtitle: "EduVerse AI Pro Plan", 
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionScreen()))),
                          const SizedBox(height: 12),
                          _NavRow(icon: Icons.description_outlined, iconColor: Colors.purple, title: "Privacy Policy", subtitle: "Terms and conditions", 
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()))),

                          const SizedBox(height: 26),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const StudentDashboard(),
                                  ),
                                  (route) => false,
                                );
                              },
                              icon: const Icon(Icons.logout, size: 18, color: Colors.white),
                              label: const Text("Sign Out", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE94A56), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
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
// HELPER CLASSES (FIXES ERRORS)
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
        border: Border.all(color: const Color(0xFF1F355C), width: highlighted ? 3 : 2),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF5E6D7A))),
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
    return Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F355C)));
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final bool iconOnLight;
  final String title, subtitle;
  final VoidCallback onTap;

  const _NavRow({required this.icon, required this.iconColor, this.iconOnLight = false, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1F355C), width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconOnLight ? const Color(0xFF1F355C) : Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1F355C))),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF1F355C)),
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
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F355C))),
          Switch(value: value, onChanged: onChanged, activeColor: Colors.white, activeTrackColor: const Color(0xFFE94A56)),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  const _BottomNavItem({required this.icon, required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFFE94A56) : const Color(0xFF9AA5B1);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}