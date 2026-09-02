import 'package:flutter/material.dart';

class LiveAIHunt extends StatelessWidget {
  const LiveAIHunt({super.key});

  final Color primaryBlue = const Color(0xff31527B);
  final Color lightBlue = const Color(0xff55C6E8);
  final Color cardBlue = const Color(0xffEAF8FC);
  final Color textBlue = const Color(0xff477FA6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 240, // Increased to make sure list clears the AI card
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),

                  // TOP BAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 55,
                          width: 55,
                          decoration: const BoxDecoration(
                            color: Color(0xffEEF2F5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: primaryBlue,
                            size: 28,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.search,
                        size: 35,
                        color: textBlue,
                      )
                    ],
                  ),

                  const SizedBox(height: 35),

                  // TITLE
                  Text(
                    "Fractions",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: primaryBlue,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Icon(Icons.school, color: textBlue, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        "Mathematics · Grade 6  •  7 Topics",
                        style: TextStyle(fontSize: 18, color: textBlue),
                      )
                    ],
                  ),

                  const SizedBox(height: 45),

                  // MASTERY CARD - FIXED: Removed fixed height
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: const Color(0xffDCCFD6),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 90,
                          width: 90,
                          child: CircularProgressIndicator(
                            value: 0.45,
                            strokeWidth: 12,
                            backgroundColor: Colors.white,
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xffE9344F),
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Chapter Mastery",
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "You've completed 3 of 7 topics. Keep it up!",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.workspace_premium,
                          color: Colors.amber,
                          size: 45,
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  Text(
                    "Learning Path",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),

                  const SizedBox(height: 25),

                  topicCard("Introduction", "10 mins", 0.8),
                  topicCard("Equivalent Fractions", "15 mins", 0.7),
                  topicCard("Improper Fractions", "12 mins", 0.6),
                  topicCard("Mixed Fractions", "18 mins", 0.1),
                  topicCard("Addition of Fractions", "25 mins", 0),
                  topicCard("Subtraction of Fractions", "25 mins", 0),
                  topicCard("Real Life Problems", "30 mins", 0),
                ],
              ),
            ),

            // ASK MENTOR BUTTON
            Positioned(
              right: 30,
              bottom: 180, // Moved up so it doesn't overlap AI card
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
                decoration: BoxDecoration(
                  color: const Color(0xffF0444E),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [
                    BoxShadow(blurRadius: 10, color: Colors.black26)
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.psychology, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      "Ask Mentor",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
            ),

            // AI HELP CARD - FIXED: Removed fixed height
            Positioned(
              bottom: 15,
              left: 25,
              right: 25,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          "AI",
                          style: TextStyle(
                            color: lightBlue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: Text(
                        "Need help with Mixed Fractions?\nI can explain it with pizza slices!",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff204B70),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // TOPIC CARD WIDGET - FIXED: Removed fixed height
  Widget topicCard(String title, String time, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xffEDF0F3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 65,
                width: 65,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: const Color(0xffF0F2F3),
                  valueColor: AlwaysStoppedAnimation(
                    progress == 0
                        ? const Color(0xffE8EDF0)
                        : const Color(0xff9EDDE0),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 25),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: textBlue,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: textBlue),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(fontSize: 16, color: textBlue),
                    )
                  ],
                )
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 25,
            color: const Color(0xffA7DCE3),
          )
        ],
      ),
    );
  }
}