import 'package:flutter/material.dart';

// ---------------------------------------------------------------
// Shared design tokens for this screen (inlined — no shared theme
// file). Kept identical across all 5 admin screens so they stay
// visually consistent even without a common import.
// ---------------------------------------------------------------
class AppColors {
  static const Color primary = Color(0xFF4F46E5); // Indigo
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color background = Color(0xFFF7F8FC);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);
  static const Color easy = Color(0xFF16A34A);
  static const Color medium = Color(0xFFD97706);
  static const Color hard = Color(0xFFDC2626);
}

class AppTextStyles {
  static const TextStyle screenTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle cardValue = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );
  static const TextStyle cardLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}

/// Reusable card container so this screen's sections share the
/// same corner radius / shadow / padding treatment.
class AdminCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AdminCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Small colored status/label pill used across list rows.
class StatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const StatusPill({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Standard admin app bar so this screen's title bar matches the
/// rest of the admin module.
PreferredSizeWidget adminAppBar(String title, {List<Widget>? actions}) {
  return AppBar(
    title: Text(title, style: AppTextStyles.screenTitle),
    backgroundColor: AppColors.background,
    elevation: 0,
    foregroundColor: AppColors.textPrimary,
    actions: actions,
  );
}

/// Admin > Global Analytics
///
/// Top-level dashboard showing platform-wide numbers: universities,
/// students, revenue, active users, system health, plus simple
/// revenue/growth/distribution charts.
class GlobalAnalyticsScreen extends StatelessWidget {
  const GlobalAnalyticsScreen({super.key});

  // ---- Dummy data (wire up to real API later) ----
  static const int universityCount = 42;
  static const int studentCount = 18540;
  static const double monthlyRevenue = 1245000; // ₹12,45,000
  static const int activeUsers = 9321;
  static const double systemHealthPct = 0.98;

  static const List<double> revenueTrend = [
    6.2, 7.1, 6.8, 8.4, 9.0, 8.7, 10.2, 11.0, 10.4, 11.8, 12.1, 12.45,
  ]; // in lakhs, last 12 months

  static const List<double> userGrowthTrend = [
    9.2, 10.1, 10.9, 11.8, 12.6, 13.4, 14.5, 15.6, 16.4, 17.2, 17.9, 18.54,
  ]; // in thousands

  static const List<_DistributionSlice> universityDistribution = [
    _DistributionSlice('North Zone', 14, AppColors.primary),
    _DistributionSlice('South Zone', 12, Color(0xFF06B6D4)),
    _DistributionSlice('West Zone', 9, Color(0xFFF59E0B)),
    _DistributionSlice('East Zone', 7, Color(0xFFEC4899)),
  ];

  static String _formatINR(double value) {
    // Simple Indian numbering (lakh/crore) formatter for display.
    final intVal = value.round();
    final s = intVal.toString();
    if (s.length <= 3) return s;
    final last3 = s.substring(s.length - 3);
    var rest = s.substring(0, s.length - 3);
    final buffer = StringBuffer();
    while (rest.length > 2) {
      buffer.write(',${rest.substring(rest.length - 2)}');
      rest = rest.substring(0, rest.length - 2);
    }
    buffer.write(rest);
    final grouped = buffer.toString().split('').reversed.join();
    return '$grouped,$last3';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: adminAppBar('Global Analytics', actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh',
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ]),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Universities / Students
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.account_balance_outlined,
                    label: 'Universities',
                    value: universityCount.toString(),
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.groups_outlined,
                    label: 'Students',
                    value: studentCount.toString(),
                    color: const Color(0xFF06B6D4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Monthly Revenue
            AdminCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Monthly Revenue', style: AppTextStyles.cardLabel),
                  const SizedBox(height: 6),
                  Text(
                    '₹ ${_formatINR(monthlyRevenue)}',
                    style: AppTextStyles.cardValue.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.trending_up,
                          size: 16, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text('+12.4% vs last month',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.success)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Active Users / System Health
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.bolt_outlined,
                    label: 'Active Users',
                    value: activeUsers.toString(),
                    color: const Color(0xFFF59E0B),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AdminCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.favorite_outline,
                                size: 18, color: AppColors.success),
                            const SizedBox(width: 6),
                            Text('System Health',
                                style: AppTextStyles.cardLabel),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('${(systemHealthPct * 100).toStringAsFixed(0)}%',
                            style: AppTextStyles.cardValue),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: systemHealthPct,
                            minHeight: 6,
                            backgroundColor: AppColors.border,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Revenue Chart
            _ChartCard(
              title: 'Revenue Chart',
              subtitle: 'Last 12 months (₹ lakhs)',
              child: _BarTrendChart(
                values: revenueTrend,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            // User Growth Chart
            _ChartCard(
              title: 'User Growth Chart',
              subtitle: 'Last 12 months (thousands)',
              child: _LineTrendChart(
                values: userGrowthTrend,
                color: const Color(0xFF06B6D4),
              ),
            ),
            const SizedBox(height: 16),

            // University Distribution
            _ChartCard(
              title: 'University Distribution',
              subtitle: 'By zone',
              child: _DistributionBars(slices: universityDistribution),
            ),
          ],
        ),
      ),
    );
  }
}

class _DistributionSlice {
  final String label;
  final int count;
  final Color color;
  const _DistributionSlice(this.label, this.count, this.color);
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(value, style: AppTextStyles.cardValue),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.cardLabel),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          Text(subtitle, style: AppTextStyles.caption),
          const SizedBox(height: 16),
          SizedBox(height: 140, child: child),
        ],
      ),
    );
  }
}

/// Minimal bar chart drawn with CustomPaint — no external chart
/// package dependency required.
class _BarTrendChart extends StatelessWidget {
  final List<double> values;
  final Color color;

  const _BarTrendChart({required this.values, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _BarPainter(values: values, color: color),
    );
  }
}

class _BarPainter extends CustomPainter {
  final List<double> values;
  final Color color;
  _BarPainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final barWidth = size.width / (values.length * 1.6);
    final gap = barWidth * 0.6;
    final paint = Paint()..color = color;

    for (var i = 0; i < values.length; i++) {
      final barHeight = (values[i] / maxVal) * (size.height - 4);
      final left = i * (barWidth + gap);
      final rect = Rect.fromLTWH(
        left,
        size.height - barHeight,
        barWidth,
        barHeight,
      );
      final rrect = RRect.fromRectAndCorners(
        rect,
        topLeft: const Radius.circular(3),
        topRight: const Radius.circular(3),
      );
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}

/// Minimal line chart drawn with CustomPaint.
class _LineTrendChart extends StatelessWidget {
  final List<double> values;
  final Color color;

  const _LineTrendChart({required this.values, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _LinePainter(values: values, color: color),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<double> values;
  final Color color;
  _LinePainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final range = (maxVal - minVal) == 0 ? 1 : (maxVal - minVal);
    final stepX = size.width / (values.length - 1);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.12)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    for (var i = 0; i < values.length; i++) {
      final x = i * stepX;
      final normalized = (values[i] - minVal) / range;
      final y = size.height - (normalized * (size.height - 8)) - 4;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // End point dot
    final lastNormalized = (values.last - minVal) / range;
    final lastY = size.height - (lastNormalized * (size.height - 8)) - 4;
    canvas.drawCircle(
      Offset(size.width, lastY),
      4,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}

/// Horizontal distribution bars (university count by zone).
class _DistributionBars extends StatelessWidget {
  final List<_DistributionSlice> slices;

  const _DistributionBars({required this.slices});

  @override
  Widget build(BuildContext context) {
    final total = slices.fold<int>(0, (sum, s) => sum + s.count);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: slices.map((s) {
        final fraction = total == 0 ? 0.0 : s.count / total;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(s.label, style: AppTextStyles.caption),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 10,
                    backgroundColor: AppColors.border,
                    color: s.color,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 24,
                child: Text('${s.count}',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}