import 'package:flutter/material.dart';

// ============================================================
// MODELS
// ============================================================

class SubjectPerformance {
  final String subject;
  final IconData icon;
  final Color color;
  final double score; // 0.0 - 1.0
  final String trend; // e.g. '+5%', '-2%'
  final bool trendUp;

  const SubjectPerformance({
    required this.subject,
    required this.icon,
    required this.color,
    required this.score,
    required this.trend,
    required this.trendUp,
  });
}

// ============================================================
// SCREEN
// ============================================================

class StudentReportsScreen extends StatelessWidget {
  final String studentName;
  final int overallScorePercent;
  final int attendancePercent;
  final int completedLessons;
  final List<SubjectPerformance> subjects;

  const StudentReportsScreen({
    super.key,
    this.studentName = 'Arjun',
    this.overallScorePercent = 78,
    this.attendancePercent = 94,
    this.completedLessons = 46,
    this.subjects = const [
      SubjectPerformance(
        subject: 'Chemistry',
        icon: Icons.science,
        color: Color(0xFF33B679),
        score: 0.82,
        trend: '+6%',
        trendUp: true,
      ),
      SubjectPerformance(
        subject: 'Maths',
        icon: Icons.functions,
        color: Color(0xFFE8394A),
        score: 0.71,
        trend: '+3%',
        trendUp: true,
      ),
      SubjectPerformance(
        subject: 'Physics',
        icon: Icons.bolt_rounded,
        color: Color(0xFFF4C10F),
        score: 0.64,
        trend: '-2%',
        trendUp: false,
      ),
      SubjectPerformance(
        subject: 'English',
        icon: Icons.menu_book_rounded,
        color: Color(0xFF4D86AD),
        score: 0.88,
        trend: '+9%',
        trendUp: true,
      ),
    ],
  });

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color mastGreen = Color(0xFF33B679);
  static const Color trackGrey = Color(0xFFE9EDF0);

  Widget _statTile(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: navy, width: 1.4),
        ),
        child: Column(
          children: [
            Icon(icon, color: brandRed, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: navy,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: subtitleBlue,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, color: navy),
                  ),
                  const Text(
                    'Student Report',
                    style: TextStyle(
                      color: navy,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$studentName\'s Progress Overview',
                      style: const TextStyle(
                        color: navy,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // STAT TILES
                    Row(
                      children: [
                        _statTile('Overall Score', '$overallScorePercent%',
                            Icons.trending_up_rounded),
                        const SizedBox(width: 12),
                        _statTile('Attendance', '$attendancePercent%',
                            Icons.event_available_rounded),
                        const SizedBox(width: 12),
                        _statTile('Lessons Done', '$completedLessons',
                            Icons.check_circle_outline),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Subject-wise Performance',
                      style: TextStyle(
                        color: navy,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: navy, width: 1.4),
                      ),
                      child: Column(
                        children: List.generate(subjects.length * 2 - 1, (i) {
                          if (i.isOdd) {
                            return const SizedBox(height: 18);
                          }

                          final subject = subjects[i ~/ 2];
                          final scorePercent =
                              (subject.score * 100).round();

                          return Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: subject.color,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(subject.icon,
                                    color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            subject.subject,
                                            style: const TextStyle(
                                              color: navy,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '$scorePercent%',
                                          style: const TextStyle(
                                            color: navy,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Icon(
                                          subject.trendUp
                                              ? Icons.arrow_upward_rounded
                                              : Icons.arrow_downward_rounded,
                                          size: 14,
                                          color: subject.trendUp
                                              ? mastGreen
                                              : brandRed,
                                        ),
                                        Text(
                                          subject.trend,
                                          style: TextStyle(
                                            color: subject.trendUp
                                                ? mastGreen
                                                : brandRed,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: LinearProgressIndicator(
                                        value: subject.score,
                                        minHeight: 8,
                                        backgroundColor: trackGrey,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                subject.color),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCF1F8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: navy, width: 1.4),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb_rounded,
                              color: navy, size: 26),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tutor tip: Focus a bit more time on Physics '
                              'this week — a short review of force diagrams '
                              'could help lift that score.',
                              style: const TextStyle(
                                color: navy,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
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
          ],
        ),
      ),
    );
  }
}