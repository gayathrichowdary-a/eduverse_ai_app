import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _controller.forward();

    // ADDED: Navigate to WelcomeScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted){

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );
    }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF5FAFF),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [

                  // Question mark decoration
                  Positioned(
                    left: constraints.maxWidth * 0.15,
                    top: constraints.maxHeight * 0.18,
                    child: Text(
                      '?',
                      style: TextStyle(
                        fontSize: constraints.maxWidth * 0.10,
                        color: const Color(0xFFF3E8EF),
                      ),
                    ),
                  ),

                  // Light bulb decoration
                  Positioned(
                    right: constraints.maxWidth * 0.15,
                    top: constraints.maxHeight * 0.40,
                    child: Icon(
                      Icons.lightbulb_outline,
                      size: constraints.maxWidth * 0.10,
                      color: const Color(0xFFEDEEF2),
                    ),
                  ),

                  // Main content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        // Logo
                        Container(
                          width: constraints.maxWidth * 0.42,
                          height: constraints.maxWidth * 0.42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFEFF9FF),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF61D5FF)
                                    .withOpacity(0.45),
                                blurRadius: 35,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: constraints.maxWidth * 0.31,
                              height: constraints.maxWidth * 0.31,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFE8475D),
                              ),
                              child: const Icon(
                                Icons.school,
                                color: Colors.white,
                                size: 75,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: constraints.maxHeight * 0.045,
                        ),

                        // App name
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'EduVerse ',
                                style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.075,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF214675),
                                ),
                              ),
                              TextSpan(
                                text: 'AI',
                                style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.075,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF8999AA),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: constraints.maxHeight * 0.015,
                        ),

                        // Subtitle
                        Text(
                          'Your Personal AI Learning Companion',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.035,
                            color: const Color(0xFF4A87B9),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom loading section
                  Positioned(
                    bottom: constraints.maxHeight * 0.045,
                    left: constraints.maxWidth * 0.12,
                    right: constraints.maxWidth * 0.12,
                    child: Column(
                      children: [

                        const Text(
                          'Loading your universe...',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF82B5D4),
                          ),
                        ),

                        const SizedBox(height: 18),

                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return LinearProgressIndicator(
                              value: _progressAnimation.value,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(10),
                              backgroundColor: const Color(0xFFE8F0F5),
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                Color(0xFF45BFEA),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}