import 'package:flutter/material.dart';
import 'onboarding_daily_study_time.dart';

class InterestOption {
  final String label;
  final IconData icon;
  bool selected;

  InterestOption({
    required this.label,
    required this.icon,
    this.selected = false,
  });
}

class OnboardingInterestSelection extends StatefulWidget {
  const OnboardingInterestSelection({Key? key}) : super(key: key);

  @override
  State<OnboardingInterestSelection> createState() =>
      _OnboardingInterestSelectionState();
}

class _OnboardingInterestSelectionState
    extends State<OnboardingInterestSelection> {
  // ================= COLORS =================

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color yellow = Color(0xFFFFD400);
  static const Color yellowSelected = Color(0xFFFFC700);

  static const int _minRequired = 3;

  final List<InterestOption> _interests = [
    InterestOption(label: 'Robotics', icon: Icons.precision_manufacturing),
    InterestOption(label: 'Programming', icon: Icons.terminal),
    InterestOption(label: 'Art & Design', icon: Icons.palette),
    InterestOption(label: 'Music', icon: Icons.music_note),
    InterestOption(label: 'Sports', icon: Icons.sports_basketball),
    InterestOption(label: 'Photography', icon: Icons.photo_camera),
    InterestOption(label: 'Space', icon: Icons.rocket_launch),
    InterestOption(label: 'Science', icon: Icons.science),
    InterestOption(label: 'Reading', icon: Icons.menu_book),
    InterestOption(label: 'Business', icon: Icons.business_center),
    InterestOption(label: 'Nature', icon: Icons.park),
    InterestOption(label: 'Game Dev', icon: Icons.sports_esports),
  ];

  int get _selectedCount => _interests.where((i) => i.selected).length;

  bool get _canContinue => _selectedCount >= _minRequired;

  void _toggleInterest(InterestOption interest) {
    setState(() => interest.selected = !interest.selected);
  }

  void _continue() {
    if (!_canContinue) return;
    final selected = _interests.where((i) => i.selected).toList();
    // TODO: pass `selected` forward once the next page needs it.

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingDailyStudyTime(),
      ),
    );
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
                      'What do you enjoy?',
                      style: TextStyle(
                        color: navy,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ================= SUBTITLE =================

                    const Text(
                      'Choose at least three interests to personalize your AI mentor.',
                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 16,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ================= INTEREST GRID =================

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _interests.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        // Fixed height avoids overflow regardless of
                        // text scale factor.
                        mainAxisExtent: 150,
                      ),
                      itemBuilder: (context, index) {
                        final interest = _interests[index];
                        return _InterestCard(
                          interest: interest,
                          onTap: () => _toggleInterest(interest),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // ================= SELECTED COUNTER =================

                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: subtitleBlue,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$_selectedCount interest'
                            '${_selectedCount == 1 ? '' : 's'} selected',
                            style: const TextStyle(
                              color: subtitleBlue,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
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
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _canContinue ? _continue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    disabledBackgroundColor: const Color(0xFFF3A1A7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Continue to EduVerse',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
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

class _InterestCard extends StatelessWidget {
  final InterestOption interest;
  final VoidCallback onTap;

  const _InterestCard({required this.interest, required this.onTap});

  static const Color navy = Color(0xFF14213D);
  static const Color yellow = Color(0xFFFFD400);
  static const Color yellowSelected = Color(0xFFFFC700);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: interest.selected ? yellowSelected : yellow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: interest.selected ? navy : Colors.transparent,
            width: interest.selected ? 2 : 0,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(interest.icon, color: navy, size: 22),
                  const SizedBox(width: 10),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        interest.label,
                        maxLines: 1,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (interest.selected)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: navy,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: yellow, size: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}