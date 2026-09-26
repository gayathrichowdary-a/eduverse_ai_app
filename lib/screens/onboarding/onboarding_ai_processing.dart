import 'package:flutter/material.dart';

import 'onboarding_initial_ai_assessment.dart';

// ============================================================
// MODEL
// ============================================================

class ProcessingTag {
  final IconData icon;
  final Color color;
  final String label;

  const ProcessingTag({
    required this.icon,
    required this.color,
    required this.label,
  });
}

// ============================================================
// SCREEN
// ============================================================

class OnboardingAiProcessing extends StatefulWidget {
  final String engineLabel;
  final String headline;
  final String subtitle;
  final Duration processingDuration;
  final List<ProcessingTag> tags;

  const OnboardingAiProcessing({
    super.key,
    this.engineLabel = 'EduVerse AI Engine v2.0',
    this.headline = 'Analyzing your strengths...',
    this.subtitle = 'Building your personalized roadmap...',
    this.processingDuration = const Duration(seconds: 3),
    this.tags = const [
      ProcessingTag(
        icon: Icons.psychology_alt_rounded,
        color: Color(0xFF29B6D8),
        label: 'Cognitive Patterns',
      ),
      ProcessingTag(
        icon: Icons.auto_awesome,
        color: Color(0xFFF4C10F),
        label: 'Skill Gaps',
      ),
      ProcessingTag(
        icon: Icons.school_rounded,
        color: Color(0xFF33B679),
        label: 'Learning Pace',
      ),
    ],
  });

  @override
  State<OnboardingAiProcessing> createState() =>
      _OnboardingAiProcessingState();
}

class _OnboardingAiProcessingState extends State<OnboardingAiProcessing>
    with SingleTickerProviderStateMixin {
  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color trackGrey = Color(0xFFE9EDF0);

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.processingDuration,
    )..forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goToAssessmentIntro();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToAssessmentIntro() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const OnboardingInitialAiAssessment(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE9F6FB),
              Color(0xFFF3EFFB),
              Color(0xFFFBE6EA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 5),

              // ================= LOADING DOTS =================
              const _PulsingDots(),

              const Spacer(flex: 5),

              // ================= LABEL + HEADLINE =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.help_rounded,
                            color: navy, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          widget.engineLabel,
                          style: const TextStyle(
                            color: navy,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.headline,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 18),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: LinearProgressIndicator(
                            value: _controller.value,
                            minHeight: 5,
                            backgroundColor: const Color(0xFFF0DDEF),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF29B6D8)),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    Text(
                      widget.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: subtitleBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 4),

              // ================= TAG PILLS =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: widget.tags
                      .map(
                        (tag) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _TagPill(tag: tag),
                        ),
                      )
                      .toList(),
                ),
              ),

              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PULSING DOTS LOADER
// ============================================================

class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const List<Color> _dotColors = [
    Color(0xFF5B5FE0),
    Color(0xFF33B679),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_dotColors.length, (i) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = i * 0.3;
            final t = (_controller.value - delay).clamp(0.0, 1.0);
            final scale = 0.6 + 0.4 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _dotColors[i],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// ============================================================
// TAG PILL
// ============================================================

class _TagPill extends StatelessWidget {
  final ProcessingTag tag;

  const _TagPill({required this.tag});

  static const Color navy = Color(0xFF14213D);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: BoxDecoration(
        color: tag.color,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: navy, width: 1.4),
      ),
      child: Row(
        children: [
          Icon(tag.icon, color: navy, size: 20),
          const SizedBox(width: 12),
          Text(
            tag.label,
            style: const TextStyle(
              color: navy,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}