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
  // Sir's Brand Design Colors
  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color brandGradientEnd = Color(0xFFF12C68);
  static const Color mastGreen = Color(0xFF12B76A);
  static const Color textMuted = Color(0xFF667085);
  static const Color cardBorder = Color(0xFFE4E7EC);

  int? _selectedOption;
  bool _checked = false;
  bool _isCorrect = false;

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Logic & Thinking Challenge',
                    style: TextStyle(
                      color: navy,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${widget.skillLevel} Level • Problem Solving',
                    style: const TextStyle(
                      color: textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Stage 2/3',
                style: TextStyle(
                  color: navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: cardBorder),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: brandRed,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.psychology_outlined,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _question,
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Pattern Display Banner
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: cardBorder),
                            ),
                            child: Center(
                              child: Text(
                                _sequence,
                                style: const TextStyle(
                                  color: navy,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Options Label
                    const Text(
                      'Select the correct answer:',
                      style: TextStyle(
                        color: navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Options Grid/List
                    ...List.generate(_options.length, (index) {
                      final isSelected = _selectedOption == index;
                      final isThisCorrect = _checked && index == _correctIndex;
                      final isThisWrong = _checked && isSelected && !_isCorrect;

                      Color borderColor = cardBorder;
                      Color bgColor = Colors.white;

                      if (isThisCorrect) {
                        borderColor = mastGreen;
                        bgColor = const Color(0xFFF6FEF9);
                      } else if (isThisWrong) {
                        borderColor = brandRed;
                        bgColor = const Color(0xFFFFF0F2);
                      } else if (isSelected) {
                        borderColor = brandRed;
                        bgColor = const Color(0xFFFFF0F2);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            if (_checked) return;
                            setState(() {
                              _selectedOption = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: borderColor,
                                width: isSelected || isThisCorrect ? 1.8 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isThisCorrect
                                          ? mastGreen
                                          : (isSelected ? brandRed : cardBorder),
                                      width: 2,
                                    ),
                                    color: isThisCorrect
                                        ? mastGreen
                                        : (isSelected ? brandRed : Colors.transparent),
                                  ),
                                  child: isThisCorrect
                                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                                      : (isSelected
                                          ? Center(
                                              child: Container(
                                                width: 8,
                                                height: 8,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          : null),
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  _options[index],
                                  style: TextStyle(
                                    color: isThisCorrect
                                        ? const Color(0xFF027A48)
                                        : (isThisWrong ? brandRed : navy),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),

                    // Check Answer Button
                    if (!_checked)
                      Container(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: _selectedOption != null ? _checkAnswer : null,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: _selectedOption != null ? brandRed : cardBorder,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Check Answer',
                            style: TextStyle(
                              color: _selectedOption != null ? brandRed : textMuted,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                    // Feedback Box
                    if (_checked) ...[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _isCorrect ? const Color(0xFFF6FEF9) : const Color(0xFFFFF0F2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _isCorrect ? const Color(0xFFB4F3D0) : const Color(0xFFFECDCA),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isCorrect ? Icons.check_circle : Icons.cancel,
                              color: _isCorrect ? mastGreen : brandRed,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _isCorrect
                                    ? 'Great job! Pattern increases by +3 each step (12 + 3 = 15).'
                                    : 'Good try! Pattern increases by +3 each step (12 + 3 = 15).',
                                style: TextStyle(
                                  color: _isCorrect ? const Color(0xFF027A48) : brandRed,
                                  fontSize: 13,
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

            // Bottom Continue Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFF2F4F7), width: 1)),
              ),
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: _checked
                      ? const LinearGradient(
                          colors: [brandRed, brandGradientEnd],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                  color: _checked ? null : const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _checked
                      ? [
                          BoxShadow(
                            color: brandRed.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: ElevatedButton(
                  onPressed: _checked ? _continue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue to Conceptual Question',
                        style: TextStyle(
                          color: _checked ? Colors.white : const Color(0xFF98A2B3),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: _checked ? Colors.white : const Color(0xFF98A2B3),
                        size: 18,
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