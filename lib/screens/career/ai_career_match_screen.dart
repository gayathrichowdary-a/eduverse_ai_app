import 'package:flutter/material.dart';
import 'career_details_screen.dart';

class AiCareerMatchScreen extends StatelessWidget {
  const AiCareerMatchScreen({super.key});

  // Theme Colors
  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color matchGreen = Color(0xFF52B68C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Career Pathways",
              style: TextStyle(color: navy, fontWeight: FontWeight.bold, fontSize: 18)),
            Text("AI-powered matches based on your skills",
              style: TextStyle(color: subtitleBlue, fontSize: 11)),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: navy),
            onPressed: () => _showRefineMatchesSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- Top Match Highlight Card ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFDE8E9),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: brandRed, size: 30),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Top Match: Data Scientist",
                          style: TextStyle(color: brandRed, fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 4),
                        Text("Your strong performance in Calculus and Logic puzzles makes this a 94% match.",
                          style: TextStyle(color: navy, fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- Career Match List ---
            _buildMatchCard(
              context,
              "Aerospace Engineer",
              "88% Match",
              "High aptitude in Physics and 3D spatial reasoning modules.",
              Icons.rocket_launch,
              brandRed
            ),
            _buildMatchCard(
              context,
              "Psychologist",
              "82% Match",
              "Strong emotional intelligence scores and consistent journaling patterns.",
              Icons.accessibility_new,
              const Color(0xFF4FC3F7)
            ),
            _buildMatchCard(
              context,
              "UX Designer",
              "76% Match",
              "Combines your interest in digital art with high problem-solving speed.",
              Icons.palette,
              const Color(0xFFFFC107)
            ),
            _buildMatchCard(
              context,
              "Environmental Scientist",
              "71% Match",
              "Driven by your frequent engagement with biology and sustainability topics.",
              Icons.eco,
              matchGreen
            ),

            const SizedBox(height: 20),
            const Text("Want to explore more niches?",
              style: TextStyle(color: subtitleBlue, fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- Refine Matches Bottom Sheet ---
  void _showRefineMatchesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => const _RefineMatchesSheet(),
    );
  }

  Widget _buildMatchCard(BuildContext context, String title, String percentage, String reason, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: navy.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
                child: Icon(icon, color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: matchGreen, borderRadius: BorderRadius.circular(10)),
                child: Text(percentage,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(reason, style: const TextStyle(color: subtitleBlue, fontSize: 14, height: 1.4)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CareerDetailsScreen(careerTitle: title))
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: navy),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Explore Path", style: TextStyle(color: navy, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}

// --- Stateful Bottom Sheet Content ---
class _RefineMatchesSheet extends StatefulWidget {
  const _RefineMatchesSheet();

  @override
  State<_RefineMatchesSheet> createState() => _RefineMatchesSheetState();
}

class _RefineMatchesSheetState extends State<_RefineMatchesSheet> {
  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);

  // Filter state
  final List<String> _categories = ["Tech", "Science", "Arts", "Business"];
  String? _selectedCategory = "Tech";
  double _minMatch = 0;
  String _sortBy = "Best Match"; // or "Alphabetical"

  void _reset() {
    setState(() {
      _selectedCategory = null;
      _minMatch = 0;
      _sortBy = "Best Match";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Refine Matches",
                style: TextStyle(color: navy, fontSize: 22, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: _reset,
                child: const Text("Reset",
                  style: TextStyle(color: brandRed, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Category
          const Text("Category",
            style: TextStyle(color: navy, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _categories.map((cat) {
              final bool selected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFFFDE8E9) : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: selected ? brandRed : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(cat,
                    style: TextStyle(
                      color: navy,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 25),

          // Minimum Match
          Text("Minimum Match: ${_minMatch.toInt()}%",
            style: const TextStyle(color: navy, fontSize: 14, fontWeight: FontWeight.bold)),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: brandRed,
              inactiveTrackColor: Colors.grey.shade200,
              thumbColor: brandRed,
              overlayColor: brandRed.withValues(alpha: 0.2),
              trackHeight: 3,
            ),
            child: Slider(
              value: _minMatch,
              min: 0,
              max: 100,
              divisions: 20,
              onChanged: (val) => setState(() => _minMatch = val),
            ),
          ),

          const SizedBox(height: 10),

          // Sort By
          const Text("Sort By",
            style: TextStyle(color: navy, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _sortChip("Best Match")),
              const SizedBox(width: 12),
              Expanded(child: _sortChip("Alphabetical")),
            ],
          ),

          const SizedBox(height: 30),

          // Apply Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                // Return chosen filters back to caller if needed:
                Navigator.pop(context, {
                  "category": _selectedCategory,
                  "minMatch": _minMatch,
                  "sortBy": _sortBy,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: brandRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Apply Filters",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortChip(String label) {
    final bool selected = _sortBy == label;
    return GestureDetector(
      onTap: () => setState(() => _sortBy = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? navy : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: selected ? navy : Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selected) ...[
              const Icon(Icons.check, color: Colors.white, size: 16),
              const SizedBox(width: 6),
            ],
            Text(label,
              style: TextStyle(
                color: selected ? Colors.white : navy,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}