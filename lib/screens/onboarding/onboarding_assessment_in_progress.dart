import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_coding_test.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

class OnboardingAssessmentInProgress extends StatefulWidget {
  final Duration initialTime;
  final String skillLevel;
  final String? branch;
  final String? course;

  const OnboardingAssessmentInProgress({
    super.key,
    this.initialTime = const Duration(minutes: 3, seconds: 0),
    this.skillLevel = 'Standard',
    this.branch,
    this.course,
  });

  @override
  State<OnboardingAssessmentInProgress> createState() =>
      _OnboardingAssessmentInProgressState();
}

class _OnboardingAssessmentInProgressState
    extends State<OnboardingAssessmentInProgress> {
  // Sir's Brand Design Colors
  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color brandGradientEnd = Color(0xFFF12C68);
  static const Color mastGreen = Color(0xFF12B76A);
  static const Color textMuted = Color(0xFF667085);
  static const Color cardBorder = Color(0xFFE4E7EC);

  static const List<QuizQuestion> _questionBank = [
    QuizQuestion(
      question:
          'Which principle explains why a spinning ice skater pulls their arms in to rotate faster?',
      options: [
        'Conservation of Linear Momentum',
        'Conservation of Angular Momentum',
        "Newton's Third Law of Motion",
        'Centripetal Force Acceleration',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Angular momentum stays constant when no net outside torque acts. Pulling the arms in reduces the skater\'s moment of inertia, so angular velocity increases.',
    ),
    QuizQuestion(
      question: 'What is the SI unit of electric current?',
      options: ['Volt', 'Ohm', 'Ampere', 'Watt'],
      correctAnswerIndex: 2,
      explanation:
          'Current is measured in Amperes (A) — it measures the rate of charge flow past a given point.',
    ),
    QuizQuestion(
      question: 'Which data structure follows FIFO (First In, First Out) ordering?',
      options: ['Stack', 'Queue', 'Tree', 'Graph'],
      correctAnswerIndex: 1,
      explanation:
          'A Queue adds elements at the tail and removes from the head, ensuring the earliest inserted element is dequeued first.',
    ),
  ];

  int get _totalQuestions => _questionBank.length;
  int _currentIndex = 0;
  late List<int?> _selectedAnswers;
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _selectedAnswers = List<int?>.filled(_totalQuestions, null);
    _remaining = widget.initialTime;
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onTick(Timer timer) {
    if (_remaining.inSeconds <= 0) {
      timer.cancel();
      return;
    }
    setState(() {
      _remaining = _remaining - const Duration(seconds: 1);
    });
  }

  QuizQuestion get _currentQuestion => _questionBank[_currentIndex];
  bool get _hasAnswered => _selectedAnswers[_currentIndex] != null;
  bool get _isCorrect =>
      _selectedAnswers[_currentIndex] == _currentQuestion.correctAnswerIndex;

  int get _correctCount {
    var count = 0;
    for (var i = 0; i < _questionBank.length; i++) {
      if (_selectedAnswers[i] == _questionBank[i].correctAnswerIndex) {
        count++;
      }
    }
    return count;
  }

  double get _progress => (_currentIndex + 1) / _totalQuestions;

  String get _formattedTime {
    final minutes =
        _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _selectOption(int optionIndex) {
    if (_hasAnswered) return;
    setState(() {
      _selectedAnswers[_currentIndex] = optionIndex;
    });
  }

  void _goToPrevious() {
    if (_currentIndex == 0) return;
    setState(() {
      _currentIndex -= 1;
    });
  }

  void _goToNext() {
    if (_currentIndex >= _totalQuestions - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OnboardingCodingTest(
            skillLevel: widget.skillLevel,
            branch: widget.branch,
            course: widget.course,
            cognitiveScore: _correctCount,
          ),
        ),
      );
      return;
    }
    setState(() {
      _currentIndex += 1;
    });
  }

  void _showHint() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sophia AI Hint: Focus on rotational motion & physics conservation principles!'),
        backgroundColor: navy,
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
          icon: const Icon(Icons.close, color: navy, size: 22),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_outlined, color: brandRed, size: 16),
              const SizedBox(width: 6),
              Text(
                _formattedTime,
                style: const TextStyle(
                  color: brandRed,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.outlined_flag_rounded, color: textMuted, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question Counter & Progress
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question ${_currentIndex + 1} of $_totalQuestions',
                          style: const TextStyle(
                            color: navy,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${(_progress * 100).round()}% Completed',
                          style: const TextStyle(
                            color: textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 5,
                        backgroundColor: const Color(0xFFF2F4F7),
                        valueColor: const AlwaysStoppedAnimation<Color>(brandRed),
                      ),
                    ),
                    const SizedBox(height: 20),

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
                      child: Text(
                        _currentQuestion.question,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Option Cards
                    ...List.generate(_currentQuestion.options.length, (i) {
                      final selected = _selectedAnswers[_currentIndex] == i;
                      final isCorrectOption =
                          i == _currentQuestion.correctAnswerIndex;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _OptionTile(
                          label: _currentQuestion.options[i],
                          selected: selected,
                          revealed: _hasAnswered,
                          isCorrectOption: isCorrectOption,
                          onTap: () => _selectOption(i),
                        ),
                      );
                    }),

                    // Sophia's Explanation Card
                    if (_hasAnswered) ...[
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: _isCorrect ? mastGreen : brandRed,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isCorrect ? Icons.check : Icons.close_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _isCorrect ? 'Correct! — Sophia AI' : "Sophia's Explanation",
                                    style: TextStyle(
                                      color: _isCorrect ? const Color(0xFF027A48) : brandRed,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _currentQuestion.explanation,
                                    style: const TextStyle(
                                      color: Color(0xFF344054),
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
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Row
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFF2F4F7), width: 1)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _showHint,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9E6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFDECC8)),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline,
                        color: Color(0xFFF4A100),
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  if (_currentIndex > 0) ...[
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _goToPrevious,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: cardBorder),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Previous',
                            style: TextStyle(
                              color: navy,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],

                  Expanded(
                    flex: 6,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: _hasAnswered
                            ? const LinearGradient(
                                colors: [brandRed, brandGradientEnd],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                            : null,
                        color: _hasAnswered ? null : const Color(0xFFF2F4F7),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: _hasAnswered
                            ? [
                                BoxShadow(
                                  color: brandRed.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: ElevatedButton(
                        onPressed: _hasAnswered ? _goToNext : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          disabledBackgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentIndex >= _totalQuestions - 1 ? 'Continue' : 'Next Question',
                              style: TextStyle(
                                color: _hasAnswered ? Colors.white : const Color(0xFF98A2B3),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: _hasAnswered ? Colors.white : const Color(0xFF98A2B3),
                              size: 16,
                            ),
                          ],
                        ),
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

class _OptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final bool revealed;
  final bool isCorrectOption;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.selected,
    required this.revealed,
    required this.isCorrectOption,
    required this.onTap,
  });

  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color mastGreen = Color(0xFF12B76A);
  static const Color cardBorder = Color(0xFFE4E7EC);

  Color get _bgColor {
    if (!revealed) return selected ? const Color(0xFFFFF0F2) : Colors.white;
    if (isCorrectOption) return const Color(0xFFF6FEF9);
    if (selected) return const Color(0xFFFFF0F2);
    return Colors.white;
  }

  Color get _borderColor {
    if (!revealed) return selected ? brandRed : cardBorder;
    if (isCorrectOption) return mastGreen;
    if (selected) return brandRed;
    return cardBorder;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: revealed ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _borderColor,
            width: selected || (revealed && isCorrectOption) ? 1.8 : 1.0,
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
                color: revealed && isCorrectOption
                    ? mastGreen
                    : (selected ? brandRed : Colors.transparent),
                border: Border.all(
                  color: revealed && isCorrectOption
                      ? mastGreen
                      : (selected ? brandRed : cardBorder),
                  width: 2,
                ),
              ),
              child: revealed && isCorrectOption
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : (selected && revealed && !isCorrectOption
                      ? const Icon(Icons.close, color: Colors.white, size: 14)
                      : (selected
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
                          : null)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: revealed && isCorrectOption
                      ? const Color(0xFF027A48)
                      : (selected && revealed && !isCorrectOption
                          ? brandRed
                          : (selected ? brandRed : navy)),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}