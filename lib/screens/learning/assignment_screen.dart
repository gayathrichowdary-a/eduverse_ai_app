import 'package:flutter/material.dart';

// ============================================================
// MODELS
// ============================================================

enum AssignmentStatus { pending, submitted, graded }

class AssignmentItem {
  final String title;
  final String subject;
  final String dueDate;
  final AssignmentStatus status;
  final String? grade;
  final Color accent;
  final IconData icon;

  const AssignmentItem({
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.status,
    this.grade,
    required this.accent,
    required this.icon,
  });
}

// ============================================================
// SCREEN
// ============================================================

class AssignmentScreen extends StatefulWidget {
  final List<AssignmentItem> assignments;

  const AssignmentScreen({
    super.key,
    this.assignments = const [
      AssignmentItem(
        title: 'Balancing Chemical Equations',
        subject: 'Chemistry',
        dueDate: 'Due tomorrow',
        status: AssignmentStatus.pending,
        accent: Color(0xFF33B679),
        icon: Icons.science,
      ),
      AssignmentItem(
        title: 'Derivatives Worksheet',
        subject: 'Maths',
        dueDate: 'Due in 4 days',
        status: AssignmentStatus.pending,
        accent: Color(0xFFE8394A),
        icon: Icons.functions,
      ),
      AssignmentItem(
        title: 'Newton\'s Laws Reflection',
        subject: 'Physics',
        dueDate: 'Submitted 2 days ago',
        status: AssignmentStatus.submitted,
        accent: Color(0xFF4D86AD),
        icon: Icons.bolt,
      ),
      AssignmentItem(
        title: 'Essay: Industrial Revolution',
        subject: 'History',
        dueDate: 'Graded',
        status: AssignmentStatus.graded,
        grade: 'A-',
        accent: Color(0xFFF4C10F),
        icon: Icons.menu_book_rounded,
      ),
    ],
  });

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color mastGreen = Color(0xFF33B679);
  static const Color mustard = Color(0xFFF4C10F);
  static const Color trackGrey = Color(0xFFE9EDF0);

  String _filter = 'All';
  final List<String> _filters = const ['All', 'Pending', 'Submitted', 'Graded'];

  final Map<String, bool> _localSubmitted = {};

  List<AssignmentItem> get _filtered {
    if (_filter == 'All') return widget.assignments;
    return widget.assignments.where((a) {
      switch (_filter) {
        case 'Pending':
          return a.status == AssignmentStatus.pending &&
              _localSubmitted[a.title] != true;
        case 'Submitted':
          return a.status == AssignmentStatus.submitted ||
              _localSubmitted[a.title] == true;
        case 'Graded':
          return a.status == AssignmentStatus.graded;
        default:
          return true;
      }
    }).toList();
  }

  String _statusLabel(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.pending:
        return 'Pending';
      case AssignmentStatus.submitted:
        return 'Submitted';
      case AssignmentStatus.graded:
        return 'Graded';
    }
  }

  Color _statusColor(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.pending:
        return brandRed;
      case AssignmentStatus.submitted:
        return mustard;
      case AssignmentStatus.graded:
        return mastGreen;
    }
  }

  void _openSubmitSheet(AssignmentItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final controller = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add a note for your teacher (optional)',
                  filled: true,
                  fillColor: trackGrey.withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(sheetContext).showSnackBar(
                    const SnackBar(
                      content:
                          Text('File picker — hook this up to your storage.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.attach_file_rounded, color: navy),
                label: const Text(
                  'Attach file',
                  style: TextStyle(color: navy, fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: navy, width: 1.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _localSubmitted[item.title] = true;
                    });
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.title} submitted!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Submit Assignment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: navy),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Assignments',
                    style: TextStyle(
                      color: navy,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: navy, height: 1, thickness: 1.4),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
              child: SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final f = _filters[index];
                    final selected = f == _filter;
                    return InkWell(
                      onTap: () => setState(() => _filter = f),
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected ? brandRed : Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: selected ? brandRed : navy,
                            width: 1.4,
                          ),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            color: selected ? Colors.white : navy,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                itemCount: _filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final item = _filtered[index];
                  final isSubmittedLocally =
                      _localSubmitted[item.title] == true;

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: navy, width: 1.4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: item.accent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(item.icon,
                                  color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.subject,
                                    style: const TextStyle(
                                      color: subtitleBlue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      color: navy,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: (isSubmittedLocally
                                        ? mustard
                                        : _statusColor(item.status))
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                isSubmittedLocally
                                    ? 'Submitted'
                                    : (item.grade != null
                                        ? '${_statusLabel(item.status)} · ${item.grade}'
                                        : _statusLabel(item.status)),
                                style: TextStyle(
                                  color: isSubmittedLocally
                                      ? mustard
                                      : _statusColor(item.status),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.event_rounded,
                                      color: subtitleBlue, size: 15),
                                  const SizedBox(width: 6),
                                  Text(
                                    item.dueDate,
                                    style: const TextStyle(
                                      color: subtitleBlue,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (item.status == AssignmentStatus.pending &&
                                !isSubmittedLocally)
                              SizedBox(
                                height: 38,
                                child: ElevatedButton(
                                  onPressed: () => _openSubmitSheet(item),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: brandRed,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            if (isSubmittedLocally)
                              const Icon(Icons.check_circle_rounded,
                                  color: mastGreen, size: 22),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}