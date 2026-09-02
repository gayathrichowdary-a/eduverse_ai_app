import 'package:flutter/material.dart';
import 'onboarding_learning_goal.dart';

/// ---------------------------------------------------------------------
/// Colors used across this page (kept local so you can drop this file in
/// as-is without depending on a separate theme file).
/// ---------------------------------------------------------------------
class _Palette {
  static const Color red = Color(0xFFE8394A);
  static const Color redDark = Color(0xFFD32E3F);
  static const Color navy = Color(0xFF14213D);
  static const Color subtitleGrey = Color(0xFF6B7A8F);
  static const Color hintTeal = Color(0xFFB9D6D6);
  static const Color cardBorder = Color(0xFFE8394A);
  static const Color background = Colors.white;
}

class Subject {
  final String name;
  final IconData icon;
  final int masteryPercent;
  bool selected;

  Subject({
    required this.name,
    required this.icon,
    this.masteryPercent = 0,
    this.selected = true,
  });
}

class OnboardingSubjectSelection extends StatefulWidget {
  const OnboardingSubjectSelection({super.key});

  @override
  State<OnboardingSubjectSelection> createState() =>
      _OnboardingSubjectSelectionState();
}

class _OnboardingSubjectSelectionState
    extends State<OnboardingSubjectSelection> {
  final TextEditingController _searchController = TextEditingController();

  final List<Subject> _allSubjects = [
    Subject(name: 'Mathematics', icon: Icons.functions),
    Subject(name: 'Science', icon: Icons.science),
    Subject(name: 'English', icon: Icons.translate),
    Subject(name: 'Social Studies', icon: Icons.public),
    Subject(name: 'Comp. Science', icon: Icons.terminal),
    Subject(name: 'Artificial Intel.', icon: Icons.smart_toy),
    Subject(name: 'Biology', icon: Icons.help_outline),
    Subject(name: 'Physics', icon: Icons.architecture),
    Subject(name: 'Medicine', icon: Icons.medical_services),
  ];

  List<Subject> _filteredSubjects = [];

  @override
  void initState() {
    super.initState();
    _filteredSubjects = _allSubjects;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredSubjects = query.isEmpty
          ? _allSubjects
          : _allSubjects
              .where((s) => s.name.toLowerCase().contains(query))
              .toList();
    });
  }

  void _toggleSubject(Subject subject) {
    setState(() => subject.selected = !subject.selected);
  }

  void _continue() {
    final selected = _allSubjects.where((s) => s.selected).toList();
    // TODO: pass `selected` forward once the next page needs it.

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingLearningGoal(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Palette.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    sliver: SliverToBoxAdapter(
                      child: _Header(searchController: _searchController),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        // Fixed row height avoids any overflow (the
                        // yellow/black striped error banner) regardless of
                        // text scale factor.
                        mainAxisExtent: 210,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final subject = _filteredSubjects[index];
                          return _SubjectCard(
                            subject: subject,
                            onTap: () => _toggleSubject(subject),
                          );
                        },
                        childCount: _filteredSubjects.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _ContinueButton(onPressed: _continue),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final TextEditingController searchController;

  const _Header({required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Your Subjects',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: _Palette.navy,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Select the subjects you want to master with your AI mentor.',
          style: TextStyle(
            fontSize: 16,
            height: 1.35,
            color: _Palette.subtitleGrey,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: searchController,
          style: const TextStyle(fontSize: 16, color: _Palette.navy),
          decoration: InputDecoration(
            hintText: 'Search subjects...',
            hintStyle: const TextStyle(color: _Palette.hintTeal),
            prefixIcon: const Icon(Icons.search, color: _Palette.hintTeal),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8ED)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8ED)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _Palette.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;

  const _SubjectCard({required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color:
                subject.selected ? _Palette.cardBorder : const Color(0xFFE2E8ED),
            width: 1.4,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: _Palette.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(subject.icon, color: Colors.white, size: 24),
                ),
                AnimatedOpacity(
                  opacity: subject.selected ? 1 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: _Palette.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check,
                        color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              subject.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: _Palette.navy,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Mastery: ${subject.masteryPercent}%',
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: _Palette.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ContinueButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _Palette.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.arrow_forward, size: 20),
            SizedBox(width: 10),
            Text(
              'Continue to Dashboard',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}