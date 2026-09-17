import 'package:flutter/material.dart';
import 'registration_page.dart';
import 'success_page.dart';
class RoleSelectionPage extends StatefulWidget {
  /// Optional callback for custom flow handling (e.g., Join EduVerse AI)
  final Function(String selectedRole)? onRoleSelected;

  const RoleSelectionPage({
    super.key,
    this.onRoleSelected,
  });

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  // =========================
  // COLORS
  // =========================

  static const Color brandRed = Color(0xFFEF3340);
  static const Color navy = Color(0xFF1D3B64);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color shadowColor = Color(0xFFD5D9DD);
  static const Color unselectedBorder = Color(0xFFE0E0E0);

  int selectedRole = 0;

  // =========================
  // ROLE DATA
  // =========================

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // =========================
            // MAIN CONTENT
            // =========================
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 35, 24, 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Who are you?',
                        style: TextStyle(
                          color: navy,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Choose your role to personalize your experience.',
                        style: TextStyle(
                          color: subtitleBlue,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // =========================
                      // ROLE CARDS
                      // =========================
                      ...List.generate(
                        roles.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _buildRoleCard(
                              index: index,
                              title: roles[index]['title'],
                              description: roles[index]['description'],
                              icon: roles[index]['icon'],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // =========================
            // BOTTOM CONTINUE SECTION
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE8ECEF),
                    width: 1,
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _continueToNextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
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

  // =========================================================
  // ROLE CARD
  // =========================================================

  Widget _buildRoleCard({
    required int index,
    required String title,
    required String description,
    required IconData icon,
  }) {
    final bool isSelected = selectedRole == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 120),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? brandRed : unselectedBorder,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: shadowColor,
                    offset: Offset(0, 6),
                    blurRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected ? brandRed : const Color(0xFFF2F4F7),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : navy,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),

            // Content Text
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: subtitleBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Dynamic Check Indicator
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected ? brandRed : const Color(0xFFD0D5DD),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? brandRed : const Color(0xFFD0D5DD),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // CONTINUE ACTION
  // =========================================================

  void _continueToNextPage() {
    final String chosenRole = roles[selectedRole]['title'] as String;

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
}