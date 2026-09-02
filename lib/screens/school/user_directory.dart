import 'package:flutter/material.dart';

/// SCHOOL / user_directory.dart
///
/// College manages students/instructors: search, registration,
/// status, and CSV import/export.
/// Styled to match SchoolDashboard (navy + yellow theme).
class UserDirectoryScreen extends StatefulWidget {
  const UserDirectoryScreen({super.key});

  @override
  State<UserDirectoryScreen> createState() => _UserDirectoryScreenState();
}

class _UserDirectoryScreenState extends State<UserDirectoryScreen>
    with SingleTickerProviderStateMixin {
  static const Color navy = Color(0xFF1F355C);
  static const Color yellow = Color(0xFFFFD52E);

  late final TabController _tabController = TabController(length: 2, vsync: this)
    ..addListener(() => setState(() {}));

  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<_DirectoryUser> _students = [
    _DirectoryUser(id: 'S-1001', name: 'Ananya Sharma', detail: 'B.Tech CSE · Sem 5', active: true),
    _DirectoryUser(id: 'S-1002', name: 'Rohan Verma', detail: 'B.Tech ECE · Sem 3', active: true),
    _DirectoryUser(id: 'S-1003', name: 'Fatima Khan', detail: 'MBA · Sem 2', active: false),
    _DirectoryUser(id: 'S-1004', name: 'Karthik Iyer', detail: 'B.Tech CSE · Sem 7', active: true),
  ];

  final List<_DirectoryUser> _instructors = [
    _DirectoryUser(id: 'T-201', name: 'Dr. Meera Nair', detail: 'Computer Science Dept.', active: true),
    _DirectoryUser(id: 'T-202', name: 'Prof. Arjun Rao', detail: 'Electronics Dept.', active: true),
    _DirectoryUser(id: 'T-203', name: 'Dr. Sunita Menon', detail: 'Management Dept.', active: false),
  ];

  List<_DirectoryUser> get _filteredStudents => _students
      .where((u) =>
          u.name.toLowerCase().contains(_query.toLowerCase()) ||
          u.id.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  List<_DirectoryUser> get _filteredInstructors => _instructors
      .where((u) =>
          u.name.toLowerCase().contains(_query.toLowerCase()) ||
          u.id.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  void _importCsv() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Select a CSV file to import users')),
    );
  }

  void _exportCsv() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting directory to CSV...')),
    );
  }

  Future<void> _openRegisterDialog() async {
    final nameController = TextEditingController();
    final idController = TextEditingController();
    final detailController = TextEditingController();
    String role = _tabController.index == 0 ? 'Student' : 'Instructor';

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add User',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: navy)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: role,
                    decoration: _fieldDecoration('Role'),
                    items: const [
                      DropdownMenuItem(value: 'Student', child: Text('Student')),
                      DropdownMenuItem(value: 'Instructor', child: Text('Instructor')),
                    ],
                    onChanged: (v) => setSheetState(() => role = v ?? role),
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: idController, decoration: _fieldDecoration('ID')),
                  const SizedBox(height: 12),
                  TextField(controller: nameController, decoration: _fieldDecoration('Full name')),
                  const SizedBox(height: 12),
                  TextField(
                    controller: detailController,
                    decoration: _fieldDecoration('Program / Department'),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: navy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        if (nameController.text.trim().isEmpty ||
                            idController.text.trim().isEmpty) {
                          return;
                        }
                        setState(() {
                          final newUser = _DirectoryUser(
                            id: idController.text.trim(),
                            name: nameController.text.trim(),
                            detail: detailController.text.trim(),
                            active: true,
                          );
                          if (role == 'Student') {
                            _students.insert(0, newUser);
                          } else {
                            _instructors.insert(0, newUser);
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Register', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

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

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openRegisterDialog,
        backgroundColor: navy,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Add User', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              decoration: const BoxDecoration(
                color: yellow,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                        child: const Icon(Icons.groups_rounded, color: navy),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('User Directory',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold, color: navy)),
                            Text('Manage students & instructors',
                                style: TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFF5E6D7A),
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name or ID',
                      prefixIcon: const Icon(Icons.search, color: navy),
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: navy, width: 1.4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: navy, width: 1.4),
                      ),
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                    child: _SegmentButton(
                      label: 'Students',
                      selected: _tabController.index == 0,
                      onTap: () => setState(() => _tabController.index = 0),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SegmentButton(
                      label: 'Instructors',
                      selected: _tabController.index == 1,
                      onTap: () => setState(() => _tabController.index = 1),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _IconSquareButton(icon: Icons.upload_file_rounded, onTap: _importCsv),
                  const SizedBox(width: 8),
                  _IconSquareButton(icon: Icons.download_rounded, onTap: _exportCsv),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _UserList(users: _filteredStudents, onToggleActive: _toggleActive),
                  _UserList(users: _filteredInstructors, onToggleActive: _toggleActive),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleActive(_DirectoryUser user) {
    setState(() => user.active = !user.active);
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const Color navy = Color(0xFF1F355C);
  static const Color yellow = Color(0xFFFFD52E);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? navy : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: navy, width: 1.4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? yellow : navy,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _IconSquareButton extends StatelessWidget {
  const _IconSquareButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  static const Color navy = Color(0xFF1F355C);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: navy, width: 1.4),
        ),
        child: Icon(icon, color: navy, size: 20),
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  const _UserList({required this.users, required this.onToggleActive});

  final List<_DirectoryUser> users;
  final ValueChanged<_DirectoryUser> onToggleActive;

  static const Color navy = Color(0xFF1F355C);

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(child: Text('No users found', style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 90),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => _showProfile(context, user),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: navy, width: 2),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: navy,
                    foregroundColor: Colors.white,
                    child: Text(user.name.isNotEmpty ? user.name[0] : '?'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name,
                            style: const TextStyle(fontWeight: FontWeight.w800, color: navy)),
                        Text('${user.id} · ${user.detail}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: user.active
                              ? const Color(0xFF57B97A).withOpacity(.15)
                              : Colors.grey.withOpacity(.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          user.active ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: user.active ? const Color(0xFF2E7D4F) : Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Switch(
                        value: user.active,
                        activeColor: navy,
                        onChanged: (_) => onToggleActive(user),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showProfile(BuildContext context, _DirectoryUser user) {
    showModalBottomSheet(
      context: context,
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
              Text(user.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: navy)),
              const SizedBox(height: 6),
              Text('ID: ${user.id}'),
              Text('Details: ${user.detail}'),
              Text('Status: ${user.active ? "Active" : "Inactive"}'),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}

class _DirectoryUser {
  _DirectoryUser({
    required this.id,
    required this.name,
    required this.detail,
    required this.active,
  });

  final String id;
  final String name;
  final String detail;
  bool active;
}