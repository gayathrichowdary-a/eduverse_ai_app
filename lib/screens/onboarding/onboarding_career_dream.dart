import 'package:flutter/material.dart';
import 'onboarding_board_selection.dart';

class OnboardingCareerDream extends StatefulWidget {
  const OnboardingCareerDream({super.key});

  @override
  State<OnboardingCareerDream> createState() => _OnboardingCareerDreamState();
}

class _OnboardingCareerDreamState extends State<OnboardingCareerDream> {
  // Sir's Brand Colors
  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color brandGradientEnd = Color(0xFFF12C68);
  static const Color textMuted = Color(0xFF667085);
  static const Color cardBorder = Color(0xFFE4E7EC);

  final List<Map<String, dynamic>> _careers = [
    {'title': 'Doctor & Medicine', 'desc': 'MBBS, Healthcare, Life Sciences', 'icon': Icons.medical_services_outlined, 'sel': false},
    {'title': 'Software Engineer / AI Tech', 'desc': 'Coding, Algorithms, Machine Learning', 'icon': Icons.code_rounded, 'sel': true},
    {'title': 'Space & Aeronautical Scientist', 'desc': 'Astrophysics, ISRO/NASA, Research', 'icon': Icons.rocket_launch_outlined, 'sel': false},
    {'title': 'Civil Services (IAS / IPS)', 'desc': 'UPSC, Public Governance & Leadership', 'icon': Icons.shield_outlined, 'sel': false},
    {'title': 'Educator / Professor', 'desc': 'Teaching, Academic Research, Mentorship', 'icon': Icons.school_outlined, 'sel': false},
    {'title': 'Entrepreneur / Founder', 'desc': 'Startups, Finance, Business Innovation', 'icon': Icons.lightbulb_outline, 'sel': false},
  ];

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
                child: Container(height: 5, color: brandRed),
              ),
            ),
          ],
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
                    // Eyebrow badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'CAREER ASPIRATION',
                        style: TextStyle(
                          color: brandRed,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Title in Sir's exact typography
                    const Text(
                      'What would you like\nto become?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: navy,
                        letterSpacing: -0.3,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    const Text(
                      'EduVerse AI designs long-term milestone roadmaps for your dream career.',
                      style: TextStyle(
                        fontSize: 14,
                        color: textMuted,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Careers List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _careers.length,
                      itemBuilder: (context, index) {
                        final item = _careers[index];
                        final bool isSel = item['sel'] as bool;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                for (var c in _careers) {
                                  c['sel'] = false;
                                }
                                item['sel'] = true;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: isSel ? brandRed : const Color(0xFFF2F4F7),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      item['icon'] as IconData,
                                      size: 20,
                                      color: isSel ? Colors.white : navy,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['title'] as String,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: isSel ? brandRed : navy,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          item['desc'] as String,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: textMuted,
                                            height: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSel ? brandRed : Colors.transparent,
                                      border: Border.all(
                                        color: isSel ? brandRed : cardBorder,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSel
                                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Continue Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                  borderRadius: BorderRadius.circular(16),
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
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingBoardSelection(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue to Board Selection',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
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