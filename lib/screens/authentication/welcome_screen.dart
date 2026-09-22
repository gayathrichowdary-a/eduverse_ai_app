import 'package:flutter/material.dart';
import 'intro_page_1.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TOP: LANGUAGE BUTTON
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.language,
                        color: Color(0xFF4D86AD),
                        size: 22,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'English',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D3B64),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF4D86AD),
                      ),
                    ],
                  ),
                ),
              ),

              // CENTER: ILLUSTRATION + TEXTS
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // WELCOME ILLUSTRATION
                  Image.asset(
                    'assets/images/welcome_illustration.png',
                    width: screenWidth * 0.75,
                    height: screenHeight * 0.22,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 16),

                  // WELCOME TITLE
                  const Text(
                    'Welcome to\nEduVerse AI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1D3B64),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // TAGLINE
                  const Text(
                    'Learn Smarter. Grow Faster.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D3B64),
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Achieve More.',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFE8475D),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // DESCRIPTION
                  const Text(
                    'Your personalized AI-powered mentor, career advisor,\nand emotional support companion.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Color(0xFF4D86AD),
                    ),
                  ),
                ],
              ),

              // BOTTOM: GET STARTED BUTTON + TERMS
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // GET STARTED BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IntroPage1(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8475D),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // TERMS AND PRIVACY POLICY
                  const Text(
                    'By continuing, you agree to our Terms & Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1D3B64),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}