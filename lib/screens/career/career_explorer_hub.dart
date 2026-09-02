import 'package:flutter/material.dart';

import 'career_details_screen.dart';
import 'ai_career_match_screen.dart';
import 'expert_profile_screen.dart';

// ============================================================
// CAREER MODEL
// ============================================================

class CareerMatch {
  final String title;
  final String category;
  final int matchPercent;
  final String description;
  final IconData icon;
  final Color iconBg;

  const CareerMatch({
    required this.title,
    required this.category,
    required this.matchPercent,
    required this.description,
    required this.icon,
    required this.iconBg,
  });
}

// ============================================================
// CAREER EXPLORER HUB
// ============================================================

class CareerExplorerHub extends StatefulWidget {
  const CareerExplorerHub({super.key});

  @override
  State<CareerExplorerHub> createState() => _CareerExplorerHubState();
}

class _CareerExplorerHubState extends State<CareerExplorerHub> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color matchGreen = Color(0xFF52B68C);
  static const Color lightBackground = Color(0xFFF7F9FC);
  static const Color cardBlue = Color(0xFFEAF5FA);
  static const Color cardYellow = Color(0xFFFFF5D6);

  // ============================================================
  // SEARCH
  // ============================================================

  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  // ============================================================
  // FILTERS
  // ============================================================

  final Set<String> _selectedCategories = {};

  int _minMatchPercent = 0;

  String _sortBy = 'Best Match';

  // ============================================================
  // CAREER DATA
  // ============================================================

  final List<CareerMatch> _allCareers = const [
    CareerMatch(
      title: 'AI Engineer',
      category: 'Tech',
      matchPercent: 92,
      description:
          'Design and build intelligent AI systems, machine learning models and AI applications.',
      icon: Icons.memory_rounded,
      iconBg: Color(0xFFE8394A),
    ),

    CareerMatch(
      title: 'Data Scientist',
      category: 'Tech',
      matchPercent: 88,
      description:
          'Analyze complex datasets and create data-driven solutions for real-world problems.',
      icon: Icons.analytics_rounded,
      iconBg: Color(0xFF4FC3F7),
    ),

    CareerMatch(
      title: 'Machine Learning Engineer',
      category: 'Tech',
      matchPercent: 84,
      description:
          'Develop, train and deploy machine learning models for intelligent applications.',
      icon: Icons.auto_awesome_rounded,
      iconBg: Color(0xFF7E57C2),
    ),

    CareerMatch(
      title: 'Software Engineer',
      category: 'Development',
      matchPercent: 81,
      description:
          'Design, develop, test and maintain software applications and systems.',
      icon: Icons.code_rounded,
      iconBg: Color(0xFF33B679),
    ),

    CareerMatch(
      title: 'Data Analyst',
      category: 'Data',
      matchPercent: 79,
      description:
          'Transform raw data into useful insights through analysis and visualization.',
      icon: Icons.bar_chart_rounded,
      iconBg: Color(0xFFFFA726),
    ),

    CareerMatch(
      title: 'Cloud Engineer',
      category: 'Cloud',
      matchPercent: 74,
      description:
          'Build and maintain scalable cloud infrastructure and deployment systems.',
      icon: Icons.cloud_rounded,
      iconBg: Color(0xFF42A5F5),
    ),
  ];

  // ============================================================
  // AVAILABLE CATEGORIES
  // ============================================================

  List<String> get _availableCategories {
    return _allCareers
        .map((career) => career.category)
        .toSet()
        .toList();
  }

  // ============================================================
  // FILTERED CAREERS
  // ============================================================

  List<CareerMatch> get _filteredCareers {
    final query = _searchQuery.trim().toLowerCase();

    List<CareerMatch> result = _allCareers.where((career) {
      final categoryMatches =
          _selectedCategories.isEmpty ||
          _selectedCategories.contains(career.category);

      final matchMatches =
          career.matchPercent >= _minMatchPercent;

      final searchMatches =
          query.isEmpty ||
          career.title.toLowerCase().contains(query) ||
          career.category.toLowerCase().contains(query) ||
          career.description.toLowerCase().contains(query);

      return categoryMatches &&
          matchMatches &&
          searchMatches;
    }).toList();

    if (_sortBy == 'Best Match') {
      result.sort(
        (a, b) => b.matchPercent.compareTo(a.matchPercent),
      );
    } else if (_sortBy == 'Alphabetical') {
      result.sort(
        (a, b) => a.title.compareTo(b.title),
      );
    }

    return result;
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
  // OPEN AI CAREER MATCH
  // ============================================================

  void _openAiCareerMatch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AiCareerMatchScreen(),
      ),
    );
  }

  // ============================================================
  // OPEN CAREER DETAILS
  // ============================================================

  void _openCareerDetails(String careerTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CareerDetailsScreen(
          careerTitle: careerTitle,
        ),
      ),
    );
  }

  // ============================================================
  // OPEN EXPERT PROFILE
  // ============================================================

  void _openExpertProfile(String expertName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ExpertProfileScreen(
          expertName: expertName,
        ),
      ),
    );
  }

  // ============================================================
  // FILTER SHEET
  // ============================================================

  void _openFilterSheet() {
    Set<String> tempCategories =
        {..._selectedCategories};

    int tempMinMatch = _minMatchPercent;

    String tempSortBy = _sortBy;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (
            sheetContext,
            setSheetState,
          ) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom:
                      MediaQuery.of(sheetContext)
                              .viewInsets
                              .bottom +
                          20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // ==================================================
                      // HEADER
                      // ==================================================

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Refine Career Matches',
                            style: TextStyle(
                              color: navy,
                              fontSize: 21,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setSheetState(() {
                                tempCategories.clear();
                                tempMinMatch = 0;
                                tempSortBy =
                                    'Best Match';
                              });
                            },
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                color: brandRed,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // ==================================================
                      // CATEGORY
                      // ==================================================

                      const Text(
                        'Career Category',
                        style: TextStyle(
                          color: navy,
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children:
                            _availableCategories
                                .map(
                          (category) {
                            final selected =
                                tempCategories
                                    .contains(
                              category,
                            );

                            return FilterChip(
                              label:
                                  Text(category),
                              selected:
                                  selected,
                              selectedColor:
                                  brandRed
                                      .withOpacity(
                                0.15,
                              ),
                              checkmarkColor:
                                  brandRed,
                              labelStyle:
                                  TextStyle(
                                color: selected
                                    ? brandRed
                                    : navy,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                              side: BorderSide(
                                color: selected
                                    ? brandRed
                                    : Colors.grey
                                        .shade300,
                              ),
                              onSelected:
                                  (value) {
                                setSheetState(() {
                                  if (value) {
                                    tempCategories
                                        .add(
                                      category,
                                    );
                                  } else {
                                    tempCategories
                                        .remove(
                                      category,
                                    );
                                  }
                                });
                              },
                            );
                          },
                        ).toList(),
                      ),

                      const SizedBox(height: 25),

                      // ==================================================
                      // MINIMUM MATCH
                      // ==================================================

                      Text(
                        'Minimum Career Match: $tempMinMatch%',
                        style: const TextStyle(
                          color: navy,
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                      Slider(
                        value:
                            tempMinMatch.toDouble(),
                        min: 0,
                        max: 100,
                        divisions: 20,
                        activeColor: brandRed,
                        label:
                            '$tempMinMatch%',
                        onChanged: (value) {
                          setSheetState(() {
                            tempMinMatch =
                                value.round();
                          });
                        },
                      ),

                      const SizedBox(height: 10),

                      // ==================================================
                      // SORT
                      // ==================================================

                      const Text(
                        'Sort Careers By',
                        style: TextStyle(
                          color: navy,
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 10,
                        children: [
                          'Best Match',
                          'Alphabetical',
                        ].map(
                          (option) {
                            final selected =
                                tempSortBy ==
                                    option;

                            return ChoiceChip(
                              label:
                                  Text(option),
                              selected:
                                  selected,
                              selectedColor:
                                  navy,
                              labelStyle:
                                  TextStyle(
                                color: selected
                                    ? Colors.white
                                    : navy,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                              onSelected: (_) {
                                setSheetState(() {
                                  tempSortBy =
                                      option;
                                });
                              },
                            );
                          },
                        ).toList(),
                      ),

                      const SizedBox(height: 28),

                      // ==================================================
                      // APPLY
                      // ==================================================

                      SizedBox(
                        width:
                            double.infinity,
                        height: 52,
                        child:
                            ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategories
                                ..clear()
                                ..addAll(
                                  tempCategories,
                                );

                              _minMatchPercent =
                                  tempMinMatch;

                              _sortBy =
                                  tempSortBy;
                            });

                            Navigator.pop(
                              sheetContext,
                            );
                          },
                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                brandRed,
                            elevation: 0,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                50,
                              ),
                            ),
                          ),
                          child:
                              const Text(
                            'Apply Filters',
                            style: TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // CLEAR ALL FILTERS
  // ============================================================

  void _clearFilters() {
    setState(() {
      _selectedCategories.clear();
      _minMatchPercent = 0;
      _sortBy = 'Best Match';
      _searchQuery = '';
      _searchController.clear();
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final careers = _filteredCareers;

    return Scaffold(
      backgroundColor: lightBackground,

      // ==========================================================
      // APP BAR
      // ==========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: navy,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Career Explorer',
          style: TextStyle(
            color: navy,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.tune_rounded,
              color: navy,
            ),
            onPressed: _openFilterSheet,
          ),
        ],
      ),

      // ==========================================================
      // BODY
      // ==========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),
          padding:
              const EdgeInsets.fromLTRB(
            20,
            10,
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
                'Build Your Career Path',
                style: TextStyle(
                  color: navy,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Explore careers that match your skills, interests and learning progress.',
                style: TextStyle(
                  color: subtitleBlue,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // SEARCH
              // ==================================================

              TextField(
                controller:
                    _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery =
                        value;
                  });
                },
                decoration:
                    InputDecoration(
                  hintText:
                      'Search careers, skills or roles...',
                  hintStyle:
                      const TextStyle(
                    color: Colors.grey,
                  ),
                  prefixIcon:
                      const Icon(
                    Icons.search_rounded,
                    color:
                        subtitleBlue,
                  ),
                  suffixIcon:
                      _searchQuery.isNotEmpty
                          ? IconButton(
                              icon:
                                  const Icon(
                                Icons
                                    .clear_rounded,
                                color:
                                    subtitleBlue,
                              ),
                              onPressed:
                                  () {
                                setState(() {
                                  _searchQuery =
                                      '';
                                  _searchController
                                      .clear();
                                });
                              },
                            )
                          : null,
                  filled: true,
                  fillColor:
                      Colors.white,
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      17,
                    ),
                    borderSide:
                        BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 17,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // AI CAREER MATCH CARD
              // ==================================================

              GestureDetector(
                onTap:
                    _openAiCareerMatch,
                child: Container(
                  width:
                      double.infinity,
                  padding:
                      const EdgeInsets.all(
                    20,
                  ),
                  decoration:
                      BoxDecoration(
                    gradient:
                        const LinearGradient(
                      colors: [
                        Color(0xFFE8394A),
                        Color(0xFF55C6E8),
                      ],
                      begin:
                          Alignment.centerLeft,
                      end:
                          Alignment.centerRight,
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(
                      24,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration:
                            BoxDecoration(
                          color: Colors
                              .white
                              .withOpacity(
                            0.20,
                          ),
                          shape:
                              BoxShape
                                  .circle,
                        ),
                        child:
                            const Icon(
                          Icons
                              .auto_awesome_rounded,
                          color:
                              Colors.white,
                          size: 27,
                        ),
                      ),

                      const SizedBox(
                        width: 14,
                      ),

                      const Expanded(
                        child:
                            Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              'AI Career Match',
                              style:
                                  TextStyle(
                                color:
                                    Colors.white,
                                fontSize:
                                    17,
                                fontWeight:
                                    FontWeight
                                        .w800,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Let EduVerse AI analyze your skills and suggest suitable career paths.',
                              style:
                                  TextStyle(
                                color:
                                    Colors.white70,
                                fontSize:
                                    13,
                                height:
                                    1.35,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons
                            .chevron_right_rounded,
                        color:
                            Colors.white,
                        size: 27,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // SKILL + CAREER MAPPING
              // ==================================================

              Container(
                width:
                    double.infinity,
                padding:
                    const EdgeInsets.all(
                  20,
                ),
                decoration:
                    BoxDecoration(
                  color: cardBlue,
                  borderRadius:
                      BorderRadius
                          .circular(
                    22,
                  ),
                  border:
                      Border.all(
                    color: navy,
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration:
                              BoxDecoration(
                            color:
                                navy,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),
                          ),
                          child:
                              const Icon(
                            Icons
                                .account_tree_rounded,
                            color:
                                Colors.white,
                            size: 25,
                          ),
                        ),

                        const SizedBox(
                          width: 13,
                        ),

                        const Expanded(
                          child:
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                'Skill & Career Mapping',
                                style:
                                    TextStyle(
                                  color:
                                      navy,
                                  fontSize:
                                      17,
                                  fontWeight:
                                      FontWeight
                                          .w800,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'See how your current skills align with career requirements.',
                                style:
                                    TextStyle(
                                  color:
                                      subtitleBlue,
                                  fontSize:
                                      13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    _skillProgress(
                      'Python',
                      0.88,
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    _skillProgress(
                      'Machine Learning',
                      0.72,
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    _skillProgress(
                      'Data Structures',
                      0.64,
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    _skillProgress(
                      'Generative AI',
                      0.58,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // TOP CAREER MATCHES
              // ==================================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  const Text(
                    'Top Career Matches',
                    style: TextStyle(
                      color: navy,
                      fontSize: 21,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  TextButton(
                    onPressed:
                        _openFilterSheet,
                    child:
                        const Text(
                      'Refine',
                      style:
                          TextStyle(
                        color:
                            brandRed,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              // ==================================================
              // ACTIVE FILTERS
              // ==================================================

              if (_selectedCategories
                      .isNotEmpty ||
                  _minMatchPercent >
                      0 ||
                  _searchQuery
                      .isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._selectedCategories
                        .map(
                      (category) =>
                          Chip(
                        label: Text(
                          category,
                          style:
                              const TextStyle(
                            color:
                                brandRed,
                            fontSize:
                                12,
                          ),
                        ),
                        backgroundColor:
                            brandRed
                                .withOpacity(
                          0.10,
                        ),
                        onDeleted: () {
                          setState(() {
                            _selectedCategories
                                .remove(
                              category,
                            );
                          });
                        },
                      ),
                    ),

                    if (_minMatchPercent >
                        0)
                      Chip(
                        label: Text(
                          '$_minMatchPercent%+ match',
                          style:
                              const TextStyle(
                            color:
                                brandRed,
                            fontSize:
                                12,
                          ),
                        ),
                        backgroundColor:
                            brandRed
                                .withOpacity(
                          0.10,
                        ),
                        onDeleted: () {
                          setState(() {
                            _minMatchPercent =
                                0;
                          });
                        },
                      ),

                    if (_searchQuery
                        .isNotEmpty)
                      Chip(
                        label: Text(
                          'Search: $_searchQuery',
                          style:
                              const TextStyle(
                            color:
                                brandRed,
                            fontSize:
                                12,
                          ),
                        ),
                        backgroundColor:
                            brandRed
                                .withOpacity(
                          0.10,
                        ),
                        onDeleted: () {
                          setState(() {
                            _searchQuery =
                                '';
                            _searchController
                                .clear();
                          });
                        },
                      ),

                    ActionChip(
                      label:
                          const Text(
                        'Clear All',
                        style:
                            TextStyle(
                          color:
                              navy,
                          fontSize:
                              12,
                          fontWeight:
                              FontWeight
                                  .w600,
                        ),
                      ),
                      onPressed:
                          _clearFilters,
                    ),
                  ],
                ),

                const SizedBox(
                  height: 14,
                ),
              ],

              // ==================================================
              // CAREER LIST
              // ==================================================

              if (careers.isEmpty)
                Container(
                  width:
                      double.infinity,
                  padding:
                      const EdgeInsets.all(
                    35,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,
                    borderRadius:
                        BorderRadius
                            .circular(
                      20,
                    ),
                  ),
                  child:
                      const Column(
                    children: [
                      Icon(
                        Icons
                            .search_off_rounded,
                        color:
                            subtitleBlue,
                        size: 45,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        'No matching careers found.',
                        style:
                            TextStyle(
                          color:
                              navy,
                          fontSize:
                              16,
                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...careers.map(
                  (career) =>
                      _buildCareerCard(
                    career,
                  ),
                ),

              const SizedBox(height: 28),

              // ==================================================
              // PERSONALIZED ROADMAP
              // ==================================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  const Text(
                    'Your Career Roadmap',
                    style: TextStyle(
                      color: navy,
                      fontSize: 21,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      _showMessage(
                        'Personalized roadmap',
                      );
                    },
                    child:
                        const Text(
                      'View All',
                      style:
                          TextStyle(
                        color:
                            brandRed,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 12,
              ),

              _buildRoadmapStep(
                number: '1',
                title:
                    'Strengthen Core Skills',
                description:
                    'Improve Python, DSA and mathematics fundamentals.',
                completed: true,
              ),

              _buildRoadmapStep(
                number: '2',
                title:
                    'Build AI & ML Skills',
                description:
                    'Complete machine learning and AI learning paths.',
                completed: false,
              ),

              _buildRoadmapStep(
                number: '3',
                title:
                    'Complete Real-World Projects',
                description:
                    'Build projects that demonstrate your practical skills.',
                completed: false,
              ),

              _buildRoadmapStep(
                number: '4',
                title:
                    'Become Placement Ready',
                description:
                    'Prepare your portfolio, resume and technical skills.',
                completed: false,
              ),

              const SizedBox(
                height: 28,
              ),

              // ==================================================
              // AI MENTOR
              // ==================================================

              GestureDetector(
                onTap: () {
                  _showMessage(
                    'AI Mentor is ready to help with your career path.',
                  );
                },
                child: Container(
                  width:
                      double.infinity,
                  padding:
                      const EdgeInsets.all(
                    20,
                  ),
                  decoration:
                      BoxDecoration(
                    color: cardYellow,
                    borderRadius:
                        BorderRadius
                            .circular(
                      22,
                    ),
                    border:
                        Border.all(
                      color: navy,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFFF4C10F,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            15,
                          ),
                        ),
                        child:
                            const Icon(
                          Icons
                              .psychology_alt_rounded,
                          color:
                              navy,
                          size: 28,
                        ),
                      ),

                      const SizedBox(
                        width: 14,
                      ),

                      const Expanded(
                        child:
                            Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              'AI Career Mentor',
                              style:
                                  TextStyle(
                                color:
                                    navy,
                                fontSize:
                                    17,
                                fontWeight:
                                    FontWeight
                                        .w800,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Get guidance on skills, careers, projects and your next learning step.',
                              style:
                                  TextStyle(
                                color:
                                    subtitleBlue,
                                fontSize:
                                    13,
                                height:
                                    1.35,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons
                            .chevron_right_rounded,
                        color:
                            navy,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 28,
              ),

              // ==================================================
              // EXPERTS
              // ==================================================

              const Text(
                'Talk to Career Experts',
                style: TextStyle(
                  color: navy,
                  fontSize: 21,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal,
                child: Row(
                  children: [
                    _expertAvatar(
                      'Dr. Aris',
                      Icons.school_rounded,
                    ),

                    _expertAvatar(
                      'Sarah Chen',
                      Icons
                          .business_center_rounded,
                    ),

                    _expertAvatar(
                      'Vikram S.',
                      Icons
                          .engineering_rounded,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SKILL PROGRESS
  // ============================================================

  Widget _skillProgress(
    String skill,
    double value,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
          children: [
            Text(
              skill,
              style: const TextStyle(
                color: navy,
                fontSize: 13,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: const TextStyle(
                color:
                    subtitleBlue,
                fontSize: 13,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 7,
        ),

        ClipRRect(
          borderRadius:
              BorderRadius.circular(
            20,
          ),
          child:
              LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor:
                Colors.white,
            valueColor:
                const AlwaysStoppedAnimation<
                    Color>(
              brandRed,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CAREER CARD
  // ============================================================

  Widget _buildCareerCard(
    CareerMatch career,
  ) {
    return Container(
      width:
          double.infinity,
      margin:
          const EdgeInsets.only(
        bottom: 17,
      ),
      padding:
          const EdgeInsets.all(
        19,
      ),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        border:
            Border.all(
          color:
              navy.withOpacity(
            0.10,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color:
                Color(0x08000000),
            blurRadius: 8,
            offset:
                Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration:
                    BoxDecoration(
                  color:
                      career.iconBg,
                  borderRadius:
                      BorderRadius
                          .circular(
                    15,
                  ),
                ),
                child:
                    Icon(
                  career.icon,
                  color:
                      Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(
                width: 13,
              ),

              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      career.title,
                      style:
                          const TextStyle(
                        color:
                            navy,
                        fontSize:
                            18,
                        fontWeight:
                            FontWeight
                                .w800,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      career.category,
                      style:
                          const TextStyle(
                        color:
                            brandRed,
                        fontSize:
                            13,
                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      matchGreen
                          .withOpacity(
                    0.13,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(
                    12,
                  ),
                ),
                child:
                    Text(
                  '${career.matchPercent}% Match',
                  style:
                      const TextStyle(
                    color:
                        matchGreen,
                    fontSize:
                        12,
                    fontWeight:
                        FontWeight
                            .w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 15,
          ),

          Text(
            career.description,
            style:
                const TextStyle(
              color:
                  subtitleBlue,
              fontSize:
                  14,
              height:
                  1.4,
            ),
          ),

          const SizedBox(
            height: 17,
          ),

          SizedBox(
            width:
                double.infinity,
            height: 45,
            child:
                OutlinedButton(
              onPressed: () {
                _openCareerDetails(
                  career.title,
                );
              },
              style:
                  OutlinedButton.styleFrom(
                side:
                    const BorderSide(
                  color:
                      navy,
                  width:
                      1.2,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                    25,
                  ),
                ),
              ),
              child:
                  const Text(
                'Explore Career Path',
                style:
                    TextStyle(
                  color:
                      navy,
                  fontWeight:
                      FontWeight
                          .w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ROADMAP STEP
  // ============================================================

  Widget _buildRoadmapStep({
    required String number,
    required String title,
    required String description,
    required bool completed,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 13,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration:
                BoxDecoration(
              color: completed
                  ? matchGreen
                  : Colors.white,
              shape:
                  BoxShape.circle,
              border:
                  Border.all(
                color: completed
                    ? matchGreen
                    : navy,
                width: 1.5,
              ),
            ),
            alignment:
                Alignment.center,
            child: completed
                ? const Icon(
                    Icons.check_rounded,
                    color:
                        Colors.white,
                    size: 20,
                  )
                : Text(
                    number,
                    style:
                        const TextStyle(
                      color:
                          navy,
                      fontWeight:
                          FontWeight
                              .w800,
                    ),
                  ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child:
                Container(
              padding:
                  const EdgeInsets
                      .all(
                15,
              ),
              decoration:
                  BoxDecoration(
                color:
                    Colors.white,
                borderRadius:
                    BorderRadius
                        .circular(
                  16,
                ),
                border:
                    Border.all(
                  color: navy
                      .withOpacity(
                    0.08,
                  ),
                ),
              ),
              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(
                      color:
                          navy,
                      fontSize:
                          15,
                      fontWeight:
                          FontWeight
                              .w800,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    description,
                    style:
                        const TextStyle(
                      color:
                          subtitleBlue,
                      fontSize:
                          12,
                      height:
                          1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EXPERT AVATAR
  // ============================================================

  Widget _expertAvatar(
    String name,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () {
        _openExpertProfile(
          name,
        );
      },
      child:
          Container(
        width: 105,
        margin:
            const EdgeInsets
                .only(
          right: 15,
        ),
        child:
            Column(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration:
                  BoxDecoration(
                color:
                    Colors.white,
                shape:
                    BoxShape
                        .circle,
                border:
                    Border.all(
                  color:
                      navy,
                  width:
                      1.5,
                ),
              ),
              child:
                  Icon(
                icon,
                color:
                    brandRed,
                size:
                    30,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              name,
              textAlign:
                  TextAlign
                      .center,
              style:
                  const TextStyle(
                color:
                    navy,
                fontSize:
                    12,
                fontWeight:
                    FontWeight
                        .w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content:
            Text(message),
        behavior:
            SnackBarBehavior
                .floating,
      ),
    );
  }
}