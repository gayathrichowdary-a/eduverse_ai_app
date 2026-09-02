import 'package:flutter/material.dart';

class GoalHabitTracker extends StatefulWidget {
  const GoalHabitTracker({super.key});

  @override
  State<GoalHabitTracker> createState() => _GoalHabitTrackerState();
}

class _GoalHabitTrackerState extends State<GoalHabitTracker> {
  // Palette
  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("TRACKING & REWARDS", 
          style: TextStyle(color: navy, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 84. GOAL TRACKER SECTION ---
            const Text("Your Goals", style: TextStyle(color: navy, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildGoalItem("Complete Algebra Module", 0.7, Colors.orange),
            _buildGoalItem("Read 10 Pages of Physics", 0.3, brandRed),
            _buildGoalItem("Practice English Speaking", 0.9, Colors.green),

            const SizedBox(height: 40),

            // --- 85. HABIT TRACKER SECTION ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Habit Tracker", style: TextStyle(color: navy, fontSize: 22, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text("View All", style: TextStyle(color: brandRed))),
              ],
            ),
            const SizedBox(height: 10),
            _buildHabitCard("Morning Meditation", "12 Day Streak", Icons.self_improvement, Colors.purple),
            _buildHabitCard("Water Intake (3L)", "5 Day Streak", Icons.local_drink, Colors.blue),
            _buildHabitCard("Daily Reading", "8 Day Streak", Icons.menu_book, Colors.orange),

            const SizedBox(height: 30),

            // --- REWARDS / STREAK PREVIEW ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars, color: Colors.amber, size: 40),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("You're on Fire!", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Maintain your streak to unlock the 'Scholar' badge.", style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem(String title, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: navy, fontWeight: FontWeight.w600)),
              Text("${(progress * 100).toInt()}%", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildHabitCard(String title, String streak, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: navy, fontWeight: FontWeight.bold)),
                Text(streak, style: const TextStyle(color: subtitleBlue, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.check_circle_outline, color: Colors.grey),
        ],
      ),
    );
  }
}