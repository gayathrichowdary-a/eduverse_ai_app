import 'package:flutter/material.dart';

class TopicListScreen extends StatefulWidget {
  const TopicListScreen({super.key});

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  static const Color navy = Color(0xFF1F355C);

  // Initial Data List
  final List<Map<String, dynamic>> topics = [
    {"title": "Chapter 1: Newton's Laws", "count": "5 Topics", "color": Colors.green},
    {"title": "Chapter 2: Thermodynamics", "count": "8 Topics", "color": Colors.orange},
  ];

  final TextEditingController topicController = TextEditingController();

  void _addTopicDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Add New Topic", style: TextStyle(color: navy, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: topicController,
          decoration: const InputDecoration(labelText: "Topic/Chapter Name", hintText: "e.g. Chapter 4: Light"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: navy),
            onPressed: () {
              if (topicController.text.isNotEmpty) {
                setState(() {
                  topics.add({
                    "title": topicController.text,
                    "count": "0 Topics",
                    "color": Colors.blue, // Default color for new topics
                  });
                });
                topicController.clear();
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
      appBar: AppBar(backgroundColor: navy, title: const Text("Topics & Chapters")),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: navy, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.topic_rounded, color: topics[index]['color'], size: 30),
                const SizedBox(width: 15),
                Expanded(child: Text(topics[index]['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                Text(topics[index]['count'], style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: navy,
        onPressed: _addTopicDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}