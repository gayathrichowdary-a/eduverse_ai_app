import 'package:flutter/material.dart';
import 'onboarding_interest_selection.dart';

class OnboardingLearningStyle extends StatefulWidget {
  const OnboardingLearningStyle({super.key});

  @override
  State<OnboardingLearningStyle> createState() => _OnboardingLearningStyleState();
}

class _OnboardingLearningStyleState extends State<OnboardingLearningStyle> {
  // ================= SIR'S BRAND COLORS =================
  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color brandGradientEnd = Color(0xFFF12C68);
  static const Color textMuted = Color(0xFF667085);
  static const Color cardBorder = Color(0xFFE4E7EC);

  final List<Map<String, dynamic>> _styles = [
    {'title': 'Watching', 'icon': Icons.play_arrow_rounded, 'sel': true},
    {'title': 'Reading', 'icon': Icons.menu_book_outlined, 'sel': false},
    {'title': 'Listening', 'icon': Icons.headphones_outlined, 'sel': false},
    {'title': 'Writing', 'icon': Icons.edit_note_outlined, 'sel': false},
    {'title': 'Hands-on', 'icon': Icons.science_outlined, 'sel': true},
    {'title': 'Discussion', 'icon': Icons.chat_bubble_outline_rounded, 'sel': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: navy),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 20),
          // ================= 6-SEGMENT PROGRESS BAR (STEP 5 OF 6) =================
          child: Row(
            children: List.generate(6, (index) {
              final bool isActive = index <= 4; // First 5 segments active
              return Expanded(
                child: Container(
                  height: 5,
                  margin: EdgeInsets.only(right: index == 5 ? 0 : 6),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? const LinearGradient(
                            colors: [brandRed, brandGradientEnd],
                          )
                        : null,
                    color: isActive ? null : const Color(0xFFF0F2F4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title in Sir's exact typography
                    const Text(
                      'How do you learn best?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: navy,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Choose the formats that make concepts click fastest for you.',
                      style: TextStyle(
                        fontSize: 14,
                        color: textMuted,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Grid of Learning Styles
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        mainAxisExtent: 135,
                      ),
                      itemCount: _styles.length,
                      itemBuilder: (context, index) {
                        final item = _styles[index];
                        final bool isSel = item['sel'] as bool;
                        return GestureDetector(
                          onTap: () => setState(() => item['sel'] = !isSel),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFFFFF0F2) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSel ? brandRed : cardBorder,
                                width: isSel ? 2.0 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSel
                                      ? brandRed.withOpacity(0.08)
                                      : Colors.black.withOpacity(0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                if (isSel)
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        color: brandRed,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 13,
                                      ),
                                    ),
                                  ),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: isSel ? brandRed : const Color(0xFFF2F4F7),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          item['icon'] as IconData,
                                          size: 22,
                                          color: isSel ? Colors.white : navy,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        item['title'] as String,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: isSel ? brandRed : navy,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ================= BOTTOM CAPSULE CONTINUE BUTTON =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFF2F4F7), width: 1),
                ),
              ),
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [brandRed, brandGradientEnd],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30), // Sir's capsule pill shape
                  boxShadow: [
                    BoxShadow(
                      color: brandRed.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingInterestSelection(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
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