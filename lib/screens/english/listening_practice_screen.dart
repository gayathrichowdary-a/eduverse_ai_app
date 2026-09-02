import 'package:flutter/material.dart';

class ListeningPracticeScreen extends StatefulWidget {
  const ListeningPracticeScreen({super.key});

  @override
  State<ListeningPracticeScreen> createState() =>
      _ListeningPracticeScreenState();
}

class _ListeningPracticeScreenState extends State<ListeningPracticeScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color lightBlueBg = Color(0xFFEAF8FB);
  static const Color chartBlue = Color(0xFF55C6E8);
  static const Color matchGreen = Color(0xFF52B68C);
  static const Color mustard = Color(0xFFFBC02D);
  static const Color lightBg = Color(0xFFF7F9FB);

  // ============================================================
  // STATE
  // ============================================================

  bool _isPlaying = false;
  bool _showTranscript = false;
  int _selectedAnswer = -1;
  bool _answerSubmitted = false;

  double _progress = 0.45;

  // ============================================================
  // ANSWERS
  // ============================================================

  final List<String> _answers = [
    'The speaker is describing a new project.',
    'The speaker is explaining a travel experience.',
    'The speaker is discussing a university course.',
    'The speaker is talking about a job interview.',
  ];

  // ============================================================
  // PLAY / PAUSE
  // ============================================================

  void _togglePlayback() {
    if (_isPlaying) {
      setState(() {
        _isPlaying = false;
      });
      return;
    }

    setState(() {
      _isPlaying = true;
      _progress = 0.45;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Playing listening exercise...'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted || !_isPlaying) return;

      setState(() {
        _isPlaying = false;
        _progress = 0.75;
      });
    });
  }

  // ============================================================
  // SUBMIT ANSWER
  // ============================================================

  void _submitAnswer() {
    if (_selectedAnswer == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an answer first.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _answerSubmitted = true;
      _progress = 1.0;
    });

    final bool isCorrect = _selectedAnswer == 0;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect
              ? 'Correct! Great listening.'
              : 'Not quite. Listen again and try once more.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // RESET
  // ============================================================

  void _resetExercise() {
    setState(() {
      _isPlaying = false;
      _showTranscript = false;
      _selectedAnswer = -1;
      _answerSubmitted = false;
      _progress = 0.45;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Listening exercise restarted.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // HINT
  // ============================================================

  void _showHint() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: mustard,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Listening Hint',
                      style: TextStyle(
                        color: navy,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Listen for the main topic rather than trying to remember every single word.',
                  style: TextStyle(
                    color: navy,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Got it',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: navy,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Listening Practice',
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'English • Listening Module',
              style: TextStyle(
                color: subtitleBlue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: navy,
            ),
            tooltip: 'Restart',
            onPressed: _resetExercise,
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: Column(
          children: [
            const Divider(
              height: 1,
              color: Color(0xFFE5E9ED),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  110,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressCard(),

                    const SizedBox(height: 24),

                    const Text(
                      'Listening Activity',
                      style: TextStyle(
                        color: navy,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 14),

                    _buildAudioCard(),

                    const SizedBox(height: 22),

                    _buildTranscriptSection(),

                    const SizedBox(height: 28),

                    const Text(
                      'Comprehension Question',
                      style: TextStyle(
                        color: navy,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 14),

                    _buildQuestionCard(),

                    const SizedBox(height: 22),

                    _buildListeningTips(),

                    const SizedBox(height: 28),

                    _buildVocabularySection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ========================================================
      // BOTTOM ACTION
      // ========================================================

      bottomNavigationBar: _buildBottomAction(),
    );
  }

  // ============================================================
  // PROGRESS CARD
  // ============================================================

  Widget _buildProgressCard() {
    final int percentage = (_progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: lightBlueBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: navy.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.headphones_rounded,
                  color: chartBlue,
                  size: 26,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Listening Progress',
                      style: TextStyle(
                        color: navy,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Listen carefully and identify the main idea.',
                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '$percentage%',
                style: const TextStyle(
                  color: brandRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(
                brandRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AUDIO CARD
  // ============================================================

  Widget _buildAudioCard() {
    const List<double> bars = [
      25,
      45,
      60,
      35,
      55,
      30,
      50,
      40,
      65,
      35,
      55,
      45,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: brandRed.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Listen Carefully',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Listen to the short passage and answer the question.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: bars.map((height) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 5,
                  height: _isPlaying ? height : height * 0.45,
                  decoration: BoxDecoration(
                    color: _isPlaying
                        ? brandRed
                        : Colors.white54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 25),

          GestureDetector(
            onTap: _togglePlayback,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                color: brandRed,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Text(
            _isPlaying ? 'Playing...' : 'Tap to Play',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.speed_rounded,
                color: Colors.white70,
                size: 16,
              ),
              SizedBox(width: 5),
              Text(
                'Normal Speed',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 15),
              Icon(
                Icons.timer_outlined,
                color: Colors.white70,
                size: 16,
              ),
              SizedBox(width: 5),
              Text(
                '1:20',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TRANSCRIPT
  // ============================================================

  Widget _buildTranscriptSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: lightBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            onTap: () {
              setState(() {
                _showTranscript = !_showTranscript;
              });
            },
            leading: const Icon(
              Icons.article_outlined,
              color: subtitleBlue,
            ),
            title: const Text(
              'Show Transcript',
              style: TextStyle(
                color: navy,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            trailing: Icon(
              _showTranscript
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: navy,
            ),
          ),

          if (_showTranscript)
            const Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                0,
                20,
                20,
              ),
              child: Text(
                'The speaker introduces a new project and explains '
                'how the team plans to improve communication and '
                'productivity. The main goal is to make the process '
                'easier and more efficient for everyone.',
                style: TextStyle(
                  color: navy,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // QUESTION CARD
  // ============================================================

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What is the speaker mainly talking about?',
            style: TextStyle(
              color: navy,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 18),

          ...List.generate(
            _answers.length,
            (index) => _buildAnswerOption(
              index,
              _answers[index],
            ),
          ),

          if (_answerSubmitted) ...[
            const SizedBox(height: 5),
            _buildAnswerFeedback(),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // ANSWER OPTION
  // ============================================================

  Widget _buildAnswerOption(
    int index,
    String answer,
  ) {
    final bool isSelected = _selectedAnswer == index;
    final bool isCorrect = index == 0;

    Color borderColor = Colors.grey.shade200;
    Color backgroundColor = Colors.white;

    if (isSelected) {
      borderColor = brandRed;
      backgroundColor = const Color(0xFFFDE8E9);
    }

    if (_answerSubmitted && isSelected && isCorrect) {
      borderColor = matchGreen;
      backgroundColor = const Color(0xFFE8F5E9);
    }

    return GestureDetector(
      onTap: () {
        if (_answerSubmitted) return;

        setState(() {
          _selectedAnswer = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 1.7 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 29,
              height: 29,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? brandRed
                    : lightBg,
              ),
              child: Text(
                String.fromCharCode(65 + index),
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : navy,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                answer,
                style: const TextStyle(
                  color: navy,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ANSWER FEEDBACK
  // ============================================================

  Widget _buildAnswerFeedback() {
    final bool isCorrect = _selectedAnswer == 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCorrect
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect
                ? Icons.check_circle_rounded
                : Icons.info_outline_rounded,
            color: isCorrect
                ? matchGreen
                : brandRed,
            size: 20,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              isCorrect
                  ? 'Correct! You identified the main idea.'
                  : 'Try listening again. Focus on the speaker\'s main topic.',
              style: const TextStyle(
                color: navy,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LISTENING TIPS
  // ============================================================

  Widget _buildListeningTips() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: mustard.withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: mustard,
                size: 21,
              ),
              SizedBox(width: 8),
              Text(
                'Listening Tip',
                style: TextStyle(
                  color: navy,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'Don\'t translate every word in your head. Listen for '
            'keywords, tone, repeated ideas, and the speaker\'s '
            'main point.',
            style: TextStyle(
              color: navy,
              fontSize: 13,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 15),

          GestureDetector(
            onTap: _showHint,
            child: const Text(
              'View More Tips →',
              style: TextStyle(
                color: brandRed,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VOCABULARY
  // ============================================================

  Widget _buildVocabularySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.menu_book_rounded,
              color: navy,
              size: 21,
            ),
            SizedBox(width: 8),
            Text(
              'Key Listening Vocabulary',
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        _buildVocabularyCard(
          'Productivity',
          'The ability to work efficiently and effectively.',
        ),

        _buildVocabularyCard(
          'Communication',
          'The process of sharing information and ideas.',
        ),

        _buildVocabularyCard(
          'Efficient',
          'Achieving a result with minimal wasted time or effort.',
        ),
      ],
    );
  }

  // ============================================================
  // VOCABULARY CARD
  // ============================================================

  Widget _buildVocabularyCard(
    String word,
    String meaning,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF0F2F5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: lightBlueBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.volume_up_outlined,
              color: chartBlue,
              size: 20,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word,
                  style: const TextStyle(
                    color: navy,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  meaning,
                  style: const TextStyle(
                    color: subtitleBlue,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM ACTION
  // ============================================================

  Widget _buildBottomAction() {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          12,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: _answerSubmitted
                ? _resetExercise
                : _submitAnswer,
            icon: Icon(
              _answerSubmitted
                  ? Icons.refresh_rounded
                  : Icons.check_circle_outline_rounded,
              color: Colors.white,
            ),
            label: Text(
              _answerSubmitted
                  ? 'Try Again'
                  : 'Submit Answer',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: brandRed,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}