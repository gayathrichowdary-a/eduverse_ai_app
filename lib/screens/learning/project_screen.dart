import 'package:flutter/material.dart';

// ============================================================
// MODELS
// ============================================================

enum ProjectStatus { pending, inProgress, submitted }

class ProjectItem {
  final String title;
  final String subject;
  final String dueDate;
  final double progress; // 0.0 - 1.0
  final ProjectStatus status;
  final Color accent;
  final IconData icon;

  const ProjectItem({
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.progress,
    required this.status,
    required this.accent,
    required this.icon,
  });
}

// ============================================================
// SCREEN
// ============================================================

class ProjectsScreen extends StatefulWidget {
  final List<ProjectItem> projects;

  const ProjectsScreen({
    Key? key,
    this.projects = const [
      ProjectItem(
        title: 'Volcano Model Report',
        subject: 'Chemistry',
        dueDate: 'Due in 3 days',
        progress: 0.65,
        status: ProjectStatus.inProgress,
        accent: Color(0xFF33B679),
        icon: Icons.science,
      ),
      ProjectItem(
        title: 'Newton\'s Laws Presentation',
        subject: 'Physics',
        dueDate: 'Due in 6 days',
        progress: 0.2,
        status: ProjectStatus.pending,
        accent: Color(0xFFE8394A),
        icon: Icons.bolt,
      ),
      ProjectItem(
        title: 'Statistics Mini-Project',
        subject: 'Maths',
        dueDate: 'Submitted',
        progress: 1.0,
        status: ProjectStatus.submitted,
        accent: Color(0xFFF4C10F),
        icon: Icons.functions,
      ),
    ],
  }) : super(key: key);

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color trackGrey = Color(0xFFE9EDF0);

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — hook this up to your next screen.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _statusLabel(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.pending:
        return 'Pending';
      case ProjectStatus.inProgress:
        return 'In Progress';
      case ProjectStatus.submitted:
        return 'Submitted';
    }
  }

  Color _statusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.pending:
        return brandRed;
      case ProjectStatus.inProgress:
        return const Color(0xFFF4C10F);
      case ProjectStatus.submitted:
        return const Color(0xFF33B679);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: navy),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Projects',
                    style: TextStyle(
                      color: navy,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: navy, height: 1, thickness: 1.4),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                itemCount: widget.projects.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final project = widget.projects[index];
                  return InkWell(
                    onTap: () => _showComingSoon(project.title),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: navy, width: 1.4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: project.accent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(project.icon,
                                    color: Colors.white, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      project.subject,
                                      style: const TextStyle(
                                        color: subtitleBlue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      project.title,
                                      style: const TextStyle(
                                        color: navy,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _statusColor(project.status)
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  _statusLabel(project.status),
                                  style: TextStyle(
                                    color: _statusColor(project.status),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: LinearProgressIndicator(
                              value: project.progress,
                              minHeight: 8,
                              backgroundColor: trackGrey,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  project.accent),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.event_rounded,
                                  color: subtitleBlue, size: 15),
                              const SizedBox(width: 6),
                              Text(
                                project.dueDate,
                                style: const TextStyle(
                                  color: subtitleBlue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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