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

/// Required consent step before the Sophia live assessment starts.
///
/// Per the spec: "Sophia Ai Teacher will take an assessment of your
/// cognitive and analysing skills by taking access of your webcam and
/// mic and also your screen." The student must explicitly authorize all
/// three before Sophia's assessment intro can begin.
///
/// NOTE: the actual OS-level permission requests (camera/mic/screen
/// capture) should be wired up here using a package such as
/// `permission_handler` (camera/microphone) and the platform screen
/// capture API. This screen implements the consent UI + state machine;
/// swap `_requestPermission`'s simulated grant for the real platform
/// calls when that package is added to pubspec.yaml.
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
  // ================= COLORS =================

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color mastGreen = Color(0xFF33B679);
  static const Color trackGrey = Color(0xFFE9EDF0);
  static const Color infoBg = Color(0xFFE7E9FB);
  static const Color infoText = Color(0xFF5B6B8C);

  late final List<DevicePermission> _permissions = [
    DevicePermission(
      code: 'camera',
      title: 'Webcam Access',
      description: 'Sophia watches for engagement and runs anti-cheat '
          'monitoring during your assessment.',
      icon: Icons.videocam_rounded,
    ),
    DevicePermission(
      code: 'mic',
      title: 'Microphone Access',
      description: 'Lets you answer conceptual questions out loud and '
          'talk through your reasoning with Sophia.',
      icon: Icons.mic_rounded,
    ),
    DevicePermission(
      code: 'screen',
      title: 'Screen Share',
      description: 'Sophia observes your coding sandbox to verify your '
          'work is your own.',
      icon: Icons.screen_share_rounded,
    ),
  ];

  bool get _allGranted =>
      _permissions.every((p) => p.status == PermissionStatus.granted);

  Future<void> _requestPermission(DevicePermission permission) async {
    if (permission.status == PermissionStatus.granted) return;

    setState(() => permission.status = PermissionStatus.requesting);

    // TODO: replace with a real platform permission request, e.g.
    //   await Permission.camera.request();
    //   await Permission.microphone.request();
    //   (screen capture is platform-specific — see foreground_service /
    //   MediaProjection on Android, ReplayKit on iOS)
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
        // Existing screen — kept as a plain const call since its current
        // constructor takes no params. Once it's updated to accept
        // skillLevel/branch/course, thread widget.skillLevel /
        // widget.branch / widget.course through here.
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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= SOPHIA BADGE =================

                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: brandRed,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.auto_awesome,
                          color: Colors.white, size: 30),
                    ),

                    const SizedBox(height: 20),

                    // ================= TITLE =================

                    const Text(
                      'Sophia Needs Device Access',
                      style: TextStyle(
                        color: navy,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'To run your ${widget.skillLevel} assessment fairly, '
                      "Sophia needs your permission for the following "
                      "before we begin.",
                      style: const TextStyle(
                        color: subtitleBlue,
                        fontSize: 16,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= PERMISSION LIST =================

                    ...List.generate(_permissions.length, (index) {
                      final permission = _permissions[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              index == _permissions.length - 1 ? 0 : 16,
                        ),
                        child: _PermissionCard(
                          permission: permission,
                          onTap: () => _requestPermission(permission),
                        ),
                      );
                    }),

                    const SizedBox(height: 16),

                    // ================= INFO BANNER =================

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: infoBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lock_outline_rounded,
                              color: infoText,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Access is used only for the duration of this '
                              'assessment and is never recorded without '
                              'your consent.',
                              style: TextStyle(
                                color: infoText,
                                fontSize: 14,
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
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: trackGrey, width: 1),
                ),
              ),
              child: Column(
                children: [
                  if (!_allGranted)
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _allowAll,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandRed,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          'Allow All & Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _continue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mastGreen,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Start Assessment',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward,
                                color: Colors.white, size: 20),
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

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color mastGreen = Color(0xFF33B679);
  static const Color cardSelectedBg = Color(0xFFF6E3E4);

  @override
  Widget build(BuildContext context) {
    final granted = permission.status == PermissionStatus.granted;
    final requesting = permission.status == PermissionStatus.requesting;

    return InkWell(
      onTap: requesting ? null : onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: granted ? cardSelectedBg : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: granted ? mastGreen : const Color(0xFFE2E8ED),
            width: 1.6,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: brandRed,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(permission.icon, color: Colors.white, size: 26),
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
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    permission.description,
                    style: const TextStyle(
                      color: subtitleBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (requesting)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: brandRed,
                ),
              )
            else
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: granted ? mastGreen : Colors.transparent,
                  shape: BoxShape.circle,
                  border: granted
                      ? null
                      : Border.all(color: const Color(0xFFE2E8ED)),
                ),
                child: granted
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}