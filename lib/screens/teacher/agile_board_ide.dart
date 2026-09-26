import 'package:flutter/material.dart';

/// agile_board_ide.dart
/// Teacher module — instructors review student coding projects line by line
/// and send feedback. Two screens live in this file:
///   1. AgileBoardIde        -> list of student projects awaiting review
///   2. CodeReviewScreen     -> code editor + line-by-line comments + feedback
///
/// Colors match the real EduVerse AI system (from teacher_portal_hub.dart):
/// navy #1F355C, yellow #FFD52E, background #F8F8F8, coral CTA #E94A56.

const Color kNavy = Color(0xFF1F355C);
const Color kYellow = Color(0xFFFFD52E);
const Color kBg = Color(0xFFF8F8F8);
const Color kCoral = Color(0xFFE94A56);
const Color kMuted = Colors.grey;

enum ReviewStatus { pending, inProgress, reviewed }

extension ReviewStatusX on ReviewStatus {
  String get label {
    switch (this) {
      case ReviewStatus.pending:
        return "Pending Review";
      case ReviewStatus.inProgress:
        return "In Progress";
      case ReviewStatus.reviewed:
        return "Reviewed";
    }
  }

  Color get color {
    switch (this) {
      case ReviewStatus.pending:
        return const Color(0xFFF7C948);
      case ReviewStatus.inProgress:
        return const Color(0xFF58C7F3);
      case ReviewStatus.reviewed:
        return const Color(0xFF57B97A);
    }
  }
}

class StudentProject {
  StudentProject({
    required this.id,
    required this.studentName,
    required this.projectTitle,
    required this.subject,
    required this.status,
    required this.codeLines,
    List<LineComment>? comments,
  }) : comments = comments ?? [];

  final String id;
  final String studentName;
  final String projectTitle;
  final String subject;
  ReviewStatus status;
  final List<String> codeLines;
  final List<LineComment> comments;
}

class LineComment {
  LineComment({required this.lineNumber, required this.text});
  final int lineNumber;final String text;
}

// -------------------- MOCK DATA --------------------

final List<StudentProject> _mockProjects = [
  StudentProject(
    id: "p1",
    studentName: "Arjun Mehta",
    projectTitle: "Student Grade Calculator",
    subject: "Python Basics",
    status: ReviewStatus.pending,
    codeLines: const [
      "def calculate_grade(marks):",
      "    if marks >= 90:",
      "        return 'A'",
      "    elif marks >= 75:",
      "        return 'B'",
      "    else:",
      "        return 'C'",
      "",
      "print(calculate_grade(82))",
    ],
  ),
  StudentProject(
    id: "p2",
    studentName: "Sana Khan",
    projectTitle: "Linked List Implementation",
    subject: "Data Structures",
    status: ReviewStatus.inProgress,
    codeLines: const [
      "class Node:",
      "    def __init__(self, data):",
      "        self.data = data",
      "        self.next = None",
      "",
      "class LinkedList:",
      "    def __init__(self):",
      "        self.head = None",
    ],
    comments: [LineComment(lineNumber: 3, text: "Good — clean constructor.")],
  ),
  StudentProject(
    id: "p3",
    studentName: "Rohan Das",
    projectTitle: "To-Do List App (Flutter)",
    subject: "Mobile Development",
    status: ReviewStatus.reviewed,
    codeLines: const [
      "class TodoItem {",
      "  String title;",
      "  bool isDone;",
      "",
      "  TodoItem(this.title, {this.isDone = false});",
      "}",
    ],
    comments: [
      LineComment(lineNumber: 2, text: "Consider making fields final."),
      LineComment(lineNumber: 5, text: "Nice use of named parameter default."),
    ],
  ),
];

// ==================== SCREEN 1: PROJECTS LIST ====================

class AgileBoardIde extends StatefulWidget {
  const AgileBoardIde({super.key});

  @override
  State<AgileBoardIde> createState() => _AgileBoardIdeState();
}

class _AgileBoardIdeState extends State<AgileBoardIde> {
  late List<StudentProject> projects;

  @override
  void initState() {
    super.initState();
    projects = _mockProjects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            //================ HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              decoration: const BoxDecoration(
                color: kYellow,
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
                        border: Border.all(color: kNavy, width: 2),
                      ),
                      child: const Icon(Icons.arrow_back, color: kNavy, size: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    "Agile Board",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kNavy),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            //================ PROJECT LIST =================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Student Projects (${projects.length})",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kNavy),
                    ),
                    const SizedBox(height: 12),
                    ...projects.map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _ProjectCard(
                            project: p,
                            onReview: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CodeReviewScreen(project: p),
                                ),
                              );
                              setState(() {}); // refresh status/comments on return
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

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.onReview});

  final StudentProject project;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kNavy, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(color: Color(0xFFEDEDED), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(
                  project.studentName.split(" ").map((e) => e.isNotEmpty ? e[0] : "").take(2).join(),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF5E6D7A)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.studentName,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: kNavy)),
                    const SizedBox(height: 2),
                    Text(project.subject, style: const TextStyle(fontSize: 12, color: kMuted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: project.status.color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  project.status.label,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: project.status.color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(project.projectTitle,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: kNavy)),
          const SizedBox(height: 4),
          Text("${project.codeLines.length} lines • ${project.comments.length} comments",
              style: const TextStyle(fontSize: 12, color: kMuted)),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: kCoral,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text("Review", style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== SCREEN 2: CODE REVIEW ====================

class CodeReviewScreen extends StatefulWidget {
  const CodeReviewScreen({super.key, required this.project});

  final StudentProject project;

  @override
  State<CodeReviewScreen> createState() => _CodeReviewScreenState();
}

class _CodeReviewScreenState extends State<CodeReviewScreen> {
  int? _selectedLine;
  final _commentController = TextEditingController();
  bool _isRunning = false;
  String? _runOutput;
  late ReviewStatus _status;

  @override
  void initState() {
    super.initState();
    _status = widget.project.status;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Map<int, List<LineComment>> get _commentsByLine {
    final map = <int, List<LineComment>>{};
    for (final c in widget.project.comments) {
      map.putIfAbsent(c.lineNumber, () => []).add(c);
    }
    return map;
  }

  void _addComment() {
    if (_selectedLine == null || _commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select a line and enter a comment")),
      );
      return;
    }
    setState(() {
      widget.project.comments.add(
        LineComment(lineNumber: _selectedLine!, text: _commentController.text.trim()),
      );
      _commentController.clear();
      _selectedLine = null;
    });
  }

  void _runCode() async {
    setState(() {
      _isRunning = true;
      _runOutput = null;
    });
    // TODO: replace with real code-execution / sandbox API call.
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() {
      _isRunning = false;
      _runOutput = "Program executed successfully — no errors found.";
    });
  }

  void _sendFeedback() {
    setState(() => _status = ReviewStatus.reviewed);
    widget.project.status = ReviewStatus.reviewed;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Feedback sent to ${widget.project.studentName}"),
        backgroundColor: const Color(0xFF57B97A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final commentsByLine = _commentsByLine;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            //================ HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              decoration: const BoxDecoration(
                color: kYellow,
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
                        border: Border.all(color: kNavy, width: 2),
                      ),
                      child: const Icon(Icons.arrow_back, color: kNavy, size: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.project.projectTitle,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kNavy),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.project.studentName,
                          style: const TextStyle(fontSize: 13, color: kNavy),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //================ STATUS + RUN/DEBUG =================
                    Row(
                      children: [
                        Expanded(child: _statusChipRow()),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isRunning ? null : _runCode,
                            icon: _isRunning
                                ? const SizedBox(
                                    width: 14, height: 14,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: kNavy),
                                  )
                                : const Icon(Icons.play_arrow_rounded, color: kNavy),
                            label: const Text("Run", style: TextStyle(color: kNavy, fontWeight: FontWeight.w700)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: kNavy, width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Debugger attached — step through with breakpoints")),
                              );
                            },
                            icon: const Icon(Icons.bug_report_outlined, color: kNavy),
                            label: const Text("Debug", style: TextStyle(color: kNavy, fontWeight: FontWeight.w700)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: kNavy, width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_runOutput != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF7FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline, size: 16, color: kNavy),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(_runOutput!,
                                  style: const TextStyle(fontSize: 12, color: kNavy)),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    //================ CODE EDITOR =================
                    const Text("Code Editor",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kNavy)),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kNavy,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: List.generate(widget.project.codeLines.length, (i) {
                          final lineNo = i + 1;
                          final isSelected = _selectedLine == lineNo;
                          final lineComments = commentsByLine[lineNo] ?? [];
                          return GestureDetector(
                            onTap: () => setState(() => _selectedLine = lineNo),
                            child: Container(
                              color: isSelected ? Colors.white.withValues(alpha: 0.10) : Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 26,
                                    child: Text(
                                      "$lineNo",
                                      style: TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 12,
                                        color: Colors.white.withValues(alpha: 0.4),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.project.codeLines[i].isEmpty ? " " : widget.project.codeLines[i],
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 13,
                                        color: Colors.white,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                  if (lineComments.isNotEmpty)
                                    Container(
                                      margin: const EdgeInsets.only(left: 6),
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: kYellow,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        "${lineComments.length}",
                                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kNavy),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _selectedLine != null
                          ? "Line $_selectedLine selected — add your comment below"
                          : "Tap a line to attach a comment",
                      style: const TextStyle(fontSize: 12, color: kMuted, fontStyle: FontStyle.italic),
                    ),

                    const SizedBox(height: 22),

                    //================ INSTRUCTOR COMMENTS =================
                    const Text("Instructor Comments",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kNavy)),
                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kNavy, width: 2),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                hintText: _selectedLine != null
                                    ? "Comment on line $_selectedLine..."
                                    : "Select a line first...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _addComment,
                            icon: const Icon(Icons.send_rounded, color: kCoral),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    if (widget.project.comments.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text("No comments yet.", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      )
                    else
                      ...widget.project.comments.map((c) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: kNavy, width: 1.4),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: kYellow,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "L${c.lineNumber}",
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kNavy),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(c.text, style: const TextStyle(fontSize: 13, color: kNavy, height: 1.4)),
                                  ),
                                ],
                              ),
                            ),
                          )),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            //================ SEND FEEDBACK =================
            Container(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _sendFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kCoral,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text("Send Feedback", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChipRow() {
    return Wrap(
      spacing: 8,
      children: ReviewStatus.values.map((s) {
        final isActive = s == _status;
        return GestureDetector(
          onTap: () {
            setState(() {
              _status = s;
              widget.project.status = s;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: isActive ? s.color : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kNavy, width: 2),
            ),
            child: Text(
              s.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : kNavy,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}