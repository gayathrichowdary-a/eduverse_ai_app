import 'package:flutter/material.dart';
import '../parent/ai_chat_screen.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _Faq {
  final String question;
  final String answer;
  const _Faq({required this.question, required this.answer});
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  int? expandedIndex;

  final List<_Faq> faqs = const [
    _Faq(
      question: "How does the AI Mentor personalize lessons?",
      answer:
          "The AI Mentor looks at your quiz scores, focus patterns, and study habits to adjust difficulty and suggest topics you should review.",
    ),
    _Faq(
      question: "Can my parents see my chat with the AI Mentor?",
      answer:
          "No, your one-on-one chats stay private. Parents only see progress summaries, unless you choose to share more in Settings.",
    ),
    _Faq(
      question: "How do I change my study reminders?",
      answer:
          "Go to Settings & Privacy > Notifications, and toggle Lesson Reminders on or off.",
    ),
    _Faq(
      question: "What happens if I turn on Incognito Learning?",
      answer:
          "Your session won't be saved to your learning history, and it won't affect your AI Mentor's recommendations.",
    ),
  ];

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
                    "Help Center",
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
                        "Frequently Asked Questions",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F355C),
                        ),
                      ),

                      const SizedBox(height: 14),

                      ...List.generate(faqs.length, (index) {
                        final faq = faqs[index];
                        final bool isExpanded = expandedIndex == index;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF1F355C),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      expandedIndex =
                                          isExpanded ? null : index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 14,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            faq.question,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF1F355C),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          isExpanded
                                              ? Icons.remove
                                              : Icons.add,
                                          color: const Color(0xFF1F355C),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (isExpanded)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        14, 0, 14, 14),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        faq.answer,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          height: 1.4,
                                          color: Color(0xFF5E6D7A),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 20),

                      //================ CONTACT SUPPORT =================

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF7FF),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFF1F355C),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Still need help?",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F355C),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Our support team typically replies within 24 hours.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF5E6D7A),
                              ),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AiChatScreen(),
    ),
  );

                                },
                                icon: const Icon(
                                    Icons.chat_bubble_outline,
                                    size: 18,
                                    color: Colors.white),
                                label: const Text(
                                  "Contact Support",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFF1F355C),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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