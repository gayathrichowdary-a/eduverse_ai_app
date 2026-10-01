import 'package:flutter/material.dart';

// --- Screen Imports ---
import '../ai_features/ai_hub_screen.dart';
import '../ai_features/ai_scanner_analysis.dart';
import '../ai_features/ai_voice_conversation.dart';
import '../ai_features/interactive_model_screen.dart';
import '../ai_features/ai_mentor_hub.dart';
import '../tracking_rewards/goal_habit_tracker.dart';
import '../career/career_explorer_hub.dart';
import '../english/english_lab_dashboard.dart';
import '../settings/settings_profile.dart';
import 'live_ai_hunt.dart';
import 'knowledge_hub_screen.dart';
import 'daily_assessment_hub.dart';
import 'assessment_selection.dart';
import 'ai_media_studio_screen.dart';

enum MainTab { home, learn, ai, practice, me }

class StudentDashboard extends StatefulWidget {
  final String studentName;
  final String avatarInitial;

  const StudentDashboard({
    super.key,
    this.studentName = 'Arjun',
    this.avatarInitial = 'A',
  });

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  // Sir's Brand Colors
  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color brandGradientEnd = Color(0xFFF12C68);
  static const Color textMuted = Color(0xFF667085);
  static const Color cardBorder = Color(0xFFE4E7EC);
  static const Color bgSurface = Color(0xFFF8F9FC);

  MainTab _activeTab = MainTab.home;

  // Today's Mission Checklist state
  final List<Map<String, dynamic>> _missions = [
    {
      'title': 'Maths – Fractions',
      'duration': '20 min',
      'icon': Icons.calculate_outlined,
      'color': Color(0xFF0086C9),
      'done': false,
    },
    {
      'title': 'Science – Electricity',
      'duration': '15 min',
      'icon': Icons.science_outlined,
      'color': Color(0xFF12B76A),
      'done': false,
    },
    {
      'title': 'English – Reading',
      'duration': '15 min',
      'icon': Icons.menu_book_rounded,
      'color': Color(0xFF7F56D9),
      'done': false,
    },
    {
      'title': 'Practice Quiz',
      'duration': '10 min',
      'icon': Icons.sports_esports_outlined,
      'color': Color(0xFFF79009),
      'done': false,
    },
  ];

  int get _completedMissionsCount =>
      _missions.where((m) => m['done'] == true).length;

  void _onTabTapped(MainTab tab) {
    setState(() => _activeTab = tab);
  }

  // --- Navigation Methods ---
  void _openAskAI() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AiMentorHub()),
    );
  }

  void _openVoiceTutor() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AiVoiceConversation()),
    );
  }

  void _openScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AiScannerAnalysis()),
    );
  }

  void _openPractice() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AssessmentSelection()),
    );
  }

  void _openCareer() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CareerExplorerHub()),
    );
  }

  // Opens Real AI Media Studio with Topic Search, MP3 & MP4!
  void _openVideoClass() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AIMediaStudioScreen(),
      ),
    );
  }

  Widget _buildBodyForActiveTab() {
    switch (_activeTab) {
      case MainTab.home:
        return _buildHomeContent();
      case MainTab.learn:
        return const KnowledgeHubScreen();
      case MainTab.ai:
        return const AiHubScreen();
      case MainTab.practice:
        return const GoalHabitTracker();
      case MainTab.me:
        return const SettingsProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSurface,
      body: SafeArea(
        child: _buildBodyForActiveTab(),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ============================================================
  // HOME CONTENT
  // ============================================================
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. TOP HEADER
          _buildHeader(),
          const SizedBox(height: 16),

          // 2. HERO GREETING BANNER WITH BOY IMAGE
          _buildHeroGreeting(),
          const SizedBox(height: 18),

          // 3. TWO-COLUMN: TODAY'S MISSION & (STREAK + EXAM)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Today's Mission
              Expanded(
                flex: 11,
                child: _buildTodaysMissionCard(),
              ),
              const SizedBox(width: 12),
              // Right: Streak & Next Exam stacked
              Expanded(
                flex: 9,
                child: Column(
                  children: [
                    _buildLearningStreakCard(),
                    const SizedBox(height: 12),
                    _buildNextExamCard(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 4. CONTINUE LEARNING (CONNECTS DIRECTLY TO AI MEDIA STUDIO)
          _buildContinueLearningCard(),
          const SizedBox(height: 22),

          // 5. QUICK ACTIONS
          _buildSectionTitle('Quick Actions', icon: Icons.auto_awesome),
          const SizedBox(height: 12),
          _buildQuickActionsGrid(),
          const SizedBox(height: 22),

          // 6. EXPLORE MORE (ALL 8 BUTTONS WORKING)
          _buildSectionTitle('Explore More'),
          const SizedBox(height: 12),
          _buildExploreMoreGrid(),
          const SizedBox(height: 20),

          // 7. TALK TO EDUVERSE AI BANNER
          _buildTalkToAiBanner(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: navy,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.school_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'EduVerse ',
                style: TextStyle(
                  color: navy,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              TextSpan(
                text: 'AI',
                style: TextStyle(
                  color: brandRed,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),

        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: navy, size: 22),
          visualDensity: VisualDensity.compact,
        ),

        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded,
                  color: navy, size: 22),
              visualDensity: VisualDensity.compact,
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: brandRed,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 4),

        GestureDetector(
          onTap: () => _onTabTapped(MainTab.me),
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFFDB022),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.avatarInitial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HERO GREETING (LOADS THE BOY IMAGE FROM ASSETS)
  // ============================================================
  Widget _buildHeroGreeting() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good Morning,',
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '${widget.studentName}!',
                      style: const TextStyle(
                        color: navy,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('👋', style: TextStyle(fontSize: 22)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ready to learn something new today?',
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // 3D Student Boy Character Image (loads assets/onboarding_1.png)
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 76,
                  height: 76,
                  child: Image.asset(
                    'assets/onboarding_1.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/hero.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFFF0F2),
                                  Color(0xFFFEE4E2)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.face_rounded,
                                color: brandRed,
                                size: 42,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: brandRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '✨',
                    style: TextStyle(fontSize: 10),
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
  // TODAY'S MISSION CARD (LEFT COLUMN)
  // ============================================================
  Widget _buildTodaysMissionCard() {
    final double progress = _missions.isEmpty
        ? 0.0
        : _completedMissionsCount / _missions.length;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF0F2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.track_changes_rounded,
                    color: brandRed, size: 16),
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  "Today's Mission",
                  style: TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '60 min',
                  style: TextStyle(
                    color: navy,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Complete these to stay on track',
            style: TextStyle(color: textMuted, fontSize: 10),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: const Color(0xFFF2F4F7),
                    valueColor: const AlwaysStoppedAnimation<Color>(brandRed),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$_completedMissionsCount/4',
                style: const TextStyle(
                  color: textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          ...List.generate(_missions.length, (index) {
            final m = _missions[index];
            final bool isDone = m['done'] == true;

            return InkWell(
              onTap: () {
                setState(() {
                  m['done'] = !isDone;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      isDone
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked,
                      size: 16,
                      color:
                          isDone ? Color(0xFF12B76A) : const Color(0xFFD0D5DD),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: (m['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        m['icon'] as IconData,
                        color: m['color'] as Color,
                        size: 12,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        m['title'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDone ? textMuted : navy,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          decoration:
                              isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    Text(
                      m['duration'] as String,
                      style: const TextStyle(color: textMuted, fontSize: 10),
                    ),
                    const Icon(Icons.chevron_right,
                        size: 14, color: Color(0xFFD0D5DD)),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [brandRed, brandGradientEnd],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: brandRed.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _openVideoClass, // Opens AI Media Studio
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.zero,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start My Day',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LEARNING STREAK CARD
  // ============================================================
  Widget _buildLearningStreakCard() {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    const streakDays = [true, true, true, true, false, false, false];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_fire_department_rounded,
                  color: Color(0xFFF79009), size: 18),
              SizedBox(width: 4),
              Text(
                'Learning Streak',
                style: TextStyle(
                  color: textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: '5 ',
                  style: TextStyle(
                    color: brandRed,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: 'Days',
                  style: TextStyle(
                    color: navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final active = streakDays[i];
              return Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active ? brandRed : const Color(0xFFF2F4F7),
                    ),
                    child: active
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 10)
                        : null,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    days[i],
                    style: const TextStyle(
                      color: textMuted,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NEXT EXAM CARD
  // ============================================================
  Widget _buildNextExamCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AssessmentSelection()),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cardBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.calendar_month_outlined,
                          color: Color(0xFF0086C9), size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Next Exam',
                        style: TextStyle(
                          color: textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(Icons.chevron_right, size: 14, color: textMuted),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Science',
                    style: TextStyle(
                      color: navy,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '12 days left',
                    style: TextStyle(
                      color: brandRed,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFECDCA)),
              ),
              child: const Text(
                'A+',
                style: TextStyle(
                  color: brandRed,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CONTINUE LEARNING (CONNECTS DIRECTLY TO AI MEDIA STUDIO)
  // ============================================================
  Widget _buildContinueLearningCard() {
    return InkWell(
      onTap: _openVideoClass,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.play_circle_fill_rounded,
                    color: brandRed, size: 20),
                const SizedBox(width: 6),
                const Text(
                  'Continue Learning',
                  style: TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.video_library_rounded,
                          size: 13, color: brandRed),
                      SizedBox(width: 4),
                      Text(
                        'AI Video Studio',
                        style: TextStyle(
                          color: brandRed,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.smart_display_rounded,
                        color: brandRed,
                        size: 28,
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: brandRed.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 16),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search & Learn with 2D Video',
                        style: TextStyle(
                          color: navy,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Tap to search any topic, watch MP4 animation & quiz',
                        style: TextStyle(color: textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: textMuted),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // QUICK ACTIONS GRID (4 Cards)
  // ============================================================
  Widget _buildQuickActionsGrid() {
    return Row(
      children: [
        Expanded(
          child: _quickActionCard(
            title: 'All Subjects',
            subtitle: 'Class-wise\nlessons',
            icon: Icons.menu_book_rounded,
            iconBg: const Color(0xFFE8FDF2),
            iconColor: const Color(0xFF12B76A),
            onTap: () => _onTabTapped(MainTab.learn),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _quickActionCard(
            title: 'Ask AI',
            subtitle: 'Doubts &\nexplanations',
            icon: Icons.smart_toy_rounded,
            iconBg: const Color(0xFFF4F3FF),
            iconColor: const Color(0xFF7F56D9),
            onTap: _openAskAI,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _quickActionCard(
            title: 'Scan & Solve',
            subtitle: 'Homework\n& questions',
            icon: Icons.camera_alt_rounded,
            iconBg: const Color(0xFFFEF6EE),
            iconColor: const Color(0xFFF79009),
            onTap: _openScanner,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _quickActionCard(
            title: 'Practice',
            subtitle: 'Quizzes &\nPYQs',
            icon: Icons.track_changes_rounded,
            iconBg: const Color(0xFFFFF0F2),
            iconColor: brandRed,
            onTap: _openPractice,
          ),
        ),
      ],
    );
  }

  Widget _quickActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cardBorder),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: navy,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                color: textMuted,
                fontSize: 10,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EXPLORE MORE GRID
  // ============================================================
  Widget _buildExploreMoreGrid() {
    final items = [
      {
        'title': 'Career Explorer',
        'icon': Icons.explore_outlined,
        'color': const Color(0xFF7F56D9),
        'action': _openCareer,
      },
      {
        'title': 'Exam Mission',
        'icon': Icons.event_note_rounded,
        'color': const Color(0xFFEF3340),
        'action': _openPractice,
      },
      {
        'title': 'Voice Tutor',
        'icon': Icons.mic_none_rounded,
        'color': const Color(0xFF0086C9),
        'action': _openVoiceTutor,
      },
      {
        'title': 'AI Media Studio',
        'icon': Icons.video_library_outlined,
        'color': const Color(0xFFF79009),
        'action': _openVideoClass,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3.2,
      ),
      itemBuilder: (context, i) {
        final item = items[i];
        final VoidCallback action = item['action'] as VoidCallback;

        return InkWell(
          onTap: action,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cardBorder),
            ),
            child: Row(
              children: [
                Icon(
                  item['icon'] as IconData,
                  color: item['color'] as Color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item['title'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right,
                    size: 16, color: Color(0xFFD0D5DD)),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // TALK TO EDUVERSE AI BANNER
  // ============================================================
  Widget _buildTalkToAiBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEDE9FE), Color(0xFFFCE7F3)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9D7FE)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: Color(0xFF7F56D9), size: 26),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Talk to EduVerse AI',
                  style: TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Need help? Just ask or speak!',
                  style: TextStyle(color: textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _openVoiceTutor,
            icon: const Icon(Icons.mic, color: Colors.white, size: 16),
            label: const Text(
              'Chat Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: navy,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: const Color(0xFFF79009), size: 16),
          const SizedBox(width: 6),
        ],
        Text(
          title,
          style: const TextStyle(
            color: navy,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // 5-TAB BOTTOM NAVIGATION
  // ============================================================
  Widget _buildBottomNav() {
    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF2F4F7), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomNavItem(MainTab.home, Icons.home_rounded, 'Home'),
          _bottomNavItem(MainTab.learn, Icons.menu_book_rounded, 'Learn'),
          _bottomNavItem(MainTab.ai, Icons.smart_toy_rounded, 'AI',
              isSpecial: true),
          _bottomNavItem(
              MainTab.practice, Icons.emoji_events_rounded, 'Practice'),
          _bottomNavItem(MainTab.me, Icons.person_outline_rounded, 'Me'),
        ],
      ),
    );
  }

  Widget _bottomNavItem(MainTab tab, IconData icon, String label,
      {bool isSpecial = false}) {
    final bool isSelected = _activeTab == tab;

    if (isSpecial) {
      return GestureDetector(
        onTap: () => _onTabTapped(tab),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: navy,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x331D3B64),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.smart_toy_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? brandRed : textMuted,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: () => _onTabTapped(tab),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: isSelected ? brandRed : textMuted,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? brandRed : textMuted,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: brandRed,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}