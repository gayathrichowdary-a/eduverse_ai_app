import 'package:flutter/material.dart';
import 'ai_voice_conversation.dart';

/// Sophia Hub — central launcher for Sophia AI features.
/// Search bar, quick-action shortcuts scoped to the LMS's engineering/DSA
/// content, recent Sophia conversations, and a "continue learning" banner
/// tied to the student's active course track.
class AiHubScreen extends StatefulWidget {
  final String userName;
  final String userInitials;
  final String activeCourseTrack;
  final String suggestedTopic;

  const AiHubScreen({
    super.key,
    this.userName = 'Akhil',
    this.userInitials = 'AK',
    this.activeCourseTrack = 'Python & AI',
    this.suggestedTopic = 'Binary Search Trees',
  });

  @override
  State<AiHubScreen> createState() => _AiHubScreenState();
}

class _AiHubScreenState extends State<AiHubScreen> {
  final TextEditingController _searchController = TextEditingController();

  static const Color brandRed = Color(0xFFE8394A);
  static const Color navy = Color(0xFF14213D);
  static const Color textBlue = Color(0xFF4D86AD);
  static const Color tealAccent = Color(0xFF4FA9A0);
  static const Color bgGrey = Color(0xFFF7F9FB);

  // Quick actions scoped to what Sophia actually does per the LMS spec:
  // debugging/hints, concept explanations with visual + video fallback,
  // mock interview practice, and resume/ATS help.
  final List<_QuickAction> _quickActions = const [
    _QuickAction(
      icon: Icons.bug_report_outlined,
      label: 'Debug My Code',
      route: 'debug_code',
    ),
    _QuickAction(
      icon: Icons.lightbulb_outline,
      label: 'Explain DSA Concept',
      route: 'explain_concept',
    ),
    _QuickAction(
      icon: Icons.record_voice_over_outlined,
      label: 'Mock Interview',
      route: 'mock_interview',
    ),
    _QuickAction(
      icon: Icons.description_outlined,
      label: 'Resume ATS Check',
      route: 'resume_check',
    ),
    _QuickAction(
      icon: Icons.tips_and_updates_outlined,
      label: 'Hint on Current Problem',
      route: 'coding_hint',
    ),
    _QuickAction(
      icon: Icons.route_outlined,
      label: 'Career Roadmap',
      route: 'career_roadmap',
    ),
  ];

  final List<_RecentConversation> _recentConversations = const [
    _RecentConversation(
      icon: Icons.account_tree_outlined,
      title: 'Binary Search Trees',
      subtitle: 'Explained in-order traversal...',
    ),
    _RecentConversation(
      icon: Icons.bug_report_outlined,
      title: 'Null pointer in linked list',
      subtitle: 'Found the missing base case...',
    ),
    _RecentConversation(
      icon: Icons.sort,
      title: 'Merge Sort walkthrough',
      subtitle: 'Step-by-step divide and merge...',
    ),
    _RecentConversation(
      icon: Icons.work_outline,
      title: 'Resume — Software Engineer',
      subtitle: 'Match score improved to 78%...',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleQuickAction(String route) {
    // TODO: wire to actual Sophia feature screens/backend as they're built.
    // e.g. 'coding_hint' should deep-link into the LMS Coding screen's
    // collapsible Sophia hint panel rather than opening a standalone page.
    debugPrint('Sophia quick action tapped: $route');
  }

  void _handleRecentConversation(_RecentConversation conversation) {
    // TODO: navigate to the conversation detail / chat screen
    debugPrint('Recent conversation tapped: ${conversation.title}');
  }

  void _handleSeeAllConversations() {
    // TODO: navigate to full conversation history screen
    debugPrint('See all conversations tapped');
  }

  void _handleContinueLearning() {
    // TODO: navigate to the suggested topic inside the student's course track
    debugPrint('Continue learning tapped: ${widget.suggestedTopic}');
  }

  void _handleSearchSubmit(String query) {
    if (query.trim().isEmpty) return;
    // TODO: route the free-form query to Sophia's chat/response screen
    debugPrint('Search submitted to Sophia: $query');
  }

  void _openVoiceAssistant() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AiVoiceConversation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 24),
            const Text(
              'Ask Sophia',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),
            const SizedBox(height: 12),
            _buildQuickActionsGrid(),
            const SizedBox(height: 24),
            _buildRecentConversationsHeader(),
            const SizedBox(height: 8),
            ..._recentConversations.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildRecentConversationCard(c),
              ),
            ),
            const SizedBox(height: 8),
            _buildContinueLearningBanner(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Hi ${widget.userName} 👋',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: tealAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Sophia's ready to help",
                    style: TextStyle(
                      fontSize: 15,
                      color: navy.withOpacity(0.65),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 26,
          backgroundColor: brandRed,
          child: Text(
            widget.userInitials,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: _handleSearchSubmit,
        decoration: InputDecoration(
          hintText: 'Ask Sophia anything...',
          hintStyle: TextStyle(color: navy.withOpacity(0.4)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.mic_none, color: brandRed),
                tooltip: 'Talk to Sophia',
                onPressed: _openVoiceAssistant,
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined, color: brandRed),
                tooltip: 'Scan a problem',
                onPressed: () => debugPrint('Camera input tapped'),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _quickActions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final action = _quickActions[index];
        return _QuickActionCard(
          action: action,
          onTap: () => _handleQuickAction(action.route),
        );
      },
    );
  }

  Widget _buildRecentConversationsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent with Sophia',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: navy,
          ),
        ),
        TextButton(
          onPressed: _handleSeeAllConversations,
          child: const Text(
            'See All',
            style: TextStyle(
              color: brandRed,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentConversationCard(_RecentConversation conversation) {
    return InkWell(
      onTap: () => _handleRecentConversation(conversation),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE7EAEE)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFEFF3F6),
              child: Icon(conversation.icon, color: navy, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    conversation.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: navy.withOpacity(0.55),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: tealAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueLearningBanner() {
    return InkWell(
      onTap: _handleContinueLearning,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [brandRed, Color(0xFF4A90D9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Continue ${widget.activeCourseTrack}?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Sophia suggests picking up '${widget.suggestedTopic}' today.",
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: _handleContinueLearning,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: brandRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Resume Learning',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final String route;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.route,
  });
}

class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;
  final VoidCallback onTap;

  const _QuickActionCard({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE7EAEE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFCE4E4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(action.icon, color: const Color(0xFFE8394A), size: 20),
            ),
            const Spacer(),
            Text(
              action.label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF14213D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentConversation {
  final IconData icon;
  final String title;
  final String subtitle;

  const _RecentConversation({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}