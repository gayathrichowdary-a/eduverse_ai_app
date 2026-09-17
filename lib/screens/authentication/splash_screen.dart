import 'dart:async';
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
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();

    // Guaranteed navigation after 2 seconds:
    _navigationTimer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFE),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight,
                    maxWidth: 500,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      // Animated Cap Logo
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFEFF9FF),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF61D5FF).withOpacity(0.35),
                              blurRadius: 30,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 85,
                            height: 85,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE8475D),
                            ),
                            child: const Icon(
                              Icons.school,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // App Name
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'EduVerse ',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF214675),
                              ),
                            ),
                            TextSpan(
                              text: 'AI',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF8999AA),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Your Personal AI Learning Companion',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A87B9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const Spacer(),

                      // Loading Universe Status
                      const Text(
                        'Loading your universe...',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF82B5D4),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Progress Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: _progressAnimation.value,
                                minHeight: 6,
                                backgroundColor: const Color(0xFFE8F0F5),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF45BFEA),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}