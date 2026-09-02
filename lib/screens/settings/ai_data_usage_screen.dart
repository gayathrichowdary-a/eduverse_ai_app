import 'package:flutter/material.dart';

class AiDataUsageScreen extends StatefulWidget {
  const AiDataUsageScreen({super.key});

  @override
  State<AiDataUsageScreen> createState() => _AiDataUsageScreenState();
}

class _AiDataUsageScreenState extends State<AiDataUsageScreen> {
  bool useForTraining = true;
  bool personalizedInsights = true;
  bool voiceDataStorage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [

            //================ HEADER =================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              decoration: const BoxDecoration(
                color: Color(0xFFFFD52E),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all(
                          color: const Color(0xFF1F355C),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1F355C),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    "AI Data Usage",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F355C),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF7FF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(Icons.info_outline,
                                size: 18, color: Color(0xFF1F355C)),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "These settings control how your learning data is used to personalize your AI Mentor experience.",
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.4,
                                  color: Color(0xFF1F355C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF1F355C),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            _DataToggleRow(
                              title: "Use my data to improve AI models",
                              subtitle:
                                  "Helps train better learning recommendations",
                              value: useForTraining,
                              onChanged: (val) {
                                setState(() {
                                  useForTraining = val;
                                });
                              },
                            ),
                            const Divider(height: 1, color: Color(0xFFEFEFEF)),
                            _DataToggleRow(
                              title: "Personalized Insights",
                              subtitle:
                                  "AI Mentor uses your progress to tailor advice",
                              value: personalizedInsights,
                              onChanged: (val) {
                                setState(() {
                                  personalizedInsights = val;
                                });
                              },
                            ),
                            const Divider(height: 1, color: Color(0xFFEFEFEF)),
                            _DataToggleRow(
                              title: "Store Voice Data",
                              subtitle:
                                  "Save voice recordings for AI Mentor chats",
                              value: voiceDataStorage,
                              onChanged: (val) {
                                setState(() {
                                  voiceDataStorage = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 26),

                      const Text(
                        "Data Management",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F355C),
                        ),
                      ),

                      const SizedBox(height: 10),

                      _ActionRow(
                        icon: Icons.download_outlined,
                        iconColor: const Color(0xFF58C7F3),
                        title: "Export My Data",
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Preparing data export...")),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _ActionRow(
                        icon: Icons.delete_outline,
                        iconColor: const Color(0xFFE94A56),
                        title: "Delete My Learning Data",
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Text("Delete Learning Data?"),
                              content: const Text(
                                "This will permanently erase your AI Mentor's memory of your progress. This cannot be undone.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Learning data deleted"),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(
                                        color: Color(0xFFE94A56)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

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

class _DataToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _DataToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F355C),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFFE94A56),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF1F355C),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F355C),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF1F355C)),
          ],
        ),
      ),
    );
  }
}