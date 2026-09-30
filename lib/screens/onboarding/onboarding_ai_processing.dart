import 'package:flutter/material.dart';
import 'onboarding_initial_ai_assessment.dart';

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

class OnboardingAiProcessing extends StatefulWidget {
  final String engineLabel;
  final String headline;
  final String subtitle;
  final Duration processingDuration;
  final List<ProcessingTag> tags;

  const OnboardingAiProcessing({
    super.key,
    this.engineLabel = 'EduVerse AI Engine v2.0',
    this.headline = 'Analyzing your learning profile...',
    this.subtitle = 'Sophia is crafting your personalized roadmap',
    this.processingDuration = const Duration(seconds: 3),
    this.tags = const [
      ProcessingTag(
        icon: Icons.psychology_outlined,
        color: Color(0xFF1D3B64),
        label: 'Cognitive Patterns & Pace',
      ),
      ProcessingTag(
        icon: Icons.auto_awesome,
        color: Color(0xFFEF3340),
        label: 'Foundational Knowledge Gaps',
      ),
      ProcessingTag(
        icon: Icons.school_outlined,
        color: Color(0xFF12B76A),
        label: 'Board Syllabus Alignment',
      ),
    ],
  });

  @override
  State<OnboardingAiProcessing> createState() =>
      _OnboardingAiProcessingState();
}

class _OnboardingAiProcessingState extends State<OnboardingAiProcessing>
    with SingleTickerProviderStateMixin {
  // Sir's Brand Colors
  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color brandGradientEnd = Color(0xFFF12C68);
  static const Color textMuted = Color(0xFF667085);
  static const Color cardBorder = Color(0xFFE4E7EC);

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
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF7F8),
              Color(0xFFF9FAFB),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),

              // AI Glow Orb & Pulsing Dots
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF0F2),
                  boxShadow: [
                    BoxShadow(
                      color: brandRed.withOpacity(0.18),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Center(
                  child: _PulsingDots(),
                ),
              ),

              const Spacer(flex: 2),

              // Title and Engine Badge
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFECDCA)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome,
                              color: brandRed, size: 13),
                          const SizedBox(width: 5),
                          Text(
                            widget.engineLabel,
                            style: const TextStyle(
                              color: brandRed,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      widget.headline,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Progress Bar
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _controller.value,
                            minHeight: 6,
                            backgroundColor: const Color(0xFFF2F4F7),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                brandRed),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Tag Pills
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: widget.tags
                      .map(
                        (tag) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _TagPill(tag: tag),
                        ),
                      )
                      .toList(),
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const List<Color> _dotColors = [
    Color(0xFFEF3340),
    Color(0xFF1D3B64),
    Color(0xFFF12C68),
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
            final delay = i * 0.25;
            final t = (_controller.value - delay).clamp(0.0, 1.0);
            final scale =
                0.6 + 0.4 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 9,
                  height: 9,
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

class _TagPill extends StatelessWidget {
  final ProcessingTag tag;

  const _TagPill({required this.tag});

  static const Color navy = Color(0xFF1D3B64);
  static const Color cardBorder = Color(0xFFE4E7EC);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: tag.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(tag.icon, color: tag.color, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            tag.label,
            style: const TextStyle(
              color: navy,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}