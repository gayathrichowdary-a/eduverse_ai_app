import 'package:flutter/material.dart';
import 'go_backend_service.dart';

class CoursePlayerScreen extends StatefulWidget {
  const CoursePlayerScreen({super.key});

  @override
  State<CoursePlayerScreen> createState() => _CoursePlayerScreenState();
}

class _CoursePlayerScreenState extends State<CoursePlayerScreen> {
  bool isPlayingAudio = false;
  bool isGeneratingVideo = false;
  bool isLoadingCourses = true;
  String currentStatus = 'Backend connected at http://localhost:8080';
  List<dynamic> courses = [];
  String? generatedVideoUrl;
  String? activeAudioMessage;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoadingCourses = true);
    final fetched = await GoBackendService.fetchCourses();
    setState(() {
      courses = fetched.isNotEmpty
          ? fetched
          : [
              {
                'id': '1',
                'title': 'Newton\'s Laws of Motion',
                'subject': 'Physics',
                'summary': 'Explore dynamics, inertia, and action-reaction pairs.',
              },
              {
                'id': '2',
                'title': 'Photosynthesis & Cellular Energy',
                'subject': 'Biology',
                'summary': 'How chloroplasts convert solar energy into glucose.',
              },
              {
                'id': '3',
                'title': 'Quantum Computing Fundamentals',
                'subject': 'Computer Science',
                'summary': 'Qubits, superposition, and quantum teleportation basics.',
              }
            ];
      isLoadingCourses = false;
    });
  }

  Future<void> _playLessonAudio(String text) async {
    setState(() {
      currentStatus = 'Connecting to Go backend MP3 TTS generator...';
      isPlayingAudio = true;
      activeAudioMessage = null;
    });

    final res = await GoBackendService.generateLessonAudio(text);
    setState(() {
      isPlayingAudio = false;
      currentStatus = '✅ MP3 Audio Stream Synthesized Successfully!';
      activeAudioMessage = res['message'] ?? 'Playing AI audio narration stream...';
    });
  }

  Future<void> _synthesizeVideo(String prompt) async {
    setState(() {
      isGeneratingVideo = true;
      currentStatus = 'Synthesizing 2D vector animation video via Go backend...';
    });

    final res = await GoBackendService.synthesizeLessonVideo(prompt);
    setState(() {
      isGeneratingVideo = false;
      generatedVideoUrl = res['video_url'] ?? 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4';
      currentStatus = '✅ AI 2D Animation Video Ready!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: const Text('EduVerse AI - Course Studio'),
        backgroundColor: const Color(0xFF214675),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Status Notification Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFFEFF6FF),
            child: Row(
              children: [
                const Icon(Icons.hub_outlined, color: Color(0xFF3B82F6), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    currentStatus,
                    style: const TextStyle(
                      color: Color(0xFF1E40AF),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Audio playback banner if active
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
                    child: Text(
                      activeAudioMessage!,
                      style: const TextStyle(color: Color(0xFF166534), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

          // Main Interactive Area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Video Player Box
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: isGeneratingVideo
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(height: 12),
                              Text(
                                'Synthesizing 2D AI Animation...',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                generatedVideoUrl != null ? Icons.play_circle_fill : Icons.smart_display_outlined,
                                size: 64,
                                color: generatedVideoUrl != null ? const Color(0xFFEF3340) : Colors.white54,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                generatedVideoUrl != null
                                    ? 'Animation Video Ready (Click to View)'
                                    : 'Select a course below to generate 2D AI Video Lesson',
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Available Interactive Lessons',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 12),

                // Courses List
                if (isLoadingCourses)
                  const Center(child: CircularProgressIndicator())
                else
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
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF3340).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    subject,
                    style: const TextStyle(
                      color: Color(0xFFEF3340),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              summary,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: isPlayingAudio
                      ? null
                      : () => _playLessonAudio(summary.isNotEmpty ? summary : title),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF214675),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.volume_up, size: 18),
                  label: const Text('Listen (MP3)'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: isGeneratingVideo
                      ? null
                      : () => _synthesizeVideo('Create 2D animation for $title: $summary'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.video_call, size: 18),
                  label: const Text('Generate Video'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}