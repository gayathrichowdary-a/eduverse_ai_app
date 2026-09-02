import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // Simple demo data: day number -> status ('present', 'absent', 'none')
  final Map<int, String> attendance = {
    1: "present", 2: "present", 3: "present", 4: "absent", 5: "present",
    6: "none", 7: "none",
    8: "present", 9: "present", 10: "present", 11: "present", 12: "present",
    13: "none", 14: "none",
    15: "present", 16: "absent", 17: "present", 18: "present", 19: "present",
    20: "none", 21: "none",
    22: "present", 23: "present", 24: "present", 25: "present", 26: "present",
    27: "none", 28: "none",
    29: "present", 30: "present", 31: "present",
  };

  final String monthLabel = "July 2026";
  final int daysInMonth = 31;
  final int startWeekday = 3; // 1=Mon .. 7=Sun (July 1, 2026 is a Wednesday)

  @override
  Widget build(BuildContext context) {
    final int presentCount =
        attendance.values.where((v) => v == "present").length;
    final int absentCount =
        attendance.values.where((v) => v == "absent").length;
    final int totalMarked = presentCount + absentCount;
    final double percent =
        totalMarked == 0 ? 0 : (presentCount / totalMarked) * 100;

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
                    "Attendance",
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

                      //================ SUMMARY CARD =================

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF1F355C),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFF57B97A),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.event_available,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${percent.toStringAsFixed(0)}%",
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F355C),
                                  ),
                                ),
                                const Text(
                                  "Attendance this month",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF5E6D7A),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      //================ CALENDAR =================

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF1F355C),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              monthLabel,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F355C),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Weekday headers
                            Row(
                              children: const [
                                _WeekdayLabel("M"),
                                _WeekdayLabel("T"),
                                _WeekdayLabel("W"),
                                _WeekdayLabel("T"),
                                _WeekdayLabel("F"),
                                _WeekdayLabel("S"),
                                _WeekdayLabel("S"),
                              ],
                            ),

                            const SizedBox(height: 8),

                            GridView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                mainAxisSpacing: 6,
                                crossAxisSpacing: 6,
                              ),
                              itemCount: daysInMonth + (startWeekday - 1),
                              itemBuilder: (context, index) {
                                final int dayNum =
                                    index - (startWeekday - 2);

                                if (dayNum < 1 || dayNum > daysInMonth) {
                                  return const SizedBox();
                                }

                                final String status =
                                    attendance[dayNum] ?? "none";

                                Color bgColor;
                                Color textColor;

                                switch (status) {
                                  case "present":
                                    bgColor = const Color(0xFF9BE3A6);
                                    textColor = const Color(0xFF1F5C33);
                                    break;
                                  case "absent":
                                    bgColor = const Color(0xFFE94A56);
                                    textColor = Colors.white;
                                    break;
                                  default:
                                    bgColor = const Color(0xFFF0F0F0);
                                    textColor = const Color(0xFF5E6D7A);
                                }

                                return Container(
                                  decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "$dayNum",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                _LegendDot(
                                  color: const Color(0xFF9BE3A6),
                                  label: "Present",
                                ),
                                const SizedBox(width: 16),
                                _LegendDot(
                                  color: const Color(0xFFE94A56),
                                  label: "Absent",
                                ),
                                const SizedBox(width: 16),
                                _LegendDot(
                                  color: const Color(0xFFF0F0F0),
                                  label: "Holiday/Weekend",
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

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

class _WeekdayLabel extends StatelessWidget {
  final String label;
  const _WeekdayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF5E6D7A),
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF5E6D7A),
          ),
        ),
      ],
    );
  }
}