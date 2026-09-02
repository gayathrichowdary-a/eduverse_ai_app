import 'package:flutter/material.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  // Project Colors
  static const Color navy = Color(0xFF1F355C);
  static const Color yellow = Color(0xFFFFD52E);
  static const Color red = Color(0xFFE94A56);
  static const Color green = Color(0xFF57B97A);

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
              decoration: const BoxDecoration(color: yellow),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all(color: navy, width: 2),
                      ),
                      child: const Icon(Icons.arrow_back, color: navy, size: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text("Subscription", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: navy)),
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
                      //================ CURRENT PLAN =================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(color: const Color(0xFFF7C948), borderRadius: BorderRadius.circular(10)),
                              child: const Text("CURRENT PLAN", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: navy)),
                            ),
                            const SizedBox(height: 12),
                            const Text("EduVerse AI Pro", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                            const Text("Renews on Aug 15, 2026", style: TextStyle(fontSize: 12, color: Colors.white70)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 26),
                      const Text("What's Included", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: navy)),
                      const SizedBox(height: 12),
                      const _FeatureRow(text: "Unlimited AI Mentor chats"),
                      const _FeatureRow(text: "Personalized study plans"),
                      const _FeatureRow(text: "Advanced progress analytics"),
                      const _FeatureRow(text: "Priority support response"),
                      const _FeatureRow(text: "Offline lesson downloads"),

                      const SizedBox(height: 26),
                      
                      //================ BILLING CYCLE =================
                      _buildInfoCard(
                        context,
                        title: "Billing Cycle",
                        value: "Monthly - ₹499/mo",
                        buttonText: "Change",
                        onTap: () => _showToast(context, "Opening billing options..."),
                      ),

                      const SizedBox(height: 15),

                      //================ PAYMENT METHOD (Added) =================
                      _buildInfoCard(
                        context,
                        title: "Payment Method",
                        value: "Visa •••• 4242",
                        buttonText: "Edit",
                        onTap: () => _showToast(context, "Opening payment settings..."),
                      ),

                      const SizedBox(height: 30),

                      //================ CANCEL BUTTON =================
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _showCancelDialog(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: red,
                            side: const BorderSide(color: red, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text("Cancel Subscription", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      const Center(
                        child: Text("Need help with billing? Contact Support", 
                        style: TextStyle(color: subtitleBlue, fontSize: 13, decoration: TextDecoration.underline)),
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

  // --- Helper: Info Card ---
  Widget _buildInfoCard(BuildContext context, {required String title, required String value, required String buttonText, required VoidCallback onTap}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: navy, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: navy)),
              ],
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(buttonText, style: const TextStyle(color: red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Cancel Subscription?"),
        content: const Text("You'll lose access to AI Pro features at the end of your billing cycle."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Keep Plan")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showToast(context, "Subscription will cancel at period end");
            },
            child: const Text("Cancel Plan", style: TextStyle(color: red)),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;
  const _FeatureRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF57B97A), size: 18),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 14, color: Color(0xFF1F355C))),
        ],
      ),
    );
  }
}

// Added to maintain project styling
const Color subtitleBlue = Color(0xFF4D86AD);