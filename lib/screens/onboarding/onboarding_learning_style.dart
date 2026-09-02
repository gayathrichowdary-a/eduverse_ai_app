import 'package:flutter/material.dart';
// IMPORT ADDED
import 'onboarding_interest_selection.dart'; 

class OnboardingLearningStyle extends StatefulWidget {
  const OnboardingLearningStyle({super.key});

  @override
  State<OnboardingLearningStyle> createState() => _OnboardingLearningStyleState();
}

class _OnboardingLearningStyleState extends State<OnboardingLearningStyle> {
  final Color brandRed = const Color(0xFFE8394A);
  final Color navy = const Color(0xFF14213D);

  // List of styles with icons and titles
  final List<Map<String, dynamic>> _styles = [
    {'title': 'Watching', 'icon': Icons.play_circle_fill, 'sel': false},
    {'title': 'Reading', 'icon': Icons.menu_book_rounded, 'sel': false},
    {'title': 'Listening', 'icon': Icons.headphones, 'sel': false},
    {'title': 'Writing', 'icon': Icons.edit_note_rounded, 'sel': false},
    {'title': 'Hands-on', 'icon': Icons.science_rounded, 'sel': false},
    {'title': 'Discussion', 'icon': Icons.forum_rounded, 'sel': false},
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
                  children: [
                    // BIG HEADER FOR STUDENTS
                    const Text(
                      "How do you learn best?", 
                      textAlign: TextAlign.center, 
                      style: TextStyle(
                        fontSize: 36, 
                        fontWeight: FontWeight.w900, 
                        color: Color(0xFF14213D)
                      )
                    ),
                    const SizedBox(height: 30),
                    
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, 
                        mainAxisSpacing: 15, 
                        crossAxisSpacing: 15,
                        mainAxisExtent: 190, // HEIGHT INCREASED TO PREVENT TEXT SPLITTING
                      ),
                      itemCount: _styles.length,
                      itemBuilder: (context, index) {
                        final item = _styles[index];
                        return GestureDetector(
                          onTap: () => setState(() => item['sel'] = !item['sel']),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: item['sel'] ? brandRed.withValues(alpha: 0.1) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: item['sel'] ? brandRed : Colors.grey.shade300, 
                                width: 3
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(item['icon'], size: 50, color: brandRed),
                                const SizedBox(height: 12),
                                // FONT SIZE 24 - LARGE AND BOLD
                                Text(
                                  item['title'], 
                                  textAlign: TextAlign.center, 
                                  style: TextStyle(
                                    fontSize: 24, 
                                    fontWeight: FontWeight.bold, 
                                    color: navy
                                  )
                                ),
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

            // NAVIGATION BUTTON
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                  ),
                  onPressed: () {
                    // NAVIGATION ADDED HERE
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingInterestSelection(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Personalize my journey", 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 20, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, color: Colors.white),
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
}