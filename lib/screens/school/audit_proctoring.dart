import 'package:flutter/material.dart';


final List<BoxShadow> _softShadow = [
  BoxShadow(
    color: const Color(0xFF0B2F63).withValues(alpha: 0.06),
    blurRadius: 16,
    offset: const Offset(0, 6),
  ),
];

/// SCHOOL / audit_proctoring.dart
///
/// College reviews AI interview/proctoring violations and
/// makes access decisions.
/// Styled to match SchoolDashboard (navy + soft indigo theme).
class AuditProctoringScreen extends StatefulWidget {
  const AuditProctoringScreen({super.key});

  @override
  State<AuditProctoringScreen> createState() => _AuditProctoringScreenState();
}

enum RiskLevel { low, medium, high }

extension on RiskLevel {
  String get label => switch (this) {
        RiskLevel.low => 'Low',
        RiskLevel.medium => 'Medium',
        RiskLevel.high => 'High',
      };

  Color get color => switch (this) {
        RiskLevel.low => const Color(0xFF57B97A),
        RiskLevel.medium => const Color(0xFFF7C948),
        RiskLevel.high => const Color(0xFFF12C68),
      };
}

enum AccessDecision { pending, approved, rejected, flagged }

extension on AccessDecision {
  String get label => switch (this) {
        AccessDecision.pending => 'Pending',
        AccessDecision.approved => 'Approved',
        AccessDecision.rejected => 'Rejected',
        AccessDecision.flagged => 'Flagged',
      };

  Color get color => switch (this) {
        AccessDecision.pending => Color(0xFF7B8798),
        AccessDecision.approved => const Color(0xFF57B97A),
        AccessDecision.rejected => const Color(0xFFF12C68),
        AccessDecision.flagged => const Color(0xFFF7C948),
      };
}

class _ProctoringRecord {
  _ProctoringRecord({
    required this.studentName,
    required this.studentId,
    required this.violationCount,
    required this.riskLevel,
    required this.reportSummary,
    this.decision = AccessDecision.pending,
  });

  final String studentName;
  final String studentId;
  final int violationCount;
  final RiskLevel riskLevel;
  final String reportSummary;
  AccessDecision decision;
}

class _AuditProctoringScreenState extends State<AuditProctoringScreen> {
  static const Color navy = Color(0xFF0B2F63);
  static const Color surface = Colors.white;

  final List<_ProctoringRecord> _records = [
    _ProctoringRecord(
      studentName: 'Ananya Sharma',
      studentId: 'S-1001',
      violationCount: 5,
      riskLevel: RiskLevel.high,
      reportSummary:
          'Multiple face-not-visible events and a secondary voice detected during the AI interview session.',
    ),
    _ProctoringRecord(
      studentName: 'Rohan Verma',
      studentId: 'S-1002',
      violationCount: 2,
      riskLevel: RiskLevel.medium,
      reportSummary:
          'Tab switch detected twice; gaze diverted from screen for over 15 seconds combined.',
    ),
    _ProctoringRecord(
      studentName: 'Karthik Iyer',
      studentId: 'S-1004',
      violationCount: 1,
      riskLevel: RiskLevel.low,
      reportSummary: 'Brief background noise flagged; no visual violations recorded.',
      decision: AccessDecision.approved,
    ),
  ];

  RiskLevel? _riskFilter;

  List<_ProctoringRecord> get _filtered => _riskFilter == null
      ? _records
      : _records.where((r) => r.riskLevel == _riskFilter).toList();

  void _setDecision(_ProctoringRecord r, AccessDecision decision) {
    setState(() => r.decision = decision);
    Navigator.of(context, rootNavigator: true).maybePop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${r.studentName}: marked as ${decision.label}')),
    );
  }

  void _openReview(_ProctoringRecord r) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      r.studentName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: navy),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: r.riskLevel.color.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('${r.riskLevel.label} risk',
                        style: TextStyle(color: r.riskLevel.color, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('ID: ${r.studentId} · Violations: ${r.violationCount}',
                  style: TextStyle(color: const Color(0xFF7B8798))),
              const SizedBox(height: 14),
              const Text('Report', style: TextStyle(fontWeight: FontWeight.w800, color: navy)),
              const SizedBox(height: 4),
              Text(r.reportSummary),
              const SizedBox(height: 16),
              Text('Current status: ${r.decision.label}',
                  style: TextStyle(color: r.decision.color, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF57B97A),
                        side: const BorderSide(color: Color(0xFF57B97A)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.check_circle_rounded),
                      label: const Text('Approve'),
                      onPressed: () => _setDecision(r, AccessDecision.approved),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFF7A800),
                        side: const BorderSide(color: Color(0xFFF7A800)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.flag_rounded),
                      label: const Text('Flag'),
                      onPressed: () => _setDecision(r, AccessDecision.flagged),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF12C68),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  icon: const Icon(Icons.cancel_rounded),
                  label: const Text('Reject Access', style: TextStyle(fontWeight: FontWeight.w700)),
                  onPressed: () => _setDecision(r, AccessDecision.rejected),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FD),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: _softShadow,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_rounded, color: navy),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2),
        boxShadow: _softShadow,
                    ),
                    child: const Icon(Icons.fact_check_rounded, color: navy),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Audit & Proctoring',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: navy)),
                        Text('Review AI interview violations',
                            style: TextStyle(
                                fontSize: 12.5, color: Color(0xFF7B8798), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _FilterChipButton(
                      label: 'All',
                      selected: _riskFilter == null,
                      onTap: () => setState(() => _riskFilter = null),
                    ),
                    const SizedBox(width: 8),
                    ...RiskLevel.values.map(
                      (level) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _FilterChipButton(
                          label: level.label,
                          selected: _riskFilter == level,
                          onTap: () => setState(() => _riskFilter = level),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(
                      child: Text('No records match this filter', style: TextStyle(color: Color(0xFF7B8798))))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final r = _filtered[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2),
        boxShadow: _softShadow,
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
                                      color: r.riskLevel.color,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.person_rounded, color: Colors.white, size: 20),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(r.studentName,
                                            style: const TextStyle(
                                                fontSize: 15.5, fontWeight: FontWeight.w800, color: navy)),
                                        Text('ID: ${r.studentId}',
                                            style: TextStyle(color: const Color(0xFF7B8798), fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: r.riskLevel.color.withValues(alpha: .15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text('${r.riskLevel.label} risk',
                                        style: TextStyle(
                                            color: r.riskLevel.color,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.warning_amber_rounded, size: 16, color: const Color(0xFF7B8798)),
                                  const SizedBox(width: 4),
                                  Text('${r.violationCount} violation(s)',
                                      style: TextStyle(color: const Color(0xFF7B8798), fontSize: 12.5)),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: r.decision.color.withValues(alpha: .15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(r.decision.label,
                                        style: TextStyle(
                                            color: r.decision.color,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: navy,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 13),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  ),
                                  onPressed: () => _openReview(r),
                                  icon: const Icon(Icons.rate_review_rounded, size: 18),
                                  label: const Text('Review', style: TextStyle(fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const Color navy = Color(0xFF0B2F63);
  static const Color surface = Colors.white;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4F46E5) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE6E2F7), width: 1.2),
        boxShadow: _softShadow,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : navy,
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
          ),
        ),
      ),
    );
  }
}