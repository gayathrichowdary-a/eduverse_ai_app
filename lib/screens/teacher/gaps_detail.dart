import 'package:flutter/material.dart';

// NEW: soft card shadow used across the restyled screens
final List<BoxShadow> _softShadow = [
  BoxShadow(
    color: const Color(0xFF0B2F63).withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 6),
  ),
];

class GapsDetail extends StatelessWidget {
  const GapsDetail({super.key});

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
                    "Learning Gaps",
                    style: TextStyle(
                      fontSize: 24,
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
                      _SubjectGapCard(
                        subject: "Math",
                        color: Color(0xFFF12C68),
                        weakTopics: [
                          _TopicGap(
                            topic: "Quadratic Equations",
                            studentsAffected: 12,
                            masteryPercent: 42,
                          ),
                          _TopicGap(
                            topic: "Trigonometry Basics",
                            studentsAffected: 6,
                            masteryPercent: 61,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _SubjectGapCard(
                        subject: "Science",
                        color: Color(0xFFF7C948),
                        weakTopics: [
                          _TopicGap(
                            topic: "Organic Chemistry",
                            studentsAffected: 9,
                            masteryPercent: 55,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _SubjectGapCard(
                        subject: "English",
                        color: Color(0xFF58C7F3),
                        weakTopics: [
                          _TopicGap(
                            topic: "Descriptive Writing",
                            studentsAffected: 5,
                            masteryPercent: 68,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _SubjectGapCard(
                        subject: "History",
                        color: Color(0xFF9BE3A6),
                        weakTopics: [
                          _TopicGap(
                            topic: "World War II Timeline",
                            studentsAffected: 8,
                            masteryPercent: 38,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _SubjectGapCard(
                        subject: "Geography",
                        color: Color(0xFF57B97A),
                        weakTopics: [
                          _TopicGap(
                            topic: "Map Reading",
                            studentsAffected: 4,
                            masteryPercent: 71,
                          ),
                        ],
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

class _TopicGap {
  final String topic;
  final int studentsAffected;
  final int masteryPercent;

  const _TopicGap({
    required this.topic,
    required this.studentsAffected,
    required this.masteryPercent,
  });
}

class _SubjectGapCard extends StatelessWidget {
  final String subject;
  final Color color;
  final List<_TopicGap> weakTopics;

  const _SubjectGapCard({
    required this.subject,
    required this.color,
    required this.weakTopics,
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
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                subject,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B2F63),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ...weakTopics.map((t) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          t.topic,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0B2F63),
                          ),
                        ),
                      ),
                      Text(
                        "${t.masteryPercent}%",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: t.masteryPercent < 50
                              ? const Color(0xFFF12C68)
                              : const Color(0xFF0B2F63),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: t.masteryPercent / 100,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFEDEBF7),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${t.studentsAffected} students affected",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF7B8798),
                    ),
                  ),
                ],
              ),
            );
          }),

        ],
      ),
    );
  }
}