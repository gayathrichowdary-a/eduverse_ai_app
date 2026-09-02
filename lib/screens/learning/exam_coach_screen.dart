import 'package:flutter/material.dart';
import 'competitive_exam_coach_screen.dart';
class ExamCoachScreen extends StatelessWidget {
  const ExamCoachScreen({super.key});

  static const Color navy = Color(0xFF14213D);
  static const Color blue = Color(0xFF4D86AD);
  static const Color red = Color(0xFFE8394A);
  static const Color yellow = Color(0xFFF9D65C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: navy),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          "Exam Coach",
          style: TextStyle(
            color: navy,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: yellow,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [

                        Text(
                          "Your JEE Readiness",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: navy,
                          ),
                        ),

                        SizedBox(height:8),

                        Text(
                          "78%",
                          style: TextStyle(
                            fontSize:42,
                            fontWeight: FontWeight.bold,
                            color:red,
                          ),
                        ),

                        SizedBox(height:6),

                        Text(
                          "Based on your recent practice",
                          style: TextStyle(
                            color: navy,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const CircleAvatar(
                    radius:45,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.school,
                      color:red,
                      size:45,
                    ),
                  )

                ],
              ),
            ),

            const SizedBox(height:25),

            Row(
              children: [

                Expanded(
                  child: _infoCard(
                    "Accuracy",
                    "82%",
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),

                const SizedBox(width:15),

                Expanded(
                  child: _infoCard(
                    "Global Rank",
                    "#254",
                    Icons.leaderboard,
                    Colors.orange,
                  ),
                )

              ],
            ),

            const SizedBox(height:25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [

                  Text(
                    "AI Mentor Tip",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:20,
                      color:navy,
                    ),
                  ),

                  SizedBox(height:12),

                  Text(
                    "Focus more on Organic Chemistry and Time & Work. "
                    "Your performance has improved by 15% this week.",
                    style: TextStyle(
                      fontSize:16,
                      color:Colors.black87,
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height:30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Available Tests",
                style: TextStyle(
                  fontSize:22,
                  fontWeight: FontWeight.bold,
                  color:navy,
                ),
              ),
            ),

            const SizedBox(height:15),

            _testTile(
              context,
              "JEE Main Mock Test",
              "30 Questions • 30 Minutes",
            ),

            const SizedBox(height:15),

            _testTile(
              context,
              "Physics Practice",
              "20 Questions",
            ),

            const SizedBox(height:15),

            _testTile(
              context,
              "Mathematics Quiz",
              "25 Questions",
            ),

            const SizedBox(height:30),

            SizedBox(
              width: double.infinity,
              height:55,
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor:red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                onPressed:(){

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const CompetitiveExamCoachScreen(),
                    ),
                  );

                },

                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontSize:18,
                    color:Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),
            )

          ],
        ),
      ),
    );
  }

  Widget _infoCard(
      String title,
      String value,
      IconData icon,
      Color color){

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [

          Icon(icon,color:color,size:35),

          const SizedBox(height:10),

          Text(
            value,
            style: const TextStyle(
              fontSize:28,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(title),

        ],
      ),
    );
  }

  Widget _testTile(
      BuildContext context,
      String title,
      String subtitle){

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [

          const Icon(Icons.assignment,color:red),

          const SizedBox(width:15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:18,
                  ),
                ),

                Text(subtitle),

              ],
            ),
          ),

          ElevatedButton(
            onPressed:(){},
            child: const Text("Start"),
          )

        ],
      ),
    );
  }
}