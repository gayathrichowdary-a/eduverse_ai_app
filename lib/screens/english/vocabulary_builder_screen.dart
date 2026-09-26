import 'package:flutter/material.dart';

class VocabularyBuilderScreen extends StatefulWidget {
  const VocabularyBuilderScreen({super.key});

  @override
  State<VocabularyBuilderScreen> createState() =>
      _VocabularyBuilderScreenState();
}

class _VocabularyBuilderScreenState extends State<VocabularyBuilderScreen> {
  // EduVerse Theme Colors
  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color lightBg = Color(0xFFF7F9FB);

  // Word data
  static const Map<String, Map<String, String>> _words = {
    "Resilient": {
      "phonetic": "/rɪˈzilyənt/",
      "meaning":
          "Able to withstand or recover quickly from difficult conditions.",
      "level": "Intermediate",
      "example":
          "Despite the setback, she remained resilient and pushed forward with the project.",
    },
    "Eloquence": {
      "phonetic": "/ˈɛləkwəns/",
      "meaning": "Fluent or persuasive speaking.",
      "level": "Advanced",
      "example":
          "His eloquence during the debate won over even the toughest critics.",
    },
    "Coherent": {
      "phonetic": "/koʊˈhɪərənt/",
      "meaning": "Logical and consistent.",
      "level": "Beginner",
      "example":
          "She gave a coherent explanation of the entire process.",
    },
    "Pragmatic": {
      "phonetic": "/præɡˈmætɪk/",
      "meaning": "Dealing with things sensibly and realistically.",
      "level": "Advanced",
      "example":
          "We need a pragmatic approach to solve this budget issue.",
    },
  };

  static const Map<String, Color> _levelColors = {
    "Intermediate": Colors.orange,
    "Advanced": Colors.purple,
    "Beginner": Colors.green,
  };

  // Pronunciation action
  void _playPronunciation(String word) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing pronunciation for "$word"...'),
      ),
    );

    // TODO:
    // Connect a real text-to-speech package here later.
    // Example package: flutter_tts
  }

  // Open word details
  void _openWordDetail(String word) {
    final details = _words[word];

    if (details == null) {
      return;
    }

    final String level = details["level"] ?? "Beginner";
    final Color levelColor = _levelColors[level] ?? navy;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        word,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _playPronunciation(word),
                      icon: const Icon(
                        Icons.volume_up_rounded,
                        color: navy,
                        size: 26,
                      ),
                    ),
                  ],
                ),

                Text(
                  details["phonetic"] ?? "",
                  style: const TextStyle(
                    color: subtitleBlue,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  details["meaning"] ?? "",
                  style: const TextStyle(
                    color: navy,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: levelColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    level,
                    style: TextStyle(
                      color: levelColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Example",
                  style: TextStyle(
                    color: subtitleBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '"${details["example"] ?? ""}"',
                  style: const TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Got it",
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

  // Practice quiz action
  void _startPracticeQuiz() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Starting practice quiz..."),
      ),
    );

    // TODO:
    // Connect this button to the actual vocabulary quiz screen later.
    // Example:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => const PracticeQuizScreen(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: navy,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Vocabulary Builder",
          style: TextStyle(
            color: navy,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      // ---------------- BODY ----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------- TODAY'S PROGRESS --------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Today's Progress",
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "12 / 20 words",
                  style: TextStyle(
                    color: brandRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(
                value: 0.6,
                minHeight: 8,
                backgroundColor: Color(0xFFEEEEEE),
                valueColor: AlwaysStoppedAnimation<Color>(brandRed),
              ),
            ),

            const SizedBox(height: 35),

            // -------- AI PICK --------
            const Text(
              "AI Pick for You",
              style: TextStyle(
                color: navy,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _buildWordCard(
              "Resilient",
              "/rɪˈzilyənt/",
              "Able to withstand or recover quickly from difficult conditions.",
              "Intermediate",
              Colors.orange,
            ),

            const SizedBox(height: 35),

            // -------- NEW WORDS --------
            const Text(
              "New Words to Master",
              style: TextStyle(
                color: navy,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _buildListItem(
              "Eloquence",
              "Fluent or persuasive speaking.",
              "Advanced",
              Colors.purple,
            ),

            _buildListItem(
              "Coherent",
              "Logical and consistent.",
              "Beginner",
              Colors.green,
            ),

            _buildListItem(
              "Pragmatic",
              "Dealing with things sensibly.",
              "Advanced",
              Colors.purple,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // ---------------- PRACTICE BUTTON ----------------
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _startPracticeQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Start Practice Quiz",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- AI WORD CARD ----------------
  Widget _buildWordCard(
    String word,
    String phonetic,
    String meaning,
    String level,
    Color levelColor,
  ) {
    return GestureDetector(
      onTap: () => _openWordDetail(word),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: navy,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: brandRed.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    word,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () => _playPronunciation(word),
                  icon: const Icon(
                    Icons.volume_up_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),

            Text(
              phonetic,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              meaning,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: levelColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                level,
                style: TextStyle(
                  color: levelColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- WORD LIST ITEM ----------------
  Widget _buildListItem(
    String word,
    String meaning,
    String level,
    Color levelColor,
  ) {
    return GestureDetector(
      onTap: () => _openWordDetail(word),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFFF2F4F7),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word,
                    style: const TextStyle(
                      color: navy,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    meaning,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: subtitleBlue,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Text(
              level,
              style: TextStyle(
                color: levelColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(width: 10),

            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}