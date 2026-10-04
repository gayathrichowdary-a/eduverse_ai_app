import 'package:flutter/material.dart';

class ReportDetailScreen extends StatelessWidget {
  final String reportTitle;
  const ReportDetailScreen({super.key, required this.reportTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: const Color(0x1A0B2F63),
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(22))),
        iconTheme: const IconThemeData(color: Color(0xFF0B2F63)),
        titleTextStyle: const TextStyle(color: Color(0xFF0B2F63), fontSize: 20, fontWeight: FontWeight.w800),
        title: Text(reportTitle),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 80, color: Color(0xFF7B8798)),
            SizedBox(height: 16),
            Text("Detailed Analytics will appear here.", 
                 style: TextStyle(fontSize: 16, color: Color(0xFF7B8798))),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Once database is connected, this page will show charts and tables.", 
                          textAlign: TextAlign.center),
            )
          ],
        ),
      ),
    );
  }
}