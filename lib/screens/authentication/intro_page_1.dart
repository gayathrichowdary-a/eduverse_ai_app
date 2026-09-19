import 'package:flutter/material.dart';
import 'intro_page_2.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  static const Color brandRed = Color(0xFFEF4444);
  static const Color navy = Color(0xFF16214A);
  static const Color subtitleBlue = Color(0xFF5B7A9D);
  static const Color pinkBlobLight = Color(0xFFFDEDEC);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      // TOP BAR
                      _buildTopBar(),

                      SizedBox(height: isSmallScreen ? 12 : 20),

                      // ILLUSTRATION SECTION
                      SizedBox(
                        height: isSmallScreen ? 200 : 250,
                        child: _buildIllustrationSection(),
                      ),

                      SizedBox(height: isSmallScreen ? 12 : 20),

                      // TITLE
                      Text(
                        'Personalized Learning',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: navy,
                          fontSize: isSmallScreen ? 28 : 34,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // SUBTITLE
                      const Text(
                        'Every lesson adapts to your learning speed,\n'
                        'strengths, and areas for improvement.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: subtitleBlue,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),

                      const Spacer(),

                      // NEXT BUTTON
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 150,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const IntroPage2(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: brandRed,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Next',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // TOP BAR
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'EduVerse AI',
          style: TextStyle(
            color: brandRed,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            Container(
              width: 36,
              height: 8,
              decoration: BoxDecoration(
                color: brandRed,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 6),
            _buildDot(),
            const SizedBox(width: 6),
            _buildDot(),
          ],
        ),
      ],
    );
  }

  Widget _buildDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFFE5E7EB),
        shape: BoxShape.circle,
      ),
    );
  }

  // ILLUSTRATION SECTION
  Widget _buildIllustrationSection() {
    return Center(
      child: Container(
        width: 280,
        height: 220,
        decoration: BoxDecoration(
          color: pinkBlobLight,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: SizedBox(
            width: 260,
            height: 180,
            child: CustomPaint(
              painter: _StudentRobotPainter(),
            ),
          ),
        ),
      ),
    );
  }
}

// CUSTOM ILLUSTRATION
class _StudentRobotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Paint navyPaint = Paint()..color = const Color(0xFF16214A);
    final Paint skinPaint = Paint()..color = const Color(0xFFC7CCF0);
    final Paint redPaint = Paint()..color = const Color(0xFFEF4444);
    final Paint outlinePaint = Paint()
      ..color = const Color(0xFFC7CCF0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // BOY HEAD
    final Offset headCenter = Offset(w * 0.32, h * 0.30);
    canvas.drawCircle(headCenter, w * 0.11, skinPaint);

    // HAIR
    final Path hairPath = Path()
      ..moveTo(headCenter.dx - w * 0.11, headCenter.dy)
      ..quadraticBezierTo(headCenter.dx, headCenter.dy - h * 0.18, headCenter.dx + w * 0.11, headCenter.dy)
      ..lineTo(headCenter.dx + w * 0.08, headCenter.dy - h * 0.12)
      ..quadraticBezierTo(headCenter.dx, headCenter.dy - h * 0.20, headCenter.dx - w * 0.10, headCenter.dy - h * 0.10)
      ..close();
    canvas.drawPath(hairPath, navyPaint);

    // FACE EYES
    canvas.drawCircle(Offset(headCenter.dx - 6, headCenter.dy + 3), 2, navyPaint);
    canvas.drawCircle(Offset(headCenter.dx + 6, headCenter.dy + 3), 2, navyPaint);

    // RED SHIRT
    final Path shirtPath = Path()
      ..moveTo(w * 0.10, h * 0.65)
      ..quadraticBezierTo(w * 0.15, h * 0.40, w * 0.32, h * 0.40)
      ..quadraticBezierTo(w * 0.48, h * 0.40, w * 0.54, h * 0.65)
      ..close();
    canvas.drawPath(shirtPath, redPaint);

    // HANDS
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.20, h * 0.57, w * 0.18, h * 0.10),
        const Radius.circular(10),
      ),
      skinPaint,
    );

    // LAPTOP
    final Path laptopPath = Path()
      ..moveTo(w * 0.18, h * 0.68)
      ..lineTo(w * 0.24, h * 0.46)
      ..lineTo(w * 0.50, h * 0.46)
      ..lineTo(w * 0.53, h * 0.68)
      ..close();
    canvas.drawPath(laptopPath, Paint()..color = Colors.white);
    canvas.drawPath(laptopPath, outlinePaint);

    // LAPTOP BASE
    canvas.drawLine(
      Offset(w * 0.14, h * 0.68),
      Offset(w * 0.56, h * 0.68),
      outlinePaint,
    );

    // ROBOT HEAD
    final Offset robotHead = Offset(w * 0.72, h * 0.25);
    final RRect robotHeadRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: robotHead, width: w * 0.24, height: h * 0.20),
      const Radius.circular(16),
    );
    canvas.drawRRect(robotHeadRect, Paint()..color = const Color(0xFFDCE0F7));
    canvas.drawRRect(robotHeadRect, outlinePaint);

    // ROBOT EYES
    final Paint eyePaint = Paint()
      ..color = const Color(0xFF16214A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(robotHead.dx - 10, robotHead.dy), width: 10, height: 10),
      0, 3.14, false, eyePaint,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(robotHead.dx + 10, robotHead.dy), width: 10, height: 10),
      0, 3.14, false, eyePaint,
    );

    // ROBOT BODY
    final Path bodyPath = Path()
      ..moveTo(robotHead.dx - w * 0.09, robotHead.dy + h * 0.10)
      ..quadraticBezierTo(robotHead.dx - w * 0.12, robotHead.dy + h * 0.28, robotHead.dx - w * 0.05, robotHead.dy + h * 0.38)
      ..lineTo(robotHead.dx + w * 0.08, robotHead.dy + h * 0.38)
      ..quadraticBezierTo(robotHead.dx + w * 0.15, robotHead.dy + h * 0.28, robotHead.dx + w * 0.09, robotHead.dy + h * 0.10)
      ..close();
    canvas.drawPath(bodyPath, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}