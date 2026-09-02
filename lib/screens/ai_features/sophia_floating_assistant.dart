import 'package:flutter/material.dart';
import 'ai_voice_conversation.dart';

/// Persistent floating Sophia assistant.
///
/// Per spec: "Sophia AI Mentor: Available as both a floating popover and
/// full-screen modal... We Have Floating Sophia Ai in Every Screen."
///
/// USAGE — mount this ONCE at the app root, not inside individual screens,
/// so it survives navigation instead of resetting per-route:
///
/// ```dart
/// MaterialApp(
///   ...
///   builder: (context, child) {
///     return Stack(
///       children: [
///         if (child != null) child,
///         const SophiaFloatingAssistant(),
///       ],
///     );
///   },
/// )
/// ```
///
/// Wrapping it in the `builder` (not each Scaffold) is what makes it
/// screen-independent — it keeps its drag position and open/closed state
/// across every push/pop in the app.
class SophiaFloatingAssistant extends StatefulWidget {
  const SophiaFloatingAssistant({super.key});

  @override
  State<SophiaFloatingAssistant> createState() => _SophiaFloatingAssistantState();
}

class _SophiaFloatingAssistantState extends State<SophiaFloatingAssistant> {
  static const Color brandRed = Color(0xFFE8394A);
  static const Color navy = Color(0xFF14213D);
  static const Color textBlue = Color(0xFF4D86AD);
  static const Color lightBlue = Color(0xFF4FC3F7);

  // Bubble position — starts bottom-right, draggable anywhere on screen.
  Offset? _bubbleOffset;
  bool _isPopoverOpen = false;

  static const double _bubbleSize = 60;

  void _handleDrag(DragUpdateDetails details, Size screenSize) {
    setState(() {
      final current = _bubbleOffset ??
          Offset(screenSize.width - 84, screenSize.height - 160);
      final next = current + details.delta;
      // Keep the bubble fully on-screen.
      _bubbleOffset = Offset(
        next.dx.clamp(8, screenSize.width - _bubbleSize - 8),
        next.dy.clamp(40, screenSize.height - _bubbleSize - 40),
      );
    });
  }

  void _togglePopover() {
    setState(() => _isPopoverOpen = !_isPopoverOpen);
  }

  void _openFullModal() {
    setState(() => _isPopoverOpen = false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _SophiaFullModal(),
    );
  }

  void _openVoice() {
    setState(() => _isPopoverOpen = false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AiVoiceConversation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final offset = _bubbleOffset ??
        Offset(screenSize.width - 84, screenSize.height - 160);

    return Stack(
      children: [
        // Compact popover — appears just above the bubble.
        if (_isPopoverOpen)
          Positioned(
            left: (offset.dx - 190).clamp(12, screenSize.width - 292),
            bottom: screenSize.height - offset.dy + 12,
            child: _SophiaPopover(
              onExpand: _openFullModal,
              onVoice: _openVoice,
              onClose: _togglePopover,
            ),
          ),

        // Draggable floating bubble.
        Positioned(
          left: offset.dx,
          top: offset.dy,
          child: GestureDetector(
            onPanUpdate: (details) => _handleDrag(details, screenSize),
            onTap: _togglePopover,
            child: Container(
              width: _bubbleSize,
              height: _bubbleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: brandRed,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: _isPopoverOpen
                    ? const Icon(Icons.close, color: Colors.white, size: 26)
                    : const Text(
                        'S',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Compact popover shown above the bubble — quick text ask, voice shortcut,
/// and an expand button into the full modal.
class _SophiaPopover extends StatefulWidget {
  final VoidCallback onExpand;
  final VoidCallback onVoice;
  final VoidCallback onClose;

  const _SophiaPopover({
    required this.onExpand,
    required this.onVoice,
    required this.onClose,
  });

  @override
  State<_SophiaPopover> createState() => _SophiaPopoverState();
}

class _SophiaPopoverState extends State<_SophiaPopover> {
  static const Color brandRed = Color(0xFFE8394A);
  static const Color navy = Color(0xFF14213D);
  static const Color textBlue = Color(0xFF4D86AD);
  static const Color lightBlue = Color(0xFF4FC3F7);

  final TextEditingController _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    // TODO: send to Sophia backend; for now just expand into full modal
    // so the reply has somewhere to render.
    _controller.clear();
    widget.onExpand();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: lightBlue,
                  child: Text(
                    'S',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Sophia',
                    style: TextStyle(fontWeight: FontWeight.bold, color: navy),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_full, size: 18, color: textBlue),
                  tooltip: 'Expand',
                  onPressed: widget.onExpand,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Stuck on something? Ask me here.',
              style: TextStyle(color: textBlue, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: 'Type a question...',
                      hintStyle: const TextStyle(fontSize: 13, color: textBlue),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF4F6F8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: widget.onVoice,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: brandRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mic, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-screen modal Sophia chat — opened from the popover's expand button.
class _SophiaFullModal extends StatefulWidget {
  const _SophiaFullModal();

  @override
  State<_SophiaFullModal> createState() => _SophiaFullModalState();
}

class _SophiaFullModalState extends State<_SophiaFullModal> {
  static const Color brandRed = Color(0xFFE8394A);
  static const Color navy = Color(0xFF14213D);
  static const Color textBlue = Color(0xFF4D86AD);
  static const Color bubbleGrey = Color(0xFFF4F6F8);

  final TextEditingController _controller = TextEditingController();
  final List<_ModalMessage> _messages = [
    const _ModalMessage(
      text: "Hi! I'm Sophia. What are you working on right now?",
      isUser: false,
    ),
  ];

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ModalMessage(text: text, isUser: true));
      // TODO: replace with real Sophia backend call.
      _messages.add(const _ModalMessage(
        text: "(Sophia's response will be connected here.)",
        isUser: false,
      ));
    });
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFF4FC3F7),
                      child: Text(
                        'S',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Sophia',
                        style: TextStyle(
                          color: navy,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: navy),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) => _buildBubble(_messages[index]),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFF0F2F5))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: InputDecoration(
                          hintText: 'Ask Sophia...',
                          hintStyle: const TextStyle(color: textBlue),
                          filled: true,
                          fillColor: bubbleGrey,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _send,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: brandRed,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBubble(_ModalMessage message) {
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

class _ModalMessage {
  final String text;
  final bool isUser;
  const _ModalMessage({required this.text, required this.isUser});
}