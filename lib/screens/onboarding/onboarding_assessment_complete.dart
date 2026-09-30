import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../learning/student_dashboard.dart';

enum RoadmapTier { beginner, intermediate, advanced }

extension RoadmapTierX on RoadmapTier {
  String get label {
    switch (this) {
      case RoadmapTier.beginner:
        return 'Beginner';
      case RoadmapTier.intermediate:
        return 'Intermediate';
      case RoadmapTier.advanced:
        return 'Advanced';
    }
  }

  static RoadmapTier fromPercent(int percent) {
    if (percent < 50) return RoadmapTier.beginner;
    if (percent <= 80) return RoadmapTier.intermediate;
    return RoadmapTier.advanced;
  }
}

class InsightItem {
  final IconData icon;
  final Color iconBackground;
  final String title;
  final String description;

  const InsightItem({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.description,
  });
}

class NextStepItem {
  final IconData icon;
  final Color iconBackground;
  final String title;
  final String duration;
  final VoidCallback? onTap;

  const NextStepItem({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.duration,
    this.onTap,
  });
}

class AssessmentComplete extends StatelessWidget {
  final String studentName;
  final String subjectLabel;
  final String unitLabel;
  final int score;
  final int totalScore;
  final int accuracyPercent;
  final String accuracyTrendLabel;
  final String timeTaken;
  final String timeTrendLabel;
  final int masteryPercent;
  final List<String> conceptsMastered;
  final List<String> needsReview;
  final InsightItem conceptualGapInsight;
  final String misconceptionLabel;
  final String commonMistakeText;
  final String correctConceptText;
  final List<NextStepItem> nextSteps;
  final VoidCallback? onReviewDetailedAnswers;
  final VoidCallback? onContinue;

  final GlobalKey _shareCardKey = GlobalKey();

  AssessmentComplete({
    super.key,
    this.studentName = 'Aryan',
    this.subjectLabel = 'Mathematics',
    this.unitLabel = 'Real Numbers',
    this.score = 18,
    this.totalScore = 22,
    this.accuracyPercent = 82,
    this.accuracyTrendLabel = '+5%',
    this.timeTaken = '14m 20s',
    this.timeTrendLabel = 'avg',
    this.masteryPercent = 82,
    this.conceptsMastered = const ['Rational Numbers', "Euclid's Lemma"],
    this.needsReview = const ['Irrational Proofs'],
    this.conceptualGapInsight = const InsightItem(
      icon: Icons.auto_awesome,
      iconBackground: Color(0xFFF4A100),
      title: 'Conceptual Gap Found',
      description:
          "You consistently struggle with contradiction proofs for irrationality. Let's practice the logic.",
    ),
    this.misconceptionLabel = 'Common Misconception Detected',
    this.commonMistakeText = 'Assumed √p is rational implies p is even',
    this.correctConceptText = 'p must be a prime factor of the square',
    this.nextSteps = const [
      NextStepItem(
        icon: Icons.replay_rounded,
        iconBackground: Color(0xFFEF3340),
        title: 'Review Errors',
        duration: '5 mins',
      ),
      NextStepItem(
        icon: Icons.play_arrow_rounded,
        iconBackground: Color(0xFF12B76A),
        title: 'Next Lesson',
        duration: '12 mins',
      ),
    ],
    this.onReviewDetailedAnswers,
    this.onContinue,
  });

  // Sir's Brand Colors
  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color brandGradientEnd = Color(0xFFF12C68);
  static const Color mastGreen = Color(0xFF12B76A);
  static const Color textMuted = Color(0xFF667085);
  static const Color cardBorder = Color(0xFFE4E7EC);
  static const Color tierGold = Color(0xFFF79009);

  int get scorePercent =>
      totalScore == 0 ? 0 : ((score / totalScore) * 100).round();

  RoadmapTier get tier => RoadmapTierX.fromPercent(scorePercent);

  Color get _tierColor {
    switch (tier) {
      case RoadmapTier.beginner:
        return mastGreen;
      case RoadmapTier.intermediate:
        return const Color(0xFF0086C9);
      case RoadmapTier.advanced:
        return tierGold;
    }
  }

  IconData get _tierIcon {
    switch (tier) {
      case RoadmapTier.beginner:
        return Icons.eco_rounded;
      case RoadmapTier.intermediate:
        return Icons.trending_up_rounded;
      case RoadmapTier.advanced:
        return Icons.military_tech_rounded;
    }
  }

  Future<void> _shareResult(BuildContext context) async {
    try {
      final boundary = _shareCardKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('Share card not ready yet');

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('Could not encode image');

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/assessment_result.png')
          .writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            '$studentName scored $score/$totalScore ($accuracyPercent%) in $unitLabel! 🎉',
        subject: 'Assessment Result - $unitLabel',
      );
    } catch (e) {
      debugPrint('Share failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: navy, size: 22),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assessment Complete',
              style: TextStyle(
                color: navy,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '$subjectLabel • $unitLabel',
              style: const TextStyle(
                color: textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: textMuted, size: 20),
            onPressed: () => _shareResult(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RepaintBoundary(
                      key: _shareCardKey,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hero Card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [brandRed, brandGradientEnd],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: brandRed.withOpacity(0.28),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.auto_awesome,
                                            color: Colors.white, size: 13),
                                        SizedBox(width: 4),
                                        Text(
                                          'EVALUATION REPORT',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Excellent Progress, $studentName!',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "You've mastered core concepts in this topic baseline.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      height: 1.35,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.22),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Score: ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '$score/$totalScore',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Stat Cards
                            Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    icon: Icons.check_circle_rounded,
                                    iconBackground: mastGreen,
                                    value: '$accuracyPercent%',
                                    label: 'Accuracy',
                                    trendLabel: accuracyTrendLabel,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _StatCard(
                                    icon: Icons.timer_rounded,
                                    iconBackground: const Color(0xFF0086C9),
                                    value: timeTaken,
                                    label: 'Time Taken',
                                    trendLabel: timeTrendLabel,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Mastery Breakdown Card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: cardBorder),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Mastery Breakdown',
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 86,
                                        height: 86,
                                        child: _MasteryDonut(
                                          masteryPercent: masteryPercent,
                                          masteryColor: mastGreen,
                                          gapColor: brandRed,
                                        ),
                                      ),
                                      const SizedBox(width: 18),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _LegendBlock(
                                              dotColor: mastGreen,
                                              label: 'Concepts Mastered',
                                              value:
                                                  conceptsMastered.join(', '),
                                            ),
                                            const SizedBox(height: 10),
                                            _LegendBlock(
                                              dotColor: brandRed,
                                              label: 'Needs Review',
                                              value: needsReview.join(', '),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Roadmap Tier Banner
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _tierColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: _tierColor.withOpacity(0.35),
                                    width: 1.2),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: _tierColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(_tierIcon,
                                        color: Colors.white, size: 22),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${tier.label} Roadmap Unlocked',
                                          style: const TextStyle(
                                            color: navy,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'You scored $scorePercent% — Sophia personalized your track.',
                                          style: const TextStyle(
                                            color: textMuted,
                                            fontSize: 12,
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // AI Mentor Insights
                    const Text(
                      'AI Mentor Insights',
                      style: TextStyle(
                        color: navy,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Conceptual gap card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: cardBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: conceptualGapInsight.iconBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(conceptualGapInsight.icon,
                                color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  conceptualGapInsight.title,
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  conceptualGapInsight.description,
                                  style: const TextStyle(
                                    color: textMuted,
                                    fontSize: 12,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Common misconception card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            misconceptionLabel,
                            style: const TextStyle(
                              color: navy,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.cancel_outlined,
                                  color: brandRed, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  commonMistakeText,
                                  style: const TextStyle(
                                    color: brandRed,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.check_circle_outline,
                                  color: mastGreen, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  correctConceptText,
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Recommended Next Steps
                    const Text(
                      'Recommended Next Steps',
                      style: TextStyle(
                        color: navy,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: nextSteps
                          .map(
                            (step) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: step == nextSteps.last ? 0 : 10,
                                ),
                                child: _NextStepCard(item: step),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom Continue Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                border:
                    Border(top: BorderSide(color: Color(0xFFF2F4F7), width: 1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [brandRed, brandGradientEnd],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: brandRed.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: onContinue ??
                          () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const StudentDashboard(),
                              ),
                            );
                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Unlock ${tier.label} Roadmap',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded,
                              color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final String value;
  final String label;
  final String trendLabel;

  const _StatCard({
    required this.icon,
    required this.iconBackground,
    required this.value,
    required this.label,
    required this.trendLabel,
  });

  static const Color navy = Color(0xFF1D3B64);
  static const Color textMuted = Color(0xFF667085);
  static const Color cardBorder = Color(0xFFE4E7EC);
  static const Color mastGreen = Color(0xFF12B76A);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: navy,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.trending_up_rounded, color: mastGreen, size: 14),
              const SizedBox(width: 4),
              Text(
                trendLabel,
                style: const TextStyle(
                  color: mastGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendBlock extends StatelessWidget {
  final Color dotColor;
  final String label;
  final String value;

  const _LegendBlock({
    required this.dotColor,
    required this.label,
    required this.value,
  });

  static const Color navy = Color(0xFF1D3B64);
  static const Color textMuted = Color(0xFF667085);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: navy,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MasteryDonut extends StatelessWidget {
  final int masteryPercent;
  final Color masteryColor;
  final Color gapColor;

  const _MasteryDonut({
    required this.masteryPercent,
    required this.masteryColor,
    required this.gapColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DonutPainter(
        percent: masteryPercent / 100,
        progressColor: masteryColor,
        remainderColor: gapColor,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$masteryPercent%',
              style: const TextStyle(
                color: Color(0xFF1D3B64),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Text(
              'Mastery',
              style: TextStyle(
                color: Color(0xFF667085),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double percent;
  final Color progressColor;
  final Color remainderColor;

  _DonutPainter({
    required this.percent,
    required this.progressColor,
    required this.remainderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.20;
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (size.width - strokeWidth) / 2;

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt
      ..color = remainderColor;

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt
      ..color = progressColor;

    const startAngle = -math.pi / 2;
    final sweepFull = 2 * math.pi;
    final sweepProgress = sweepFull * percent;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepFull,
      false,
      basePaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepProgress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.percent != percent ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.remainderColor != remainderColor;
  }
}

class _NextStepCard extends StatelessWidget {
  final NextStepItem item;

  const _NextStepCard({required this.item});

  static const Color navy = Color(0xFF1D3B64);
  static const Color textMuted = Color(0xFF667085);
  static const Color cardBorder = Color(0xFFE4E7EC);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    item.duration,
                    style: const TextStyle(
                      color: textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}