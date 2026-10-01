import 'package:flutter/material.dart';
import 'ai_chat_screen.dart';
import 'full_report_screen.dart';

// NEW: soft card shadow used across the restyled screens
final List<BoxShadow> _softShadow = [
  BoxShadow(
    color: const Color(0xFF0B2F63).withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 6),
  ),
];

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ---------------- HEADER ----------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                decoration: BoxDecoration(
                color: Colors.white, // CHANGED: yellow -> white
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                boxShadow: _softShadow,
              ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back button -> Parent Home Dashboard
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
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
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "PARENT PORTAL",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Arjun's Progress",
                            style: TextStyle(
                              fontSize: 24, // CHANGED: 34 -> 24
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B2F63),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---------------- ACADEMIC TITLE ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        "Academic Mastery",
                        style: TextStyle(
                          fontSize: 22, // CHANGED: 28 -> 22
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B2F63),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.menu_book,
                      color: Color(0xFFF12C68),
                      size: 24,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ---------------- SUBJECT CARDS ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: const [
                    Expanded(
                      child: SubjectCard(
                        color: Color(0xFF55C7F5),
                        subject: "Math",
                        score: "92%",
                        growth: "↑ 5% this week",
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: SubjectCard(
                        color: Color(0xFF5BBE84),
                        subject: "Science",
                        score: "88%",
                        growth: "↑ 2% this week",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Container(
    width: double.infinity,
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
        const Row(
          children: [
            Icon(Icons.favorite, color: Colors.red),
            SizedBox(width: 8),
            Text(
              "Emotional Well-being",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        buildProgress("Confidence Level", 0.85, Colors.lightBlue),
        const SizedBox(height: 15),
        buildProgress("Focus & Attention", 0.72, Colors.orange),
        const SizedBox(height: 15),
        buildProgress("Stress Managment", 0.90, Colors.green),
        const SizedBox(height: 20),

Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: const Color(0xFFEAF4FB),
    border: Border.all(
      color: const Color(0xFF9FB5C7),
    ),
    borderRadius: BorderRadius.circular(12),
  ),
  child: const Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 14,
        backgroundColor: Color(0xFF2D3E5E),
        child: Icon(
          Icons.lightbulb,
          color: Colors.white,
          size: 16,
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        child: Text(
          "Arjun is feeling curious today! He spent extra time on 'Space Exploration' modules.",
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF2D3E5E),
          ),
        ),
      ),
    ],
  ),
),
      ],
    ),
  ),
),

const SizedBox(height: 25),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Future Path",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0B2F63),
        ),
      ),

      const SizedBox(height: 15),

      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2), // CHANGED
        boxShadow: _softShadow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFDECEC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.rocket_launch,
                color: Color(0xFFF12C68),
              ),
            ),

            const SizedBox(width: 15),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "TOP CAREER INTEREST",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Aerospace Engineering",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B2F63),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Match Score: 94%",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 18),

      Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const FullReportScreen(),
    ),
  );},
              icon: const Icon(Icons.description),
              label: const Text("Full Report"),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AiChatScreen(),
    ),
  );},
              icon: const Icon(Icons.smart_toy),
              label: const Text("Talk to AI"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF12C68),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ],
  ),
),

const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final Color color;
  final String subject;
  final String score;
  final String growth;

  const SubjectCard({
    super.key,
    required this.color,
    required this.subject,
    required this.score,
    required this.growth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), // CHANGED: compact
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2), // CHANGED
        boxShadow: _softShadow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // color chip + subject name on one line
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subject,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B6A8B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            score,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B2F63),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            growth,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
Widget buildProgress(
  String title,
  double value,
  Color color,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text("${(value * 100).toInt()}%"),
        ],
      ),

      const SizedBox(height: 8),

      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: value,
          minHeight: 10,
          color: color,
          backgroundColor: Colors.grey.shade300,
        ),
      ),
    ],
  );
}