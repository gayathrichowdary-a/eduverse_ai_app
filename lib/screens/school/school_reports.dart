import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'report_detail_screen.dart';

class SchoolReports extends StatelessWidget {
  const SchoolReports({super.key});

  static const Color navy = Color(0xFF1F355C);
  static const Color yellow = Color(0xFFF7C948);

  // Dummy data - later this will come from your database
  static final List<Map<String, String>> _reports = [
    {"title": "Academic Performance", "subtitle": "View student academic performance"},
    {"title": "Student Report", "subtitle": "View student enrollment and activity"},
    {"title": "Teacher Report", "subtitle": "View teacher performance information"},
    {"title": "Annual Report", "subtitle": "Export annual school report"},
  ];

  // Builds the PDF and opens the native save/share/print sheet
  Future<void> _exportReport(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "School Reports",
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 6),
              pw.Text("Term and annual report summary"),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 10),
              ..._reports.map(
                (report) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 14),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        report['title']!,
                        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(report['subtitle']!, style: const pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text(
                "Generated on ${DateTime.now().toString().split('.').first}",
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF to the device's app documents directory
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final fileName = "School_Report_${DateTime.now().millisecondsSinceEpoch}.pdf";
    final file = File("${dir.path}/$fileName");
    await file.writeAsBytes(bytes);

    // Open it with the device's default PDF viewer
    final result = await OpenFile.open(file.path);

    if (context.mounted && result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Report saved to ${file.path}"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "School Reports",
          style: TextStyle(
            color: navy,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 24),
            const Text(
              "Available Reports",
              style: TextStyle(
                color: navy,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),

            _report(
              context,
              Icons.assessment_rounded,
              yellow,
              "Academic Performance",
              "View student academic performance",
            ),
            _report(
              context,
              Icons.people_alt_rounded,
              const Color(0xFF58C7F3),
              "Student Report",
              "View student enrollment and activity",
            ),
            _report(
              context,
              Icons.school_rounded,
              const Color(0xFF57B97A),
              "Teacher Report",
              "View teacher performance information",
            ),
            _report(
              context,
              Icons.calendar_month_rounded,
              const Color(0xFFE94A56),
              "Annual Report",
              "Export annual school report",
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _exportReport(context),
                icon: const Icon(Icons.download_rounded),
                label: const Text("Export Report"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(22)),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(Icons.description_rounded, color: yellow, size: 28),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("School Reports", style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("Export term and annual reports", style: TextStyle(color: Color(0xFFB9C6D6), fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _report(BuildContext context, IconData icon, Color color, String title, String subtitle) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportDetailScreen(reportTitle: title),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: navy, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: navy, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: navy),
          ],
        ),
      ),
    );
  }
}