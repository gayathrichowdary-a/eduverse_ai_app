import 'package:flutter/material.dart';

class CareerMentorChat extends StatefulWidget {
  final String expertName;

  const CareerMentorChat({super.key, this.expertName = "Career Mentor"});

  @override
  State<CareerMentorChat> createState() => _CareerMentorChatState();
}

class _CareerMentorChatState extends State<CareerMentorChat> {
  // Theme Colors
  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFE3F2FD),
              child: Icon(Icons.business_center,
                  color: Color(0xFF2196F3), size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.expertName,
                    style: const TextStyle(
                        color: navy,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const Text("Online | AI Powered",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildBotMessage(
                    "Hi Arjun! I've analyzed your skills in Mathematics and Physics. You're a great fit for Engineering roles."),
                _buildBotMessage(
                    "Would you like to see a roadmap for becoming an AI Engineer or explore something else?"),
                _buildUserMessage("Tell me more about AI Engineering."),
                _buildBotMessage(
                    "Great choice! AI Engineering requires strong Python skills and Linear Algebra. You've already mastered Algebra, so you're 40% there!"),
              ],
            ),
          ),

          // --- Chat Input ---
          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildBotMessage(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20, right: 50),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFFF1F4F8),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Text(text,
            style: const TextStyle(color: navy, fontSize: 14, height: 1.4)),
      ),
    );
  }

  Widget _buildUserMessage(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 50),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: brandRed,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Ask about careers...",
                filled: true,
                fillColor: const Color(0xFFF7F9FB),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const CircleAvatar(
            backgroundColor: navy,
            child: Icon(Icons.send, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}