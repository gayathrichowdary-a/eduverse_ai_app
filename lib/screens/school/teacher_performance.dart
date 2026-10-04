import 'package:flutter/material.dart';


final List<BoxShadow> _softShadow = [
  BoxShadow(
    color: const Color(0xFF0B2F63).withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 6),
  ),
];

class TeacherPerformance extends StatelessWidget {
  const TeacherPerformance({super.key});

  static const Color navy = Color(0xFF0B2F63);
  static const Color red = Color(0xFFF12C68);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Teacher Performance",
          style: TextStyle(
            color: navy,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _overview(),
            const SizedBox(height: 24),
            const Text(
              "Teacher Performance",
              style: TextStyle(
                color: navy,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            _teacher(
              "Mathematics",
              "Excellent",
              "92%",
              const Color(0xFF57B97A),
            ),
            _teacher(
              "Science",
              "Very Good",
              "86%",
              const Color(0xFF58C7F3),
            ),
            _teacher(
              "English",
              "Good",
              "81%",
              const Color(0xFFF7C948),
            ),
            _teacher(
              "Social Studies",
              "Good",
              "78%",
              red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _overview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.trending_up_rounded,
              color: red,
              size: 28,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Teacher Analytics",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Review teacher effectiveness scores",
                  style: TextStyle(
                    color: Color(0xFFB9C6D6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _teacher(
    String subject,
    String status,
    String score,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2),
        boxShadow: _softShadow,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color,
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(
                    color: Color(0xFF7B8798),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            score,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}