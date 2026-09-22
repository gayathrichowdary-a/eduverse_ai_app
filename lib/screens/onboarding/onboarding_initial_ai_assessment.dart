import 'package:flutter/material.dart';

import 'onboarding_assessment_in_progress.dart';

class OnboardingInitialAiAssessment extends StatefulWidget {
  const OnboardingInitialAiAssessment({super.key});

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

  void _startAssessment() {
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
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ================= SUBTITLE =================

                    const Text(
                      'A quick baseline assessment to personalize your AI mentors.',
                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Divider(color: Color(0xFFE9EDF0), height: 1),

                    const SizedBox(height: 24),

                    // ================= SECTION LABEL =================

                    const Text(
                      'Upcoming Module',
                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ================= GENERAL ASSESSMENT CARD =================

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: navy, width: 1.5),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF29B6D8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.quiz_outlined,
                                  color: Colors.white,
                                  size: 28,
                                ),
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
                                child: const Text(
                                  'Adaptive Level',
                                  style: TextStyle(
                                    color: navy,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            '3 Quick Questions',
                            style: TextStyle(
                              color: subtitleBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            'General Topics Assessment',
                            style: TextStyle(
                              color: navy,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            'General topic questions tailored according to your learning stage and class level.',
                            style: TextStyle(
                              color: subtitleBlue,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 16),

                          const Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                color: subtitleBlue,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                '~2 mins',
                                style: TextStyle(
                                  color: subtitleBlue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ================= SUMMARY ROW =================

                    Row(
                      children: const [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Duration',
                                style: TextStyle(
                                  color: subtitleBlue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '2 Minutes',
                                style: TextStyle(
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
                              Text(
                                'Questions',
                                style: TextStyle(
                                  color: subtitleBlue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '3 Total',
                                style: TextStyle(
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
                height: 58,
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