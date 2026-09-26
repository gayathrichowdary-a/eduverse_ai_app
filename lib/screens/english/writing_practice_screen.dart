import 'package:flutter/material.dart';

class WritingPracticeScreen extends StatefulWidget {
  const WritingPracticeScreen({super.key});

  @override
  State<WritingPracticeScreen> createState() => _WritingPracticeScreenState();
}

class _WritingPracticeScreenState extends State<WritingPracticeScreen> {
  // Theme Colors
  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color bgGrey = Color(0xFFF7F9FB);

  // 0 = Draft, 1 = Guidelines, 2 = History
  int _selectedTab = 0;

  bool _isSubmitting = false;

  // Mock past submissions for History tab
  static const List<Map<String, String>> _history = [
    {
      "title": "The Role of Federalism in Indian Democracy",
      "date": "May 22, 2024",
      "score": "8.2/10",
    },
    {
      "title": "Climate Change and Sustainable Agriculture",
      "date": "May 18, 2024",
      "score": "7.5/10",
    },
    {
      "title": "Women Empowerment through Self-Help Groups",
      "date": "May 12, 2024",
      "score": "8.9/10",
    },
  ];

  void _showAnalyticsDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: brandRed.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.analytics_outlined,
                        color: brandRed,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Your Writing Stats",
                        style: TextStyle(
                          color: navy,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _statRow("Essays Submitted", "12"),
                _statRow("Average Score", "8.1 / 10"),
                _statRow("Average Word Count", "487 words"),
                _statRow("Writing Streak", "6 days"),
                _statRow("Most Common Feedback", "Add more examples"),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: subtitleBlue,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: navy,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            "Submit for Final Review?",
            style: TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Once submitted, you won't be able to edit this draft. "
            "Your AI Mentor will review it and share detailed feedback.",
            style: TextStyle(
              color: subtitleBlue,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(
                "Cancel",
                style: TextStyle(color: subtitleBlue),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: brandRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulated submission delay.
    // Replace this with the real API call later.
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Submitted! Your AI Mentor is reviewing it ✅",
        ),
        backgroundColor: Color(0xFF52B68C),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: navy,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Writing Practice",
          style: TextStyle(
            color: navy,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.analytics_outlined,
              color: brandRed,
            ),
            onPressed: _showAnalyticsDialog,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomTabBar(),

            const SizedBox(height: 25),

            if (_selectedTab == 0)
              _buildDraftTab(),

            if (_selectedTab == 1)
              _buildGuidelinesTab(),

            if (_selectedTab == 2)
              _buildHistoryTab(),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar:
          _selectedTab == 0 ? _buildSubmitButton() : null,
    );
  }

  // ------------------------------------------------------------
  // DRAFT TAB
  // ------------------------------------------------------------

  Widget _buildDraftTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                "Current Prompt",
                style: TextStyle(
                  color: navy,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFDE8E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check,
                    color: brandRed,
                    size: 14,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "UPSC Mains",
                    style: TextStyle(
                      color: brandRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        _buildPromptCard(),

        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Expanded(
              child: Text(
                "Writing Workspace",
                style: TextStyle(
                  color: navy,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              "Auto-saved 12:45 PM",
              style: TextStyle(
                color: subtitleBlue,
                fontSize: 11,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        _buildWritingArea(),

        const SizedBox(height: 25),

        Row(
          children: [
            _buildStatBox(
              "142/500",
              "Words",
              Icons.menu_book,
            ),
            const SizedBox(width: 12),
            _buildStatBox(
              "Good",
              "Clarity",
              Icons.psychology,
            ),
            const SizedBox(width: 12),
            _buildStatBox(
              "Formal",
              "Tone",
              Icons.record_voice_over,
            ),
          ],
        ),

        const SizedBox(height: 35),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                "AI Assistant Insights",
                style: TextStyle(
                  color: navy,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Grammar check completed.",
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.spellcheck,
                size: 16,
              ),
              label: const Text(
                "Check Grammar",
              ),
              style: TextButton.styleFrom(
                foregroundColor: brandRed,
              ),
            ),
          ],
        ),

        _buildInsightCard(
          "Enhance Vocabulary",
          "Consider replacing 'wide' with 'yawning' to emphasize the scale...",
          const Color(0xFFE8EAF6),
          Icons.auto_awesome,
          Colors.blue,
        ),

        const SizedBox(height: 12),

        _buildInsightCard(
          "Structural Tip",
          "Your second paragraph could benefit from a specific example like Digital India.",
          const Color(0xFFFFF3E0),
          Icons.lightbulb,
          Colors.orange,
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // GUIDELINES TAB
  // ------------------------------------------------------------

  Widget _buildGuidelinesTab() {
    final tips = [
      {
        "title": "Structure Matters",
        "body":
            "Use a clear intro, 2–3 body paragraphs, and a strong conclusion. Examiners reward organization as much as content.",
        "icon": Icons.view_agenda_outlined,
      },
      {
        "title": "Stay Within Word Limit",
        "body":
            "UPSC Mains answers are typically capped at 250 words for a 15-mark question. Practice concise writing.",
        "icon": Icons.short_text,
      },
      {
        "title": "Use Concrete Examples",
        "body":
            "Cite real schemes, data, or case studies (e.g. Digital India, PM-KISAN) to strengthen your argument.",
        "icon": Icons.fact_check_outlined,
      },
      {
        "title": "Balanced Perspective",
        "body":
            "Present multiple viewpoints before reaching a conclusion — avoid one-sided arguments.",
        "icon": Icons.balance_outlined,
      },
      {
        "title": "Neat Presentation",
        "body":
            "Use headings, underlines, or bullet points where relevant to improve readability.",
        "icon": Icons.format_list_bulleted,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Writing Guidelines",
          style: TextStyle(
            color: navy,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          "Tips to help you write a stronger UPSC Mains answer.",
          style: TextStyle(
            color: subtitleBlue,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 20),

        ...tips.map(
          (tip) => Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgGrey,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  tip["icon"] as IconData,
                  color: brandRed,
                  size: 22,
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip["title"] as String,
                        style: const TextStyle(
                          color: navy,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        tip["body"] as String,
                        style: const TextStyle(
                          color: subtitleBlue,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // HISTORY TAB
  // ------------------------------------------------------------

  Widget _buildHistoryTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Past Submissions",
          style: TextStyle(
            color: navy,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          "${_history.length} essays reviewed so far.",
          style: const TextStyle(
            color: subtitleBlue,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 20),

        ..._history.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: navy.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EAF6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: navy,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"]!,
                        style: const TextStyle(
                          color: navy,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        item["date"]!,
                        style: const TextStyle(
                          color: subtitleBlue,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF52B68C),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item["score"]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // TAB BAR
  // ------------------------------------------------------------

  Widget _buildCustomTabBar() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: bgGrey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _tabItem("Draft", index: 0),
          _tabItem("Guidelines", index: 1),
          _tabItem("History", index: 2),
        ],
      ),
    );
  }

  Widget _tabItem(
    String label, {
    required int index,
  }) {
    final isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFE3F2FD)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF1976D2)
                  : subtitleBlue,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // PROMPT CARD
  // ------------------------------------------------------------

  Widget _buildPromptCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: navy.withValues(alpha: 0.8),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The Impact of Digital Literacy on Rural Empowerment in India",
            style: TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          SizedBox(height: 10),

          Text(
            "Discuss how digital education can bridge the socio-economic gap in tier-3 cities. Focus on gender inclusivity and agricultural innovation.",
            style: TextStyle(
              color: subtitleBlue,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // WRITING AREA
  // ------------------------------------------------------------

  Widget _buildWritingArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: brandRed,
          width: 1.5,
        ),
      ),
      child: const Text(
        "The digital revolution has reached the doorsteps of rural India, yet the chasm between access and literacy remains wide. For a farmer in Vidarbha, a smartphone is a window to global markets, but without the skill to navigate it, the window remains shuttered. Digital empowerment is not merely about providing hardware; it is about fostering a culture of curiosity and competence...",
        style: TextStyle(
          color: navy,
          fontSize: 15,
          height: 1.6,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // STAT BOX
  // ------------------------------------------------------------

  Widget _buildStatBox(
    String value,
    String label,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: navy,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: navy,
              size: 20,
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              label,
              style: const TextStyle(
                color: subtitleBlue,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // AI INSIGHT CARD
  // ------------------------------------------------------------

  Widget _buildInsightCard(
    String title,
    String body,
    Color bg,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconColor,
            radius: 18,
            child: const Text(
              "AI",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: navy,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  body,
                  style: const TextStyle(
                    color: subtitleBlue,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          const Icon(
            Icons.add_circle_outline,
            color: Colors.blue,
            size: 20,
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // SUBMIT BUTTON
  // ------------------------------------------------------------

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        30,
      ),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          onPressed:
              _isSubmitting ? null : _handleSubmit,
          icon: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
          label: Text(
            _isSubmitting
                ? "Submitting..."
                : "Submit for Final Review",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: brandRed,
            disabledBackgroundColor:
                brandRed.withValues(alpha: 0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}