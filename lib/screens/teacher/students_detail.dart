import 'package:flutter/material.dart';

// NEW: soft card shadow used across the restyled screens
final List<BoxShadow> _softShadow = [
  BoxShadow(
    color: const Color(0xFF0B2F63).withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 6),
  ),
];

class StudentsDetail extends StatelessWidget {
  const StudentsDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FD),
      body: SafeArea(
        child: Column(
          children: [

            //================ HEADER =================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              decoration: BoxDecoration(
                color: Colors.white, // CHANGED: yellow -> white
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                boxShadow: _softShadow,
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
                        border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2), // CHANGED
        boxShadow: _softShadow,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF0B2F63),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    "Students Needing Help",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0B2F63),
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
                    children: const [
                      _StudentDetailCard(
                        name: "Arjun Mehta",
                        topic: "Quadratic Equations",
                        percent: 42,
                        percentColor: Color(0xFFF12C68),
                        lastActive: "15 mins ago",
                        recommendation:
                            "Struggling with factoring. Recommend 1-on-1 session on the discriminant formula.",
                      ),
                      SizedBox(height: 16),
                      _StudentDetailCard(
                        name: "Sana Khan",
                        topic: "Organic Chemistry",
                        percent: 55,
                        percentColor: Color(0xFFF7C948),
                        lastActive: "1 hour ago",
                        recommendation:
                            "Confusing functional groups. A quick revision quiz could help close the gap.",
                      ),
                      SizedBox(height: 16),
                      _StudentDetailCard(
                        name: "Rohan Das",
                        topic: "World War II",
                        percent: 38,
                        percentColor: Color(0xFFF12C68),
                        lastActive: "Yesterday",
                        recommendation:
                            "Low engagement on timeline-based questions. Try a visual timeline exercise.",
                      ),
                      SizedBox(height: 20),
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

class _StudentDetailCard extends StatelessWidget {
  final String name;
  final String topic;
  final int percent;
  final Color percentColor;
  final String lastActive;
  final String recommendation;

  const _StudentDetailCard({
    required this.name,
    required this.topic,
    required this.percent,
    required this.percentColor,
    required this.lastActive,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2), // CHANGED
        boxShadow: _softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0EEFB),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    name
                        .split(" ")
                        .map((e) => e.isNotEmpty ? e[0] : "")
                        .take(2)
                        .join(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E6D7A),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0B2F63),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Topic: $topic",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7B8798),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "$percent%",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: percentColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 6,
              backgroundColor: const Color(0xFFEDEBF7),
              valueColor: AlwaysStoppedAnimation<Color>(percentColor),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Color(0xFF7B8798)),
              const SizedBox(width: 6),
              Text(
                "Last active: $lastActive",
                style: const TextStyle(fontSize: 12, color: Color(0xFF7B8798)),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline,
                    size: 16, color: Color(0xFF0B2F63)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    recommendation,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: Color(0xFF0B2F63),
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