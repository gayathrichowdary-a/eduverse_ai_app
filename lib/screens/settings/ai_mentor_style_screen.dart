import 'package:flutter/material.dart';

class AiMentorStyleScreen extends StatefulWidget {
  const AiMentorStyleScreen({super.key});

  @override
  State<AiMentorStyleScreen> createState() => _AiMentorStyleScreenState();
}

class _MentorStyle {
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const _MentorStyle({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _AiMentorStyleScreenState extends State<AiMentorStyleScreen> {
  String selectedStyle = "Encouraging & Visual";

  final List<_MentorStyle> styles = const [
    _MentorStyle(
      name: "Encouraging & Visual",
      description: "Positive tone, lots of diagrams and examples",
      icon: Icons.emoji_emotions_outlined,
      color: Color(0xFF58C7F3),
    ),
    _MentorStyle(
      name: "Direct & Concise",
      description: "Straight to the point, minimal explanation",
      icon: Icons.bolt,
      color: Color(0xFFF7C948),
    ),
    _MentorStyle(
      name: "Socratic",
      description: "Asks guiding questions instead of giving answers",
      icon: Icons.psychology_outlined,
      color: Color(0xFF57B97A),
    ),
    _MentorStyle(
      name: "Story-based",
      description: "Explains concepts through analogies and stories",
      icon: Icons.auto_stories_outlined,
      color: Color(0xFFE94A56),
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
                    "AI Mentor Style",
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
                        "Choose how your AI Mentor teaches you",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5E6D7A),
                        ),
                      ),

                      const SizedBox(height: 16),

                      ...styles.map((style) {
                        final bool isSelected =
                            style.name == selectedStyle;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedStyle = style.name;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFE94A56)
                                      : const Color(0xFF1F355C),
                                  width: isSelected ? 3 : 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: style.color,
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Icon(style.icon,
                                        color: Colors.white, size: 20),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          style.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1F355C),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          style.description,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFE94A56),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "AI Mentor style set to $selectedStyle",
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE94A56),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "Save Style",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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