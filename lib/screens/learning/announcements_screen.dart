import 'package:flutter/material.dart';

// ============================================================
// MODELS
// ============================================================

enum AnnouncementCategory { general, exam, event }

class AnnouncementItem {
  final String title;
  final String message;
  final String date;
  final AnnouncementCategory category;
  final bool isNew;

  const AnnouncementItem({
    required this.title,
    required this.message,
    required this.date,
    required this.category,
    this.isNew = false,
  });
}

// ============================================================
// SCREEN
// ============================================================

class AnnouncementsScreen extends StatefulWidget {
  final List<AnnouncementItem> announcements;

  const AnnouncementsScreen({
    super.key,
    this.announcements = const [
      AnnouncementItem(
        title: 'Mid-term Exams Schedule Released',
        message:
            'The mid-term examination timetable for all subjects has been published. Please check your subject-wise dates and arrive 15 minutes early.',
        date: 'Today',
        category: AnnouncementCategory.exam,
        isNew: true,
      ),
      AnnouncementItem(
        title: 'Science Fair Registrations Open',
        message:
            'Sign up for this year\'s Science Fair before the 15th. Great opportunity to showcase your projects to guest judges from local universities.',
        date: 'Today',
        category: AnnouncementCategory.event,
        isNew: true,
      ),
      AnnouncementItem(
        title: 'New Study Materials Added',
        message:
            'Fresh notes and practice sheets for Calculus and Chemical Bonds have been added to your course library.',
        date: 'Yesterday',
        category: AnnouncementCategory.general,
      ),
      AnnouncementItem(
        title: 'Parent-Teacher Meeting',
        message:
            'The next parent-teacher meeting is scheduled for this weekend. Details have been shared with your guardians.',
        date: '2 days ago',
        category: AnnouncementCategory.event,
      ),
    ],
  });

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color mastGreen = Color(0xFF33B679);
  static const Color mustard = Color(0xFFF4C10F);

  String _categoryLabel(AnnouncementCategory category) {
    switch (category) {
      case AnnouncementCategory.general:
        return 'General';
      case AnnouncementCategory.exam:
        return 'Exam';
      case AnnouncementCategory.event:
        return 'Event';
    }
  }

  Color _categoryColor(AnnouncementCategory category) {
    switch (category) {
      case AnnouncementCategory.general:
        return subtitleBlue;
      case AnnouncementCategory.exam:
        return brandRed;
      case AnnouncementCategory.event:
        return mastGreen;
    }
  }

  IconData _categoryIcon(AnnouncementCategory category) {
    switch (category) {
      case AnnouncementCategory.general:
        return Icons.campaign_rounded;
      case AnnouncementCategory.exam:
        return Icons.edit_note_rounded;
      case AnnouncementCategory.event:
        return Icons.event_available_rounded;
    }
  }

  void _openDetail(AnnouncementItem item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _categoryColor(item.category).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      _categoryLabel(item.category),
                      style: TextStyle(
                        color: _categoryColor(item.category),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    item.date,
                    style: const TextStyle(
                      color: subtitleBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                item.title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                item.message,
                style: const TextStyle(
                  color: navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Got it',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                    'Announcements',
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
                itemCount: widget.announcements.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final item = widget.announcements[index];
                  return InkWell(
                    onTap: () => _openDetail(item),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: navy, width: 1.4),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: _categoryColor(item.category),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _categoryIcon(item.category),
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.title,
                                        style: const TextStyle(
                                          color: navy,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    if (item.isNew)
                                      Container(
                                        margin:
                                            const EdgeInsets.only(left: 6),
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: mustard,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.message,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: subtitleBlue,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.date,
                                  style: const TextStyle(
                                    color: subtitleBlue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
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