import 'package:flutter/material.dart';

/// Sophia Voice Assistant — lets the student talk through a doubt in their
/// own native language, per the spec's Voice Assistant requirement.
class AiVoiceConversation extends StatefulWidget {
  const AiVoiceConversation({super.key});

  @override
  State<AiVoiceConversation> createState() => _AiVoiceConversationState();
}

class _AiVoiceConversationState extends State<AiVoiceConversation> {
  static const Color brandRed = Color(0xFFE8394A);
  static const Color navy = Color(0xFF14213D);
  static const Color lightBlue = Color(0xFF4FC3F7);
  static const Color textBlue = Color(0xFF4D86AD);

  // Native-language support — the spec calls this out explicitly, so it's
  // a first-class control here rather than an afterthought.
  static const List<String> _supportedLanguages = [
    'English',
    'తెలుగు (Telugu)',
    'हिन्दी (Hindi)',
    'தமிழ் (Tamil)',
    'ಕನ್ನಡ (Kannada)',
  ];
  String _selectedLanguage = 'English';

  bool _isListening = true;
  bool _isMuted = false;
  bool _speakerOn = true;

  String _sophiaResponse =
      "I'm here to help. Tell me which topic or problem is confusing you.";

  void _toggleListening() {
    setState(() => _isListening = !_isListening);
    // TODO: hook into actual speech-to-text (e.g. speech_to_text package),
    // start/stop capture based on _isListening, and send the recognized
    // text + _selectedLanguage to Sophia's backend for a response.
  }

  void _toggleMute() {
    setState(() => _isMuted = !_isMuted);
  }

  void _toggleSpeaker() {
    setState(() => _speakerOn = !_speakerOn);
  }

  void _stopConversation() {
    setState(() {
      _isListening = false;
      _sophiaResponse = "Ended the session. Tap the mic anytime to resume.";
    });
    // TODO: tear down STT/TTS session and any open audio streams.
  }

  void _pickLanguage() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Talk to Sophia in',
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ..._supportedLanguages.map(
                  (lang) => ListTile(
                    title: Text(
                      lang,
                      style: const TextStyle(color: navy, fontWeight: FontWeight.w600),
                    ),
                    trailing: lang == _selectedLanguage
                        ? const Icon(Icons.check_circle, color: brandRed)
                        : null,
                    onTap: () => Navigator.pop(context, lang),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (choice != null) {
      setState(() => _selectedLanguage = choice);
      // TODO: pass _selectedLanguage into the STT/TTS session config.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildTopBar(),

              const Spacer(flex: 1),

              Text(
                _isListening ? "Listening..." : "Paused",
                style: TextStyle(
                  color: _isListening ? brandRed : textBlue,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _waveBar(20, lightBlue),
                  _waveBar(40, brandRed),
                  _waveBar(60, lightBlue),
                  _waveBar(45, brandRed),
                  _waveBar(25, lightBlue),
                ],
              ),

              const SizedBox(height: 50),

              GestureDetector(
                onTap: _toggleListening,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: brandRed.withOpacity(0.1),
                  ),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening ? brandRed : textBlue,
                    ),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_off,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: lightBlue,
                          radius: 15,
                          child: Text(
                            "S",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Sophia",
                          style: TextStyle(fontWeight: FontWeight.bold, color: navy),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _sophiaResponse,
                      style: const TextStyle(color: navy, fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton(
                    _isMuted ? Icons.mic_off : Icons.mic_none,
                    _isMuted ? "Unmute" : "Mute",
                    onTap: _toggleMute,
                    isActive: _isMuted,
                  ),
                  _actionButton(
                    _speakerOn ? Icons.volume_up : Icons.volume_off,
                    "Speaker",
                    onTap: _toggleSpeaker,
                    isActive: !_speakerOn,
                  ),
                  _actionButton(
                    Icons.stop,
                    "Stop",
                    onTap: _stopConversation,
                    isRed: true,
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.close, color: navy, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 4,
                backgroundColor: _isListening ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                "Sophia Active",
                style: TextStyle(color: navy.withOpacity(0.7), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        // Language picker — required for "talk in your own native language".
        GestureDetector(
          onTap: _pickLanguage,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const Icon(Icons.language, color: navy, size: 20),
                const SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, color: navy.withOpacity(0.6)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _waveBar(double height, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: _isListening ? height : height * 0.4,
      width: 6,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _actionButton(
    IconData icon,
    String label, {
    required VoidCallback onTap,
    bool isRed = false,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isRed
                  ? brandRed
                  : (isActive ? navy.withOpacity(0.08) : Colors.white),
              border: isRed ? null : Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
              ],
            ),
            child: Icon(icon, color: isRed ? Colors.white : navy),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: textBlue, fontSize: 12)),
        ],
      ),
    );
  }
}