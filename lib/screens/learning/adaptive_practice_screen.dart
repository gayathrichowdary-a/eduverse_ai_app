import 'package:flutter/material.dart';
import '../settings/settings_profile.dart';
import 'ai_explanation_screen.dart';   


class AdaptivePracticeScreen extends StatefulWidget {
  const AdaptivePracticeScreen({super.key});

  @override
  State<AdaptivePracticeScreen> createState() =>
      _AdaptivePracticeScreenState();
}

class _AdaptivePracticeScreenState
    extends State<AdaptivePracticeScreen> {
  // ============================================================
  // VARIABLES
  // ============================================================

  String selectedDifficulty = 'Medium';

  // Start from the FIRST question
  int currentQuestion = 1;

  // Total number of questions
  final int totalQuestions = 20;

  // Selected answer for the current question
  int? selectedAnswer;

  // ============================================================
  // CURRENT QUESTION DATA
  // ============================================================

  final List<Map<String, dynamic>> questions = [
    {
      'subject': 'PHYSICS',
      'difficulty': 'Medium',
      'question':
          'A ball is thrown vertically upwards with a velocity of 20 m/s. '
          'What is the maximum height reached by the ball? '
          '(Assume g = 10 m/s²)',
      'answers': [
        '10 meters',
        '20 meters',
        '30 meters',
        '40 meters',
      ],
      'correctAnswer': 1,
    },

    {
      'subject': 'CHEMISTRY',
      'difficulty': 'Medium',
      'question':
          'Which of the following is the chemical formula for water?',
      'answers': [
        'CO₂',
        'O₂',
        'H₂O',
        'NaCl',
      ],
      'correctAnswer': 2,
    },

    {
      'subject': 'MATHEMATICS',
      'difficulty': 'Easy',
      'question':
          'What is the value of 5 × 5?',
      'answers': [
        '10',
        '15',
        '20',
        '25',
      ],
      'correctAnswer': 3,
    },

    {
      'subject': 'BIOLOGY',
      'difficulty': 'Easy',
      'question':
          'Which organ pumps blood throughout the human body?',
      'answers': [
        'Brain',
        'Heart',
        'Lungs',
        'Kidney',
      ],
      'correctAnswer': 1,
    },

    {
      'subject': 'PHYSICS',
      'difficulty': 'Medium',
      'question':
          'What is the SI unit of force?',
      'answers': [
        'Joule',
        'Watt',
        'Newton',
        'Pascal',
      ],
      'correctAnswer': 2,
    },
  ];

  // ============================================================
  // GET CURRENT QUESTION
  // ============================================================

  Map<String, dynamic> get currentQuestionData {
    final index = (currentQuestion - 1) % questions.length;
    return questions[index];
  }

  // ============================================================
  // SUBMIT ANSWER
  // ============================================================

  void _submitAnswer() {
    if (selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select an answer before submitting.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final correctAnswer =
        currentQuestionData['correctAnswer'] as int;

    final isCorrect =
        selectedAnswer == correctAnswer;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect
              ? 'Correct answer! 🎉'
              : 'Incorrect answer. Keep practising!',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );

    _goToNextQuestion();
  }

  // ============================================================
  // SKIP QUESTION
  // ============================================================

  void _skipQuestion() {
    _goToNextQuestion();
  }

  // ============================================================
  // GO TO NEXT QUESTION
  // ============================================================

  void _goToNextQuestion() {
    if (currentQuestion >= totalQuestions) {
      _showCompletionDialog();
      return;
    }

    setState(() {
      currentQuestion++;
      selectedAnswer = null;
    });
  }

  // ============================================================
  // COMPLETION DIALOG
  // ============================================================

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Practice Complete 🎉',
          ),
          content: const Text(
            'You have completed all 20 questions.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                setState(() {
                  currentQuestion = 1;
                  selectedAnswer = null;
                });
              },
              child: const Text(
                'Start Again',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'Finish',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final question =
        currentQuestionData;

    final String subject =
        question['subject'];

    final String difficulty =
        question['difficulty'];

    final String questionText =
        question['question'];

    final List<String> answers =
        List<String>.from(
      question['answers'],
    );

    final double progress =
        currentQuestion / totalQuestions;

    return Scaffold(
      backgroundColor: Colors.white,

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF1E3A5F),
            size: 32,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Adaptive Practice',
          style: TextStyle(
            color: Color(0xFF1E3A5F),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Color(0xFF4D8AAE),
              size: 32,
            ),
            onPressed: () {Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SettingsProfile()),
  );},
          ),
        ],
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // ============================================================
            // PROGRESS
            // ============================================================

            Row(
              children: [

                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 14,
                    backgroundColor:
                        const Color(0xFFEFF1F3),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
                      Color(0xFF4FC3E8),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                Text(
                  '$currentQuestion/$totalQuestions',
                  style: const TextStyle(
                    color: Color(0xFF397CA0),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),

            // ============================================================
            // SELECT DIFFICULTY
            // ============================================================

            const Text(
              'Select Difficulty',
              style: TextStyle(
                color: Color(0xFF397CA0),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                _difficultyButton(
                  'Easy',
                  Icons.smart_toy,
                ),

                const SizedBox(width: 10),

                _difficultyButton(
                  'Medium',
                  Icons.school,
                ),

                const SizedBox(width: 10),

                _difficultyButton(
                  'Hard',
                  Icons.psychology,
                ),
              ],
            ),

            const SizedBox(height: 40),

            // ============================================================
            // QUESTION CARD
            // ============================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(28),

                border: Border.all(
                  color: const Color(0xFFE7EBEF),
                  width: 2,
                ),

                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFD5DCE2),
                    offset: Offset(0, 8),
                    blurRadius: 0,
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // ============================================================
                  // SUBJECT AND DIFFICULTY
                  // ============================================================

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              const Color(0xFFEAF7FC),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),

                        child: Text(
                          subject,
                          style: const TextStyle(
                            color:
                                Color(0xFF1E3A5F),
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      Text(
                        'Difficulty: $difficulty',
                        style: const TextStyle(
                          color:
                              Color(0xFF1E3A5F),
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ============================================================
                  // QUESTION
                  // ============================================================

                  Text(
                    questionText,
                    style: const TextStyle(
                      color: Color(0xFF1E3A5F),
                      fontSize: 22,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ============================================================
                  // ANSWER OPTIONS
                  // ============================================================

                  for (int i = 0;
                      i < answers.length;
                      i++)
                    _answerOption(
                      i,
                      answers[i],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // ============================================================
            // HINT AND SOLUTION
            // ============================================================

            Row(
              children: [

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Hint: Use the equation v² = u² + 2as.',
                          ),
                        ),
                      );
                    },

                    icon: const Icon(
                      Icons.lightbulb_outline,
                    ),

                    label: const Text(
                      'Hint',
                    ),

                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          const Color(0xFF1E3A5F),

                      side: const BorderSide(
                        color:
                            Color(0xFF1E3A5F),
                        width: 2,
                      ),

                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 18,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Solution: Maximum height = 20 metres.',
                          ),
                        ),
                      );
                    },

                    icon: const Icon(
                      Icons.check_circle_outline,
                    ),

                    label: const Text(
                      'Solution',
                    ),

                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          const Color(0xFF1E3A5F),

                      side: const BorderSide(
                        color:
                            Color(0xFF1E3A5F),
                        width: 2,
                      ),

                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 18,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ============================================================
            // AI EXPLAIN CARD
            // ============================================================

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(25),

              decoration: BoxDecoration(
                color: const Color(0xFFFFE9E9),
                borderRadius:
                    BorderRadius.circular(28),

                border: Border.all(
                  color:
                      const Color(0xFFFFB6B6),
                  width: 2,
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    '✨  Stuck? Ask EduVerse AI',
                    style: TextStyle(
                      color: Color(0xFF1E3A5F),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Get a step-by-step breakdown of the '
                    'concepts used in this problem.',

                    style: TextStyle(
                      color: Color(0xFF1E3A5F),
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: () {  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AiExplanationScreen(
        subject: subject,
        questionText: questionText,
      ),
    ),
  );

                      },

                      icon: const Icon(
                        Icons.psychology,
                      ),

                      label: const Text(
                        'AI Explain',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFEF3340),

                        foregroundColor:
                            Colors.white,

                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 18,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // ============================================================
            // BOTTOM BUTTONS
            // ============================================================

            Row(
              children: [

                Expanded(
                  child: TextButton(
                    onPressed: _skipQuestion,

                    child: const Text(
                      'Skip Question',
                      style: TextStyle(
                        color:
                            Color(0xFFEF3340),
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitAnswer,

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFEF3340),

                      foregroundColor:
                          Colors.white,

                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 18,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),
                      ),
                    ),

                    child: const Text(
                      'Submit Answer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DIFFICULTY BUTTON
  // ============================================================

  Widget _difficultyButton(
    String difficulty,
    IconData icon,
  ) {
    final isSelected =
        selectedDifficulty == difficulty;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedDifficulty =
                difficulty;
          });
        },

        child: Container(
          padding:
              const EdgeInsets.symmetric(
            vertical: 18,
          ),

          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFEAF7FC)
                : Colors.white,

            borderRadius:
                BorderRadius.circular(30),

            border: Border.all(
              color:
                  const Color(0xFFE7EBEF),
              width: 2,
            ),
          ),

          child: Column(
            children: [

              Icon(
                icon,
                color:
                    const Color(0xFF1E3A5F),
              ),

              const SizedBox(height: 5),

              Text(
                difficulty,
                style: const TextStyle(
                  color:
                      Color(0xFF1E3A5F),
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ANSWER OPTION
  // ============================================================

  Widget _answerOption(
    int index,
    String answer,
  ) {
    final isSelected =
        selectedAnswer == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswer = index;
        });
      },

      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          vertical: 12,
        ),

        child: Row(
          children: [

            Container(
              width: 35,
              height: 35,

              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,

                color: isSelected
                    ? const Color(
                        0xFF4FC3E8,
                      )
                    : Colors.white,

                border: Border.all(
                  color: isSelected
                      ? const Color(
                          0xFF4FC3E8,
                        )
                      : const Color(
                          0xFFE7EBEF,
                        ),

                  width: 4,
                ),
              ),

              child: isSelected
                  ? const Icon(
                      Icons.circle,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),

            const SizedBox(width: 25),

            Expanded(
              child: Text(
                answer,
                style: const TextStyle(
                  color:
                      Color(0xFF1E3A5F),
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}