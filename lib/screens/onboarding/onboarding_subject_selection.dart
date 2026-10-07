import 'package:flutter/material.dart';
import 'onboarding_learning_goal.dart';

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
  // ================= SIR'S BRAND COLORS =================
  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color brandGradientEnd = Color(0xFFF12C68);
  static const Color textMuted = Color(0xFF667085);
  static const Color cardBorder = Color(0xFFE4E7EC);

  final TextEditingController _searchController = TextEditingController();

  final List<Subject> _allSubjects = [
    Subject(name: 'Mathematics', icon: Icons.functions),
    Subject(name: 'Science', icon: Icons.science),
    Subject(name: 'English', icon: Icons.translate),
    Subject(name: 'Social Studies', icon: Icons.public),
    Subject(name: 'Comp. Science', icon: Icons.terminal),
    Subject(name: 'Artificial Intel.', icon: Icons.smart_toy),
    Subject(name: 'Biology', icon: Icons.biotech),
    Subject(name: 'Physics', icon: Icons.architecture),
    Subject(name: 'Medicine', icon: Icons.medical_services_outlined),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 20),
          // ================= 6-SEGMENT PROGRESS BAR (STEP 3 OF 6) =================
          child: Row(
            children: List.generate(6, (index) {
              final bool isActive = index <= 2; // First 3 segments active
              return Expanded(
                child: Container(
                  height: 5,
                  margin: EdgeInsets.only(right: index == 5 ? 0 : 6),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? const LinearGradient(
                            colors: [brandRed, brandGradientEnd],
                          )
                        : null,
                    color: isActive ? null : const Color(0xFFF0F2F4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Choose Your Subjects',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: navy,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Select the subjects you want to master with your AI mentor.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: textMuted,
                            ),
                          ),
                          const SizedBox(height: 18),
                          TextField(
                            controller: _searchController,
                            style: const TextStyle(fontSize: 14, color: navy),
                            decoration: InputDecoration(
                              hintText: 'Search subjects...',
                              hintStyle: const TextStyle(
                                color: Color(0xFF98A2B3),
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: textMuted,
                                size: 20,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: cardBorder,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: brandRed,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 136,
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

            // ================= BOTTOM CAPSULE CONTINUE BUTTON =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFF2F4F7), width: 1),
                ),
              ),
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [brandRed, brandGradientEnd],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30), // Sir's capsule pill shape
                  boxShadow: [
                    BoxShadow(
                      color: brandRed.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;

  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color cardBorder = Color(0xFFE4E7EC);
  static const Color textMuted = Color(0xFF667085);

  const _SubjectCard({required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: subject.selected ? const Color(0xFFFFF0F2) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: subject.selected ? brandRed : cardBorder,
            width: subject.selected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: subject.selected
                  ? brandRed.withOpacity(0.08)
                  : Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: subject.selected ? brandRed : const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    subject.icon,
                    color: subject.selected ? Colors.white : navy,
                    size: 20,
                  ),
                ),
                if (subject.selected)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: brandRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 13),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              subject.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: subject.selected ? brandRed : navy,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Mastery: ${subject.masteryPercent}%',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}