import 'package:flutter/material.dart';
import 'success_page.dart';
import 'registration_page.dart';
class RoleSelectionPage extends StatefulWidget {
  final Function(String selectedRole)? onRoleSelected;

  const RoleSelectionPage({
    super.key,
    this.onRoleSelected,
  });

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  static const Color brandRed = Color(0xFFEF3340);
  static const Color navy = Color(0xFF1D3B64);
  static const Color subtitleBlue = Color(0xFF4D86AD);

  int selectedRoleIndex = 0;

  final List<Map<String, dynamic>> roles = [
    {
      'title': 'Student',
      'description': 'Personalized learning and exam coaching',
      'icon': Icons.school,
    },
    {
      'title': 'Parent',
      'description': 'Monitor progress and emotional well-being',
      'icon': Icons.family_restroom,
    },
    {
      'title': 'Teacher',
      'description': 'Empower classrooms with AI analytics',
      'icon': Icons.psychology,
    },
    {
      'title': 'School',
      'description': 'Manage curriculum and teacher performance',
      'icon': Icons.business,
    },
    {
      'title': 'Administrator',
      'description': 'System-wide insights and configuration',
      'icon': Icons.account_balance,
    },
  ];

  void _continueToNextPage() {
    final String chosenRole = roles[selectedRoleIndex]['title'] as String;

    if (widget.onRoleSelected != null) {
      widget.onRoleSelected!(chosenRole);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegistrationPage(role: chosenRole),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Who are you?',
                      style: TextStyle(
                        color: navy,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Select your primary role to customize your EduVerse AI experience.',
                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 25),
                    ...List.generate(roles.length, (index) {
                      final item = roles[index];
                      final bool isSelected = selectedRoleIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedRoleIndex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFFFF5F5) : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected ? brandRed : const Color(0xFFE5E7EB),
                              width: isSelected ? 2.2 : 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isSelected ? brandRed : const Color(0xFFF3F4F6),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  color: isSelected ? Colors.white : navy,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      style: TextStyle(
                                        color: navy,
                                        fontSize: 18,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['description'] as String,
                                      style: const TextStyle(
                                        color: subtitleBlue,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? brandRed : Colors.grey.shade400,
                                    width: 2,
                                  ),
                                  color: isSelected ? brandRed : Colors.transparent,
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _continueToNextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Continue as ${roles[selectedRoleIndex]['title']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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