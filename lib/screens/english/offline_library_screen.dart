import 'package:flutter/material.dart';

class OfflineLibraryScreen extends StatefulWidget {
  const OfflineLibraryScreen({super.key});

  @override
  State<OfflineLibraryScreen> createState() => _OfflineLibraryScreenState();
}

class _LibraryItem {
  final String title;
  final String type; // "Video", "PDF", "Pack"
  final String size;
  final IconData icon;
  final Color iconColor;

  _LibraryItem({
    required this.title,
    required this.type,
    required this.size,
    required this.icon,
    required this.iconColor,
  });
}

class _OfflineLibraryScreenState extends State<OfflineLibraryScreen> {
  // Theme Colors from the UI
  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color lightBg = Color(0xFFF7F9FB);

  // 0 = All Downloads, 1 = Videos, 2 = PDFs
  int _selectedFilter = 0;

  bool _isEditingVideos = false;
  final Set<String> _selectedForDeletion = {};

  List<_LibraryItem> _videos = [
    _LibraryItem(
      title: "Quantum Mechanics Basics",
      type: "Video",
      size: "420 MB",
      icon: Icons.play_circle_filled,
      iconColor: brandRed,
    ),
    _LibraryItem(
      title: "Organic Chemistry Vol. 2",
      type: "Video",
      size: "185 MB",
      icon: Icons.play_circle_filled,
      iconColor: const Color(0xFF4FC3F7),
    ),
  ];

  final List<_LibraryItem> _documents = [
    _LibraryItem(
      title: "JEE Advanced Formula Sheet",
      type: "PDF",
      size: "12 MB",
      icon: Icons.picture_as_pdf,
      iconColor: const Color(0xFF52B68C),
    ),
    _LibraryItem(
      title: "Ancient Indian History Notes",
      type: "PDF",
      size: "8 MB",
      icon: Icons.article,
      iconColor: Colors.orange,
    ),
  ];

  final List<_LibraryItem> _packs = [
    _LibraryItem(
      title: "Complete Algebra Mastery",
      type: "Pack",
      size: "540 MB",
      icon: Icons.inventory_2,
      iconColor: const Color(0xFF5B5FE0),
    ),
  ];

  void _toggleEditMode() {
    setState(() {
      _isEditingVideos = !_isEditingVideos;
      if (!_isEditingVideos) _selectedForDeletion.clear();
    });
  }

  void _toggleSelection(String title) {
    setState(() {
      if (_selectedForDeletion.contains(title)) {
        _selectedForDeletion.remove(title);
      } else {
        _selectedForDeletion.add(title);
      }
    });
  }

  Future<void> _confirmDeleteSelected() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text("Remove downloads?", style: TextStyle(color: navy, fontWeight: FontWeight.bold)),
        content: Text(
          "${_selectedForDeletion.length} video${_selectedForDeletion.length > 1 ? 's' : ''} will be removed from your offline library. You can re-download them anytime.",
          style: const TextStyle(color: subtitleBlue, fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: subtitleBlue)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: brandRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Remove", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _videos = _videos.where((v) => !_selectedForDeletion.contains(v.title)).toList();
      _selectedForDeletion.clear();
      _isEditingVideos = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Removed from downloads"), backgroundColor: Color(0xFF52B68C)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final showVideos = _selectedFilter == 0 || _selectedFilter == 1;
    final showDocuments = _selectedFilter == 0 || _selectedFilter == 2;
    final showPacks = _selectedFilter == 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Offline Library",
            style: TextStyle(color: navy, fontSize: 28, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Access your learning anywhere",
                style: TextStyle(color: subtitleBlue, fontSize: 14)),
            const SizedBox(height: 20),

            // --- 1. Storage Bar Section ---
            _buildStorageSection(),

            const SizedBox(height: 25),

            // --- 2. Filter Pills ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterPill("All Downloads", Icons.grid_view_rounded, 0),
                  _filterPill("Videos", Icons.play_circle_fill, 1),
                  _filterPill("PDFs", Icons.description, 2),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 3. Video Lessons Section ---
            if (showVideos) ...[
              _sectionHeader(
                "Video Lessons",
                showEdit: true,
                isEditing: _isEditingVideos,
                onEditTap: _toggleEditMode,
              ),
              if (_videos.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text("No downloaded videos", style: TextStyle(color: subtitleBlue, fontSize: 13)),
                ),
              ..._videos.map((v) => _buildLibraryCard(v, isEditable: true)),
              const SizedBox(height: 10),
            ],

            // --- 4. Documents Section ---
            if (showDocuments) ...[
              _sectionHeader("Documents", showEdit: false),
              ..._documents.map((d) => _buildLibraryCard(d)),
              const SizedBox(height: 10),
            ],

            // --- 5. Lesson Packs Section ---
            if (showPacks) ...[
              _sectionHeader("Lesson Packs", showEdit: false),
              ..._packs.map((p) => _buildLibraryCard(p)),
            ],

            const SizedBox(height: 100), // Bottom spacing
          ],
        ),
      ),
      bottomNavigationBar: (_isEditingVideos && _selectedForDeletion.isNotEmpty)
          ? _buildDeleteBar()
          : null,
    );
  }

  Widget _buildDeleteBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          onPressed: _confirmDeleteSelected,
          icon: const Icon(Icons.delete_outline, color: Colors.white),
          label: Text("Remove ${_selectedForDeletion.length} selected",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: brandRed,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ),
    );
  }

  Widget _buildStorageSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.help_outline, color: subtitleBlue, size: 18),
                  SizedBox(width: 8),
                  Text("Storage Used", style: TextStyle(color: subtitleBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
              const Text("1.2 GB / 5.0 GB", style: TextStyle(color: navy, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.24,
              minHeight: 8,
              backgroundColor: Color(0xFFEEEEEE),
              valueColor: AlwaysStoppedAnimation(brandRed),
            ),
          )
        ],
      ),
    );
  }

  Widget _filterPill(String label, IconData icon, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? brandRed : brandRed.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(
    String title, {
    bool showEdit = true,
    bool isEditing = false,
    VoidCallback? onEditTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.bold)),
          if (showEdit)
            GestureDetector(
              onTap: onEditTap,
              child: Text(isEditing ? "Done" : "Edit",
                  style: TextStyle(
                      color: isEditing ? brandRed : subtitleBlue, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildLibraryCard(_LibraryItem item, {bool isEditable = false}) {
    final isSelected = _selectedForDeletion.contains(item.title);
    final showCheckbox = isEditable && _isEditingVideos;

    return GestureDetector(
      onTap: showCheckbox ? () => _toggleSelection(item.title) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? brandRed.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: isSelected ? brandRed : navy, width: 2),
        ),
        child: Row(
          children: [
            if (showCheckbox) ...[
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_off,
                color: isSelected ? brandRed : Colors.grey.shade400,
                size: 24,
              ),
              const SizedBox(width: 12),
            ],
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: item.iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.type, style: const TextStyle(color: subtitleBlue, fontSize: 12, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: navy),
                        ),
                        child: Text(item.size, style: const TextStyle(color: navy, fontSize: 10, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(item.title, style: const TextStyle(color: navy, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}