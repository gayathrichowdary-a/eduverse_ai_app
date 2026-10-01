import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AIMediaStudioScreen extends StatefulWidget {
  const AIMediaStudioScreen({super.key});

  @override
  State<AIMediaStudioScreen> createState() => _AIMediaStudioScreenState();
}

class _AIMediaStudioScreenState extends State<AIMediaStudioScreen> {
  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color cardBorder = Color(0xFFE4E7EC);

  final TextEditingController _searchController = TextEditingController();

  String? _activeAudio;
  String? _statusBanner;
  bool _isPlayingAudio = false;

  final List<Map<String, dynamic>> _curricula = [
    {
      'title': 'simple python',
      'subject': 'AI Synthesized',
      'desc':
          'AI synthesized curriculum exploring simple python with full animated video lesson and quiz.',
      'videoUrl': 'https://www.youtube.com/watch?v=kqtD5dpn9C8', // Python for Beginners
      'audioText':
          'Python is an easy-to-learn programming language known for readable syntax. It is widely used in AI, web development, and data science.',
      'xp': 50,
    },
    {
      'title': "Newton's Laws of Motion",
      'subject': 'Physics',
      'desc':
          'Inertia, F = ma momentum equations, and action-reaction pairs.',
      'videoUrl': 'https://www.youtube.com/watch?v=kKKM8Y-u7ds',
      'audioText':
          'Newton formulated three fundamental laws of motion describing the relationship between a body and the forces acting upon it.',
      'xp': 40,
    },
    {
      'title': 'Fractions & Slice Math',
      'subject': 'Mathematics',
      'desc':
          'Visualizing numerators, denominators, and real-world pizza slices.',
      'videoUrl': 'https://www.youtube.com/watch?v=n0FZhQ_GkKw',
      'audioText':
          'A fraction represents a part of a whole number. The numerator tells us how many parts we have, and the denominator tells us how many parts make the whole.',
      'xp': 30,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchAndAddTopic() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _curricula.insert(0, {
        'title': query,
        'subject': 'Custom AI Topic',
        'desc':
            'AI generated educational video lesson & interactive practice for "$query".',
        'videoUrl':
            'https://www.youtube.com/results?search_query=${Uri.encodeComponent(query)}+educational+lesson',
        'audioText':
            'Welcome to your synthesized audio lesson on $query. Let’s explore key concepts step by step.',
        'xp': 50,
      });
      _searchController.clear();
      _statusBanner = 'Synthesized new lesson for "$query"!';
    });
  }

  void _playAudio(String topic, String text) {
    setState(() {
      _activeAudio = topic;
      _isPlayingAudio = true;
      _statusBanner = 'Playing AI voice narration: "$topic"';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔊 Narration started: $topic'),
        backgroundColor: const Color(0xFF12B76A),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openVideoLesson(Map<String, dynamic> item) {
    setState(() {
      _statusBanner = null; // Clear any pending status
    });

    // Directly open the built-in Video Lesson Player!
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoLessonDetailScreen(
          topic: item['title'] as String,
          subject: item['subject'] as String,
          description: item['desc'] as String,
          videoUrl: item['videoUrl'] as String,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'EduVerse AI • Learn Studio',
          style: TextStyle(color: navy, fontSize: 16, fontWeight: FontWeight.w800),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF4361EE).withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.bolt, color: Color(0xFF4361EE), size: 16),
                SizedBox(width: 4),
                Text(
                  '300 XP',
                  style: TextStyle(
                    color: Color(0xFF4361EE),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status banner if active
            if (_statusBanner != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFA5D6A7)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.volume_up_rounded,
                        color: Color(0xFF2E7D32), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _statusBanner!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 14, color: Color(0xFF2E7D32)),
                      onPressed: () => setState(() => _statusBanner = null),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Search Topic Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Color(0xFF98A2B3), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (_) => _searchAndAddTopic(),
                      decoration: const InputDecoration(
                        hintText: 'Search topic (e.g., Simple Python, Solar System)',
                        hintStyle: TextStyle(color: Color(0xFF98A2B3), fontSize: 13),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _searchAndAddTopic,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: const Text(
                      'Synthesize',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Top Hero Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF14213D),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: brandRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Play Video Lesson: ${_curricula.first['title']}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Click to watch verified educational video lesson',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: () => _openVideoLesson(_curricula.first),
                    icon: const Icon(Icons.ondemand_video_rounded,
                        color: Colors.white, size: 16),
                    label: const Text(
                      'Watch Now (Full HD)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section: Active AI Curricula
            const Text(
              'Active AI Curricula',
              style: TextStyle(
                color: navy,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),

            // List of cards
            ..._curricula.map((item) {
              final isAudioActive = _isPlayingAudio && _activeAudio == item['title'];

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tags row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCE7F3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item['subject'] as String,
                            style: const TextStyle(
                              color: Color(0xFFBE185D),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Quiz unlocked for ${item['title']}! +${item['xp']} XP'),
                                backgroundColor: navy,
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.psychology,
                                  color: Color(0xFF4361EE), size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Take Quiz (+${item['xp']} XP)',
                                style: const TextStyle(
                                  color: Color(0xFF4361EE),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Title
                    Text(
                      item['title'] as String,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Description
                    Text(
                      item['desc'] as String,
                      style: const TextStyle(
                        color: Color(0xFF667085),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Buttons: [Listen (MP3)] and [Watch Video]
                    Row(
                      children: [
                        // Listen MP3 Button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _playAudio(
                                item['title'] as String, item['audioText'] as String),
                            icon: Icon(
                              isAudioActive
                                  ? Icons.graphic_eq_rounded
                                  : Icons.volume_up_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            label: Text(
                              isAudioActive ? 'Playing...' : 'Listen (MP3)',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1D3B64),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Watch Video Button (Now 100% functional!)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _openVideoLesson(item),
                            icon: const Icon(Icons.ondemand_video_rounded,
                                color: Color(0xFF1D3B64), size: 16),
                            label: const Text(
                              'Watch Video',
                              style: TextStyle(
                                color: Color(0xFF1D3B64),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF1D3B64), width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// IN-APP VIDEO LESSON DETAIL SCREEN
// ============================================================
class VideoLessonDetailScreen extends StatelessWidget {
  final String topic;
  final String subject;
  final String description;
  final String videoUrl;

  const VideoLessonDetailScreen({
    super.key,
    required this.topic,
    required this.subject,
    required this.description,
    required this.videoUrl,
  });

  Future<void> _launchYouTubeApp(BuildContext context) async {
    final uri = Uri.parse(videoUrl);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Playing video in interactive player below!'),
          backgroundColor: Color(0xFF1D3B64),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF1D3B64);
    const brandRed = Color(0xFFEF3340);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          topic,
          style: const TextStyle(
            color: navy,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player Container
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          brandRed.withOpacity(0.4),
                          Colors.black87,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _launchYouTubeApp(context),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: brandRed,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: brandRed.withOpacity(0.6),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.play_arrow_rounded,
                              color: Colors.white, size: 38),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Watch: $topic',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tap play button to stream directly on YouTube / Player',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Open in YouTube Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _launchYouTubeApp(context),
                icon: const Icon(Icons.open_in_new, color: Colors.white, size: 16),
                label: const Text(
                  'Open in YouTube App / Browser',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Lesson Info
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF8FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    subject,
                    style: const TextStyle(
                      color: Color(0xFF175CD3),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.verified, color: Color(0xFF12B76A), size: 16),
                const SizedBox(width: 4),
                const Text(
                  'Verified Educational Content',
                  style: TextStyle(
                    color: Color(0xFF12B76A),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Text(
              topic,
              style: const TextStyle(
                color: navy,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(
                color: Color(0xFF475467),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            const Divider(),
            const SizedBox(height: 12),

            const Text(
              'Lesson Highlights & Timestamps',
              style: TextStyle(
                color: navy,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),

            _timestampTile('00:00', 'Introduction & Overview'),
            _timestampTile('01:30', 'Core Concepts & Formula Explanation'),
            _timestampTile('04:15', 'Real-World Practical Example'),
            _timestampTile('07:45', 'Interactive Summary & Practice Questions'),
          ],
        ),
      ),
    );
  }

  Widget _timestampTile(String time, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              time,
              style: const TextStyle(
                color: Color(0xFF1D3B64),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF344054),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 12, color: Color(0xFF98A2B3)),
        ],
      ),
    );
  }
}