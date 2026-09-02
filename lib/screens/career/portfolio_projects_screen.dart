import 'package:flutter/material.dart';

class PortfolioProjectsScreen extends StatelessWidget {
  const PortfolioProjectsScreen({super.key});

  // Theme Colors
  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);

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
        actions: [
          IconButton(
            icon: const Icon(Icons.notes_rounded, color: navy), // Filter/Menu icon
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Title Section ---
            const Text(
              "Portfolio Projects",
              style: TextStyle(
                color: navy, 
                fontSize: 32, 
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Apply your AI-mentor guided learning to real-world builds.",
              style: TextStyle(
                color: subtitleBlue, 
                fontSize: 16, 
                height: 1.4
              ),
            ),

            const SizedBox(height: 30),

            // --- Filter Chips ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip("All Projects", Icons.grid_view_rounded, true),
                  const SizedBox(width: 12),
                  _buildFilterChip("AI & ML", Icons.grid_view_rounded, false),
                  const SizedBox(width: 12),
                  _buildFilterChip("Web Dev", Icons.grid_view_rounded, false),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // --- Portfolio Readiness Gradient Card ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE8394A), // Brand Red
                    Color(0xFF55C6E8), // Light Blue
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Portfolio Readiness",
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 20, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "You are 65% ready for internships",
                          style: TextStyle(
                            color: Colors.white70, 
                            fontSize: 14, 
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const SizedBox(height: 20),
                        // --- Custom Progress Bar ---
                        Stack(
                          children: [
                            Container(
                              height: 10,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Container(
                              height: 10,
                              width: MediaQuery.of(context).size.width * 0.4, // 65% visual
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFC107), // Yellow Progress
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // --- Badge Icon ---
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.workspace_premium, 
                      color: navy, 
                      size: 32
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? brandRed : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: isSelected ? null : Border.all(color: Colors.grey.shade100),
        boxShadow: isSelected ? null : [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon, 
            color: isSelected ? Colors.white : navy, 
            size: 18
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : navy,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}