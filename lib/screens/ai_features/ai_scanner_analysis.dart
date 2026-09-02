import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'ai_action_detail_screen.dart';

/// AI Problem Scanner — part of the LMS Coding module.
/// Lets a student photograph a handwritten DSA problem / pseudocode /
/// algorithm sketch and get it matched against the DSA question bank,
/// with Sophia AI providing the explanation, approach, and hints.
class AiScannerAnalysis extends StatefulWidget {
  const AiScannerAnalysis({super.key});

  @override
  State<AiScannerAnalysis> createState() => _AiScannerAnalysisState();
}

class _AiScannerAnalysisState extends State<AiScannerAnalysis> {
  // Color Palette from existing design
  static const Color brandRed = Color(0xFFE8394A);
  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color lightBlueBg = Color(0xFFE3F2FD);
  static const Color insightBlue = Color(0xFF1E88E5);

  File? _pickedImage;
  bool _isAnalyzing = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _showImageSourceSheet() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: navy),
                title: const Text("Take a Photo", style: TextStyle(color: navy, fontWeight: FontWeight.bold)),
                subtitle: const Text("Snap a handwritten problem or pseudocode", style: TextStyle(color: subtitleBlue, fontSize: 12)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: navy),
                title: const Text("Choose from Gallery", style: TextStyle(color: navy, fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? file = await _picker.pickImage(source: source, imageQuality: 85);
    if (file == null) return;

    setState(() {
      _pickedImage = File(file.path);
      _isAnalyzing = true;
    });

    // Simulated analysis delay — replace with real DSA-matching/AI backend call later.
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isAnalyzing = false);
    }
  }

  void _openAction(String title, IconData icon, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AiActionDetailScreen(
          title: title,
          icon: icon,
          placeholderContent: content,
        ),
      ),
    );
  }

  void _shareResult() {
    const String summary =
        "💻 AI Problem Scanner Result\n\n"
        "Topic: Data Structures & Algorithms\n"
        "Matched Problem: Two Sum (Array • Hashing)\n"
        "Match: 96%\n"
        "Difficulty: Medium • Time Complexity Focus\n\n"
        "Common Misconception: Students often reach for a nested loop (O(n²)) before considering a hashmap (O(n)) pass.\n\n"
        "Scanned via Next Gen LMS";

    if (_pickedImage != null) {
      Share.shareXFiles(
        [XFile(_pickedImage!.path)],
        text: summary,
      );
    } else {
      Share.share(summary);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "AI Problem Scanner",
          style: TextStyle(color: navy, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: navy),
            onPressed: _shareResult,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // --- Image Section (tap to scan) ---
                  _buildImagePreview(),

                  const SizedBox(height: 20),

                  // --- Problem & Title Section ---
                  _buildProblemCard(),

                  const SizedBox(height: 25),

                  const Text(
                    "Sophia AI Insights",
                    style: TextStyle(
                      color: navy,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // --- Insight Alert Card ---
                  _buildInsightCard(),

                  const SizedBox(height: 25),

                  // --- Action Grid (2x2) ---
                  _buildActionGrid(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // --- Footer Button ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => _openAction(
                  "Solution",
                  Icons.check_circle_outline,
                  "Step 1: Identify what's being asked — return indices of two numbers that sum to target.\n"
                  "Step 2: Consider brute force (O(n²)) vs. a single-pass hashmap (O(n)).\n"
                  "Step 3: Iterate once, storing each value's index; check if (target - current) already exists.\n\n"
                  "Full worked solution and sandbox will appear here once connected to the DSA question bank and Sophia AI backend.",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Open in Sandbox",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return GestureDetector(
      onTap: _showImageSourceSheet,
      child: Container(
        height: 280,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: _pickedImage != null
                ? FileImage(_pickedImage!) as ImageProvider
                : const NetworkImage(
                    'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=1000'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 4,
                      backgroundColor: _isAnalyzing ? Colors.orangeAccent : Colors.greenAccent,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isAnalyzing ? "Sophia is analyzing..." : (_pickedImage != null ? "Analysis Ready" : "Tap to Scan a Problem"),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            if (_isAnalyzing)
              const Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            if (_pickedImage == null && !_isAnalyzing)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 40),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Data Structures & Algorithms • Arrays",
            style: TextStyle(color: brandRed, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Two Sum",
                  style: TextStyle(color: navy, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "96% Match",
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _tagItem(Icons.school_outlined, "Intermediate"),
              const SizedBox(width: 8),
              _tagItem(Icons.speed_outlined, "Medium"),
              const SizedBox(width: 8),
              _tagItem(Icons.timer_outlined, "O(n) Optimal"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tagItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: subtitleBlue),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: subtitleBlue, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildInsightCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightBlueBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb, color: insightBlue, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Common Misconception Alert",
                  style: TextStyle(color: insightBlue, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 5),
                Text(
                  "Students often jump to a nested loop (O(n²)) first. A single hashmap pass solves it in O(n) time.",
                  style: TextStyle(color: insightBlue, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.3,
      children: [
        _actionCard(
          Icons.auto_awesome,
          "Explain Concept",
          const Color(0xFFFFEBEE),
          onTap: () => _openAction(
            "Explain Concept",
            Icons.auto_awesome,
            "The Two Sum problem asks you to find two numbers in an array that add up to a target value, and return their indices.\n\n"
            "A hashmap lets you check, for each element, whether its complement (target - element) has already been seen — in a single pass.",
          ),
        ),
        _actionCard(
          Icons.list_alt_rounded,
          "Step-by-Step",
          const Color(0xFFFFF3E0),
          onTap: () => _openAction(
            "Step-by-Step Solution",
            Icons.list_alt_rounded,
            "1. Create an empty hashmap (value → index).\n"
            "2. Loop through the array once.\n"
            "3. For each element, compute complement = target - element.\n"
            "4. If complement exists in the map, return [map[complement], currentIndex].\n"
            "5. Otherwise, store element → currentIndex and continue.",
          ),
        ),
        _actionCard(
          Icons.help_outline_rounded,
          "Get a Hint",
          const Color(0xFFFCE4EC),
          onTap: () => _openAction(
            "Hint",
            Icons.help_outline_rounded,
            "Before coding, ask: do I really need to check every pair? What if I remembered numbers I've already seen instead?",
          ),
        ),
        _actionCard(
          Icons.edit_note_rounded,
          "Practice Similar",
          const Color(0xFFF3E5F5),
          onTap: () => _openAction(
            "Practice Similar",
            Icons.edit_note_rounded,
            "A set of similar array/hashmap practice problems will appear here once connected to the DSA question bank.",
          ),
        ),
      ],
    );
  }

  Widget _actionCard(IconData icon, String title, Color iconBg, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: brandRed, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: navy, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}