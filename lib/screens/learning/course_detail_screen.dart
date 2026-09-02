import 'package:flutter/material.dart';

// ============================================================
// COURSE DETAIL SCREEN
// ============================================================

class CourseDetailScreen extends StatefulWidget {
  final String courseTitle;
  final String subject;
  final String instructor;
  final String description;
  final String duration;
  final int totalLessons;
  final int completedLessons;
  final Color courseColor;

  const CourseDetailScreen({
    super.key,
    required this.courseTitle,
    required this.subject,
    this.instructor = 'EduVerse AI Mentor',
    this.description =
        'Learn this subject step by step with personalized lessons, '
        'practice questions, quizzes, and AI-powered guidance.',
    this.duration = '6 hours',
    this.totalLessons = 10,
    this.completedLessons = 0,
    this.courseColor = const Color(0xFF33B679),
  });

  @override
  State<CourseDetailScreen> createState() =>
      _CourseDetailScreenState();
}

// ============================================================
// STATE
// ============================================================

class _CourseDetailScreenState
    extends State<CourseDetailScreen> {
  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color trackGrey = Color(0xFFE9EDF0);
  static const Color lightBlue = Color(0xFFDCF1F8);
  static const Color lightYellow = Color(0xFFFBF1CE);

  // ==========================================================
  // LESSON MODEL
  // ==========================================================

  late List<LessonItem> lessons;

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();

    lessons = _createLessons();
  }

  // ==========================================================
  // CREATE LESSONS
  // ==========================================================

  List<LessonItem> _createLessons() {
    final List<String> lessonTitles = [
      'Introduction',
      'Understanding the Basics',
      'Core Concepts',
      'Important Principles',
      'Practical Examples',
      'Problem Solving',
      'Advanced Concepts',
      'Practice Session',
      'Revision',
      'Final Assessment',
    ];

    final List<String> durations = [
      '15 min',
      '25 min',
      '30 min',
      '25 min',
      '30 min',
      '35 min',
      '40 min',
      '30 min',
      '20 min',
      '30 min',
    ];

    return List.generate(
      widget.totalLessons,
      (index) {
        final title = index < lessonTitles.length
            ? lessonTitles[index]
            : 'Lesson ${index + 1}';

        final duration = index < durations.length
            ? durations[index]
            : '25 min';

        return LessonItem(
          number: index + 1,
          title: title,
          duration: duration,
          completed:
              index < widget.completedLessons,
        );
      },
    );
  }

  // ==========================================================
  // PROGRESS
  // ==========================================================

  double get progress {
    if (lessons.isEmpty) {
      return 0;
    }

    final completed =
        lessons.where((lesson) => lesson.completed).length;

    return completed / lessons.length;
  }

  int get completedCount {
    return lessons
        .where((lesson) => lesson.completed)
        .length;
  }

  // ==========================================================
  // LESSON TAP
  // ==========================================================

  void _openLesson(LessonItem lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonLearningScreen(
          courseTitle: widget.courseTitle,
          lesson: lesson,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  // ==========================================================
  // START / CONTINUE COURSE
  // ==========================================================

  void _continueCourse() {
    LessonItem? nextLesson;

    for (final lesson in lessons) {
      if (!lesson.completed) {
        nextLesson = lesson;
        break;
      }
    }

    if (nextLesson != null) {
      _openLesson(nextLesson);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Congratulations! You completed this course.',
          ),
        ),
      );
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final percentage =
        (progress * 100).round();

    return Scaffold(
      backgroundColor: Colors.white,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,

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
          'Course Details',
          style: TextStyle(
            color: navy,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              // ==================================================
              // COURSE HERO
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius:
                      BorderRadius.circular(26),
                  border: Border.all(
                    color: navy,
                    width: 1.4,
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    // SUBJECT ICON
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: widget.courseColor,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // SUBJECT
                    Text(
                      widget.subject,
                      style: const TextStyle(
                        color: subtitleBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // COURSE TITLE
                    Text(
                      widget.courseTitle,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // INSTRUCTOR
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          color: subtitleBlue,
                          size: 18,
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            widget.instructor,
                            style:
                                const TextStyle(
                              color: subtitleBlue,
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // DURATION
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: subtitleBlue,
                          size: 18,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          widget.duration,
                          style:
                              const TextStyle(
                            color: subtitleBlue,
                            fontSize: 14,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // PROGRESS CARD
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(20),
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
                        const Expanded(
                          child: Text(
                            'Your Progress',
                            style: TextStyle(
                              color: navy,
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                        ),

                        Text(
                          '$percentage%',
                          style: const TextStyle(
                            color: brandRed,
                            fontSize: 20,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(50),
                      child:
                          LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor:
                            trackGrey,
                        valueColor:
                            AlwaysStoppedAnimation<
                                Color>(
                          widget.courseColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      '$completedCount of ${lessons.length} lessons completed',
                      style: const TextStyle(
                        color: subtitleBlue,
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // CONTINUE BUTTON
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _continueCourse,
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(50),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        progress == 0
                            ? Icons.play_arrow_rounded
                            : Icons.play_circle_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        progress == 0
                            ? 'Start Course'
                            : progress >= 1
                                ? 'Course Completed'
                                : 'Continue Learning',
                        style:
                            const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // ABOUT COURSE
              // ==================================================

              const Text(
                'About This Course',
                style: TextStyle(
                  color: navy,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: lightYellow,
                  borderRadius:
                      BorderRadius.circular(20),
                  border: Border.all(
                    color: navy,
                    width: 1.2,
                  ),
                ),
                child: Text(
                  widget.description,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ==================================================
              // COURSE CONTENT
              // ==================================================

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Course Content',
                      style: TextStyle(
                        color: navy,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ),

                  Text(
                    '${lessons.length} Lessons',
                    style: const TextStyle(
                      color: subtitleBlue,
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ==================================================
              // LESSON LIST
              // ==================================================

              ListView.separated(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: lessons.length,
                separatorBuilder:
                    (context, index) =>
                        const SizedBox(height: 12),
                itemBuilder:
                    (context, index) {
                  final lesson =
                      lessons[index];

                  return _LessonCard(
                    lesson: lesson,
                    onTap: () {
                      _openLesson(lesson);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// LESSON MODEL
// ============================================================

class LessonItem {
  final int number;
  final String title;
  final String duration;
  bool completed;

  LessonItem({
    required this.number,
    required this.title,
    required this.duration,
    this.completed = false,
  });
}

// ============================================================
// LESSON CARD
// ============================================================

class _LessonCard extends StatelessWidget {
  final LessonItem lesson;
  final VoidCallback onTap;

  const _LessonCard({
    required this.lesson,
    required this.onTap,
  });

  static const Color navy =
      Color(0xFF14213D);

  static const Color subtitleBlue =
      Color(0xFF4D86AD);

  static const Color brandRed =
      Color(0xFFE8394A);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: navy,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [

            // ==================================================
            // LESSON NUMBER
            // ==================================================

            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: lesson.completed
                    ? const Color(
                        0xFF33B679,
                      )
                    : const Color(
                        0xFFDCF1F8,
                      ),
                borderRadius:
                    BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: lesson.completed
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 26,
                    )
                  : Text(
                      '${lesson.number}',
                      style:
                          const TextStyle(
                        color: navy,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
            ),

            const SizedBox(width: 14),

            // ==================================================
            // LESSON DETAILS
            // ==================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    'Lesson ${lesson.number}',
                    style:
                        const TextStyle(
                      color: subtitleBlue,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    lesson.title,
                    style:
                        const TextStyle(
                      color: navy,
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Row(
                    children: [
                      const Icon(
                        Icons
                            .access_time_rounded,
                        color:
                            subtitleBlue,
                        size: 14,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        lesson.duration,
                        style:
                            const TextStyle(
                          color:
                              subtitleBlue,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ==================================================
            // ARROW
            // ==================================================

            Icon(
              lesson.completed
                  ? Icons.check_circle_outline
                  : Icons
                      .chevron_right_rounded,
              color: lesson.completed
                  ? const Color(
                      0xFF33B679,
                    )
                  : brandRed,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// LESSON LEARNING SCREEN
// ============================================================

class LessonLearningScreen
    extends StatefulWidget {
  final String courseTitle;
  final LessonItem lesson;

  const LessonLearningScreen({
    super.key,
    required this.courseTitle,
    required this.lesson,
  });

  @override
  State<LessonLearningScreen> createState() =>
      _LessonLearningScreenState();
}

// ============================================================
// LESSON LEARNING STATE
// ============================================================

class _LessonLearningScreenState
    extends State<LessonLearningScreen> {

  static const Color navy =
      Color(0xFF14213D);

  static const Color subtitleBlue =
      Color(0xFF4D86AD);

  static const Color brandRed =
      Color(0xFFE8394A);

  static const Color lightBlue =
      Color(0xFFDCF1F8);

  // ==========================================================
  // MARK LESSON COMPLETE
  // ==========================================================

  void _markComplete() {
    setState(() {
      widget.lesson.completed = true;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Lesson completed! Great work 🎉',
        ),
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

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
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: navy,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          widget.courseTitle,
          style: const TextStyle(
            color: navy,
            fontSize: 18,
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
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              // ==================================================
              // LESSON HEADER
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius:
                      BorderRadius.circular(24),
                  border: Border.all(
                    color: navy,
                    width: 1.3,
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      'Lesson ${widget.lesson.number}',
                      style: const TextStyle(
                        color: subtitleBlue,
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      widget.lesson.title,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 28,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: subtitleBlue,
                          size: 17,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.lesson.duration,
                          style:
                              const TextStyle(
                            color:
                                subtitleBlue,
                            fontSize: 14,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // LESSON CONTENT
              // ==================================================

              const Text(
                'Learn',
                style: TextStyle(
                  color: navy,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(20),
                  border: Border.all(
                    color: navy,
                    width: 1.2,
                  ),
                ),
                child: const Text(
                  'This lesson will contain personalized '
                  'learning content generated for the student. '
                  'You can later connect this section with '
                  'your AI Tutor, RAG system, videos, notes, '
                  'examples, and interactive explanations.',
                  style: TextStyle(
                    color: navy,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // AI TUTOR CARD
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF1CE),
                  borderRadius:
                      BorderRadius.circular(20),
                  border: Border.all(
                    color: navy,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Container(
                      width: 48,
                      height: 48,
                      decoration:
                          const BoxDecoration(
                        color:
                            Color(0xFF33B679),
                        shape: BoxShape.circle,
                      ),
                      alignment:
                          Alignment.center,
                      child: const Text(
                        'AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aria: Your AI Tutor',
                            style: TextStyle(
                              color: navy,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Need help? Ask me to explain '
                            'this lesson in a simpler way.',
                            style: TextStyle(
                              color:
                                  subtitleBlue,
                              fontSize: 14,
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
              // COMPLETE BUTTON
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed:
                      widget.lesson.completed
                          ? null
                          : _markComplete,
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        brandRed,
                    disabledBackgroundColor:
                        const Color(
                      0xFF33B679,
                    ),
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        50,
                      ),
                    ),
                  ),
                  child: Text(
                    widget.lesson.completed
                        ? 'Lesson Completed ✓'
                        : 'Mark as Complete',
                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
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
  }
}