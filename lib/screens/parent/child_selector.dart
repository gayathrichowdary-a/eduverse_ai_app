import 'package:flutter/material.dart';

class ChildSelector extends StatelessWidget {
  const ChildSelector({super.key});

  static const Color navy = Color(0xFF1F355C);
  static const Color yellow = Color(0xFFFFD52E);

  // Dummy data - later this will come from your database (children linked to this parent)
  static final List<Map<String, String>> children = [
    {"initials": "AR", "name": "Arjun", "grade": "Grade 8", "status": "Active Now"},
    {"initials": "AK", "name": "Akhil", "grade": "Grade 5", "status": "Active Now"},
    {"initials": "SN", "name": "Sneha", "grade": "Grade 10", "status": "Offline"},
  ];

  // Change this to whichever child is currently selected on the dashboard
  static const String currentlySelected = "Arjun";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: yellow,
        elevation: 0,
        iconTheme: const IconThemeData(color: navy),
        title: const Text(
          "Select Child",
          style: TextStyle(color: navy, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: children.length,
        itemBuilder: (context, index) {
          final child = children[index];
          final bool isSelected = child['name'] == currentlySelected;

          return GestureDetector(
            onTap: () {
              // Returns the picked child back to the dashboard.
              // Later: use this to actually swap the dashboard's stats.
              Navigator.pop(context, child);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? yellow : navy,
                  width: isSelected ? 3 : 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: navy, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        child['initials']!,
                        style: const TextStyle(fontSize: 18, color: navy, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          child['name']!,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: navy),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${child['grade']} • ${child['status']}",
                          style: const TextStyle(fontSize: 13, color: Color(0xFF5E6D7A)),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle, color: navy)
                  else
                    const Icon(Icons.chevron_right_rounded, color: navy),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}