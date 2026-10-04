import 'package:flutter/material.dart';
import 'Lecture_Notes_Screen.dart';
import 'Video_Tutorials_Screen.dart';


final List<BoxShadow> _softShadow = [
  BoxShadow(
    color: const Color(0xFF0B2F63).withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 6),
  ),
];

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  static const Color navy = Color(0xFF0B2F63);

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
      appBar: AppBar(backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: const Color(0x1A0B2F63),
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(22))),
        iconTheme: const IconThemeData(color: navy),
        titleTextStyle: const TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.w800), title: const Text("Study Materials")),
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
                border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2),
                boxShadow: _softShadow,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(materials[index]['icon'], color: materials[index]['color'], size: 45),
                  const SizedBox(height: 10),
                  Text(materials[index]['title'], style: const TextStyle(fontWeight: FontWeight.w700, color: navy)),
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