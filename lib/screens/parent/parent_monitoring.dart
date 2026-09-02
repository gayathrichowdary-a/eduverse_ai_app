import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'ai_chat_screen.dart';

class ParentMonitoring extends StatelessWidget {
  const ParentMonitoring({super.key});

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
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD52E),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),

                child: Column(
                  children: [

                    Row(
                      children: [

                        Container(
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

                        const SizedBox(width: 15),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                "Arjun's Progress",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F355C),
                                ),
                              ),

                              SizedBox(height: 2),

                              Text(
                                "Grade 8 • Active Now",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF5E6D7A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                            ],
                          ),
                        ),

                        Container(
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
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.red,
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [

                        Expanded(
                          child: _StatCard(
                            color: const Color(0xFF58C7F3),
                            title: "Study Time",
                            value: "4.5h",
                          ),
                        ),

                        const SizedBox(width: 18),

                        Expanded(
                          child: _StatCard(
                            color: const Color(0xFF4CAF50),
                            title: "Focus Score",
                            value: "88%",
                          ),
                        ),

                      ],
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 22),

              //================ ACADEMIC GROWTH =================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF1F355C),
                      width: 2,
                    ),
                  ),

                  child: Column(
                    children: [

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [

                          const Text(
                            "Academic Growth",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F355C),
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD52E),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  "Weekly",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        height: 180,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [

                            PieChart(
                              PieChartData(
                                startDegreeOffset: -78,
                                centerSpaceRadius: 45,
                                sectionsSpace: 4,
                                sections: [
                                  PieChartSectionData(
                                    value: 10,
                                    color: const Color(0xFF57B97A),
                                    radius: 18,
                                    showTitle: false,
                                  ),
                                  PieChartSectionData(
                                    value: 45,
                                    color: const Color(0xFFE83B4F),
                                    radius: 18,
                                    showTitle: false,
                                  ),
                                  PieChartSectionData(
                                    value: 30,
                                    color: const Color(0xFFFFC928),
                                    radius: 18,
                                    showTitle: false,
                                  ),
                                  PieChartSectionData(
                                    value: 15,
                                    color: const Color(0xFF58C7F3),
                                    radius: 18,
                                    showTitle: false,
                                  ),
                                ],
                              ),
                            ),

                            const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Text(
                                  "82%",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F355C),
                                  ),
                                ),

                                Text(
                                  "Overall",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),

                              ],
                            ),

                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Column(
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              _LegendItem(
                                color: const Color(0xFFE84A5F),
                                title: "Math",
                                percent: "45%",
                              ),

                              const SizedBox(width: 14),

                              _LegendItem(
                                color: const Color(0xFFF7C948),
                                title: "Science",
                                percent: "30%",
                              ),

                              const SizedBox(width: 14),

                              _LegendItem(
                                color: const Color(0xFF58C7F3),
                                title: "English",
                                percent: "15%",
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              _LegendItem(
                                color: const Color(0xFF52B86A),
                                title: "Coding",
                                percent: "10%",
                              ),

                            ],
                          ),

                        ],
                      ),

                      const SizedBox(height: 20),

                      const Divider(
                        thickness: 1,
                        color: Color(0xFFE5E5E5),
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [

                          Expanded(
                            child: Column(
                              children: const [

                                Text(
                                  "Quiz Avg",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),

                                SizedBox(height: 6),

                                Text(
                                  "A-",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F355C),
                                  ),
                                ),

                              ],
                            ),
                          ),

                          Container(
                            width: 1,
                            height: 60,
                            color: Colors.grey.shade300,
                          ),

                          Expanded(
                            child: Column(
                              children: const [

                                Text(
                                  "Rank",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),

                                SizedBox(height: 6),

                                Text(
                                  "#4",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F355C),
                                  ),
                                ),

                              ],
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              //================ MILESTONES & ALERTS =================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Milestones & Alerts",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F355C),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const MilestoneCard(
                      icon: Icons.school,
                      iconBackground: Color(0xFF59C27D),
                      title: "Mastered: Quadratic Equations",
                      time: "15 mins ago",
                    ),

                    const SizedBox(height: 14),

                    const MilestoneCard(
                      icon: Icons.warning_rounded,
                      iconBackground: Color(0xFFE94A56),
                      title: "Low Focus: Social Media",
                      time: "1 hour ago",
                    ),

                    const SizedBox(height: 14),

                    const MilestoneCard(
                      icon: Icons.help_outline,
                      iconBackground: Color(0xFF59C7F3),
                      title: "Career Path: Robotics",
                      time: "Yesterday",
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 22),

              //================ AI MENTOR INSIGHT =================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF7FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF1F355C),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: const [
                          Icon(Icons.auto_awesome,
                              color: Color(0xFF1F355C), size: 20),
                          SizedBox(width: 8),
                          Text(
                            "AI Mentor Insight",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F355C),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Arjun is showing high aptitude for logical reasoning but needs more practice in descriptive English. I've adjusted his schedule.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5E6D7A),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 14),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AiChatScreen(),
    ),
  );},
                          icon: const Icon(Icons.chat_bubble_outline,
                              size: 18, color: Colors.white),
                          label: const Text(
                            "Chat with AI Mentor",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1F355C),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

            ],
          ),
        ),
      ),

      //================ BOTTOM NAVIGATION BAR (new) =================



    );
  }
}

class _StatCard extends StatelessWidget {
  final Color color;
  final String title;
  final String value;

  const _StatCard({
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5E6D7A),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F355C),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String title;
  final String percent;

  const _LegendItem({
    required this.color,
    required this.title,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          "$title  $percent",
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F355C),
          ),
        ),
      ],
    );
  }
}

class MilestoneCard extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final String title;
  final String time;

  const MilestoneCard({
    super.key,
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF1F355C),
          width: 2,
        ),
      ),
      child: Row(
        children: [

          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 22,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F355C),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
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
    );
  }
}