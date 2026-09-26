import 'package:flutter/material.dart';

/// exam_compiler.dart
/// Teacher module — lets an instructor build an exam (title, subject,
/// duration, marks), add MCQ / Coding / Descriptive questions, and either
/// save the exam as a draft or publish it directly to students.
///
/// NOTE ON STYLING:
/// No app-wide theme/colors file was available at the time this screen was
/// built, so a sensible default EdTech-style palette (indigo/purple primary,
/// soft card backgrounds, rounded corners) was used. Swap the constants in
/// `_ExamCompilerColors` below for your real `AppColors`/`AppTheme` values
/// and the rest of the screen will pick them up automatically.

class _ExamCompilerColors {
  static const primary = Color(0xFF5B5FEF);
  static const primaryDark = Color(0xFF4347C4);
  static const bg = Color(0xFFF6F7FB);
  static const card = Colors.white;
  static const border = Color(0xFFE7E8F3);
  static const textPrimary = Color(0xFF1E2130);
  static const textSecondary = Color(0xFF8B8D9A);
  static const success = Color(0xFF2ECC71);
  static const warning = Color(0xFFF5A623);
  static const danger = Color(0xFFEB5757);
  static const mcqTag = Color(0xFF5B5FEF);
  static const codingTag = Color(0xFF2ECC71);
  static const descriptiveTag = Color(0xFFF5A623);
}

enum QuestionType { mcq, coding, descriptive }

extension QuestionTypeX on QuestionType {
  String get label {
    switch (this) {
      case QuestionType.mcq:
        return 'MCQ';
      case QuestionType.coding:
        return 'Coding';
      case QuestionType.descriptive:
        return 'Descriptive';
    }
  }

  Color get color {
    switch (this) {
      case QuestionType.mcq:
        return _ExamCompilerColors.mcqTag;
      case QuestionType.coding:
        return _ExamCompilerColors.codingTag;
      case QuestionType.descriptive:
        return _ExamCompilerColors.descriptiveTag;
    }
  }

  IconData get icon {
    switch (this) {
      case QuestionType.mcq:
        return Icons.check_circle_outline;
      case QuestionType.coding:
        return Icons.code;
      case QuestionType.descriptive:
        return Icons.short_text;
    }
  }
}

class ExamQuestion {
  ExamQuestion({
    required this.id,
    required this.type,
    required this.text,
    this.options = const [],
    this.correctOptionIndex,
    this.marks = 1,
  });

  final String id;
  QuestionType type;
  String text;
  List<String> options;
  int? correctOptionIndex;
  int marks;
}

class ExamCompilerScreen extends StatefulWidget {
  const ExamCompilerScreen({super.key});

  @override
  State<ExamCompilerScreen> createState() => _ExamCompilerScreenState();
}

class _ExamCompilerScreenState extends State<ExamCompilerScreen> {
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _durationController = TextEditingController(text: '60');
  final _totalMarksController = TextEditingController();

  final List<ExamQuestion> _questions = [];

  bool _autoGrading = true;
  bool _scheduleExam = false;
  DateTime? _scheduledDate;
  TimeOfDay? _scheduledTime;

  bool _isSaving = false;

  int get _computedTotalMarks =>
      _questions.fold(0, (sum, q) => sum + q.marks);

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _durationController.dispose();
    _totalMarksController.dispose();
    super.dispose();
  }

  void _addOrEditQuestion({ExamQuestion? existing, int? index}) async {
    final result = await showModalBottomSheet<ExamQuestion>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddQuestionSheet(existing: existing),
    );

    if (result != null) {
      setState(() {
        if (existing != null && index != null) {
          _questions[index] = result;
        } else {
          _questions.add(result);
        }
        _totalMarksController.text = _computedTotalMarks.toString();
      });
    }
  }

  void _removeQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
      _totalMarksController.text = _computedTotalMarks.toString();
    });
  }

  Future<void> _pickScheduleDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;

    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      _scheduledDate = date;
      _scheduledTime = time;
    });
  }

  bool _validate({required bool forPublish}) {
    if (_titleController.text.trim().isEmpty) {
      _showSnack('Please enter an exam title', isError: true);
      return false;
    }
    if (_subjectController.text.trim().isEmpty) {
      _showSnack('Please enter a subject', isError: true);
      return false;
    }
    if (forPublish && _questions.isEmpty) {
      _showSnack('Add at least one question before publishing', isError: true);
      return false;
    }
    if (forPublish && _scheduleExam && (_scheduledDate == null || _scheduledTime == null)) {
      _showSnack('Please pick a schedule date & time', isError: true);
      return false;
    }
    return true;
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? _ExamCompilerColors.danger : _ExamCompilerColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _saveDraft() async {
    if (!_validate(forPublish: false)) return;
    setState(() => _isSaving = true);

    // TODO: replace with actual API / Firestore call to persist as draft.
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _isSaving = false);
    _showSnack('Exam saved as draft');
  }

  Future<void> _publishExam() async {
    if (!_validate(forPublish: true)) return;
    setState(() => _isSaving = true);

    // TODO: replace with actual API call to publish exam to students.
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isSaving = false);
    _showSnack('Exam published to students 🎉');
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _ExamCompilerColors.bg,
      appBar: AppBar(
        backgroundColor: _ExamCompilerColors.bg,
        elevation: 0,
        foregroundColor: _ExamCompilerColors.textPrimary,
        title: const Text(
          'Exam Compiler',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Question Bank',
            icon: const Icon(Icons.storage_rounded),
            onPressed: () {
              // TODO: navigate to cms_bank.dart / question bank picker.
              _showSnack('Open question bank — hook up navigation here');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 140),
        children: [
          _sectionCard(
            title: 'Exam Details',
            child: Column(
              children: [
                _textField(
                  controller: _titleController,
                  label: 'Exam Title',
                  hint: 'e.g. Unit Test 2 — Data Structures',
                  icon: Icons.title_rounded,
                ),
                const SizedBox(height: 14),
                _textField(
                  controller: _subjectController,
                  label: 'Subject',
                  hint: 'e.g. Computer Science',
                  icon: Icons.menu_book_rounded,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _textField(
                        controller: _durationController,
                        label: 'Duration (mins)',
                        hint: '60',
                        icon: Icons.timer_outlined,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _textField(
                        controller: _totalMarksController,
                        label: 'Total Marks',
                        hint: 'Auto-calculated',
                        icon: Icons.stars_rounded,
                        keyboardType: TextInputType.number,
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Advanced Settings',
            child: Column(
              children: [
                _switchTile(
                  icon: Icons.fact_check_outlined,
                  title: 'Auto Grading',
                  subtitle: 'MCQs are graded automatically on submission',
                  value: _autoGrading,
                  onChanged: (v) => setState(() => _autoGrading = v),
                ),
                const Divider(height: 24, color: _ExamCompilerColors.border),
                _switchTile(
                  icon: Icons.schedule_rounded,
                  title: 'Schedule Exam',
                  subtitle: _scheduleExam && _scheduledDate != null
                      ? 'Opens ${_formatSchedule()}'
                      : 'Publish immediately or schedule for later',
                  value: _scheduleExam,
                  onChanged: (v) {
                    setState(() => _scheduleExam = v);
                    if (v) _pickScheduleDateTime();
                  },
                ),
                if (_scheduleExam && _scheduledDate != null) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _pickScheduleDateTime,
                      icon: const Icon(Icons.edit_calendar_rounded, size: 18),
                      label: const Text('Change date & time'),
                      style: TextButton.styleFrom(
                        foregroundColor: _ExamCompilerColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Questions (${_questions.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _ExamCompilerColors.textPrimary,
                ),
              ),
              Text(
                'Total: $_computedTotalMarks marks',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _ExamCompilerColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_questions.isEmpty)
            _emptyQuestionsState()
          else
            ...List.generate(_questions.length, (index) {
              final q = _questions[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _QuestionCard(
                  index: index,
                  question: q,
                  onEdit: () => _addOrEditQuestion(existing: q, index: index),
                  onDelete: () => _removeQuestion(index),
                ),
              );
            }),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _addOrEditQuestion(),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Question'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _ExamCompilerColors.primary,
              side: const BorderSide(color: _ExamCompilerColors.primary, width: 1.4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              minimumSize: const Size(double.infinity, 0),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: _ExamCompilerColors.card,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSaving ? null : _saveDraft,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _ExamCompilerColors.primary,
                    side: const BorderSide(color: _ExamCompilerColors.primary, width: 1.4),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Save Draft', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _publishExam,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _ExamCompilerColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text('Publish Exam', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatSchedule() {
    if (_scheduledDate == null || _scheduledTime == null) return '';
    final d = _scheduledDate!;
    final t = _scheduledTime!.format(context);
    return '${d.day}/${d.month}/${d.year} at $t';
  }

  Widget _emptyQuestionsState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36),
      decoration: BoxDecoration(
        color: _ExamCompilerColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _ExamCompilerColors.border),
      ),
      child: Column(
        children: [
          Icon(Icons.quiz_outlined, size: 40, color: _ExamCompilerColors.textSecondary.withValues(alpha: 0.6)),
          const SizedBox(height: 10),
          const Text(
            'No questions yet',
            style: TextStyle(fontWeight: FontWeight.w600, color: _ExamCompilerColors.textPrimary),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap "Add Question" to build your exam',
            style: TextStyle(fontSize: 13, color: _ExamCompilerColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _ExamCompilerColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _ExamCompilerColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _ExamCompilerColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      style: const TextStyle(color: _ExamCompilerColors.textPrimary, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20, color: _ExamCompilerColors.textSecondary),
        labelStyle: const TextStyle(color: _ExamCompilerColors.textSecondary),
        filled: true,
        fillColor: readOnly ? _ExamCompilerColors.bg : _ExamCompilerColors.card,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _ExamCompilerColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _ExamCompilerColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _ExamCompilerColors.primary, width: 1.6),
        ),
      ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: _ExamCompilerColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 19, color: _ExamCompilerColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: _ExamCompilerColors.textPrimary)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: _ExamCompilerColors.textSecondary)),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: _ExamCompilerColors.primary,
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.index,
    required this.question,
    required this.onEdit,
    required this.onDelete,
  });

  final int index;
  final ExamQuestion question;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _ExamCompilerColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _ExamCompilerColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _ExamCompilerColors.bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: _ExamCompilerColors.textPrimary),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: question.type.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(question.type.icon, size: 13, color: question.type.color),
                    const SizedBox(width: 4),
                    Text(
                      question.type.label,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: question.type.color),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '${question.marks} ${question.marks == 1 ? 'mark' : 'marks'}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _ExamCompilerColors.textSecondary),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded, size: 20, color: _ExamCompilerColors.textSecondary),
                onSelected: (v) {
                  if (v == 'edit') onEdit();
                  if (v == 'delete') onDelete();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.text.isEmpty ? 'Untitled question' : question.text,
            style: const TextStyle(fontWeight: FontWeight.w600, color: _ExamCompilerColors.textPrimary),
          ),
          if (question.type == QuestionType.mcq && question.options.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(question.options.length, (i) {
                final isCorrect = question.correctOptionIndex == i;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isCorrect ? _ExamCompilerColors.success.withValues(alpha: 0.12) : _ExamCompilerColors.bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCorrect ? _ExamCompilerColors.success : _ExamCompilerColors.border,
                    ),
                  ),
                  child: Text(
                    question.options[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isCorrect ? _ExamCompilerColors.success : _ExamCompilerColors.textSecondary,
                    ),
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddQuestionSheet extends StatefulWidget {
  const _AddQuestionSheet({this.existing});

  final ExamQuestion? existing;

  @override
  State<_AddQuestionSheet> createState() => _AddQuestionSheetState();
}

class _AddQuestionSheetState extends State<_AddQuestionSheet> {
  late QuestionType _type;
  late TextEditingController _textController;
  late TextEditingController _marksController;
  late List<TextEditingController> _optionControllers;
  int? _correctIndex;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _type = existing?.type ?? QuestionType.mcq;
    _textController = TextEditingController(text: existing?.text ?? '');
    _marksController = TextEditingController(text: (existing?.marks ?? 1).toString());
    _correctIndex = existing?.correctOptionIndex;
    final opts = existing?.options.isNotEmpty == true
        ? existing!.options
        : ['', '', '', ''];
    _optionControllers = opts.map((o) => TextEditingController(text: o)).toList();
  }

  @override
  void dispose() {
    _textController.dispose();
    _marksController.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (_textController.text.trim().isEmpty) return;

    final question = ExamQuestion(
      id: widget.existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      type: _type,
      text: _textController.text.trim(),
      options: _type == QuestionType.mcq
          ? _optionControllers.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList()
          : [],
      correctOptionIndex: _type == QuestionType.mcq ? _correctIndex : null,
      marks: int.tryParse(_marksController.text.trim()) ?? 1,
    );

    Navigator.of(context).pop(question);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: _ExamCompilerColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: _ExamCompilerColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Text(
                widget.existing != null ? 'Edit Question' : 'Add Question',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _ExamCompilerColors.textPrimary),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: QuestionType.values.map((t) {
                  final selected = t == _type;
                  return ChoiceChip(
                    label: Text(t.label),
                    selected: selected,
                    onSelected: (_) => setState(() => _type = t),
                    selectedColor: t.color.withValues(alpha: 0.15),
                    labelStyle: TextStyle(
                      color: selected ? t.color : _ExamCompilerColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(color: selected ? t.color : _ExamCompilerColors.border),
                    backgroundColor: _ExamCompilerColors.bg,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _textController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Question',
                  hintText: 'Type the question here...',
                  filled: true,
                  fillColor: _ExamCompilerColors.bg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              if (_type == QuestionType.mcq) ...[
                const Text('Options', style: TextStyle(fontWeight: FontWeight.w600, color: _ExamCompilerColors.textPrimary)),
                const SizedBox(height: 8),
                ...List.generate(_optionControllers.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Radio<int>(
                          value: i,
                          groupValue: _correctIndex,
                          activeColor: _ExamCompilerColors.success,
                          onChanged: (v) => setState(() => _correctIndex = v),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _optionControllers[i],
                            decoration: InputDecoration(
                              hintText: 'Option ${i + 1}',
                              filled: true,
                              fillColor: _ExamCompilerColors.bg,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 6),
              ],
              TextField(
                controller: _marksController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Marks',
                  filled: true,
                  fillColor: _ExamCompilerColors.bg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _ExamCompilerColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(widget.existing != null ? 'Save Changes' : 'Add Question'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}