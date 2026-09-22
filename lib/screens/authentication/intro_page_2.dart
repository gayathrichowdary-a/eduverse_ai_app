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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TOP BAR
              Column(
                children: [
                  const SizedBox(height: 12),
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
                          size: 32,
                          color: navy,
                        ),
                      ),

                      // SKIP
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IntroPage3(),
                            ),
                          );
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: brandRed,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // CENTER CONTENT: IMAGE, TITLE, DESCRIPTION
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // INTRODUCTION IMAGE
                  SizedBox(
                    height: screenHeight * 0.35,
                    child: Image.asset(
                      'assets/images/intro_2_illustration.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // TITLE
                  const Text(
                    'Practice Every Day',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: navy,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // DESCRIPTION
                  const Text(
                    'Improve your English, coding, mathematics, and\n'
                    'reasoning with instant AI feedback.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: subtitleBlue,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),

              // BOTTOM ROW: PROGRESS DOTS (CENTER/LEFT) & CONTINUE BUTTON (RIGHT)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // PROGRESS INDICATOR
                    Row(
                      children: [
                        _buildProgressDot(),
                        const SizedBox(width: 8),
                        Container(
                          width: 36,
                          height: 10,
                          decoration: BoxDecoration(
                            color: brandRed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildProgressDot(),
                      ],
                    ),

                    // CONTINUE BUTTON (BOTTOM RIGHT CORNER)
                    ElevatedButton(
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressDot() {
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: Color(0xFFE9ECEF),
        shape: BoxShape.circle,
      ),
    );
  }
}