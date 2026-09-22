import 'package:flutter/material.dart';
import 'onboarding_conceptual_question.dart';

class OnboardingCodingTest extends StatefulWidget {
  final String skillLevel;
  final String? branch;
  final String? course;
  final int cognitiveScore;

  const OnboardingCodingTest({
    super.key,
    required this.skillLevel,
    this.branch,
    this.course,
    this.cognitiveScore = 0,
  });

  @override
  State<OnboardingCodingTest> createState() => _OnboardingCodingTestState();
}

class _OnboardingCodingTestState extends State<OnboardingCodingTest> {
  // ================= COLORS =================
  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color mastGreen = Color(0xFF33B679);
  static const Color trackGrey = Color(0xFFE9EDF0);
  static const Color panelGrey = Color(0xFFF8FAFB);

  int? _selectedOption;
  bool _checked = false;
  bool _isCorrect = false;

  // School-friendly, universally understandable visual puzzle
  final String _question = "What number comes next in this pattern?";
  final String _sequence = "3  ➔  6  ➔  9  ➔  12  ➔  ?";
  final List<String> _options = ["14", "15", "16", "18"];
  final int _correctIndex = 1; // 15

  void _checkAnswer() {
    if (_selectedOption == null) return;
    setState(() {
      _checked = true;
      _isCorrect = _selectedOption == _correctIndex;
    });
  }

  void _continue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OnboardingConceptualQuestion(
          skillLevel: widget.skillLevel,
          branch: widget.branch,
          course: widget.course,
          runningScore: widget.cognitiveScore + (_isCorrect ? 1 : 0),
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
            // ================= TOP BAR =================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Logic & Thinking Challenge',
                          style: TextStyle(
                            color: navy,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.skillLevel} Level • Problem Solving',
                          style: const TextStyle(
                            color: subtitleBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: panelGrey,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: trackGrey),
                    ),
                    child: const Text(
                      'Stage 2/3',
                      style: TextStyle(
                        color: navy,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: trackGrey, height: 1),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= QUESTION CARD =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: navy, width: 1.4),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0F000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: brandRed,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.psychology_outlined,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  _question,
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // PATTERN DISPLAY
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: panelGrey,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: trackGrey),
                            ),
                            child: Center(
                              child: Text(
                                _sequence,
                                style: const TextStyle(
                                  color: navy,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= OPTIONS =================
                    const Text(
                      'Select the correct answer:',
                      style: TextStyle(
                        color: navy,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 14),

                    ...List.generate(_options.length, (index) {
                      final isSelected = _selectedOption == index;
                      final isThisCorrect = _checked && index == _correctIndex;
                      final isThisWrong = _checked && isSelected && !_isCorrect;

                      Color borderColor = trackGrey;
                      Color bgColor = Colors.white;

                      if (isThisCorrect) {
                        borderColor = mastGreen;
                        bgColor = const Color(0xFFE8F7EE);
                      } else if (isThisWrong) {
                        borderColor = brandRed;
                        bgColor = const Color(0xFFFDEBEC);
                      } else if (isSelected) {
                        borderColor = brandRed;
                        bgColor = const Color(0xFFFFF5F6);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            if (_checked) return;
                            setState(() {
                              _selectedOption = index;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: borderColor,
                                width: isSelected || isThisCorrect ? 2 : 1.2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? brandRed : subtitleBlue,
                                      width: 2,
                                    ),
                                    color: isSelected ? brandRed : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  _options[index],
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 12),

                    // CHECK ANSWER BUTTON
                    if (!_checked)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: _selectedOption != null ? _checkAnswer : null,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: _selectedOption != null ? brandRed : trackGrey,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Check Answer',
                            style: TextStyle(
                              color: _selectedOption != null ? brandRed : subtitleBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                    // FEEDBACK RESULT
                    if (_checked) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _isCorrect ? const Color(0xFFE8F7EE) : const Color(0xFFFDEBEC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _isCorrect ? mastGreen : brandRed,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isCorrect ? Icons.check_circle : Icons.cancel,
                              color: _isCorrect ? mastGreen : brandRed,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _isCorrect
                                    ? 'Great job! Pattern increases by +3 each step.'
                                    : 'Good try! Pattern increases by +3 (12 + 3 = 15).',
                                style: TextStyle(
                                  color: _isCorrect ? const Color(0xFF1B6B45) : brandRed,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ================= BOTTOM CONTINUE BUTTON =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: trackGrey, width: 1)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _checked ? _continue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _checked ? brandRed : trackGrey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue to Conceptual Question',
                        style: TextStyle(
                          color: _checked ? Colors.white : subtitleBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: _checked ? Colors.white : subtitleBlue,
                        size: 20,
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