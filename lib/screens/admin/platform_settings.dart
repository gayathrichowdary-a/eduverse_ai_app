import 'package:flutter/material.dart';

// NEW: soft card shadow used across the restyled screens
final List<BoxShadow> _softShadow = [
  BoxShadow(
    color: const Color(0xFF0B2F63).withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 6),
  ),
];

class PlatformSettings extends StatefulWidget {
  const PlatformSettings({super.key});

  @override
  State<PlatformSettings> createState() => _PlatformSettingsState();
}

class _PlatformSettingsState extends State<PlatformSettings> {
  static const Color navy = Color(0xFF0B2F63);
  static const Color green = Color(0xFF9BE3A6);
  static const Color background = Color(0xFFF6F5FD);

  bool notifications = true;
  bool maintenanceMode = false;
  bool allowRegistration = true;
  bool aiFeatures = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white, // CHANGED
        foregroundColor: const Color(0xFF0B2F63),
        elevation: 3,
        shadowColor: const Color(0x1A0B2F63),
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
        ),
        title: const Text(
          'Platform Settings',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              color: navy,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Configure global app settings.',
            style: TextStyle(color: Color(0xFF7B8798)),
          ),
          const SizedBox(height: 20),

          _SettingTile(
            icon: Icons.notifications_active,
            title: 'Notifications',
            subtitle: 'Enable platform notifications',
            value: notifications,
            onChanged: (value) {
              setState(() {
                notifications = value;
              });
            },
          ),

          _SettingTile(
            icon: Icons.person_add,
            title: 'Student Registration',
            subtitle: 'Allow new student registrations',
            value: allowRegistration,
            onChanged: (value) {
              setState(() {
                allowRegistration = value;
              });
            },
          ),

          _SettingTile(
            icon: Icons.psychology,
            title: 'AI Features',
            subtitle: 'Enable AI-powered learning features',
            value: aiFeatures,
            onChanged: (value) {
              setState(() {
                aiFeatures = value;
              });
            },
          ),

          _SettingTile(
            icon: Icons.build_circle,
            title: 'Maintenance Mode',
            subtitle: 'Temporarily restrict platform access',
            value: maintenanceMode,
            onChanged: (value) {
              setState(() {
                maintenanceMode = value;
              });
            },
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2), // CHANGED
        boxShadow: _softShadow,
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: navy,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'These settings apply globally to the learning platform.',
                    style: TextStyle(
                      color: navy,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  static const Color navy = Color(0xFF0B2F63);
  static const Color green = Color(0xFF9BE3A6);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2), // CHANGED
        boxShadow: _softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: green,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: navy,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF7B8798),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white, // CHANGED
            activeTrackColor: const Color(0xFF4F46E5),
          ),
        ],
      ),
    );
  }
}