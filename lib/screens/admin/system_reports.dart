import 'package:flutter/material.dart';

// NEW: soft card shadow used across the restyled screens
final List<BoxShadow> _softShadow = [
  BoxShadow(
    color: const Color(0xFF0B2F63).withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 6),
  ),
];

class SystemReports extends StatelessWidget {
  const SystemReports({super.key});

  static const Color navy = Color(0xFF0B2F63);
  static const Color yellow = Color(0xFFF7C948);
  static const Color background = Color(0xFFF6F5FD);

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
          'System Reports',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Platform Reports',
            style: TextStyle(
              color: navy,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Platform-wide usage and performance.',
            style: TextStyle(color: Color(0xFF7B8798)),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _ReportCard(
                  title: 'Students',
                  value: '6.2K',
                  icon: Icons.groups,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReportCard(
                  title: 'Teachers',
                  value: '184',
                  icon: Icons.person,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _ReportCard(
                  title: 'Schools',
                  value: '12',
                  icon: Icons.school,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReportCard(
                  title: 'Avg. Score',
                  value: '88%',
                  icon: Icons.bar_chart,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2), // CHANGED
        boxShadow: _softShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weekly Activity',
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 22),
                ...[
                  ['Monday', 0.65],
                  ['Tuesday', 0.82],
                  ['Wednesday', 0.55],
                  ['Thursday', 0.90],
                  ['Friday', 0.72],
                ].map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 75,
                          child: Text(
                            item[0] as String,
                            style: const TextStyle(color: navy),
                          ),
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: item[1] as double,
                            minHeight: 9,
                            borderRadius: BorderRadius.circular(20),
                            backgroundColor: const Color(0xFFE9EDF0),
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(yellow),
                          ),
                        ),
                      ],
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

class _ReportCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _ReportCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  static const Color navy = Color(0xFF0B2F63);
  static const Color yellow = Color(0xFFF7C948);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2), // CHANGED
        boxShadow: _softShadow,
      ),
      child: Column(
        children: [
          Icon(icon, color: yellow, size: 32),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: navy,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF7B8798)),
          ),
        ],
      ),
    );
  }
}