import 'package:flutter/material.dart';
import 'intro_page_1.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),

            child: Column(
              children: [
                // LANGUAGE BUTTON
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.language,
                          color: Color(0xFF4D86AD),
                          size: 25,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'English',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D3B64),
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF4D86AD),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 160),

                // WELCOME ILLUSTRATION
                Image.asset(
                  'assets/images/welcome_illustration.png',
                  width: screenWidth * 0.85,
                  height: 220,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 20),

                // WELCOME TITLE
                const Text(
                  'Welcome to\nEduVerse AI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 46,
                    height: 1.15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D3B64),
                  ),
                ),

                const SizedBox(height: 28),

                // TAGLINE
                const Text(
                  'Learn Smarter. Grow Faster.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D3B64),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Achieve More.',
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFFE8475D),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 28),

                // DESCRIPTION
                const Text(
                  'Your personalized AI-powered mentor, career advisor,\nand emotional support companion.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.6,
                    color: Color(0xFF4D86AD),
                  ),
                ),

                const SizedBox(height: 45),

                // GET STARTED BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 65,
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: OutlinedButton(
                    onPressed: () {
                      // Login screen navigation will be added here
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1D3B64),
                      side: const BorderSide(
                        color: Color(0xFF1D3B64),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    child: const Text(
                      'I Already Have an Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 45),

                // TERMS AND PRIVACY POLICY
                const Text(
                  'By continuing, you agree to our Terms & Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1D3B64),
                  ),
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}