import 'dart:convert';
import 'package:http/http.dart' as http;

class GoBackendService {
  // Base URL for Go Gin Backend
  static const String baseUrl = 'http://localhost:8080/api/v1';

  // 1. Health Check
  static Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 2. Fetch All Live Courses
  static Future<List<dynamic>> fetchCourses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/courses'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['courses'] ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 3. Generate Lesson MP3 Audio (TTS)
  static Future<Map<String, dynamic>> generateLessonAudio(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/media/tts/mp3'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'error': 'Failed with status ${response.statusCode}'};
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // 4. Synthesize AI 2D Animation Video
  static Future<Map<String, dynamic>> synthesizeLessonVideo(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/media/synthesize/video'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt, 'style': '2d_animation'}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'error': 'Failed with status ${response.statusCode}'};
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}