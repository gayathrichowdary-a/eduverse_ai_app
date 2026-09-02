import 'package:flutter/material.dart';

class LearningJourneyScreen extends StatelessWidget {
  const LearningJourneyScreen({super.key});

  // Theme Colors
  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color lightPink = Color(0xFFFDE8E9);
  static const Color activeGreen = Color(0xFF4ADE80);

  // --- Mock: which days in the month had study activity ---
  // In a real app this would come from your backend / local DB.
  static const Set<int> _activeDays = {
    1, 2, 4, 5, 7, 8, 10, 11, 13, 14, 16, 17, 19, 20, 22, 23, 25, 26, 28, 29,
  };
  static const int _daysInMonth = 31; // May 2024
  static const int _firstWeekdayOffset = 3; // May 1, 2024 was a Wednesday (0=Mon)
  static const int _todayDate = 29;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Learning Journey",
                style: TextStyle(color: navy, fontSize: 24, fontWeight: FontWeight.bold)),
            Text("May 2024",
                style: TextStyle(color: subtitleBlue, fontSize: 14)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined, color: brandRed),
            onPressed: () => _showActivityCalendar(context),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // --- 1. Streak Banner ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: lightPink.withOpacity(0.5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: brandRed,
                    child: Icon(Icons.local_fire_department, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("14 Day Streak!",
                            style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("You're in the top 5% of learners this week",
                            style: TextStyle(color: subtitleBlue, fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text("Study Activity",
                style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // --- 2. GitHub-style Activity Dots ---
            _buildActivityGrid(),

            const SizedBox(height: 35),
            const Text("Upcoming Milestones",
                style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // --- 3. Milestone Cards ---
            _buildMilestoneCard("JEE Mock Test - Phase 1", "In 2 days", Icons.assignment, Colors.orange),
            _buildMilestoneCard("Physics Semester Finals", "May 24, 2024", Icons.school, Colors.blueAccent),

            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Today's Progress",
                    style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold)),
                Text("3 Lessons",
                    style: TextStyle(color: brandRed, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),

            // --- 4. Today's Progress List ---
            _buildProgressCard("Quantum Mechanics Basics", "Physics", "45m", Icons.functions, brandRed),
            _buildProgressCard("Organic Synthesis", "Chemistry", "30m", Icons.science, Colors.cyan),
            _buildProgressCard("Calculus: Integration", "Mathematics", "1h 10m", Icons.architecture, Colors.amber),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- NEW: Activity calendar bottom sheet ---
  void _showActivityCalendar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.92,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.local_fire_department, color: brandRed, size: 22),
                        SizedBox(width: 8),
                        Text("Study Activity Calendar",
                            style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text("May 2024 · 14 day streak",
                        style: TextStyle(color: subtitleBlue, fontSize: 13)),
                    const SizedBox(height: 20),
                    _buildWeekdayHeader(),
                    const SizedBox(height: 10),
                    _buildMonthGrid(),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildLegendDot(activeGreen, "Studied"),
                        const SizedBox(width: 20),
                        _buildLegendDot(Colors.grey.shade200, "No activity"),
                        const SizedBox(width: 20),
                        _buildLegendDot(brandRed, "Today"),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildWeekdayHeader() {
    const labels = ["M", "T", "W", "T", "F", "S", "S"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels
          .map((l) => SizedBox(
                width: 32,
                child: Text(
                  l,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: subtitleBlue, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildMonthGrid() {
    final totalCells = _firstWeekdayOffset + _daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rows, (row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (col) {
              final cellIndex = row * 7 + col;
              final day = cellIndex - _firstWeekdayOffset + 1;

              if (day < 1 || day > _daysInMonth) {
                return const SizedBox(width: 32, height: 32);
              }

              final isActive = _activeDays.contains(day);
              final isToday = day == _todayDate;

              return Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isToday
                      ? brandRed
                      : (isActive ? activeGreen : Colors.grey.shade100),
                ),
                child: Text(
                  "$day",
                  style: TextStyle(
                    color: isToday || isActive ? Colors.white : subtitleBlue,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: navy, fontSize: 12)),
      ],
    );
  }

  Widget _buildActivityGrid() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(15, (index) {
              return CircleAvatar(
                radius: 6,
                backgroundColor: index % 3 == 0 ? Colors.grey.shade100 : Colors.greenAccent.shade400,
              );
            }),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Less", style: TextStyle(color: subtitleBlue, fontSize: 10)),
              Text("More", style: TextStyle(color: subtitleBlue, fontSize: 10)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(String title, String sub, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: navy, width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: navy, fontWeight: FontWeight.bold, fontSize: 15)),
                Text(sub, style: const TextStyle(color: subtitleBlue, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: subtitleBlue),
        ],
      ),
    );
  }

  Widget _buildProgressCard(String title, String subject, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: navy, width: 2),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: const TextStyle(color: subtitleBlue, fontSize: 11, fontWeight: FontWeight.bold)),
                Text(title, style: const TextStyle(color: navy, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: subtitleBlue),
                    const SizedBox(width: 5),
                    Text(time, style: const TextStyle(color: subtitleBlue, fontSize: 12)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}