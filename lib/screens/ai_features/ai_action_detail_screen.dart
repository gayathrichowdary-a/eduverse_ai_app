import 'package:flutter/material.dart';

/// Reusable screen for all AI Scanner actions.
/// Pass a different title/icon/content for each action — content-agnostic,
/// so it works for any subject (currently fed DSA content from the scanner).
class AiActionDetailScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final String placeholderContent;

  const AiActionDetailScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.placeholderContent,
  });

  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color lightBg = Color(0xFFF7F9FB);

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
        title: Text(title, style: const TextStyle(color: navy, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFDE8E9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: brandRed, size: 28),
            ),
            const SizedBox(height: 20),
            Text(title,
                style: const TextStyle(color: navy, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: lightBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                placeholderContent,
                style: const TextStyle(color: subtitleBlue, fontSize: 15, height: 1.5),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandRed,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("Back to Scan",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}