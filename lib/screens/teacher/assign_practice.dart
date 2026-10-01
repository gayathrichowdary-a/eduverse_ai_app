import 'package:flutter/material.dart';

// NEW: soft card shadow used across the restyled screens
final List<BoxShadow> _softShadow = [
  BoxShadow(
    color: const Color(0xFF0B2F63).withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 6),
  ),
];

class AssignPractice extends StatefulWidget {
  const AssignPractice({super.key});

  @override
  State<AssignPractice> createState() => _AssignPracticeState();
}

class _AssignPracticeState extends State<AssignPractice> {
  // Track which students are selected
  final Map<String, bool> students = {
    "Arjun Mehta": true,
    "Sana Khan": true,
    "Rohan Das": true,
    "Priya Sharma": false,
    "Rohan Gupta": false,
  };

  String selectedTopic = "Photosynthesis";
  final List<String> topics = [
    "Photosynthesis",
    "Quadratic Equations",
    "Organic Chemistry",
    "World War II",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FD),
      body: SafeArea(
        child: Column(
          children: [

            //================ HEADER =================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              decoration: BoxDecoration(
                color: Colors.white, // CHANGED: yellow -> white
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                boxShadow: _softShadow,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2), // CHANGED
        boxShadow: _softShadow,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF0B2F63),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    "Assign Practice",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0B2F63),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //================ TOPIC SELECTION =================

                      const Text(
                        "Select Topic",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B2F63),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2), // CHANGED
        boxShadow: _softShadow,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedTopic,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: Color(0xFF0B2F63)),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0B2F63),
                            ),
                            items: topics.map((t) {
                              return DropdownMenuItem(
                                value: t,
                                child: Text(t),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedTopic = value!;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 26),

                      //================ STUDENT SELECTION =================

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Select Students",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B2F63),
                            ),
                          ),
                          Text(
                            "${students.values.where((v) => v).length} selected",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5E6D7A),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      ...students.keys.map((name) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2), // CHANGED
        boxShadow: _softShadow,
                            ),
                            child: CheckboxListTile(
                              value: students[name],
                              onChanged: (value) {
                                setState(() {
                                  students[name] = value!;
                                });
                              },
                              controlAffinity:
                                  ListTileControlAffinity.leading,
                              activeColor: const Color(0xFFF12C68),
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0B2F63),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 20),

                    ],
                  ),
                ),
              ),
            ),

            //================ ASSIGN BUTTON =================

            Container(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final selectedCount =
                        students.values.where((v) => v).length;

                    if (selectedCount == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Please select at least one student"),
                        ),
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "$selectedTopic assigned to $selectedCount student(s)",
                        ),
                      ),
                    );

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF12C68),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // CHANGED
                    ),
                  ),
                  child: const Text(
                    "Assign Practice Set",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}