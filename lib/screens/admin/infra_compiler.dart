import 'package:flutter/material.dart';

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
            color: Colors.black.withValues(alpha: 0.03),
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
        color: color.withValues(alpha: 0.12),
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

/// Admin > Infrastructure Compiler
///
/// Lets an admin update server URL / API endpoint / API key and
/// switch between Development and Production environments.
///
/// NOTE: The API key field is always masked in the UI and never
/// pre-filled with a real secret — it should be loaded/saved via a
/// secure backend call, never hardcoded in the client.
class InfraCompilerScreen extends StatefulWidget {
  const InfraCompilerScreen({super.key});

  @override
  State<InfraCompilerScreen> createState() => _InfraCompilerScreenState();
}

enum InfraEnvironment { development, production }

class _InfraCompilerScreenState extends State<InfraCompilerScreen> {
  final _serverUrlCtrl =
      TextEditingController(text: 'https://api.yourdomain.example');
  final _apiEndpointCtrl =
      TextEditingController(text: 'https://api.yourdomain.example/v1');
  // Never store or display a real key here — placeholder/masked only.
  final _apiKeyCtrl = TextEditingController(text: '••••••••••••••••');

  InfraEnvironment _environment = InfraEnvironment.development;
  bool _obscureKey = true;
  final bool _isOnline = true;
  bool _saving = false;

  @override
  void dispose() {
    _serverUrlCtrl.dispose();
    _apiEndpointCtrl.dispose();
    _apiKeyCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveConfiguration() async {
    setState(() => _saving = true);
    // Wire this up to your real config-save endpoint.
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuration saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: adminAppBar('Infrastructure'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Server status
          AdminCard(
            child: Row(
              children: [
                Text('Server Status', style: AppTextStyles.sectionTitle),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _isOnline ? AppColors.success : AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _isOnline ? 'Online' : 'Offline',
                  style: AppTextStyles.body.copyWith(
                    color: _isOnline ? AppColors.success : AppColors.danger,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Server Configuration
          Text('Server Configuration', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          AdminCard(
            child: TextField(
              controller: _serverUrlCtrl,
              decoration: const InputDecoration(
                labelText: 'Server URL',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // API Configuration
          Text('API Configuration', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          AdminCard(
            child: Column(
              children: [
                TextField(
                  controller: _apiEndpointCtrl,
                  decoration: const InputDecoration(
                    labelText: 'API Endpoint',
                    border: InputBorder.none,
                  ),
                ),
                const Divider(height: 24),
                TextField(
                  controller: _apiKeyCtrl,
                  obscureText: _obscureKey,
                  enableSuggestions: false,
                  autocorrect: false,
                  // Masked display only — do not surface the real
                  // secret value in this client.
                  decoration: InputDecoration(
                    labelText: 'API Key',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureKey
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () =>
                          setState(() => _obscureKey = !_obscureKey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Environment
          Text('Environment', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          AdminCard(
            child: Column(
              children: [
                RadioListTile<InfraEnvironment>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Development'),
                  value: InfraEnvironment.development,
                  groupValue: _environment,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _environment = v!),
                ),
                RadioListTile<InfraEnvironment>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Production'),
                  value: InfraEnvironment.production,
                  groupValue: _environment,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _environment = v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _saveConfiguration,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Save Configuration'),
            ),
          ),
        ],
      ),
    );
  }
}