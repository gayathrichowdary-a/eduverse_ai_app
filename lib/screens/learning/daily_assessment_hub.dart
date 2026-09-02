import 'dart:math' as math;
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'ai_assessment.dart';
import 'adaptive_practice_screen.dart';

// ============================================================
// MODELS (Restored)
// ============================================================

class HubStatCard {
  final String label;
  final String value;
  const HubStatCard({required this.label, required this.value});
}

class HubGoalItem {
  final String title;
  final String time;
  final bool completed;
  final VoidCallback? onTap;

  const HubGoalItem({
    required this.title,
    required this.time,
    this.completed = false,
    this.onTap,
  });
}

class HubRecommendation {
  final String title;
  final String description;
  final Color badgeColor;
  final IconData icon;
  final VoidCallback? onTap;

  const HubRecommendation({
    required this.title,
    required this.description,
    required this.badgeColor,
    required this.icon,
    this.onTap,
  });
}

enum RadarMode { logic, memory }

// ============================================================
// SCREEN
// ============================================================

class DailyAssessmentHub extends StatefulWidget {
  final String studentName;
  final HubStatCard mastery;
  final HubStatCard streak;
  final HubStatCard rank;
  final List<double> logicValues;
  final List<double> memoryValues;
  final String strengths;
  final String focusArea;
  final List<HubGoalItem> goals;
  final List<HubRecommendation> recommendations;
  final VoidCallback? onStartLearning;
  final VoidCallback? onViewWeekly;

  const DailyAssessmentHub({
    Key? key,
    this.studentName = 'Akhil',
    this.mastery = const HubStatCard(label: 'Mastery', value: '82%'),
    this.streak = const HubStatCard(label: 'Streak', value: '12 Days'),
    this.rank = const HubStatCard(label: 'Rank', value: '#7'),
    this.logicValues = const [0.8, 0.65, 0.7, 0.55, 0.75],
    this.memoryValues = const [0.5, 0.6, 0.45, 0.7, 0.4],
    this.strengths = 'Quantitative, Physics',
    this.focusArea = 'Verbal Ability, Bio',
    this.goals = const [
      HubGoalItem(title: 'Complete Calculus Module 3', time: '45 mins', completed: true),
      HubGoalItem(title: 'Practice 20 Chemistry MCQs', time: '30 mins', completed: false),
      HubGoalItem(title: 'Review AI Career Roadmap', time: '10 mins', completed: false),
    ],
    this.recommendations = const [
      HubRecommendation(
        title: 'Misconception Alert',
        description: "You're struggling with 'Thermodynamics'. Try our visual simulator.",
        badgeColor: Color(0xFFF4C10F),
        icon: Icons.lightbulb_rounded,
      ),
      HubRecommendation(
        title: 'Exam Readiness',
        description: 'JEE Mock Test #4 is live. Based on your pace, take it tonight.',
        badgeColor: Color(0xFF5B5FE0),
        icon: Icons.fact_check_rounded,
      ),
    ],
    this.onStartLearning,
    this.onViewWeekly,
  }) : super(key: key);

  @override
  State<DailyAssessmentHub> createState() => _DailyAssessmentHubState();
}

class _DailyAssessmentHubState extends State<DailyAssessmentHub> {
  // COLORS
  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color memoryBlue = Color(0xFF29B6D8);
  static const Color trackGrey = Color(0xFFE9EDF0);

  RadarMode _mode = RadarMode.logic;

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon!'), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeValues = _mode == RadarMode.logic ? widget.logicValues : widget.memoryValues;
    final activeColor = _mode == RadarMode.logic ? brandRed : memoryBlue;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER SECTION
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: brandRed,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello ${widget.studentName},', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                    const Text('Welcome to EduVerse AI', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _HeaderStatCard(stat: widget.mastery)),
                        const SizedBox(width: 10),
                        Expanded(child: _HeaderStatCard(stat: widget.streak)),
                        const SizedBox(width: 10),
                        Expanded(child: _HeaderStatCard(stat: widget.rank)),
                      ],
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // RADAR CHART CARD (FIXED)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: trackGrey),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                      ),
                      child: Column(
                        children: [
                          const Text('Skill Mastery Radar', style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 220,
                            width: double.infinity,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return CustomPaint(
                                  size: Size(constraints.maxWidth, constraints.maxHeight),
                                  painter: _RadarChartPainter(values: activeValues, color: activeColor),
                                );
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _RadarTogglePill(label: 'Logic', color: brandRed, selected: _mode == RadarMode.logic, onTap: () => setState(() => _mode = RadarMode.logic)),
                              const SizedBox(width: 10),
                              _RadarTogglePill(label: 'Memory', color: memoryBlue, selected: _mode == RadarMode.memory, onTap: () => setState(() => _mode = RadarMode.memory)),
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    // STRENGTHS & FOCUS
                    Row(
                      children: [
                        Expanded(child: _InfoPill(title: 'Strengths', subtitle: widget.strengths, color: Colors.green.shade50)),
                        const SizedBox(width: 10),
                        Expanded(child: _InfoPill(title: 'Focus Area', subtitle: widget.focusArea, color: Colors.orange.shade50)),
                      ],
                    ),

                    const SizedBox(height: 20),
                    // GOALS
                    const Align(alignment: Alignment.centerLeft, child: Text("Today's Goals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    ...widget.goals.map((g) => _HubGoalTile(goal: g)),

                    const SizedBox(height: 20),
                    // RECOMMENDATIONS
                    const Align(alignment: Alignment.centerLeft, child: Text("AI Recommendations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    ...widget.recommendations.map((r) => _RecommendationCard(rec: r)),

                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: brandRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdaptivePracticeScreen())),
                        child: const Text("Start Learning Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SUPPORTING WIDGETS (Restored & Fixed)
// ============================================================

class _HeaderStatCard extends StatelessWidget {
  final HubStatCard stat;
  const _HeaderStatCard({required this.stat});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Text(stat.value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF14213D))),
          Text(stat.label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _RadarTogglePill extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  const _RadarTogglePill({required this.label, required this.color, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(color: selected ? color : Colors.transparent, borderRadius: BorderRadius.circular(20), border: Border.all(color: color)),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : color, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  const _InfoPill({required this.title, required this.subtitle, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _HubGoalTile extends StatelessWidget {
  final HubGoalItem goal;
  const _HubGoalTile({required this.goal});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(goal.completed ? Icons.check_circle : Icons.circle_outlined, color: goal.completed ? Colors.green : Colors.grey),
        title: Text(goal.title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(goal.time),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final HubRecommendation rec;
  const _RecommendationCard({required this.rec});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Icon(rec.icon, color: rec.badgeColor, size: 30),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(rec.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(rec.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ]))
        ],
      ),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final List<double> values;
  final Color color;
  _RadarChartPainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.8;
    
    // Background rings
    final bgPaint = Paint()..color = Colors.grey.withOpacity(0.1)..style = PaintingStyle.stroke;
    for (var i = 1; i <= 3; i++) canvas.drawCircle(center, radius * (i / 3), bgPaint);

    // Data Shape
    final paint = Paint()..color = color.withOpacity(0.4)..style = PaintingStyle.fill;
    final strokePaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2;
    
    final path = Path();
    for (var i = 0; i < 5; i++) {
      double angle = (i * 2 * math.pi / 5) - (math.pi / 2);
      double val = i < values.length ? values[i] : 0;
      double x = center.dx + radius * val * math.cos(angle);
      double y = center.dy + radius * val * math.sin(angle);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) => !listEquals(oldDelegate.values, values) || oldDelegate.color != color;
}