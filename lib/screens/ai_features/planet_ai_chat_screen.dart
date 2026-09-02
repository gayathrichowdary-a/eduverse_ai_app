import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  const ChatMessage({required this.text, required this.isUser});
}

// NOTE: class name kept as `PlanetAiChatScreen` so existing imports/routes
// keep working. Content re-themed from planet chat to a generic AI Tutor
// topic chat, matching the spec's "real-time explanations" flow.
class PlanetAiChatScreen extends StatefulWidget {
  final String topic;

  const PlanetAiChatScreen({
    super.key,
    this.topic = 'Binary Search Tree',
  });

  @override
  State<PlanetAiChatScreen> createState() => _PlanetAiChatScreenState();
}

class _PlanetAiChatScreenState extends State<PlanetAiChatScreen> {
  static const Color brandRed = Color(0xFFE8394A);
  static const Color navy = Color(0xFF14213D);
  static const Color textBlue = Color(0xFF4D86AD);
  static const Color bubbleGrey = Color(0xFFF4F6F8);

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      ChatMessage(
        text: "I'm here to help you understand ${widget.topic}. What would you like to know?",
        isUser: false,
      ),
    ];
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      // TODO: replace with a real AI backend call for live code
      // explanations, debugging hints, or mock interview feedback.
      _messages.add(ChatMessage(
        text: "That's a great question about ${widget.topic}! (AI response will be connected soon.)",
        isUser: false,
      ));
    });

    _controller.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF4FC3F7),
              child: Text('AI', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sophia - AI Tutor',
                  style: TextStyle(color: navy, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Discussing ${widget.topic}',
                  style: const TextStyle(color: textBlue, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildBubble(message);
                },
              ),
            ),

            // ============================================================
            // INPUT BAR
            // ============================================================
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFF0F2F5))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Ask something about ${widget.topic}...',
                        hintStyle: const TextStyle(color: textBlue),
                        filled: true,
                        fillColor: bubbleGrey,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(color: brandRed, shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
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

  Widget _buildBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? brandRed : bubbleGrey,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser ? Colors.white : navy,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}