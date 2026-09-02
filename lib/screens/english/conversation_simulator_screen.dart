import 'package:flutter/material.dart';

class ConversationSimulatorScreen extends StatefulWidget {
  const ConversationSimulatorScreen({super.key});

  @override
  State<ConversationSimulatorScreen> createState() => _ConversationSimulatorScreenState();
}

class _ChatMessage {
  final bool isUser;
  final String text;
  _ChatMessage({required this.isUser, required this.text});
}

class _ConversationSimulatorScreenState extends State<ConversationSimulatorScreen> {
  // Corrected Theme Colors
  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color lightBlue = Color(0xFF4FC3F7);
  static const Color bgGrey = Color(0xFFF7F9FB);
  static const Color conceptPink = Color(0xFFFDE8E9);

  // --- State ---
  String _difficulty = "Undergrad"; // "Beginner" or "Undergrad"
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      isUser: false,
      text:
          "To understand Quantum Entanglement, imagine two dice. If you roll one and get a 6, the other always shows a 6, even if it's on the moon. This is what Einstein called 'Spooky action at a distance'.",
    ),
    _ChatMessage(
      isUser: true,
      text: "That makes sense, but how does the 'observation' affect the outcome?",
    ),
    _ChatMessage(
      isUser: false,
      text:
          "Great question! When we observe one particle, we 'collapse' the wave function. This means the uncertainty disappears.",
    ),
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _selectDifficulty(String level) {
    if (_difficulty == level) return;
    setState(() => _difficulty = level);
  }

  void _scrollToBottom() {
    // Wait a frame so the new message is laid out before we scroll to it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _sendMessage([String? overrideText]) {
    final text = (overrideText ?? _inputController.text).trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(isUser: true, text: text));
      _inputController.clear();
    });
    _scrollToBottom();

    // TODO: replace this mock reply with a real AI Mentor API call.
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(
          isUser: false,
          text: "Got it — let's dig into that. (This is a placeholder AI reply.)",
        ));
      });
      _scrollToBottom();
    });
  }

  void _useSuggestion(String label) {
    // Strip any leading emoji from the chip label before sending it as a message.
    final cleanText = label.replaceFirst(RegExp(r'^[^\w]*'), '').trim();
    _sendMessage(cleanText);
  }

  // --- FIXED: history icon now opens a bottom sheet listing past sessions ---
  final List<Map<String, String>> _pastSessions = const [
    {"title": "Session 11 • Wave-Particle Duality", "date": "Aug 6, 2026"},
    {"title": "Session 10 • Schrödinger's Cat", "date": "Aug 4, 2026"},
    {"title": "Session 9 • Heisenberg Uncertainty", "date": "Aug 1, 2026"},
  ];

  void _showHistorySheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Session History",
                  style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ..._pastSessions.map((session) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: bgGrey,
                      child: Icon(Icons.chat_bubble_outline, color: navy, size: 18),
                    ),
                    title: Text(session["title"]!,
                        style: const TextStyle(color: navy, fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text(session["date"]!,
                        style: const TextStyle(color: subtitleBlue, fontSize: 11)),
                    onTap: () => Navigator.pop(context),
                  )),
            ],
          ),
        );
      },
    );
  }

  // --- FIXED: 3-dot icon now opens a real popup menu with working actions ---
  void _handleMenuSelection(String value) {
    switch (value) {
      case 'restart':
        setState(() {
          _messages
            ..clear()
            ..add(_ChatMessage(
              isUser: false,
              text: "Session restarted. What would you like to explore about Quantum Physics?",
            ));
        });
        break;
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Chat exported.")),
        );
        break;
      case 'clear':
        setState(() => _messages.clear());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: navy, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Quantum Physics Mentor",
              style: TextStyle(color: navy, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "AI Active • Session 12",
              style: TextStyle(color: subtitleBlue, fontSize: 11),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: navy),
            onPressed: _showHistorySheet,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: navy),
            onSelected: _handleMenuSelection,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'restart', child: Text('Restart Session')),
              PopupMenuItem(value: 'export', child: Text('Export Chat')),
              PopupMenuItem(value: 'clear', child: Text('Clear Messages')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // --- 1. Difficulty & Pace Bar ---
          _buildSettingsBar(),

          // --- 2. Chat Area ---
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: message.isUser
                      ? _buildUserMessage(context, message.text)
                      : _buildAiMessageCard(context, message.text),
                );
              },
            ),
          ),

          // --- 3. Suggestions & Input Section ---
          _buildBottomSection(context),
        ],
      ),
    );
  }

  Widget _buildSettingsBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgGrey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Difficulty Level", style: TextStyle(color: subtitleBlue, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _levelChip("Beginner"),
                    const SizedBox(width: 8),
                    _levelChip("Undergrad"),
                  ],
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text("Pace", style: TextStyle(color: subtitleBlue, fontSize: 10, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text("Normal", style: TextStyle(color: navy, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          )
        ],
      ),
    );
  }

  // --- FIXED: chips are now tappable and toggle _difficulty via setState ---
  Widget _levelChip(String label) {
    final isSelected = _difficulty == label;
    return GestureDetector(
      onTap: () => _selectDifficulty(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? brandRed : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : navy,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAiMessageCard(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          backgroundColor: brandRed, 
          radius: 18, 
          child: Text("AI", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  children: [
                    Text(text, style: const TextStyle(color: navy, fontSize: 14, height: 1.5)),
                    const SizedBox(height: 12),
                    // Inner Concept Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: conceptPink, 
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb, color: brandRed, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Key Concept: Non-locality", style: TextStyle(color: navy, fontWeight: FontWeight.bold, fontSize: 12)),
                                SizedBox(height: 4),
                                Text(
                                  "The state of a particle is not independent of other particles.", 
                                  style: TextStyle(color: subtitleBlue, fontSize: 11, height: 1.3)
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _aiAction(Icons.edit_note, "Explain like I'm 5"),
                  const SizedBox(width: 15),
                  _aiAction(Icons.functions, "Show Equation"),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // --- FIXED: wrapped in GestureDetector so these actions are tappable too ---
  Widget _aiAction(IconData icon, String label) {
    return GestureDetector(
      onTap: () => _useSuggestion(label),
      child: Row(
        children: [
          Icon(icon, color: brandRed, size: 14),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: brandRed, fontWeight: FontWeight.bold, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildUserMessage(BuildContext context, String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: brandRed,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18), 
                    bottomLeft: Radius.circular(18), 
                    topRight: Radius.circular(18)
                  ),
                ),
                child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4)),
              ),
              const SizedBox(width: 10),
              const CircleAvatar(
                backgroundColor: lightBlue, 
                radius: 18, 
                child: Text("ME", style: TextStyle(color: navy, fontSize: 9, fontWeight: FontWeight.bold))
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 6, right: 48),
            child: Text("Sent • 2:14 PM", style: TextStyle(color: Colors.grey, fontSize: 10)),
          )
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 25),
      decoration: const BoxDecoration(
        color: Colors.white, 
        border: Border(top: BorderSide(color: Color(0xFFF2F2F2)))
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _suggestionCard("💡 Give me an example"),
                const SizedBox(width: 10),
                _suggestionCard("❓ Summarize this"),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: bgGrey, borderRadius: BorderRadius.circular(25)),
                  child: Row(
                    children: [
                      const Icon(Icons.sentiment_satisfied_alt_outlined, color: subtitleBlue, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                          decoration: const InputDecoration(
                            hintText: "Ask your AI mentor anything...",
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ),
                      ),
                      const Icon(Icons.attach_file_rounded, color: subtitleBlue, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // --- FIXED: send button is now wired to _sendMessage via GestureDetector ---
              GestureDetector(
                onTap: () => _sendMessage(),
                child: const CircleAvatar(
                  radius: 24,
                  backgroundColor: brandRed,
                  child: Icon(Icons.send_rounded, color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- FIXED: wrapped in GestureDetector so tapping a suggestion sends it ---
  Widget _suggestionCard(String text) {
    return GestureDetector(
      onTap: () => _useSuggestion(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: navy,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }
}