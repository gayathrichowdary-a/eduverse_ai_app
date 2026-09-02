import 'package:flutter/material.dart';

class ReportDetailScreen extends StatelessWidget {
  final String reportTitle;
  const ReportDetailScreen({super.key, required this.reportTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F355C),
        title: Text(reportTitle),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text("Detailed Analytics will appear here.", 
                 style: TextStyle(fontSize: 16, color: Colors.grey)),
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