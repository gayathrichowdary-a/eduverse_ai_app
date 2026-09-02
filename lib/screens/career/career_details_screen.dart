import 'package:flutter/material.dart';
import 'personalized_roadmap_screen.dart'; // <--- IMPORT ADDED HERE

class CareerDetailsScreen extends StatelessWidget {
  final String careerTitle;
  const CareerDetailsScreen({super.key, this.careerTitle = "AI Engineer"});

  // Theme Colors
  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // --- Header with Image ---
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: navy,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(careerTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              background: Image.network(
                'https://images.unsplash.com/photo-1677442136019-21780ecad995?q=80&w=1000',
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.4),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Quick Stats Row ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStat("Avg. Salary", "₹18L - 45L", Icons.payments_outlined, Colors.green),
                      _buildStat("Growth", "Very High", Icons.trending_up, Colors.orange),
                      _buildStat("Work Type", "Hybrid", Icons.laptop_mac, Colors.blue),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // --- About Section ---
                  const Text("About the Role", style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text(
                    "AI Engineers are responsible for developing, programming, and training the complex networks of algorithms that make up AI so that they can function like a human brain.",
                    style: TextStyle(color: subtitleBlue, fontSize: 14, height: 1.5),
                  ),

                  const SizedBox(height: 30),

                  // --- Core Skills Required ---
                  const Text("Top Skills Required", style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildSkillChip("Python"),
                      _buildSkillChip("Machine Learning"),
                      _buildSkillChip("Neural Networks"),
                      _buildSkillChip("Mathematics"),
                      _buildSkillChip("Cloud Computing"),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // --- Future Outlook ---
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F4F8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Future Outlook", style: TextStyle(color: navy, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(
                          "The demand for AI professionals is expected to grow by 35% over the next decade as more industries adopt automation.",
                          style: TextStyle(color: subtitleBlue, fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          )
        ],
      ),
      // --- Floating Action Button to Roadmap ---
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              // NAVIGATION ADDED HERE
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => PersonalizedRoadmapScreen(careerTitle: careerTitle)
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: brandRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text("Create My Roadmap", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: subtitleBlue, fontSize: 11)),
        Text(value, style: const TextStyle(color: navy, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: navy.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: const TextStyle(color: navy, fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }
}