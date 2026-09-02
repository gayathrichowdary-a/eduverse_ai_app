import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'planet_ai_chat_screen.dart';

// NOTE: this screen still uses the class name `InteractiveModelScreen` so
// existing navigation/routes elsewhere in the app keep working. Content is
// re-themed from a planet explorer to the spec's AI Tutor: a visual
// representation of a difficult topic, with a YouTube link fallback.
class InteractiveModelScreen extends StatelessWidget {
  final String topic;
  final String category;
  final String description;

  const InteractiveModelScreen({
    super.key,
    this.topic = 'Binary Search Tree',
    this.category = 'Data Structure',
    this.description =
        'A hierarchical structure where each node has at most two children, '
        'and left child values are always smaller than the parent while '
        'right child values are always larger. This ordering is what makes '
        'search, insert, and delete operations fast on average.',
  });

  // Color Palette from your design
  static const Color brandRed = Color(0xFFE8394A);
  static const Color navy = Color(0xFF14213D);
  static const Color textBlue = Color(0xFF4D86AD);
  static const Color accentCyan = Color(0xFF4FC3F7);
  static const Color gold = Color(0xFFFBC02D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // --- Background ---
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF14213D), Color(0xFF1F3A5F)],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // --- Top Navigation Bar ---
                _buildTopBar(context),

                const SizedBox(height: 20),

                // --- Category Chips ---
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _categoryChip(Icons.apps_rounded, "All Topics", brandRed),
                      const SizedBox(width: 12),
                      _categoryChip(Icons.account_tree_rounded, "Data Structures", brandRed),
                      const SizedBox(width: 12),
                      _categoryChip(Icons.timeline_rounded, "Algorithms", brandRed),
                    ],
                  ),
                ),

                // --- Main Info Card (scrolls if it's taller than the screen) ---
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    physics: const BouncingScrollPhysics(),
                    child: _buildTopicCard(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleButton(Icons.arrow_back, () => Navigator.pop(context)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: const [
                Icon(Icons.explore, color: brandRed, size: 20),
                SizedBox(width: 8),
                Text(
                  "Visual Explainer",
                  style: TextStyle(color: navy, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _circleButton(Icons.tune, () => _showFilterSheet(context)),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, color: navy),
      ),
    );
  }

  Widget _categoryChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic,
                          style: const TextStyle(color: navy, fontSize: 30, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          category,
                          style: const TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Tap to Explore",
                      style: TextStyle(color: brandRed, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // --- Stats Row ---
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _statCard("Search", "O(log n)"),
                    const SizedBox(width: 12),
                    _statCard("Insert", "O(log n)"),
                    const SizedBox(width: 12),
                    _statCard("Space", "O(n)"),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              Text(
                description,
                style: const TextStyle(color: textBlue, fontSize: 15, height: 1.5),
              ),

              const SizedBox(height: 25),

              // --- Ask AI Mentor + YouTube fallback ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlanetAiChatScreen(topic: topic),
                      ),
                    );
                  },
                  icon: const Icon(Icons.auto_awesome, color: Colors.white),
                  label: const Text("Ask AI Mentor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => _openYoutubeFallback(context),
                  icon: const Icon(Icons.play_circle_outline_rounded, color: navy),
                  label: const Text(
                    "Still confused? Watch on YouTube",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: navy),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: navy, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- Sidebar Interactive Buttons ---
        Positioned(
          right: 5,
          top: 0,
          child: Column(
            children: [
              _sidebarIcon(Icons.zoom_in),
              _sidebarIcon(Icons.zoom_out),
              _sidebarIcon(Icons.help_outline),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: gold,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: const Icon(Icons.auto_fix_high, color: navy),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statCard(String label, String value) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: navy.withOpacity(0.1), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 45, width: 45,
            decoration: BoxDecoration(color: accentCyan, borderRadius: BorderRadius.circular(12)),
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: textBlue, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: navy, fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: accentCyan, borderRadius: BorderRadius.circular(10)),
            child: const Text("Complexity", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _sidebarIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, color: navy, size: 24),
      ),
    );
  }

  // ============================================================
  // YOUTUBE FALLBACK
  // Spec: if the visual explanation still isn't clear, hand off
  // to a relevant YouTube video for the topic.
  // ============================================================

  Future<void> _openYoutubeFallback(BuildContext context) async {
    final query = Uri.encodeComponent('$topic explained');
    final searchUrl = Uri.parse('https://www.youtube.com/results?search_query=$query');

    try {
      final launched = await launchUrl(searchUrl, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        _showLaunchError(context);
      }
    } catch (_) {
      if (context.mounted) _showLaunchError(context);
    }
  }

  void _showLaunchError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Couldn't open YouTube. Please check your connection.")),
    );
  }

  // ============================================================
  // FILTER BOTTOM SHEET
  // ============================================================

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Filter View",
                style: TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _filterOptionTile(Icons.category_outlined, "Topic Type"),
              _filterOptionTile(Icons.speed_outlined, "Difficulty Level"),
              _filterOptionTile(Icons.threed_rotation, "View Mode"),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _filterOptionTile(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: navy),
      title: Text(label, style: const TextStyle(color: navy, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, color: textBlue),
      onTap: () {
        // TODO: wire real filtering once multiple topics are supported
      },
    );
  }
}