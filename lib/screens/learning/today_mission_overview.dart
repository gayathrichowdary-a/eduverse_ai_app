import 'package:flutter/material.dart';

// ============================================================
// MODELS
// ============================================================

class MentorItem {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;

  const MentorItem({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
  });
}

class ScheduleTask {
  final String title;
  final String time;
  final bool isCompleted;
  final VoidCallback? onTap;

  const ScheduleTask({
    required this.title,
    required this.time,
    required this.isCompleted,
    this.onTap,
  });
}

// ============================================================
// TODAY'S MISSION OVERVIEW SCREEN
// ============================================================

class TodayMissionOverviewScreen extends StatelessWidget {
  final String userName;
  final int xp;
  final int streakDays;
  final double dailyGoalPercent; // 0.0 - 1.0
  final int modulesCompleted;
  final int modulesTotal;

  const TodayMissionOverviewScreen({
    super.key,
    this.userName = 'Akhil',
    this.xp = 1240,
    this.streakDays = 12,
    this.dailyGoalPercent = 0.65,
    this.modulesCompleted = 2,
    this.modulesTotal = 3,
  });

  static const Color navy = Color(0xFF0D2137);
  static const Color yellow = Color(0xFFFFC72C);
  static const Color green = Color(0xFF2ECC71);
  static const Color blueAccent = Color(0xFF4FC3E8);
  static const Color red = Color(0xFFE8483C);
  static const Color textBlue = Color(0xFF5A7A9E);

  final List<MentorItem> _mentors = const [
    MentorItem(
      icon: Icons.school,
      iconColor: navy,
      bgColor: Color(0xFF5AC8FA),
      label: 'AI Tutor',
    ),
    MentorItem(
      icon: Icons.work,
      iconColor: navy,
      bgColor: yellow,
      label: 'Career',
    ),
    MentorItem(
      icon: Icons.fitness_center,
      iconColor: navy,
      bgColor: Color(0xFF3CB878),
      label: 'Fitness',
    ),
    MentorItem(
      icon: Icons.favorite,
      iconColor: Colors.white,
      bgColor: red,
      label: 'Wellness',
    ),
  ];

  List<ScheduleTask> get _schedule => [
        const ScheduleTask(
          title: 'Math: Quadratic Equations',
          time: '09:00 AM',
          isCompleted: true,
        ),
        const ScheduleTask(
          title: 'Science: Chemical Bonds',
          time: '11:30 AM',
          isCompleted: true,
        ),
        const ScheduleTask(
          title: 'Mock Test: JEE Prep',
          time: '04:00 PM',
          isCompleted: false,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildMentorsSection(),
              const SizedBox(height: 24),
              _buildScheduleSection(),
              const SizedBox(height: 16),
              _buildFeaturedCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: yellow,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Good Morning, $userName!',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: navy,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('☀️', style: TextStyle(fontSize: 24)),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 26,
                backgroundColor: blueAccent,
                child: Text(
                  userName.isNotEmpty
                      ? userName.substring(0, 1).toUpperCase() +
                          (userName.length > 1
                              ? userName.substring(1, 2).toUpperCase()
                              : '')
                      : '',
                  style: const TextStyle(
                    color: navy,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _pillBadge(
                icon: Icons.bolt,
                iconColor: yellow,
                label: '$xp XP',
                bgColor: navy,
                textColor: Colors.white,
              ),
              const SizedBox(width: 10),
              _pillBadge(
                icon: Icons.local_fire_department,
                iconColor: red,
                label: '$streakDays Day Streak',
                bgColor: Colors.white,
                textColor: navy,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDailyGoalCard(),
        ],
      ),
    );
  }

  Widget _pillBadge({
    required IconData icon,
    required Color iconColor,
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyGoalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: navy, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: navy,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    value: dailyGoalPercent,
                    strokeWidth: 6,
                    backgroundColor: const Color(0xFFE8E8E8),
                    valueColor: const AlwaysStoppedAnimation<Color>(green),
                  ),
                ),
                Text(
                  '${(dailyGoalPercent * 100).round()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: navy,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Goal Progress',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$modulesCompleted of $modulesTotal modules completed',
                  style: const TextStyle(
                    color: textBlue,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- MENTORS ----------------
  Widget _buildMentorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your AI Mentors',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: wire "See All" navigation
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: red,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _mentors.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final mentor = _mentors[index];
              return _mentorCard(mentor);
            },
          ),
        ),
      ],
    );
  }

  Widget _mentorCard(MentorItem mentor) {
    return Container(
      width: 96,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: navy, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: mentor.bgColor,
            child: Icon(mentor.icon, color: mentor.iconColor, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            mentor.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: navy,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- SCHEDULE ----------------
  Widget _buildScheduleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Schedule",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: navy,
            ),
          ),
          const SizedBox(height: 14),
          ..._schedule.map((task) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _scheduleCard(task),
              )),
        ],
      ),
    );
  }

  Widget _scheduleCard(ScheduleTask task) {
    return InkWell(
      onTap: task.onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: navy, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: task.isCompleted ? green : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: task.isCompleted ? green : const Color(0xFFCCCCCC),
                  width: 1.5,
                ),
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: textBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    task.time,
                    style: const TextStyle(
                      color: textBlue,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: navy),
          ],
        ),
      ),
    );
  }

  // ---------------- FEATURED CARD ----------------
  Widget _buildFeaturedCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: blueAccent,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: navy, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: navy, width: 1.2),
              ),
              child: const Text(
                'FEATURED',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 0.5,
                  color: navy,
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Mastering Space-Time with AI Mentor',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: navy,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: navy,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow,
                          color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '15 mins left',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: navy,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: wire "Continue" navigation to the lesson screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- BOTTOM NAV ----------------
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: navy, width: 1.5)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(icon: Icons.grid_view_rounded, label: 'Home', active: true),
            _navItem(icon: Icons.menu_book_rounded, label: 'Learn', active: false),
            _navItem(icon: Icons.psychology_alt_rounded, label: 'AI Chat', active: false),
            _navItem(icon: Icons.bar_chart_rounded, label: 'Stats', active: false),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool active,
  }) {
    final color = active ? red : navy;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}