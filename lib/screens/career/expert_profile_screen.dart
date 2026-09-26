import 'package:flutter/material.dart';
import 'career_mentor_chat.dart';

// ============================================================
// MODEL — one entry per expert
// ============================================================

class ExpertProfile {
  final String name;
  final String title;
  final String bio;
  final IconData icon;
  final List<String> expertiseTags;

  const ExpertProfile({
    required this.name,
    required this.title,
    required this.bio,
    required this.icon,
    required this.expertiseTags,
  });
}

// Simple lookup so the avatar row can pass just a name and this screen
// resolves the full profile. Replace with real data / API call later.
const Map<String, ExpertProfile> expertDirectory = {
  "Dr. Aris": ExpertProfile(
    name: "Dr. Aris",
    title: "AI Research Lead",
    bio:
        "15+ years in machine learning research. Specializes in helping "
        "students break into AI engineering roles and choose the right "
        "specialization early.",
    icon: Icons.school,
    expertiseTags: ["Machine Learning", "Career Guidance", "Research"],
  ),
  "Sarah Chen": ExpertProfile(
    name: "Sarah Chen",
    title: "Senior Data Scientist",
    bio:
        "Works with Fortune 500 companies on analytics strategy. Loves "
        "mentoring students on turning a love of numbers into a career.",
    icon: Icons.business_center,
    expertiseTags: ["Data Science", "Analytics", "Interview Prep"],
  ),
  "Vikram S.": ExpertProfile(
    name: "Vikram S.",
    title: "Engineering Manager",
    bio:
        "Leads a 20-person engineering team. Focuses on helping students "
        "understand what real-world engineering work actually looks like.",
    icon: Icons.engineering,
    expertiseTags: ["Software Engineering", "Leadership", "Roadmaps"],
  ),
};

class ExpertProfileScreen extends StatelessWidget {
  final String expertName;

  const ExpertProfileScreen({super.key, required this.expertName});

  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);

  @override
  Widget build(BuildContext context) {
    final expert = expertDirectory[expertName] ??
        ExpertProfile(
          name: expertName,
          title: "Mentor",
          bio: "Profile details coming soon.",
          icon: Icons.person,
          expertiseTags: const [],
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Expert Profile",
            style: TextStyle(color: navy, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Header: avatar + name + title ----
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: navy, width: 2),
                    ),
                    child: Icon(expert.icon, color: brandRed, size: 48),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    expert.name,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expert.title,
                    style: const TextStyle(
                      color: subtitleBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ---- Expertise tags ----
            if (expert.expertiseTags.isNotEmpty) ...[
              const Text(
                "Expertise",
                style: TextStyle(
                  color: navy,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: expert.expertiseTags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: brandRed.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: brandRed,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 28),
            ],

            // ---- Bio ----
            const Text(
              "About",
              style: TextStyle(
                color: navy,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              expert.bio,
              style: const TextStyle(
                color: subtitleBlue,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 40),

            // ---- Chat Now button ----
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // NOTE: adjust the parameter name below to match
                      // whatever career_mentor_chat.dart actually expects
                      builder: (context) => CareerMentorChat(
                        expertName: expert.name,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline,
                    color: Colors.white, size: 20),
                label: const Text(
                  "Chat Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandRed,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
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