import 'package:flutter/material.dart';

// NEW: soft card shadow used across the restyled screens
final List<BoxShadow> _softShadow = [
  BoxShadow(
    color: const Color(0xFF0B2F63).withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 6),
  ),
];

class ManageStudents extends StatefulWidget {
  const ManageStudents({super.key});

  @override
  State<ManageStudents> createState() => _ManageStudentsState();
}

class _ManageStudentsState extends State<ManageStudents> {
  static const Color navy = Color(0xFF0B2F63);
  static const Color green = Color(0xFF57B97A);
  static const Color background = Color(0xFFF6F5FD);

  final List<Map<String, String>> students = [
    {
      'name': 'Arjun Reddy',
      'class': 'Grade 10',
      'score': '91%',
    },
    {
      'name': 'Sneha Patel',
      'class': 'Grade 9',
      'score': '87%',
    },
    {
      'name': 'Kiran Kumar',
      'class': 'Grade 10',
      'score': '94%',
    },
    {
      'name': 'Meghana Rao',
      'class': 'Grade 8',
      'score': '82%',
    },
  ];

  void _removeStudent(int index) {
    setState(() {
      students.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white, // CHANGED
        foregroundColor: const Color(0xFF0B2F63),
        elevation: 3,
        shadowColor: const Color(0x1A0B2F63),
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
        ),
        title: const Text(
          'Manage Students',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Students',
            style: TextStyle(
              color: navy,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'View and manage student accounts.',
            style: TextStyle(color: Color(0xFF7B8798)),
          ),
          const SizedBox(height: 20),
          ...List.generate(
            students.length,
            (index) {
              final student = students[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2), // CHANGED
        boxShadow: _softShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: green,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student['name']!,
                            style: const TextStyle(
                              color: navy,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            student['class']!,
                            style: const TextStyle(color: Color(0xFF7B8798)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Average Score: ${student['score']}',
                            style: const TextStyle(
                              color: green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _removeStudent(index),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFEF3340),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}