import 'package:flutter/material.dart';

// ============================================================
// MODELS
// ============================================================

class QuizItem {
  final String subject;
  final String title;
  final int questionCount;
  final String duration;
  final String difficulty;
  final Color accent;
  final IconData icon;
  final List<QuizQuestion> questions;

  const QuizItem({
    required this.subject,
    required this.title,
    required this.questionCount,
    required this.duration,
    required this.difficulty,
    required this.accent,
    required this.icon,
    required this.questions,
  });
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

// ============================================================
// QUIZ LIST SCREEN
// ============================================================

class QuizScreen extends StatelessWidget {
  final List<QuizItem> quizzes;

  const QuizScreen({
    super.key,
    this.quizzes = const [
      QuizItem(
        subject: 'Chemistry',
        title: 'Chemical Bonds Quiz',
        questionCount: 3,
        duration: '6 min',
        difficulty: 'Medium',
        accent: Color(0xFF33B679),
        icon: Icons.science,
        questions: [
          QuizQuestion(
            question: 'Which bond involves the sharing of electron pairs?',
            options: ['Ionic bond', 'Covalent bond', 'Metallic bond', 'Hydrogen bond'],
            correctIndex: 1,
          ),
          QuizQuestion(
            question: 'What holds ions together in an ionic bond?',
            options: [
              'Shared electrons',
              'Electrostatic attraction',
              'Magnetic force',
              'Gravitational pull'
            ],
            correctIndex: 1,
          ),
          QuizQuestion(
            question: 'Which of these is a diatomic molecule?',
            options: ['NaCl', 'O2', 'CaCO3', 'KOH'],
            correctIndex: 1,
          ),
        ],
      ),
      QuizItem(
        subject: 'Maths',
        title: 'Calculus Basics Quiz',
        questionCount: 3,
        duration: '8 min',
        difficulty: 'Hard',
        accent: Color(0xFFE8394A),
        icon: Icons.functions,
        questions: [
          QuizQuestion(
            question: 'What is the derivative of x²?',
            options: ['x', '2x', 'x²', '2x²'],
            correctIndex: 1,
          ),
          QuizQuestion(
            question: 'What does the integral of a function represent?',
            options: [
              'Slope',
              'Rate of change',
              'Area under the curve',
              'Maximum value'
            ],
            correctIndex: 2,
          ),
          QuizQuestion(
            question: 'The derivative of a constant is always:',
            options: ['1', 'Undefined', '0', 'The constant itself'],
            correctIndex: 2,
          ),
        ],
      ),
    ],
  });

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: navy),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Quizzes',
                    style: TextStyle(
                      color: navy,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: navy, height: 1, thickness: 1.4),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                itemCount: quizzes.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final quiz = quizzes[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _QuizPlayScreen(quiz: quiz),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: navy, width: 1.4),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: quiz.accent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(quiz.icon,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  quiz.subject,
                                  style: const TextStyle(
                                    color: subtitleBlue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  quiz.title,
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${quiz.questionCount} questions · ${quiz.duration} · ${quiz.difficulty}',
                                  style: const TextStyle(
                                    color: subtitleBlue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              color: navy, size: 24),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// QUIZ PLAY SCREEN
// ============================================================

class _QuizPlayScreen extends StatefulWidget {
  final QuizItem quiz;

  const _QuizPlayScreen({required this.quiz});

  @override
  State<_QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<_QuizPlayScreen> {
  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color mastGreen = Color(0xFF33B679);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color trackGrey = Color(0xFFE9EDF0);

  int _currentIndex = 0;
  int? _selectedOption;
  int _score = 0;
  bool _finished = false;

  void _selectOption(int index) {
    if (_selectedOption != null) return;
    setState(() => _selectedOption = index);
  }

  void _next() {
    final question = widget.quiz.questions[_currentIndex];
    if (_selectedOption == question.correctIndex) {
      _score++;
    }

    if (_currentIndex == widget.quiz.questions.length - 1) {
      setState(() => _finished = true);
    } else {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) {
      return _buildResult();
    }

    final question = widget.quiz.questions[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: navy),
                  ),
                  Expanded(
                    child: Text(
                      widget.quiz.title,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / widget.quiz.questions.length,
                  minHeight: 8,
                  backgroundColor: trackGrey,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(widget.quiz.accent),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Question ${_currentIndex + 1} of ${widget.quiz.questions.length}',
                style: const TextStyle(
                  color: subtitleBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                question.question,
                style: const TextStyle(
                  color: navy,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: question.options.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedOption == index;
                    final isCorrect = index == question.correctIndex;

                    Color borderColor = navy;
                    Color bg = Colors.white;

                    if (_selectedOption != null) {
                      if (isCorrect) {
                        borderColor = mastGreen;
                        bg = mastGreen.withValues(alpha: 0.1);
                      } else if (isSelected) {
                        borderColor = brandRed;
                        bg = brandRed.withValues(alpha: 0.08);
                      }
                    }

                    return InkWell(
                      onTap: () => _selectOption(index),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: 1.4),
                        ),
                        child: Text(
                          question.options[index],
                          style: const TextStyle(
                            color: navy,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _selectedOption == null ? null : _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    disabledBackgroundColor: trackGrey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    _currentIndex == widget.quiz.questions.length - 1
                        ? 'Finish'
                        : 'Next',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResult() {
    final total = widget.quiz.questions.length;
    final pct = (_score / total * 100).round();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: mastGreen.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: mastGreen, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$pct%',
                  style: const TextStyle(
                    color: mastGreen,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Quiz Complete!',
                style: TextStyle(
                  color: navy,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You scored $_score out of $total on ${widget.quiz.title}.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: subtitleBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Back to Quizzes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}