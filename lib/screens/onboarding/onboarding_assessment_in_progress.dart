import 'dart:async';
import 'package:flutter/material.dart';

import 'onboarding_coding_test.dart';

// ============================================================
// MODEL
// ============================================================

class QuizQuestion {
  final String question;
  final List<String> options;

  /// Index into [options] that is correct.
  final int correctAnswerIndex;

  /// Sophia's (AI mentor) explanation shown after the student answers,
  /// regardless of whether they got it right.
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

// ============================================================
// ONBOARDING ASSESSMENT IN PROGRESS
// ============================================================
//
// SCOPE CHANGE:
// This screen used to hold a 45-question bank. It has been
// shrunk to a fixed 3-question warm-up assessment. The coding
// and conceptual-question stages that used to live inside this
// flow are no longer handled here — they're their own screens
// (onboarding_coding_test.dart / onboarding_conceptual_question.dart)
// and are navigated to separately.
// ============================================================

class OnboardingAssessmentInProgress extends StatefulWidget {
  /// Countdown duration for the whole assessment.
  final Duration initialTime;

  /// Forwarded to OnboardingCodingTest, which requires a skillLevel.
  /// Defaults to 'Standard' since callers built before the coding-test
  /// stage existed don't pass one.
  final String skillLevel;
  final String? branch;
  final String? course;

  const OnboardingAssessmentInProgress({
    Key? key,
    this.initialTime = const Duration(minutes: 3, seconds: 0),
    this.skillLevel = 'Standard',
    this.branch,
    this.course,
  }) : super(key: key);

  @override
  State<OnboardingAssessmentInProgress> createState() =>
      _OnboardingAssessmentInProgressState();
}

// ============================================================
// STATE
// ============================================================

class _OnboardingAssessmentInProgressState
    extends State<OnboardingAssessmentInProgress> {
  // ================= COLORS =================

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color mastGreen = Color(0xFF1F8A56);
  static const Color trackGrey = Color(0xFFE9EDF0);
  static const Color hintYellowBg = Color(0xFFFDECC8);
  static const Color hintYellowIcon = Color(0xFFF4A100);
  static const Color explanationBg = Color(0xFFE7E9FB);

  // ============================================================
  // FIXED 3-QUESTION BANK
  // ============================================================

  static const List<QuizQuestion> _questionBank = [
    QuizQuestion(
      question:
          'Which of the following principles explains why a spinning ice '
          'skater pulls their arms in to rotate faster?',
      options: [
        'Conservation of Linear Momentum',
        'Conservation of Angular Momentum',
        "Newton's Third Law of Motion",
        'Centripetal Force Acceleration',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Angular momentum stays constant when no outside force acts. '
          'Pulling the arms in reduces the skater\'s radius, so their '
          'rotation speed increases to balance it out.',
    ),
    QuizQuestion(
      question: 'What is the SI unit of electric current?',
      options: ['Volt', 'Ohm', 'Ampere', 'Watt'],
      correctAnswerIndex: 2,
      explanation:
          'Current is measured in Amperes (A) — it tells us how much '
          'charge flows past a point every second.',
    ),
    QuizQuestion(
      question: 'Which data structure uses FIFO (First In, First Out) order?',
      options: ['Stack', 'Queue', 'Tree', 'Graph'],
      correctAnswerIndex: 1,
      explanation:
          'A Queue adds items at the back and removes them from the '
          'front, so the first item in is always the first one out.',
    ),
  ];

  // ============================================================
  // STATE VARIABLES
  // ============================================================

  int get _totalQuestions => _questionBank.length;

  int _currentIndex = 0;

  late List<int?> _selectedAnswers;

  late Timer _timer;

  late Duration _remaining;

  // ============================================================
  // INIT STATE
  // ============================================================

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

  // ============================================================
  // TIMER
  // ============================================================

  void _onTick(Timer timer) {
    if (_remaining.inSeconds <= 0) {
      timer.cancel();
      return;
    }

    setState(() {
      _remaining = _remaining - const Duration(seconds: 1);
    });
  }

  // ============================================================
  // CURRENT QUESTION
  // ============================================================

  QuizQuestion get _currentQuestion => _questionBank[_currentIndex];

  bool get _hasAnswered => _selectedAnswers[_currentIndex] != null;

  bool get _isCorrect =>
      _selectedAnswers[_currentIndex] == _currentQuestion.correctAnswerIndex;

  /// Running tally of correct answers across the 3-question bank, passed
  /// on to OnboardingCodingTest as its starting cognitiveScore.
  int get _correctCount {
    var count = 0;
    for (var i = 0; i < _questionBank.length; i++) {
      if (_selectedAnswers[i] == _questionBank[i].correctAnswerIndex) {
        count++;
      }
    }
    return count;
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  double get _progress => (_currentIndex + 1) / _totalQuestions;

  // ============================================================
  // FORMATTED TIME
  // ============================================================

  String get _formattedTime {
    final minutes =
        _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // ============================================================
  // SELECT ANSWER
  // ============================================================

  void _selectOption(int optionIndex) {
    // Lock the answer in once chosen for this question — selecting
    // reveals Sophia's explanation, so re-tapping shouldn't change it.
    if (_hasAnswered) return;

    setState(() {
      _selectedAnswers[_currentIndex] = optionIndex;
    });
  }

  // ============================================================
  // PREVIOUS QUESTION
  // ============================================================

  void _goToPrevious() {
    if (_currentIndex == 0) return;

    setState(() {
      _currentIndex -= 1;
    });
  }

  // ============================================================
  // NEXT QUESTION
  // ============================================================

  void _goToNext() {
    // On the last question, hand off to the coding-test stage.
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

  // ============================================================
  // HINT
  // ============================================================

  void _showHint() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hint feature will be available soon.'),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

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
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= TOP BAR =================

                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.close, color: navy, size: 26),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              _formattedTime,
                              style: const TextStyle(
                                color: brandRed,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            // Flag question feature.
                          },
                          icon: const Icon(
                            Icons.outlined_flag_rounded,
                            color: subtitleBlue,
                            size: 24,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ================= QUESTION NUMBER =================

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question ${_currentIndex + 1} of $_totalQuestions',
                          style: const TextStyle(
                            color: navy,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${(_progress * 100).round()}%',
                          style: const TextStyle(
                            color: subtitleBlue,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ================= PROGRESS BAR =================

                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 6,
                        backgroundColor: trackGrey,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(brandRed),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Divider(color: trackGrey, height: 1),

                    const SizedBox(height: 28),

                    // ================= QUESTION CARD =================

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: trackGrey, width: 1.4),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Text(
                        _currentQuestion.question,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= OPTIONS =================

                    ...List.generate(_currentQuestion.options.length, (i) {
                      final selected = _selectedAnswers[_currentIndex] == i;
                      final isCorrectOption =
                          i == _currentQuestion.correctAnswerIndex;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _OptionTile(
                          label: _currentQuestion.options[i],
                          selected: selected,
                          revealed: _hasAnswered,
                          isCorrectOption: isCorrectOption,
                          onTap: () => _selectOption(i),
                        ),
                      );
                    }),

                    // ================= SOPHIA'S EXPLANATION =================

                    if (_hasAnswered)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: explanationBg,
                          borderRadius: BorderRadius.circular(16),
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
                                _isCorrect
                                    ? Icons.check
                                    : Icons.close_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _isCorrect
                                        ? 'Correct! — Sophia'
                                        : "Not quite — Sophia",
                                    style: const TextStyle(
                                      color: navy,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _currentQuestion.explanation,
                                    style: const TextStyle(
                                      color: subtitleBlue,
                                      fontSize: 14,
                                      height: 1.35,
                                      fontWeight: FontWeight.w500,
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

            // ================= BOTTOM SECTION =================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: trackGrey, width: 1)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _showHint,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: hintYellowBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lightbulb,
                        color: hintYellowIcon,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: _currentIndex == 0 ? null : _goToPrevious,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          side: const BorderSide(color: navy, width: 1.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          'Previous',
                          style: TextStyle(
                            color: navy,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        // Require an answer before moving on, since the
                        // explanation is part of the learning loop.
                        onPressed: _hasAnswered ? _goToNext : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandRed,
                          disabledBackgroundColor: trackGrey,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentIndex >= _totalQuestions - 1
                                    ? 'Continue'
                                    : 'Next Question',
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
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

// ============================================================
// OPTION TILE
// ============================================================

class _OptionTile extends StatelessWidget {
  final String label;
  final bool selected;

  /// True once the student has answered this question — used to
  /// reveal correct/incorrect styling on all options.
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

  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color mastGreen = Color(0xFF1F8A56);
  static const Color unselectedGrey = Color(0xFFC9D2D8);

  Color get _indicatorColor {
    if (!revealed) return selected ? brandRed : Colors.white;
    if (isCorrectOption) return mastGreen;
    if (selected) return brandRed;
    return Colors.white;
  }

  Color get _borderColor {
    if (!revealed) return selected ? brandRed : unselectedGrey;
    if (isCorrectOption) return mastGreen;
    if (selected) return brandRed;
    return unselectedGrey;
  }

  IconData? get _icon {
    if (!revealed) return selected ? Icons.circle : null;
    if (isCorrectOption) return Icons.check;
    if (selected) return Icons.close_rounded;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Lock answers once revealed — tapping does nothing after that.
      onTap: revealed ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _indicatorColor,
              border: Border.all(color: _borderColor, width: 2),
            ),
            child: _icon == null
                ? null
                : Center(
                    child: Icon(
                      _icon,
                      color: (!revealed) ? Colors.white : Colors.white,
                      size: _icon == Icons.circle ? 8 : 14,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                decoration: revealed && !isCorrectOption && selected
                    ? TextDecoration.none
                    : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}