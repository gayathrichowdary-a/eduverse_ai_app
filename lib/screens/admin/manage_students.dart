import 'package:flutter/material.dart';

class ManageStudents extends StatefulWidget {
  const ManageStudents({super.key});

  @override
  State<ManageStudents> createState() => _ManageStudentsState();
}

class _ManageStudentsState extends State<ManageStudents> {
  static const Color navy = Color(0xFF1D3B64);
  static const Color green = Color(0xFF57B97A);
  static const Color background = Color(0xFFF8F8F8);

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
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Text(
          'Manage Students',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Students',
            style: TextStyle(
              color: navy,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'View and manage student accounts.',
            style: TextStyle(color: Colors.grey),
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
                  border: Border.all(color: navy, width: 1.5),
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
                            style: const TextStyle(color: Colors.grey),
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