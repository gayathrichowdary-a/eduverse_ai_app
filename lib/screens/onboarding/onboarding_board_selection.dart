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
  // Sir's Brand Colors
  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color brandGradientEnd = Color(0xFFF12C68);
  static const Color textMuted = Color(0xFF667085);
  static const Color cardBorder = Color(0xFFE4E7EC);

  final List<BoardOption> _boards = [
    BoardOption(
      code: 'CBSE',
      name: 'CBSE',
      subtitle: 'Central Board of Secondary Education',
      icon: Icons.school_outlined,
      selected: true,
    ),
    BoardOption(
      code: 'ICSE',
      name: 'ICSE',
      subtitle: 'Indian Certificate of Secondary Education',
      icon: Icons.account_balance_outlined,
    ),
    BoardOption(
      code: 'SSC',
      name: 'State Board (SSC)',
      subtitle: 'State Board Curriculum & Syllabus',
      icon: Icons.location_city_outlined,
    ),
    BoardOption(
      code: 'IB',
      name: 'IB Board',
      subtitle: 'International Baccalaureate Curriculum',
      icon: Icons.public_outlined,
    ),
    BoardOption(
      code: 'Cambridge',
      name: 'Cambridge International',
      subtitle: 'IGCSE & A Levels',
      icon: Icons.language_outlined,
    ),
  ];

  void _selectBoard(BoardOption board) {
    setState(() {
      for (final b in _boards) {
        b.selected = identical(b, board);
      }
    });
  }

  void _continue() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(height: 5, color: brandRed),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(height: 5, color: brandRed),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(height: 5, color: brandRed),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(height: 5, color: brandRed),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(height: 5, color: brandRed),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title in Sir's exact typography
                    const Text(
                      'Choose Your Board',
                      style: TextStyle(
                        color: navy,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    const Text(
                      "We'll personalize your syllabus and AI mentor based on your curriculum.",
                      style: TextStyle(
                        color: textMuted,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Board List
                    ..._boards.map((board) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _BoardCard(
                          board: board,
                          onTap: () => _selectBoard(board),
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 12),

                    // Info Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F6FB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE4E7EC)),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xFF4D86AD),
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'You can switch your board syllabus anytime later in your profile settings.',
                              style: TextStyle(
                                color: Color(0xFF4D86AD),
                                fontSize: 12,
                                height: 1.35,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Bottom Continue Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFF2F4F7), width: 1),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [brandRed, brandGradientEnd],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
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
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue to AI Assessment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: _exploreAsGuest,
                    child: const Text(
                      'Not sure? Explore as guest',
                      style: TextStyle(
                        color: textMuted,
                        fontSize: 13,
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

  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color cardBorder = Color(0xFFE4E7EC);
  static const Color textMuted = Color(0xFF667085);

  const _BoardCard({required this.board, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: board.selected ? const Color(0xFFFFF0F2) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: board.selected ? brandRed : cardBorder,
            width: board.selected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: board.selected
                  ? brandRed.withOpacity(0.08)
                  : Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: board.selected ? brandRed : const Color(0xFFF2F4F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                board.icon,
                color: board.selected ? Colors.white : navy,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    board.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: board.selected ? brandRed : navy,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    board.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: board.selected ? brandRed : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: board.selected ? brandRed : cardBorder,
                  width: 2,
                ),
              ),
              child: board.selected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}