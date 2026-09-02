import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
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
                    "Notifications",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F355C),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //================ TODAY =================

                      const _DateHeader("Today"),
                      const SizedBox(height: 10),
                      const _NotificationCard(
                        icon: Icons.school,
                        iconBackground: Color(0xFF59C27D),
                        title: "Mastered: Quadratic Equations",
                        subtitle: "Arjun scored 92% on the topic quiz",
                        time: "15 mins ago",
                      ),
                      const SizedBox(height: 12),
                      const _NotificationCard(
                        icon: Icons.warning_rounded,
                        iconBackground: Color(0xFFE94A56),
                        title: "Low Focus Detected",
                        subtitle: "Extended time spent on Social Media app",
                        time: "1 hour ago",
                      ),

                      const SizedBox(height: 26),

                      //================ YESTERDAY =================

                      const _DateHeader("Yesterday"),
                      const SizedBox(height: 10),
                      const _NotificationCard(
                        icon: Icons.emoji_events,
                        iconBackground: Color(0xFFF7C948),
                        title: "New Achievement Unlocked",
                        subtitle: "\"7-Day Study Streak\" badge earned",
                        time: "Yesterday, 6:40 PM",
                      ),
                      const SizedBox(height: 12),
                      const _NotificationCard(
                        icon: Icons.help_outline,
                        iconBackground: Color(0xFF58C7F3),
                        title: "Career Path Suggestion",
                        subtitle: "New match: Robotics Engineering (91%)",
                        time: "Yesterday, 4:15 PM",
                      ),

                      const SizedBox(height: 26),

                      //================ THIS WEEK =================

                      const _DateHeader("This Week"),
                      const SizedBox(height: 10),
                      const _NotificationCard(
                        icon: Icons.message_outlined,
                        iconBackground: Color(0xFF1F355C),
                        title: "Message from Teacher",
                        subtitle:
                            "\"Arjun did great in today's group project!\"",
                        time: "Monday, 2:20 PM",
                      ),
                      const SizedBox(height: 12),
                      const _NotificationCard(
                        icon: Icons.trending_down,
                        iconBackground: Color(0xFFE94A56),
                        title: "Score Drop Alert",
                        subtitle: "Chemistry quiz score fell to 55%",
                        time: "Monday, 10:05 AM",
                      ),

                      const SizedBox(height: 30),

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

class _DateHeader extends StatelessWidget {
  final String label;
  const _DateHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F355C),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final String time;

  const _NotificationCard({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF1F355C),
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),

          const SizedBox(width: 14),

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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9AA5B1),
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