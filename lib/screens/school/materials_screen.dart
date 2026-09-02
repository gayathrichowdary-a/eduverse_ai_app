import 'package:flutter/material.dart';
import 'lecture_notes_screen.dart';
import 'video_tutorials_screen.dart';

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  static const Color navy = Color(0xFF1F355C);

  // Initial Grid Data
  final List<Map<String, dynamic>> materials = [
    {"title": "Lecture Notes", "icon": Icons.description, "color": Colors.blue},
    {"title": "Video Tutorials", "icon": Icons.play_circle_fill, "color": Colors.red},
  ];

  final TextEditingController materialController = TextEditingController();

  void _addMaterialDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Add Learning Material", style: TextStyle(color: navy, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: materialController,
          decoration: const InputDecoration(labelText: "Material Name", hintText: "e.g. Revision PDF"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: navy),
            onPressed: () {
              if (materialController.text.isNotEmpty) {
                setState(() {
                  materials.add({
                    "title": materialController.text,
                    "icon": Icons.folder_shared_rounded, // Default icon
                    "color": Colors.purple,
                  });
                });
                materialController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _onTileTap(String title) {
    if (title == "Lecture Notes") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LectureNotesScreen()),
      );
    } else if (title == "Video Tutorials") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VideoTutorialsScreen()),
      );
    } else {
      // Custom materials added via the dialog don't have a screen yet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$title screen coming soon")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: navy, title: const Text("Study Materials")),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
        ),
        itemCount: materials.length,
        itemBuilder: (context, index) {
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _onTileTap(materials[index]['title']),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(materials[index]['icon'], color: materials[index]['color'], size: 45),
                  const SizedBox(height: 10),
                  Text(materials[index]['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: navy,
        onPressed: _addMaterialDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}