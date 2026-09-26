import 'package:flutter/material.dart';
import 'skills_marketplace.dart';
import 'mentors_list.dart';

class SkillGapAnalysis extends StatelessWidget {
  const SkillGapAnalysis({super.key});

  // ============================================================
  // COLORS
  // ============================================================

  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color insightBlueBg = Color(0xFFEAF8FB);

  static const Color softSkillsColor = Color(0xFF52B68C);
  static const Color mathColor = Color(0xFFE8394A);
  static const Color codingColor = Color(0xFF4FC3F7);
  static const Color creativityColor = Color(0xFFFFC107);
  static const Color careerRequirementColor = Color(0xFFDDE6ED);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: navy,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Skill Gap Analysis',
          style: TextStyle(
            color: navy,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            24,
            10,
            24,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // TITLE
              // ==================================================

              const Text(
                'Skill Gap Analysis',
                style: TextStyle(
                  color: navy,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Target: Software Engineer at Google',
                style: TextStyle(
                  color: subtitleBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 35),

              // ==================================================
              // COMPETENCY RADAR HEADER
              // ==================================================

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Competency Radar',
                      style: TextStyle(
                        color: navy,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: brandRed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.compare_arrows_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Current vs Target',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // ==================================================
              // SKILL CHART
              // ==================================================

              _buildSkillChart(),

              const SizedBox(height: 25),

              // ==================================================
              // LEGEND
              // ==================================================

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _LegendItem(
                        color: brandRed,
                        label: 'Student',
                      ),
                      SizedBox(width: 20),
                      _LegendItem(
                        color: careerRequirementColor,
                        label: 'Career Req.',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // ==================================================
              // CRITICAL GAPS
              // ==================================================

              const Text(
                'Critical Gaps Identified',
                style: TextStyle(
                  color: navy,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // ==================================================
              // GAP 1
              // ==================================================

              _buildGapCard(
                icon: Icons.code_rounded,
                title: 'Coding',
                description:
                    'Improve advanced coding and scalable software development skills.',
                color: codingColor,
              ),

              const SizedBox(height: 12),

              // ==================================================
              // GAP 2
              // ==================================================

              _buildGapCard(
                icon: Icons.auto_graph_rounded,
                title: 'Scalability',
                description:
                    'Build more projects that demonstrate scalable system design.',
                color: mathColor,
              ),

              const SizedBox(height: 25),

              // ==================================================
              // AI MENTOR INSIGHT
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: insightBlueBg,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: const Color(0xFFD5EEF4),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: navy,
                        size: 22,
                      ),
                    ),

                    const SizedBox(width: 14),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Mentor Insight',
                            style: TextStyle(
                              color: navy,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            'Your logical reasoning is strong, but you need more projects focusing on scalability to bridge the Coding gap.',
                            style: TextStyle(
                              color: navy,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // GENERATE STUDY PLAN
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SkillsMarketplace(),
                      ),
                    );
                  },

                  icon: const Icon(
                    Icons.auto_fix_high,
                    size: 18,
                    color: Colors.white,
                  ),

                  label: const Text(
                    'Generate Study Plan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // FIND MENTOR
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const MentorsList(),
                      ),
                    );
                  },

                  icon: const Icon(
                    Icons.groups,
                    color: navy,
                  ),

                  label: const Text(
                    'Find Mentors for Coding',
                    style: TextStyle(
                      color: navy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: navy,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SKILL CHART
  // ============================================================

  Widget _buildSkillChart() {
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: CustomPaint(
          painter: SkillChartPainter(),
          child: const SizedBox(
            width: 300,
            height: 300,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // GAP CARD
  // ============================================================

  Widget _buildGapCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: navy,
              size: 23,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: const TextStyle(
                    color: subtitleBlue,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LEGEND ITEM
// ============================================================

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 8),

        Text(
          label,
          style: const TextStyle(
            color: SkillGapAnalysis.subtitleBlue,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// SKILL CHART PAINTER
// ============================================================

class SkillChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.width * 0.30;

    // ========================================================
    // GRID
    // ========================================================

    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFFE1E7ED);

    for (int i = 1; i <= 4; i++) {
      final r = radius * i / 4;

      final path = Path();

      for (int j = 0; j < 4; j++) {
        final angle =
            (-90 + j * 90) * 3.1415926535 / 180;

        final point = Offset(
          center.dx + r * _cos(angle),
          center.dy + r * _sin(angle),
        );

        if (j == 0) {
          path.moveTo(
            point.dx,
            point.dy,
          );
        } else {
          path.lineTo(
            point.dx,
            point.dy,
          );
        }
      }

      path.close();

      canvas.drawPath(
        path,
        gridPaint,
      );
    }

    // ========================================================
    // AXES
    // ========================================================

    final axisPaint = Paint()
      ..color = const Color(0xFFD3DCE5)
      ..strokeWidth = 1.2;

    for (int i = 0; i < 4; i++) {
      final angle =
          (-90 + i * 90) * 3.1415926535 / 180;

      final end = Offset(
        center.dx + radius * _cos(angle),
        center.dy + radius * _sin(angle),
      );

      canvas.drawLine(
        center,
        end,
        axisPaint,
      );
    }

    // ========================================================
    // STUDENT SKILL AREA
    // ========================================================

    final studentPaint = Paint()
      ..color = SkillGapAnalysis.brandRed.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;

    final studentBorder = Paint()
      ..color = SkillGapAnalysis.brandRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final studentValues = [
      0.78, // Math
      0.55, // Coding
      0.82, // Soft Skills
      0.62, // Creativity
    ];

    final studentPath = _createPolygon(
      center,
      radius,
      studentValues,
    );

    canvas.drawPath(
      studentPath,
      studentPaint,
    );

    canvas.drawPath(
      studentPath,
      studentBorder,
    );

    // ========================================================
    // CAREER REQUIREMENT AREA
    // ========================================================

    final careerPaint = Paint()
      ..color = SkillGapAnalysis.careerRequirementColor
          .withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    final careerBorder = Paint()
      ..color = const Color(0xFFB7C4D0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final careerValues = [
      0.85, // Math
      0.90, // Coding
      0.80, // Soft Skills
      0.85, // Creativity
    ];

    final careerPath = _createPolygon(
      center,
      radius,
      careerValues,
    );

    canvas.drawPath(
      careerPath,
      careerPaint,
    );

    canvas.drawPath(
      careerPath,
      careerBorder,
    );

    // ========================================================
    // LABELS
    // ========================================================

    _drawLabel(
      canvas,
      center,
      radius,
      'Math',
      -90,
    );

    _drawLabel(
      canvas,
      center,
      radius,
      'Coding',
      0,
    );

    _drawLabel(
      canvas,
      center,
      radius,
      'Soft Skills',
      90,
    );

    _drawLabel(
      canvas,
      center,
      radius,
      'Creativity',
      180,
    );
  }

  // ============================================================
  // CREATE POLYGON
  // ============================================================

  Path _createPolygon(
    Offset center,
    double radius,
    List<double> values,
  ) {
    final path = Path();

    for (int i = 0; i < values.length; i++) {
      final angle =
          (-90 + i * 90) * 3.1415926535 / 180;

      final r = radius * values[i];

      final point = Offset(
        center.dx + r * _cos(angle),
        center.dy + r * _sin(angle),
      );

      if (i == 0) {
        path.moveTo(
          point.dx,
          point.dy,
        );
      } else {
        path.lineTo(
          point.dx,
          point.dy,
        );
      }
    }

    path.close();

    return path;
  }

  // ============================================================
  // LABEL
  // ============================================================

  void _drawLabel(
    Canvas canvas,
    Offset center,
    double radius,
    String text,
    double angleDegrees,
  ) {
    final angle =
        angleDegrees * 3.1415926535 / 180;

    final labelRadius = radius + 28;

    final offset = Offset(
      center.dx + labelRadius * _cos(angle),
      center.dy + labelRadius * _sin(angle),
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: SkillGapAnalysis.navy,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        offset.dx - textPainter.width / 2,
        offset.dy - textPainter.height / 2,
      ),
    );
  }

  double _cos(double angle) {
    // Avoid importing dart:math just for these calculations.
    // Using the standard trigonometric approximation through
    // dart:math is cleaner, so this method is replaced below.
    return _cosValue(angle);
  }

  double _sin(double angle) {
    return _sinValue(angle);
  }

  double _cosValue(double angle) {
    return _Trig.cos(angle);
  }

  double _sinValue(double angle) {
    return _Trig.sin(angle);
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}

// ============================================================
// SIMPLE TRIG HELPER
// ============================================================

class _Trig {
  static double sin(double x) {
    // Taylor approximation is sufficient for this visual.
    double result = 0;
    double term = x;

    for (int i = 1; i <= 10; i++) {
      result += term;

      term *=
          -x * x / ((2 * i) * (2 * i + 1));
    }

    return result;
  }

  static double cos(double x) {
    return sin(x + 1.57079632679);
  }
}