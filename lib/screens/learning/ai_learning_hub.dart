import 'package:flutter/material.dart';
import 'projects_screen.dart';
import 'today_mission_overview.dart';
import 'course_screen.dart';
import 'quiz_screen.dart';
import 'assignment_screen.dart';
import 'announcements_screen.dart';
import 'certification_screen.dart';
import 'student_reports_screen.dart';
// ============================================================
// MODELS
// ============================================================

class DailyPathItem {
  final IconData icon;
  final Color iconBackground;
  final String subject;
  final String title;
  final String duration;
  final VoidCallback? onTap;

  const DailyPathItem({
    required this.icon,
    required this.iconBackground,
    required this.subject,
    required this.title,
    required this.duration,
    this.onTap,
  });
}

enum HubTab {
  home,
  lessons,
  goals,
  mentor,
}

// ============================================================
// SCREEN
// ============================================================

class AiLearningHub extends StatefulWidget {
  final String studentName;
  final int points;
  final String tutorName;
  final String tutorStatus;
  final String tutorMessage;
  final List<DailyPathItem> dailyPath;
  final int examReadinessPercent;
  final String examReadinessNote;
  final String careerInsightLabel;
  final String careerInsightText;

  const AiLearningHub({
    Key? key,
    this.studentName = 'Arjun',
    this.points = 1250,
    this.tutorName = 'Aria: Your AI Tutor',
    this.tutorStatus = 'Ready to explain Quantum Physics',
    this.tutorMessage =
        "Hi Arjun! I've prepared a 5-minute summary of today's "
        "Physics lesson. Ready to dive in?",
    this.dailyPath = const [
      DailyPathItem(
        icon: Icons.science,
        iconBackground: Color(0xFF33B679),
        subject: 'Chemistry',
        title: 'Chemical Bonds',
        duration: '12 min',
      ),
      DailyPathItem(
        icon: Icons.functions,
        iconBackground: Color(0xFFE8394A),
        subject: 'Maths',
        title: 'Calculus Basics',
        duration: '20 min',
      ),
    ],
    this.examReadinessPercent = 72,
    this.examReadinessNote =
        "You're doing great in Algebra! Let's focus on Geometry next.",
    this.careerInsightLabel = 'Career Insight',
    this.careerInsightText =
        'Based on your Math scores, you might love Data Science!',
  }) : super(key: key);

  @override
  State<AiLearningHub> createState() => _AiLearningHubState();
}

// ============================================================
// STATE
// ============================================================

class _AiLearningHubState extends State<AiLearningHub> {
  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color mastGreen = Color(0xFF33B679);
  static const Color mustard = Color(0xFFF4C10F);
  static const Color trackGrey = Color(0xFFE9EDF0);
  static const Color tutorCardBg = Color(0xFFDCF1F8);
  static const Color careerCardBg = Color(0xFFFBF1CE);

  // ==========================================================
  // ACTIVE TAB
  // ==========================================================

  HubTab _activeTab = HubTab.home;

  // ==========================================================
  // COMING SOON
  // ==========================================================

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — hook this up to your next screen.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================================
  // TODAY MISSION OVERVIEW
  // ==========================================================

  void _openTodayMissionOverview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodayMissionOverviewScreen(
          userName: widget.studentName,
          xp: widget.points,
        ),
      ),
    );
  }

  // ==========================================================
  // COURSES SCREEN
  // ==========================================================
  void _openCoursesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CoursesScreen(),
      ),
    );
  }
  // ==========================================================
  // PROJECTS SCREEN
  // ==========================================================

  void _openProjectsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProjectsScreen(),
      ),
    );
  }

  // ==========================================================
  // QUIZ SCREEN
  // ==========================================================

  void _openQuizScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuizScreen(),
      ),
    );
  }

  // ==========================================================
  // ASSIGNMENT SCREEN
  // ==========================================================

  void _openAssignmentScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AssignmentScreen(),
      ),
    );
  }

  // ==========================================================
  // ANNOUNCEMENTS SCREEN
  // ==========================================================

  void _openAnnouncementsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AnnouncementsScreen(),
      ),
    );
  }

  // ==========================================================
  // CERTIFICATION SCREEN
  // ==========================================================

  void _openCertificationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CertificationScreen(),
      ),
    );
  }

  // ==========================================================
  // STUDENT REPORTS SCREEN
  // ==========================================================

  void _openStudentReportsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentReportsScreen(
          studentName: widget.studentName,
        ),
      ),
    );
  }

  // ==========================================================
  // BOTTOM NAVIGATION
  // ==========================================================

  void _onTabTapped(HubTab tab) {
    if (tab == _activeTab) {
      return;
    }

    setState(() {
      _activeTab = tab;
    });

    switch (tab) {
      case HubTab.home:
        break;

      case HubTab.lessons:
        _openCoursesScreen();
        break;

      case HubTab.goals:
        _openStudentReportsScreen();
        break;

      case HubTab.mentor:
        _showComingSoon('Mentor / Ask Aria chat');
        break;
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ======================================================
      // BODY
      // ======================================================

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // HEADER
            // ==================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EduVerse AI',
                          style: TextStyle(
                            color: brandRed,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Personalized Hub',
                          style: TextStyle(
                            color: subtitleBlue,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // XP / POINTS
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: mustard,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: navy,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.points}',
                          style: const TextStyle(
                            color: navy,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(
              color: navy,
              height: 1,
              thickness: 1.4,
            ),

            // ==================================================
            // MAIN CONTENT
            // ==================================================

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==========================================
                    // AI TUTOR CARD
                    // ==========================================

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: tutorCardBg,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: navy,
                          width: 1.4,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // AI ICON
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: mastGreen,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: navy,
                                    width: 1.6,
                                  ),
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

                              const SizedBox(width: 14),

                              // TUTOR DETAILS
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.tutorName,
                                      style: const TextStyle(
                                        color: navy,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),

                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration:
                                              const BoxDecoration(
                                            color: mastGreen,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),

                                        Expanded(
                                          child: Text(
                                            widget.tutorStatus,
                                            style: const TextStyle(
                                              color: subtitleBlue,
                                              fontSize: 13,
                                              fontWeight:
                                                  FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // TUTOR MESSAGE
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(18),
                              border: Border.all(
                                color: navy,
                                width: 1.2,
                              ),
                            ),
                            child: Text(
                              widget.tutorMessage,
                              style: const TextStyle(
                                color: navy,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // TUTOR BUTTONS
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _showComingSoon(
                                        'Start Lesson',
                                      );
                                    },
                                    style:
                                        ElevatedButton.styleFrom(
                                      backgroundColor: brandRed,
                                      elevation: 0,
                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                          50,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'Start Lesson',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      _showComingSoon(
                                        'Ask Aria chat',
                                      );
                                    },
                                    style:
                                        OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: navy,
                                        width: 1.4,
                                      ),
                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                          50,
                                        ),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.edit_rounded,
                                          color: navy,
                                          size: 16,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Ask Aria',
                                          style: TextStyle(
                                            color: navy,
                                            fontSize: 15,
                                            fontWeight:
                                                FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ==========================================
                    // QUICK ACCESS
                    // ==========================================

                    const Text(
                      'Quick Access',
                      style: TextStyle(
                        color: navy,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 14),

                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.95,
                      children: [
                        _QuickAccessTile(
                          icon: Icons.rocket_launch_rounded,
                          background: brandRed,
                          label: 'Projects',
                          onTap: _openProjectsScreen,
                        ),
                        _QuickAccessTile(
                          icon: Icons.quiz_rounded,
                          background: mastGreen,
                          label: 'Quizzes',
                          onTap: _openQuizScreen,
                        ),
                        _QuickAccessTile(
                          icon: Icons.assignment_rounded,
                          background: mustard,
                          label: 'Assignments',
                          onTap: _openAssignmentScreen,
                        ),
                        _QuickAccessTile(
                          icon: Icons.campaign_rounded,
                          background: subtitleBlue,
                          label: 'Announcements',
                          onTap: _openAnnouncementsScreen,
                        ),
                        _QuickAccessTile(
                          icon: Icons.workspace_premium_rounded,
                          background: navy,
                          label: 'Certificates',
                          onTap: _openCertificationScreen,
                        ),
                        _QuickAccessTile(
                          icon: Icons.insert_chart_rounded,
                          background: brandRed,
                          label: 'Reports',
                          onTap: _openStudentReportsScreen,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ==========================================
                    // DAILY PATH
                    // ==========================================

                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Your Daily Path',
                            style: TextStyle(
                              color: navy,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),

                        TextButton(
                          onPressed: _openTodayMissionOverview,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              color: brandRed,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // DAILY PATH CARDS
                    Row(
                      children: List.generate(
                        widget.dailyPath.length * 2 - 1,
                        (i) {
                          if (i.isOdd) {
                            return const SizedBox(width: 14);
                          }

                          final item =
                              widget.dailyPath[i ~/ 2];

                          return Expanded(
                            child: _DailyPathCard(
                              item: item,
                              onTap: item.onTap ??
                                  () => _showComingSoon(
                                        item.title,
                                      ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ==========================================
                    // EXAM READINESS
                    // ==========================================

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(20),
                        border: Border.all(
                          color: navy,
                          width: 1.4,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Exam Readiness',
                            style: TextStyle(
                              color: navy,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(50),
                                  child:
                                      LinearProgressIndicator(
                                    value: widget
                                            .examReadinessPercent /
                                        100,
                                    minHeight: 10,
                                    backgroundColor:
                                        trackGrey,
                                    valueColor:
                                        const AlwaysStoppedAnimation<
                                            Color>(
                                      mastGreen,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Text(
                                '${widget.examReadinessPercent}%',
                                style: const TextStyle(
                                  color: navy,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          Text(
                            widget.examReadinessNote,
                            style: const TextStyle(
                              color: subtitleBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==========================================
                    // CAREER INSIGHT
                    // ==========================================

                    InkWell(
                      onTap: () {
                        _showComingSoon(
                          'Career Insight detail',
                        );
                      },
                      borderRadius:
                          BorderRadius.circular(20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: careerCardBg,
                          borderRadius:
                              BorderRadius.circular(20),
                          border: Border.all(
                            color: navy,
                            width: 1.4,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: mustard,
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.psychology_alt_rounded,
                                color: navy,
                                size: 26,
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.careerInsightLabel,
                                    style: const TextStyle(
                                      color: subtitleBlue,
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    widget.careerInsightText,
                                    style: const TextStyle(
                                      color: navy,
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.w800,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Icon(
                              Icons.chevron_right_rounded,
                              color: navy,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================

      bottomNavigationBar: _HubBottomNav(
        activeTab: _activeTab,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}

// ============================================================
// QUICK ACCESS TILE
// ============================================================

class _QuickAccessTile extends StatelessWidget {
  final IconData icon;
  final Color background;
  final String label;
  final VoidCallback onTap;

  const _QuickAccessTile({
    required this.icon,
    required this.background,
    required this.label,
    required this.onTap,
  });

  static const Color navy = Color(0xFF14213D);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: navy,
            width: 1.4,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: navy,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DAILY PATH CARD
// ============================================================

class _DailyPathCard extends StatelessWidget {
  final DailyPathItem item;
  final VoidCallback onTap;

  const _DailyPathCard({
    required this.item,
    required this.onTap,
  });

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: navy,
            width: 1.4,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: item.iconBackground,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Icon(
                item.icon,
                color: Colors.white,
                size: 22,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              item.subject,
              style: const TextStyle(
                color: subtitleBlue,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              item.title,
              style: const TextStyle(
                color: navy,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: subtitleBlue,
                  size: 15,
                ),

                const SizedBox(width: 6),

                Text(
                  item.duration,
                  style: const TextStyle(
                    color: subtitleBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// BOTTOM NAV BAR
// ============================================================

class _HubBottomNav extends StatelessWidget {
  final HubTab activeTab;
  final ValueChanged<HubTab> onTabTapped;

  const _HubBottomNav({
    required this.activeTab,
    required this.onTabTapped,
  });

  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color trackGrey = Color(0xFFE9EDF0);

  static const List<_NavItemData> _items = [
    _NavItemData(
      tab: HubTab.home,
      icon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItemData(
      tab: HubTab.lessons,
      icon: Icons.menu_book_rounded,
      label: 'Lessons',
    ),
    _NavItemData(
      tab: HubTab.goals,
      icon: Icons.emoji_events_rounded,
      label: 'Goals',
    ),
    _NavItemData(
      tab: HubTab.mentor,
      icon: Icons.face_retouching_natural_rounded,
      label: 'Mentor',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: trackGrey,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
          children: _items.map((item) {
            final selected =
                item.tab == activeTab;

            final color = selected
                ? brandRed
                : navy.withOpacity(0.55);

            return InkWell(
              onTap: () => onTabTapped(item.tab),
              borderRadius:
                  BorderRadius.circular(12),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      color: color,
                      size: 24,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      item.label,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ============================================================
// NAVIGATION ITEM MODEL
// ============================================================

class _NavItemData {
  final HubTab tab;
  final IconData icon;
  final String label;

  const _NavItemData({
    required this.tab,
    required this.icon,
    required this.label,
  });
}