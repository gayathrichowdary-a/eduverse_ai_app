import 'dart:async';
import 'package:flutter/material.dart';

class SpeakingPracticeScreen extends StatefulWidget {
  const SpeakingPracticeScreen({super.key});

  @override
  State<SpeakingPracticeScreen> createState() =>
      _SpeakingPracticeScreenState();
}

class _SpeakingPracticeScreenState
    extends State<SpeakingPracticeScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color lightGrey = Color(0xFFF4F6F8);
  static const Color borderGrey = Color(0xFFE5E9ED);
  static const Color successGreen = Color(0xFF33B679);
  static const Color mentorBlue = Color(0xFFEAF8FB);

  // ============================================================
  // SCREEN STATES
  // 0 = Start
  // 1 = Recording
  // 2 = Results
  // ============================================================

  int _screenState = 0;

  Timer? _timer;
  int _seconds = 0;

  bool _isPlaying = false;
  Timer? _playbackTimer;

  // Mock scores for the result screen.
  // These can later be replaced with real AI-generated scores.
  final Map<String, double> _scores = {
    "Pronunciation": 82,
    "Fluency": 76,
    "Grammar": 88,
    "Vocabulary": 74,
    "Confidence": 80,
  };

  // ============================================================
  // SAMPLE SPEAKING SENTENCE
  // ============================================================

  final String _sampleSentence =
      "Technology has transformed the way students learn and communicate.";

  // ============================================================
  // START RECORDING
  // ============================================================

  void _startRecording() {
    setState(() {
      _screenState = 1;
      _seconds = 0;
    });

    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) return;

        setState(() {
          _seconds++;
        });
      },
    );
  }

  // ============================================================
  // STOP RECORDING
  // ============================================================

  void _stopRecording() {
    _timer?.cancel();
    _timer = null;

    setState(() {
      _screenState = 2;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Speaking test completed. Your AI results are ready.",
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // TRY AGAIN
  // ============================================================

  void _tryAgain() {
    _timer?.cancel();
    _playbackTimer?.cancel();

    setState(() {
      _screenState = 0;
      _seconds = 0;
      _isPlaying = false;
    });
  }

  // ============================================================
  // PLAY RECORDING
  // ============================================================

  void _playRecording() {
    if (_isPlaying) {
      _playbackTimer?.cancel();

      setState(() {
        _isPlaying = false;
      });

      return;
    }

    setState(() {
      _isPlaying = true;
    });

    _playbackTimer?.cancel();

    _playbackTimer = Timer(
      const Duration(seconds: 5),
      () {
        if (!mounted) return;

        setState(() {
          _isPlaying = false;
        });
      },
    );
  }

  // ============================================================
  // TIMER FORMAT
  // ============================================================

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return "${minutes.toString().padLeft(2, '0')}:"
        "${remainingSeconds.toString().padLeft(2, '0')}";
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _timer?.cancel();
    _playbackTimer?.cancel();
    super.dispose();
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Speaking Test",
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "AI English Communication Lab",
              style: TextStyle(
                color: subtitleBlue,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress indicator
              _buildProgressIndicator(),

              const SizedBox(height: 25),

              if (_screenState == 0)
                _buildStartScreen(),

              if (_screenState == 1)
                _buildRecordingScreen(),

              if (_screenState == 2)
                _buildResultsScreen(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROGRESS INDICATOR
  // ============================================================

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _progressStep(
          number: "1",
          label: "Start",
          active: _screenState >= 0,
        ),

        Expanded(
          child: Container(
            height: 3,
            color: _screenState >= 1
                ? brandRed
                : borderGrey,
          ),
        ),

        _progressStep(
          number: "2",
          label: "Record",
          active: _screenState >= 1,
        ),

        Expanded(
          child: Container(
            height: 3,
            color: _screenState >= 2
                ? brandRed
                : borderGrey,
          ),
        ),

        _progressStep(
          number: "3",
          label: "Results",
          active: _screenState >= 2,
        ),
      ],
    );
  }

  Widget _progressStep({
    required String number,
    required String label,
    required bool active,
  }) {
    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: active
                ? brandRed
                : lightGrey,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(
              color: active
                  ? Colors.white
                  : subtitleBlue,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),

        const SizedBox(height: 5),

        Text(
          label,
          style: TextStyle(
            color: active
                ? navy
                : subtitleBlue,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SCREEN 32
  // SPEAKING TEST - START
  // ============================================================

  Widget _buildStartScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: mentorBlue,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: navy.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: brandRed,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.record_voice_over_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(width: 15),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Speaking Test",
                      style: TextStyle(
                        color: navy,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      "Improve your English communication skills.",
                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        // Instructions
        const Text(
          "Instructions",
          style: TextStyle(
            color: navy,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 12),

        _instructionItem(
          Icons.volume_up_outlined,
          "Read the sentence clearly and naturally.",
        ),

        _instructionItem(
          Icons.speed_outlined,
          "Maintain a comfortable speaking pace.",
        ),

        _instructionItem(
          Icons.record_voice_over_outlined,
          "Speak loudly enough for the AI to hear you.",
        ),

        _instructionItem(
          Icons.psychology_outlined,
          "Focus on pronunciation, fluency and confidence.",
        ),

        const SizedBox(height: 25),

        // Sample sentence
        const Text(
          "Sample Sentence",
          style: TextStyle(
            color: navy,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: lightGrey,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderGrey,
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.format_quote_rounded,
                color: brandRed,
                size: 30,
              ),

              const SizedBox(height: 8),

              Text(
                _sampleSentence,
                style: const TextStyle(
                  color: navy,
                  fontSize: 17,
                  height: 1.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // Start Recording
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _startRecording,
            icon: const Icon(
              Icons.mic_rounded,
              color: Colors.white,
            ),
            label: const Text(
              "Start Recording",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: brandRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INSTRUCTION ITEM
  // ============================================================

  Widget _instructionItem(
    IconData icon,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: mentorBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: brandRed,
              size: 19,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: navy,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SCREEN 33
  // SPEAKING TEST - RECORDING
  // ============================================================

  Widget _buildRecordingScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Read the sentence",
          style: TextStyle(
            color: navy,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 12),

        // Highlighted sentence
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F2),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: brandRed,
              width: 1.5,
            ),
          ),
          child: Text(
            _sampleSentence,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: navy,
              fontSize: 19,
              fontWeight: FontWeight.w700,
              height: 1.6,
            ),
          ),
        ),

        const SizedBox(height: 35),

        // Timer
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: lightGrey,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: brandRed,
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  _formatTime(_seconds),
                  style: const TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 35),

        // Waveform
        _buildWaveform(),

        const SizedBox(height: 35),

        // Mic animation
        Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(
              begin: 0.85,
              end: 1.0,
            ),
            duration: const Duration(
              milliseconds: 700,
            ),
            curve: Curves.easeInOut,
            onEnd: () {
              if (_screenState == 1) {
                setState(() {});
              }
            },
            builder: (
              context,
              scale,
              child,
            ) {
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 105,
                  height: 105,
                  decoration: BoxDecoration(
                    color: brandRed,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: brandRed.withValues(alpha: 0.25),
                        blurRadius: 25,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.mic_rounded,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 18),

        const Center(
          child: Text(
            "Recording...",
            style: TextStyle(
              color: brandRed,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Stop button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _stopRecording,
            icon: const Icon(
              Icons.stop_rounded,
              color: Colors.white,
            ),
            label: const Text(
              "Stop Recording",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: navy,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // WAVEFORM / MIC ANIMATION
  // ============================================================

  Widget _buildWaveform() {
    final heights = [
      22.0,
      38.0,
      28.0,
      55.0,
      35.0,
      65.0,
      30.0,
      50.0,
      40.0,
      70.0,
      32.0,
      58.0,
      25.0,
      48.0,
      35.0,
      60.0,
      28.0,
      45.0,
      32.0,
      55.0,
    ];

    return Container(
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center,
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: heights.map(
          (height) {
            return Container(
              width: 5,
              height: height,
              margin: const EdgeInsets.symmetric(
                horizontal: 3,
              ),
              decoration: BoxDecoration(
                color: brandRed,
                borderRadius:
                    BorderRadius.circular(10),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  // ============================================================
  // SCREEN 34
  // SPEAKING TEST - RESULTS
  // ============================================================

  Widget _buildResultsScreen() {
    final overallScore = _calculateOverallScore();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Result header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: mentorBlue,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: successGreen,
                size: 35,
              ),

              const SizedBox(height: 10),

              const Text(
                "Speaking Test Complete!",
                style: TextStyle(
                  color: navy,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Here is your AI communication analysis.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: subtitleBlue,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 18),

              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: successGreen,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "${overallScore.round()}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Overall Score",
                style: TextStyle(
                  color: navy,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        // Score bars
        const Text(
          "Skill Analysis",
          style: TextStyle(
            color: navy,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 15),

        ..._scores.entries.map(
          (entry) {
            return _buildScoreBar(
              entry.key,
              entry.value,
            );
          },
        ),

        const SizedBox(height: 25),

        // Recording playback
        const Text(
          "Your Recording",
          style: TextStyle(
            color: navy,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: lightGrey,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: borderGrey,
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: _playRecording,
                child: CircleAvatar(
                  radius: 27,
                  backgroundColor: brandRed,
                  child: Icon(
                    _isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Speaking Test Recording",
                      style: TextStyle(
                        color: navy,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      _isPlaying
                          ? "Playing recording..."
                          : "Tap play to listen",
                      style: const TextStyle(
                        color: subtitleBlue,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.graphic_eq_rounded,
                color: subtitleBlue,
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // Try again
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _tryAgain,
            icon: const Icon(
              Icons.refresh_rounded,
              color: Colors.white,
            ),
            label: const Text(
              "Try Again",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: brandRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SCORE BAR
  // ============================================================

  Widget _buildScoreBar(
    String title,
    double score,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderGrey,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),

              Text(
                "${score.round()}%",
                style: const TextStyle(
                  color: navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 9,
              backgroundColor: lightGrey,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                brandRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // OVERALL SCORE
  // ============================================================

  double _calculateOverallScore() {
    double total = 0;

    for (final score in _scores.values) {
      total += score;
    }

    return total / _scores.length;
  }
}