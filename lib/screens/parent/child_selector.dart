import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

class ChildSelector extends StatelessWidget {
  const ChildSelector({super.key});

  static const Color navy = Color(0xFF1F355C);
  static const Color yellow = Color(0xFFFFD52E);
  static const Color red = Color(0xFFEF3340);

  // Dummy data - later this will come from your database (children linked to this parent)
  static final List<Map<String, String>> children = [
    {"initials": "AR", "name": "Arjun", "grade": "Grade 8", "status": "Active Now"},
    {"initials": "AK", "name": "Akhil", "grade": "Grade 5", "status": "Active Now"},
    {"initials": "SN", "name": "Sneha", "grade": "Grade 10", "status": "Offline"},
  ];

  // Change this to whichever child is currently selected on the dashboard
  static const String currentlySelected = "Arjun";

  Future<void> _confirmLogout(BuildContext context) async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          "Log out?",
          style: TextStyle(color: navy, fontWeight: FontWeight.bold),
        ),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel", style: TextStyle(color: navy)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              "Log out",
              style: TextStyle(color: red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
  await Supabase.instance.client.auth.signOut();
  if (!context.mounted) return;

  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: yellow,
        elevation: 0,
        iconTheme: const IconThemeData(color: navy),
        title: const Text(
          "Select Child",
          style: TextStyle(color: navy, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: children.length,
        itemBuilder: (context, index) {
          final child = children[index];
          final bool isSelected = child['name'] == currentlySelected;

          return GestureDetector(
            onTap: () {
              Navigator.pop(context, child);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? yellow : navy,
                  width: isSelected ? 3 : 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: navy, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        child['initials']!,
                        style: const TextStyle(fontSize: 18, color: navy, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          child['name']!,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: navy),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${child['grade']} • ${child['status']}",
                          style: const TextStyle(fontSize: 13, color: Color(0xFF5E6D7A)),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle, color: navy)
                  else
                    const Icon(Icons.chevron_right_rounded, color: navy),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
          child: SizedBox(
            height: 54,
            child: OutlinedButton.icon(
              onPressed: () => _confirmLogout(context),
              icon: const Icon(Icons.logout_rounded, color: red),
              label: const Text(
                "Log out",
                style: TextStyle(color: red, fontSize: 17, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: red, width: 1.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}