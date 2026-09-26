import 'package:flutter/material.dart';
import 'course_detail_screen.dart';

// ============================================================
// MODEL
// ============================================================

class CourseListItem {
  final String courseTitle;
  final String subject;
  final IconData icon;
  final Color courseColor;
  final String duration;
  final int totalLessons;
  final int completedLessons;

  const CourseListItem({
    required this.courseTitle,
    required this.subject,
    required this.icon,
    required this.courseColor,
    required this.duration,
    required this.totalLessons,
    this.completedLessons = 0,
  });
}

// ============================================================
// COURSES SCREEN
// ============================================================

class CoursesScreen extends StatelessWidget {
  final List<CourseListItem> courses;

  const CoursesScreen({
    super.key,
    this.courses = const [
      CourseListItem(
        courseTitle: 'Chemical Bonds',
        subject: 'Chemistry',
        icon: Icons.science,
        courseColor: Color(0xFF33B679),
        duration: '5 hours',
        totalLessons: 10,
        completedLessons: 4,
      ),
      CourseListItem(
        courseTitle: 'Calculus Basics',
        subject: 'Maths',
        icon: Icons.functions,
        courseColor: Color(0xFFE8394A),
        duration: '6 hours',
        totalLessons: 10,
        completedLessons: 7,
      ),
      CourseListItem(
        courseTitle: 'Quantum Physics',
        subject: 'Physics',
        icon: Icons.bolt_rounded,
        courseColor: Color(0xFFF4C10F),
        duration: '7 hours',
        totalLessons: 10,
        completedLessons: 2,
      ),
      CourseListItem(
        courseTitle: 'Essay Writing',
        subject: 'English',
        icon: Icons.menu_book_rounded,
        courseColor: Color(0xFF4D86AD),
        duration: '4 hours',
        totalLessons: 8,
        completedLessons: 0,
      ),
    ],
  });

  static const Color navy = Color(0xFF14213D);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color trackGrey = Color(0xFFE9EDF0);

  void _openCourse(BuildContext context, CourseListItem course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailScreen(
          courseTitle: course.courseTitle,
          subject: course.subject,
          duration: course.duration,
          totalLessons: course.totalLessons,
          completedLessons: course.completedLessons,
          courseColor: course.courseColor,
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
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, color: navy),
                  ),
                  const Text(
                    'My Courses',
                    style: TextStyle(
                      color: navy,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: courses.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final course = courses[index];
                  final progress = course.totalLessons == 0
                      ? 0.0
                      : course.completedLessons / course.totalLessons;

                  return InkWell(
                    onTap: () => _openCourse(context, course),
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
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: course.courseColor,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  course.icon,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.subject,
                                      style: const TextStyle(
                                        color: subtitleBlue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      course.courseTitle,
                                      style: const TextStyle(
                                        color: navy,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: navy,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              backgroundColor: trackGrey,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                course.courseColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '${course.completedLessons}/${course.totalLessons} lessons',
                                style: const TextStyle(
                                  color: subtitleBlue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.access_time_rounded,
                                color: subtitleBlue,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                course.duration,
                                style: const TextStyle(
                                  color: subtitleBlue,
                                  fontSize: 12,
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