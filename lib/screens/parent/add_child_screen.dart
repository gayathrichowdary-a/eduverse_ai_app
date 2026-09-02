import 'package:flutter/material.dart';

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();

  String selectedGrade = "Grade 1";
  final List<String> grades = List.generate(12, (i) => "Grade ${i + 1}");

  @override
  void dispose() {
    nameController.dispose();
    schoolController.dispose();
    super.dispose();
  }

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
                    "Add Child",
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

                      //================ AVATAR PLACEHOLDER =================

                      Center(
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF1F355C),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.add_a_photo_outlined,
                            color: Color(0xFF1F355C),
                            size: 28,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      //================ NAME FIELD =================

                      const Text(
                        "Child's Name",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F355C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF1F355C),
                            width: 2,
                          ),
                        ),
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: "e.g. Arjun Mehta",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      //================ GRADE DROPDOWN =================

                      const Text(
                        "Grade",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F355C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF1F355C),
                            width: 2,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedGrade,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: Color(0xFF1F355C)),
                            items: grades.map((g) {
                              return DropdownMenuItem(
                                value: g,
                                child: Text(g),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedGrade = value!;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      //================ SCHOOL FIELD =================

                      const Text(
                        "School Name",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F355C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF1F355C),
                            width: 2,
                          ),
                        ),
                        child: TextField(
                          controller: schoolController,
                          decoration: const InputDecoration(
                            hintText: "e.g. Greenwood High School",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                    ],
                  ),
                ),
              ),
            ),

            //================ SAVE BUTTON =================

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
                    if (nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter the child's name"),
                        ),
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${nameController.text} added successfully",
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
                    "Save Child",
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