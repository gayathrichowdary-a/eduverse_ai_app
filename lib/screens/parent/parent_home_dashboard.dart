import 'package:flutter/material.dart';
import 'parent_monitoring.dart';
import 'parent_insights_portal.dart'; // contains ParentDashboard class
import 'attendance_screen.dart';       // uncomment once you create this screen
import 'notifications_screen.dart';    // uncomment once you create this screen
import 'child_selector.dart';

class ParentHomeDashboard extends StatelessWidget {
  const ParentHomeDashboard({super.key});

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
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD52E),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Row(
                  children: [

                    // Tap avatar -> Child Selector
                    GestureDetector(
                      onTap: () async {
                        final selectedChild = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChildSelector(),
                          ),
                        );

                        if (selectedChild != null && context.mounted) {
                          // Later: use selectedChild['name'], ['grade'] etc.
                          // to actually swap the dashboard's stats.
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Switched to ${selectedChild['name']}"),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(29),
                          border: Border.all(
                            color: const Color(0xFF1F355C),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "AR",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Arjun's Progress",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F355C),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Grade 8 • Active Now",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF5E6D7A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bell icon -> Notifications
                    GestureDetector(
                      onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const NotificationsScreen(),
    ),
  );
},

                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: const Color(0xFF1F355C),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.notifications,
                          color: Colors.red,
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 22),

              //================ QUICK SUMMARY CARD =================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFF1F355C),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "This Week's Summary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F355C),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _SummaryStat(
                              icon: Icons.mood,
                              iconColor: const Color(0xFF58C7F3),
                              label: "Confidence",
                              value: "85%",
                            ),
                          ),
                          Expanded(
                            child: _SummaryStat(
                              icon: Icons.event_available,
                              iconColor: const Color(0xFF57B97A),
                              label: "Attendance",
                              value: "96%",
                            ),
                          ),
                          Expanded(
                            child: _SummaryStat(
                              icon: Icons.priority_high,
                              iconColor: const Color(0xFFE94A56),
                              label: "Weak Areas",
                              value: "2",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 26),

              //================ QUICK LINKS =================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Quick Links",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F355C),
                      ),
                    ),
                    const SizedBox(height: 14),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.5,
                      children: [

                        _QuickLinkCard(
                          icon: Icons.trending_up,
                          iconColor: const Color(0xFF58C7F3),
                          label: "Full Progress",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ParentMonitoring(),
                              ),
                            );
                          },
                        ),

                        _QuickLinkCard(
                          icon: Icons.insights,
                          iconColor: const Color(0xFF57B97A),
                          label: "Insights",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ParentDashboard(),
                              ),
                            );
                          },
                        ),

                        _QuickLinkCard(
                          icon: Icons.calendar_today,
                          iconColor: const Color(0xFFF7C948),
                          label: "Attendance",
                          onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AttendanceScreen(),
    ),
  );
},
 
                        ),

                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

            ],
          ),
        ),
      ),
    );
  }
}

//================ REUSABLE WIDGETS =================

class _SummaryStat extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _SummaryStat({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F355C),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF5E6D7A),
          ),
        ),
      ],
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _QuickLinkCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF1F355C),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F355C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}