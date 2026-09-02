import 'package:flutter/material.dart';

class CompetitiveExamCoachScreen extends StatelessWidget {
  const CompetitiveExamCoachScreen({super.key});

  static const Color navy = Color(0xFF14213D);
  static const Color red = Color(0xFFE53950);
  static const Color blue = Color(0xFF4D86AD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Competitive Exam Coach",
          style: TextStyle(
            color: navy,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Reading List",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),

            const SizedBox(height: 16),

            _readingCard(
              "Physics Formula Sheet",
              "Complete revision",
              Icons.menu_book,
            ),

            const SizedBox(height: 14),

            _readingCard(
              "Mathematics Short Notes",
              "High Priority",
              Icons.calculate,
            ),

            const SizedBox(height: 14),

            _readingCard(
              "Chemistry Mind Maps",
              "Quick Revision",
              Icons.science,
            ),

            const SizedBox(height: 30),

            const Text(
              "Focus Areas",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                Chip(
                  label: Text("Mechanics"),
                  backgroundColor: Color(0xFFEAF4FF),
                ),
                Chip(
                  label: Text("Algebra"),
                  backgroundColor: Color(0xFFEAF4FF),
                ),
                Chip(
                  label: Text("Organic Chemistry"),
                  backgroundColor: Color(0xFFEAF4FF),
                ),
                Chip(
                  label: Text("Logical Reasoning"),
                  backgroundColor: Color(0xFFEAF4FF),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Progress Chart",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [

                  _progressRow("Physics", 0.75),

                  const SizedBox(height: 18),

                  _progressRow("Mathematics", 0.60),

                  const SizedBox(height: 18),

                  _progressRow("Chemistry", 0.82),

                  const SizedBox(height: 18),

                  _progressRow("Reasoning", 0.45),

                ],
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Start Practice Clicked"),
                    ),
                  );

                },
                child: const Text(
                  "Start Practice",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Complete Analysis Clicked"),
                    ),
                  );

                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: blue,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Complete Analysis",
                  style: TextStyle(
                    color: blue,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _readingCard(
      String title,
      String subtitle,
      IconData icon,
      ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [

          CircleAvatar(
            backgroundColor: const Color(0xFFEAF4FF),
            child: Icon(icon, color: blue),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: navy,
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _progressRow(String subject, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              subject,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("${(value * 100).toInt()}%"),
          ],
        ),

        const SizedBox(height: 8),

        LinearProgressIndicator(
          value: value,
          minHeight: 10,
          borderRadius: BorderRadius.circular(20),
          backgroundColor: Colors.grey.shade300,
          valueColor: const AlwaysStoppedAnimation(red),
        ),
      ],
    );
  }
}