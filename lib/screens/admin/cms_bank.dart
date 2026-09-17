import 'package:flutter/material.dart';

// ---------------------------------------------------------------
// Shared design tokens for this screen (inlined — no shared theme
// file). Kept identical across all 5 admin screens so they stay
// visually consistent even without a common import.
// ---------------------------------------------------------------
class AppColors {
  static const Color primary = Color(0xFF4F46E5); // Indigo
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color background = Color(0xFFF7F8FC);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);
  static const Color easy = Color(0xFF16A34A);
  static const Color medium = Color(0xFFD97706);
  static const Color hard = Color(0xFFDC2626);
}

class AppTextStyles {
  static const TextStyle screenTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle cardValue = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );
  static const TextStyle cardLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}

/// Reusable card container so this screen's sections share the
/// same corner radius / shadow / padding treatment.
class AdminCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AdminCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Small colored status/label pill used across list rows.
class StatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const StatusPill({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Standard admin app bar so this screen's title bar matches the
/// rest of the admin module.
PreferredSizeWidget adminAppBar(String title, {List<Widget>? actions}) {
  return AppBar(
    title: Text(title, style: AppTextStyles.screenTitle),
    backgroundColor: AppColors.background,
    elevation: 0,
    foregroundColor: AppColors.textPrimary,
    actions: actions,
  );
}

/// Admin > CMS Question Bank
///
/// Manage the DSA coding questions shown in the student's coding
/// section: search, filter by topic/difficulty, add/edit/delete,
/// and publish/unpublish.
class CmsBankScreen extends StatefulWidget {
  const CmsBankScreen({super.key});

  @override
  State<CmsBankScreen> createState() => _CmsBankScreenState();
}

enum Difficulty { easy, medium, hard }

extension DifficultyX on Difficulty {
  String get label => switch (this) {
        Difficulty.easy => 'Easy',
        Difficulty.medium => 'Medium',
        Difficulty.hard => 'Hard',
      };

  Color get color => switch (this) {
        Difficulty.easy => AppColors.easy,
        Difficulty.medium => AppColors.medium,
        Difficulty.hard => AppColors.hard,
      };
}

class TestCase {
  String input;
  String expectedOutput;
  TestCase({required this.input, required this.expectedOutput});
}

class CodingQuestion {
  String title;
  String topic;
  Difficulty difficulty;
  String prompt;
  List<TestCase> testCases;
  bool isPublished;

  CodingQuestion({
    required this.title,
    required this.topic,
    required this.difficulty,
    required this.prompt,
    required this.testCases,
    this.isPublished = true,
  });
}

const List<String> kTopics = [
  'Arrays',
  'Strings',
  'Linked List',
  'Trees',
  'Graphs',
  'Dynamic Programming',
  'Stacks & Queues',
];

class _CmsBankScreenState extends State<CmsBankScreen> {
  final List<CodingQuestion> _questions = [
    CodingQuestion(
      title: 'Two Sum',
      topic: 'Arrays',
      difficulty: Difficulty.easy,
      prompt: 'Return indices of the two numbers that add up to target.',
      testCases: [
        TestCase(input: '[2,7,11,15], target=9', expectedOutput: '[0,1]'),
      ],
    ),
    CodingQuestion(
      title: 'Binary Tree Level Order Traversal',
      topic: 'Trees',
      difficulty: Difficulty.medium,
      prompt: 'Return the level order traversal of a binary tree.',
      testCases: [
        TestCase(
            input: '[3,9,20,null,null,15,7]',
            expectedOutput: '[[3],[9,20],[15,7]]'),
      ],
    ),
    CodingQuestion(
      title: 'Course Schedule',
      topic: 'Graphs',
      difficulty: Difficulty.hard,
      prompt: 'Determine if all courses can be finished given prerequisites.',
      testCases: [
        TestCase(input: 'numCourses=2, [[1,0]]', expectedOutput: 'true'),
      ],
      isPublished: false,
    ),
    CodingQuestion(
      title: 'Reverse Linked List',
      topic: 'Linked List',
      difficulty: Difficulty.easy,
      prompt: 'Reverse a singly linked list.',
      testCases: [
        TestCase(input: '[1,2,3,4,5]', expectedOutput: '[5,4,3,2,1]'),
      ],
    ),
  ];

  String _query = '';
  String? _topicFilter;
  Difficulty? _difficultyFilter;

  List<CodingQuestion> get _filtered {
    return _questions.where((q) {
      final matchesQuery =
          _query.trim().isEmpty || q.title.toLowerCase().contains(_query.toLowerCase());
      final matchesTopic = _topicFilter == null || q.topic == _topicFilter;
      final matchesDifficulty =
          _difficultyFilter == null || q.difficulty == _difficultyFilter;
      return matchesQuery && matchesTopic && matchesDifficulty;
    }).toList();
  }

  Map<String, int> get _topicCounts {
    final map = <String, int>{};
    for (final q in _questions) {
      map[q.topic] = (map[q.topic] ?? 0) + 1;
    }
    return map;
  }

  void _openEditor({CodingQuestion? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _QuestionEditorSheet(
        existing: existing,
        onSave: (q) {
          setState(() {
            if (existing == null) {
              _questions.add(q);
            } else {
              final i = _questions.indexOf(existing);
              _questions[i] = q;
            }
          });
        },
      ),
    );
  }

  void _delete(CodingQuestion q) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete question?'),
        content: Text('This will permanently remove "${q.title}".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _questions.remove(q));
              Navigator.pop(ctx);
            },
            child: const Text('Delete',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: adminAppBar('DSA Question Bank'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Add Question'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search question...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),

          // Topic summary chips (tap to filter)
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _topicCounts.entries.map((e) {
                final selected = _topicFilter == e.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('${e.key}  ${e.value}'),
                    selected: selected,
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                    onSelected: (sel) {
                      setState(() => _topicFilter = sel ? e.key : null);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // Difficulty filter row
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: Difficulty.values.map((d) {
                final selected = _difficultyFilter == d;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(d.label),
                    selected: selected,
                    labelStyle: TextStyle(
                        color: selected ? d.color : AppColors.textSecondary,
                        fontSize: 12),
                    selectedColor: d.color.withValues(alpha: 0.15),
                    onSelected: (sel) {
                      setState(() => _difficultyFilter = sel ? d : null);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text('No questions found',
                        style: AppTextStyles.caption))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final q = _filtered[i];
                      return _QuestionCard(
                        question: q,
                        onEdit: () => _openEditor(existing: q),
                        onDelete: () => _delete(q),
                        onTogglePublish: () =>
                            setState(() => q.isPublished = !q.isPublished),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final CodingQuestion question;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTogglePublish;

  const _QuestionCard({
    required this.question,
    required this.onEdit,
    required this.onDelete,
    required this.onTogglePublish,
  });

  @override
  Widget build(BuildContext context) {
    final q = question;
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(q.title,
                    style: AppTextStyles.sectionTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              StatusPill(label: q.difficulty.label, color: q.difficulty.color),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.topic_outlined,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(q.topic, style: AppTextStyles.caption),
              const SizedBox(width: 12),
              const Icon(Icons.fact_check_outlined,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('${q.testCases.length} test case${q.testCases.length == 1 ? '' : 's'}',
                  style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              StatusPill(
                label: q.isPublished ? 'Published' : 'Unpublished',
                color: q.isPublished ? AppColors.success : AppColors.textSecondary,
              ),
              const Spacer(),
              IconButton(
                icon: Icon(q.isPublished
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                tooltip: q.isPublished ? 'Unpublish' : 'Publish',
                onPressed: onTogglePublish,
                color: AppColors.textSecondary,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit',
                onPressed: onEdit,
                color: AppColors.primary,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete',
                onPressed: onDelete,
                color: AppColors.danger,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuestionEditorSheet extends StatefulWidget {
  final CodingQuestion? existing;
  final void Function(CodingQuestion) onSave;

  const _QuestionEditorSheet({this.existing, required this.onSave});

  @override
  State<_QuestionEditorSheet> createState() => _QuestionEditorSheetState();
}

class _QuestionEditorSheetState extends State<_QuestionEditorSheet> {
  late TextEditingController _titleCtrl;
  late TextEditingController _promptCtrl;
  late String _topic;
  late Difficulty _difficulty;
  late List<TestCase> _testCases;
  late bool _published;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _titleCtrl = TextEditingController(text: e?.title ?? '');
    _promptCtrl = TextEditingController(text: e?.prompt ?? '');
    _topic = e?.topic ?? kTopics.first;
    _difficulty = e?.difficulty ?? Difficulty.easy;
    _testCases = e?.testCases
            .map((t) => TestCase(input: t.input, expectedOutput: t.expectedOutput))
            .toList() ??
        [TestCase(input: '', expectedOutput: '')];
    _published = e?.isPublished ?? true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _promptCtrl.dispose();
    super.dispose();
  }

  void _addTestCase() {
    setState(() => _testCases.add(TestCase(input: '', expectedOutput: '')));
  }

  void _removeTestCase(int i) {
    setState(() => _testCases.removeAt(i));
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) return;
    widget.onSave(CodingQuestion(
      title: _titleCtrl.text.trim(),
      topic: _topic,
      difficulty: _difficulty,
      prompt: _promptCtrl.text.trim(),
      testCases: _testCases
          .where((t) => t.input.trim().isNotEmpty)
          .toList(),
      isPublished: _published,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: ListView(
              controller: scrollController,
              children: [
                Text(isEditing ? 'Edit Question' : 'Add Question',
                    style: AppTextStyles.screenTitle),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: 'Question Title'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _topic,
                        decoration: const InputDecoration(labelText: 'Topic'),
                        items: kTopics
                            .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                            .toList(),
                        onChanged: (v) => setState(() => _topic = v ?? _topic),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<Difficulty>(
                        initialValue: _difficulty,
                        decoration: const InputDecoration(labelText: 'Difficulty'),
                        items: Difficulty.values
                            .map((d) =>
                                DropdownMenuItem(value: d, child: Text(d.label)))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _difficulty = v ?? _difficulty),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _promptCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Coding Question / Prompt',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Test Cases', style: AppTextStyles.sectionTitle),
                    TextButton.icon(
                      onPressed: _addTestCase,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add'),
                    ),
                  ],
                ),
                ..._testCases.asMap().entries.map((entry) {
                  final i = entry.key;
                  final tc = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AdminCard(
                      child: Column(
                        children: [
                          TextField(
                            decoration: const InputDecoration(labelText: 'Input'),
                            controller: TextEditingController(text: tc.input)
                              ..selection = TextSelection.collapsed(offset: tc.input.length),
                            onChanged: (v) => tc.input = v,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            decoration:
                                const InputDecoration(labelText: 'Expected Output'),
                            controller:
                                TextEditingController(text: tc.expectedOutput)
                                  ..selection = TextSelection.collapsed(
                                      offset: tc.expectedOutput.length),
                            onChanged: (v) => tc.expectedOutput = v,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () => _removeTestCase(i),
                              icon: const Icon(Icons.delete_outline,
                                  size: 16, color: AppColors.danger),
                              label: const Text('Remove',
                                  style: TextStyle(color: AppColors.danger)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Published'),
                  subtitle: const Text('Visible to students immediately'),
                  value: _published,
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) => setState(() => _published = v),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(isEditing ? 'Save Changes' : 'Add Question'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}