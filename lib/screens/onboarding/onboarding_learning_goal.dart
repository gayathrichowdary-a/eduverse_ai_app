import 'package:flutter/material.dart';
import 'onboarding_learning_style.dart';

class OnboardingLearningGoal extends StatefulWidget {
  const OnboardingLearningGoal({super.key});

  @override
  State<OnboardingLearningGoal> createState() =>
      _OnboardingLearningGoalState();
}

class _OnboardingLearningGoalState extends State<OnboardingLearningGoal> {
  // ================= SIR'S BRAND DESIGN COLORS =================
  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color brandGradientEnd = Color(0xFFF12C68);
  static const Color textMuted = Color(0xFF667085);
  static const Color cardBorder = Color(0xFFE4E7EC);

  String selectedGoal = 'Ace Exams & Score 90%+';

  final List<Map<String, dynamic>> goals = [
    {
      'title': 'Ace Exams & Score 90%+',
      'desc': 'Structured revision, chapter tests & previous year questions',
      'icon': Icons.emoji_events_outlined,
    },
    {
      'title': 'Master Deep Concepts',
      'desc': 'Clear foundational doubts with AI 1-on-1 explanations',
      'icon': Icons.lightbulb_outline,
    },
    {
      'title': 'Competitive Prep (JEE/NEET)',
      'desc': 'Speed mastery, mock tests & advanced problem solving',
      'icon': Icons.rocket_launch_outlined,
    },
    {
      'title': 'Build Real-World AI Skills',
      'desc': 'Coding, logic building, projects & future career readiness',
      'icon': Icons.psychology_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 20),
          // ================= 6-SEGMENT PROGRESS BAR (STEP 4 OF 6) =================
          child: Row(
            children: List.generate(6, (index) {
              final bool isActive = index <= 3; // First 4 segments active
              return Expanded(
                child: Container(
                  height: 5,
                  margin: EdgeInsets.only(right: index == 5 ? 0 : 6),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? const LinearGradient(
                            colors: [brandRed, brandGradientEnd],
                          )
                        : null,
                    color: isActive ? null : const Color(0xFFF0F2F4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ================= SCROLLABLE CONTENT =================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title in Sir's exact typography
                    const Text(
                      'What is your main\nlearning goal?',
                      style: TextStyle(
                        color: navy,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    const Text(
                      'EduVerse AI will personalize your curriculum and mentors based on your choice.',
                      style: TextStyle(
                        color: textMuted,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Goal Cards
                    ...goals.map((g) {
                      final isSelected = selectedGoal == g['title'];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedGoal = g['title'] as String;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFFFF0F2) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? brandRed : cardBorder,
                                width: isSelected ? 2.0 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? brandRed.withOpacity(0.08)
                                      : Colors.black.withOpacity(0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isSelected ? brandRed : const Color(0xFFF2F4F7),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    g['icon'] as IconData,
                                    color: isSelected ? Colors.white : navy,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        g['title'] as String,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected ? brandRed : navy,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        g['desc'] as String,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: textMuted,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? brandRed : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected ? brandRed : cardBorder,
                                      width: isSelected ? 0 : 1.5,
                                    ),
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            // ================= BOTTOM CAPSULE CONTINUE BUTTON =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFF2F4F7),
                    width: 1,
                  ),
                ),
              ),
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [brandRed, brandGradientEnd],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30), // Sir's capsule pill shape
                  boxShadow: [
                    BoxShadow(
                      color: brandRed.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _continue() {
    FocusScope.of(context).unfocus();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingLearningStyle(),
      ),
    );
  }
}