import 'package:flutter/material.dart';
import 'onboarding_initial_ai_assessment.dart';
import '../learning/student_dashboard.dart';

class BoardOption {
  final String code;
  final String name;
  final String subtitle;
  final IconData icon;
  bool selected;

  BoardOption({
    required this.code,
    required this.name,
    required this.subtitle,
    required this.icon,
    // FIX: this used to default to `true`, and none of the entries
    // below overrode it — so every board card rendered as "selected"
    // (red border + checkmark) on first load, for all 5 boards at
    // once, instead of just one. Default is now `false`, and only
    // one board (CBSE) is explicitly marked selected below.
    this.selected = false,
  });
}

class OnboardingBoardSelection extends StatefulWidget {
  const OnboardingBoardSelection({super.key});

  @override
  State<OnboardingBoardSelection> createState() =>
      _OnboardingBoardSelectionState();
}

class _OnboardingBoardSelectionState extends State<OnboardingBoardSelection> {
  // ================= COLORS =================

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color cardSelectedBg = Color(0xFFF6E3E4);
  static const Color infoBg = Color(0xFFE7E9FB);
  static const Color infoText = Color(0xFF5B6B8C);

  final List<BoardOption> _boards = [
    BoardOption(
      code: 'CBSE',
      name: 'CBSE',
      subtitle: 'Central Board of Secondary Education',
      icon: Icons.school_rounded,
      // Default selected board.
      selected: true,
    ),
    BoardOption(
      code: 'ICSE',
      name: 'ICSE',
      subtitle: 'Indian Certificate of Secondary Education',
      icon: Icons.account_balance_rounded,
    ),
    BoardOption(
      code: 'SSC',
      name: 'SSC',
      subtitle: 'State Board Curriculum',
      icon: Icons.location_city_rounded,
    ),
    BoardOption(
      code: 'IB',
      name: 'IB Board',
      subtitle: 'International Baccalaureate',
      icon: Icons.public_rounded,
    ),
    BoardOption(
      code: 'Cambridge',
      name: 'Cambridge',
      subtitle: 'IGCSE & A Levels',
      icon: Icons.language_rounded,
    ),
  ];

  void _selectBoard(BoardOption board) {
    setState(() {
      // Single-select: choosing one board unselects the rest.
      for (final b in _boards) {
        b.selected = identical(b, board);
      }
    });
  }

  void _continue() {
    final selected = _boards.firstWhere(
      (b) => b.selected,
      orElse: () => _boards.first,
    );
    // TODO: pass `selected` forward once the next page needs it.

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingInitialAiAssessment(),
      ),
    );
  }

  void _exploreAsGuest() {
    Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => const StudentDashboard(),
    ),
    (route) => false,
  );
    // TODO: hook up guest flow.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= TITLE =================

                    const Text(
                      'Choose Your Board',
                      style: TextStyle(
                        color: navy,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ================= SUBTITLE =================

                    const Text(
                      "We'll personalize your syllabus and AI mentor based on your curriculum.",
                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 16,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= BOARD LIST =================

                    ...List.generate(_boards.length, (index) {
                      final board = _boards[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == _boards.length - 1 ? 0 : 16,
                        ),
                        child: _BoardCard(
                          board: board,
                          onTap: () => _selectBoard(board),
                        ),
                      );
                    }),

                    const SizedBox(height: 16),

                    // ================= INFO BANNER =================

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: infoBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lightbulb_outline,
                              color: infoText,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'You can change your board later in settings if you switch schools.',
                              style: TextStyle(
                                color: infoText,
                                fontSize: 14,
                                height: 1.35,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =====================================================
            // BOTTOM SECTION
            // =====================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE9EDF0), width: 1),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _continue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandRed,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue to Grade Selection',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward,
                              color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ================= EXPLORE AS GUEST =================

                  GestureDetector(
                    onTap: _exploreAsGuest,
                    child: const Text(
                      'Not sure? Explore as guest',
                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
}

class _BoardCard extends StatelessWidget {
  final BoardOption board;
  final VoidCallback onTap;

  const _BoardCard({required this.board, required this.onTap});

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color cardSelectedBg = Color(0xFFF6E3E4);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: board.selected ? cardSelectedBg : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: board.selected ? brandRed : const Color(0xFFE2E8ED),
            width: 1.6,
          ),
        ),
        child: Row(
          children: [
            // ================= ICON =================

            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: brandRed,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(board.icon, color: Colors.white, size: 26),
            ),

            const SizedBox(width: 14),

            // ================= TEXT =================

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    board.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    board.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: subtitleBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // ================= CHECK =================

            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: board.selected ? brandRed : Colors.transparent,
                shape: BoxShape.circle,
                border: board.selected
                    ? null
                    : Border.all(color: const Color(0xFFE2E8ED)),
              ),
              child: board.selected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}