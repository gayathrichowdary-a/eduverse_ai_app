import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_assessment_complete.dart';

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
  final String? selectedClass;

  /// Global holder so any previous screen can easily set the class
  static String activeClassCategory = '6th–10th Class';

  const OnboardingAssessmentInProgress({
    super.key,
    this.initialTime = const Duration(minutes: 3, seconds: 0),
    this.skillLevel = 'Standard',
    this.branch,
    this.course,
    this.selectedClass,
  });

  @override
  State<OnboardingAssessmentInProgress> createState() =>
      _OnboardingAssessmentInProgressState();
}

class _OnboardingAssessmentInProgressState
    extends State<OnboardingAssessmentInProgress> {
  // Sir's Brand Colors
  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color brandGradientEnd = Color(0xFFF12C68);
  static const Color mastGreen = Color(0xFF12B76A);
  static const Color textMuted = Color(0xFF667085);
  static const Color cardBorder = Color(0xFFE4E7EC);

  // ============================================================
  // QUESTION BANKS BY CLASS CATEGORY
  // ============================================================

  static const Map<String, List<QuizQuestion>> _classQuestionBanks = {
    // 1st–5th Class
    '1st–5th Class': [
      QuizQuestion(
        question: 'What is 5 + 3?',
        options: ['6', '7', '8', '9'],
        correctAnswerIndex: 2, // 8
        explanation: '5 plus 3 equals 8.',
      ),
      QuizQuestion(
        question: 'Which animal is known as the “King of the Jungle”?',
        options: ['Elephant', 'Lion', 'Tiger', 'Horse'],
        correctAnswerIndex: 1, // Lion
        explanation: 'The lion is traditionally called the King of the Jungle.',
      ),
      QuizQuestion(
        question: 'How many days are there in one week?',
        options: ['5', '6', '7', '8'],
        correctAnswerIndex: 2, // 7
        explanation: 'There are 7 days in a week.',
      ),
    ],

    // 6th–10th Class
    '6th–10th Class': [
      QuizQuestion(
        question: 'What is the value of 12 × 5?',
        options: ['50', '60', '70', '80'],
        correctAnswerIndex: 1, // 60
        explanation: '12 multiplied by 5 equals 60.',
      ),
      QuizQuestion(
        question: 'Which planet is known as the Red Planet?',
        options: ['Earth', 'Venus', 'Mars', 'Jupiter'],
        correctAnswerIndex: 2, // Mars
        explanation: 'Mars is called the Red Planet due to iron oxide on its surface.',
      ),
      QuizQuestion(
        question: 'What is the process by which plants make their food?',
        options: ['Respiration', 'Digestion', 'Photosynthesis', 'Transpiration'],
        correctAnswerIndex: 2, // Photosynthesis
        explanation: 'Photosynthesis is the process plants use to convert sunlight into food.',
      ),
    ],

    // 11th–12th Class
    '11th–12th Class': [
      QuizQuestion(
        question: 'What is the SI unit of force?',
        options: ['Joule', 'Watt', 'Newton', 'Pascal'],
        correctAnswerIndex: 2, // Newton
        explanation: 'The SI unit of force is the Newton (N).',
      ),
      QuizQuestion(
        question: 'If the value of x is 5, what is the value of 2x² + 3?',
        options: ['43', '50', '53', '58'],
        correctAnswerIndex: 2, // 53
        explanation: '2(5²) + 3 = 2(25) + 3 = 50 + 3 = 53.',
      ),
      QuizQuestion(
        question: 'Which part of the cell contains genetic material?',
        options: ['Cell wall', 'Nucleus', 'Cytoplasm', 'Ribosome'],
        correctAnswerIndex: 1, // Nucleus
        explanation: 'The cell nucleus contains DNA and genetic material.',
      ),
    ],

    // Undergraduate / College Students
    'Undergraduate / College Students': [
      QuizQuestion(
        question: 'Which data structure follows the LIFO principle?',
        options: ['Queue', 'Stack', 'Array', 'Linked List'],
        correctAnswerIndex: 1, // Stack
        explanation: 'A Stack follows the Last-In, First-Out (LIFO) principle.',
      ),
      QuizQuestion(
        question: 'What does CPU stand for?',
        options: [
          'Central Processing Unit',
          'Computer Processing Utility',
          'Central Program Unit',
          'Computer Primary Unit',
        ],
        correctAnswerIndex: 0, // Central Processing Unit
        explanation: 'CPU stands for Central Processing Unit.',
      ),
      QuizQuestion(
        question: 'Which of the following is an example of an operating system?',
        options: ['Python', 'MySQL', 'Linux', 'HTML'],
        correctAnswerIndex: 2, // Linux
        explanation: 'Linux is an operating system kernel.',
      ),
    ],

    // Postgraduate / Higher Studies
    'Postgraduate / Higher Studies': [
      QuizQuestion(
        question: 'What is the primary purpose of statistical analysis in research?',
        options: [
          'To design websites',
          'To interpret and analyze data',
          'To create computer hardware',
          'To write programming languages',
        ],
        correctAnswerIndex: 1, // To interpret and analyze data
        explanation: 'Statistical analysis helps researchers understand and interpret data.',
      ),
      QuizQuestion(
        question: 'Which research method primarily uses numerical data for analysis?',
        options: [
          'Qualitative research',
          'Quantitative research',
          'Historical research',
          'Narrative research',
        ],
        correctAnswerIndex: 1, // Quantitative research
        explanation: 'Quantitative research measures variables numerically.',
      ),
      QuizQuestion(
        question: 'What does AI stand for?',
        options: [
          'Automated Internet',
          'Artificial Intelligence',
          'Advanced Information',
          'Applied Integration',
        ],
        correctAnswerIndex: 1, // Artificial Intelligence
        explanation: 'AI stands for Artificial Intelligence.',
      ),
    ],

    // MBA / Management Students
    'MBA / Management Students': [
      QuizQuestion(
        question: 'What does ROI stand for?',
        options: [
          'Return on Investment',
          'Rate of Income',
          'Revenue on Investment',
          'Return on Income',
        ],
        correctAnswerIndex: 0, // Return on Investment
        explanation: 'ROI stands for Return on Investment.',
      ),
      QuizQuestion(
        question: 'Which of the following is a part of the 4Ps of marketing?',
        options: ['People', 'Product', 'Planning', 'Performance'],
        correctAnswerIndex: 1, // Product
        explanation: 'The 4Ps are Product, Price, Place, and Promotion.',
      ),
      QuizQuestion(
        question: 'What is the main purpose of SWOT analysis?',
        options: [
          'To calculate employee salaries',
          'To analyze strengths, weaknesses, opportunities, and threats',
          'To prepare financial statements',
          'To calculate market price',
        ],
        correctAnswerIndex: 1, // Strengths, weaknesses, etc.
        explanation: 'SWOT evaluates Strengths, Weaknesses, Opportunities, and Threats.',
      ),
    ],
  };

  String _resolveCategory(String? raw) {
    if (raw == null || raw.isEmpty) {
      return OnboardingAssessmentInProgress.activeClassCategory;
    }
    final lower = raw.toLowerCase();

    if (lower.contains('mba') ||
        lower.contains('management') ||
        lower.contains('bba') ||
        lower.contains('business')) {
      return 'MBA / Management Students';
    }
    if (lower.contains('post') ||
        lower.contains('pg') ||
        lower.contains('master') ||
        lower.contains('m.tech') ||
        lower.contains('phd') ||
        lower.contains('research')) {
      return 'Postgraduate / Higher Studies';
    }
    if (lower.contains('undergrad') ||
        lower.contains('ug') ||
        lower.contains('college') ||
        lower.contains('b.tech') ||
        lower.contains('b.sc') ||
        lower.contains('b.com') ||
        lower.contains('degree')) {
      return 'Undergraduate / College Students';
    }
    if (lower.contains('11') ||
        lower.contains('12') ||
        lower.contains('senior') ||
        lower.contains('inter')) {
      return '11th–12th Class';
    }
    if (lower.contains('1') ||
        lower.contains('2') ||
        lower.contains('3') ||
        lower.contains('4') ||
        lower.contains('5') ||
        lower.contains('primary') ||
        lower.contains('foundational')) {
      return '1st–5th Class';
    }
    return '6th–10th Class';
  }

  late final String _activeCategory;
  late final List<QuizQuestion> _questions;
  int _currentIndex = 0;
  final Map<int, int> _selectedAnswers = {};

  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _activeCategory = _resolveCategory(widget.selectedClass);
    _questions = _classQuestionBanks[_activeCategory] ??
        _classQuestionBanks['6th–10th Class']!;

    _remainingSeconds = widget.initialTime.inSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
        _submitAssessment();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _selectOption(int optionIndex) {
    setState(() {
      _selectedAnswers[_currentIndex] = optionIndex;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _submitAssessment();
    }
  }

  void _prevQuestion() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  // ============================================================
  // DIRECT TO ASSESSMENT COMPLETE (SKIPS CREATIVE QUESTION)
  // ============================================================
  void _submitAssessment() {
    _timer?.cancel();

    // Calculate score
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i].correctAnswerIndex) {
        score++;
      }
    }

    final int total = _questions.length;
    final int accuracy = ((score / total) * 100).round();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AssessmentComplete(
          score: score,
          totalScore: total,
          accuracyPercent: accuracy,
          subjectLabel: _activeCategory,
          unitLabel: 'Baseline Evaluation',
          masteryPercent: accuracy,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = _questions[_currentIndex];
    final selectedOption = _selectedAnswers[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assessment • $_activeCategory',
              style: const TextStyle(
                color: navy,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Question ${_currentIndex + 1} of ${_questions.length}',
              style: const TextStyle(
                color: textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 18),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFECDCA)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_outlined, color: brandRed, size: 16),
                const SizedBox(width: 4),
                Text(
                  _formatDuration(_remainingSeconds),
                  style: const TextStyle(
                    color: brandRed,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFF2F4F7),
              valueColor: const AlwaysStoppedAnimation<Color>(brandRed),
              minHeight: 4,
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: cardBorder),
                      ),
                      child: Text(
                        currentQ.question,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Choose the correct answer:',
                      style: TextStyle(
                        color: textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...List.generate(currentQ.options.length, (index) {
                      final optionText = currentQ.options[index];
                      final isSelected = selectedOption == index;
                      final optionLetters = ['A', 'B', 'C', 'D'];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => _selectOption(index),
                          borderRadius: BorderRadius.circular(14),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFFF0F2)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? brandRed : cardBorder,
                                width: isSelected ? 1.8 : 1.2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? brandRed
                                        : const Color(0xFFF2F4F7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      optionLetters[index],
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : navy,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    optionText,
                                    style: TextStyle(
                                      color: isSelected ? brandRed : navy,
                                      fontSize: 15,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: brandRed,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFF2F4F7), width: 1),
                ),
              ),
              child: Row(
                children: [
                  if (_currentIndex > 0) ...[
                    OutlinedButton(
                      onPressed: _prevQuestion,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: cardBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                      child: const Text(
                        'Previous',
                        style: TextStyle(
                          color: navy,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [brandRed, brandGradientEnd],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: brandRed.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: selectedOption != null ? _nextQuestion : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentIndex == _questions.length - 1
                                  ? 'View Evaluation Report'
                                  : 'Next Question',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
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
          ],
        ),
      ),
    );
  }
}