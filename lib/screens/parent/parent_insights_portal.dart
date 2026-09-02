import 'package:flutter/material.dart';
import 'ai_chat_screen.dart';
import 'full_report_screen.dart';

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ---------------- HEADER ----------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD52E),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Text(
                        "AA",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ---------------- ACADEMIC TITLE ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        "Academic Mastery",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F355C),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.menu_book,
                      color: Colors.red,
                      size: 28,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

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
border: Border.all(
  color: Color(0xFFFFD52E),
  width: 3,
),
      boxShadow: const [
        BoxShadow(
          color: Color(0x22000000),
          blurRadius: 5,
          offset: Offset(2, 3),
        ),
      ],
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
          color: Color(0xFF1F355C),
        ),
      ),

      const SizedBox(height: 15),

      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFF1F355C),
            width: 2,
          ),
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
                color: Colors.redAccent,
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
                      color: Color(0xFF1F355C),
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
                backgroundColor: Colors.redAccent,
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFF1F355C),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 5,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subject,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF4B6A8B),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            score,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F355C),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            growth,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 14,
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