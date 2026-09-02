import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [

            //================ HEADER =================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              decoration: const BoxDecoration(
                color: Color(0xFFFFD52E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
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
                        border: Border.all(
                          color: const Color(0xFF1F355C),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1F355C),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    "Assign Practice",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F355C),
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
                          color: Color(0xFF1F355C),
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
                          border: Border.all(
                            color: const Color(0xFF1F355C),
                            width: 2,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedTopic,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: Color(0xFF1F355C)),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F355C),
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
                              color: Color(0xFF1F355C),
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
                              border: Border.all(
                                color: const Color(0xFF1F355C),
                                width: 2,
                              ),
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
                              activeColor: const Color(0xFFE94A56),
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1F355C),
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
                    backgroundColor: const Color(0xFFE94A56),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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