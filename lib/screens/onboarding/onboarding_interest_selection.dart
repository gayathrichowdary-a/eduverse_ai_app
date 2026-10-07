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
  const OnboardingInterestSelection({super.key});

  @override
  State<OnboardingInterestSelection> createState() =>
      _OnboardingInterestSelectionState();
}

class _OnboardingInterestSelectionState
    extends State<OnboardingInterestSelection> {
  // ================= SIR'S BRAND DESIGN COLORS =================
  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color brandGradientEnd = Color(0xFFF12C68);
  static const Color textMuted = Color(0xFF667085);
  static const Color cardBorder = Color(0xFFE4E7EC);

  static const int _minRequired = 3;

  final List<InterestOption> _interests = [
    InterestOption(label: 'Robotics', icon: Icons.precision_manufacturing_outlined),
    InterestOption(label: 'Programming', icon: Icons.terminal_outlined),
    InterestOption(label: 'Art & Design', icon: Icons.palette_outlined),
    InterestOption(label: 'Music', icon: Icons.music_note_outlined),
    InterestOption(label: 'Sports', icon: Icons.sports_basketball_outlined),
    InterestOption(label: 'Photography', icon: Icons.photo_camera_outlined),
    InterestOption(label: 'Space & Astro', icon: Icons.rocket_launch_outlined),
    InterestOption(label: 'Science & Lab', icon: Icons.science_outlined),
    InterestOption(label: 'Reading & Lit', icon: Icons.menu_book_outlined),
    InterestOption(label: 'Business', icon: Icons.business_center_outlined),
    InterestOption(label: 'Nature & Bio', icon: Icons.park_outlined),
    InterestOption(label: 'Game Dev', icon: Icons.sports_esports_outlined),
  ];

  int get _selectedCount => _interests.where((i) => i.selected).length;
  bool get _canContinue => _selectedCount >= _minRequired;

  void _toggleInterest(InterestOption interest) {
    setState(() => interest.selected = !interest.selected);
  }

  void _continue() {
    if (!_canContinue) return;
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
          // ================= 6-SEGMENT PROGRESS BAR (ALL 6 STEPS ACTIVE) =================
          child: Row(
            children: List.generate(6, (index) {
              return Expanded(
                child: Container(
                  height: 5,
                  margin: EdgeInsets.only(right: index == 5 ? 0 : 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [brandRed, brandGradientEnd],
                    ),
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'What are your interests?',
                      style: TextStyle(
                        color: navy,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle + Counter Badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Text(
                            'Choose at least 3 interests to personalize topics.',
                            style: TextStyle(
                              color: textMuted,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: _canContinue
                                ? const Color(0xFFFFF0F2)
                                : const Color(0xFFF2F4F7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _canContinue ? brandRed : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '$_selectedCount / 3 selected',
                            style: TextStyle(
                              color: _canContinue ? brandRed : textMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Interest Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _interests.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 60,
                      ),
                      itemBuilder: (context, index) {
                        final interest = _interests[index];
                        return _InterestCard(
                          interest: interest,
                          onTap: () => _toggleInterest(interest),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
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
                  gradient: _canContinue
                      ? const LinearGradient(
                          colors: [brandRed, brandGradientEnd],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                  color: _canContinue ? null : const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(30), // Sir's capsule pill shape
                  boxShadow: _canContinue
                      ? [
                          BoxShadow(
                            color: brandRed.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: ElevatedButton(
                  onPressed: _canContinue ? _continue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _canContinue ? 'Continue' : 'Select at least $_minRequired',
                        style: TextStyle(
                          color: _canContinue ? Colors.white : const Color(0xFF98A2B3),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_canContinue) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                      ],
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

class _InterestCard extends StatelessWidget {
  final InterestOption interest;
  final VoidCallback onTap;

  const _InterestCard({required this.interest, required this.onTap});

  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color cardBorder = Color(0xFFE4E7EC);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: interest.selected ? const Color(0xFFFFF0F2) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: interest.selected ? brandRed : cardBorder,
            width: interest.selected ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: interest.selected
                  ? brandRed.withOpacity(0.08)
                  : Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              interest.icon,
              color: interest.selected ? brandRed : navy,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                interest.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: interest.selected ? brandRed : navy,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (interest.selected)
              const Icon(Icons.check, color: brandRed, size: 16),
          ],
        ),
      ),
    );
  }
}