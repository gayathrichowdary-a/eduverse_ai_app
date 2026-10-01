import 'package:flutter/material.dart';
import 'onboarding_subject_selection.dart';
import 'onboarding_assessment_in_progress.dart';

class OnboardingClassSelection extends StatefulWidget {
  const OnboardingClassSelection({super.key});

  @override
  State<OnboardingClassSelection> createState() =>
      _OnboardingClassSelectionState();
}

class _OnboardingClassSelectionState extends State<OnboardingClassSelection> {
  // Sir's Brand Design Colors
  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color brandGradientEnd = Color(0xFFF12C68);
  static const Color textMuted = Color(0xFF667085);
  static const Color sectionHeaderColor = Color(0xFF344054);
  static const Color cardBorder = Color(0xFFE4E7EC);

  String? selectedClass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(height: 5, color: brandRed),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(height: 5, color: brandRed),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(height: 5, color: const Color(0xFFEAECF0)),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ================= SCROLLABLE CONTENT =================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title in Sir's exact typography
                    const Text(
                      'Which class are you\nstudying?',
                      style: TextStyle(
                        color: navy,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    const Text(
                      'Personalizing your AI mentors based on your current academic stage.',
                      style: TextStyle(
                        color: textMuted,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Foundational
                    const Text(
                      'Foundational',
                      style: TextStyle(
                        color: sectionHeaderColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _classCard(
                            title: 'Primary',
                            subtitle: 'Classes 1–5',
                            value: '1st–5th Class',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _classCard(
                            title: 'Middle School',
                            subtitle: 'Classes 6–8',
                            value: '6th–10th Class',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    // Schooling
                    const Text(
                      'Schooling',
                      style: TextStyle(
                        color: sectionHeaderColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _classCard(
                            title: 'High School',
                            subtitle: 'Classes 9–10',
                            value: '6th–10th Class',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _classCard(
                            title: 'Intermediate',
                            subtitle: 'Classes 11–12',
                            value: '11th–12th Class',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _classCard(
                            title: 'Other',
                            subtitle: 'Other schooling',
                            value: '6th–10th Class',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    // Higher Education
                    const Text(
                      'Higher Education',
                      style: TextStyle(
                        color: sectionHeaderColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _classCard(
                            title: 'College',
                            subtitle: 'Undergraduate (UG)',
                            value: 'Undergraduate / College Students',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _classCard(
                            title: 'Postgraduate',
                            subtitle: "Master's degree (PG)",
                            value: 'Postgraduate / Higher Studies',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _classCard(
                            title: 'Management',
                            subtitle: 'MBA / Business',
                            value: 'MBA / Management Students',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ================= BOTTOM SECTION =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFF2F4F7),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: selectedClass == null
                          ? null
                          : const LinearGradient(
                              colors: [brandRed, brandGradientEnd],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                      color: selectedClass == null ? const Color(0xFFF2F4F7) : null,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: selectedClass != null
                          ? [
                              BoxShadow(
                                color: brandRed.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: ElevatedButton(
                      onPressed: selectedClass == null ? null : _continue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              color: selectedClass == null
                                  ? const Color(0xFF98A2B3)
                                  : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: selectedClass == null
                                ? const Color(0xFF98A2B3)
                                : Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'You can change this anytime in settings',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CLASS CARD =================
  Widget _classCard({
    required String title,
    required String subtitle,
    required String value,
  }) {
    final bool isSelected = selectedClass == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedClass = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 135,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF0F2) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? brandRed : cardBorder,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? brandRed.withOpacity(0.08)
                  : Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isSelected ? brandRed : const Color(0xFFF2F4F7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.school_outlined,
                color: isSelected ? Colors.white : navy,
                size: 20,
              ),
            ),
            const Spacer(),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected ? brandRed : navy,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _continue() {
    FocusScope.of(context).unfocus();
    if (selectedClass != null) {
      // Passes the selected category forward to the quiz screen
      OnboardingAssessmentInProgress.activeClassCategory = selectedClass!;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingSubjectSelection(),
      ),
    );
  }
}