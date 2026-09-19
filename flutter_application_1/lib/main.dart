import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const EduVerseAIApp());
}

class EduVerseAIApp extends StatelessWidget {
  const EduVerseAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduVerse AI',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progress = 0.62;

  @override
  void initState() {
    super.initState();

    // Simulates the loading progress on the splash screen
    Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        progress += 0.002;

        if (progress >= 1.0) {
          progress = 0.62;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF0F9FF),
              Color(0xFFF8FAFF),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative question mark
            Positioned(
              left: screenWidth * 0.14,
              top: screenHeight * 0.20,
              child: Opacity(
                opacity: 0.08,
                child: Text(
                  '?',
                  style: TextStyle(
                    fontSize: screenWidth * 0.10,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE5485D),
                  ),
                ),
              ),
            ),

            // Decorative light bulb
            Positioned(
              right: screenWidth * 0.13,
              top: screenHeight * 0.61,
              child: Opacity(
                opacity: 0.07,
                child: Icon(
                  Icons.lightbulb,
                  size: screenWidth * 0.08,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ),

            // Decorative flask
            Positioned(
              left: screenWidth * 0.23,
              top: screenHeight * 0.70,
              child: Opacity(
                opacity: 0.08,
                child: Icon(
                  Icons.science,
                  size: screenWidth * 0.10,
                  color: const Color(0xFF6685E8),
                ),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: screenWidth * 0.32,
                    height: screenWidth * 0.32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF7FBFF),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF48C8F2).withValues(alpha: 0.55),
                          blurRadius: 35,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.045),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE5485D),
                      ),
                      child: Icon(
                        Icons.school,
                        color: Colors.white,
                        size: screenWidth * 0.13,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.035),

                  // App name
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'EduVerse ',
                          style: TextStyle(
                            fontSize: screenWidth * 0.085,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF21436D),
                          ),
                        ),
                        TextSpan(
                          text: 'AI',
                          style: TextStyle(
                            fontSize: screenWidth * 0.085,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8999AA),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.012),

                  // Tagline
                  Text(
                    'Your Personal AI Learning Companion',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.036,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF4A87B5),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom loading section
            Positioned(
              left: screenWidth * 0.18,
              right: screenWidth * 0.18,
              bottom: screenHeight * 0.07,
              child: Column(
                children: [
                  Text(
                    'Loading your universe...',
                    style: TextStyle(
                      fontSize: screenWidth * 0.032,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF82B0CF),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.018),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 7,
                      backgroundColor: const Color(0xFFEAF1F5),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF45BDEB),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}