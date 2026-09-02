import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [

            //================ HEADER =================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              decoration: const BoxDecoration(
                color: Color(0xFFFFD52E),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all(
                          color: const Color(0xFF1F355C),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1F355C),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    "Privacy Policy",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F355C),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Last updated: July 2026",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const _PolicySection(
                        title: "1. What We Collect",
                        body:
                            "We collect your quiz scores, study time, app usage patterns, and any messages you send to the AI Mentor. This helps personalize your learning experience.",
                      ),

                      const _PolicySection(
                        title: "2. How We Use Your Data",
                        body:
                            "Your data is used to recommend lessons, track your progress, and provide insights to your parents or teachers, based on your privacy settings.",
                      ),

                      const _PolicySection(
                        title: "3. Who Can See Your Information",
                        body:
                            "Your AI Mentor chats are private. Parents and teachers only see summarized progress, unless you enable more detailed sharing in Settings.",
                      ),

                      const _PolicySection(
                        title: "4. Data Storage & Security",
                        body:
                            "All data is encrypted and stored securely. We never sell your personal information to third parties.",
                      ),

                      const _PolicySection(
                        title: "5. Your Rights",
                        body:
                            "You can export or delete your learning data at any time from the AI Data Usage settings page.",
                      ),

                      const _PolicySection(
                        title: "6. Contact Us",
                        body:
                            "If you have questions about this policy, reach out through the Help Center support chat.",
                      ),

                      const SizedBox(height: 20),

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

class _PolicySection extends StatelessWidget {
  final String title;
  final String body;

  const _PolicySection({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F355C),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF5E6D7A),
            ),
          ),
        ],
      ),
    );
  }
}