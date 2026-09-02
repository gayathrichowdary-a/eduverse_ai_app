import 'package:flutter/material.dart';

class ReadingPracticeScreen extends StatefulWidget {
  const ReadingPracticeScreen({super.key});

  @override
  State<ReadingPracticeScreen> createState() =>
      _ReadingPracticeScreenState();
}

class _ReadingPracticeScreenState extends State<ReadingPracticeScreen> {
  // ============================================================
  // THEME COLORS
  // ============================================================

  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color lightBlueBg = Color(0xFFEAF8FB);
  static const Color chartBlue = Color(0xFF55C6E8);
  static const Color matchGreen = Color(0xFF52B68C);
  static const Color mustard = Color(0xFFFBC02D);

  // ============================================================
  // STATE
  // ============================================================

  // 0 = Vocabulary
  // 1 = Comprehension
  // 2 = Pronunciation
  int _selectedTab = 0;

  String _selectedMentor = "AI Voice Coach";

  final Map<String, bool> _expandedTiles = {
    "Contextual Inference": true,
    "Idiomatic Expressions": false,
  };

  // ============================================================
  // MENTOR DETAILS
  // ============================================================

  static const Map<String, Map<String, String>> _mentorDetails = {
    "Prof. Evelyn": {
      "role": "Classic Literature Specialist",
      "bio":
          "Focuses on close reading of 19th and 20th century novels, helping you unpack theme, tone, and narrative voice.",
    },
    "AI Voice Coach": {
      "role": "Pronunciation & Fluency AI",
      "bio":
          "Listens as you read aloud, catching stress, rhythm, and pronunciation issues in real time.",
    },
    "S. Richards": {
      "role": "Technical & Non-Fiction Reading",
      "bio":
          "Specializes in scientific journals, reports, and dense informational text — great for comprehension speed.",
    },
  };

  // ============================================================
  // LESSON DETAILS
  // ============================================================

  static const Map<String, Map<String, String>> _lessonDetails = {
    "The Great Gatsby: Analysis": {
      "category": "Classic Literature",
      "time": "20 mins",
      "description":
          "A guided walkthrough of symbolism, unreliable narration, and the American Dream in Fitzgerald's novel.",
    },
    "Scientific Journal Review": {
      "category": "Technical Reading",
      "time": "15 mins",
      "description":
          "Practice extracting key findings and methodology from a dense scientific article.",
    },
  };

  // ============================================================
  // TAB INSIGHTS
  // ============================================================

  static const Map<int, List<Map<String, String>>> _tabInsights = {
    0: [
      {
        "title": "Contextual Inference",
        "body":
            "Struggling to identify subtext in complex narratives. AI suggests 'Reading Between the Lines' module.",
      },
      {
        "title": "Idiomatic Expressions",
        "body":
            "You're recognizing common idioms well — try more regional expressions next.",
      },
    ],
    1: [
      {
        "title": "Main Idea Extraction",
        "body":
            "You correctly identify main ideas in short passages. Longer texts still need practice.",
      },
      {
        "title": "Inference Questions",
        "body":
            "Work on drawing conclusions that aren't explicitly stated in the text.",
      },
    ],
    2: [
      {
        "title": "Stress & Intonation",
        "body":
            "Your sentence stress is improving. Focus next on rising intonation in questions.",
      },
      {
        "title": "Consonant Clarity",
        "body":
            "Some consonant blends (e.g. 'th', 'str') need clearer articulation.",
      },
    ],
  };

  // ============================================================
  // TAB FUNCTIONS
  // ============================================================

  void _selectTab(int index) {
    if (_selectedTab == index) return;

    final insights = _tabInsights[index] ?? [];

    setState(() {
      _selectedTab = index;
      _expandedTiles.clear();

      for (int i = 0; i < insights.length; i++) {
        final title = insights[i]["title"];

        if (title != null) {
          _expandedTiles[title] = i == 0;
        }
      }
    });
  }

  void _toggleTile(String title) {
    setState(() {
      _expandedTiles[title] = !(_expandedTiles[title] ?? false);
    });
  }

  // ============================================================
  // MENTOR FUNCTIONS
  // ============================================================

  void _selectMentor(String name, Color color) {
    final details = _mentorDetails[name];

    setState(() {
      _selectedMentor = name;
    });

    if (details == null) return;

    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: color,
                    child: Icon(
                      name == "AI Voice Coach"
                          ? Icons.graphic_eq
                          : Icons.person,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: navy,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          details["role"] ?? "",
                          style: const TextStyle(
                            color: subtitleBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                details["bio"] ?? "",
                style: const TextStyle(
                  color: navy,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Practice with $name",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // LESSON FUNCTIONS
  // ============================================================

  void _openLesson(String title) {
    final details = _lessonDetails[title];

    if (details == null) return;

    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                details["category"] ?? "",
                style: const TextStyle(
                  color: subtitleBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 14,
                    color: subtitleBlue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    details["time"] ?? "",
                    style: const TextStyle(
                      color: subtitleBlue,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                details["description"] ?? "",
                style: const TextStyle(
                  color: navy,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Begin Lesson",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // START READING
  // ============================================================

  void _startReadingExercise() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Starting reading exercise ($_selectedMentor)...",
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // MENU
  // ============================================================

  void _handleMenuSelection(String value) {
    if (value != 'restart') return;

    setState(() {
      _selectedTab = 0;

      _expandedTiles
        ..clear()
        ..addAll({
          "Contextual Inference": true,
          "Idiomatic Expressions": false,
        });

      _selectedMentor = "AI Voice Coach";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Reading progress restarted."),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final insights = _tabInsights[_selectedTab] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,

      // ----------------------------------------------------------
      // APP BAR
      // ----------------------------------------------------------

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: navy,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reading Practice",
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "English Literature • Grade 10",
              style: TextStyle(
                color: subtitleBlue,
                fontSize: 12,
              ),
            ),
          ],
        ),

        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: navy,
            ),
            onSelected: _handleMenuSelection,
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'restart',
                child: Text('Restart Progress'),
              ),
            ],
          ),
        ],
      ),

      // ----------------------------------------------------------
      // BODY
      // ----------------------------------------------------------

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            _buildHeaderCard(),

            const SizedBox(height: 30),

            const Text(
              "Reading Activity",
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _buildActivityChart(),

            const SizedBox(height: 25),

            _buildSegmentedTabs(),

            const SizedBox(height: 25),

            ...insights.map(
              (insight) {
                final title = insight["title"] ?? "";
                final body = insight["body"] ?? "";

                return _buildExpansionTile(
                  title,
                  body,
                );
              },
            ),

            const SizedBox(height: 20),

            _buildMistakeCard(),

            const SizedBox(height: 30),

            const Row(
              children: [
                Icon(
                  Icons.menu_book,
                  color: navy,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  "AI Personalized Lessons",
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            _buildLessonCard(
              "The Great Gatsby: Analysis",
              "Classic Literature",
              "20 mins",
              Icons.play_arrow_rounded,
              chartBlue,
            ),

            _buildLessonCard(
              "Scientific Journal Review",
              "Technical Reading",
              "15 mins",
              Icons.assignment_outlined,
              mustard,
            ),

            const SizedBox(height: 30),

            const Text(
              "Literary Mentors",
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMentorAvatar(
                  "Prof. Evelyn",
                  Colors.redAccent,
                ),
                _buildMentorAvatar(
                  "AI Voice Coach",
                  chartBlue,
                ),
                _buildMentorAvatar(
                  "S. Richards",
                  matchGreen,
                ),
              ],
            ),

            // Space for bottom button.
            const SizedBox(height: 130),
          ],
        ),
      ),

      // ----------------------------------------------------------
      // BOTTOM BUTTON
      // ----------------------------------------------------------

      bottomSheet: SafeArea(
        top: false,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            20,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: _startReadingExercise,
              icon: const Icon(
                Icons.psychology_outlined,
                color: Colors.white,
              ),
              label: const Text(
                "Start Reading Exercise",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: brandRed,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER CARD
  // ============================================================

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: lightBlueBg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgressIndicator(
                    value: 0.6,
                    strokeWidth: 10,
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      chartBlue,
                    ),
                  ),
                ),
                const Text(
                  "60%",
                  style: TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Eloquent Reading!",
                  style: TextStyle(
                    color: navy,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Your reading speed and comprehension are improving. Try Victorian prose for a challenge.",
                  style: TextStyle(
                    color: subtitleBlue,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 15),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildPillBadge(
                      "142 WPM",
                      mustard,
                      Icons.speed,
                    ),
                    _buildPillBadge(
                      "Expert",
                      matchGreen,
                      Icons.menu_book,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PILL BADGE
  // ============================================================

  Widget _buildPillBadge(
    String label,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: navy,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: navy,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: navy,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIVITY CHART
  // ============================================================

  Widget _buildActivityChart() {
    const values = [
      40.0,
      50.0,
      45.0,
      60.0,
      55.0,
      65.0,
      58.0,
    ];

    const days = [
      "M",
      "T",
      "W",
      "T",
      "F",
      "S",
      "S",
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Average words per minute",
                  style: TextStyle(
                    color: subtitleBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "Last 7 Days",
                style: TextStyle(
                  color: navy,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                values.length,
                (index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 15,
                        height: values[index],
                        decoration: BoxDecoration(
                          color: chartBlue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        days[index],
                        style: const TextStyle(
                          color: subtitleBlue,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEGMENTED TABS
  // ============================================================

  Widget _buildSegmentedTabs() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _tabItem(
            "Vocabulary",
            index: 0,
          ),
          _tabItem(
            "Comprehension",
            index: 1,
          ),
          _tabItem(
            "Pronunciation",
            index: 2,
          ),
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
        onTap: () => _selectTab(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 5,
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? navy
                  : subtitleBlue,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EXPANSION TILE
  // ============================================================

  Widget _buildExpansionTile(
    String title,
    String content,
  ) {
    final isExpanded = _expandedTiles[title] ?? false;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _toggleTile(title),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: subtitleBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  isExpanded
                      ? Icons.remove
                      : Icons.add,
                  color: navy,
                  size: 20,
                ),
              ],
            ),
          ),

          if (isExpanded) ...[
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                color: navy,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],

          const SizedBox(height: 15),

          const Divider(),
        ],
      ),
    );
  }

  // ============================================================
  // COMMON MISTAKE CARD
  // ============================================================

  Widget _buildMistakeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: brandRed.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.error_outline,
                color: brandRed,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "Common Mistake",
                style: TextStyle(
                  color: brandRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Text(
            "Ignoring punctuation cues in dialogue",
            style: TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 12),

          const Divider(),

          const SizedBox(height: 12),

          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: matchGreen,
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Pause at periods (2s) and commas (1s) to improve flow.",
                  style: TextStyle(
                    color: navy,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LESSON CARD
  // ============================================================

  Widget _buildLessonCard(
    String title,
    String category,
    String time,
    IconData icon,
    Color iconBg,
  ) {
    return GestureDetector(
      onTap: () => _openLesson(title),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          bottom: 15,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: navy,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      color: subtitleBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: subtitleBlue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: const TextStyle(
                          color: subtitleBlue,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.chevron_right,
              color: subtitleBlue,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MENTOR AVATAR
  // ============================================================

  Widget _buildMentorAvatar(
    String name,
    Color color,
  ) {
    final isSelected = _selectedMentor == name;

    return GestureDetector(
      onTap: () => _selectMentor(
        name,
        color,
      ),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 90,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? brandRed
                      : navy,
                  width: isSelected
                      ? 2.5
                      : 1.5,
                ),
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: color,
                child: Icon(
                  name == "AI Voice Coach"
                      ? Icons.graphic_eq
                      : Icons.person,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected
                    ? brandRed
                    : navy,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}