import 'package:flutter/material.dart';

import 'manage_schools.dart';
import 'manage_teachers.dart';
import 'manage_students.dart';
import 'system_reports.dart';
import 'platform_settings.dart';
import 'global_analytics.dart';
import 'tenant_client_hub.dart';
import 'infra_compiler.dart';
import 'cms_bank.dart';
import 'portal_code_generator.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  static const Color navy = Color(0xFF1D3B64);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color yellow = Color(0xFFFFD52E);

  // ============================================================
  // NAVIGATION FUNCTIONS
  // ============================================================

  void _openManageSchools(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ManageSchools(),
      ),
    );
  }

  void _openManageTeachers(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ManageTeachers(),
      ),
    );
  }

  void _openManageStudents(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ManageStudents(),
      ),
    );
  }

  void _openSystemReports(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SystemReports(),
      ),
    );
  }

  void _openPlatformSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PlatformSettings(),
      ),
    );
  }

  void _openGlobalAnalytics(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GlobalAnalyticsScreen(),
      ),
    );
  }

  void _openTenantClientHub(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TenantClientHubScreen(),
      ),
    );
  }

  void _openInfraCompiler(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InfraCompilerScreen(),
      ),
    );
  }

  void _openCmsBank(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CmsBankScreen(),
      ),
    );
  }

  void _openPortalCodeGenerator(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PortalCodeGeneratorScreen(),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ==================================================
              // HEADER
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  28,
                ),
                decoration: const BoxDecoration(
                  color: navy,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------- HEADER ROW ----------------

                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: const Icon(
                            Icons.account_balance,
                            color: navy,
                          ),
                        ),

                        const SizedBox(width: 14),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Admin Console",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "System-wide overview",
                                style: TextStyle(
                                  color: Color(0xFFB9C6D6),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            Navigator.of(context).maybePop();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // ---------------- STAT CARDS ----------------

                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: "Schools",
                            value: "12",
                            color: yellow,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _StatCard(
                            label: "Teachers",
                            value: "184",
                            color: yellow,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _StatCard(
                            label: "Students",
                            value: "6.2K",
                            color: yellow,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // MODULE LIST
              // ==================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Manage Platform",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: navy,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // 1. MANAGE SCHOOLS
                    // ==================================================

                    _AdminModuleTile(
                      icon: Icons.business_rounded,
                      color: const Color(0xFF58C7F3),
                      title: "Manage Schools",
                      subtitle:
                          "Add, edit, or remove schools",
                      onTap: () {
                        _openManageSchools(context);
                      },
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // 2. MANAGE TEACHERS
                    // ==================================================

                    _AdminModuleTile(
                      icon: Icons.psychology_rounded,
                      color: const Color(0xFFE94A56),
                      title: "Manage Teachers",
                      subtitle:
                          "Approve and oversee teacher accounts",
                      onTap: () {
                        _openManageTeachers(context);
                      },
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // 3. MANAGE STUDENTS
                    // ==================================================

                    _AdminModuleTile(
                      icon: Icons.groups_rounded,
                      color: const Color(0xFF57B97A),
                      title: "Manage Students",
                      subtitle:
                          "View and manage student accounts",
                      onTap: () {
                        _openManageStudents(context);
                      },
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // 4. SYSTEM REPORTS
                    // ==================================================

                    _AdminModuleTile(
                      icon: Icons.bar_chart_rounded,
                      color: const Color(0xFFF7C948),
                      title: "System Reports",
                      subtitle:
                          "Platform-wide usage and performance",
                      onTap: () {
                        _openSystemReports(context);
                      },
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // 5. PLATFORM SETTINGS
                    // ==================================================

                    _AdminModuleTile(
                      icon: Icons.settings_rounded,
                      color: const Color(0xFF9BE3A6),
                      title: "Platform Settings",
                      subtitle:
                          "Configure global app settings",
                      onTap: () {
                        _openPlatformSettings(context);
                      },
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // 6. GLOBAL ANALYTICS
                    // ==================================================

                    _AdminModuleTile(
                      icon: Icons.analytics_rounded,
                      color: const Color(0xFF7E57C2),
                      title: "Global Analytics",
                      subtitle:
                          "View system-wide analytics and insights",
                      onTap: () {
                        _openGlobalAnalytics(context);
                      },
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // 7. TENANT CLIENT HUB
                    // ==================================================

                    _AdminModuleTile(
                      icon: Icons.hub_rounded,
                      color: const Color(0xFF26A69A),
                      title: "Tenant Client Hub",
                      subtitle:
                          "Manage tenant and client operations",
                      onTap: () {
                        _openTenantClientHub(context);
                      },
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // 8. INFRA COMPILER
                    // ==================================================

                    _AdminModuleTile(
                      icon: Icons.build_circle_rounded,
                      color: const Color(0xFF5C6BC0),
                      title: "Infra Compiler",
                      subtitle:
                          "Configure and manage infrastructure",
                      onTap: () {
                        _openInfraCompiler(context);
                      },
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // 9. CMS BANK
                    // ==================================================

                    _AdminModuleTile(
                      icon: Icons.account_balance_rounded,
                      color: const Color(0xFFEC407A),
                      title: "CMS Bank",
                      subtitle:
                          "Manage CMS resources and services",
                      onTap: () {
                        _openCmsBank(context);
                      },
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // 10. PORTAL CODE GENERATOR
                    // ==================================================

                    _AdminModuleTile(
                      icon: Icons.code_rounded,
                      color: const Color(0xFF42A5F5),
                      title: "Portal Code Generator",
                      subtitle:
                          "Generate portal code and configurations",
                      onTap: () {
                        _openPortalCodeGenerator(context);
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================================================================
// STAT CARD
// ================================================================

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color,
          width: 1.4,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// ADMIN MODULE TILE
// ================================================================

class _AdminModuleTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminModuleTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const Color navy = Color(0xFF1D3B64);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: navy,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // ---------------- ICON ----------------

            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),

            const SizedBox(width: 14),

            // ---------------- TEXT ----------------

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: navy,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // ---------------- ARROW ----------------

            const Icon(
              Icons.chevron_right_rounded,
              color: navy,
            ),
          ],
        ),
      ),
    );
  }
}