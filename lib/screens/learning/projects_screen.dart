import 'package:flutter/material.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color navy = Color(0xFF1D3B64);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color lightBackground = Color(0xFFF7F9FC);
  static const Color green = Color(0xFF33B679);
  static const Color yellow = Color(0xFFF4C10F);

  // ============================================================
  // SEARCH
  // ============================================================

  final TextEditingController searchController =
      TextEditingController();

  String selectedCategory = 'All';

  // ============================================================
  // PROJECT DATA
  // ============================================================

  final List<Map<String, dynamic>> projects = [
    {
      'title': 'AI Chatbot',
      'description':
          'Build an intelligent chatbot using LLMs, prompts and conversational AI.',
      'category': 'Generative AI',
      'difficulty': 'Intermediate',
      'duration': '2 Weeks',
      'progress': 0.65,
      'icon': Icons.smart_toy_outlined,
      'iconColor': Color(0xFF4D86AD),
      'status': 'In Progress',
    },
    {
      'title': 'RAG Knowledge Assistant',
      'description':
          'Create a document-based AI assistant using embeddings, vector search and RAG.',
      'category': 'Generative AI',
      'difficulty': 'Advanced',
      'duration': '3 Weeks',
      'progress': 0.35,
      'icon': Icons.menu_book_rounded,
      'iconColor': Color(0xFF33B679),
      'status': 'In Progress',
    },
    {
      'title': 'Fraud Detection System',
      'description':
          'Build a machine learning model to identify suspicious financial transactions.',
      'category': 'Machine Learning',
      'difficulty': 'Intermediate',
      'duration': '2 Weeks',
      'progress': 0.80,
      'icon': Icons.security_outlined,
      'iconColor': Color(0xFFEF3340),
      'status': 'In Progress',
    },
    {
      'title': 'Student Performance Predictor',
      'description':
          'Predict student performance using academic and behavioral data.',
      'category': 'Machine Learning',
      'difficulty': 'Beginner',
      'duration': '1 Week',
      'progress': 0.20,
      'icon': Icons.school_outlined,
      'iconColor': Color(0xFFF4C10F),
      'status': 'Not Started',
    },
    {
      'title': 'Personal Finance Tracker',
      'description':
          'Develop an application to track income, expenses, savings and spending patterns.',
      'category': 'Application',
      'difficulty': 'Intermediate',
      'duration': '2 Weeks',
      'progress': 0.50,
      'icon': Icons.account_balance_wallet_outlined,
      'iconColor': Color(0xFF33B679),
      'status': 'In Progress',
    },
    {
      'title': 'Portfolio Website',
      'description':
          'Create a professional developer portfolio using modern web technologies.',
      'category': 'Web Development',
      'difficulty': 'Beginner',
      'duration': '1 Week',
      'progress': 0.0,
      'icon': Icons.language_outlined,
      'iconColor': Color(0xFF4D86AD),
      'status': 'Not Started',
    },
  ];

  // ============================================================
  // CATEGORIES
  // ============================================================

  final List<String> categories = [
    'All',
    'Generative AI',
    'Machine Learning',
    'Application',
    'Web Development',
  ];

  // ============================================================
  // FILTER PROJECTS
  // ============================================================

  List<Map<String, dynamic>> get filteredProjects {
    final search = searchController.text.toLowerCase();

    return projects.where((project) {
      final matchesCategory =
          selectedCategory == 'All' ||
          project['category'] == selectedCategory;

      final matchesSearch =
          project['title']
                  .toString()
                  .toLowerCase()
                  .contains(search) ||
              project['description']
                  .toString()
                  .toLowerCase()
                  .contains(search);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        iconTheme: const IconThemeData(
          color: navy,
        ),

        title: const Text(
          'Projects',
          style: TextStyle(
            color: navy,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ==================================================
              // HEADER
              // ==================================================

              const Text(
                'Build. Practice. Create. 🚀',
                style: TextStyle(
                  color: navy,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Apply what you learn by building real-world projects.',
                style: TextStyle(
                  color: subtitleBlue,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // PROJECT SUMMARY
              // ==================================================

              _projectSummaryCard(),

              const SizedBox(height: 24),

              // ==================================================
              // SEARCH
              // ==================================================

              TextField(
                controller: searchController,

                onChanged: (value) {
                  setState(() {});
                },

                decoration: InputDecoration(
                  hintText: 'Search projects...',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),

                  prefixIcon: const Icon(
                    Icons.search,
                    color: navy,
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),

                  contentPadding:
                      const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // CATEGORIES
              // ==================================================

              const Text(
                'Project Categories',
                style: TextStyle(
                  color: navy,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                height: 42,

                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,

                  itemBuilder: (context, index) {
                    final category =
                        categories[index];

                    final isSelected =
                        selectedCategory == category;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory =
                              category;
                        });
                      },

                      child: Container(
                        margin:
                            const EdgeInsets.only(
                          right: 10,
                        ),

                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),

                        decoration: BoxDecoration(
                          color: isSelected
                              ? brandRed
                              : Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            25,
                          ),
                        ),

                        child: Text(
                          category,

                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : navy,

                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // ==================================================
              // FEATURED PROJECT
              // ==================================================

              const Text(
                'Featured Project',
                style: TextStyle(
                  color: navy,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 15),

              _featuredProject(),

              const SizedBox(height: 30),

              // ==================================================
              // ALL PROJECTS
              // ==================================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    'All Projects',
                    style: TextStyle(
                      color: navy,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  Text(
                    '${filteredProjects.length} projects',
                    style: const TextStyle(
                      color: subtitleBlue,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // ==================================================
              // PROJECT LIST
              // ==================================================

              if (filteredProjects.isEmpty)

                const Padding(
                  padding: EdgeInsets.all(40),

                  child: Center(
                    child: Text(
                      'No projects found.',
                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 17,
                      ),
                    ),
                  ),
                )

              else

                ListView.builder(
                  itemCount:
                      filteredProjects.length,

                  shrinkWrap: true,

                  physics:
                      const NeverScrollableScrollPhysics(),

                  itemBuilder: (context, index) {
                    final project =
                        filteredProjects[index];

                    return _projectCard(project);
                  },
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROJECT SUMMARY
  // ============================================================

  Widget _projectSummaryCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(24),
      ),

      child: Row(
        children: [

          Expanded(
            child: _summaryItem(
              Icons.folder_open_rounded,
              '6',
              'Available',
            ),
          ),

          Container(
            width: 1,
            height: 55,
            color: Colors.white24,
          ),

          Expanded(
            child: _summaryItem(
              Icons.play_circle_outline,
              '4',
              'In Progress',
            ),
          ),

          Container(
            width: 1,
            height: 55,
            color: Colors.white24,
          ),

          Expanded(
            child: _summaryItem(
              Icons.check_circle_outline,
              '2',
              'Completed',
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUMMARY ITEM
  // ============================================================

  Widget _summaryItem(
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [

        Icon(
          icon,
          color: Colors.white,
          size: 25,
        ),

        const SizedBox(height: 8),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FEATURED PROJECT
  // ============================================================

  Widget _featuredProject() {
    return GestureDetector(
      onTap: () {
        _openProject(projects[1]);
      },

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(24),

          border: Border.all(
            color: navy,
            width: 1.4,
          ),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(
              children: [

                Container(
                  width: 58,
                  height: 58,

                  decoration: BoxDecoration(
                    color: green,
                    borderRadius:
                        BorderRadius.circular(16),
                  ),

                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 15),

                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(
                        'RAG Knowledge Assistant',
                        style: TextStyle(
                          color: navy,
                          fontSize: 19,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        'Generative AI',
                        style: TextStyle(
                          color: brandRed,
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: navy,
                  size: 18,
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              'Build a document-based AI assistant using '
              'embeddings, vector search and Retrieval-Augmented Generation.',
              style: TextStyle(
                color: subtitleBlue,
                fontSize: 14,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [

                _smallInfo(
                  Icons.signal_cellular_alt_rounded,
                  'Advanced',
                ),

                const SizedBox(width: 18),

                _smallInfo(
                  Icons.access_time_rounded,
                  '3 Weeks',
                ),
              ],
            ),

            const SizedBox(height: 18),

            const Text(
              '35% completed',
              style: TextStyle(
                color: navy,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10),

              child:
                  const LinearProgressIndicator(
                value: 0.35,
                minHeight: 8,
                backgroundColor:
                    Color(0xFFE8EDF2),
                valueColor:
                    AlwaysStoppedAnimation<Color>(
                  green,
                ),
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              height: 46,

              child: ElevatedButton(
                onPressed: () {
                  _openProject(projects[1]);
                },

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor: brandRed,
                  elevation: 0,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25),
                  ),
                ),

                child: const Text(
                  'Open Project',
                  style: TextStyle(
                    color: Colors.white,
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
  // SMALL INFO
  // ============================================================

  Widget _smallInfo(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [

        Icon(
          icon,
          color: subtitleBlue,
          size: 16,
        ),

        const SizedBox(width: 6),

        Text(
          text,
          style: const TextStyle(
            color: subtitleBlue,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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

    final bool completed =
        progress >= 1.0;

    return GestureDetector(
      onTap: () {
        _openProject(project);
      },

      child: Container(
        margin:
            const EdgeInsets.only(bottom: 16),

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(22),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // PROJECT ICON

                Container(
                  width: 58,
                  height: 58,

                  decoration: BoxDecoration(
                    color:
                        (project['iconColor']
                                as Color)
                            .withValues(alpha: 0.12),

                    borderRadius:
                        BorderRadius.circular(16),
                  ),

                  child: Icon(
                    project['icon']
                        as IconData,

                    color:
                        project['iconColor']
                            as Color,

                    size: 30,
                  ),
                ),

                const SizedBox(width: 15),

                // PROJECT INFORMATION

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
                          fontSize: 18,
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
                              FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        project['description'],
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,

                        style:
                            const TextStyle(
                          color: subtitleBlue,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ==================================================
            // DIFFICULTY + DURATION
            // ==================================================

            Row(
              children: [

                _smallInfo(
                  Icons.signal_cellular_alt_rounded,
                  project['difficulty'],
                ),

                const SizedBox(width: 18),

                _smallInfo(
                  Icons.access_time_rounded,
                  project['duration'],
                ),

                const Spacer(),

                _statusBadge(
                  project['status'],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ==================================================
            // PROGRESS
            // ==================================================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [

                Text(
                  completed
                      ? 'Completed'
                      : '${(progress * 100).round()}% completed',

                  style: const TextStyle(
                    color: navy,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                if (progress > 0)
                  Text(
                    progress >= 1
                        ? '100%'
                        : '${(progress * 100).round()}%',

                    style:
                        const TextStyle(
                      color: subtitleBlue,
                      fontSize: 13,
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

                minHeight: 8,

                backgroundColor:
                    const Color(0xFFE8EDF2),

                valueColor:
                    AlwaysStoppedAnimation<Color>(
                  progress >= 1
                      ? green
                      : brandRed,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // OPEN PROJECT BUTTON
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 44,

              child: OutlinedButton(
                onPressed: () {
                  _openProject(project);
                },

                style:
                    OutlinedButton.styleFrom(
                  foregroundColor: navy,

                  side: const BorderSide(
                    color: navy,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25),
                  ),
                ),

                child: const Text(
                  'Open Project',
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
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _statusBadge(String status) {
    Color background;
    Color textColor;

    if (status == 'In Progress') {
      background = const Color(0xFFE7F6EF);
      textColor = green;
    } else if (status == 'Completed') {
      background = const Color(0xFFE5F1FF);
      textColor = subtitleBlue;
    } else {
      background = const Color(0xFFF1F3F5);
      textColor = subtitleBlue;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: background,
        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // OPEN PROJECT
  // ============================================================

  void _openProject(
    Map<String, dynamic> project,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProjectDetailScreen(
          project: project,
        ),
      ),
    );
  }
}

// ============================================================
// PROJECT DETAIL SCREEN
// ============================================================

class ProjectDetailScreen extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailScreen({
    super.key,
    required this.project,
  });

  static const Color navy = Color(0xFF1D3B64);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color green = Color(0xFF33B679);
  static const Color lightBackground = Color(0xFFF7F9FC);

  @override
  Widget build(BuildContext context) {
    final double progress =
        project['progress'] as double;

    return Scaffold(
      backgroundColor: lightBackground,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        iconTheme:
            const IconThemeData(
          color: navy,
        ),

        title: const Text(
          'Project Details',
          style: TextStyle(
            color: navy,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // ==================================================
            // PROJECT HEADER
            // ==================================================

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: navy,
                borderRadius:
                    BorderRadius.circular(24),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Container(
                    width: 60,
                    height: 60,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(16),
                    ),

                    child: Icon(
                      project['icon']
                          as IconData,
                      color:
                          project['iconColor']
                              as Color,
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    project['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    project['category'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    project['description'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ==================================================
            // PROJECT INFORMATION
            // ==================================================

            const Text(
              'Project Information',
              style: TextStyle(
                color: navy,
                fontSize: 21,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                Expanded(
                  child: _infoCard(
                    Icons.signal_cellular_alt_rounded,
                    'Difficulty',
                    project['difficulty'],
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _infoCard(
                    Icons.access_time_rounded,
                    'Duration',
                    project['duration'],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ==================================================
            // PROGRESS
            // ==================================================

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    'Your Progress',
                    style: TextStyle(
                      color: navy,
                      fontSize: 18,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [

                      Expanded(
                        child:
                            ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                            10,
                          ),

                          child:
                              LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
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
                      ),

                      const SizedBox(width: 12),

                      Text(
                        '${(progress * 100).round()}%',
                        style:
                            const TextStyle(
                          color: navy,
                          fontSize: 18,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ==================================================
            // PROJECT STEPS
            // ==================================================

            const Text(
              'Project Roadmap',
              style: TextStyle(
                color: navy,
                fontSize: 21,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const SizedBox(height: 15),

            _roadmapItem(
              1,
              'Understand the Requirements',
              'Understand the project objective and expected output.',
              true,
            ),

            _roadmapItem(
              2,
              'Learn Required Concepts',
              'Study the concepts and technologies needed for the project.',
              progress >= 0.25,
            ),

            _roadmapItem(
              3,
              'Build the Project',
              'Implement the project step by step.',
              progress >= 0.50,
            ),

            _roadmapItem(
              4,
              'Test & Improve',
              'Test your project and fix problems.',
              progress >= 0.75,
            ),

            _roadmapItem(
              5,
              'Deploy & Present',
              'Deploy your project and prepare your presentation.',
              progress >= 1.0,
            ),

            const SizedBox(height: 25),

            // ==================================================
            // START BUTTON
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: () {

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Project workspace will be connected next.',
                      ),
                    ),
                  );
                },

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor: brandRed,
                  elevation: 0,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),
                  ),
                ),

                child: const Text(
                  'Start Project',
                  style: TextStyle(
                    color: Colors.white,
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
    );
  }

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget _infoCard(
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            color: subtitleBlue,
            size: 24,
          ),

          const SizedBox(height: 10),

          Text(
            label,
            style: const TextStyle(
              color: subtitleBlue,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              color: navy,
              fontSize: 15,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ROADMAP ITEM
  // ============================================================

  Widget _roadmapItem(
    int number,
    String title,
    String description,
    bool completed,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 14),

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(
            width: 40,
            height: 40,

            decoration: BoxDecoration(
              color: completed
                  ? green
                  : const Color(
                      0xFFE9EDF0,
                    ),
              shape: BoxShape.circle,
            ),

            alignment:
                Alignment.center,

            child: completed
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : Text(
                    '$number',
                    style:
                        const TextStyle(
                      color: navy,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style:
                      const TextStyle(
                    color: navy,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style:
                      const TextStyle(
                    color: subtitleBlue,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}