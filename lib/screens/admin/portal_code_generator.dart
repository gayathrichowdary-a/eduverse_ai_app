import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ---------------------------------------------------------------
// Shared design tokens for this screen (inlined — no shared theme
// file). Kept identical across all 5 admin screens so they stay
// visually consistent even without a common import.
// ---------------------------------------------------------------
class AppColors {
  static const Color primary = Color(0xFF4F46E5); // Indigo
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color background = Color(0xFFF7F8FC);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);
  static const Color easy = Color(0xFF16A34A);
  static const Color medium = Color(0xFFD97706);
  static const Color hard = Color(0xFFDC2626);
}

class AppTextStyles {
  static const TextStyle screenTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle cardValue = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );
  static const TextStyle cardLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}

/// Reusable card container so this screen's sections share the
/// same corner radius / shadow / padding treatment.
class AdminCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AdminCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Small colored status/label pill used across list rows.
class StatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const StatusPill({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Standard admin app bar so this screen's title bar matches the
/// rest of the admin module.
PreferredSizeWidget adminAppBar(String title, {List<Widget>? actions}) {
  return AppBar(
    title: Text(title, style: AppTextStyles.screenTitle),
    backgroundColor: AppColors.background,
    elevation: 0,
    foregroundColor: AppColors.textPrimary,
    actions: actions,
  );
}

/// Admin > Portal Code Generator
///
/// Generates unique registration codes for colleges (e.g. to hand
/// out so a college can self-onboard onto the platform).
class PortalCodeGeneratorScreen extends StatefulWidget {
  const PortalCodeGeneratorScreen({super.key});

  @override
  State<PortalCodeGeneratorScreen> createState() =>
      _PortalCodeGeneratorScreenState();
}

class _PortalCodeGeneratorScreenState
    extends State<PortalCodeGeneratorScreen> {
  final List<String> _colleges = const [
    'Nexora Institute of Technology',
    'Greenfield University',
    'Coastal College of Engineering',
    'Summit Polytechnic',
  ];

  final List<String> _codeTypes = const [
    'College Registration',
    'Instructor Onboarding',
    'Bulk Student Invite',
  ];

  final List<String> _expiryOptions = const [
    '7 Days',
    '15 Days',
    '30 Days',
    '90 Days',
    'No Expiry',
  ];

  String? _selectedCollege;
  String _codeType = 'College Registration';
  String _expiry = '30 Days';
  int _quantity = 1;

  final List<String> _generatedCodes = [];
  bool _generating = false;

  String _generateOneCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // no ambiguous chars
    final rand = Random.secure();
    String block() =>
        List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join();
    return 'NG-${block()}-${block()}';
  }

  Future<void> _generate() async {
    if (_selectedCollege == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a college first')),
      );
      return;
    }
    setState(() => _generating = true);
    await Future.delayed(const Duration(milliseconds: 500));
    final codes = List.generate(_quantity, (_) => _generateOneCode());
    setState(() {
      _generatedCodes
        ..clear()
        ..addAll(codes);
      _generating = false;
    });
  }

  void _copyCodes() {
    if (_generatedCodes.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _generatedCodes.join('\n')));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_generatedCodes.length == 1
            ? 'Code copied to clipboard'
            : '${_generatedCodes.length} codes copied to clipboard'),
      ),
    );
  }

  void _downloadCodes() {
    // Hook this up to your file-export / share flow.
    if (_generatedCodes.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preparing download...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: adminAppBar('Unique Portal Code'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('College', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCollege,
                  hint: const Text('Select College'),
                  decoration: const InputDecoration(border: InputBorder.none),
                  items: _colleges
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCollege = v),
                ),
                const Divider(height: 28),

                Text('Code Type', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _codeType,
                  decoration: const InputDecoration(border: InputBorder.none),
                  items: _codeTypes
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _codeType = v ?? _codeType),
                ),
                const Divider(height: 28),

                Text('Expiry', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _expiry,
                  decoration: const InputDecoration(border: InputBorder.none),
                  items: _expiryOptions
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _expiry = v ?? _expiry),
                ),
                const Divider(height: 28),

                Text('Quantity', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Expanded(
                      child: Text(
                        '$_quantity',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.cardValue,
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: _quantity < 100
                          ? () => setState(() => _quantity++)
                          : null,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _generating ? null : _generate,
              icon: _generating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.qr_code_2_outlined),
              label: Text(_generating ? 'Generating...' : 'Generate Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          if (_generatedCodes.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              _generatedCodes.length == 1
                  ? 'Generated Code'
                  : 'Generated Codes (${_generatedCodes.length})',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: 10),
            AdminCard(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _generatedCodes
                    .map((code) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: AppColors.primary.withOpacity(0.2)),
                          ),
                          child: Text(
                            code,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _copyCodes,
                    icon: const Icon(Icons.copy_outlined, size: 18),
                    label: const Text('Copy'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _downloadCodes,
                    icon: const Icon(Icons.download_outlined, size: 18),
                    label: const Text('Download'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}