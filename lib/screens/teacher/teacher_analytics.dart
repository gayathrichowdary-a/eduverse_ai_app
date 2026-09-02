import 'package:flutter/material.dart';

class TeacherAnalytics extends StatelessWidget {
  const TeacherAnalytics({super.key});

  // Colors
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
        title: const Text(
          "Analytics", // Correct Spelling: A-N-A-L-Y-T-I-C-S
          style: TextStyle(color: navy, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Performance Overview",
              style: TextStyle(color: navy, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // --- Performance Cards using INTEGERS for logic ---
            Row(
              children: [
                // Pass integers here (84, 12), logic converts them to String
                _buildMetricCard("Avg Score", 84, "%", Colors.blue),
                const SizedBox(width: 15),
                _buildMetricCard("Active Students", 38, "", Colors.green),
              ],
            ),

            const SizedBox(height: 25),

            // --- Subject Breakdown Section ---
            const Text(
              "Subject Proficiency",
              style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Correcting the "Integer" issue: Logic uses int, UI shows String
            _buildProgressBar("Mathematics", 75, Colors.orange),
            _buildProgressBar("Physics", 62, Colors.purple),
            _buildProgressBar("English", 90, Colors.green),

            const SizedBox(height: 30),

            // --- AI Summary Card ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4F8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "AI Insight",
                    style: TextStyle(color: brandRed, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "The class average in Physics has increased by 12% this week. Great job!",
                    style: TextStyle(color: navy, fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FIXED: This function takes an 'int' value to solve the integer error
  Widget _buildMetricCard(String title, int value, String unit, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: navy.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: subtitleBlue, fontSize: 12)),
            const SizedBox(height: 10),
            // value.toString() converts the integer to text safely
            Text(
              "${value.toString()}$unit", 
              style: TextStyle(color: navy, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String label, int percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: navy, fontWeight: FontWeight.w600)),
              Text("${percentage.toString()}%", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage / 100, // Converts int to double for the bar
              minHeight: 8,
              backgroundColor: const Color(0xFFEEEEEE),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}