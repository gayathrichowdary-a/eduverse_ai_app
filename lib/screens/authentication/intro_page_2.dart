import 'package:flutter/material.dart';
import 'intro_page_3.dart';
class IntroPage2 extends StatefulWidget {
  const IntroPage2({super.key});

  @override
  State<IntroPage2> createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> {
  static const Color navy = Color(0xFF16214A);
  static const Color subtitleBlue = Color(0xFF5B7A9D);
  static const Color brandRed = Color(0xFFEF3340);

  int selectedOption = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),

            child: Column(
              children: [

                // TOP BAR
                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    // BACK BUTTON
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 36,
                        color: navy,
                      ),
                    ),

                    // SKIP
                    TextButton(
                      onPressed: () {
                        // Add skip navigation here
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: brandRed,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // INTRODUCTION IMAGE
                SizedBox(
                  width: double.infinity,
                  height: 350,
                  child: Image.asset(
                    'assets/images/intro_2_illustration.png',
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 35),

                // TITLE
                const Text(
                  'Practice Every Day',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: navy,
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 20),

                // DESCRIPTION
                const Text(
                  'Improve your English, coding, mathematics, and\n'
                  'reasoning with instant AI feedback.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: subtitleBlue,
                    fontSize: 18,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 35),

                // OPTION 1
                _buildOption(
                  index: 0,
                  icon: Icons.translate,
                  title: 'English Speaking',
                  color: const Color(0xFF4FC3E7),
                ),

                const SizedBox(height: 12),

                // OPTION 2
                _buildOption(
                  index: 1,
                  icon: Icons.code,
                  title: 'Python Coding',
                  color: const Color(0xFFEF3340),
                ),

                const SizedBox(height: 12),

                // OPTION 3
                _buildOption(
                  index: 2,
                  icon: Icons.functions,
                  title: 'Mental Math',
                  color: const Color(0xFF55B88B),
                ),

                const SizedBox(height: 12),

                // OPTION 4 - YELLOW BUTTON
                _buildOption(
                  index: 3,
                  icon: Icons.psychology,
                  title: 'Logical Reasoning',
                  color: const Color(0xFFFFD21F),
                ),

                const SizedBox(height: 28),

                // CONTINUE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IntroPage3(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandRed,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(width: 12),

                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // PROGRESS INDICATOR
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    _buildProgressDot(),

                    const SizedBox(width: 8),

                    Container(
                      width: 45,
                      height: 14,
                      decoration: BoxDecoration(
                        color: brandRed,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(width: 8),

                    _buildProgressDot(),
                  ],
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // OPTION BUTTON
  Widget _buildOption({
    required int index,
    required IconData icon,
    required String title,
    required Color color,
  }) {
    final bool isSelected = selectedOption == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = index;
        });
      },

      child: Container(
        width: double.infinity,
        height: 80,

        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(40),

          border: Border.all(
            color: navy,
            width: 3,
          ),

          boxShadow: const [
            BoxShadow(
              color: navy,
              offset: Offset(5, 6),
              blurRadius: 0,
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 42),

          child: Row(
            children: [

              Icon(
                icon,
                color: navy,
                size: 30,
              ),

              const SizedBox(width: 20),

              Text(
                title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: navy,
                  size: 25,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressDot() {
    return Container(
      width: 14,
      height: 14,
      decoration: const BoxDecoration(
        color: Color(0xFFE9ECEF),
        shape: BoxShape.circle,
      ),
    );
  }
}