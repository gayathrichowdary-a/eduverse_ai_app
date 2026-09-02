import 'package:flutter/material.dart';

// ============================================================
// MODELS
// ============================================================

class AssessmentQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String subject;

  const AssessmentQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.subject,
  });
}

// ============================================================
// SCREEN
// ============================================================

class AIAssessment extends StatefulWidget {
  final String studentName;
  final List<AssessmentQuestion> questions;

  const AIAssessment({
    Key? key,
    this.studentName = 'Arjun',
    this.questions = const [
      AssessmentQuestion(
        subject: 'Physics',
        question: 'What is the SI unit of electric current?',
        options: ['Volt', 'Ampere', 'Ohm', 'Watt'],
        correctIndex: 1,
      ),
      AssessmentQuestion(
        subject: 'Physics',
        question: 'Which law states that force equals mass times acceleration?',
        options: [
          "Newton's First Law",
          "Newton's Second Law",
          "Newton's Third Law",
          "Law of Gravitation",
        ],
        correctIndex: 1,
      ),
      AssessmentQuestion(
        subject: 'Mathematics',
        question: 'What is the derivative of sin(x)?',
        options: ['cos(x)', '-cos(x)', 'sin(x)', '-sin(x)'],
        correctIndex: 0,
      ),
      AssessmentQuestion(
        subject: 'Mathematics',
        question: 'What is the value of log(1)?',
        options: ['1', '0', 'Undefined', '-1'],
        correctIndex: 1,
      ),
      AssessmentQuestion(
        subject: 'Chemistry',
        question: 'What is the atomic number of Carbon?',
        options: ['6', '8', '12', '14'],
        correctIndex: 0,
      ),
    ],
  }) : super(key: key);

  @override
  State<AIAssessment> createState() => _AIAssessmentState();
}

class _AIAssessmentState extends State<AIAssessment> {
  // ================= COLORS =================
  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color mastGreen = Color(0xFF33B679);
  static const Color mustard = Color(0xFFF4C10F);
  static const Color trackGrey = Color(0xFFE9EDF0);
  static const Color streakBlue = Color(0xFF6FCBEA);

  int _currentIndex = 0;
  int? _selectedOption;
  bool _answered = false;
  int _score = 0;
  bool _finished = false;

  // FIXED ERROR 1: Added safety check for empty list to prevent crash
  AssessmentQuestion get _currentQuestion => widget.questions.isNotEmpty 
      ? widget.questions[_currentIndex] 
      : const AssessmentQuestion(question: '', options: [], correctIndex: 0, subject: '');

  void _selectOption(int index) {
    if (_answered) return;
    setState(() {
      _selectedOption = index;
      _answered = true;
      if (index == _currentQuestion.correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered = false;
      });
    } else {
      setState(() {
        _finished = true;
      });
    }
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _selectedOption = null;
      _answered = false;
      _score = 0;
      _finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Safety check if questions are missing
    if (widget.questions.isEmpty) {
      return const Scaffold(body: Center(child: Text("No questions available.")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _finished ? _buildResultView() : _buildQuestionView(),
      ),
    );
  }

  // ============================================================
  // QUESTION VIEW
  // ============================================================

  Widget _buildQuestionView() {
    final progress = (_currentIndex + 1) / widget.questions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ================= HEADER =================
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Row(
            children: [
              IconButton(
                // FIXED ERROR 3: Added maybePop for safer navigation
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: navy, size: 20),
              ),
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  'AI Assessment',
                  style: TextStyle(
                    color: navy,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: streakBlue.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _currentQuestion.subject,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ================= PROGRESS =================
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: trackGrey,
                  valueColor: const AlwaysStoppedAnimation<Color>(brandRed),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Question ${_currentIndex + 1} of ${widget.questions.length}',
                style: const TextStyle(
                  color: subtitleBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ================= QUESTION + OPTIONS =================
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: mustard,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.auto_awesome,
                            color: navy, size: 18),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          _currentQuestion.question,
                          style: const TextStyle(
                            color: navy,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                ...List.generate(_currentQuestion.options.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _OptionTile(
                      text: _currentQuestion.options[index],
                      state: _optionState(index),
                      onTap: () => _selectOption(index),
                    ),
                  );
                }),

                if (_answered) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (_selectedOption == _currentQuestion.correctIndex)
                          ? mastGreen.withOpacity(0.12)
                          : brandRed.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          (_selectedOption == _currentQuestion.correctIndex)
                              ? Icons.check_circle_rounded
                              : Icons.info_rounded,
                          color: (_selectedOption == _currentQuestion.correctIndex)
                              ? mastGreen
                              : brandRed,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            (_selectedOption == _currentQuestion.correctIndex)
                                ? 'Correct! Nicely done.'
                                : 'Correct answer: ${_currentQuestion.options[_currentQuestion.correctIndex]}',
                            style: const TextStyle(
                              color: navy,
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

        // ================= NEXT BUTTON =================
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _answered ? _nextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: brandRed,
                disabledBackgroundColor: trackGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                _currentIndex == widget.questions.length - 1
                    ? 'Finish Assessment'
                    : 'Next Question',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _OptionState _optionState(int index) {
    if (!_answered) {
      return _selectedOption == index ? _OptionState.selected : _OptionState.idle;
    }
    if (index == _currentQuestion.correctIndex) {
      return _OptionState.correct;
    }
    if (index == _selectedOption) {
      return _OptionState.incorrect;
    }
    return _OptionState.disabled;
  }

  // ============================================================
  // RESULT VIEW
  // ============================================================

  Widget _buildResultView() {
    final total = widget.questions.length;
    // FIXED ERROR 2: Handle division by zero
    final percent = total > 0 ? ((_score / total) * 100).round() : 0;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: streakBlue,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$percent%',
              style: const TextStyle(
                color: navy,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Assessment Complete!',
            style: TextStyle(
              color: navy,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You got $_score out of $total questions correct.',
            style: const TextStyle(
              color: subtitleBlue,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _restart,
              style: ElevatedButton.styleFrom(
                backgroundColor: brandRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Retake Assessment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).maybePop(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: trackGrey, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Back to Dashboard',
                style: TextStyle(
                  color: navy,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// OPTION TILE
// ============================================================

enum _OptionState { idle, selected, correct, incorrect, disabled }

class _OptionTile extends StatelessWidget {
  final String text;
  final _OptionState state;
  final VoidCallback onTap;

  const _OptionTile({
    required this.text,
    required this.state,
    required this.onTap,
  });

  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color mastGreen = Color(0xFF33B679);
  static const Color trackGrey = Color(0xFFE9EDF0);

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color bgColor;
    IconData? trailingIcon;
    Color? trailingColor;

    switch (state) {
      case _OptionState.idle:
        borderColor = trackGrey;
        bgColor = Colors.white;
        break;
      case _OptionState.selected:
        borderColor = brandRed;
        bgColor = brandRed.withOpacity(0.06);
        break;
      case _OptionState.correct:
        borderColor = mastGreen;
        bgColor = mastGreen.withOpacity(0.10);
        trailingIcon = Icons.check_circle_rounded;
        trailingColor = mastGreen;
        break;
      case _OptionState.incorrect:
        borderColor = brandRed;
        bgColor = brandRed.withOpacity(0.08);
        trailingIcon = Icons.cancel_rounded;
        trailingColor = brandRed;
        break;
      case _OptionState.disabled:
        borderColor = trackGrey;
        bgColor = Colors.white;
        break;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: navy,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (trailingIcon != null)
              Icon(trailingIcon, color: trailingColor, size: 22),
          ],
        ),
      ),
    );
  }
}