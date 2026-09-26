import 'package:flutter/material.dart';

/// SCHOOL / campus_announcements.dart
///
/// Create, edit, and delete campus announcements/events.
/// Styled to match SchoolDashboard (navy + yellow theme).
class CampusAnnouncementsScreen extends StatefulWidget {
  const CampusAnnouncementsScreen({super.key});

  @override
  State<CampusAnnouncementsScreen> createState() =>
      _CampusAnnouncementsScreenState();
}

enum Priority { low, medium, high }

extension on Priority {
  String get label => switch (this) {
        Priority.low => 'Low',
        Priority.medium => 'Medium',
        Priority.high => 'High',
      };

  Color get color => switch (this) {
        Priority.low => const Color(0xFF58C7F3),
        Priority.medium => const Color(0xFFF7C948),
        Priority.high => const Color(0xFFE94A56),
      };
}

class _Announcement {
  _Announcement({
    required this.title,
    required this.body,
    required this.eventDate,
    required this.priority,
    required this.audience,
    required this.published,
  });

  String title;
  String body;
  DateTime eventDate;
  Priority priority;
  List<String> audience;
  bool published;
}

class _CampusAnnouncementsScreenState extends State<CampusAnnouncementsScreen> {
  static const Color navy = Color(0xFF1F355C);
  static const Color yellow = Color(0xFFFFD52E);

  final List<String> _audienceOptions = const [
    'All Students',
    'Faculty',
    'First Years',
    'Final Years',
    'Hostel Residents',
  ];

  final List<_Announcement> _announcements = [
    _Announcement(
      title: 'Semester Exam Schedule Released',
      body: 'The final exam timetable for this semester is now available on the portal.',
      eventDate: DateTime.now().add(const Duration(days: 10)),
      priority: Priority.high,
      audience: ['All Students'],
      published: true,
    ),
    _Announcement(
      title: "Annual Tech Fest — Registrations Open",
      body: "Register your team for this year's tech fest before slots fill up.",
      eventDate: DateTime.now().add(const Duration(days: 21)),
      priority: Priority.medium,
      audience: ['All Students', 'Faculty'],
      published: true,
    ),
    _Announcement(
      title: 'Hostel Water Supply Maintenance',
      body: 'Water supply will be interrupted between 10 AM and 2 PM for maintenance.',
      eventDate: DateTime.now().add(const Duration(days: 2)),
      priority: Priority.low,
      audience: ['Hostel Residents'],
      published: false,
    ),
  ];

  static InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: navy),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: navy),
      ),
    );
  }

  Future<void> _openEditor({_Announcement? existing}) async {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final bodyController = TextEditingController(text: existing?.body ?? '');
    DateTime eventDate = existing?.eventDate ?? DateTime.now().add(const Duration(days: 1));
    Priority priority = existing?.priority ?? Priority.medium;
    List<String> audience = List.of(existing?.audience ?? ['All Students']);
    bool published = existing?.published ?? false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 22,
                bottom: MediaQuery.of(context).viewInsets.bottom + 22,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      existing == null ? 'Create Announcement' : 'Edit Announcement',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: navy),
                    ),
                    const SizedBox(height: 16),
                    TextField(controller: titleController, decoration: _fieldDecoration('Title')),
                    const SizedBox(height: 12),
                    TextField(
                      controller: bodyController,
                      maxLines: 3,
                      decoration: _fieldDecoration('Details'),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: eventDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 1)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) setSheetState(() => eventDate = picked);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: navy),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 18, color: navy),
                            const SizedBox(width: 10),
                            Text(
                              'Event date: ${eventDate.day}/${eventDate.month}/${eventDate.year}',
                              style: const TextStyle(color: navy, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Priority>(
                      initialValue: priority,
                      decoration: _fieldDecoration('Priority'),
                      items: Priority.values
                          .map((p) => DropdownMenuItem(value: p, child: Text(p.label)))
                          .toList(),
                      onChanged: (v) => setSheetState(() => priority = v ?? priority),
                    ),
                    const SizedBox(height: 14),
                    const Text('Audience',
                        style: TextStyle(fontWeight: FontWeight.w700, color: navy)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _audienceOptions.map((option) {
                        final selected = audience.contains(option);
                        return FilterChip(
                          label: Text(option),
                          selected: selected,
                          selectedColor: navy,
                          checkmarkColor: yellow,
                          backgroundColor: Colors.white,
                          side: BorderSide(color: navy.withValues(alpha: .5)),
                          labelStyle: TextStyle(color: selected ? yellow : navy, fontSize: 12.5),
                          onSelected: (v) {
                            setSheetState(() {
                              if (v) {
                                audience.add(option);
                              } else {
                                audience.remove(option);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: navy,
                      title: const Text('Publish immediately'),
                      value: published,
                      onChanged: (v) => setSheetState(() => published = v),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel', style: TextStyle(color: navy)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navy,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            if (titleController.text.trim().isEmpty) return;
                            setState(() {
                              if (existing == null) {
                                _announcements.insert(
                                  0,
                                  _Announcement(
                                    title: titleController.text.trim(),
                                    body: bodyController.text.trim(),
                                    eventDate: eventDate,
                                    priority: priority,
                                    audience: audience,
                                    published: published,
                                  ),
                                );
                              } else {
                                existing.title = titleController.text.trim();
                                existing.body = bodyController.text.trim();
                                existing.eventDate = eventDate;
                                existing.priority = priority;
                                existing.audience = audience;
                                existing.published = published;
                              }
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            existing == null ? 'Publish / Save' : 'Save changes',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _deleteAnnouncement(_Announcement a) {
    setState(() => _announcements.remove(a));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        backgroundColor: navy,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              decoration: const BoxDecoration(
                color: yellow,
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
                      border: Border.all(color: navy, width: 2),
                    ),
                    child: const Icon(Icons.campaign_rounded, color: navy),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Campus Announcements',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: navy)),
                        Text('Notices & upcoming events',
                            style: TextStyle(
                                fontSize: 12.5, color: Color(0xFF5E6D7A), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: _announcements.isEmpty
                  ? const Center(child: Text('No announcements yet', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 90),
                      itemCount: _announcements.length,
                      itemBuilder: (context, index) {
                        final a = _announcements[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: navy, width: 2),
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
                                      color: a.priority.color,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.notifications_rounded,
                                        color: Colors.white, size: 20),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      a.title,
                                      style: const TextStyle(
                                          fontSize: 15.5, fontWeight: FontWeight.w800, color: navy),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: a.priority.color.withValues(alpha: .15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      a.priority.label,
                                      style: TextStyle(
                                        color: a.priority.color,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(a.body, style: const TextStyle(color: Colors.black87, fontSize: 13.5)),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: a.audience
                                    .map((aud) => Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF8F8F8),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: navy.withValues(alpha: .25)),
                                          ),
                                          child: Text(aud,
                                              style: const TextStyle(fontSize: 11, color: navy)),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.event_rounded, size: 16, color: Colors.grey.shade600),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${a.eventDate.day}/${a.eventDate.month}/${a.eventDate.year}',
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
                                  ),
                                  const SizedBox(width: 14),
                                  Icon(
                                    a.published ? Icons.public_rounded : Icons.lock_clock_rounded,
                                    size: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    a.published ? 'Published' : 'Draft',
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.edit_rounded, size: 20, color: navy),
                                    onPressed: () => _openEditor(existing: a),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_rounded, size: 20, color: Color(0xFFE94A56)),
                                    onPressed: () => _deleteAnnouncement(a),
                                  ),
                                ],
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