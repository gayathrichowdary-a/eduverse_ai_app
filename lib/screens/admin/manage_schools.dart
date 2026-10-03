import 'package:flutter/material.dart';

// NEW: soft card shadow used across the restyled screens
final List<BoxShadow> _softShadow = [
  BoxShadow(
    color: const Color(0xFF0B2F63).withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 6),
  ),
];

class ManageSchools extends StatefulWidget {
  const ManageSchools({super.key});

  @override
  State<ManageSchools> createState() => _ManageSchoolsState();
}

class _ManageSchoolsState extends State<ManageSchools> {
  static const Color navy = Color(0xFF0B2F63);
  static const Color blue = Color(0xFF58C7F3);
  static const Color background = Color(0xFFF6F5FD);

  final List<Map<String, String>> schools = [
    {
      'name': 'Nalla Malla Reddy School',
      'location': 'Hyderabad',
      'students': '850',
    },
    {
      'name': 'Sri Vidya High School',
      'location': 'Secunderabad',
      'students': '620',
    },
    {
      'name': 'Future Scholars School',
      'location': 'Warangal',
      'students': '540',
    },
  ];

  void _addSchool() {
    final nameController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Add School',
            style: TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'School Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  setState(() {
                    schools.add({
                      'name': nameController.text.trim(),
                      'location': locationController.text.trim(),
                      'students': '0',
                    });
                  });
                }

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5), // CHANGED
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _deleteSchool(int index) {
    setState(() {
      schools.removeAt(index);
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
          'Manage Schools',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSchool,
        backgroundColor: const Color(0xFF4F46E5), // CHANGED
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Schools',
            style: TextStyle(
              color: navy,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add, edit, or remove schools from the platform.',
            style: TextStyle(color: Color(0xFF7B8798)),
          ),
          const SizedBox(height: 20),
          ...List.generate(
            schools.length,
            (index) {
              final school = schools[index];

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
                        color: blue,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.school,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            school['name']!,
                            style: const TextStyle(
                              color: navy,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            school['location']!,
                            style: const TextStyle(color: Color(0xFF7B8798)),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${school['students']} students',
                            style: const TextStyle(color: blue),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _deleteSchool(index),
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