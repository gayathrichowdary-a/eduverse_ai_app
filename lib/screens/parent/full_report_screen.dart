import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
Future<void> generateAndOpenPdf(BuildContext context) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Arjun's Progress - Full Report",
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 16),

            pw.Text("Academic Summary",
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text("Math: 92% (up 5% this week)"),
            pw.Text("Science: 88% (up 2% this week)"),
            pw.Text("English: 78% (up 1% this week)"),
            pw.Text("Coding: 95% (up 8% this week)"),
            pw.SizedBox(height: 16),

            pw.Text("Term Overview",
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text("Overall Attendance: 96%"),
            pw.Text("Quizzes Taken: 24"),
            pw.Text("Avg. Quiz Score: A-"),
            pw.Text("Class Rank: #4 of 42"),
            pw.SizedBox(height: 16),

            pw.Text("Emotional Well-being",
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text("Confidence Level: 85%"),
            pw.Text("Focus & Attention: 72%"),
            pw.Text("Stress Management: 90%"),
            pw.SizedBox(height: 16),

            pw.Text("Future Path",
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text("Top Career Interest: Aerospace Engineering"),
            pw.Text("Match Score: 94%"),
          ],
        );
      },
    ),
  );

  final directory = await getApplicationDocumentsDirectory();
  final filePath = "${directory.path}/arjun_full_report.pdf";
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  await OpenFile.open(filePath);

if (context.mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Report saved and opened")),
  );
}
}

class FullReportScreen extends StatelessWidget {
  const FullReportScreen({super.key});

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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PARENT PORTAL",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F355C),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Full Report",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F355C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
  onTap: () {
    generateAndOpenPdf(context);
  },
  child: Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: const Color(0xFFE94A56),
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Icon(
      Icons.download,
      color: Colors.white,
      size: 18,
    ),
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

                      //================ ACADEMIC SUMMARY =================

                      const Text(
                        "Academic Summary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F355C),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _ReportStatCard(
                              iconColor: const Color(0xFF58C7F3),
                              icon: Icons.functions,
                              subject: "Math",
                              value: "92%",
                              trend: "5% this week",
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _ReportStatCard(
                              iconColor: const Color(0xFF57B97A),
                              icon: Icons.science_outlined,
                              subject: "Science",
                              value: "88%",
                              trend: "2% this week",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: _ReportStatCard(
                              iconColor: const Color(0xFFF7C948),
                              icon: Icons.menu_book_outlined,
                              subject: "English",
                              value: "78%",
                              trend: "1% this week",
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _ReportStatCard(
                              iconColor: const Color(0xFFE94A56),
                              icon: Icons.code,
                              subject: "Coding",
                              value: "95%",
                              trend: "8% this week",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 26),

                      //================ ATTENDANCE & QUIZZES =================

                      const Text(
                        "Term Overview",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F355C),
                        ),
                      ),

                      const SizedBox(height: 12),

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
                          children: [
                            _ReportRow(label: "Overall Attendance", value: "96%"),
                            const Divider(height: 24, color: Color(0xFFEFEFEF)),
                            _ReportRow(label: "Quizzes Taken", value: "24"),
                            const Divider(height: 24, color: Color(0xFFEFEFEF)),
                            _ReportRow(label: "Avg. Quiz Score", value: "A-"),
                            const Divider(height: 24, color: Color(0xFFEFEFEF)),
                            _ReportRow(label: "Class Rank", value: "#4 of 42"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 26),

                      //================ WELL-BEING =================

                      const Text(
                        "Emotional Well-being",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F355C),
                        ),
                      ),

                      const SizedBox(height: 12),

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
                            _WellbeingBar(
                              label: "Confidence Level",
                              percent: 85,
                              color: const Color(0xFF58C7F3),
                            ),
                            const SizedBox(height: 14),
                            _WellbeingBar(
                              label: "Focus & Attention",
                              percent: 72,
                              color: const Color(0xFFF7C948),
                            ),
                            const SizedBox(height: 14),
                            _WellbeingBar(
                              label: "Stress Management",
                              percent: 90,
                              color: const Color(0xFF57B97A),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 26),

                      //================ FUTURE PATH =================

                      const Text(
                        "Future Path",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F355C),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFF1F355C),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCE9EA),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.rocket_launch_outlined,
                                color: Color(0xFFE94A56),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "TOP CAREER INTEREST",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF5E6D7A),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Aerospace Engineering",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1F355C),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Match Score: 94%",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF5E6D7A),
                                    ),
                                  ),
                                ],
                              ),
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

class _ReportStatCard extends StatelessWidget {
  final Color iconColor;
  final IconData icon;
  final String subject;
  final String value;
  final String trend;

  const _ReportStatCard({
    required this.iconColor,
    required this.icon,
    required this.subject,
    required this.value,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF1F355C),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            subject,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF5E6D7A),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F355C),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "↑ $trend",
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF57B97A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReportRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF5E6D7A),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F355C),
          ),
        ),
      ],
    );
  }
}

class _WellbeingBar extends StatelessWidget {
  final String label;
  final int percent;
  final Color color;

  const _WellbeingBar({
    required this.label,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F355C),
              ),
            ),
            Text(
              "$percent%",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 8,
            backgroundColor: const Color(0xFFEFEFEF),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}