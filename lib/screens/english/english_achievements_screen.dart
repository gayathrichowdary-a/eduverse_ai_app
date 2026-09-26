import 'package:flutter/material.dart';

class EnglishAchievementsScreen extends StatefulWidget {
  const EnglishAchievementsScreen({super.key});

  @override
  State<EnglishAchievementsScreen> createState() => _EnglishAchievementsScreenState();
}

class _EnglishAchievementsScreenState extends State<EnglishAchievementsScreen> {
  // Theme Colors
  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color lightGrey = Color(0xFFF2F4F7);

  int currentQuestion = 1; // Corrected: Starts from 1
  int totalQuestions = 20;
  int? selectedOption; // Track selection (null = none)

  // --- Hints keyed by question number. Add more as you add questions. ---
  static const Map<int, String> _hints = {
    1: "Think about what gives plants their green color — that same pigment is key to capturing sunlight.",
  };

  void _nextQuestion() {
    if (currentQuestion < totalQuestions) {
      setState(() {
        currentQuestion++;
        selectedOption = null; // Reset selection for next question
      });
    } else {
      Navigator.pop(context); // Go back when finished
    }
  }

  void _showHintDialog() {
    final hintText = _hints[currentQuestion] ?? "No hint available for this question yet.";

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Text("Hint",
                      style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                hintText,
                style: const TextStyle(color: navy, fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Got it",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: navy, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Question $currentQuestion / $totalQuestions",
          style: const TextStyle(color: subtitleBlue, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: navy),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        // Progress bar fits the frame perfectly
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: currentQuestion / totalQuestions,
            backgroundColor: lightGrey,
            valueColor: const AlwaysStoppedAnimation<Color>(brandRed),
            minHeight: 4,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Which part of the plant cell is responsible for converting light energy into chemical energy?",
              style: TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.bold, height: 1.3),
            ),
            const SizedBox(height: 25),

            // --- Corrected Image Card (No Labels/Answers Visible) ---
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: navy.withValues(alpha: 0.1)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?q=80&w=1000',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- Multiple Choice List ---
            _buildOption(0, "Chloroplast", "Contains chlorophyll for photosynthesis"),
            _buildOption(1, "Mitochondria", "The powerhouse of the cell"),
            _buildOption(2, "Cell Wall", "Provides structural support"),
            _buildOption(3, "Vacuole", "Stores nutrients and waste products"),

            const SizedBox(height: 100), // Space for bottom actions
          ],
        ),
      ),
      // --- Corrected Bottom Navigation (No Overflow) ---
      bottomSheet: _buildBottomActions(),
    );
  }

  Widget _buildOption(int index, String title, String subtitle) {
    bool isSelected = selectedOption == index;
    return GestureDetector(
      onTap: () => setState(() => selectedOption = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isSelected ? brandRed.withValues(alpha: 0.05) : Colors.transparent,
          border: Border.all(color: isSelected ? brandRed : Colors.transparent),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_off,
              color: isSelected ? brandRed : Colors.grey.shade400,
              size: 24,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: navy, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: subtitleBlue, fontSize: 13)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: lightGrey)),
      ),
      child: Row(
        children: [
          // Previous Text
          TextButton(
            onPressed: currentQuestion > 1 ? () => setState(() => currentQuestion--) : null,
            child: const Text("Previous", style: TextStyle(color: brandRed, fontWeight: FontWeight.bold)),
          ),
          const Spacer(),
          // Hint Button
          OutlinedButton(
            onPressed: _showHintDialog,
            style: OutlinedButton.styleFrom(
              foregroundColor: navy,
              side: const BorderSide(color: navy),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Hint", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          // Next Question Button (Fitted to avoid yellow/black overflow)
          ElevatedButton(
            onPressed: selectedOption != null ? _nextQuestion : null, // Clickable logic
            style: ElevatedButton.styleFrom(
              backgroundColor: brandRed,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Next Question", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}