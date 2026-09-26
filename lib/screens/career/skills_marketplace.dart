import 'package:flutter/material.dart';
import 'recommended_projects.dart';

class SkillsMarketplace extends StatefulWidget {
  const SkillsMarketplace({super.key});

  @override
  State<SkillsMarketplace> createState() => _SkillsMarketplaceState();
}

class _SkillsMarketplaceState extends State<SkillsMarketplace> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color lightBlueBg = Color(0xFFF7F9FB);
  static const Color green = Color(0xFF33B679);

  // ============================================================
  // SEARCH
  // ============================================================

  final TextEditingController _searchController =
      TextEditingController();

  String _selectedCategory = 'All Skills';

  // ============================================================
  // SKILL DATA
  // ============================================================

  final List<Map<String, dynamic>> _skills = [
    {
      'name': 'Algorithms',
      'category': 'Programming',
      'description':
          'Master problem solving, algorithms and coding techniques.',
      'level': 'Intermediate',
      'progress': 0.45,
      'icon': Icons.account_tree_rounded,
    },
    {
      'name': 'Python Programming',
      'category': 'Programming',
      'description':
          'Strengthen Python fundamentals and practical programming.',
      'level': 'Intermediate',
      'progress': 0.72,
      'icon': Icons.code_rounded,
    },
    {
      'name': 'System Design',
      'category': 'Programming',
      'description':
          'Understand scalable systems, architecture and design patterns.',
      'level': 'Beginner',
      'progress': 0.20,
      'icon': Icons.architecture_rounded,
    },
    {
      'name': 'Public Speaking',
      'category': 'Soft Skills',
      'description':
          'Improve presentation, communication and speaking confidence.',
      'level': 'Beginner',
      'progress': 0.35,
      'icon': Icons.record_voice_over_rounded,
    },
    {
      'name': 'Communication',
      'category': 'Soft Skills',
      'description':
          'Develop professional communication and teamwork skills.',
      'level': 'Intermediate',
      'progress': 0.58,
      'icon': Icons.groups_rounded,
    },
    {
      'name': 'Technical Interview',
      'category': 'Career',
      'description':
          'Prepare for technical interviews and placement discussions.',
      'level': 'Beginner',
      'progress': 0.15,
      'icon': Icons.question_answer_rounded,
    },
  ];

  // ============================================================
  // FILTERED SKILLS
  // ============================================================

  List<Map<String, dynamic>> get _filteredSkills {
    final search = _searchController.text.trim().toLowerCase();

    return _skills.where((skill) {
      final categoryMatches =
          _selectedCategory == 'All Skills' ||
          skill['category'] == _selectedCategory;

      final name = skill['name'].toString().toLowerCase();
      final description =
          skill['description'].toString().toLowerCase();

      final searchMatches =
          search.isEmpty ||
          name.contains(search) ||
          description.contains(search);

      return categoryMatches && searchMatches;
    }).toList();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // OPEN RECOMMENDED PROJECTS
  // ============================================================

  void _openRecommendedProjects() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RecommendedProjects(),
      ),
    );
  }

  // ============================================================
  // SKILL DETAILS
  // ============================================================

  void _openSkill(Map<String, dynamic> skill) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        final double progress =
            skill['progress'] as double;

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            20,
            24,
            30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: navy.withValues(alpha: 0.08),
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: Icon(
                      skill['icon'] as IconData,
                      color: navy,
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          skill['name'],
                          style: const TextStyle(
                            color: navy,
                            fontSize: 21,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          skill['category'],
                          style: const TextStyle(
                            color: brandRed,
                            fontSize: 13,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                skill['description'],
                style: const TextStyle(
                  color: subtitleBlue,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Current Progress',
                    style: TextStyle(
                      color: navy,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(
                      color: brandRed,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              ClipRRect(
                borderRadius:
                    BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 9,
                  backgroundColor:
                      const Color(0xFFE8EDF2),
                  valueColor:
                      const AlwaysStoppedAnimation<
                          Color>(
                    brandRed,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: lightBlueBg,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Text(
                  'Recommended level: ${skill['level']}',
                  style: const TextStyle(
                    color: navy,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _openRecommendedProjects();
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'View Recommended Projects',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: navy,
          ),
        ),

        title: const Text(
          'Skills Marketplace',
          style: TextStyle(
            color: navy,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          20,
          5,
          20,
          30,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            // ==================================================
            // SUBTITLE
            // ==================================================

            const Text(
              'Build the skills you need for your target career.',
              style: TextStyle(
                color: subtitleBlue,
                fontSize: 15,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 22),

            // ==================================================
            // SEARCH BAR
            // ==================================================

            TextField(
              controller: _searchController,

              onChanged: (_) {
                setState(() {});
              },

              decoration: InputDecoration(
                hintText:
                    'Search skills...',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),

                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: subtitleBlue,
                ),

                suffixIcon:
                    _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: subtitleBlue,
                            ),
                          ),

                filled: true,
                fillColor: lightBlueBg,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                  borderSide:
                      BorderSide.none,
                ),

                contentPadding:
                    const EdgeInsets.symmetric(
                  vertical: 16,
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ==================================================
            // CATEGORY
            // ==================================================

            const Text(
              'Skill Categories',
              style: TextStyle(
                color: navy,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection:
                    Axis.horizontal,
                children: [
                  _categoryChip(
                    'All Skills',
                    Icons.grid_view_rounded,
                  ),
                  _categoryChip(
                    'Programming',
                    Icons.code_rounded,
                  ),
                  _categoryChip(
                    'Soft Skills',
                    Icons.groups_rounded,
                  ),
                  _categoryChip(
                    'Career',
                    Icons.work_outline_rounded,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // AI CAREER INSIGHT
            // ==================================================

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: navy,
                borderRadius:
                    BorderRadius.circular(24),
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Career Insight',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          'Focus on Algorithms and System Design to improve your Software Engineer career match.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight:
                                FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // SKILLS HEADER
            // ==================================================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recommended Skills',
                  style: TextStyle(
                    color: navy,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                Text(
                  '${_filteredSkills.length}',
                  style: const TextStyle(
                    color: subtitleBlue,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // ==================================================
            // SKILL LIST
            // ==================================================

            if (_filteredSkills.isEmpty)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(35),
                decoration: BoxDecoration(
                  color: lightBlueBg,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      color: subtitleBlue,
                      size: 42,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No matching skills found.',
                      style: TextStyle(
                        color: navy,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                itemCount:
                    _filteredSkills.length,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemBuilder:
                    (context, index) {
                  return _skillCard(
                    _filteredSkills[index],
                  );
                },
              ),

            const SizedBox(height: 20),

            // ==================================================
            // RECOMMENDED PROJECTS BUTTON
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed:
                    _openRecommendedProjects,
                icon: const Icon(
                  Icons.rocket_launch_rounded,
                  size: 20,
                ),
                label: const Text(
                  'Explore Recommended Projects',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor: brandRed,
                  foregroundColor:
                      Colors.white,
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // NEXT FLOW INFORMATION
            // ==================================================

            Container(
              padding:
                  const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightBlueBg,
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.route_rounded,
                    color: green,
                    size: 23,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your selected skills will guide the next career project recommendations.',
                      style: TextStyle(
                        color: navy,
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORY CHIP
  // ============================================================

  Widget _categoryChip(
    String label,
    IconData icon,
  ) {
    final bool selected =
        _selectedCategory == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      child: Container(
        margin:
            const EdgeInsets.only(right: 10),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? brandRed
              : lightBlueBg,
          borderRadius:
              BorderRadius.circular(14),
          border: selected
              ? null
              : Border.all(
                  color:
                      Colors.grey.shade200,
                ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected
                  ? Colors.white
                  : navy,
              size: 17,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : navy,
                fontWeight:
                    FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SKILL CARD
  // ============================================================

  Widget _skillCard(
    Map<String, dynamic> skill,
  ) {
    final double progress =
        skill['progress'] as double;

    return GestureDetector(
      onTap: () {
        _openSkill(skill);
      },
      child: Container(
        width: double.infinity,
        margin:
            const EdgeInsets.only(bottom: 14),
        padding:
            const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset:
                  const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [

            // ==================================================
            // TOP
            // ==================================================

            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color:
                        navy.withValues(alpha: 0.07),
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: Icon(
                    skill['icon']
                        as IconData,
                    color: navy,
                    size: 27,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        skill['name'],
                        style:
                            const TextStyle(
                          color: navy,
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        skill['description'],
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            const TextStyle(
                          color:
                              subtitleBlue,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: subtitleBlue,
                ),
              ],
            ),

            const SizedBox(height: 15),

            // ==================================================
            // LEVEL + PROGRESS
            // ==================================================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: lightBlueBg,
                    borderRadius:
                        BorderRadius.circular(
                      9,
                    ),
                  ),
                  child: Text(
                    skill['level'],
                    style:
                        const TextStyle(
                      color: navy,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),

                Text(
                  '${(progress * 100).round()}%',
                  style:
                      const TextStyle(
                    color: brandRed,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10),
              child:
                  LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                backgroundColor:
                    const Color(
                  0xFFE8EDF2,
                ),
                valueColor:
                    const AlwaysStoppedAnimation<
                        Color>(
                  brandRed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}