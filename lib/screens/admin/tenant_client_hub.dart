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

/// Admin > Tenant Client Hub
///
/// Manage university/college clients: list, add, view details,
/// toggle active/inactive, and track subscription + headcounts.
class TenantClientHubScreen extends StatefulWidget {
  const TenantClientHubScreen({super.key});

  @override
  State<TenantClientHubScreen> createState() => _TenantClientHubScreenState();
}

class University {
  String name;
  String location;
  bool isActive;
  String subscriptionPlan; // e.g. 'Premium', 'Standard', 'Trial'
  DateTime subscriptionEnds;
  int studentCount;
  int instructorCount;

  University({
    required this.name,
    required this.location,
    required this.isActive,
    required this.subscriptionPlan,
    required this.subscriptionEnds,
    required this.studentCount,
    required this.instructorCount,
  });
}

class _TenantClientHubScreenState extends State<TenantClientHubScreen> {
  final List<University> _universities = [
    University(
      name: 'Nexora Institute of Technology',
      location: 'Bengaluru, KA',
      isActive: true,
      subscriptionPlan: 'Premium',
      subscriptionEnds: DateTime(2027, 3, 31),
      studentCount: 2140,
      instructorCount: 86,
    ),
    University(
      name: 'Greenfield University',
      location: 'Pune, MH',
      isActive: true,
      subscriptionPlan: 'Standard',
      subscriptionEnds: DateTime(2026, 12, 15),
      studentCount: 980,
      instructorCount: 42,
    ),
    University(
      name: 'Coastal College of Engineering',
      location: 'Kochi, KL',
      isActive: false,
      subscriptionPlan: 'Trial',
      subscriptionEnds: DateTime(2026, 9, 1),
      studentCount: 310,
      instructorCount: 15,
    ),
  ];

  String _query = '';

  List<University> get _filtered {
    if (_query.trim().isEmpty) return _universities;
    final q = _query.toLowerCase();
    return _universities
        .where((u) =>
            u.name.toLowerCase().contains(q) ||
            u.location.toLowerCase().contains(q))
        .toList();
  }

  void _openAddUniversitySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddUniversitySheet(
        onAdd: (u) => setState(() => _universities.add(u)),
      ),
    );
  }

  void _openDetails(University u) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _UniversityDetailsSheet(
        university: u,
        onToggleActive: () => setState(() => u.isActive = !u.isActive),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: adminAppBar('Client Hub'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddUniversitySheet,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Add University'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search universities...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text('No universities found',
                        style: AppTextStyles.caption))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, i) =>
                        _UniversityCard(
                      university: _filtered[i],
                      onManage: () => _openDetails(_filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _UniversityCard extends StatelessWidget {
  final University university;
  final VoidCallback onManage;

  const _UniversityCard({required this.university, required this.onManage});

  @override
  Widget build(BuildContext context) {
    final u = university;
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.account_balance_outlined,
                    color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(u.name,
                        style: AppTextStyles.sectionTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(u.location, style: AppTextStyles.caption),
                  ],
                ),
              ),
              StatusPill(
                label: u.isActive ? 'Active' : 'Inactive',
                color: u.isActive ? AppColors.success : AppColors.danger,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _MiniStat(
                icon: Icons.school_outlined,
                label: 'Students',
                value: u.studentCount.toString(),
              ),
              const SizedBox(width: 20),
              _MiniStat(
                icon: Icons.person_outline,
                label: 'Instructors',
                value: u.instructorCount.toString(),
              ),
              const Spacer(),
              StatusPill(
                label: u.subscriptionPlan,
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onManage,
              icon: const Icon(Icons.settings_outlined, size: 18),
              label: const Text('Manage'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MiniStat(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text('$value ', style: AppTextStyles.body),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _AddUniversitySheet extends StatefulWidget {
  final void Function(University) onAdd;
  const _AddUniversitySheet({required this.onAdd});

  @override
  State<_AddUniversitySheet> createState() => _AddUniversitySheetState();
}

class _AddUniversitySheetState extends State<_AddUniversitySheet> {
  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _studentsCtrl = TextEditingController();
  final _instructorsCtrl = TextEditingController();
  String _plan = 'Standard';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _studentsCtrl.dispose();
    _instructorsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameCtrl.text.trim().isEmpty || _locationCtrl.text.trim().isEmpty) {
      return;
    }
    widget.onAdd(University(
      name: _nameCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      isActive: true,
      subscriptionPlan: _plan,
      subscriptionEnds: DateTime.now().add(const Duration(days: 365)),
      studentCount: int.tryParse(_studentsCtrl.text) ?? 0,
      instructorCount: int.tryParse(_instructorsCtrl.text) ?? 0,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add University', style: AppTextStyles.screenTitle),
            const SizedBox(height: 16),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'University Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationCtrl,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _studentsCtrl,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Student Count'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _instructorsCtrl,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Instructor Count'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _plan,
              decoration: const InputDecoration(labelText: 'Subscription Plan'),
              items: const [
                DropdownMenuItem(value: 'Trial', child: Text('Trial')),
                DropdownMenuItem(value: 'Standard', child: Text('Standard')),
                DropdownMenuItem(value: 'Premium', child: Text('Premium')),
              ],
              onChanged: (v) => setState(() => _plan = v ?? _plan),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Add University'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UniversityDetailsSheet extends StatefulWidget {
  final University university;
  final VoidCallback onToggleActive;

  const _UniversityDetailsSheet({
    required this.university,
    required this.onToggleActive,
  });

  @override
  State<_UniversityDetailsSheet> createState() =>
      _UniversityDetailsSheetState();
}

class _UniversityDetailsSheetState extends State<_UniversityDetailsSheet> {
  @override
  Widget build(BuildContext context) {
    final u = widget.university;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(u.name, style: AppTextStyles.screenTitle)),
              StatusPill(
                label: u.isActive ? 'Active' : 'Inactive',
                color: u.isActive ? AppColors.success : AppColors.danger,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(u.location, style: AppTextStyles.caption),
          const SizedBox(height: 20),
          _DetailRow(label: 'Subscription Plan', value: u.subscriptionPlan),
          _DetailRow(
            label: 'Renews / Expires',
            value:
                '${u.subscriptionEnds.day}/${u.subscriptionEnds.month}/${u.subscriptionEnds.year}',
          ),
          _DetailRow(label: 'Student Count', value: u.studentCount.toString()),
          _DetailRow(
              label: 'Instructor Count', value: u.instructorCount.toString()),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(widget.onToggleActive);
                  },
                  icon: Icon(u.isActive
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline),
                  label: Text(u.isActive ? 'Deactivate' : 'Activate'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        u.isActive ? AppColors.danger : AppColors.success,
                    side: BorderSide(
                      color: u.isActive ? AppColors.danger : AppColors.success,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit Details'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
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
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption),
          Text(value, style: AppTextStyles.body),
        ],
      ),
    );
  }
}