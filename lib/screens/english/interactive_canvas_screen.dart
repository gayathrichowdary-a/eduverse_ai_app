import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InteractiveCanvasScreen extends StatefulWidget {
  const InteractiveCanvasScreen({super.key});

  @override
  State<InteractiveCanvasScreen> createState() =>
      _InteractiveCanvasScreenState();
}

class _InteractiveCanvasScreenState
    extends State<InteractiveCanvasScreen> {
  // ============================================================
  // THEME COLORS
  // ============================================================

  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color insightBlue = Color(0xFFEAF8FB);
  static const Color matchGreen = Color(0xFF52B68C);

  // ============================================================
  // CONTROLLERS / STATES
  // ============================================================

  final ScreenshotController _screenshotController =
      ScreenshotController();

  bool _isSaving = false;
  bool _isSharing = false;

  // ============================================================
  // SESSION DATA
  // ============================================================

  final Map<String, dynamic> _sessionData = {
    "topic": "Physics: Force & Motion",
    "liveInsight":
        "I see you're drawing a free-body diagram. Remember that the Normal Force is always perpendicular to the surface!",
    "potentialGap": {
      "label": "Vector Direction",
      "progress": 0.65,
    },
    "commonMistake": {
      "wrong": "Gravity parallel to slope",
      "correct": "Gravity acts vertically downward",
    },
    "careerMatch": {
      "title": "Mechanical Engineer",
      "match": 92,
    },
    "sessionDuration": "12:45",
  };

  // ============================================================
  // SAVE PROGRESS TO SHARED PREFERENCES
  // ============================================================

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final existingSessions =
        prefs.getStringList('canvas_sessions') ?? [];

    final entry = {
      ..._sessionData,
      "savedAt": DateTime.now().toIso8601String(),
    };

    existingSessions.add(jsonEncode(entry));

    await prefs.setStringList(
      'canvas_sessions',
      existingSessions,
    );
  }

  // ============================================================
  // SAVE SCREENSHOT + PROGRESS
  // ============================================================

  Future<void> _handleSave() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Capture the canvas
      final Uint8List? imageBytes =
          await _screenshotController.capture(
        pixelRatio: 2.0,
      );

      if (imageBytes == null) {
        throw Exception("Could not capture canvas");
      }

      // Check gallery permission
      bool hasAccess = await Gal.hasAccess();

      if (!hasAccess) {
        hasAccess = await Gal.requestAccess();
      }

      if (!hasAccess) {
        throw Exception("Gallery permission was denied");
      }

      // Save image to gallery
      await Gal.putImageBytes(
        imageBytes,
        name:
            "interactive_canvas_${DateTime.now().millisecondsSinceEpoch}",
      );

      // Save session data
      await _saveProgress();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Saved image & progress successfully ✅"),
          backgroundColor: matchGreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Save failed: $e"),
          backgroundColor: brandRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // ============================================================
  // SHARE SCREENSHOT
  // ============================================================

  Future<void> _handleShare() async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      final Uint8List? imageBytes =
          await _screenshotController.capture(
        pixelRatio: 2.0,
      );

      if (imageBytes == null) {
        throw Exception("Could not capture canvas");
      }

      // Create temporary file
      final directory = await getTemporaryDirectory();

      final filePath =
          '${directory.path}/canvas_share_${DateTime.now().millisecondsSinceEpoch}.png';

      final file = File(filePath);

      await file.writeAsBytes(imageBytes);

      // Share image
      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            "Check out my ${_sessionData["topic"]} insight from EduVerse AI!",
        subject: "EduVerse AI — Interactive Canvas",
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Share failed: $e"),
          backgroundColor: brandRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: navy,
            size: 22,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Interactive Canvas",
              style: TextStyle(
                color: navy,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _sessionData["topic"] as String,
              style: const TextStyle(
                color: subtitleBlue,
                fontSize: 11,
              ),
            ),
          ],
        ),

        actions: [
          // SHARE BUTTON
          TextButton(
            onPressed: _isSharing ? null : _handleShare,
            child: _isSharing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: navy,
                    ),
                  )
                : const Text(
                    "Share",
                    style: TextStyle(
                      color: navy,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),

          // SAVE BUTTON
          Padding(
            padding: const EdgeInsets.only(
              right: 12,
              top: 8,
              bottom: 8,
            ),
            child: ElevatedButton(
              onPressed: _isSaving ? null : _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: brandRed,
                disabledBackgroundColor:
                    brandRed.withValues(alpha: 0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Screenshot(
        controller: _screenshotController,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // ==================================================
                    // LEFT SIDEBAR
                    // ==================================================

                    Container(
                      width: 75,
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Color(0xFFF2F2F2),
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),

                          // Image
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(12),
                            child: Image.network(
                              "https://images.unsplash.com/photo-1517976487492-5750f3195933?q=80&w=100",
                              height: 55,
                              width: 55,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) {
                                return Container(
                                  height: 55,
                                  width: 55,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),

                          const Spacer(),

                          // AI suggestion
                          RotatedBox(
                            quarterTurns: 3,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD54F),
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    size: 14,
                                    color: navy,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Normal Force",
                                    style: TextStyle(
                                      color: navy,
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Edit button
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 20,
                            ),
                            child: CircleAvatar(
                              radius: 26,
                              backgroundColor: brandRed,
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ==================================================
                    // RIGHT AI MENTOR PANEL
                    // ==================================================

                    Expanded(
                      child: SingleChildScrollView(
                        physics:
                            const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            // AI Mentor heading
                            const Row(
                              children: [
                                Icon(
                                  Icons.smart_toy_rounded,
                                  color: navy,
                                  size: 24,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "AI Mentor",
                                  style: TextStyle(
                                    color: navy,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            // Live Insight
                            _buildInsightCard(),

                            const SizedBox(height: 25),

                            // Potential Gaps
                            const Text(
                              "Potential Gaps",
                              style: TextStyle(
                                color: navy,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            _buildGapCard(),

                            const SizedBox(height: 15),

                            // Common Mistake
                            _buildCommonMistakeCard(),

                            const SizedBox(height: 20),

                            // Career Match
                            _buildCareerMatchCard(),

                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Status bar
              _buildStatusBar(),
            ],
          ),
        ),
      ),

      // ========================================================
      // BOTTOM CHAT INPUT
      // ========================================================

      bottomSheet: _buildBottomChatInput(),
    );
  }

  // ============================================================
  // LIVE INSIGHT CARD
  // ============================================================

  Widget _buildInsightCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: insightBlue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "LIVE INSIGHT",
            style: TextStyle(
              color: subtitleBlue,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            _sessionData["liveInsight"] as String,
            style: const TextStyle(
              color: navy,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // POTENTIAL GAP CARD
  // ============================================================

  Widget _buildGapCard() {
    final Map<String, dynamic> gap =
        Map<String, dynamic>.from(
      _sessionData["potentialGap"] as Map,
    );

    final double progress =
        (gap["progress"] as num).toDouble();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: navy.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.adjust_rounded,
            color: navy,
            size: 22,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  gap["label"] as String,
                  style: const TextStyle(
                    color: navy,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 6),

                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor:
                        const Color(0xFFEEEEEE),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
                      Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Text(
            "${(progress * 100).round()}%",
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMMON MISTAKE CARD
  // ============================================================

  Widget _buildCommonMistakeCard() {
    final Map<String, dynamic> mistake =
        Map<String, dynamic>.from(
      _sessionData["commonMistake"] as Map,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.error_outline,
                color: brandRed,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                "Common Mistake",
                style: TextStyle(
                  color: brandRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            mistake["wrong"] as String,
            style: const TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.lineThrough,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 18,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  mistake["correct"] as String,
                  style: const TextStyle(
                    color: navy,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CAREER MATCH CARD
  // ============================================================

  Widget _buildCareerMatchCard() {
    final Map<String, dynamic> career =
        Map<String, dynamic>.from(
      _sessionData["careerMatch"] as Map,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFF8F9FA),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.indigo,
                child: Icon(
                  Icons.engineering,
                  color: Colors.white,
                  size: 16,
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: matchGreen,
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: Text(
                  "${career["match"]}% Match",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            career["title"] as String,
            style: const TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Design safe bridges and machines...",
            style: TextStyle(
              color: subtitleBlue,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS BAR
  // ============================================================

  Widget _buildStatusBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      color: const Color(0xFFF8F9FA),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "● AI Analysis Active",
            style: TextStyle(
              color: Colors.green,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            "Session: ${_sessionData["sessionDuration"]}",
            style: const TextStyle(
              color: subtitleBlue,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM CHAT INPUT
  // ============================================================

  Widget _buildBottomChatInput() {
    return Container(
      height: 65,
      padding:
          const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFF2F2F2),
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 65),

          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4F8),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.graphic_eq,
                    color: matchGreen,
                    size: 18,
                  ),

                  SizedBox(width: 10),

                  Text(
                    "Ask me about friction...",
                    style: TextStyle(
                      color: subtitleBlue,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}