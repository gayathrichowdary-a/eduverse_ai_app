import 'package:flutter/material.dart';

class AiExplanationScreen extends StatelessWidget {
  final String subject;
  final String questionText;

  const AiExplanationScreen({
    super.key,
    required this.subject,
    required this.questionText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E3A5F), size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'AI Explain',
          style: TextStyle(
            color: Color(0xFF1E3A5F),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF7FC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                subject,
                style: const TextStyle(
                  color: Color(0xFF1E3A5F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Original question, for context
            Text(
              questionText,
              style: const TextStyle(
                color: Color(0xFF1E3A5F),
                fontSize: 18,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            // AI explanation card — placeholder content for now
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE9E9),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFFFB6B6), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.psychology, color: Color(0xFFEF3340), size: 26),
                      SizedBox(width: 10),
                      Text(
                        'Step-by-step breakdown',
                        style: TextStyle(
                          color: Color(0xFF1E3A5F),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // TODO: replace this placeholder text with a real AI-generated
                  // explanation once the backend/AI call is wired up.
                  Text(
                    'This is a placeholder explanation. Once connected to the '
                    'AI backend, this screen will show a step-by-step '
                    'breakdown of the concepts and working needed to solve '
                    'this question.',
                    style: TextStyle(
                      color: Color(0xFF1E3A5F),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  'Back to Question',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF3340),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
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