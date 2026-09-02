import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
Future<void> generateAndOpenTeacherPdf(
    BuildContext context, String format, String range) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Class 10-A Report",
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text("Range: $range"),
            pw.SizedBox(height: 16),

            pw.Text("Class Summary",
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text("Students: 42"),
            pw.Text("Avg. Score: 84%"),
            pw.Text("Critical Gaps: 1 topic flagged"),
            pw.SizedBox(height: 16),

            pw.Text("Students Needing Attention",
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text("Arjun Mehta - Quadratic Equations - 42%"),
            pw.Text("Sana Khan - Organic Chemistry - 55%"),
            pw.Text("Rohan Das - World War II - 38%"),
          ],
        );
      },
    ),
  );

  final directory = await getApplicationDocumentsDirectory();
  final filePath = "${directory.path}/class_10a_report.pdf";
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  await OpenFile.open(filePath);

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Report saved and opened")),
    );
  }
}

class GenerateReport extends StatefulWidget {
  const GenerateReport({super.key});

  @override
  State<GenerateReport> createState() => _GenerateReportState();
}

class _GenerateReportState extends State<GenerateReport> {
  String selectedFormat = "PDF";
  final List<String> formats = ["PDF", "Excel", "CSV"];

  String selectedRange = "This Week";
  final List<String> ranges = ["This Week", "This Month", "This Term"];

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
                    "Generate Report",
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

                      //================ REPORT PREVIEW SUMMARY =================

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
                            Row(
                              children: const [
                                Icon(Icons.description_outlined,
                                    color: Color(0xFF1F355C), size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Report Summary",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F355C),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _SummaryRow(label: "Class", value: "10-A • Science"),
                            const SizedBox(height: 10),
                            _SummaryRow(label: "Students", value: "42"),
                            const SizedBox(height: 10),
                            _SummaryRow(label: "Avg. Score", value: "84%"),
                            const SizedBox(height: 10),
                            _SummaryRow(
                                label: "Critical Gaps", value: "1 topic flagged"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 26),

                      //================ DATE RANGE =================

                      const Text(
                        "Date Range",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F355C),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: ranges.map((r) {
                          final bool isActive = r == selectedRange;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedRange = r;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFFE94A56)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF1F355C),
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                r,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isActive
                                      ? Colors.white
                                      : const Color(0xFF1F355C),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 26),

                      //================ FORMAT SELECTION =================

                      const Text(
                        "Export Format",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F355C),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: formats.map((f) {
                          final bool isActive = f == selectedFormat;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedFormat = f;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? const Color(0xFF1F355C)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color(0xFF1F355C),
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    f,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isActive
                                          ? Colors.white
                                          : const Color(0xFF1F355C),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                    ],
                  ),
                ),
              ),
            ),

            //================ GENERATE BUTTON =================

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
                child: ElevatedButton.icon(
                  onPressed: () {generateAndOpenTeacherPdf(context, selectedFormat, selectedRange);

                  },
                  icon: const Icon(Icons.download, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE94A56),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  label: const Text(
                    "Generate Report",
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

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
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F355C),
          ),
        ),
      ],
    );
  }
}