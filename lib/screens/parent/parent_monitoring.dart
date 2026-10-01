import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'ai_chat_screen.dart';

// NEW: soft card shadow used across the restyled screens
final List<BoxShadow> _softShadow = [
  BoxShadow(
    color: const Color(0xFF0B2F63).withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 6),
  ),
];

class ParentMonitoring extends StatelessWidget {
  const ParentMonitoring({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              //================ HEADER =================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                decoration: BoxDecoration(
                color: Colors.white, // CHANGED: yellow -> white
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                boxShadow: _softShadow,
              ),

                child: Column(
                  children: [

                    Row(
                      children: [

                        GestureDetector(
                          onTap: () => Navigator.pop(context), // back to Parent Home Dashboard
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(21),
                              border: Border.all(color: const Color(0xFFE6E2F7), width: 1.5),
                              boxShadow: _softShadow,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFF0B2F63),
                              size: 20,
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
                                  fontSize: 24, // CHANGED: 28 -> 24
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0B2F63),
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

                      ],
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [

                        Expanded(
                          child: _StatCard(
                            color: const Color(0xFF58C7F3),
                            title: "Study Time",
                            value: "4.5h",
                          ),
                        ),

                        const SizedBox(width: 14),

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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2), // CHANGED
        boxShadow: _softShadow,
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
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0B2F63),
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0EEFB),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  "Weekly",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4F46E5),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 18,
                                  color: Color(0xFF4F46E5),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [

                          // Donut chart
                          SizedBox(
                            width: 132,
                            height: 132,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [

                                PieChart(
                                  PieChartData(
                                    startDegreeOffset: -78,
                                    centerSpaceRadius: 38,
                                    sectionsSpace: 3,
                                    sections: [
                                      PieChartSectionData(
                                        value: 10,
                                        color: const Color(0xFF57B97A),
                                        radius: 14,
                                        showTitle: false,
                                      ),
                                      PieChartSectionData(
                                        value: 45,
                                        color: const Color(0xFFE83B4F),
                                        radius: 14,
                                        showTitle: false,
                                      ),
                                      PieChartSectionData(
                                        value: 30,
                                        color: const Color(0xFFFFC928),
                                        radius: 14,
                                        showTitle: false,
                                      ),
                                      PieChartSectionData(
                                        value: 15,
                                        color: const Color(0xFF58C7F3),
                                        radius: 14,
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0B2F63),
                                      ),
                                    ),

                                    Text(
                                      "Overall",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF7B8798),
                                      ),
                                    ),

                                  ],
                                ),

                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          // Legend (vertical, next to the chart)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                _LegendItem(
                                  color: const Color(0xFFE83B4F),
                                  title: "Math",
                                  percent: "45%",
                                ),

                                const SizedBox(height: 10),

                                _LegendItem(
                                  color: const Color(0xFFFFC928),
                                  title: "Science",
                                  percent: "30%",
                                ),

                                const SizedBox(height: 10),

                                _LegendItem(
                                  color: const Color(0xFF58C7F3),
                                  title: "English",
                                  percent: "15%",
                                ),

                                const SizedBox(height: 10),

                                _LegendItem(
                                  color: const Color(0xFF57B97A),
                                  title: "Coding",
                                  percent: "10%",
                                ),

                              ],
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 14),

                      const Divider(
                        thickness: 1,
                        color: Color(0xFFEDEBF7),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [

                          Expanded(
                            child: Column(
                              children: const [

                                Text(
                                  "Quiz Avg",
                                  style: TextStyle(
                                    color: Color(0xFF7B8798),
                                    fontSize: 12,
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  "A-",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0B2F63),
                                  ),
                                ),

                              ],
                            ),
                          ),

                          Container(
                            width: 1,
                            height: 44,
                            color: Colors.grey.shade300,
                          ),

                          Expanded(
                            child: Column(
                              children: const [

                                Text(
                                  "Rank",
                                  style: TextStyle(
                                    color: Color(0xFF7B8798),
                                    fontSize: 12,
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  "#4",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0B2F63),
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
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0B2F63),
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
                      iconBackground: Color(0xFFF12C68),
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
                    color: const Color(0xFFF0EEFB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2), // CHANGED
        boxShadow: _softShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: const [
                          Icon(Icons.auto_awesome,
                              color: Color(0xFF0B2F63), size: 20),
                          SizedBox(width: 8),
                          Text(
                            "AI Mentor Insight",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B2F63),
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
                            backgroundColor: const Color(0xFF0B2F63),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2), // CHANGED
        boxShadow: _softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5E6D7A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B2F63),
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
            color: Color(0xFF0B2F63),
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
        border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2), // CHANGED
        boxShadow: _softShadow,
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
                    color: Color(0xFF0B2F63),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7B8798),
                  ),
                ),

              ],
            ),
          ),

          const Icon(
            Icons.chevron_right,
            color: Color(0xFF0B2F63),
          ),
        ],
      ),
    );
  }
}