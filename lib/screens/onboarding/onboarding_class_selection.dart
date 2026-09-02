import 'package:flutter/material.dart';
import 'onboarding_subject_selection.dart';

class OnboardingClassSelection extends StatefulWidget {
  const OnboardingClassSelection({super.key});

  @override
  State<OnboardingClassSelection> createState() =>
      _OnboardingClassSelectionState();
}

class _OnboardingClassSelectionState
    extends State<OnboardingClassSelection> {
  // ================= COLORS =================

  static const Color navy = Color(0xFF1D3B64);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFEF3340);

  // ================= SELECTED CLASS =================

  String? selectedClass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // =====================================================
            // SCROLLABLE CONTENT
            // =====================================================

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),

                padding: const EdgeInsets.fromLTRB(
                  46,
                  28,
                  46,
                  30,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // ================= BACK BUTTON =================

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },

                      child: const Icon(
                        Icons.arrow_back,
                        color: navy,
                        size: 42,
                      ),
                    ),

                    const SizedBox(height: 55),

                    // ================= TITLE =================

                    const Text(
                      'Which class are you\nstudying?',

                      style: TextStyle(
                        color: navy,
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ================= SUBTITLE =================

                    const Text(
                      'Personalizing your AI mentors based on your current\nacademic stage.',

                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 24,
                        height: 1.8,
                      ),
                    ),

                    const SizedBox(height: 38),

                    // ================= FOUNDATIONAL =================

                    const Text(
                      'Foundational',

                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Expanded(
                          child: _classCard(
                            title: 'Primary',
                            subtitle: 'Classes 1–5',
                            value: 'Primary',
                          ),
                        ),

                        const SizedBox(width: 30),

                        Expanded(
                          child: _classCard(
                            title: 'Middle School',
                            subtitle: 'Classes 6–8',
                            value: 'Middle School',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 45),

                    // ================= SCHOOLING =================

                    const Text(
                      'Schooling',

                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Expanded(
                          child: _classCard(
                            title: 'High School',
                            subtitle: 'Classes 9–10',
                            value: 'High School',
                          ),
                        ),

                        const SizedBox(width: 30),

                        Expanded(
                          child: _classCard(
                            title: 'Intermediate',
                            subtitle: 'Classes 11–12',
                            value: 'Intermediate',
                          ),
                        ),

                        const SizedBox(width: 30),

                        Expanded(
                          child: _classCard(
                            title: 'Other',
                            subtitle: 'Other schooling',
                            value: 'Other Schooling',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 45),

                    // ================= HIGHER EDUCATION =================

                    const Text(
                      'Higher Education',

                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Expanded(
                          child: _classCard(
                            title: 'College',
                            subtitle: 'Undergraduate',
                            value: 'College',
                          ),
                        ),

                        const SizedBox(width: 30),

                        Expanded(
                          child: _classCard(
                            title: 'Postgraduate',
                            subtitle: 'Master’s degree',
                            value: 'Postgraduate',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // =====================================================
            // BOTTOM SECTION
            // =====================================================

            Container(
              width: double.infinity,

              padding: const EdgeInsets.fromLTRB(
                46,
                20,
                46,
                28,
              ),

              decoration: const BoxDecoration(
                color: Colors.white,

                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE9EDF0),
                    width: 1,
                  ),
                ),
              ),

              child: Column(
                children: [
                  // ================= CONTINUE BUTTON =================

                  SizedBox(
                    width: double.infinity,
                    height: 92,

                    child: ElevatedButton(
                      onPressed: selectedClass == null
                          ? null
                          : _continue,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandRed,

                        disabledBackgroundColor:
                            const Color(0xFFF3A1A7),

                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),

                      child: const Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [
                          Text(
                            'Continue',

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(width: 18),

                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ================= SETTINGS TEXT =================

                  const Text(
                    'You can change this anytime in settings',

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: navy,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
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

  // ============================================================
  // CLASS CARD
  // ============================================================

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
        duration: const Duration(milliseconds: 200),

        height: 190,

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFFF1F2)
              : Colors.white,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: isSelected
                ? brandRed
                : const Color(0xFFE1E6EA),

            width: isSelected ? 2.5 : 1.5,
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ================= CARD ICON =================

            Container(
              width: 52,
              height: 52,

              decoration: BoxDecoration(
                color: isSelected
                    ? brandRed
                    : const Color(0xFFF1F5F7),

                borderRadius: BorderRadius.circular(14),
              ),

              child: Icon(
                Icons.school_outlined,

                color: isSelected
                    ? Colors.white
                    : navy,

                size: 28,
              ),
            ),

            const Spacer(),

            // ================= TITLE =================

            SizedBox(
              width: double.infinity,

              child: Text(
                title,

                maxLines: 2,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  color: navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 5),

            // ================= SUBTITLE =================

            SizedBox(
              width: double.infinity,

              child: Text(
                subtitle,

                maxLines: 2,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  color: subtitleBlue,
                  fontSize: 14,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CONTINUE
  // ============================================================

  void _continue() {
    FocusScope.of(context).unfocus();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingSubjectSelection(),
      ),
    );
  }
}