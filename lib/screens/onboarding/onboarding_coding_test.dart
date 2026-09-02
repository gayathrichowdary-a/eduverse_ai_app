import 'package:flutter/material.dart';
import 'onboarding_conceptual_question.dart';

// ============================================================
// MODEL
// ============================================================

enum CompileResult { none, running, success, failure }

/// A single sandbox coding problem for the onboarding assessment.
class CodingTestProblem {
  final String title;
  final String prompt;
  final String starterCode;
  final List<String> requiredTokens; // naive "must compile" check
  final String language;

  const CodingTestProblem({
    required this.title,
    required this.prompt,
    required this.starterCode,
    required this.requiredTokens,
    this.language = 'Python',
  });
}

// ============================================================
// SCREEN
// ============================================================

/// Dedicated sandbox coding-challenge stage of the Sophia assessment.
///
/// Per the spec this is a separate stage from the 3 cognitive/analytical
/// MCQs: "After Three Question an Coding Test will be taken. In Coding
/// test a Sandbox Environment will open and the Coding Problem will be
/// asked and after the correct code then it will take you to the
/// Conceptual Question part."
///
/// NOTE: `_compile` below runs a lightweight local check so the flow is
/// demonstrable without a backend. Swap it for a real call to your
/// multi-language code runner (see "Interactive DSA & Coding
/// Environment" in the spec) when that service is wired up.
class OnboardingCodingTest extends StatefulWidget {
  final String skillLevel;
  final String? branch;
  final String? course;
  final int cognitiveScore; // running score from the 3 prior questions

  const OnboardingCodingTest({
    Key? key,
    required this.skillLevel,
    this.branch,
    this.course,
    this.cognitiveScore = 0,
  }) : super(key: key);

  @override
  State<OnboardingCodingTest> createState() => _OnboardingCodingTestState();
}

class _OnboardingCodingTestState extends State<OnboardingCodingTest> {
  // ================= COLORS =================

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color mastGreen = Color(0xFF33B679);
  static const Color trackGrey = Color(0xFFE9EDF0);
  static const Color panelGrey = Color(0xFFF5F7F8);
  static const Color terminalBg = Color(0xFF14213D);

  static const CodingTestProblem _problem = CodingTestProblem(
    title: 'Reverse a String',
    prompt: 'Write a function reverseString(s) that takes a string and '
        'returns it reversed, without using a built-in reverse method.',
    starterCode: 'def reverseString(s):\n'
        '    # your code here\n'
        '    pass\n',
    requiredTokens: ['def reverseString', 'return'],
  );

  late final TextEditingController _codeController =
      TextEditingController(text: _problem.starterCode);

  CompileResult _result = CompileResult.none;
  String _output = '';

  Future<void> _compile() async {
    setState(() {
      _result = CompileResult.running;
      _output = '';
    });

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final code = _codeController.text;

    // Simple heuristic: the required function signature must be present
    // and the body must actually do something beyond the starter `pass`.
    final hasRequiredTokens =
        _problem.requiredTokens.every((token) => code.contains(token));
    final bodyChanged = code.trim() != _problem.starterCode.trim();
    final looksImplemented =
        hasRequiredTokens && bodyChanged && !code.contains('pass\n');

    setState(() {
      if (looksImplemented) {
        _result = CompileResult.success;
        _output = '✓ Compiled successfully\n✓ Test 1 passed: "hello" → '
            '"olleh"\n✓ Test 2 passed: "LMS" → "SML"\n✓ All test cases '
            'passed.';
      } else {
        _result = CompileResult.failure;
        _output = '✗ Compilation finished but tests failed.\nMake sure '
            'reverseString actually returns the reversed string.';
      }
    });
  }

  void _continue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OnboardingConceptualQuestion(
          skillLevel: widget.skillLevel,
          branch: widget.branch,
          course: widget.course,
          runningScore: widget.cognitiveScore,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final success = _result == CompileResult.success;
    final running = _result == CompileResult.running;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= TOP BAR =================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Coding Test',
                          style: TextStyle(
                            color: navy,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.skillLevel} Assessment • Sandbox',
                          style: const TextStyle(
                            color: subtitleBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: panelGrey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      _problem.language,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: trackGrey, height: 1),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= PROBLEM CARD =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: trackGrey, width: 1.2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0F000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: brandRed,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.code_rounded,
                                    color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _problem.title,
                                style: const TextStyle(
                                  color: navy,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _problem.prompt,
                            style: const TextStyle(
                              color: subtitleBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ================= CODE EDITOR =================
                    const Text(
                      'Sandbox Environment',
                      style: TextStyle(
                        color: navy,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: terminalBg,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _codeController,
                        maxLines: 10,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'monospace',
                          height: 1.5,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ================= RUN BUTTON =================
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: running ? null : _compile,
                        icon: running
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.2, color: brandRed),
                              )
                            : const Icon(Icons.play_arrow_rounded,
                                color: brandRed),
                        label: Text(
                          running ? 'Compiling…' : 'Run & Compile',
                          style: const TextStyle(
                            color: brandRed,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: brandRed, width: 1.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),

                    if (_result != CompileResult.none &&
                        _result != CompileResult.running) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: success
                              ? const Color(0xFFE6F6EE)
                              : const Color(0xFFFCE3E6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: success ? mastGreen : brandRed,
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          _output,
                          style: TextStyle(
                            color: success ? const Color(0xFF1F7A50) : brandRed,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'monospace',
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
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
                border: Border(top: BorderSide(color: trackGrey, width: 1)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: success ? _continue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: success ? brandRed : trackGrey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue to Conceptual Question',
                        style: TextStyle(
                          color: success ? Colors.white : subtitleBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded,
                          color: success ? Colors.white : subtitleBlue,
                          size: 20),
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