import 'package:flutter/material.dart';

class PersonalizedEnglishPractice extends StatefulWidget {
  const PersonalizedEnglishPractice({super.key});

  @override
  State<PersonalizedEnglishPractice> createState() => _PersonalizedEnglishPracticeState();
}

class _ChatMessage {
  final bool isUser;
  final String text;
  _ChatMessage({required this.isUser, required this.text});
}

class _PersonalizedEnglishPracticeState extends State<PersonalizedEnglishPractice> {
  // EduVerse Palette
  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color lightBlueBg = Color(0xFFF7F9FB);
  static const Color insightPink = Color(0xFFFDE8E9);
  static const Color aiBlue = Color(0xFF4FC3F7);

  // --- State ---
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isListening = false;

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      isUser: false,
      text: "Great start! Your use of 'Although' was correct, but try to vary your sentence structure.",
    ),
    _ChatMessage(
      isUser: true,
      text: "I think the environment is important because it affects our health.",
    ),
    _ChatMessage(
      isUser: false,
      text: "Conceptually sound! Replace 'important' with 'paramount' for a better impact.",
    ),
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  // --- FIXED: mic button now toggles a listening state.
  // This is UI-only — plug in real speech-to-text here (see notes below).
  void _startVoiceInput() {
    setState(() => _isListening = !_isListening);

    if (_isListening) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Listening... (voice input not yet connected)"),
          duration: Duration(seconds: 2),
        ),
      );

      // TODO: wire up real speech-to-text here, e.g. using the
      // `speech_to_text` package:
      //
      //   final speech = stt.SpeechToText();
      //   final available = await speech.initialize();
      //   if (available) {
      //     speech.listen(
      //       onResult: (result) {
      //         setState(() => _inputController.text = result.recognizedWords);
      //       },
      //     );
      //   }
      //
      // Don't forget to request microphone permission (e.g. via the
      // `permission_handler` package) and add the mic usage description
      // to your AndroidManifest.xml / Info.plist.
      //
      // For now, auto-reset the listening indicator after a short delay
      // so the UI doesn't get stuck in a "listening" state.
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _isListening = false);
      });
    }
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
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
          text: "Nice work — keep going. (This is a placeholder AI reply.)",
        ));
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: navy, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Personalized Practice",
                style: TextStyle(color: navy, fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              children: [
                CircleAvatar(radius: 3, backgroundColor: Colors.green),
                SizedBox(width: 5),
                Text("AI Mentor Active", style: TextStyle(color: subtitleBlue, fontSize: 11)),
              ],
            ),
          ],
        ),
        // --- FIXED: settings icon removed ---
      ),
      body: Column(
        children: [
          // Divider to fix the "lines in corner" look
          const Divider(height: 1, color: Color(0xFFF2F2F2)),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 1. Current Session Header Card ---
                  _buildSessionHeader(),

                  const SizedBox(height: 30),
                  const Text("Live Practice Transcript",
                      style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  // --- 2. Chat Transcript ---
                  ..._messages.map((message) =>
                      message.isUser ? _buildUserMessage(message.text) : _buildAiMessage(message.text)),

                  const SizedBox(height: 30),

                  // --- 3. AI Learning Insight Card (Pink) ---
                  _buildInsightCard(),

                  const SizedBox(height: 30),

                  // --- 4. Fluency Progress Graph (FIXED: NO NETWORK IMAGES) ---
                  _buildFluencyGraph(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          // --- 5. Bottom Input Bar ---
          _buildBottomInput(),
        ],
      ),
    );
  }

  Widget _buildSessionHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Current Session", style: TextStyle(color: subtitleBlue, fontWeight: FontWeight.bold, fontSize: 12)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: brandRed.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                child: const Text("Adaptive Level 4", style: TextStyle(color: brandRed, fontWeight: FontWeight.bold, fontSize: 10)),
              )
            ],
          ),
          const SizedBox(height: 12),
          const Text("Mastering 'Conditionals' in\nPersuasive Writing",
              style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold, height: 1.3)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _headerStat(Icons.access_time, "12:45", "Time"),
              _headerStat(Icons.analytics_outlined, "88%", "Accuracy"),
              _headerStat(Icons.auto_awesome, "+12", "Vocab"),
            ],
          )
        ],
      ),
    );
  }

  Widget _headerStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: aiBlue, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: navy, fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }

  Widget _buildAiMessage(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 16, backgroundColor: aiBlue, child: Text("AI", style: TextStyle(color: Colors.white, fontSize: 10))),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: lightBlueBg, borderRadius: BorderRadius.circular(15)),
              child: Text(text, style: const TextStyle(color: navy, fontSize: 14, height: 1.4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserMessage(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(text, style: const TextStyle(color: navy, fontSize: 14, height: 1.4)),
            ),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(radius: 16, backgroundColor: Color(0xFFEEEEEE), child: Text("ME", style: TextStyle(color: navy, fontSize: 9))),
        ],
      ),
    );
  }

  Widget _buildInsightCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: insightPink, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.lightbulb_outline, color: brandRed, size: 20),
              SizedBox(width: 10),
              Text("AI Learning Insight", style: TextStyle(color: brandRed, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
              "You tend to overuse simple cause-and-effect structures. I've flagged 3 sentences to rewrite.",
              style: TextStyle(color: brandRed, fontSize: 13, height: 1.4)),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(side: const BorderSide(color: brandRed), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text("Review Flagged Sentences", style: TextStyle(color: brandRed, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFluencyGraph() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Fluency Progress (Last 10 Mins)", style: TextStyle(color: subtitleBlue, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 20),
          // --- FIXED GRAPH: This is now a custom shape, no error possible ---
          SizedBox(
            height: 60,
            width: double.infinity,
            child: CustomPaint(
              painter: _LineChartPainter(brandRed),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(8, (i) => Text("${i + 1}", style: const TextStyle(color: Colors.grey, fontSize: 10))),
          )
        ],
      ),
    );
  }

  Widget _buildBottomInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 25),
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFF2F2F2)))),
      child: Row(
        children: [
          GestureDetector(
            onTap: _startVoiceInput,
            child: Icon(
              _isListening ? Icons.mic : Icons.mic_none_outlined,
              color: _isListening ? brandRed : subtitleBlue,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: lightBlueBg, borderRadius: BorderRadius.circular(25)),
              child: TextField(
                controller: _inputController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: const InputDecoration(
                  hintText: "Type your response...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // --- FIXED: send button now wired to _sendMessage via GestureDetector ---
          GestureDetector(
            onTap: _sendMessage,
            child: const CircleAvatar(
              radius: 22,
              backgroundColor: brandRed,
              child: Icon(Icons.send, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Helper class to draw the graph without internet errors ---
class _LineChartPainter extends CustomPainter {
  final Color color;
  _LineChartPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.2, size.width * 0.4, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.8, size.width * 0.8, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.1);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}