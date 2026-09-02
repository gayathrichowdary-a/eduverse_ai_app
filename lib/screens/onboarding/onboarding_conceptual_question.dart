import 'package:flutter/material.dart';
import 'onboarding_assessment_complete.dart';

// ============================================================
// SCREEN
// ============================================================

/// Final "conceptual thinking" stage of the Sophia assessment — separate
/// from the 3 cognitive/analytical MCQs and the coding test.
///
/// Per the spec: "After you compile you could proceed to the Conceptual
/// Question part... After submitting the Conceptual Thinking Question
/// answer, Sophia will show you your whole interview report" — which is
/// [AssessmentComplete], where the <50 / 50-80 / >80 score-tier routing
/// (Beginner / Intermediate / Advanced roadmap) happens.
class OnboardingConceptualQuestion extends StatefulWidget {
  final String skillLevel;
  final String? branch;
  final String? course;

  /// Score accumulated from the 3 cognitive questions + coding test,
  /// out of [runningScoreTotal], so it can be combined with this
  /// question's result before handing off to AssessmentComplete for
  /// the final tier decision.
  final int runningScore;
  final int runningScoreTotal;

  const OnboardingConceptualQuestion({
    Key? key,
    required this.skillLevel,
    this.branch,
    this.course,
    this.runningScore = 0,
    this.runningScoreTotal = 18,
  }) : super(key: key);

  @override
  State<OnboardingConceptualQuestion> createState() =>
      _OnboardingConceptualQuestionState();
}

class _OnboardingConceptualQuestionState
    extends State<OnboardingConceptualQuestion> {
  // ================= COLORS =================

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color trackGrey = Color(0xFFE9EDF0);
  static const Color panelGrey = Color(0xFFF5F7F8);

  static const String _question =
      'Design a rate limiter for a public API. Walk through your '
      'approach and the trade-offs of the algorithm you chose.';

  final TextEditingController _answerController = TextEditingController();
  bool _submitting = false;

  bool get _canSubmit => _answerController.text.trim().length >= 20;

  Future<void> _submit() async {
    if (!_canSubmit || _submitting) return;

    setState(() => _submitting = true);

    // TODO: send widget.skillLevel/branch/course + the answer text to
    // Sophia's grading endpoint and fold the returned score into
    // widget.runningScore before navigating. A short delay simulates
    // that grading round-trip for now.
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    // Rough placeholder scoring: a substantive answer earns full marks
    // for this stage until real grading is wired up.
    final conceptualScore =
        _answerController.text.trim().length >= 80 ? 4 : 2;
    final finalScore =
        (widget.runningScore + conceptualScore).clamp(0, widget.runningScoreTotal);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AssessmentComplete(
          score: finalScore,
          totalScore: widget.runningScoreTotal,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ================= TOP BAR =================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Conceptual Question',
                          style: TextStyle(
                            color: navy,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.skillLevel} Assessment • Final Step',
                          style: const TextStyle(
                            color: subtitleBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
                    // ================= SOPHIA PROMPT CARD =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: brandRed,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome,
                                  color: Colors.white, size: 22),
                              const SizedBox(width: 8),
                              const Text(
                                'Sophia asks',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            _question,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Your Answer',
                      style: TextStyle(
                        color: navy,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ================= ANSWER FIELD =================
                    Container(
                      decoration: BoxDecoration(
                        color: panelGrey,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: trackGrey, width: 1.2),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _answerController,
                        maxLines: 8,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(
                          color: navy,
                          fontSize: 15,
                          height: 1.5,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: 'Explain your reasoning in your own '
                              'words — there are no wrong angles here, '
                              'Sophia is looking at how you think.',
                          hintStyle: TextStyle(
                            color: subtitleBlue,
                            fontSize: 14,
                          ),
                        ),
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
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: trackGrey, width: 1)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: (_canSubmit && !_submitting) ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canSubmit ? brandRed : trackGrey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Submit & View Report',
                              style: TextStyle(
                                color:
                                    _canSubmit ? Colors.white : subtitleBlue,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded,
                                color:
                                    _canSubmit ? Colors.white : subtitleBlue,
                                size: 20),
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