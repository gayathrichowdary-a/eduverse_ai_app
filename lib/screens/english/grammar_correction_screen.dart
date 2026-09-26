import 'package:flutter/material.dart';

class GrammarCorrectionScreen extends StatefulWidget {
  const GrammarCorrectionScreen({super.key});

  @override
  State<GrammarCorrectionScreen> createState() =>
      _GrammarCorrectionScreenState();
}

class _GrammarCorrectionScreenState
    extends State<GrammarCorrectionScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color insightBlue = Color(0xFF3F51B5);
  static const Color lightBg = Color(0xFFF7F9FB);
  static const Color successGreen = Color(0xFF52B68C);
  static const Color warningOrange = Color(0xFFFF8F00);

  // ============================================================
  // GRAMMAR DATA
  // ============================================================

  static const String _originalDraft =
      "I have went to the store yesterday and buyed some fresh "
      "vegetables for the dinner. My mother was happy because "
      "she likes eat healthy food.";

  static const String _correctedDraft =
      "I went to the store yesterday and bought some fresh "
      "vegetables for dinner. My mother was happy because "
      "she likes to eat healthy food.";

  bool _correctionsApplied = false;

  // ============================================================
  // GRAMMAR REFRESHER STATE
  // ============================================================

  final Map<String, bool> _expandedRefreshers = {
    "Simple Past Tense": true,
    "Present Perfect Tense": false,
    "Gerunds vs Infinitives": false,
  };

  static const Map<String, String> _refresherBodies = {
    "Simple Past Tense":
        "Use the simple past for an action that was completed "
        "at a definite time in the past. Example: "
        "'I went to the store yesterday.'",

    "Present Perfect Tense":
        "Use the present perfect with have or has + past participle "
        "when the action is connected to the present. "
        "Example: 'I have finished my homework.'",

    "Gerunds vs Infinitives":
        "A gerund uses verb + ing, while an infinitive uses "
        "'to + verb'. Some verbs are followed by an infinitive. "
        "Example: 'She likes to eat healthy food.'",
  };

  // ============================================================
  // ACTIONS
  // ============================================================

  void _toggleRefresher(String title) {
    setState(() {
      _expandedRefreshers[title] =
          !(_expandedRefreshers[title] ?? false);
    });
  }

  void _tryAgain() {
    setState(() {
      _correctionsApplied = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Corrections reset. Try the draft again."),
      ),
    );
  }

  void _applyCorrections() {
    if (_correctionsApplied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Corrections are already applied."),
        ),
      );
      return;
    }

    setState(() {
      _correctionsApplied = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Grammar corrections applied successfully."),
        backgroundColor: successGreen,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: navy,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "AI Grammar Mentor",
              style: TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Grammar feedback",
              style: TextStyle(
                color: subtitleBlue,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressCard(),

            const SizedBox(height: 28),

            const Text(
              "Your Draft",
              style: TextStyle(
                color: navy,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            _buildDraftSection(),

            const SizedBox(height: 28),

            const Text(
              "Mentor Insights",
              style: TextStyle(
                color: navy,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            _buildInsightCard(
              color: insightBlue,
              icon: Icons.auto_awesome_rounded,
              title: "Past Tense",
              body:
                  "'Have went' is incorrect here because 'yesterday' "
                  "shows that the action was completed in the past. "
                  "Use the simple past: 'I went.'",
            ),

            const SizedBox(height: 12),

            _buildInsightCard(
              color: warningOrange,
              icon: Icons.edit_rounded,
              title: "Verb Form",
              body:
                  "'Buyed' is incorrect. The correct past form of "
                  "'buy' is 'bought'.",
            ),

            const SizedBox(height: 12),

            _buildInsightCard(
              color: successGreen,
              icon: Icons.check_circle_outline_rounded,
              title: "Infinitive",
              body:
                  "After 'likes', use 'to + verb' in this sentence: "
                  "'She likes to eat healthy food.'",
            ),

            const SizedBox(height: 28),

            _buildGrammarRefresher(),
          ],
        ),
      ),

      // ========================================================
      // BOTTOM ACTION BAR
      // ========================================================

      bottomSheet: _buildBottomActions(),
    );
  }

  // ============================================================
  // PROGRESS CARD
  // ============================================================

  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: successGreen.withValues(alpha: 0.35),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: successGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.edit_note_rounded,
              color: successGreen,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Grammar Review",
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Your AI Mentor found 3 grammar corrections "
                  "in this draft.",
                  style: TextStyle(
                    color: subtitleBlue,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DRAFT SECTION
  // ============================================================

  Widget _buildDraftSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: navy.withValues(alpha: 0.12),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // STATUS
          Row(
            children: [
              Icon(
                _correctionsApplied
                    ? Icons.check_circle_rounded
                    : Icons.edit_document,
                color: _correctionsApplied
                    ? successGreen
                    : brandRed,
                size: 19,
              ),
              const SizedBox(width: 8),
              Text(
                _correctionsApplied
                    ? "Corrected Draft"
                    : "Original Draft",
                style: TextStyle(
                  color: _correctionsApplied
                      ? successGreen
                      : navy,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // DRAFT TEXT
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: lightBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _correctionsApplied
                  ? _correctedDraft
                  : _originalDraft,
              style: const TextStyle(
                color: navy,
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Divider(),

          const SizedBox(height: 15),

          const Text(
            "Corrections",
            style: TextStyle(
              color: navy,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _buildCorrectionRow(
            original: "have went",
            corrected: "went",
          ),

          const SizedBox(height: 10),

          _buildCorrectionRow(
            original: "buyed",
            corrected: "bought",
          ),

          const SizedBox(height: 10),

          _buildCorrectionRow(
            original: "likes eat",
            corrected: "likes to eat",
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CORRECTION ROW
  // ============================================================

  Widget _buildCorrectionRow({
    required String original,
    required String corrected,
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFDE8E9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              original,
              style: const TextStyle(
                color: brandRed,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.arrow_forward_rounded,
            color: subtitleBlue,
            size: 19,
          ),
        ),

        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F6EF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              corrected,
              style: const TextStyle(
                color: successGreen,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MENTOR INSIGHT CARD
  // ============================================================

  Widget _buildInsightCard({
    required Color color,
    required IconData icon,
    required String title,
    required String body,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  body,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GRAMMAR REFRESHER
  // ============================================================

  Widget _buildGrammarRefresher() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: lightBg,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
              18,
              18,
              18,
              12,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  color: brandRed,
                  size: 21,
                ),
                SizedBox(width: 10),
                Text(
                  "Quick Grammar Refresher",
                  style: TextStyle(
                    color: navy,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          _refresherItem("Simple Past Tense"),
          _refresherItem("Present Perfect Tense"),
          _refresherItem("Gerunds vs Infinitives"),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ============================================================
  // REFRESHER ITEM
  // ============================================================

  Widget _refresherItem(String title) {
    final bool isExpanded =
        _expandedRefreshers[title] ?? false;

    final String body =
        _refresherBodies[title] ?? "";

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleRefresher(title),
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Icon(
                    isExpanded
                        ? Icons.remove_rounded
                        : Icons.add_rounded,
                    color: navy,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                15,
                0,
                15,
                15,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  body,
                  style: const TextStyle(
                    color: subtitleBlue,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM ACTIONS
  // ============================================================

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        25,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFEEEEEE),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // TRY AGAIN
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _tryAgain,
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                ),
                label: const Text(
                  "Try Again",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: navy,
                  side: const BorderSide(
                    color: navy,
                    width: 1.2,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // APPLY CORRECTIONS
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _applyCorrections,
                icon: Icon(
                  _correctionsApplied
                      ? Icons.check_circle_rounded
                      : Icons.check_rounded,
                  size: 18,
                ),
                label: Text(
                  _correctionsApplied
                      ? "Applied"
                      : "Apply Corrections",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _correctionsApplied
                          ? successGreen
                          : brandRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}