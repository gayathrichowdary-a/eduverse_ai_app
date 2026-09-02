import 'package:flutter/material.dart';

class StudentsDetail extends StatelessWidget {
  const StudentsDetail({super.key});

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
                    "Students Needing Help",
                    style: TextStyle(
                      fontSize: 22,
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
                    children: const [
                      _StudentDetailCard(
                        name: "Arjun Mehta",
                        topic: "Quadratic Equations",
                        percent: 42,
                        percentColor: Color(0xFFE94A56),
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
                        percentColor: Color(0xFFE94A56),
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
        border: Border.all(
          color: const Color(0xFF1F355C),
          width: 2,
        ),
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
                  color: Color(0xFFEDEDED),
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
                        color: Color(0xFF1F355C),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Topic: $topic",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
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
              backgroundColor: const Color(0xFFEFEFEF),
              valueColor: AlwaysStoppedAnimation<Color>(percentColor),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                "Last active: $lastActive",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline,
                    size: 16, color: Color(0xFF1F355C)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    recommendation,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: Color(0xFF1F355C),
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