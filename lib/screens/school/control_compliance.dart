import 'package:flutter/material.dart';

/// SCHOOL / control_compliance.dart
///
/// College controls: proctoring strictness, authorization,
/// AI tutor settings, student lookup, and audit trail.
/// Styled to match SchoolDashboard (navy + yellow theme).
class ControlComplianceScreen extends StatefulWidget {
  const ControlComplianceScreen({super.key});

  static const Color navy = Color(0xFF1F355C);
  static const Color yellow = Color(0xFFFFD52E);

  @override
  State<ControlComplianceScreen> createState() =>
      _ControlComplianceScreenState();
}

class _ControlComplianceScreenState extends State<ControlComplianceScreen> {
  static const Color navy = ControlComplianceScreen.navy;
  static const Color yellow = ControlComplianceScreen.yellow;

  double _proctoringStrictness = 60;

  String _strictnessLabel(double v) {
    if (v < 33) return 'Low';
    if (v < 66) return 'Medium';
    return 'High';
  }

  final List<_AuthEntry> _authEntries = [
    _AuthEntry(name: 'Dr. Meera Nair', role: 'Instructor', authorized: true),
    _AuthEntry(name: 'Prof. Arjun Rao', role: 'Instructor', authorized: true),
    _AuthEntry(name: 'Front Desk Staff', role: 'Staff', authorized: false),
  ];

  String _aiVerbosity = 'Balanced';
  bool _allowHints = true;
  bool _allowStepByStep = true;
  bool _restrictOffSyllabus = true;

  final TextEditingController _studentIdController = TextEditingController();
  Map<String, dynamic>? _studentResult;

  void _searchStudent() {
    final id = _studentIdController.text.trim();
    if (id.isEmpty) return;
    setState(() {
      _studentResult = {
        'id': id,
        'name': 'Student #$id',
        'lastAccess': '2 days ago',
        'sessionsReviewed': 4,
        'flags': 0,
      };
    });
  }

  final List<_AuditEntry> _auditTrail = [
    _AuditEntry(
      actor: 'Admin (you)',
      action: 'Updated proctoring strictness to Medium',
      time: 'Today, 09:14',
    ),
    _AuditEntry(
      actor: 'Dr. Meera Nair',
      action: 'Reviewed proctoring flag for Student #2211',
      time: 'Yesterday, 17:02',
    ),
    _AuditEntry(
      actor: 'Admin (you)',
      action: 'Revoked authorization for Front Desk Staff',
      time: '2 days ago',
    ),
  ];

  bool _dirty = false;
  void _markDirty() => setState(() => _dirty = true);

  void _saveChanges() {
    setState(() {
      _auditTrail.insert(
        0,
        _AuditEntry(
          actor: 'Admin (you)',
          action: 'Saved control & compliance settings',
          time: 'Just now',
        ),
      );
      _dirty = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _Header(
                icon: Icons.security_rounded,
                title: 'Control & Compliance',
                subtitle: 'Proctoring, authorization & AI tutor settings',
                trailing: _SaveButton(enabled: _dirty, onTap: _saveChanges),
              ),
              const SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionCard(
                      title: 'Proctoring Strictness',
                      icon: Icons.shield_moon_rounded,
                      iconColor: const Color(0xFF58C7F3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _strictnessLabel(_proctoringStrictness),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: navy,
                                ),
                              ),
                              Text(
                                '${_proctoringStrictness.round()}%',
                                style: const TextStyle(
                                  color: navy,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: navy,
                              thumbColor: navy,
                              inactiveTrackColor: navy.withValues(alpha: .15),
                              overlayColor: navy.withValues(alpha: .1),
                            ),
                            child: Slider(
                              value: _proctoringStrictness,
                              min: 0,
                              max: 100,
                              divisions: 20,
                              label: _strictnessLabel(_proctoringStrictness),
                              onChanged: (v) {
                                setState(() => _proctoringStrictness = v);
                                _markDirty();
                              },
                            ),
                          ),
                          const Text(
                            'Higher strictness increases face/gaze tracking '
                            'sensitivity and flags more borderline behavior '
                            'during AI-proctored sessions.',
                            style: TextStyle(color: Colors.grey, fontSize: 12.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _SectionCard(
                      title: 'User / Instructor Authorization',
                      icon: Icons.admin_panel_settings_rounded,
                      iconColor: const Color(0xFF57B97A),
                      child: Column(
                        children: _authEntries.map((entry) {
                          return SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            activeThumbColor: navy,
                            title: Text(
                              entry.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: navy,
                              ),
                            ),
                            subtitle: Text(entry.role),
                            value: entry.authorized,
                            onChanged: (v) {
                              setState(() => entry.authorized = v);
                              _markDirty();
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _SectionCard(
                      title: 'AI Tutor Response Settings',
                      icon: Icons.smart_toy_rounded,
                      iconColor: const Color(0xFFE94A56),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            initialValue: _aiVerbosity,
                            decoration: InputDecoration(
                              labelText: 'Response verbosity',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: navy),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: navy),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'Concise', child: Text('Concise')),
                              DropdownMenuItem(value: 'Balanced', child: Text('Balanced')),
                              DropdownMenuItem(value: 'Detailed', child: Text('Detailed')),
                            ],
                            onChanged: (v) {
                              if (v == null) return;
                              setState(() => _aiVerbosity = v);
                              _markDirty();
                            },
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            activeThumbColor: navy,
                            title: const Text('Allow hints'),
                            value: _allowHints,
                            onChanged: (v) {
                              setState(() => _allowHints = v);
                              _markDirty();
                            },
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            activeThumbColor: navy,
                            title: const Text('Allow step-by-step solutions'),
                            value: _allowStepByStep,
                            onChanged: (v) {
                              setState(() => _allowStepByStep = v);
                              _markDirty();
                            },
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            activeThumbColor: navy,
                            title: const Text('Restrict answers to syllabus scope'),
                            value: _restrictOffSyllabus,
                            onChanged: (v) {
                              setState(() => _restrictOffSyllabus = v);
                              _markDirty();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _SectionCard(
                      title: 'Past Student Data Access',
                      icon: Icons.person_search_rounded,
                      iconColor: const Color(0xFFF7C948),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _studentIdController,
                                  decoration: InputDecoration(
                                    labelText: 'Search student by ID',
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: navy),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: navy),
                                    ),
                                  ),
                                  onSubmitted: (_) => _searchStudent(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _searchStudent,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: navy,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 14),
                                ),
                                child: const Text('Search'),
                              ),
                            ],
                          ),
                          if (_studentResult != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: yellow.withValues(alpha: .18),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: navy.withValues(alpha: .3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_studentResult!['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800, color: navy)),
                                  Text('ID: ${_studentResult!['id']}'),
                                  Text('Last access: ${_studentResult!['lastAccess']}'),
                                  Text(
                                      'Sessions reviewed: ${_studentResult!['sessionsReviewed']}'),
                                  Text('Open flags: ${_studentResult!['flags']}'),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _SectionCard(
                      title: 'Internal Audit Trail',
                      icon: Icons.receipt_long_rounded,
                      iconColor: navy,
                      child: Column(
                        children: _auditTrail.map((e) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.history, size: 20, color: navy),
                            title: Text(e.action,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text('${e.actor} · ${e.time}'),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _dirty ? _saveChanges : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: navy,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.save_rounded),
                        label: const Text(
                          'Save / Update Controls',
                          style: TextStyle(fontWeight: FontWeight.w700),
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

class _AuthEntry {
  _AuthEntry({required this.name, required this.role, required this.authorized});
  final String name;
  final String role;
  bool authorized;
}

class _AuditEntry {
  _AuditEntry({required this.actor, required this.action, required this.time});
  final String actor;
  final String action;
  final String time;
}

// ================================================================
// SHARED STYLED WIDGETS (matches SchoolDashboard visual language)
// ================================================================

class _Header extends StatelessWidget {
  const _Header({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  static const Color navy = Color(0xFF1F355C);
  static const Color yellow = Color(0xFFFFD52E);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: const BoxDecoration(
        color: yellow,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded, color: navy),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 6),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: navy, width: 2),
            ),
            child: Icon(icon, color: navy),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: navy,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF5E6D7A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.enabled, required this.onTap});
  final bool enabled;
  final VoidCallback onTap;

  static const Color navy = Color(0xFF1F355C);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: navy, width: 1.4),
        ),
        child: Icon(
          Icons.save_rounded,
          color: enabled ? navy : navy.withValues(alpha: .3),
          size: 20,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  static const Color navy = Color(0xFF1F355C);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: navy, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: navy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}