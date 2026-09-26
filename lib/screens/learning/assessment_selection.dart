import 'package:flutter/material.dart';
import '../onboarding/onboarding_assessment_in_progress.dart';
// ============================================================
// MODELS
// ============================================================

enum AssessmentCategory { all, competitive, weekly }

class MockTestItem {
  final String title;
  final String duration; // e.g. "180 min"
  final int questionCount;
  final String subjectsLabel; // e.g. "Physics, Chemistry, Maths"
  final AssessmentCategory category;

  const MockTestItem({
    required this.title,
    required this.duration,
    required this.questionCount,
    required this.subjectsLabel,
    required this.category,
  });
}

class DeadlineItem {
  final IconData icon;
  final Color iconBackground;
  final String title;
  final String subtitle;

  const DeadlineItem({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
  });
}

// ============================================================
// SCREEN
// ============================================================

class AssessmentSelection extends StatefulWidget {
  final int completedCount;
  final int avgScorePercent;
  final List<MockTestItem> recommended;
  final List<DeadlineItem> deadlines;
  final String personalizedTestLabel;
  final String personalizedTestSubtitle;

  const AssessmentSelection({
    super.key,
    this.completedCount = 12,
    this.avgScorePercent = 88,
    this.recommended = const [
      MockTestItem(
        title: 'JEE Main Full Mock - Physics',
        duration: '180 min',
        questionCount: 90,
        subjectsLabel: 'Physics, Chemistry, Maths',
        category: AssessmentCategory.competitive,
      ),
      MockTestItem(
        title: 'NEET Practice: Biology Genetics',
        duration: '60 min',
        questionCount: 90,
        subjectsLabel: 'Biology',
        category: AssessmentCategory.competitive,
      ),
    ],
    this.deadlines = const [
      DeadlineItem(
        icon: Icons.functions,
        iconBackground: Color(0xFFF4A100),
        title: 'Maths Unit 4 Test',
        subtitle: 'Tomorrow, 10:00 AM',
      ),
      DeadlineItem(
        icon: Icons.menu_book_rounded,
        iconBackground: Color(0xFF5B5FE0),
        title: 'English Literature Quiz',
        subtitle: 'Friday, 02:30 PM',
      ),
    ],
    this.personalizedTestLabel = 'Personalized AI Test',
    this.personalizedTestSubtitle = 'Based on your weak topics in Algebra',
  });

  @override
  State<AssessmentSelection> createState() => _AssessmentSelectionState();
}

class _AssessmentSelectionState extends State<AssessmentSelection> {
  // ================= COLORS =================

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color mastGreen = Color(0xFF33B679);
  static const Color mustard = Color(0xFFF4C10F);
  static const Color trackGrey = Color(0xFFE9EDF0);
  static const Color chipBlueBg = Color(0xFFDCF1F8);

  AssessmentCategory _selectedCategory = AssessmentCategory.all;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MockTestItem> get _filteredTests {
    final query = _searchController.text.trim().toLowerCase();
    return widget.recommended.where((test) {
      final matchesCategory = _selectedCategory == AssessmentCategory.all ||
          test.category == _selectedCategory;
      final matchesQuery =
          query.isEmpty || test.title.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _startMockTest(MockTestItem test) {
    // FIX: OnboardingAssessmentInProgress dropped its totalQuestions
    // param when it was shrunk to a fixed 3-question warm-up — it no
    // longer takes question-count input from callers.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OnboardingAssessmentInProgress(),
      ),
    );
  }

  void _startPersonalizedTest() {
    // FIX: same as above — totalQuestions is no longer a valid param.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OnboardingAssessmentInProgress(),
      ),
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
            // ================= TOP BAR =================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: navy, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Assessments',
                      style: TextStyle(
                        color: navy,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      // TODO: hook up overflow menu actions.
                    },
                    icon: const Icon(Icons.more_vert_rounded,
                        color: navy, size: 22),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= SEARCH =================
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(color: navy, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Search mock tests...',
                        hintStyle: const TextStyle(color: subtitleBlue),
                        prefixIcon:
                            const Icon(Icons.search, color: subtitleBlue),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              const BorderSide(color: trackGrey, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: navy, width: 1.4),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ================= CATEGORY TABS =================
                    Row(
                      children: [
                        _CategoryTab(
                          label: 'All',
                          selected:
                              _selectedCategory == AssessmentCategory.all,
                          onTap: () => setState(
                              () => _selectedCategory = AssessmentCategory.all),
                        ),
                        const SizedBox(width: 10),
                        _CategoryTab(
                          label: 'Competitive',
                          selected: _selectedCategory ==
                              AssessmentCategory.competitive,
                          onTap: () => setState(() => _selectedCategory =
                              AssessmentCategory.competitive),
                        ),
                        const SizedBox(width: 10),
                        _CategoryTab(
                          label: 'Weekly',
                          selected:
                              _selectedCategory == AssessmentCategory.weekly,
                          onTap: () => setState(() =>
                              _selectedCategory = AssessmentCategory.weekly),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ================= STAT CARDS =================
                    Row(
                      children: [
                        Expanded(
                          child: _StatMiniCard(
                            icon: Icons.check_circle_rounded,
                            iconColor: mastGreen,
                            label: 'Completed',
                            value: '${widget.completedCount}',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatMiniCard(
                            icon: Icons.star_rounded,
                            iconColor: mustard,
                            label: 'Avg. Score',
                            value: '${widget.avgScorePercent}%',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ================= RECOMMENDED =================
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Recommended for You',
                            style: TextStyle(
                              color: navy,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: navigate to full recommended list.
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              color: brandRed,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    if (_filteredTests.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'No mock tests match your search.',
                          style: TextStyle(
                            color: subtitleBlue,
                            fontSize: 14,
                          ),
                        ),
                      )
                    else
                      ..._filteredTests.map(
                        (test) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _MockTestCard(
                            test: test,
                            onStart: () => _startMockTest(test),
                          ),
                        ),
                      ),

                    const SizedBox(height: 12),

                    // ================= UPCOMING DEADLINES =================
                    const Text(
                      'Upcoming Deadlines',
                      style: TextStyle(
                        color: navy,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 14),

                    ...widget.deadlines.map(
                      (deadline) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _DeadlineTile(deadline: deadline),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ================= PERSONALIZED AI TEST =================
                    InkWell(
                      onTap: _startPersonalizedTest,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: brandRed,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.22),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.auto_awesome,
                                  color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.personalizedTestLabel,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.personalizedTestSubtitle,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded,
                                color: Colors.white, size: 24),
                          ],
                        ),
                      ),
                    ),
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

// ============================================================
// CATEGORY TAB
// ============================================================

class _CategoryTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  static const Color navy = Color(0xFF14213D);
  static const Color chipBlueBg = Color(0xFFDCF1F8);
  static const Color trackGrey = Color(0xFFE9EDF0);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? chipBlueBg : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: selected ? navy : trackGrey,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: navy,
            fontSize: 14,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// STAT MINI CARD
// ============================================================

class _StatMiniCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatMiniCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: navy, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: subtitleBlue,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: navy,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MOCK TEST CARD
// ============================================================

class _MockTestCard extends StatelessWidget {
  final MockTestItem test;
  final VoidCallback onStart;

  const _MockTestCard({required this.test, required this.onStart});

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color trackGrey = Color(0xFFE9EDF0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: trackGrey, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  test.title,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: subtitleBlue, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  color: subtitleBlue, size: 15),
              const SizedBox(width: 6),
              Text(
                test.duration,
                style: const TextStyle(
                  color: subtitleBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.help_outline_rounded,
                  color: subtitleBlue, size: 15),
              const SizedBox(width: 6),
              Text(
                '${test.questionCount} Qs',
                style: const TextStyle(
                  color: subtitleBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            test.subjectsLabel,
            style: const TextStyle(
              color: brandRed,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: brandRed,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text(
                'Start Mock Test',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DEADLINE TILE
// ============================================================

class _DeadlineTile extends StatelessWidget {
  final DeadlineItem deadline;

  const _DeadlineTile({required this.deadline});

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color trackGrey = Color(0xFFE9EDF0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: trackGrey, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: deadline.iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(deadline.icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deadline.title,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  deadline.subtitle,
                  style: const TextStyle(
                    color: subtitleBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: subtitleBlue, size: 20),
        ],
      ),
    );
  }
}