import 'package:flutter/material.dart';

/// virtual_meet.dart
/// Teacher module — online classes & extracurricular meetings.
///   1. VirtualMeet         -> upcoming classes list, create meeting
///   2. LiveMeetingScreen   -> in-call UI: video tiles, mic/cam/screen-share,
///                              chat, participants, raise hand, poll, quiz
///
/// No real video/audio backend is wired up — video tiles, mic/cam state,
/// chat, polls and quizzes are all local UI state. Swap in your WebRTC /
/// Agora / Jitsi SDK calls where marked with TODO.
///
/// Colors are private to this file (prefixed with _) so they never collide
/// with the kNavy/kYellow/etc. constants already declared in
/// agile_board_ide.dart when both files are imported into the same hub.

const Color _navy = Color(0xFF1F355C);
const Color _yellow = Color(0xFFFFD52E);
const Color _bg = Color(0xFFF8F8F8);
const Color _coral = Color(0xFFE94A56);
const Color _green = Color(0xFF57B97A);
const Color _blue = Color(0xFF58C7F3);

class MeetingModel {
  MeetingModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.startTime,
    required this.endTime,
    this.isLive = false,
  });

  final String id;
  String title;
  String subject;
  String startTime;
  String endTime;
  bool isLive;
}

final List<MeetingModel> _mockMeetings = [
  MeetingModel(
    id: "m1",
    title: "Data Structures",
    subject: "Computer Science",
    startTime: "10:00 AM",
    endTime: "11:00 AM",
    isLive: true,
  ),
  MeetingModel(
    id: "m2",
    title: "Organic Chemistry Doubt Session",
    subject: "Chemistry",
    startTime: "1:00 PM",
    endTime: "1:45 PM",
  ),
  MeetingModel(
    id: "m3",
    title: "Debate Club — Weekly Meet",
    subject: "Extracurricular",
    startTime: "4:30 PM",
    endTime: "5:15 PM",
  ),
];

class ChatMessage {
  ChatMessage({required this.sender, required this.text});
  final String sender;
  final String text;
}

class PollOption {
  PollOption({required this.text, this.votes = 0});
  final String text;
  int votes;
}

// ==================== SCREEN 1: MEETING LIST ====================

class VirtualMeet extends StatefulWidget {
  const VirtualMeet({super.key});

  @override
  State<VirtualMeet> createState() => _VirtualMeetState();
}

class _VirtualMeetState extends State<VirtualMeet> {
  late List<MeetingModel> meetings;

  @override
  void initState() {
    super.initState();
    meetings = _mockMeetings;
  }

  void _createMeeting() async {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();
    final timeController = TextEditingController();

    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const Text("Create Meeting", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: _navy)),
              const SizedBox(height: 16),
              _sheetField(titleController, "Meeting Title", "e.g. Algebra Revision"),
              const SizedBox(height: 12),
              _sheetField(subjectController, "Subject", "e.g. Mathematics"),
              const SizedBox(height: 12),
              _sheetField(timeController, "Time", "e.g. 3:00 PM - 3:45 PM"),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) return;
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _coral,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text("Create", style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (created == true) {
      final parts = timeController.text.split('-');
      setState(() {
        meetings.add(MeetingModel(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: titleController.text.trim(),
          subject: subjectController.text.trim().isEmpty ? "General" : subjectController.text.trim(),
          startTime: parts.isNotEmpty ? parts[0].trim() : "TBD",
          endTime: parts.length > 1 ? parts[1].trim() : "",
        ));
      });
    }
  }

  Widget _sheetField(TextEditingController c, String label, String hint) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: _bg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            //================ HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              decoration: const BoxDecoration(
                color: _yellow,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all(color: _navy, width: 2),
                      ),
                      child: const Icon(Icons.arrow_back, color: _navy, size: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text("Virtual Meet", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _navy)),
                ],
              ),
            ),
            const SizedBox(height: 22),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Upcoming Classes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _navy)),
                        GestureDetector(
                          onTap: _createMeeting,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                            decoration: BoxDecoration(
                              color: _coral,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text("Create Meeting", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ...meetings.map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _MeetingCard(
                            meeting: m,
                            onJoin: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => LiveMeetingScreen(meeting: m)));
                            },
                            onReschedule: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Reschedule ${m.title} — hook up date/time picker here")),
                              );
                            },
                          ),
                        )),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeetingCard extends StatelessWidget {
  const _MeetingCard({required this.meeting, required this.onJoin, required this.onReschedule});

  final MeetingModel meeting;
  final VoidCallback onJoin;
  final VoidCallback onReschedule;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _navy, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(meeting.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _navy)),
              ),
              if (meeting.isLive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: _coral.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 8, color: _coral),
                      SizedBox(width: 5),
                      Text("LIVE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _coral)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(meeting.subject, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.schedule, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text("${meeting.startTime} - ${meeting.endTime}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onJoin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _coral,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text("Join", style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onReschedule,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _navy, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text("Reschedule", style: TextStyle(color: _navy, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== SCREEN 2: LIVE MEETING ====================

class LiveMeetingScreen extends StatefulWidget {
  const LiveMeetingScreen({super.key, required this.meeting});

  final MeetingModel meeting;

  @override
  State<LiveMeetingScreen> createState() => _LiveMeetingScreenState();
}

class _LiveMeetingScreenState extends State<LiveMeetingScreen> {
  bool _micOn = true;
  bool _camOn = true;
  bool _screenSharing = false;
  bool _handRaised = false;

  final List<String> _participants = ["You (Teacher)", "Arjun Mehta", "Sana Khan", "Rohan Das", "Priya Sharma"];
  final Map<String, bool> _participantMics = {
    "Arjun Mehta": true, "Sana Khan": false, "Rohan Das": true, "Priya Sharma": false,
  };

  final List<ChatMessage> _messages = [
    ChatMessage(sender: "Sana Khan", text: "Good morning!"),
    ChatMessage(sender: "Rohan Das", text: "Can you repost the slide link?"),
  ];
  final _chatController = TextEditingController();

  List<PollOption> _pollOptions = [];
  String _pollQuestion = "";

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  void _toggleMic() => setState(() => _micOn = !_micOn);
  void _toggleCam() => setState(() => _camOn = !_camOn);
  void _toggleShare() {
    setState(() => _screenSharing = !_screenSharing);
    // TODO: hook into real screen-share / WebRTC track publishing here.
  }
  void _toggleHand() {
    setState(() => _handRaised = !_handRaised);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_handRaised ? "Hand raised" : "Hand lowered"), duration: const Duration(seconds: 1)),
    );
  }

  void _sendChat() {
    if (_chatController.text.trim().isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(sender: "You (Teacher)", text: _chatController.text.trim()));
      _chatController.clear();
    });
  }

  void _openChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, scrollController) => Container(
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: Column(
              children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 14),
                const Align(alignment: Alignment.centerLeft, child: Text("Chat", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: _navy))),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (_, i) {
                      final m = _messages[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Align(
                          alignment: m.sender.startsWith("You") ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            constraints: const BoxConstraints(maxWidth: 260),
                            decoration: BoxDecoration(
                              color: m.sender.startsWith("You") ? _coral.withOpacity(0.12) : _bg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m.sender, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _navy)),
                                const SizedBox(height: 2),
                                Text(m.text, style: const TextStyle(fontSize: 13, color: _navy)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          filled: true,
                          fillColor: _bg,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _sendChat();
                        setSheetState(() {});
                      },
                      icon: const Icon(Icons.send_rounded, color: _coral),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openParticipants() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 14), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)))),
            Text("Participants (${_participants.length})", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: _navy)),
            const SizedBox(height: 14),
            ..._participants.map((p) {
              final isTeacher = p.startsWith("You");
              final micOn = isTeacher ? _micOn : (_participantMics[p] ?? false);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    CircleAvatar(radius: 18, backgroundColor: _bg, child: Text(p[0], style: const TextStyle(color: _navy, fontWeight: FontWeight.bold))),
                    const SizedBox(width: 12),
                    Expanded(child: Text(p, style: const TextStyle(fontWeight: FontWeight.w600, color: _navy))),
                    Icon(micOn ? Icons.mic : Icons.mic_off, size: 18, color: micOn ? _green : Colors.grey),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _openPoll() {
    final questionController = TextEditingController(text: _pollQuestion);
    final optionControllers = List.generate(3, (i) => TextEditingController(text: _pollOptions.length > i ? _pollOptions[i].text : ""));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 14), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)))),
              const Text("Launch Poll", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: _navy)),
              const SizedBox(height: 14),
              TextField(controller: questionController, decoration: InputDecoration(labelText: "Question", filled: true, fillColor: _bg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
              const SizedBox(height: 10),
              ...optionControllers.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: e.value,
                      decoration: InputDecoration(labelText: "Option ${e.key + 1}", filled: true, fillColor: _bg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                    ),
                  )),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (questionController.text.trim().isEmpty) return;
                    setState(() {
                      _pollQuestion = questionController.text.trim();
                      _pollOptions = optionControllers.where((c) => c.text.trim().isNotEmpty).map((c) => PollOption(text: c.text.trim())).toList();
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Poll launched to all participants")));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: _coral, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: const Text("Launch Poll", style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openQuiz() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 14), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)))),
            const Text("Quick Quiz", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: _navy)),
            const SizedBox(height: 8),
            const Text("Send a quick quiz question to all students in the meeting.", style: TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: navigate to exam_compiler.dart / cms_bank.dart to pick or build a quick quiz.
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pick a quiz from Exam Compiler / Question Bank — hook up navigation here")));
                },
                icon: const Icon(Icons.quiz_outlined, color: Colors.white),
                label: const Text("Choose Quiz", style: TextStyle(fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(backgroundColor: _coral, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _endMeeting() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("End meeting?", style: TextStyle(color: _navy, fontWeight: FontWeight.bold)),
        content: const Text("This will end the session for all participants."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("End", style: TextStyle(color: _coral, fontWeight: FontWeight.bold))),
        ],
      ),
    );
    if (confirm == true && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _navy,
      body: SafeArea(
        child: Column(
          children: [
            //================ TOP BAR =================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(widget.meeting.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: _coral.withOpacity(0.25), borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 8, color: _coral),
                        SizedBox(width: 5),
                        Text("LIVE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //================ VIDEO GRID =================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.85,
                  ),
                  itemCount: _participants.length,
                  itemBuilder: (_, i) {
                    final name = _participants[i];
                    final isTeacher = name.startsWith("You");
                    final camOn = isTeacher ? _camOn : true;
                    final micOn = isTeacher ? _micOn : (_participantMics[name] ?? false);
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A4066),
                        borderRadius: BorderRadius.circular(16),
                        border: _handRaised && isTeacher ? Border.all(color: _yellow, width: 2) : null,
                      ),
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Center(
                            child: camOn
                                ? CircleAvatar(radius: 28, backgroundColor: _bg, child: Text(name[0], style: const TextStyle(color: _navy, fontWeight: FontWeight.bold, fontSize: 20)))
                                : const Icon(Icons.videocam_off_rounded, color: Colors.white54, size: 30),
                          ),
                          Positioned(
                            left: 8, bottom: 8,
                            child: Row(
                              children: [
                                Text(name, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                                const SizedBox(width: 4),
                                Icon(micOn ? Icons.mic : Icons.mic_off, size: 13, color: micOn ? _green : _coral),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            //================ SCREEN SHARE BANNER =================
            if (_screenSharing)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(color: _green.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: const Row(
                  children: [
                    Icon(Icons.screen_share_rounded, color: _green, size: 16),
                    SizedBox(width: 8),
                    Text("You are sharing your screen", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),

            //================ CONTROL BAR =================
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(color: Color(0xFF16294A)),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _controlButton(icon: _micOn ? Icons.mic : Icons.mic_off, label: "Mic", active: _micOn, onTap: _toggleMic),
                        const SizedBox(width: 14),
                        _controlButton(icon: _camOn ? Icons.videocam : Icons.videocam_off, label: "Camera", active: _camOn, onTap: _toggleCam),
                        const SizedBox(width: 14),
                        _controlButton(icon: Icons.screen_share_rounded, label: "Share", active: _screenSharing, onTap: _toggleShare),
                        const SizedBox(width: 14),
                        _controlButton(icon: Icons.chat_bubble_outline_rounded, label: "Chat", active: false, onTap: _openChat),
                        const SizedBox(width: 14),
                        _controlButton(icon: Icons.people_alt_outlined, label: "People", active: false, onTap: _openParticipants),
                        const SizedBox(width: 14),
                        _controlButton(icon: Icons.back_hand_outlined, label: "Raise Hand", active: _handRaised, onTap: _toggleHand),
                        const SizedBox(width: 14),
                        _controlButton(icon: Icons.poll_outlined, label: "Poll", active: false, onTap: _openPoll),
                        const SizedBox(width: 14),
                        _controlButton(icon: Icons.quiz_outlined, label: "Quiz", active: false, onTap: _openQuiz),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _endMeeting,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                      decoration: BoxDecoration(color: _coral, borderRadius: BorderRadius.circular(24)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.call_end_rounded, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text("End Meeting", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        ],
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

  Widget _controlButton({required IconData icon, required String label, required bool active, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              color: active ? _yellow : Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: active ? _navy : Colors.white, size: 20),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }
}