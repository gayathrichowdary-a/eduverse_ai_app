import 'package:flutter/material.dart';

import 'onboarding_ai_processing.dart';

// ============================================================
// MODEL
// ============================================================

class GradeOption {
  final String number; // e.g. "9"
  final String label; // e.g. "Freshman"

  const GradeOption({required this.number, required this.label});
}

class InterestOption {
  final IconData icon;
  final String label;

  const InterestOption({required this.icon, required this.label});
}

// ============================================================
// SCREEN
// ============================================================

class OnboardingProfileSetup extends StatefulWidget {
  /// Which step this screen represents out of [totalSteps].
  final int currentStep;
  final int totalSteps;

  const OnboardingProfileSetup({
    super.key,
    this.currentStep = 1,
    this.totalSteps = 3,
  });

  @override
  State<OnboardingProfileSetup> createState() =>
      _OnboardingProfileSetupState();
}

class _OnboardingProfileSetupState extends State<OnboardingProfileSetup> {
  // ================= COLORS =================

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color skyBlue = Color(0xFF29B6D8);
  static const Color mustard = Color(0xFFF4C10F);
  static const Color trackGrey = Color(0xFFE9EDF0);
  static const Color mastGreen = Color(0xFF33B679);

  static const List<GradeOption> _grades = [
    GradeOption(number: '9', label: 'Freshman'),
    GradeOption(number: '10', label: 'Sophomore'),
    GradeOption(number: '11', label: 'Junior'),
    GradeOption(number: '12', label: 'Senior'),
  ];

  static const List<InterestOption> _interests = [
    InterestOption(icon: Icons.functions, label: 'Mathematics'),
    InterestOption(icon: Icons.rocket_launch, label: 'Space'),
    InterestOption(icon: Icons.terminal, label: 'Coding'),
    InterestOption(icon: Icons.biotech, label: 'Biology'),
    InterestOption(icon: Icons.account_balance, label: 'History'),
    InterestOption(icon: Icons.palette, label: 'Art'),
  ];

  int? _selectedGradeIndex = 1; // "10" pre-selected in the design
  final Set<int> _selectedInterests = {0, 2}; // Mathematics + Coding

  final TextEditingController _dreamJobController = TextEditingController();

  @override
  void dispose() {
    _dreamJobController.dispose();
    super.dispose();
  }

  void _createMyUniverse() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OnboardingAiProcessing(),
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
            // ================= TOP BAR =================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: LinearProgressIndicator(
                        value: widget.currentStep / widget.totalSteps,
                        minHeight: 6,
                        backgroundColor: trackGrey,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(mastGreen),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: trackGrey,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: navy, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= MASCOT =================
                    // NOTE: swap this placeholder for your own mascot
                    // illustration/asset — kept generic here.
                    Center(
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: mustard.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.smart_toy_rounded,
                            color: navy, size: 72),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= TITLE =================
                    const Text(
                      'Welcome to EduVerse!',
                      style: TextStyle(
                        color: navy,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Your AI mentor is ready to help you grow. Let's "
                      "set up your profile!",
                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ================= GRADE PICKER =================
                    const Text(
                      'What grade are you in?',
                      style: TextStyle(
                        color: navy,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 14),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _grades.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 1.5,
                      ),
                      itemBuilder: (context, index) {
                        final grade = _grades[index];
                        final selected = _selectedGradeIndex == index;
                        return _GradeCard(
                          grade: grade,
                          selected: selected,
                          onTap: () =>
                              setState(() => _selectedGradeIndex = index),
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    // ================= INTERESTS =================
                    const Text(
                      'What do you love?',
                      style: TextStyle(
                        color: navy,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 14),

                    ...List.generate(_interests.length, (index) {
                      final interest = _interests[index];
                      final selected = _selectedInterests.contains(index);
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == _interests.length - 1 ? 0 : 12,
                        ),
                        child: _InterestTile(
                          interest: interest,
                          selected: selected,
                          onTap: () {
                            setState(() {
                              if (selected) {
                                _selectedInterests.remove(index);
                              } else {
                                _selectedInterests.add(index);
                              }
                            });
                          },
                        ),
                      );
                    }),

                    const SizedBox(height: 28),

                    // ================= CAREER GOAL =================
                    const Text(
                      'Future Career Goal',
                      style: TextStyle(
                        color: navy,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Dream Job',
                      style: TextStyle(
                        color: navy,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _dreamJobController,
                      style: const TextStyle(color: navy, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'e.g. Aerospace Engineer',
                        hintStyle: const TextStyle(color: subtitleBlue),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('🚀', style: TextStyle(fontSize: 18)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: navy, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: navy, width: 1.6),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ================= CTA =================
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: _createMyUniverse,
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
                              'Create My Universe',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded,
                                color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Center(
                      child: Text(
                        'Step ${widget.currentStep} of ${widget.totalSteps}',
                        style: const TextStyle(
                          color: subtitleBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
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
// GRADE CARD
// ============================================================

class _GradeCard extends StatelessWidget {
  final GradeOption grade;
  final bool selected;
  final VoidCallback onTap;

  const _GradeCard({
    required this.grade,
    required this.selected,
    required this.onTap,
  });

  static const Color navy = Color(0xFF14213D);
  static const Color skyBlue = Color(0xFF29B6D8);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color trackGrey = Color(0xFFE9EDF0);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? skyBlue : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? brandRed : trackGrey,
            width: selected ? 2 : 1.2,
          ),
          boxShadow: [
            if (!selected)
              const BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              grade.number,
              style: TextStyle(
                color: selected ? Colors.white : navy,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              grade.label,
              style: TextStyle(
                color: selected ? Colors.white : navy,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// INTEREST TILE
// ============================================================

class _InterestTile extends StatelessWidget {
  final InterestOption interest;
  final bool selected;
  final VoidCallback onTap;

  const _InterestTile({
    required this.interest,
    required this.selected,
    required this.onTap,
  });

  static const Color navy = Color(0xFF14213D);
  static const Color mustard = Color(0xFFF4C10F);
  static const Color trackGrey = Color(0xFFE9EDF0);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? mustard : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: selected ? mustard : trackGrey,
            width: 1.4,
          ),
        ),
        child: Row(
          children: [
            Icon(interest.icon, color: navy, size: 20),
            const SizedBox(width: 12),
            Text(
              interest.label,
              style: const TextStyle(
                color: navy,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}