import 'package:flutter/material.dart';
import 'onboarding_board_selection.dart';

class OnboardingCareerDream extends StatefulWidget {
  const OnboardingCareerDream({super.key});

  @override
  State<OnboardingCareerDream> createState() => _OnboardingCareerDreamState();
}

class _OnboardingCareerDreamState extends State<OnboardingCareerDream> {
  final Color brandRed = const Color(0xFFE8394A);
  final Color navy = const Color(0xFF14213D);

  final List<Map<String, dynamic>> _careers = [
    {'title': 'Doctor', 'icon': Icons.medical_services_rounded, 'sel': false},
    {'title': 'Software Engineer', 'icon': Icons.code_rounded, 'sel': false},
    {'title': 'Space Scientist', 'icon': Icons.rocket_launch_rounded, 'sel': false},
    {'title': 'IPS Officer', 'icon': Icons.shield_rounded, 'sel': false},
    {'title': 'Teacher', 'icon': Icons.school_rounded, 'sel': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Career Dream", style: TextStyle(color: Color(0xFF6B7A8F), fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 8),
                    const Text("What would you like to become?", style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Color(0xFF14213D), height: 1.1)),
                    const SizedBox(height: 30),
                    // Use a List instead of Grid so Font Size 24 fits perfectly
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _careers.length,
                      itemBuilder: (context, index) {
                        final item = _careers[index];
                        return GestureDetector(
                          onTap: () => setState(() => item['sel'] = !item['sel']),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: item['sel'] ? brandRed.withValues(alpha: 0.1) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: item['sel'] ? brandRed : Colors.grey.shade300, width: 3),
                            ),
                            child: Row(
                              children: [
                                Icon(item['icon'], size: 35, color: brandRed),
                                const SizedBox(width: 20),
                                // FONT SIZE 24 - NO WRAPPING
                                Text(item['title'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navy)),
                                const Spacer(),
                                if (item['sel']) Icon(Icons.check_circle, color: brandRed, size: 30),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: brandRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const OnboardingBoardSelection()));
                  },
                  child: const Text("Continue to My Path →", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}