import 'package:flutter/material.dart';

class SubjectFocusScreen extends StatefulWidget {
  const SubjectFocusScreen({super.key});

  @override
  State<SubjectFocusScreen> createState() => _SubjectFocusScreenState();
}

class _SubjectFocusScreenState extends State<SubjectFocusScreen> {
  final Map<String, bool> subjects = {
    "Math": true,
    "Physics": true,
    "Chemistry": false,
    "Biology": false,
    "English": false,
    "History": false,
    "Coding": false,
    "Career Prep": true,
  };

  @override
  Widget build(BuildContext context) {
    final selectedCount = subjects.values.where((v) => v).length;

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
                    "Subject Focus",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F355C),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Select subjects you want your AI Mentor to prioritize ($selectedCount selected)",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5E6D7A),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: subjects.keys.map((subject) {
                          final bool isSelected = subjects[subject]!;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                subjects[subject] = !isSelected;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFE94A56)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF1F355C),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSelected)
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(right: 6),
                                      child: Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  Text(
                                    subject,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF1F355C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedCount == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Please select at least one subject"),
                                ),
                              );
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "$selectedCount subjects saved as focus areas",
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE94A56),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "Save Focus Areas",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                    ],
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