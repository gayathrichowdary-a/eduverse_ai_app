import 'package:flutter/material.dart';
import 'onboarding_career_dream.dart';

class OnboardingDailyStudyTime extends StatefulWidget {
  const OnboardingDailyStudyTime({super.key});

  @override
  State<OnboardingDailyStudyTime> createState() =>
      _OnboardingDailyStudyTimeState();
}

class _OnboardingDailyStudyTimeState extends State<OnboardingDailyStudyTime> {
  // ================= COLORS =================

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color tipBg = Color(0xFFEAF4FC);
  static const Color tipText = Color(0xFF3B5877);

  // Slider range in minutes: 15 -> 240 ("4h+")
  static const double _minMinutes = 15;
  static const double _maxMinutes = 240;

  double _minutes = 150; // default 2h 30m, matches screenshot

  int get _hours => _minutes ~/ 60;
  int get _mins => (_minutes % 60).round();

  /// Rough "days to mastery" estimate that scales with daily minutes,
  /// purely cosmetic to match the screenshot's dynamic-feeling copy.
  int get _masteryDays {
    final days = (1800 / _minutes).round();
    return days.clamp(3, 60);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ================= EYEBROW =================

              const Text(
                'Daily Study Goal',
                style: TextStyle(
                  color: subtitleBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              // ================= TITLE =================

              const Text(
                'How much time can you\nstudy?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: navy,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),

              const SizedBox(height: 32),

              // ================= ROBOT ILLUSTRATION =================

              const _RobotIllustration(),

              const SizedBox(height: 32),

              // ================= CONSISTENCY TIP =================

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: const Color(0xFFE9EDF0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb, color: navy, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Consistency is better than intensity',
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

              const SizedBox(height: 24),

              // ================= TARGET CARD =================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---- Daily Target label ----
                    const Center(
                      child: Text(
                        'Daily Target',
                        style: TextStyle(
                          color: subtitleBlue,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ---- Big hrs/mins readout ----
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$_hours',
                              style: const TextStyle(
                                color: brandRed,
                                fontSize: 44,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const TextSpan(
                              text: ' hrs ',
                              style: TextStyle(
                                color: brandRed,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: '$_mins',
                              style: const TextStyle(
                                color: brandRed,
                                fontSize: 44,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const TextSpan(
                              text: ' mins',
                              style: TextStyle(
                                color: brandRed,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 26),

                    // ---- Study Duration label ----
                    const Text(
                      'Study Duration',
                      style: TextStyle(
                        color: navy,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // ---- Slider ----
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: brandRed,
                        inactiveTrackColor: const Color(0xFFE2E8ED),
                        thumbColor: Colors.white,
                        overlayColor: brandRed.withOpacity(0.15),
                        trackHeight: 3,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 14,
                          elevation: 3,
                        ),
                      ),
                      child: Slider(
                        min: _minMinutes,
                        max: _maxMinutes,
                        value: _minutes.clamp(_minMinutes, _maxMinutes),
                        onChanged: (value) {
                          setState(() => _minutes = value);
                        },
                      ),
                    ),

                    const SizedBox(height: 4),

                    // ---- Helper text ----
                    const Text(
                      'Adjust your daily commitment',
                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ---- Range labels ----
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '15m',
                          style: TextStyle(
                            color: navy,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '2h',
                          style: TextStyle(
                            color: navy,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '4h+',
                          style: TextStyle(
                            color: navy,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ---- Mastery estimate tip ----
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: tipBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.auto_awesome,
                              color: navy, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "At this pace, you'll master 'Quantum Physics' in $_masteryDays days.",
                              style: const TextStyle(
                                color: tipText,
                                fontSize: 15,
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

              const SizedBox(height: 24),

              // ================= SET STUDY GOAL BUTTON =================

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
                        'Set Study Goal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CONTINUE
  // ============================================================

  void _continue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingCareerDream(),
      ),
    );
  }
}

/// Robot avatar built entirely from widgets/shapes — no image asset
/// required. Two soft overlapping gradient blobs sit behind a rounded
/// icon "face" made of simple containers.
class _RobotIllustration extends StatelessWidget {
  const _RobotIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ---- Peach blob (back, offset left) ----
          Positioned(
            left: 0,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFDE3D8).withOpacity(0.9),
                    const Color(0xFFFDE3D8).withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // ---- Purple/blue blob (front, centered) ----
          Container(
            width: 260,
            height: 260,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFC9CDF7),
            ),
          ),

          // ---- Robot face ----
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // antenna
              Container(
                width: 3,
                height: 18,
                color: const Color(0xFF5B5FE0),
              ),
              // head
              Container(
                width: 120,
                height: 100,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6266E8),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              // body
              Container(
                width: 150,
                height: 130,
                padding: const EdgeInsets.only(top: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF6266E8),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (i) => Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(i == 0 ? 0.9 : 0.4),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}