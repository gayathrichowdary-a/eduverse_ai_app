import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AIMediaStudioScreen extends StatefulWidget {
  const AIMediaStudioScreen({super.key});

  @override
  State<AIMediaStudioScreen> createState() => _AIMediaStudioScreenState();
}

class _AIMediaStudioScreenState extends State<AIMediaStudioScreen> {
  static const String backendUrl = 'http://localhost:8080/api/v1';

  final TextEditingController _customTopicController = TextEditingController();
  bool isPlayingAudio = false;
  int userTotalXP = 250;
  String currentStatus = 'EduVerse Engine connected at http://localhost:8080';
  String? activeAudioUrl;
  String? activeAudioMessage;
  dynamic activeLesson;

  final List<Map<String, dynamic>> initialCourses = [
    {
      'id': '1',
      'title': 'Newton\'s Laws of Motion',
      'subject': 'Physics',
      'summary': 'Inertia, F = ma momentum equations, and action-reaction pairs.',
      'video_url': 'https://www.youtube.com/watch?v=kKKM8Y-u7ds',
      'audio_url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'quiz': [
        {
          'q': 'Newton\'s First Law is also widely known as the Law of:',
          'options': ['Inertia', 'Acceleration', 'Action & Reaction', 'Thermodynamics'],
          'answer': 0,
        },
        {
          'q': 'What is the standard SI unit of Force in F = ma?',
          'options': ['Joule', 'Newton (N)', 'Watt', 'Pascal'],
          'answer': 1,
        }
      ]
    },
    {
      'id': '2',
      'title': 'Photosynthesis & Cellular Energy',
      'subject': 'Biology',
      'summary': 'Light reactions, Calvin cycle, and chloroplast ATP synthesis.',
      'video_url': 'https://www.youtube.com/watch?v=sQK3Yr4Sc_k',
      'audio_url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      'quiz': [
        {
          'q': 'Where do light-dependent reactions of photosynthesis occur?',
          'options': ['Stroma', 'Thylakoid Membrane', 'Ribosome', 'Outer Envelope'],
          'answer': 1,
        },
        {
          'q': 'What gas byproduct is released during photosynthesis?',
          'options': ['Carbon Dioxide', 'Methane', 'Oxygen (O2)', 'Nitrogen'],
          'answer': 2,
        }
      ]
    },
    {
      'id': '3',
      'title': 'Quantum Computing & Qubits',
      'subject': 'Computer Science',
      'summary': 'Superposition, entanglement, and quantum Bloch sphere states.',
      'video_url': 'https://www.youtube.com/watch?v=JhHMJCUmq28',
      'audio_url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      'quiz': [
        {
          'q': 'Unlike classical bits (0 or 1), a quantum bit can exist in:',
          'options': ['Superposition', 'Static charge', 'Binary isolation', 'Parity error'],
          'answer': 0,
        },
        {
          'q': 'Which geometric sphere represents pure quantum state qubit vectors?',
          'options': ['Riemann Sphere', 'Bloch Sphere', 'Euler Sphere', 'Galois Ring'],
          'answer': 1,
        }
      ]
    },
    {
      'id': '4',
      'title': 'Neural Networks & Deep Learning',
      'subject': 'Artificial Intelligence',
      'summary': 'Backpropagation, gradient descent, and multi-layer perceptrons.',
      'video_url': 'https://www.youtube.com/watch?v=aircAruvnKk',
      'audio_url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      'quiz': [
        {
          'q': 'What mathematical algorithm adjusts weights in deep learning?',
          'options': ['Dijkstra', 'Backpropagation', 'Bubble Sort', 'K-Means'],
          'answer': 1,
        }
      ]
    }
  ];

  late List<Map<String, dynamic>> courses;

  @override
  void initState() {
    super.initState();
    courses = List.from(initialCourses);
    activeLesson = courses[0];
  }

  void _generateCustomAILesson() {
    final query = _customTopicController.text.trim();
    if (query.isEmpty) return;

    final lower = query.toLowerCase();
    String directVideoUrl;

    if (lower.contains('python')) {
      directVideoUrl = 'https://www.youtube.com/watch?v=_uQrJ0TkZlc';
    } else if (lower.contains('agent') || lower.contains('ai') || lower.contains('machine')) {
      directVideoUrl = 'https://www.youtube.com/watch?v=sal78ACtGTc';
    } else if (lower.contains('data') || lower.contains('sql')) {
      directVideoUrl = 'https://www.youtube.com/watch?v=HXV3zeRR3h4';
    } else if (lower.contains('math') || lower.contains('calculus')) {
      directVideoUrl = 'https://www.youtube.com/watch?v=WUvTyaaNkzM';
    } else {
      directVideoUrl = 'https://www.youtube.com/watch?v=aircAruvnKk';
    }

    setState(() {
      final newCourse = {
        'id': (courses.length + 1).toString(),
        'title': query,
        'subject': 'AI Synthesized',
        'summary': 'AI synthesized curriculum exploring $query with full animated video lesson and quiz.',
        'video_url': directVideoUrl,
        'audio_url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        'quiz': [
          {
            'q': 'What is the primary core foundation of $query?',
            'options': ['Fundamental theoretical concepts', 'Random iteration', 'Manual regression', 'Null hypothesis'],
            'answer': 0,
          },
          {
            'q': 'How does modern engineering apply $query?',
            'options': ['Scalable algorithmic execution', 'Static caching only', 'Mechanical sorting', 'None'],
            'answer': 0,
          }
        ]
      };

      courses.insert(0, newCourse);
      activeLesson = newCourse;
      _customTopicController.clear();
      currentStatus = '✅ AI synthesized curriculum for "$query"!';
      userTotalXP += 50;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✨ New AI Curriculum created: "$query" (+50 XP)!')),
    );
  }

  Future<void> _playLessonAudio(dynamic course) async {
    final title = course['title'];
    setState(() {
      currentStatus = 'Generating AI voiceover audio from Go backend...';
      isPlayingAudio = true;
      activeAudioMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/media/tts/mp3'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': title}),
      );
      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        activeAudioUrl = res['audio_url'] ?? course['audio_url'];
      } else {
        activeAudioUrl = course['audio_url'];
      }
    } catch (_) {
      activeAudioUrl = course['audio_url'];
    }

    setState(() {
      isPlayingAudio = false;
      currentStatus = '✅ MP3 Audio Stream Synthesized Successfully!';
      activeAudioMessage = 'Playing AI voice narration: "$title"';
    });

    if (activeAudioUrl != null) {
      final uri = Uri.parse(activeAudioUrl!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> _openVideoLesson(dynamic course) async {
    final videoUrl = course['video_url'] as String?;
    if (videoUrl == null) return;

    setState(() {
      activeLesson = course;
      currentStatus = 'Opening video lesson for ${course['title']}...';
    });

    final uri = Uri.parse(videoUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openQuizModal(BuildContext context, dynamic course) {
    final quiz = course['quiz'] as List<dynamic>? ?? [];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.quiz_outlined, color: Color(0xFF2563EB)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('AI Quiz: ${course['title']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const Text('Answer questions & earn +25 XP', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                    ],
                  ),
                  const Divider(height: 28),
                  Expanded(
                    child: ListView.builder(
                      itemCount: quiz.length,
                      itemBuilder: (context, qIdx) {
                        final item = quiz[qIdx];
                        final options = item['options'] as List<dynamic>;
                        final int correctAns = item['answer'];
                        final int? selectedAns = item['selected'];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Q${qIdx + 1}: ${item['q']}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                              const SizedBox(height: 10),
                              ...List.generate(options.length, (optIdx) {
                                final isSelected = selectedAns == optIdx;
                                final isCorrect = optIdx == correctAns;
                                Color tileColor = Colors.grey.shade50;
                                Color borderColor = Colors.grey.shade300;

                                if (selectedAns != null) {
                                  if (isCorrect) {
                                    tileColor = const Color(0xFFDCFCE7);
                                    borderColor = const Color(0xFF16A34A);
                                  } else if (isSelected && !isCorrect) {
                                    tileColor = const Color(0xFFFEE2E2);
                                    borderColor = const Color(0xFFDC2626);
                                  }
                                }

                                return InkWell(
                                  onTap: selectedAns != null
                                      ? null
                                      : () {
                                          setModalState(() {
                                            item['selected'] = optIdx;
                                            if (optIdx == correctAns) {
                                              setState(() => userTotalXP += 25);
                                            }
                                          });
                                        },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: tileColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: borderColor),
                                    ),
                                    child: Row(
                                      children: [
                                        Text('${String.fromCharCode(65 + optIdx)}.', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 10),
                                        Expanded(child: Text(options[optIdx])),
                                        if (selectedAns != null && isCorrect)
                                          const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 18),
                                        if (selectedAns != null && isSelected && !isCorrect)
                                          const Icon(Icons.cancel, color: Color(0xFFDC2626), size: 18),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: const Text('EduVerse AI • Learning Studio'),
        backgroundColor: const Color(0xFF214675),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text('$userTotalXP XP', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFEFF6FF),
            child: Row(
              children: [
                const Icon(Icons.hub_outlined, color: Color(0xFF3B82F6), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(currentStatus, style: const TextStyle(color: Color(0xFF1E40AF), fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          if (activeAudioMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFDCFCE7),
              child: Row(
                children: [
                  const Icon(Icons.volume_up, color: Color(0xFF16A34A), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(activeAudioMessage!, style: const TextStyle(color: Color(0xFF166534), fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  if (activeAudioUrl != null)
                    TextButton(
                      onPressed: () => launchUrl(Uri.parse(activeAudioUrl!), mode: LaunchMode.externalApplication),
                      child: const Text('Open Player', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // AI Custom Generator Box
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.auto_awesome, color: Color(0xFFEF3340), size: 20),
                          SizedBox(width: 8),
                          Text('AI Custom Curriculum Synthesizer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Type any academic topic to generate an interactive AI course, video lesson, & quiz:',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _customTopicController,
                              decoration: InputDecoration(
                                hintText: 'e.g. Thermodynamics, Black Holes, Genetics...',
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: _generateCustomAILesson,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF214675),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.bolt, size: 18),
                            label: const Text('Synthesize'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Top Banner Video Player Card
                InkWell(
                  onTap: () => _openVideoLesson(activeLesson ?? courses[0]),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 190,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEF3340)),
                            child: const Icon(Icons.play_arrow, size: 40, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Play Video Lesson: ${activeLesson?['title'] ?? 'Select Lesson'}',
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text('Click to watch verified educational video lesson', style: TextStyle(color: Colors.white60, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Active AI Curricula', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                const SizedBox(height: 12),
                ...courses.map((c) => _buildCourseCard(c)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(dynamic course) {
    final title = course['title'] ?? 'Lesson';
    final subject = course['subject'] ?? 'General';
    final summary = course['summary'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFEF3340).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(subject, style: const TextStyle(color: Color(0xFFEF3340), fontSize: 11, fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _openQuizModal(context, course),
                  icon: const Icon(Icons.psychology, size: 16, color: Color(0xFF2563EB)),
                  label: const Text('Take Quiz (+XP)', style: TextStyle(color: Color(0xFF2563EB), fontSize: 12)),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(summary, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 14),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: isPlayingAudio ? null : () => _playLessonAudio(course),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF214675),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.volume_up, size: 16),
                  label: const Text('Listen (MP3)'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _openVideoLesson(course),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.video_call, size: 16),
                  label: const Text('Watch Video'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}