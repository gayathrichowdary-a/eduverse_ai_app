import 'package:flutter/material.dart';

class Enrollment extends StatelessWidget {
  const Enrollment({super.key});

  static const Color navy = Color(0xFF1F355C);
  static const Color green = Color(0xFF57B97A);
  static const Color lightBackground = Color(0xFFF8F8F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ================= HEADER =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                decoration: const BoxDecoration(
                  color: green,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                      child: const Icon(Icons.how_to_reg_rounded, color: green, size: 26),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Enrollment", style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
                          SizedBox(height: 3),
                          Text("Manage student admissions", style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ================= SUMMARY =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: const [
                    Expanded(child: _EnrollmentStatCard(value: "124", label: "Applications")),
                    SizedBox(width: 12),
                    Expanded(child: _EnrollmentStatCard(value: "86", label: "Approved")),
                    SizedBox(width: 12),
                    Expanded(child: _EnrollmentStatCard(value: "38", label: "Pending")),
                  ],
                ),
              ),

              const SizedBox(height: 26),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Align(alignment: Alignment.centerLeft, child: Text("Enrollment Management", style: TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(height: 14),

              // ================= SEARCH =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: navy, width: 1.3)),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search student applications",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      prefixIcon: Icon(Icons.search_rounded, color: navy),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ================= APPLICATIONS =================
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Align(alignment: Alignment.centerLeft, child: Text("Recent Applications", style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: const [
                    _StudentApplicationCard(name: "Aarav Kumar", className: "Grade 8", date: "Applied: 02 Aug 2026", status: "Pending", statusColor: Color(0xFFF7C948)),
                    SizedBox(height: 12),
                    _StudentApplicationCard(name: "Ananya Reddy", className: "Grade 7", date: "Applied: 01 Aug 2026", status: "Approved", statusColor: Color(0xFF57B97A)),
                    SizedBox(height: 12),
                    _StudentApplicationCard(name: "Rahul Sharma", className: "Grade 9", date: "Applied: 31 Jul 2026", status: "Pending", statusColor: Color(0xFFF7C948)),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ================= ADD STUDENT BUTTON =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddStudentDialog(context),
                    icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
                    label: const Text("Add New Student", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: navy, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ================= ADD STUDENT DIALOG FORM =================
  void _showAddStudentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("New Student Registration", style: TextStyle(color: navy, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogField("Full Name", Icons.person_outline),
                const SizedBox(height: 15),
                _buildDialogField("Grade / Class", Icons.school_outlined),
                const SizedBox(height: 15),
                _buildDialogField("Parent Contact", Icons.phone_android_outlined),
                const SizedBox(height: 10),
                const Text("An AI review will process this application within 24 hours.", style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Application Submitted Successfully")));
              },
              style: ElevatedButton.styleFrom(backgroundColor: green),
              child: const Text("Submit", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogField(String label, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: navy, fontSize: 14),
        prefixIcon: Icon(icon, color: navy, size: 20),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: navy, width: 2)),
      ),
    );
  }
}

// ================= STAT CARD =================
class _EnrollmentStatCard extends StatelessWidget {
  final String value;
  final String label;
  const _EnrollmentStatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1F355C), width: 1.3)),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Color(0xFF1F355C), fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF1F355C), fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ================= APPLICATION CARD =================
class _StudentApplicationCard extends StatelessWidget {
  final String name;
  final String className;
  final String date;
  final String status;
  final Color statusColor;

  const _StudentApplicationCard({required this.name, required this.className, required this.date, required this.status, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF1F355C), width: 1.7)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: const Color(0xFFE9F7EF), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.person_rounded, color: Color(0xFF57B97A), size: 26),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(color: Color(0xFF1F355C), fontSize: 15, fontWeight: FontWeight.bold)),
              Text(className, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            // FIXED: Updated withValues to remove deprecation warning
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
            child: Text(status, style: TextStyle(color: statusColor == const Color(0xFFF7C948) ? const Color(0xFF9A7800) : const Color(0xFF2E8B57), fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF1F355C)),
        ],
      ),
    );
  }
}