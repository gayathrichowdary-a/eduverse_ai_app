import 'package:flutter/material.dart';
import 'login_page.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  // COLORS
  static const Color brandRed = Color(0xFFEF3340);
  static const Color navy = Color(0xFF1D3B64);
  static const Color subtitleBlue = Color(0xFF4D86AD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Column(
            children: [

              // =========================
              // SKIP BUTTON
              // =========================
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    // You can navigate to LoginPage here if needed
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      right: 10,
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: brandRed,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // ILLUSTRATION IMAGE
              // =========================
              Expanded(
                flex: 5,
                child: Image.asset(
                  'assets/images/intro_3_illustration.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),

              // =========================
              // TITLE
              // =========================
              const Text(
                'Build Your Future',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: navy,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // DESCRIPTION
              // =========================
              const Text(
                'Explore careers, scholarships, competitive exams,\n'
                'and personalized roadmaps.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: subtitleBlue,
                  fontSize: 18,
                  height: 1.45,
                ),
              ),

              const Spacer(),

              // =========================
              // PAGE INDICATOR
              // =========================
              _buildPageIndicator(),

              const SizedBox(height: 55),

              // =========================
              // START LEARNING BUTTON
              // =========================
              SizedBox(
                width: double.infinity,
                height: 92,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Start Learning',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // PAGE INDICATOR
  // =========================
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        _indicatorDot(),

        const SizedBox(width: 8),

        _indicatorDot(),

        const SizedBox(width: 8),

        Container(
          width: 45,
          height: 16,
          decoration: BoxDecoration(
            color: brandRed,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  // =========================
  // INDICATOR DOT
  // =========================
  Widget _indicatorDot() {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        color: Color(0xFFF0F2F3),
        shape: BoxShape.circle,
      ),
    );
  }
}