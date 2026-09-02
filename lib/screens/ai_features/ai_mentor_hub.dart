import 'package:flutter/material.dart';
import '../settings/settings_profile.dart';

class AiMentorHub extends StatefulWidget {
  final String studentName;
  const AiMentorHub({super.key, this.studentName = 'Akhil'});

  @override
  State<AiMentorHub> createState() => _AiMentorHubState();
}

class _AiMentorHubState extends State<AiMentorHub> {
  // Navigation State
  String activeTab = 'Code Help'; // Code Help, Debug, Interview

  // Palette - Defined correctly
  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color bgGrey = Color(0xFFF7F9FB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: navy),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          "SOPHIA AI MENTOR",
          style: TextStyle(
            color: navy,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          // Voice Assistant entry point (separate feature from the spec)
          IconButton(
            icon: const Icon(Icons.mic_none_rounded, color: navy),
            onPressed: () {
              // TODO: navigate to the standalone Voice Assistant screen
              // Navigator.push(context, MaterialPageRoute(builder: (_) => const VoiceAssistantScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: navy),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsProfile()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // --- Segmented Toggle ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: bgGrey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: ['Code Help', 'Debug', 'Interview'].map((tab) {
                  bool isSelected = activeTab == tab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => activeTab = tab),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? navy : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          tab,
                          style: TextStyle(
                            color: isSelected ? Colors.white : subtitleBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildMentorHeader(), // Sophia stays visible on all tabs
                  const SizedBox(height: 25),

                  // SWITCH CONTENT BASED ON TAB
                  if (activeTab == 'Code Help') _buildCodeHelpContent(),
                  if (activeTab == 'Debug') _buildDebugContent(),
                  if (activeTab == 'Interview') _buildInterviewContent(),

                  const SizedBox(height: 100), // Space for input bar
                ],
              ),
            ),
          ),

          // --- Bottom AI Input Bar ---
          _buildBottomInputBar(),
        ],
      ),
    );
  }

  // --- 1. CODE HELP CONTENT ---
  // Real-time code explanations, per spec.
  Widget _buildCodeHelpContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMasteryCard(),
        const SizedBox(height: 25),
        const Text("Quick Topics", style: TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 1.3,
          children: [
            _buildBalanceTile(Icons.data_object_rounded, "Arrays", "12 explanations", brandRed),
            _buildBalanceTile(Icons.account_tree_rounded, "Recursion", "8 explanations", Colors.blue),
            _buildBalanceTile(Icons.storage_rounded, "SQL Joins", "5 explanations", Colors.cyan),
            _buildBalanceTile(Icons.hub_rounded, "OOP Concepts", "10 explanations", Colors.green),
          ],
        ),
        const SizedBox(height: 25),
        _buildQuoteCard(),
      ],
    );
  }

  // --- 2. DEBUG CONTENT ---
  // Debugging hints, per spec.
  Widget _buildDebugContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Debugging Hints", style: TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildInsightCard("Check for off-by-one errors in loops", Icons.repeat_rounded, Colors.orange),
        _buildInsightCard("Trace variable state with print/log statements", Icons.terminal_rounded, Colors.blue),
        _buildInsightCard("Watch for null or undefined references", Icons.report_gmailerrorred_rounded, brandRed),
        _buildInsightCard("Re-check your base case in recursive calls", Icons.change_history_rounded, Colors.purple),
      ],
    );
  }

  // --- 3. INTERVIEW CONTENT ---
  // Mock interview practice, per spec.
  Widget _buildInterviewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Mock Interview Practice", style: TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildInsightCard("Technical: Reverse a Linked List", Icons.code_rounded, Colors.purple),
        _buildInsightCard("Technical: Two Sum Problem", Icons.functions_rounded, Colors.amber),
        _buildInsightCard("Behavioral: A challenging bug you fixed", Icons.forum_rounded, brandRed),
        _buildInsightCard("System Design: Rate limiter basics", Icons.schema_rounded, Colors.blue),
      ],
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildMentorHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: navy.withValues(alpha: 0.1), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 28, backgroundColor: Color(0xFF4FC3F7), child: Text("🤖", style: TextStyle(fontSize: 28))),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Sophia", style: TextStyle(color: navy, fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                Row(children: const [
                  CircleAvatar(radius: 4, backgroundColor: Colors.green),
                  SizedBox(width: 6),
                  Text("Ready to help you code!", style: TextStyle(color: subtitleBlue, fontSize: 13)),
                ])
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInsightCard(String text, IconData icon, Color color) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: bgGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color, size: 20)),
        title: Text(text, style: const TextStyle(color: navy, fontSize: 14, fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right, color: subtitleBlue, size: 18),
        onTap: () {
          // TODO: open this item in Sophia's chat with context pre-loaded
        },
      ),
    );
  }

  Widget _buildMasteryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: bgGrey, borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: [
          const SizedBox(height: 60, width: 60, child: CircularProgressIndicator(value: 0.75, strokeWidth: 8, backgroundColor: Colors.white, valueColor: AlwaysStoppedAnimation<Color>(brandRed))),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Concepts Mastered", style: TextStyle(color: subtitleBlue, fontSize: 13)),
                SizedBox(height: 4),
                Text("3 Topics Explained Today", style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Top 5% of learners today!", style: TextStyle(color: subtitleBlue, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBalanceTile(IconData icon, String title, String sub, Color color) {
    return GestureDetector(
      onTap: () {
        // TODO: open a real-time code explanation session for this topic
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const Spacer(),
            Text(title, style: const TextStyle(color: navy, fontWeight: FontWeight.bold, fontSize: 15)),
            Text(sub, style: const TextStyle(color: subtitleBlue, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.format_quote_rounded, color: brandRed, size: 30),
          Text("First, solve the problem. Then, write the code.", style: TextStyle(color: navy, fontStyle: FontStyle.italic, fontSize: 16, height: 1.4)),
          SizedBox(height: 8),
          Text("- John Johnson", style: TextStyle(color: subtitleBlue, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBottomInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))]),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Ask Sophia...",
                hintStyle: const TextStyle(color: subtitleBlue, fontSize: 14),
                prefixIcon: const Icon(Icons.psychology_outlined, color: navy),
                filled: true,
                fillColor: bgGrey,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(radius: 25, backgroundColor: brandRed, child: Icon(Icons.mic, color: Colors.white)),
        ],
      ),
    );
  }
}