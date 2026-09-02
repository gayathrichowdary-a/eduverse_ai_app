import 'package:flutter/material.dart';

import 'onboarding_assessment_in_progress.dart';

enum AssessmentDifficulty { beginner, intermediate, advanced }

class AssessmentModule {
  final String title;
  final IconData icon;
  final Color iconColor;
  final AssessmentDifficulty difficulty;
  final int questionCount;
  final String duration;

  AssessmentModule({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.difficulty,
    required this.questionCount,
    required this.duration,
  });

  String get difficultyLabel {
    switch (difficulty) {
      case AssessmentDifficulty.beginner:
        return 'Beginner';
      case AssessmentDifficulty.intermediate:
        return 'Intermediate';
      case AssessmentDifficulty.advanced:
        return 'Advanced';
    }
  }
}

class OnboardingInitialAiAssessment extends StatefulWidget {
  const OnboardingInitialAiAssessment({Key? key}) : super(key: key);

  @override
  State<OnboardingInitialAiAssessment> createState() =>
      _OnboardingInitialAiAssessmentState();
}

class _OnboardingInitialAiAssessmentState
    extends State<OnboardingInitialAiAssessment> {
  // ================= COLORS =================

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);

  // NOTE:
  // This module list is display copy for the "what's coming" preview
  // on this screen. The actual quiz stage (OnboardingAssessmentInProgress)
  // now runs its own fixed 3-question warm-up internally and no longer
  // takes a totalQuestions param, so these counts/durations are no
  // longer wired through to it — they're just what's shown here.
  final List<AssessmentModule> _modules = [
    AssessmentModule(
      title: 'Mathematics',
      icon: Icons.functions,
      iconColor: const Color(0xFFE8394A),
      difficulty: AssessmentDifficulty.intermediate,
      questionCount: 10,
      duration: '2 mins',
    ),
    AssessmentModule(
      title: 'English Proficiency',
      icon: Icons.translate,
      iconColor: const Color(0xFF29B6D8),
      difficulty: AssessmentDifficulty.beginner,
      questionCount: 8,
      duration: '1 min',
    ),
    AssessmentModule(
      title: 'Logical Reasoning',
      icon: Icons.lightbulb,
      iconColor: const Color(0xFFF4C10F),
      difficulty: AssessmentDifficulty.advanced,
      questionCount: 12,
      duration: '2 mins',
    ),
    AssessmentModule(
      title: 'General Science',
      icon: Icons.science,
      iconColor: const Color(0xFF4CAF7D),
      difficulty: AssessmentDifficulty.intermediate,
      questionCount: 10,
      duration: '2 mins',
    ),
    AssessmentModule(
      title: 'Coding Logic',
      icon: Icons.terminal,
      iconColor: const Color(0xFF5B5FE0),
      difficulty: AssessmentDifficulty.beginner,
      questionCount: 5,
      duration: '1 min',
    ),
  ];

  int get _totalQuestions =>
      _modules.fold(0, (sum, m) => sum + m.questionCount);

  int get _totalMinutes => _modules.fold(0, (sum, m) {
        final n = int.tryParse(m.duration.split(' ').first) ?? 0;
        return sum + n;
      });

  void _startAssessment() {
    // FIX: OnboardingAssessmentInProgress was shrunk to a fixed
    // 3-question internal bank and dropped its `totalQuestions`
    // constructor param. Passing it here was a compile error
    // ("no named parameter 'totalQuestions'"). The push below no
    // longer forwards it — the module list above stays purely as
    // preview copy on this screen.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OnboardingAssessmentInProgress(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= TITLE =================

                    const Text(
                      "Let's understand your learning level.",
                      style: TextStyle(
                        color: navy,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ================= SUBTITLE =================

                    const Text(
                      'This takes around 8 minutes.',
                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Divider(color: Color(0xFFE9EDF0), height: 1),

                    const SizedBox(height: 24),

                    // ================= SECTION LABEL =================

                    const Text(
                      'Assessment Modules',
                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ================= MODULE CARDS =================

                    ...List.generate(_modules.length, (index) {
                      final module = _modules[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == _modules.length - 1 ? 0 : 16,
                        ),
                        child: _ModuleCard(module: module),
                      );
                    }),

                    const SizedBox(height: 28),

                    // ================= SUMMARY ROW =================

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Duration',
                                style: TextStyle(
                                  color: subtitleBlue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$_totalMinutes Minutes',
                                style: const TextStyle(
                                  color: navy,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Questions',
                                style: TextStyle(
                                  color: subtitleBlue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$_totalQuestions Total',
                                style: const TextStyle(
                                  color: navy,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // =====================================================
            // BOTTOM SECTION
            // =====================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE9EDF0), width: 1),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _startAssessment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Start Assessment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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

class _ModuleCard extends StatelessWidget {
  final AssessmentModule module;

  const _ModuleCard({required this.module});

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: navy, width: 1.4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Icon + difficulty badge ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: module.iconColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(module.icon, color: Colors.white, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: navy, width: 1.2),
                ),
                child: Text(
                  module.difficultyLabel,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ---- Question count ----
          Text(
            '${module.questionCount} Questions',
            style: const TextStyle(
              color: subtitleBlue,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          // ---- Title ----
          Text(
            module.title,
            style: const TextStyle(
              color: navy,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 16),

          // ---- Duration ----
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  color: subtitleBlue, size: 16),
              const SizedBox(width: 6),
              Text(
                module.duration,
                style: const TextStyle(
                  color: subtitleBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}