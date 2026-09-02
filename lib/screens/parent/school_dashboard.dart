import 'package:flutter/material.dart';

class SchoolDashboard extends StatelessWidget {
  const SchoolDashboard({super.key});

  static const Color navy = Color(0xFF1F355C);
  static const Color yellow = Color(0xFFFFD52E);

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature — hook this up to your next screen.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              //================ HEADER =================

              Container(
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
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: navy, width: 2),
                      ),
                      child: const Icon(Icons.business_rounded, color: navy),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "School Dashboard",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: navy,
                            ),
                          ),
                          Text(
                            "Curriculum & staff overview",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF5E6D7A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              //================ STAT ROW =================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: _SchoolStatCard(label: "Teachers", value: "42"),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _SchoolStatCard(label: "Students", value: "918"),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _SchoolStatCard(label: "Avg Score", value: "81%"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              //================ MODULE LIST =================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Manage School",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: navy,
                      ),
                    ),

                    const SizedBox(height: 14),

                    _SchoolModuleTile(
                      icon: Icons.menu_book_rounded,
                      color: const Color(0xFF58C7F3),
                      title: "Curriculum Management",
                      subtitle: "Edit subjects and course structure",
                      onTap: () => _showComingSoon(context, "Curriculum Management"),
                    ),
                    const SizedBox(height: 14),
                    _SchoolModuleTile(
                      icon: Icons.trending_up_rounded,
                      color: const Color(0xFFE94A56),
                      title: "Teacher Performance",
                      subtitle: "Review teacher effectiveness scores",
                      onTap: () => _showComingSoon(context, "Teacher Performance"),
                    ),
                    const SizedBox(height: 14),
                    _SchoolModuleTile(
                      icon: Icons.how_to_reg_rounded,
                      color: const Color(0xFF57B97A),
                      title: "Enrollment",
                      subtitle: "Manage student admissions",
                      onTap: () => _showComingSoon(context, "Enrollment"),
                    ),
                    const SizedBox(height: 14),
                    _SchoolModuleTile(
                      icon: Icons.description_rounded,
                      color: const Color(0xFFF7C948),
                      title: "School Reports",
                      subtitle: "Export term and annual reports",
                      onTap: () => _showComingSoon(context, "School Reports"),
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

class _SchoolStatCard extends StatelessWidget {
  final String label;
  final String value;

  const _SchoolStatCard({required this.label, required this.value});

  static const Color navy = Color(0xFF1F355C);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: navy, width: 1.4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: navy,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: navy,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SchoolModuleTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SchoolModuleTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const Color navy = Color(0xFF1F355C);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: navy, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: navy),
          ],
        ),
      ),
    );
  }
}