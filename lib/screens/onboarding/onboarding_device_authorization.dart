import 'package:flutter/material.dart';
import 'onboarding_initial_ai_assessment.dart';

// ============================================================
// MODEL
// ============================================================

enum PermissionStatus { notRequested, requesting, granted }

class DevicePermission {
  final String code; // 'camera' | 'mic' | 'screen'
  final String title;
  final String description;
  final IconData icon;
  PermissionStatus status;

  DevicePermission({
    required this.code,
    required this.title,
    required this.description,
    required this.icon,
    this.status = PermissionStatus.notRequested,
  });
}

// ============================================================
// SCREEN
// ============================================================

class OnboardingDeviceAuthorization extends StatefulWidget {
  final String skillLevel; // 'Intermediate' | 'Advanced'
  final String? branch;
  final String? course;

  const OnboardingDeviceAuthorization({
    super.key,
    required this.skillLevel,
    this.branch,
    this.course,
  });

  @override
  State<OnboardingDeviceAuthorization> createState() =>
      _OnboardingDeviceAuthorizationState();
}

class _OnboardingDeviceAuthorizationState
    extends State<OnboardingDeviceAuthorization> {
  // Sir's Brand Colors
  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color brandGradientEnd = Color(0xFFF12C68);
  static const Color mastGreen = Color(0xFF12B76A);
  static const Color textMuted = Color(0xFF667085);
  static const Color cardBorder = Color(0xFFE4E7EC);
  static const Color infoBg = Color(0xFFF2F5F9);
  static const Color infoText = Color(0xFF344054);

  late final List<DevicePermission> _permissions = [
    DevicePermission(
      code: 'camera',
      title: 'Webcam Access',
      description:
          'Sophia watches for engagement and runs anti-cheat monitoring during your assessment.',
      icon: Icons.videocam_rounded,
    ),
    DevicePermission(
      code: 'mic',
      title: 'Microphone Access',
      description:
          'Lets you answer conceptual questions out loud and talk through your reasoning with Sophia.',
      icon: Icons.mic_rounded,
    ),
    DevicePermission(
      code: 'screen',
      title: 'Screen Share',
      description:
          'Sophia observes your coding sandbox to verify your work is your own.',
      icon: Icons.screen_share_rounded,
    ),
  ];

  bool get _allGranted =>
      _permissions.every((p) => p.status == PermissionStatus.granted);

  Future<void> _requestPermission(DevicePermission permission) async {
    if (permission.status == PermissionStatus.granted) return;

    setState(() => permission.status = PermissionStatus.requesting);

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    setState(() => permission.status = PermissionStatus.granted);
  }

  Future<void> _allowAll() async {
    for (final permission in _permissions) {
      await _requestPermission(permission);
    }
  }

  void _continue() {
    if (!_allGranted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingInitialAiAssessment(),
      ),
    );
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
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= SOPHIA BADGE =================
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [brandRed, brandGradientEnd],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: brandRed.withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ================= TITLE =================
                    const Text(
                      'Sophia Needs Device Access',
                      style: TextStyle(
                        color: navy,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'To run your ${widget.skillLevel} assessment fairly, Sophia needs your permission before we begin.',
                      style: const TextStyle(
                        color: textMuted,
                        fontSize: 14,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= PERMISSION LIST =================
                    ...List.generate(_permissions.length, (index) {
                      final permission = _permissions[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == _permissions.length - 1 ? 0 : 14,
                        ),
                        child: _PermissionCard(
                          permission: permission,
                          onTap: () => _requestPermission(permission),
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    // ================= INFO BANNER =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: infoBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock_outline_rounded,
                              color: infoText,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Access is used only for the duration of this assessment and is never recorded without your consent.',
                              style: TextStyle(
                                color: infoText,
                                fontSize: 12,
                                height: 1.35,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
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
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: cardBorder, width: 1),
                ),
              ),
              child: Column(
                children: [
                  if (!_allGranted)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [brandRed, brandGradientEnd],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: brandRed.withOpacity(0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _allowAll,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Allow All & Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _continue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mastGreen,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Start Assessment',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward,
                                color: Colors.white, size: 18),
                          ],
                        ),
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
}

// ============================================================
// PERMISSION CARD
// ============================================================

class _PermissionCard extends StatelessWidget {
  final DevicePermission permission;
  final VoidCallback onTap;

  const _PermissionCard({required this.permission, required this.onTap});

  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color mastGreen = Color(0xFF12B76A);
  static const Color textMuted = Color(0xFF667085);
  static const Color cardBorder = Color(0xFFE4E7EC);

  @override
  Widget build(BuildContext context) {
    final granted = permission.status == PermissionStatus.granted;
    final requesting = permission.status == PermissionStatus.requesting;

    return InkWell(
      onTap: requesting ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: granted ? const Color(0xFFF0FDF4) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: granted ? mastGreen : cardBorder,
            width: granted ? 1.6 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: granted
                    ? mastGreen.withOpacity(0.12)
                    : brandRed.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                permission.icon,
                color: granted ? mastGreen : brandRed,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    permission.title,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    permission.description,
                    style: const TextStyle(
                      color: textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (requesting)
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: brandRed,
                ),
              )
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: granted ? mastGreen : Colors.transparent,
                  shape: BoxShape.circle,
                  border: granted
                      ? null
                      : Border.all(color: cardBorder, width: 1.5),
                ),
                child: granted
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}