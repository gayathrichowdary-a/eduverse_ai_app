import 'package:flutter/material.dart';

class UnderstandingFractionsScreen extends StatelessWidget {
  const UnderstandingFractionsScreen({super.key});

  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color lightBlue = Color(0xFF29B6D8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Mathematics • Chapter 4',
              style: TextStyle(color: subtitleBlue, fontSize: 12),
            ),
            Text(
              'Understanding Fractions',
              style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.receipt_long_outlined, color: subtitleBlue),
              onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.bookmark_border, color: subtitleBlue),
              onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Definition Card ---
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE8E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.architecture, color: brandRed, size: 30),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("What is a Fraction?",
                                  style: TextStyle(
                                      color: navy,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              SizedBox(height: 8),
                              Text(
                                "A fraction represents a part of a whole or, more generally, any number of equal parts.",
                                style: TextStyle(
                                    color: navy, fontSize: 15, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text("Visualizing 3/4",
                      style: TextStyle(
                          color: navy,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  // --- Circular Visualization ---
                  Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade100),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10)
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 140,
                            height: 140,
                            child: CircularProgressIndicator(
                              value: 0.75,
                              strokeWidth: 25,
                              backgroundColor: Colors.grey.shade100,
                              valueColor:
                                  const AlwaysStoppedAnimation(lightBlue),
                            ),
                          ),
                          // REMOVED 'const' from children list because Container is not const
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("3",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: navy)),
                              Container(height: 2, width: 30, color: navy),
                              const Text("4",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: navy)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _pillButton("Numerator (3)", lightBlue, Colors.white),
                      const SizedBox(width: 10),
                      _pillButton("Denominator (4)", Colors.white, navy,
                          hasBorder: true),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "In the diagram above, the circle is divided into 4 equal parts (the denominator). We have selected 3 of those parts (the numerator).",
                    style: TextStyle(color: navy, fontSize: 16, height: 1.5),
                  ),

                  const SizedBox(height: 30),
                  // --- Common Mistake Card ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFF9E6),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        _infoRow(Icons.error_outline, "Common Mistake", brandRed),
                        const SizedBox(height: 10),
                        const Text("Fractions only apply to circles",
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: navy,
                                fontSize: 16)),
                        const SizedBox(height: 15),
                        _infoRow(Icons.check_circle_outline,
                            "Fractions apply to any whole object or set",
                            Colors.green),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Navigation Buttons ---
                  Row(
                    children: [
                      Expanded(
                          child: _navBtn("Previous", Icons.arrow_back,
                              Colors.white, navy,
                              hasBorder: true)),
                      const SizedBox(width: 10),
                      Expanded(
                          child:
                              _navBtn("Practice Now", null, lightBlue, Colors.white)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _navBtn(
                              "Next", Icons.arrow_forward, brandRed, Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // --- Ask AI Mentor Footer ---
          Container(
            width: double.infinity,
            height: 60,
            color: brandRed,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.auto_awesome, color: Colors.white),
              label: const Text("Ask AI Mentor",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _pillButton(String text, Color bg, Color txt, {bool hasBorder = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
        border: hasBorder ? Border.all(color: navy, width: 2) : null,
      ),
      child: Text(text,
          style: TextStyle(color: txt, fontWeight: FontWeight.bold)),
    );
  }

  Widget _infoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _navBtn(String text, IconData? icon, Color bg, Color txt,
      {bool hasBorder = false}) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: hasBorder ? Border.all(color: Colors.grey.shade300) : null,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null && text == "Previous")
              Icon(icon, size: 16, color: txt),
            Text(text,
                style: TextStyle(
                    color: txt, fontWeight: FontWeight.bold, fontSize: 12)),
            if (icon != null && text == "Next") Icon(icon, size: 16, color: txt),
          ],
        ),
      ),
    );
  }
}