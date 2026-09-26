import 'package:flutter/material.dart';
import 'personal_info_screen.dart';
import 'password_screen.dart';
import 'ai_data_usage_screen.dart';
import 'help_center_screen.dart';
import 'privacy_policy_screen.dart';

class SettingsPrivacy extends StatefulWidget {
  const SettingsPrivacy({super.key});

  @override
  State<SettingsPrivacy> createState() => _SettingsPrivacyState();
}

class _SettingsPrivacyState extends State<SettingsPrivacy> {
  bool incognitoLearning = false;
  bool shareProgress = true;
  bool lessonReminders = true;
  bool aiMentorNudges = true;
  bool examAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [

            //================ HEADER =================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              decoration: const BoxDecoration(
                color: Color(0xFFFFD52E),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all(
                          color: const Color(0xFF1F355C),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1F355C),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    "Settings & Privacy",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F355C),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //================ USER CARD =================

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF58C7F3),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF1F355C),
                                  width: 2,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "AR",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Alex Rivera",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1F355C),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Student ID: EV-9921",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF1F355C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Color(0xFF1F355C),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      //================ ACCOUNT & SECURITY =================

                      const _SectionLabel("Account & Security"),
                      const SizedBox(height: 10),

                      _NavRow(
                        icon: Icons.person,
                        iconColor: const Color(0xFFE94A56),
                        title: "Personal Info",
                        subtitle: "Update name and grade",
                        onTap: () {Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const PersonalInfoScreen(),
    ),
  );

                        },
                      ),
                      const SizedBox(height: 12),
                      _NavRow(
                        icon: Icons.lock,
                        iconColor: const Color(0xFF57B97A),
                        title: "Password",
                        subtitle: "Change your login security",
                        onTap: () {  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const PasswordScreen(),
    ),
  );

                        },
                      ),

                      const SizedBox(height: 24),

                      //================ PRIVACY & DATA =================

                      const _SectionLabel("Privacy & Data"),
                      const SizedBox(height: 10),

                      _NavRow(
                        icon: Icons.auto_awesome,
                        iconColor: const Color(0xFFFFD52E),
                        iconOnLight: true,
                        title: "AI Data Usage",
                        subtitle: "Manage how AI learns with you",
                        onTap: () {
Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AiDataUsageScreen(),
    ),
  );
                        },
                      ),
                      const SizedBox(height: 12),
                      _ToggleRow(
                        title: "Incognito Learning",
                        value: incognitoLearning,
                        onChanged: (val) {
                          setState(() {
                            incognitoLearning = val;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _ToggleRow(
                        title: "Share Progress with Parents",
                        value: shareProgress,
                        onChanged: (val) {
                          setState(() {
                            shareProgress = val;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      //================ NOTIFICATIONS =================

                      const _SectionLabel("Notifications"),
                      const SizedBox(height: 10),

                      _ToggleRow(
                        title: "Lesson Reminders",
                        value: lessonReminders,
                        onChanged: (val) {
                          setState(() {
                            lessonReminders = val;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _ToggleRow(
                        title: "AI Mentor Nudges",
                        value: aiMentorNudges,
                        onChanged: (val) {
                          setState(() {
                            aiMentorNudges = val;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _ToggleRow(
                        title: "Exam Alerts",
                        value: examAlerts,
                        onChanged: (val) {
                          setState(() {
                            examAlerts = val;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      //================ SUPPORT =================

                      const _SectionLabel("Support"),
                      const SizedBox(height: 10),

                      _NavRow(
                        icon: Icons.help_outline,
                        iconColor: const Color(0xFF58C7F3),
                        title: "Help Center",
                        subtitle: "FAQs and contact support",
                        onTap: () {  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const HelpCenterScreen(),
    ),
  );

                        },
                      ),
                      const SizedBox(height: 12),
                      _NavRow(
                        icon: Icons.shield_outlined,
                        iconColor: const Color(0xFFE94A56),
                        title: "Privacy Policy",
                        subtitle: "How we protect your world",
                        onTap: () {  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const PrivacyPolicyScreen(),
    ),
  );
        
                        },
                      ),

                      const SizedBox(height: 26),

                      //================ LOG OUT =================

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Logged out")),
                            );
                          },
                          icon: const Icon(Icons.logout,
                              size: 18, color: Colors.white),
                          label: const Text(
                            "Log Out",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE94A56),
                            elevation: 0,
                            padding:
                                const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Center(
                        child: Column(
                          children: [
                            Text(
                              "EduVerse AI v2.4.0",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Made with ❤️ for students",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F355C),
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final bool iconOnLight;
  final String title;
  final String subtitle;
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
          border: Border.all(
            color: const Color(0xFF1F355C),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconOnLight ? const Color(0xFF1F355C) : Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F355C),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF1F355C),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1F355C),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F355C),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFFE94A56),
          ),
        ],
      ),
    );
  }
}