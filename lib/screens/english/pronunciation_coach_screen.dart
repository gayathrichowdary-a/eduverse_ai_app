import 'package:flutter/material.dart';

class PronunciationCoachScreen extends StatefulWidget {
  const PronunciationCoachScreen({super.key});

  @override
  State<PronunciationCoachScreen> createState() =>
      _PronunciationCoachScreenState();
}

class _PronunciationCoachScreenState
    extends State<PronunciationCoachScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color lightBlue = Color(0xFF4FC3F7);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color bgGrey = Color(0xFFF7F9FB);
  static const Color insightBlue = Color(0xFFEAF8FB);
  static const Color successGreen = Color(0xFF33B679);
  static const Color warningOrange = Color(0xFFFF9800);

  // ============================================================
  // STATE
  // ============================================================

  bool _isRecording = false;

  // ============================================================
  // RECORDING
  // ============================================================

  void _toggleRecording() {
    if (_isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Listening... Say the sentence clearly.',
        ),
        duration: Duration(seconds: 2),
      ),
    );

    // Real microphone / speech recognition can be connected here.
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted || !_isRecording) return;

      setState(() {
        _isRecording = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Practice completed. Review your pronunciation below.',
          ),
        ),
      );
    });
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Practice stopped.'),
      ),
    );
  }

  // ============================================================
  // PRACTICE AGAIN
  // ============================================================

  void _practiceAgain() {
    setState(() {
      _isRecording = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Ready for another pronunciation attempt.',
        ),
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

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: navy,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pronunciation Coach',
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'English • Phonetics Practice',
              style: TextStyle(
                color: subtitleBlue,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // AI COACH CARD
            // ==================================================

            _buildMentorStatusCard(),

            const SizedBox(height: 24),

            // ==================================================
            // PRACTICE SENTENCE
            // ==================================================

            const Text(
              'Practice Sentence',
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 12),

            _buildSentenceCard(),

            const SizedBox(height: 20),

            // ==================================================
            // RECORDING AREA
            // ==================================================

            _buildRecordingArea(),

            const SizedBox(height: 28),

            // ==================================================
            // LIVE ANALYSIS
            // ==================================================

            const Text(
              'Pronunciation Analysis',
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 12),

            _buildAnalysisCard(
              word: 'The',
              phonetic: '/ðə/',
              status: 'Good pronunciation',
              icon: Icons.check_circle_rounded,
              color: successGreen,
            ),

            _buildAnalysisCard(
              word: 'Sun',
              phonetic: '/sʌn/',
              status: 'Needs more clarity',
              icon: Icons.warning_rounded,
              color: warningOrange,
            ),

            const SizedBox(height: 20),

            // ==================================================
            // COMMON MISTAKE
            // ==================================================

            _buildCommonMistakeCard(),

            const SizedBox(height: 24),

            // ==================================================
            // AI FEEDBACK
            // ==================================================

            _buildAiFeedbackCard(),

            const SizedBox(height: 24),

            // ==================================================
            // DRILL TOOLS
            // ==================================================

            const Text(
              'Drill Tools',
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildToolCard(
                    title: 'Phonetic Guide',
                    subtitle: 'Learn sounds',
                    icon: Icons.menu_book_rounded,
                    iconColor: lightBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildToolCard(
                    title: 'Slow Practice',
                    subtitle: 'Practice slowly',
                    icon: Icons.slow_motion_video_rounded,
                    iconColor: warningOrange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ==================================================
            // PRACTICE AGAIN
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _practiceAgain,
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: navy,
                ),
                label: const Text(
                  'Practice Again',
                  style: TextStyle(
                    color: navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: navy,
                    width: 1.4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // AI MENTOR STATUS CARD
  // ============================================================

  Widget _buildMentorStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: insightBlue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: navy,
          width: 1.3,
        ),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: lightBlue,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: successGreen,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coach Aria',
                  style: TextStyle(
                    color: navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Ready to improve your pronunciation',
                  style: TextStyle(
                    color: subtitleBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.graphic_eq_rounded,
            color: brandRed,
            size: 28,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SENTENCE CARD
  // ============================================================

  Widget _buildSentenceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: navy,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Say this sentence:',
            style: TextStyle(
              color: subtitleBlue,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '“The sun shines brightly.”',
            style: TextStyle(
              color: navy,
              fontSize: 19,
              fontWeight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Focus on the “th” sound and clear pronunciation.',
            style: TextStyle(
              color: subtitleBlue,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RECORDING AREA
  // ============================================================

  Widget _buildRecordingArea() {
    return GestureDetector(
      onTap: _toggleRecording,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 28,
        ),
        decoration: BoxDecoration(
          color: _isRecording
              ? brandRed
              : const Color(0xFFFFF1F2),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isRecording
                ? brandRed
                : navy.withValues(alpha: 0.15),
            width: 1.4,
          ),
        ),
        child: Column(
          children: [
            Text(
              _isRecording
                  ? 'Listening...'
                  : 'Tap to Speak',
              style: TextStyle(
                color: _isRecording
                    ? Colors.white
                    : navy,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                28.0,
                48.0,
                36.0,
                58.0,
                42.0,
                30.0,
              ].map(
                (height) {
                  return AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 3,
                    ),
                    width: 6,
                    height: _isRecording
                        ? height
                        : height * 0.45,
                    decoration: BoxDecoration(
                      color: _isRecording
                          ? Colors.white
                          : brandRed,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  );
                },
              ).toList(),
            ),

            const SizedBox(height: 20),

            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: _isRecording
                    ? Colors.white
                    : brandRed,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isRecording
                    ? Icons.stop_rounded
                    : Icons.mic_rounded,
                color: _isRecording
                    ? brandRed
                    : Colors.white,
                size: 28,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              _isRecording
                  ? 'Tap to stop'
                  : 'Tap the microphone and speak clearly',
              style: TextStyle(
                color: _isRecording
                    ? Colors.white70
                    : subtitleBlue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ANALYSIS CARD
  // ============================================================

  Widget _buildAnalysisCard({
    required String word,
    required String phonetic,
    required String status,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: navy.withValues(alpha: 0.10),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              word,
              style: const TextStyle(
                color: navy,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  phonetic,
                  style: const TextStyle(
                    color: subtitleBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            icon,
            color: color,
            size: 22,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMMON MISTAKE
  // ============================================================

  Widget _buildCommonMistakeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: brandRed.withValues(alpha: 0.35),
          width: 1.3,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: brandRed,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Common Mistake',
                style: TextStyle(
                  color: brandRed,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Text(
            'Replacing the “th” sound with “s”.',
            style: TextStyle(
              color: navy,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          const Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: successGreen,
                size: 19,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Place your tongue gently between your teeth and let the air flow softly.',
                  style: TextStyle(
                    color: navy,
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AI FEEDBACK
  // ============================================================

  Widget _buildAiFeedbackCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: insightBlue,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: lightBlue.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology_alt_rounded,
                color: subtitleBlue,
                size: 21,
              ),
              SizedBox(width: 8),
              Text(
                'AI Feedback',
                style: TextStyle(
                  color: navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          Text(
            'Your pronunciation is improving. Focus on the “th” sound and keep your speech clear and steady.',
            style: TextStyle(
              color: navy,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DRILL TOOL CARD
  // ============================================================

  Widget _buildToolCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title selected.'),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: navy,
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              style: const TextStyle(
                color: navy,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              subtitle,
              style: const TextStyle(
                color: subtitleBlue,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}