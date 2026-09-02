import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../learning/student_dashboard.dart';
// ============================================================
// MODELS
// ============================================================

/// Score-tier roadmap unlocked by the assessment result.
///
/// Per the spec: "If you score less than 50 mark then you are eligible
/// for beginner level roadmap and if you score more than 50 then you
/// are eligible for intermediate level and if you are scoring more than
/// 80 mark then you are eligible for advance roadmap."
///
/// Boundaries as implemented: <50% -> beginner, 50-80% inclusive ->
/// intermediate, >80% -> advanced.
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

// ============================================================
// SCREEN
// ============================================================

class AssessmentComplete extends StatelessWidget {
  final String studentName;
  final String subjectLabel; // e.g. "Mathematics"
  final String unitLabel; // e.g. "Real Numbers"
  final int score;
  final int totalScore;
  final int accuracyPercent;
  final String accuracyTrendLabel; // e.g. "+5%"
  final String timeTaken; // e.g. "14m 20s"
  final String timeTrendLabel; // e.g. "avg"
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

  // Key used to capture the hero + stats + mastery section as an image
  // for sharing. NOT const-constructible, which is why the constructor
  // below can no longer be const.
  final GlobalKey _shareCardKey = GlobalKey();

  AssessmentComplete({
    Key? key,
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
          "You consistently struggle with contradiction proofs for "
          "irrationality. Let's practice the logic.",
    ),
    this.misconceptionLabel = 'Common Misconception Detected',
    this.commonMistakeText = 'Assumed √p is rational implies p is even',
    this.correctConceptText = 'p must be a prime factor of the square',
    this.nextSteps = const [
      NextStepItem(
        icon: Icons.replay_rounded,
        iconBackground: Color(0xFFE8394A),
        title: 'Review Errors',
        duration: '5 mins',
      ),
      NextStepItem(
        icon: Icons.play_arrow_rounded,
        iconBackground: Color(0xFF33B679),
        title: 'Next Lesson',
        duration: '12 mins',
      ),
    ],
    this.onReviewDetailedAnswers,
    this.onContinue,
  }) : super(key: key);

  // ================= COLORS =================

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color mastGreen = Color(0xFF33B679);
  static const Color trackGrey = Color(0xFFE9EDF0);
  static const Color panelGrey = Color(0xFFF5F7F8);
  static const Color tierGold = Color(0xFFF4A100);

  // ================= SCORE-TIER ROUTING =================

  int get scorePercent =>
      totalScore == 0 ? 0 : ((score / totalScore) * 100).round();

  RoadmapTier get tier => RoadmapTierX.fromPercent(scorePercent);

  Color get _tierColor {
    switch (tier) {
      case RoadmapTier.beginner:
        return mastGreen;
      case RoadmapTier.intermediate:
        return const Color(0xFF5B5FE0);
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

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — hook this up to your next screen.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ================= SHARE LOGIC =================

  Future<void> _shareResult(BuildContext context) async {
    try {
      final boundary = _shareCardKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('Share card not ready yet');
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Could not encode image');
      }

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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not share result. Please try again.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= TOP BAR =================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close, color: navy, size: 26),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Assessment Complete',
                          style: TextStyle(
                            color: navy,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$subjectLabel • $unitLabel',
                          style: const TextStyle(
                            color: subtitleBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => _shareResult(context),
                    icon: const Icon(Icons.share_rounded,
                        color: subtitleBlue, size: 22),
                  ),
                ],
              ),
            ),

            const Divider(color: trackGrey, height: 1),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ============================================
                    // SHAREABLE SECTION START
                    // (Hero card + Stat cards + Mastery breakdown)
                    // ============================================
                    RepaintBoundary(
                      key: _shareCardKey,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ================= HERO CARD =================
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: brandRed,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.auto_awesome,
                                      color: Colors.white, size: 30),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Excellent Progress, $studentName!',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    "You've mastered most concepts in this unit.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.22),
                                      borderRadius:
                                          BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Score: ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '$score/$totalScore',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ================= STAT CARDS =================
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
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _StatCard(
                                    icon: Icons.timer_rounded,
                                    iconBackground:
                                        const Color(0xFF5B5FE0),
                                    value: timeTaken,
                                    label: 'Time Taken',
                                    trendLabel: timeTrendLabel,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // ================= MASTERY BREAKDOWN =================
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: trackGrey, width: 1.2),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0F000000),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Mastery Breakdown',
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        height: 120,
                                        child: _MasteryDonut(
                                          masteryPercent: masteryPercent,
                                          masteryColor: mastGreen,
                                          gapColor: brandRed,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
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
                                            const SizedBox(height: 16),
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

                            const SizedBox(height: 20),

                            // ================= ROADMAP TIER BANNER =================
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: _tierColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: _tierColor, width: 1.4),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: _tierColor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(_tierIcon,
                                        color: Colors.white, size: 26),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${tier.label} Roadmap Unlocked',
                                          style: TextStyle(
                                            color: navy,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'You scored $scorePercent% — '
                                          'Sophia has personalized your '
                                          'roadmap for the ${tier.label} '
                                          'track.',
                                          style: const TextStyle(
                                            color: subtitleBlue,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            height: 1.35,
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
                    // ============================================
                    // SHAREABLE SECTION END
                    // ============================================

                    const SizedBox(height: 28),

                    // ================= AI MENTOR INSIGHTS =================
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'AI Mentor Insights',
                            style: TextStyle(
                              color: navy,
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: brandRed,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ---- Conceptual gap card ----
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: trackGrey, width: 1.2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0F000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: conceptualGapInsight.iconBackground,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(conceptualGapInsight.icon,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  conceptualGapInsight.title,
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  conceptualGapInsight.description,
                                  style: const TextStyle(
                                    color: subtitleBlue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ---- Common misconception panel ----
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: panelGrey,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            misconceptionLabel,
                            style: const TextStyle(
                              color: subtitleBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCE3E6),
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: brandRed, width: 1.4),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.error_rounded,
                                        color: brandRed, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Common Mistake',
                                      style: const TextStyle(
                                        color: brandRed,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  commonMistakeText,
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                const Divider(
                                    color: Color(0x33E8394A), height: 1),
                                const SizedBox(height: 14),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: mastGreen, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        correctConceptText,
                                        style: const TextStyle(
                                          color: navy,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ================= RECOMMENDED NEXT STEPS =================
                    const Text(
                      'Recommended Next Steps',
                      style: TextStyle(
                        color: navy,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: nextSteps
                          .map(
                            (step) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right:
                                      step == nextSteps.last ? 0 : 12,
                                ),
                                child: _NextStepCard(item: step),
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 24),

                    // ---- Review Detailed Answers ----
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: onReviewDetailedAnswers ??
                            () => _showComingSoon(
                                context, 'Detailed answers review'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: navy, width: 1.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          'Review Detailed Answers',
                          style: TextStyle(
                            color: navy,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ---- Unlock Gamify Roadmap (score-tier decision point) ----
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: onContinue ??
                            () {
                              // TODO: once StudentDashboard accepts a
                              // roadmap-tier param, pass `tier` (and
                              // `scorePercent`) through here so the Home
                              // Hub actually renders the tier-matched
                              // gamified roadmap instead of a default.
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const StudentDashboard(),
                                ),
                              );
                            },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _tierColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
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
                                color: Colors.white, size: 20),
                          ],
                        ),
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

// ============================================================
// STAT CARD
// ============================================================

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

  static const Color navy = AssessmentComplete.navy;
  static const Color subtitleBlue = AssessmentComplete.subtitleBlue;
  static const Color mastGreen = AssessmentComplete.mastGreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: navy, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              color: navy,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: subtitleBlue,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.trending_up_rounded,
                  color: mastGreen, size: 16),
              const SizedBox(width: 4),
              Text(
                trendLabel,
                style: const TextStyle(
                  color: mastGreen,
                  fontSize: 13,
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

// ============================================================
// LEGEND BLOCK
// ============================================================

class _LegendBlock extends StatelessWidget {
  final Color dotColor;
  final String label;
  final String value;

  const _LegendBlock({
    required this.dotColor,
    required this.label,
    required this.value,
  });

  static const Color navy = AssessmentComplete.navy;

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
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: navy,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: navy,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// MASTERY DONUT CHART
// ============================================================

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
                color: AssessmentComplete.navy,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Text(
              'Mastery',
              style: TextStyle(
                color: AssessmentComplete.subtitleBlue,
                fontSize: 11,
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
    final strokeWidth = size.width * 0.22;
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

    // remainder (background) full circle first
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepFull,
      false,
      basePaint,
    );

    // progress arc on top
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

// ============================================================
// NEXT STEP CARD
// ============================================================

class _NextStepCard extends StatelessWidget {
  final NextStepItem item;

  const _NextStepCard({required this.item});

  static const Color navy = AssessmentComplete.navy;
  static const Color subtitleBlue = AssessmentComplete.subtitleBlue;
  static const Color trackGrey = AssessmentComplete.trackGrey;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: trackGrey, width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
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
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.duration,
                    style: const TextStyle(
                      color: subtitleBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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