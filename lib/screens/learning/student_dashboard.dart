import 'package:flutter/material.dart';

// --- Screen Imports ---
import '../ai_features/ai_hub_screen.dart';
import '../ai_features/ai_scanner_analysis.dart';
import '../ai_features/ai_voice_conversation.dart';
import '../ai_features/interactive_model_screen.dart';
import '../ai_features/ai_mentor_hub.dart'; 
import '../tracking_rewards/goal_habit_tracker.dart'; 
import '../career/career_explorer_hub.dart'; 
import '../english/english_lab_dashboard.dart';
import '../settings/settings_profile.dart'; 
import 'live_ai_hunt.dart';
import 'knowledge_hub_screen.dart';
import 'daily_assessment_hub.dart'; 
import 'assessment_selection.dart'; 

// ============================================================
// MODELS
// ============================================================

enum ShellTab { home, library, rankings, settings }

class ToolModel {
  final String name;
  final IconData icon;
  final Color color;
  const ToolModel({required this.name, required this.icon, required this.color});
}

class GoalItemModel {
  final String title;
  final String time;
  final bool isCompleted;
  const GoalItemModel({required this.title, required this.time, this.isCompleted = false});
}

// ============================================================
// MAIN DASHBOARD
// ============================================================

class StudentDashboard extends StatefulWidget {
  final String studentName;
  final String avatarInitial;
  
  const StudentDashboard({
    super.key, 
    this.studentName = 'Arjun',
    this.avatarInitial = 'A',
  });

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  static const Color brandRed = Color(0xFFE8394A);
  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color mustard = Color(0xFFFBC02D);

  ShellTab _activeTab = ShellTab.home;

  // Tools Data
  final List<ToolModel> aiTools = const [
    ToolModel(name: 'Study Buddy', icon: Icons.smart_toy_rounded, color: Color(0xFFE8394A)),
    ToolModel(name: 'Career Guide', icon: Icons.explore_rounded, color: Color(0xFF33B679)),
    ToolModel(name: 'Zen Bot', icon: Icons.graphic_eq_rounded, color: Color(0xFF5B5FE0)),
    ToolModel(name: 'AI Scanner', icon: Icons.document_scanner_rounded, color: Color(0xFFF4A100)),
    ToolModel(name: 'Space Model', icon: Icons.rocket_launch_rounded, color: Color(0xFF29B6D8)),
    ToolModel(name: 'English Lab', icon: Icons.translate_rounded, color: Color(0xFF5B5FE0)),
  ];

  // Goals Data
  final List<GoalItemModel> todaysGoals = const [
    GoalItemModel(title: "Algebra Concept Review", time: "10:00 AM", isCompleted: true),
    GoalItemModel(title: "Newton's Law Analysis", time: "01:30 PM", isCompleted: false),
    GoalItemModel(title: "Mars Mission Study", time: "04:00 PM", isCompleted: false),
  ];

  void _onTabTapped(ShellTab tab) {
    setState(() => _activeTab = tab);
  }

  void _openDailyAssessmentHub() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DailyAssessmentHub(studentName: widget.studentName),
      ),
    );
  }

  Widget _buildActiveTabBody() {
    switch (_activeTab) {
      case ShellTab.home:
        return _buildHomeBody();
      case ShellTab.library:
        return const KnowledgeHubScreen();
      case ShellTab.rankings:
        return const GoalHabitTracker();
      case ShellTab.settings:
        return const SettingsProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildActiveTabBody(),
      ),
      bottomNavigationBar: _ShellBottomNav(
        activeTab: _activeTab,
        onTabTapped: _onTabTapped, 
      ),
    );
  }

  Widget _buildHomeBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('EduVerse AI', 
                    style: TextStyle(color: brandRed, fontSize: 28, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('Hi, ${widget.studentName}! Ready to learn?', 
                    style: const TextStyle(color: subtitleBlue, fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
              GestureDetector(
                onTap: _openDailyAssessmentHub, 
                child: CircleAvatar(
                  radius: 26, 
                  backgroundColor: mustard, 
                  child: Text(widget.avatarInitial, 
                    style: const TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 35),
          const Text('AI Tools & Mentors', 
            style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 18),

          // Tools Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: aiTools.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.3,
            ),
            itemBuilder: (context, index) {
              final tool = aiTools[index];
              return _ToolCard(
                tool: tool,
                onTap: () {
                  if (tool.name == 'Study Buddy') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AiMentorHub()));
                  } else if (tool.name == 'Career Guide') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CareerExplorerHub()));
                  } else if (tool.name == 'Zen Bot') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AiVoiceConversation()));
                  } else if (tool.name == 'AI Scanner') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AiScannerAnalysis()));
                  } else if (tool.name == 'Space Model') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const InteractiveModelScreen()));
                  } else if (tool.name == 'English Lab') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EnglishLabDashboard()));
                  }
                },
              );
            },
          ),

          const SizedBox(height: 40),
          const Text("Today's Goals", 
            style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 15),

          // Goals List
          ...todaysGoals.map((goal) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _GoalTile(
              title: goal.title, 
              time: goal.time, 
              isCompleted: goal.isCompleted
            ),
          )),
        ],
      ),
    );
  }
}

// ============================================================
// COMPONENTS
// ============================================================

class _ToolCard extends StatelessWidget {
  final ToolModel tool;
  final VoidCallback onTap;
  const _ToolCard({required this.tool, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF2F4F7)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 54, width: 54,
              decoration: BoxDecoration(color: tool.color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(tool.icon, color: tool.color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(tool.name, 
              style: const TextStyle(color: Color(0xFF14213D), fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  final String title;
  final String time;
  final bool isCompleted;
  const _GoalTile({required this.title, required this.time, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF2F4F7)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: isCompleted ? Colors.green : Colors.grey.shade300, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Color(0xFF14213D), fontWeight: FontWeight.bold, fontSize: 15)),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}

class _ShellBottomNav extends StatelessWidget {
  final ShellTab activeTab;
  final ValueChanged<ShellTab> onTabTapped;
  const _ShellBottomNav({required this.activeTab, required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(ShellTab.home, Icons.home_rounded, "Home"),
          _navItem(ShellTab.library, Icons.book_rounded, "Library"),
          _navItem(ShellTab.rankings, Icons.emoji_events_rounded, "Rankings"),
          _navItem(ShellTab.settings, Icons.settings_rounded, "Settings"),
        ],
      ),
    );
  }

  Widget _navItem(ShellTab tab, IconData icon, String label) {
    bool isSelected = activeTab == tab;
    return InkWell(
      onTap: () => onTabTapped(tab),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFFE8394A) : Colors.grey, size: 26),
          const SizedBox(height: 4),
          Text(label, 
            style: TextStyle(
              color: isSelected ? const Color(0xFFE8394A) : Colors.grey, 
              fontSize: 11, 
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)
          ),
        ],
      ),
    );
  }
}