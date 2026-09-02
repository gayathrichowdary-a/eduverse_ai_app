import 'package:flutter/material.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _ChatMessage {
  final String text;
  final bool isUser;

  const _ChatMessage({required this.text, required this.isUser});
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController controller = TextEditingController();

  final List<_ChatMessage> messages = [
    const _ChatMessage(
      text:
          "Hi! I'm Arjun's AI Mentor. Ask me anything about his progress, strengths, or areas to focus on.",
      isUser: false,
    ),
  ];

  void sendMessage() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(_ChatMessage(text: text, isUser: true));
      controller.clear();
    });

    // Simple placeholder auto-reply - replace with real AI call later
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        messages.add(const _ChatMessage(
          text:
              "That's a great question! (This is a placeholder reply - connect this to your AI backend to get real responses.)",
          isUser: false,
        ));
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              decoration: const BoxDecoration(
                color: Color(0xFFFFD52E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
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
                  Container(
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
                      Icons.auto_awesome,
                      color: Color(0xFF1F355C),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "AI Mentor",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F355C),
                          ),
                        ),
                        Text(
                          "Always here to help",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5E6D7A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //================ CHAT MESSAGES =================

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(18),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return Align(
                    alignment: msg.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      constraints: BoxConstraints(
                        maxWidth:
                            MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: msg.isUser
                            ? const Color(0xFF1F355C)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: msg.isUser
                            ? null
                            : Border.all(
                                color: const Color(0xFF1F355C),
                                width: 1.5,
                              ),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: msg.isUser
                              ? Colors.white
                              : const Color(0xFF1F355C),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            //================ INPUT BAR =================

            Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onSubmitted: (_) => sendMessage(),
                      decoration: InputDecoration(
                        hintText: "Ask about Arjun's progress...",
                        filled: true,
                        fillColor: const Color(0xFFF8F8F8),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: sendMessage,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE94A56),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
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