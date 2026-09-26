import 'package:flutter/material.dart';

class RecommendedProjects extends StatefulWidget {
  const RecommendedProjects({super.key});

  @override
  State<RecommendedProjects> createState() =>
      _RecommendedProjectsState();
}

class _RecommendedProjectsState extends State<RecommendedProjects> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color lightBlueBg = Color(0xFFF7F9FB);
  static const Color green = Color(0xFF33B679);
  static const Color yellow = Color(0xFFF4C10F);

  // ============================================================
  // SEARCH
  // ============================================================

  final TextEditingController _searchController =
      TextEditingController();

  String _selectedCategory = 'All Projects';

  // ============================================================
  // PROJECT DATA
  // ============================================================

  final List<Map<String, dynamic>> _projects = [
    {
      'title': 'AI-Powered Resume Analyzer',
      'description':
          'Build an AI application that analyzes resumes and identifies skills, strengths and missing skills.',
      'category': 'AI & ML',
      'difficulty': 'Intermediate',
      'duration': '2 Weeks',
      'skills': [
        'Python',
        'NLP',
        'Machine Learning',
      ],
      'icon': Icons.description_rounded,
      'progress': 0.0,
    },
    {
      'title': 'Student Performance Predictor',
      'description':
          'Create a machine learning system that predicts student performance using academic data.',
      'category': 'AI & ML',
      'difficulty': 'Beginner',
      'duration': '1 Week',
      'skills': [
        'Python',
        'Pandas',
        'Scikit-learn',
      ],
      'icon': Icons.analytics_rounded,
      'progress': 0.0,
    },
    {
      'title': 'Smart Expense Tracker',
      'description':
          'Develop a smart application to track expenses, categorize spending and display useful insights.',
      'category': 'Development',
      'difficulty': 'Beginner',
      'duration': '1 Week',
      'skills': [
        'Python',
        'Database',
        'UI Design',
      ],
      'icon': Icons.account_balance_wallet_rounded,
      'progress': 0.0,
    },
    {
      'title': 'RAG Knowledge Assistant',
      'description':
          'Build an AI assistant that answers questions from uploaded documents using retrieval augmented generation.',
      'category': 'Generative AI',
      'difficulty': 'Advanced',
      'duration': '3 Weeks',
      'skills': [
        'Python',
        'RAG',
        'LLMs',
      ],
      'icon': Icons.psychology_rounded,
      'progress': 0.0,
    },
    {
      'title': 'DSA Coding Challenge App',
      'description':
          'Create a coding practice application containing algorithms, problems and progress tracking.',
      'category': 'Programming',
      'difficulty': 'Intermediate',
      'duration': '2 Weeks',
      'skills': [
        'Python',
        'DSA',
        'Problem Solving',
      ],
      'icon': Icons.code_rounded,
      'progress': 0.0,
    },
    {
      'title': 'Career Recommendation System',
      'description':
          'Develop a recommendation system that suggests suitable career paths based on skills and interests.',
      'category': 'Career',
      'difficulty': 'Intermediate',
      'duration': '2 Weeks',
      'skills': [
        'Python',
        'Machine Learning',
        'Data Analysis',
      ],
      'icon': Icons.work_outline_rounded,
      'progress': 0.0,
    },
  ];

  // ============================================================
  // CATEGORIES
  // ============================================================

  final List<String> _categories = [
    'All Projects',
    'AI & ML',
    'Generative AI',
    'Programming',
    'Development',
    'Career',
  ];

  // ============================================================
  // FILTER PROJECTS
  // ============================================================

  List<Map<String, dynamic>> get _filteredProjects {
    final search =
        _searchController.text.trim().toLowerCase();

    return _projects.where((project) {
      final categoryMatches =
          _selectedCategory == 'All Projects' ||
          project['category'] == _selectedCategory;

      final title =
          project['title'].toString().toLowerCase();

      final description =
          project['description'].toString().toLowerCase();

      final category =
          project['category'].toString().toLowerCase();

      final searchMatches =
          search.isEmpty ||
          title.contains(search) ||
          description.contains(search) ||
          category.contains(search);

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
  // START PROJECT
  // ============================================================

  void _startProject(
    Map<String, dynamic> project,
  ) {
    setState(() {
      project['progress'] = 0.10;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${project['title']} added to your project path.',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: navy,
      ),
    );
  }

  // ============================================================
  // PROJECT DETAILS
  // ============================================================

  void _openProjectDetails(
    Map<String, dynamic> project,
  ) {
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
        final List skills =
            project['skills'] as List;

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            20,
            24,
            30,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // HANDLE
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

                // PROJECT HEADER
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: navy.withValues(alpha: 0.08),
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      child: Icon(
                        project['icon']
                            as IconData,
                        color: navy,
                        size: 29,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            project['title'],
                            style:
                                const TextStyle(
                              color: navy,
                              fontSize: 21,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            project['category'],
                            style:
                                const TextStyle(
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

                // DESCRIPTION
                const Text(
                  'Project Overview',
                  style: TextStyle(
                    color: navy,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  project['description'],
                  style: const TextStyle(
                    color: subtitleBlue,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 22),

                // PROJECT INFO
                Row(
                  children: [
                    Expanded(
                      child: _detailInfo(
                        Icons.speed_rounded,
                        'Difficulty',
                        project['difficulty'],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _detailInfo(
                        Icons.schedule_rounded,
                        'Duration',
                        project['duration'],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // REQUIRED SKILLS
                const Text(
                  'Skills You Will Practice',
                  style: TextStyle(
                    color: navy,
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: skills.map<Widget>(
                    (skill) {
                      return Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration:
                            BoxDecoration(
                          color: lightBlueBg,
                          borderRadius:
                              BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: Text(
                          skill.toString(),
                          style:
                              const TextStyle(
                            color: navy,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),

                const SizedBox(height: 25),

                // START BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _startProject(project);
                    },
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                    ),
                    label: const Text(
                      'Start Project',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          brandRed,
                      foregroundColor:
                          Colors.white,
                      elevation: 0,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // CLOSE
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor: navy,
                      side:
                          const BorderSide(
                        color: navy,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
          'Recommended Projects',
          style: TextStyle(
            color: navy,
            fontSize: 23,
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
            // INTRO
            // ==================================================

            const Text(
              'Projects matched to your career goals',
              style: TextStyle(
                color: navy,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Practice the skills from your career skill-gap analysis through practical projects.',
              style: TextStyle(
                color: subtitleBlue,
                fontSize: 15,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 22),

            // ==================================================
            // AI RECOMMENDATION CARD
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
                    decoration:
                        BoxDecoration(
                      color: brandRed,
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
                          'AI Project Recommendation',
                          style: TextStyle(
                            color:
                                Colors.white70,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          'Start with projects that strengthen Python, Algorithms and System Design for your target Software Engineer role.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight:
                                FontWeight.w600,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ==================================================
            // SEARCH
            // ==================================================

            TextField(
              controller: _searchController,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText:
                    'Search projects...',
                hintStyle:
                    const TextStyle(
                  color: Colors.grey,
                ),
                prefixIcon:
                    const Icon(
                  Icons.search_rounded,
                  color: subtitleBlue,
                ),
                suffixIcon:
                    _searchController.text
                            .isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController
                                  .clear();
                              setState(() {});
                            },
                            icon:
                                const Icon(
                              Icons.close_rounded,
                              color:
                                  subtitleBlue,
                            ),
                          ),
                filled: true,
                fillColor: lightBlueBg,
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                  borderSide:
                      BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets
                        .symmetric(
                  vertical: 16,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // CATEGORIES
            // ==================================================

            const Text(
              'Project Categories',
              style: TextStyle(
                color: navy,
                fontSize: 19,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 43,
              child: ListView(
                scrollDirection:
                    Axis.horizontal,
                children:
                    _categories.map(
                  (category) {
                    return _categoryChip(
                      category,
                    );
                  },
                ).toList(),
              ),
            ),

            const SizedBox(height: 27),

            // ==================================================
            // PROJECT HEADER
            // ==================================================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                const Text(
                  'Projects For You',
                  style: TextStyle(
                    color: navy,
                    fontSize: 21,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                Text(
                  '${_filteredProjects.length}',
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
            // PROJECT LIST
            // ==================================================

            if (_filteredProjects.isEmpty)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(
                  35,
                ),
                decoration:
                    BoxDecoration(
                  color: lightBlueBg,
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons
                          .folder_off_rounded,
                      color:
                          subtitleBlue,
                      size: 42,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No projects found.',
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
                    _filteredProjects.length,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemBuilder:
                    (context, index) {
                  return _projectCard(
                    _filteredProjects[
                        index],
                  );
                },
              ),

            const SizedBox(height: 20),

            // ==================================================
            // CAREER PROJECT MESSAGE
            // ==================================================

            Container(
              padding:
                  const EdgeInsets.all(17),
              decoration:
                  BoxDecoration(
                color:
                    const Color(0xFFFFF8E1),
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
                border: Border.all(
                  color:
                      Colors.orange.shade100,
                ),
              ),
              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Icon(
                    Icons.lightbulb_rounded,
                    color: yellow,
                    size: 23,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Completing practical projects can help strengthen the skills identified in your career analysis.',
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
    String category,
  ) {
    final bool selected =
        _selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        margin:
            const EdgeInsets.only(
          right: 10,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration:
            BoxDecoration(
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
        child: Text(
          category,
          style: TextStyle(
            color: selected
                ? Colors.white
                : navy,
            fontSize: 12,
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROJECT CARD
  // ============================================================

  Widget _projectCard(
    Map<String, dynamic> project,
  ) {
    final double progress =
        project['progress'] as double;

    final List skills =
        project['skills'] as List;

    return GestureDetector(
      onTap: () {
        _openProjectDetails(project);
      },
      child: Container(
        width: double.infinity,
        margin:
            const EdgeInsets.only(
          bottom: 16,
        ),
        padding:
            const EdgeInsets.all(18),
        decoration:
            BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(22),
          border: Border.all(
            color:
                Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(
                alpha: 0.035,
              ),
              blurRadius: 12,
              offset:
                  const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ==================================================
            // PROJECT HEADER
            // ==================================================

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration:
                      BoxDecoration(
                    color:
                        navy.withValues(
                      alpha: 0.07,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: Icon(
                    project['icon']
                        as IconData,
                    color: navy,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        project['title'],
                        style:
                            const TextStyle(
                          color: navy,
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        project['category'],
                        style:
                            const TextStyle(
                          color:
                              brandRed,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons
                      .chevron_right_rounded,
                  color:
                      subtitleBlue,
                ),
              ],
            ),

            const SizedBox(height: 13),

            // ==================================================
            // DESCRIPTION
            // ==================================================

            Text(
              project['description'],
              maxLines: 3,
              overflow:
                  TextOverflow.ellipsis,
              style:
                  const TextStyle(
                color:
                    subtitleBlue,
                fontSize: 13,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // DIFFICULTY + DURATION
            // ==================================================

            Row(
              children: [
                _infoChip(
                  Icons.speed_rounded,
                  project['difficulty'],
                ),

                const SizedBox(width: 8),

                _infoChip(
                  Icons.schedule_rounded,
                  project['duration'],
                ),
              ],
            ),

            const SizedBox(height: 13),

            // ==================================================
            // SKILLS
            // ==================================================

            Wrap(
              spacing: 7,
              runSpacing: 7,
              children:
                  skills.take(3).map<Widget>(
                (skill) {
                  return Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          lightBlueBg,
                      borderRadius:
                          BorderRadius
                              .circular(
                        8,
                      ),
                    ),
                    child: Text(
                      skill.toString(),
                      style:
                          const TextStyle(
                        color: navy,
                        fontSize: 10,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // PROGRESS
            // ==================================================

            if (progress > 0) ...[
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  const Text(
                    'Started',
                    style:
                        TextStyle(
                      color:
                          subtitleBlue,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${(progress * 100).round()}%',
                    style:
                        const TextStyle(
                      color: brandRed,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 7),

              ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
                child:
                    LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
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

              const SizedBox(height: 13),
            ],

            // ==================================================
            // BUTTON
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: () {
                  _openProjectDetails(
                    project,
                  );
                },
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor: navy,
                  side:
                      const BorderSide(
                    color: navy,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      13,
                    ),
                  ),
                ),
                child: Text(
                  progress > 0
                      ? 'Continue Project'
                      : 'View Project',
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INFO CHIP
  // ============================================================

  Widget _infoChip(
    IconData icon,
    String text,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration:
          BoxDecoration(
        color: lightBlueBg,
        borderRadius:
            BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: subtitleBlue,
            size: 14,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style:
                const TextStyle(
              color: navy,
              fontSize: 10,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DETAIL INFO
  // ============================================================

  Widget _detailInfo(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(13),
      decoration:
          BoxDecoration(
        color: lightBlueBg,
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: subtitleBlue,
            size: 20,
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style:
                const TextStyle(
              color: subtitleBlue,
              fontSize: 11,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            value,
            style:
                const TextStyle(
              color: navy,
              fontSize: 13,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}