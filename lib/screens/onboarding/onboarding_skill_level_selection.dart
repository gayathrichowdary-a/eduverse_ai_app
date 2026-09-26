import 'package:flutter/material.dart';
import 'onboarding_device_authorization.dart';
import '../learning/student_dashboard.dart';

// ============================================================
// MODEL
// ============================================================

class SkillLevelOption {
  final String code; // 'beginner' | 'intermediate' | 'advanced'
  final String name;
  final String subtitle;
  final IconData icon;
  bool selected;

  SkillLevelOption({
    required this.code,
    required this.name,
    required this.subtitle,
    required this.icon,
    this.selected = false,
  });
}

// ============================================================
// SCREEN
// ============================================================

/// Asks the student to self-rate their skill level for the course they
/// just selected.
///
/// Per the spec:
/// - Beginner  -> skips the Sophia assessment entirely, goes straight to
///                the Home Hub with a beginner-tier gamified roadmap.
/// - Intermediate / Advanced -> proceeds into the assessment flow,
///                starting with device authorization (webcam/mic/screen).
class OnboardingSkillLevelSelection extends StatefulWidget {
  // Forwarded from board/class/subject selection so it can keep
  // travelling down the onboarding chain (device auth -> assessment ->
  // assessment complete) instead of getting dropped, per the
  // "screens don't pass data forward" gap.
  final String? branch;
  final String? course;

  const OnboardingSkillLevelSelection({
    super.key,
    this.branch,
    this.course,
  });

  @override
  State<OnboardingSkillLevelSelection> createState() =>
      _OnboardingSkillLevelSelectionState();
}

class _OnboardingSkillLevelSelectionState
    extends State<OnboardingSkillLevelSelection> {
  // ================= COLORS =================

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color cardSelectedBg = Color(0xFFF6E3E4);
  static const Color infoBg = Color(0xFFE7E9FB);
  static const Color infoText = Color(0xFF5B6B8C);

  final List<SkillLevelOption> _levels = [
    SkillLevelOption(
      code: 'beginner',
      name: 'Beginner',
      subtitle: "New to this course? Start from the fundamentals — "
          "no assessment needed.",
      icon: Icons.eco_rounded,
    ),
    SkillLevelOption(
      code: 'intermediate',
      name: 'Intermediate',
      subtitle: "Know the basics? Take a quick Sophia assessment to "
          "confirm your level.",
      icon: Icons.trending_up_rounded,
      selected: true, // sensible default
    ),
    SkillLevelOption(
      code: 'advanced',
      name: 'Advanced',
      subtitle: "Confident already? Prove it to Sophia and unlock "
          "advanced content.",
      icon: Icons.military_tech_rounded,
    ),
  ];

  void _selectLevel(SkillLevelOption level) {
    setState(() {
      for (final l in _levels) {
        l.selected = identical(l, level);
      }
    });
  }

  SkillLevelOption get _selected =>
      _levels.firstWhere((l) => l.selected, orElse: () => _levels.first);

  void _continue() {
    final level = _selected;

    if (level.code == 'beginner') {
      // Skip the assessment entirely -> straight to Home Hub with the
      // beginner-tier gamified roadmap.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const StudentDashboard(),
        ),
        (route) => false,
      );
      return;
    }

    // Intermediate / Advanced -> device authorization, then the
    // Sophia assessment. Skill level + branch/course keep travelling
    // forward instead of being dropped.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OnboardingDeviceAuthorization(
          skillLevel: level.name,
          branch: widget.branch,
          course: widget.course,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBeginner = _selected.code == 'beginner';

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
                      "What's Your Skill Level?",
                      style: TextStyle(
                        color: navy,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      widget.course != null
                          ? "Tell us where you stand with ${widget.course} "
                              "so Sophia can personalize your roadmap."
                          : "Tell Sophia where you stand so she can "
                              "personalize your roadmap.",
                      style: const TextStyle(
                        color: subtitleBlue,
                        fontSize: 16,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= LEVEL LIST =================

                    ...List.generate(_levels.length, (index) {
                      final level = _levels[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == _levels.length - 1 ? 0 : 16,
                        ),
                        child: _SkillLevelCard(
                          level: level,
                          onTap: () => _selectLevel(level),
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
                          Expanded(
                            child: Text(
                              isBeginner
                                  ? "Beginner skips the assessment — you'll "
                                      "land straight on your Home Hub."
                                  : "Sophia will use your webcam, mic, and "
                                      "screen to run a short live assessment.",
                              style: const TextStyle(
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
              child: SizedBox(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isBeginner
                            ? 'Go to Home Dashboard'
                            : 'Continue to Assessment',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_forward,
                          color: Colors.white, size: 20),
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

// ============================================================
// LEVEL CARD
// ============================================================

class _SkillLevelCard extends StatelessWidget {
  final SkillLevelOption level;
  final VoidCallback onTap;

  const _SkillLevelCard({required this.level, required this.onTap});

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
          color: level.selected ? cardSelectedBg : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: level.selected ? brandRed : const Color(0xFFE2E8ED),
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
              child: Icon(level.icon, color: Colors.white, size: 26),
            ),

            const SizedBox(width: 14),

            // ================= TEXT =================

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    level.name,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    level.subtitle,
                    style: const TextStyle(
                      color: subtitleBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
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
                color: level.selected ? brandRed : Colors.transparent,
                shape: BoxShape.circle,
                border: level.selected
                    ? null
                    : Border.all(color: const Color(0xFFE2E8ED)),
              ),
              child: level.selected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}