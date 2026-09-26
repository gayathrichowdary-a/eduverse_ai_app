import 'package:flutter/material.dart';

class MentorModel {
  final String name;
  final String title;
  final String avatarInitials;
  final List<String> expertiseTags;
  final double rating;
  final int sessionsCompleted;
  final Color avatarColor;

  const MentorModel({
    required this.name,
    required this.title,
    required this.avatarInitials,
    required this.expertiseTags,
    required this.rating,
    required this.sessionsCompleted,
    required this.avatarColor,
  });
}

class MentorsList extends StatelessWidget {
  const MentorsList({super.key});

  // Theme Colors - matched to SkillGapAnalysis
  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color insightBlueBg = Color(0xFFEAF8FB);

  // Dummy mentor data - filtered for "Coding" skill gap
  static const List<MentorModel> _mentors = [
    MentorModel(
      name: "Ananya Rao",
      title: "Senior SWE @ Google",
      avatarInitials: "AR",
      expertiseTags: ["System Design", "Scalability", "Java"],
      rating: 4.9,
      sessionsCompleted: 128,
      avatarColor: Color(0xFFE8394A),
    ),
    MentorModel(
      name: "Rohan Mehta",
      title: "Flutter Lead @ Razorpay",
      avatarInitials: "RM",
      expertiseTags: ["Flutter", "Dart", "Clean Architecture"],
      rating: 4.8,
      sessionsCompleted: 96,
      avatarColor: Color(0xFF4FC3F7),
    ),
    MentorModel(
      name: "Priya Nair",
      title: "SDE-2 @ Amazon",
      avatarInitials: "PN",
      expertiseTags: ["DSA", "Distributed Systems"],
      rating: 4.9,
      sessionsCompleted: 210,
      avatarColor: Color(0xFF52B68C),
    ),
    MentorModel(
      name: "Karan Singh",
      title: "Backend Engineer @ Stripe",
      avatarInitials: "KS",
      expertiseTags: ["Node.js", "Scalability", "APIs"],
      rating: 4.7,
      sessionsCompleted: 74,
      avatarColor: Color(0xFFFFC107),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Find Mentors",
              style: TextStyle(color: navy, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Matched to your Coding gap",
              style: TextStyle(color: subtitleBlue, fontSize: 16, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 20),

            // --- AI Insight strip reused for context ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: insightBlueBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.auto_awesome, color: navy, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "These mentors specialize in scalability and system design — the exact skills flagged in your gap analysis.",
                      style: TextStyle(color: navy, fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- Mentor Cards ---
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _mentors.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) => _mentorCard(context, _mentors[index]),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _mentorCard(BuildContext context, MentorModel mentor) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: mentor.avatarColor,
                child: Text(
                  mentor.avatarInitials,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mentor.name,
                        style: const TextStyle(color: navy, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(mentor.title,
                        style: const TextStyle(color: subtitleBlue, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                      const SizedBox(width: 4),
                      Text(mentor.rating.toString(),
                          style: const TextStyle(color: navy, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text("${mentor.sessionsCompleted} sessions",
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Expertise tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: mentor.expertiseTags
                .map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: insightBlueBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(tag,
                          style: const TextStyle(color: navy, fontSize: 11, fontWeight: FontWeight.w600)),
                    ))
                .toList(),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Session request sent to ${mentor.name}")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: brandRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Book Session",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}