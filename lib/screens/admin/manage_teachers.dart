import 'package:flutter/material.dart';

class ManageTeachers extends StatefulWidget {
  const ManageTeachers({super.key});

  @override
  State<ManageTeachers> createState() => _ManageTeachersState();
}

class _ManageTeachersState extends State<ManageTeachers> {
  static const Color navy = Color(0xFF1D3B64);
  static const Color red = Color(0xFFE94A56);
  static const Color background = Color(0xFFF8F8F8);

  final List<Map<String, dynamic>> teachers = [
    {
      'name': 'Anita Sharma',
      'subject': 'Mathematics',
      'status': 'Approved',
    },
    {
      'name': 'Rahul Kumar',
      'subject': 'Physics',
      'status': 'Pending',
    },
    {
      'name': 'Priya Reddy',
      'subject': 'Chemistry',
      'status': 'Approved',
    },
  ];

  void _changeStatus(int index) {
    setState(() {
      teachers[index]['status'] =
          teachers[index]['status'] == 'Approved'
              ? 'Pending'
              : 'Approved';
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
          'Manage Teachers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Teachers',
            style: TextStyle(
              color: navy,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Approve and oversee teacher accounts.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ...List.generate(
            teachers.length,
            (index) {
              final teacher = teachers[index];
              final approved = teacher['status'] == 'Approved';

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
                        color: red,
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
                            teacher['name'],
                            style: const TextStyle(
                              color: navy,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            teacher['subject'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            teacher['status'],
                            style: TextStyle(
                              color: approved
                                  ? const Color(0xFF57B97A)
                                  : const Color(0xFFF7C948),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _changeStatus(index),
                      icon: Icon(
                        approved
                            ? Icons.pause_circle_outline
                            : Icons.check_circle_outline,
                        color: approved ? red : const Color(0xFF57B97A),
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