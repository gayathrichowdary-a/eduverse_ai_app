import 'package:flutter/material.dart';

// ============================================================
// MODELS
// ============================================================

class CertificateItem {
  final String title;
  final String subject;
  final IconData icon;
  final Color iconBackground;
  final bool earned;
  final double progress; // used when not yet earned
  final String? dateEarned;

  const CertificateItem({
    required this.title,
    required this.subject,
    required this.icon,
    required this.iconBackground,
    required this.earned,
    this.progress = 0.0,
    this.dateEarned,
  });
}

// ============================================================
// SCREEN
// ============================================================

class CertificationScreen extends StatelessWidget {
  final List<CertificateItem> certificates;

  const CertificationScreen({
    Key? key,
    this.certificates = const [
      CertificateItem(
        title: 'Algebra Fundamentals',
        subject: 'Maths',
        icon: Icons.functions,
        iconBackground: Color(0xFFE8394A),
        earned: true,
        dateEarned: 'Earned Aug 2, 2026',
      ),
      CertificateItem(
        title: 'Intro to Chemistry',
        subject: 'Chemistry',
        icon: Icons.science,
        iconBackground: Color(0xFF33B679),
        earned: true,
        dateEarned: 'Earned Jul 18, 2026',
      ),
      CertificateItem(
        title: 'Calculus Basics',
        subject: 'Maths',
        icon: Icons.calculate_rounded,
        iconBackground: Color(0xFFF4C10F),
        earned: false,
        progress: 0.65,
      ),
      CertificateItem(
        title: 'Quantum Physics Explorer',
        subject: 'Physics',
        icon: Icons.bolt_rounded,
        iconBackground: Color(0xFF4D86AD),
        earned: false,
        progress: 0.3,
      ),
    ],
  }) : super(key: key);

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color mastGreen = Color(0xFF33B679);
  static const Color trackGrey = Color(0xFFE9EDF0);

  void _viewCertificate(BuildContext context, CertificateItem cert) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: mastGreen,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.workspace_premium_rounded,
                      color: Colors.white, size: 36),
                ),
                const SizedBox(height: 16),
                Text(
                  cert.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  cert.dateEarned ?? '',
                  style: const TextStyle(
                    color: subtitleBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandRed,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final earnedCount = certificates.where((c) => c.earned).length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, color: navy),
                  ),
                  const Text(
                    'Certifications',
                    style: TextStyle(
                      color: navy,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF1CE),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: navy, width: 1.4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events_rounded,
                        color: navy, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'You\'ve earned $earnedCount of ${certificates.length} certificates',
                      style: const TextStyle(
                        color: navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: certificates.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final cert = certificates[index];
                  return InkWell(
                    onTap: cert.earned
                        ? () => _viewCertificate(context, cert)
                        : null,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cert.earned ? Colors.white : trackGrey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: navy, width: 1.4),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: cert.earned
                                  ? cert.iconBackground
                                  : cert.iconBackground.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(cert.icon, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cert.subject,
                                  style: const TextStyle(
                                    color: subtitleBlue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  cert.title,
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                if (cert.earned)
                                  Text(
                                    cert.dateEarned ?? '',
                                    style: const TextStyle(
                                      color: mastGreen,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                else
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: LinearProgressIndicator(
                                      value: cert.progress,
                                      minHeight: 7,
                                      backgroundColor: trackGrey,
                                      valueColor: const AlwaysStoppedAnimation<
                                          Color>(subtitleBlue),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Icon(
                            cert.earned
                                ? Icons.workspace_premium_rounded
                                : Icons.lock_outline,
                            color: cert.earned ? mastGreen : subtitleBlue,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}