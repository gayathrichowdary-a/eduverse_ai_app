import 'package:flutter/material.dart';

/// KNOWLEDGE HUB — Library tab body content.
///
/// IMPORTANT: This widget is BODY CONTENT ONLY. It does NOT include its own
/// Scaffold bottomNavigationBar, because your StudentDashboard already owns
/// the bottom nav (Home / Library / Rankings / Settings).
///
/// WHERE TO ADD THIS IN YOUR EXISTING student_dashboard.dart:
///
/// 1. Import at the top of student_dashboard.dart:
///      import 'knowledge_hub_screen.dart';
///
/// 2. Find your IndexedStack (or PageView / body switch) that holds the
///    4 tab bodies, e.g.:
///
///      final List<Widget> _tabs = [
///        HomeScreen(),
///        PlaceholderLibraryScreen(),   // <-- REPLACE THIS LINE
///        RankingsScreen(),
///        SettingsScreen(),
///      ];
///
///    Replace the Library placeholder with:
///
///      final List<Widget> _tabs = [
///        HomeScreen(),
///        const KnowledgeHubScreen(),   // <-- ADDED
///        RankingsScreen(),
///        SettingsScreen(),
///      ];
///
/// 3. No changes needed to your BottomNavigationBar itself — it already
///    controls which index is shown, and index 1 (Library) now renders
///    this screen.
class KnowledgeHubScreen extends StatefulWidget {
  const KnowledgeHubScreen({super.key});

  @override
  State<KnowledgeHubScreen> createState() => _KnowledgeHubScreenState();
}

class _KnowledgeHubScreenState extends State<KnowledgeHubScreen> {
  final TextEditingController _searchController = TextEditingController();

  static const Color kYellow = Color(0xFFF6C700);
  static const Color kNavy = Color(0xFF17233B);
  static const Color kRed = Color(0xFFE0483E);
  static const Color kGreen = Color(0xFF3FA66A);
  static const Color kPurple = Color(0xFF5B21B6);

  final List<_Mistake> _mistakes = const [
    _Mistake(
      mistake: "Thinking gravity doesn't act on objects in orbit.",
      correction:
          "Gravity provides the centripetal force that keeps objects in orbit.",
    ),
    _Mistake(
      mistake: "Confusing 'Mass' with 'Weight' in vacuum calculations.",
      correction:
          "Mass is constant; weight depends on the local gravitational field.",
    ),
  ];

  final List<_ResourceItem> _resources = const [
    _ResourceItem(
      icon: Icons.play_circle_fill,
      iconBg: Color(0xFF3AB6E8),
      badge: '80%',
      category: 'Video Lesson',
      title: 'Quantum Basics',
    ),
    _ResourceItem(
      icon: Icons.apps,
      iconBg: Color(0xFF3FA66A),
      badge: 'New',
      category: 'Interactive',
      title: 'Periodic Table',
    ),
    _ResourceItem(
      icon: Icons.psychology,
      iconBg: Color(0xFFE0483E),
      badge: 'Review',
      category: 'Exam Coach',
      title: 'Algebra Prep',
    ),
    _ResourceItem(
      icon: Icons.self_improvement,
      iconBg: Color(0xFFF6C700),
      badge: 'Ready',
      category: 'Holistic',
      title: 'Fitness Guide',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInsightsHeader(),
                  const SizedBox(height: 16),
                  ..._mistakes.map(
                    (m) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildMistakeCard(m),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Resource Library',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: kNavy,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildResourceGrid(),
                  const SizedBox(height: 20),
                  _buildCareerPathBanner(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: kYellow,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Knowledge Hub',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: kNavy,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Master your misconceptions',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: kNavy,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4FC3E8),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'JD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kNavy, width: 2),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 14),
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search formulas, topics...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: kRed,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kNavy, width: 2),
                ),
                child: const Icon(Icons.tune, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Your AI Insights',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: kNavy,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: kGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            '4 New',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMistakeCard(_Mistake m) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE1DF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kRed, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error, color: kRed, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Common Mistake',
                style: TextStyle(
                  color: kRed,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            m.mistake,
            style: const TextStyle(
              color: kNavy,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          Divider(color: kRed.withOpacity(0.3), height: 1),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle, color: kGreen, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  m.correction,
                  style: const TextStyle(
                    color: kNavy,
                    fontSize: 15,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResourceGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _resources.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final item = _resources[index];
        return GestureDetector(
          onTap: () {
            // TODO: navigate to the specific resource detail screen
            // Navigator.push(context, MaterialPageRoute(
            //   builder: (_) => ResourceDetailScreen(item: item),
            // ));
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: kNavy, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: item.iconBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(item.icon, color: Colors.white, size: 24),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Text(
                        item.badge,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: kNavy,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  item.category,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: kNavy,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCareerPathBanner() {
    return GestureDetector(
      onTap: () {
        // TODO: navigate to Career Path AI screen
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: kPurple,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Career Path AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Based on your library interests, you might love Astrophysics!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white, size: 26),
          ],
        ),
      ),
    );
  }
}

class _Mistake {
  final String mistake;
  final String correction;
  const _Mistake({required this.mistake, required this.correction});
}

class _ResourceItem {
  final IconData icon;
  final Color iconBg;
  final String badge;
  final String category;
  final String title;
  const _ResourceItem({
    required this.icon,
    required this.iconBg,
    required this.badge,
    required this.category,
    required this.title,
  });
}