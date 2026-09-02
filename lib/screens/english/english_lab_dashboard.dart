import 'package:flutter/material.dart';

import 'interactive_canvas_screen.dart';
import 'speaking_practice_screen.dart';
import 'pronunciation_coach_screen.dart';
import 'grammar_correction_screen.dart';
import 'vocabulary_builder_screen.dart';
import 'reading_practice_screen.dart';
import 'personalized_english_practice.dart';
import 'conversation_simulator_screen.dart';
import 'offline_library_screen.dart';
import 'writing_practice_screen.dart';
import 'english_achievements_screen.dart';
import 'learning_journey_screen.dart';

class EnglishLabDashboard extends StatefulWidget {
  const EnglishLabDashboard({super.key});

  @override
  State<EnglishLabDashboard> createState() => _EnglishLabDashboardState();
}

class _EnglishLabDashboardState extends State<EnglishLabDashboard> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color brandRed = Color(0xFFE8394A);
  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color chatGrey = Color(0xFFEEF1F4);
  static const Color lightBlue = Color(0xFFEAF8FB);
  static const Color lightYellow = Color(0xFFFFF7DD);
  static const Color green = Color(0xFF33B679);
  static const Color purple = Color(0xFF7667F5);

  // ============================================================
  // CURRENT ENGLISH SKILL
  // ============================================================

  String _currentFocus = 'Speaking Practice';

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
        surfaceTintColor: Colors.transparent,

        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: brandRed.withValues(alpha: 0.10),
            child: const Icon(
              Icons.language_rounded,
              color: brandRed,
              size: 21,
            ),
          ),
        ),

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'EduVerse AI',
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Row(
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor: green,
                ),
                SizedBox(width: 6),
                Text(
                  'English Lab',
                  style: TextStyle(
                    color: subtitleBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: [
          IconButton(
            tooltip: 'About English Lab',
            icon: const Icon(
              Icons.info_outline_rounded,
              color: subtitleBlue,
            ),
            onPressed: () => _showAboutEnglishLab(context),
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // WELCOME
              // ==================================================

              const Text(
                'English Learning Lab',
                style: TextStyle(
                  color: navy,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Build your English skills through personalized practice.',
                style: TextStyle(
                  color: subtitleBlue,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // AI TUTOR CARD
              // ==================================================

              _buildAiTutorCard(),

              const SizedBox(height: 24),

              // ==================================================
              // ENGLISH PROGRESS
              // ==================================================

              _buildEnglishProgressCard(),

              const SizedBox(height: 28),

              // ==================================================
              // CONTINUE LEARNING
              // ==================================================

              _buildContinueLearning(),

              const SizedBox(height: 28),

              // ==================================================
              // ENGLISH TOOLS
              // ==================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'English Practice',
                    style: TextStyle(
                      color: navy,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showAllTools(context);
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: brandRed,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _buildPracticeGrid(),

              const SizedBox(height: 28),

              // ==================================================
              // LEARNING JOURNEY
              // ==================================================

              _buildLearningJourneyCard(),

              const SizedBox(height: 18),

              // ==================================================
              // ACHIEVEMENTS
              // ==================================================

              _buildAchievementCard(),

              const SizedBox(height: 18),

              // ==================================================
              // QUICK INPUT
              // ==================================================

              _buildInputBar(context),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // AI TUTOR CARD
  // ============================================================

  Widget _buildAiTutorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: navy,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: brandRed,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: navy,
                    width: 1.2,
                  ),
                ),
                child: const Icon(
                  Icons.smart_toy_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI English Tutor',
                      style: TextStyle(
                        color: navy,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: green,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Ready to help',
                          style: TextStyle(
                            color: subtitleBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              IconButton(
                tooltip: 'Tutor information',
                icon: const Icon(
                  Icons.info_outline_rounded,
                  color: subtitleBlue,
                ),
                onPressed: () => _showAboutTutorDialog(context),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: navy,
                width: 1,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today’s English focus',
                  style: TextStyle(
                    color: subtitleBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Improve your speaking confidence with a short guided conversation.',
                  style: TextStyle(
                    color: navy,
                    fontSize: 15,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SpeakingPracticeScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                      size: 19,
                    ),
                    label: const Text(
                      'Start Practice',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandRed,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ConversationSimulatorScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: navy,
                      size: 18,
                    ),
                    label: const Text(
                      'Ask Tutor',
                      style: TextStyle(
                        color: navy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: navy,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
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
  // ENGLISH PROGRESS
  // ============================================================

  Widget _buildEnglishProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: navy,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Your English Progress',
                style: TextStyle(
                  color: navy,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Intermediate',
                style: TextStyle(
                  color: brandRed,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _progressRow(
            label: 'Speaking',
            value: 0.72,
            color: brandRed,
          ),

          const SizedBox(height: 13),

          _progressRow(
            label: 'Grammar',
            value: 0.81,
            color: purple,
          ),

          const SizedBox(height: 13),

          _progressRow(
            label: 'Vocabulary',
            value: 0.68,
            color: green,
          ),

          const SizedBox(height: 13),

          _progressRow(
            label: 'Reading',
            value: 0.76,
            color: subtitleBlue,
          ),
        ],
      ),
    );
  }

  Widget _progressRow({
    required String label,
    required double value,
    required Color color,
  }) {
    final percentage = (value * 100).round();

    return Row(
      children: [
        SizedBox(
          width: 82,
          child: Text(
            label,
            style: const TextStyle(
              color: navy,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 9,
              backgroundColor: chatGrey,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),

        const SizedBox(width: 10),

        SizedBox(
          width: 38,
          child: Text(
            '$percentage%',
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: navy,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CONTINUE LEARNING
  // ============================================================

  Widget _buildContinueLearning() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Continue Learning',
              style: TextStyle(
                color: navy,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const LearningJourneyScreen(),
                  ),
                );
              },
              child: const Text(
                'Journey',
                style: TextStyle(
                  color: brandRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const GrammarCorrectionScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(22),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: lightYellow,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: navy,
                width: 1.1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: brandRed,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.spellcheck_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),

                const SizedBox(width: 14),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next recommended activity',
                        style: TextStyle(
                          color: subtitleBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Grammar Correction',
                        style: TextStyle(
                          color: navy,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Practice sentence correction and improve accuracy.',
                        style: TextStyle(
                          color: subtitleBlue,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: navy,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PRACTICE GRID
  // ============================================================

  Widget _buildPracticeGrid() {
    final tools = <_EnglishTool>[
      _EnglishTool(
        title: 'Speaking',
        subtitle: 'Speak',
        icon: Icons.mic_rounded,
        color: brandRed,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SpeakingPracticeScreen(),
            ),
          );
        },
      ),
      _EnglishTool(
        title: 'Pronunciation',
        subtitle: 'Sound',
        icon: Icons.record_voice_over_rounded,
        color: purple,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PronunciationCoachScreen(),
            ),
          );
        },
      ),
      _EnglishTool(
        title: 'Grammar',
        subtitle: 'Correct',
        icon: Icons.spellcheck_rounded,
        color: green,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GrammarCorrectionScreen(),
            ),
          );
        },
      ),
      _EnglishTool(
        title: 'Vocabulary',
        subtitle: 'Words',
        icon: Icons.menu_book_rounded,
        color: subtitleBlue,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VocabularyBuilderScreen(),
            ),
          );
        },
      ),
      _EnglishTool(
        title: 'Reading',
        subtitle: 'Read',
        icon: Icons.auto_stories_rounded,
        color: navy,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReadingPracticeScreen(),
            ),
          );
        },
      ),
      _EnglishTool(
        title: 'Writing',
        subtitle: 'Write',
        icon: Icons.edit_note_rounded,
        color: brandRed,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WritingPracticeScreen(),
            ),
          );
        },
      ),
      _EnglishTool(
        title: 'Conversation',
        subtitle: 'Talk',
        icon: Icons.forum_rounded,
        color: purple,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const ConversationSimulatorScreen(),
            ),
          );
        },
      ),
      _EnglishTool(
        title: 'Personalized',
        subtitle: 'Practice',
        icon: Icons.auto_awesome_rounded,
        color: green,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const PersonalizedEnglishPractice(),
            ),
          );
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tools.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        return _EnglishToolCard(tool: tools[index]);
      },
    );
  }

  // ============================================================
  // LEARNING JOURNEY CARD
  // ============================================================

  Widget _buildLearningJourneyCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LearningJourneyScreen(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: navy,
            width: 1.1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.route_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),

            const SizedBox(width: 15),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Learning Journey',
                    style: TextStyle(
                      color: navy,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Track your English learning path and continue from your next activity.',
                    style: TextStyle(
                      color: subtitleBlue,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: navy,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ACHIEVEMENT CARD
  // ============================================================

  Widget _buildAchievementCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const EnglishAchievementsScreen(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: lightYellow,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: navy,
            width: 1.1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.amber.shade600,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),

            const SizedBox(width: 15),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'English Achievements',
                    style: TextStyle(
                      color: navy,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'View your completed milestones and English learning achievements.',
                    style: TextStyle(
                      color: subtitleBlue,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: navy,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INPUT BAR
  // ============================================================

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: chatGrey,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          _inputButton(
            context,
            icon: Icons.auto_awesome_rounded,
            tooltip: 'Interactive practice',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const InteractiveCanvasScreen(),
                ),
              );
            },
          ),

          _inputButton(
            context,
            icon: Icons.library_books_outlined,
            tooltip: 'Offline library',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const OfflineLibraryScreen(),
                ),
              );
            },
          ),

          _inputButton(
            context,
            icon: Icons.edit_outlined,
            tooltip: 'Writing practice',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const WritingPracticeScreen(),
                ),
              );
            },
          ),

          const SizedBox(width: 6),

          const Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.keyboard_alt_outlined,
                  color: subtitleBlue,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Ask your English tutor...',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const SpeakingPracticeScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(50),
            child: const CircleAvatar(
              backgroundColor: brandRed,
              radius: 24,
              child: Icon(
                Icons.mic_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      icon: Icon(
        icon,
        color: subtitleBlue,
        size: 21,
      ),
    );
  }

  // ============================================================
  // ABOUT ENGLISH LAB
  // ============================================================

  void _showAboutEnglishLab(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.language_rounded,
                color: brandRed,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'English Lab',
                  style: TextStyle(
                    color: navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'The English Lab provides personalized practice across '
            'speaking, pronunciation, grammar, vocabulary, reading, '
            'writing, conversation, and learning progress.',
            style: TextStyle(
              color: navy,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Got it',
                style: TextStyle(
                  color: brandRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // ABOUT AI TUTOR
  // ============================================================

  void _showAboutTutorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.smart_toy_rounded,
                color: brandRed,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'AI English Tutor',
                  style: TextStyle(
                    color: navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TutorInfoRow(
                icon: Icons.smart_toy_rounded,
                label: 'Tutor',
                value: 'EduVerse AI Tutor',
              ),
              _TutorInfoRow(
                icon: Icons.language_rounded,
                label: 'Focus',
                value: 'English learning',
              ),
              _TutorInfoRow(
                icon: Icons.trending_up_rounded,
                label: 'Mode',
                value: 'Personalized practice',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Got it',
                style: TextStyle(
                  color: brandRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // ALL TOOLS
  // ============================================================

  void _showAllTools(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'English Tools',
                  style: TextStyle(
                    color: navy,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                ListTile(
                  leading: const Icon(
                    Icons.library_books_rounded,
                    color: navy,
                  ),
                  title: const Text('Offline Library'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const OfflineLibraryScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.route_rounded,
                    color: navy,
                  ),
                  title: const Text('Learning Journey'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LearningJourneyScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.emoji_events_rounded,
                    color: navy,
                  ),
                  title: const Text('English Achievements'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const EnglishAchievementsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// ENGLISH TOOL MODEL
// ============================================================

class _EnglishTool {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _EnglishTool({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

// ============================================================
// ENGLISH TOOL CARD
// ============================================================

class _EnglishToolCard extends StatelessWidget {
  final _EnglishTool tool;

  const _EnglishToolCard({
    required this.tool,
  });

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tool.onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: navy,
            width: 1.1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: tool.color,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                tool.icon,
                color: Colors.white,
                size: 23,
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tool.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    tool.subtitle,
                    style: const TextStyle(
                      color: subtitleBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
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
// TUTOR INFO ROW
// ============================================================

class _TutorInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TutorInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: subtitleBlue,
          ),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
              color: subtitleBlue,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: navy,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}