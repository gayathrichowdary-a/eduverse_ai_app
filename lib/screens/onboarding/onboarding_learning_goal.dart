import 'package:flutter/material.dart';
import 'onboarding_learning_style.dart';

class OnboardingLearningGoal extends StatefulWidget {
  const OnboardingLearningGoal({super.key});

  @override
  State<OnboardingLearningGoal> createState() =>
      _OnboardingLearningGoalState();
}

class _OnboardingLearningGoalState extends State<OnboardingLearningGoal> {
  // ================= COLORS =================

  static const Color navy = Color(0xFF1D3B64);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFEF3340);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // =====================================================
            // SCROLLABLE CONTENT
            // =====================================================

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),

                padding: const EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  24,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // ================= TITLE =================

                    const Text(
                      'What is your goal?',

                      style: TextStyle(
                        color: navy,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ================= SUBTITLE =================

                    const Text(
                      'EduVerse AI will personalize your learning path based on your choice.',

                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 16,
                        height: 1.35,
                      ),
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

              padding: const EdgeInsets.fromLTRB(
                24,
                20,
                24,
                24,
              ),

              decoration: const BoxDecoration(
                color: Colors.white,

                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE9EDF0),
                    width: 1,
                  ),
                ),
              ),

              child: SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton(
                  onPressed: _continue,

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
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),

                      SizedBox(width: 10),

                      Text(
                        'Continue',

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

  // ============================================================
  // CONTINUE
  // ============================================================

  void _continue() {
    FocusScope.of(context).unfocus();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingLearningStyle(),
      ),
    );
  }
}