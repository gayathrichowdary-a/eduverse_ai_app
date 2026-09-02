import 'package:flutter/material.dart';

class VideoTutorialsScreen extends StatefulWidget {
  const VideoTutorialsScreen({super.key});

  @override
  State<VideoTutorialsScreen> createState() => _VideoTutorialsScreenState();
}

class _VideoTutorialsScreenState extends State<VideoTutorialsScreen> {
  static const Color navy = Color(0xFF1F355C);

  // Dummy Data - later this will come from your database
  final List<Map<String, String>> videos = [
    {"title": "Newton's Laws Explained", "duration": "12:34"},
    {"title": "Intro to Thermodynamics", "duration": "18:02"},
  ];

  final TextEditingController titleController = TextEditingController();

  void _addVideoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Add Video Tutorial", style: TextStyle(color: navy, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: "Video title", hintText: "e.g. Waves and Sound"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: navy),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  videos.add({
                    "title": titleController.text,
                    "duration": "--:--",
                  });
                });
                titleController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: navy,
        title: const Text("Video Tutorials", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: videos.isEmpty
          ? const Center(child: Text("No videos added yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.play_arrow, color: Colors.white),
                    ),
                    title: Text(videos[index]['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(videos[index]['duration']!),
                    onTap: () {
                      // Later: open a video player or launch external URL here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Playing ${videos[index]['title']}...")),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: navy,
        onPressed: _addVideoDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}