import 'package:flutter/material.dart';

import 'skill_gap_analysis.dart';
import '../learning/ai_learning_hub.dart';

class PersonalizedRoadmapScreen extends StatefulWidget {
  final String careerTitle;

  // Assessment score from Sophia assessment.
  // Example:
  // 40 -> Beginner
  // 65 -> Intermediate
  // 85 -> Advanced
  final int assessmentScore;

  const PersonalizedRoadmapScreen({
    super.key,
    this.careerTitle = 'AI Engineer',
    this.assessmentScore = 65,
  });

  @override
  State<PersonalizedRoadmapScreen> createState() =>
      _PersonalizedRoadmapScreenState();
}

class _PersonalizedRoadmapScreenState
    extends State<PersonalizedRoadmapScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color navy = Color(0xFF14213D);
  static const Color brandRed = Color(0xFFE8394A);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color successGreen = Color(0xFF52B68C);
  static const Color lightBackground = Color(0xFFF7F9FC);
  static const Color lightBlue = Color(0xFFEAF8FB);
  static const Color lightGreen = Color(0xFFEAF7F1);
  static const Color lightRed = Color(0xFFFFEEF0);

  // ============================================================
  // ROADMAP DATA
  // ============================================================

  late final List<RoadmapStage> _stages;

  @override
  void initState() {
    super.initState();
    _stages = _createRoadmap();
  }

  // ============================================================
  // DETERMINE LEVEL FROM ASSESSMENT SCORE
  // ============================================================

  String get _learningLevel {
    if (widget.assessmentScore > 80) {
      return 'Advanced';
    }

    if (widget.assessmentScore > 50) {
      return 'Intermediate';
    }

    return 'Beginner';
  }

  Color get _levelColor {
    if (_learningLevel == 'Advanced') {
      return successGreen;
    }

    if (_learningLevel == 'Intermediate') {
      return brandRed;
    }

    return subtitleBlue;
  }

  // ============================================================
  // OVERALL PROGRESS
  // ============================================================

  double get _overallProgress {
    if (_stages.isEmpty) {
      return 0;
    }

    final completed =
        _stages.where((stage) => stage.completed).length;

    final current =
        _stages.where((stage) => stage.current).length;

    return ((completed + (current * 0.5)) / _stages.length)
        .clamp(0.0, 1.0);
  }

  int get _completedStages {
    return _stages.where((stage) => stage.completed).length;
  }

  int get _remainingStages {
    return _stages
        .where(
          (stage) => !stage.completed,
        )
        .length;
  }

  // ============================================================
  // CREATE PERSONALIZED ROADMAP
  // ============================================================

  List<RoadmapStage> _createRoadmap() {
    return [
      RoadmapStage(
        title: 'Foundation',
        description:
            'Build the core knowledge required for your career path.',
        skills: [
          'Programming Fundamentals',
          'Problem Solving',
          'Logical Thinking',
        ],
        icon: Icons.foundation,
        completed: true,
        current: false,
      ),

      RoadmapStage(
        title: 'Core Skills',
        description:
            'Develop the technical skills required for your target career.',
        skills: [
          'Python',
          'Data Structures',
          'Algorithms',
          'SQL',
        ],
        icon: Icons.code_rounded,
        completed: false,
        current: true,
      ),

      RoadmapStage(
        title: 'Specialization',
        description:
            'Build specialized skills based on your career target.',
        skills: [
          'Machine Learning',
          'Generative AI',
          'Model Development',
          'AI Tools',
        ],
        icon: Icons.auto_awesome_rounded,
        completed: false,
        current: false,
      ),

      RoadmapStage(
        title: 'Projects & Practice',
        description:
            'Apply your verified skills through real-world projects.',
        skills: [
          'Portfolio Projects',
          'Coding Practice',
          'Real-world Problems',
          'Project Deployment',
        ],
        icon: Icons.rocket_launch_rounded,
        completed: false,
        current: false,
      ),

      RoadmapStage(
        title: 'Career Readiness',
        description:
            'Prepare for interviews, assessments and placement opportunities.',
        skills: [
          'Resume',
          'Mock Interviews',
          'Aptitude',
          'Communication',
        ],
        icon: Icons.work_outline_rounded,
        completed: false,
        current: false,
      ),
    ];
  }

  // ============================================================
  // UNLOCK GAMIFIED ROADMAP
  // ============================================================

  void _unlockGamifiedRoadmap() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AiLearningHub(
          studentName: 'Student',
          points: 0,
        ),
      ),
    );
  }

  // ============================================================
  // OPEN SKILL GAP
  // ============================================================

  void _openSkillGap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SkillGapAnalysis(),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final percentage =
        (_overallProgress * 100).round();

    return Scaffold(
      backgroundColor: lightBackground,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: navy,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Personalized Roadmap',
          style: const TextStyle(
            color: navy,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // ==================================================
              // HEADER
              // ==================================================

              const Text(
                'Your Learning Roadmap',
                style: TextStyle(
                  color: navy,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Personalized for ${widget.careerTitle}',
                style: const TextStyle(
                  color: subtitleBlue,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // LEVEL CARD
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),

                  border: Border.all(
                    color: navy,
                    width: 1.2,
                  ),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Row(
                      children: [

                        Container(
                          width: 55,
                          height: 55,

                          decoration: BoxDecoration(
                            color: _levelColor
                                .withValues(alpha: 0.12),
                            borderRadius:
                                BorderRadius.circular(16),
                          ),

                          child: Icon(
                            Icons.school_rounded,
                            color: _levelColor,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              const Text(
                                'Recommended Level',
                                style: TextStyle(
                                  color: subtitleBlue,
                                  fontSize: 13,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                _learningLevel,
                                style: TextStyle(
                                  color: _levelColor,
                                  fontSize: 22,
                                  fontWeight:
                                      FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),

                          decoration: BoxDecoration(
                            color: _levelColor,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),

                          child: Text(
                            '${widget.assessmentScore}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Text(
                      _levelMessage(),
                      style: const TextStyle(
                        color: navy,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // PROGRESS CARD
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: navy,
                  borderRadius:
                      BorderRadius.circular(22),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [

                        const Text(
                          'Roadmap Progress',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),

                        Text(
                          '$percentage%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(20),

                      child:
                          LinearProgressIndicator(
                        value: _overallProgress,
                        minHeight: 10,

                        backgroundColor:
                            Colors.white24,

                        valueColor:
                            const AlwaysStoppedAnimation<
                                Color>(
                          brandRed,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      '$_completedStages of ${_stages.length} stages completed',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // ADAPTIVE ROADMAP TITLE
              // ==================================================

              Row(
                children: [

                  const Expanded(
                    child: Text(
                      'Your Personalized Path',
                      style: TextStyle(
                        color: navy,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: lightGreen,
                      borderRadius:
                          BorderRadius.circular(15),
                    ),

                    child: const Row(
                      children: [

                        Icon(
                          Icons.auto_awesome,
                          color: successGreen,
                          size: 15,
                        ),

                        SizedBox(width: 5),

                        Text(
                          'Adaptive',
                          style: TextStyle(
                            color: successGreen,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              const Text(
                'Your roadmap is organized into competency-based stages. Complete each stage to unlock the next level.',
                style: TextStyle(
                  color: subtitleBlue,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // ROADMAP TIMELINE
              // ==================================================

              ListView.builder(
                itemCount: _stages.length,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),

                itemBuilder: (context, index) {

                  final stage =
                      _stages[index];

                  final isLast =
                      index == _stages.length - 1;

                  return _buildRoadmapStage(
                    stage,
                    index,
                    isLast,
                  );
                },
              ),

              const SizedBox(height: 20),

              // ==================================================
              // SKILL GAP CARD
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius:
                      BorderRadius.circular(22),

                  border: Border.all(
                    color: subtitleBlue
                        .withValues(alpha: 0.25),
                  ),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Row(
                      children: [

                        Container(
                          width: 45,
                          height: 45,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(13),
                          ),

                          child: const Icon(
                            Icons.analytics_outlined,
                            color: navy,
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Text(
                            'Need to improve your skills?',
                            style: TextStyle(
                              color: navy,
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Review your competency gaps and identify the skills that need more practice before progressing.',
                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 48,

                      child: OutlinedButton(
                        onPressed: _openSkillGap,

                        style:
                            OutlinedButton.styleFrom(
                          foregroundColor: navy,

                          side:
                              const BorderSide(
                            color: navy,
                            width: 1.2,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              25,
                            ),
                          ),
                        ),

                        child: const Text(
                          'View Skill Gap Report',
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

              const SizedBox(height: 28),

              // ==================================================
              // UNLOCK GAMIFIED ROADMAP
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(22),

                  border: Border.all(
                    color: navy,
                    width: 1.3,
                  ),
                ),

                child: Column(
                  children: [

                    Container(
                      width: 58,
                      height: 58,

                      decoration: BoxDecoration(
                        color: brandRed
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.lock_open_rounded,
                        color: brandRed,
                        size: 30,
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      'Ready to start your roadmap?',
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: navy,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Unlock your gamified learning roadmap and continue your level-wise learning from the Home Hub.',
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: subtitleBlue,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 52,

                      child: ElevatedButton.icon(
                        onPressed:
                            _unlockGamifiedRoadmap,

                        icon: const Icon(
                          Icons.rocket_launch_rounded,
                          color: Colors.white,
                        ),

                        label: const Text(
                          'Unlock Gamified Roadmap',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              brandRed,

                          elevation: 0,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Center(
                child: Text(
                  '$_remainingStages stages remaining',
                  style: const TextStyle(
                    color: subtitleBlue,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LEVEL MESSAGE
  // ============================================================

  String _levelMessage() {
    if (_learningLevel == 'Advanced') {
      return 'Your assessment indicates advanced competency. Your roadmap will focus on specialization, advanced projects and career readiness.';
    }

    if (_learningLevel == 'Intermediate') {
      return 'Your assessment indicates intermediate competency. Your roadmap will strengthen core skills and progressively move you toward specialization.';
    }

    return 'Your assessment indicates beginner competency. Your roadmap will start with foundations and gradually build the skills required for your target career.';
  }

  // ============================================================
  // ROADMAP STAGE
  // ============================================================

  Widget _buildRoadmapStage(
    RoadmapStage stage,
    int index,
    bool isLast,
  ) {
    final Color stageColor;

    if (stage.completed) {
      stageColor = successGreen;
    } else if (stage.current) {
      stageColor = brandRed;
    } else {
      stageColor = Colors.grey;
    }

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        // ======================================================
        // TIMELINE
        // ======================================================

        SizedBox(
          width: 45,

          child: Column(
            children: [

              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: stageColor
                      .withValues(alpha: 0.12),

                  shape: BoxShape.circle,

                  border: Border.all(
                    color: stageColor,
                    width: 2,
                  ),
                ),

                child: Icon(
                  stage.completed
                      ? Icons.check_rounded
                      : stage.current
                          ? Icons.play_arrow_rounded
                          : Icons.lock_outline_rounded,
                  color: stageColor,
                  size: 23,
                ),
              ),

              if (!isLast)
                Container(
                  width: 2,
                  height: 105,
                  color: stage.completed
                      ? successGreen
                      : Colors.grey.shade300,
                ),
            ],
          ),
        ),

        const SizedBox(width: 15),

        // ======================================================
        // STAGE CARD
        // ======================================================

        Expanded(
          child: Container(
            margin:
                const EdgeInsets.only(bottom: 18),

            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: stage.current
                  ? lightRed
                  : Colors.white,

              borderRadius:
                  BorderRadius.circular(20),

              border: Border.all(
                color: stage.current
                    ? brandRed
                    : Colors.grey.shade200,

                width: stage.current
                    ? 1.4
                    : 1,
              ),
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Row(
                  children: [

                    Expanded(
                      child: Text(
                        'Stage ${index + 1}: ${stage.title}',
                        style: TextStyle(
                          color: navy,
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w800,

                          decoration:
                              stage.completed
                                  ? TextDecoration
                                      .lineThrough
                                  : null,
                        ),
                      ),
                    ),

                    if (stage.completed)
                      const Text(
                        'Completed',
                        style: TextStyle(
                          color: successGreen,
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      )
                    else if (stage.current)
                      const Text(
                        'Current',
                        style: TextStyle(
                          color: brandRed,
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      )
                    else
                      const Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.grey,
                        size: 18,
                      ),
                  ],
                ),

                const SizedBox(height: 7),

                Text(
                  stage.description,
                  style: const TextStyle(
                    color: subtitleBlue,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 7,
                  runSpacing: 7,

                  children:
                      stage.skills.map(
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
                          color: Colors.grey
                              .shade100,

                          borderRadius:
                              BorderRadius
                                  .circular(
                            12,
                          ),
                        ),

                        child: Text(
                          skill,
                          style:
                              const TextStyle(
                            color: navy,
                            fontSize: 11,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// ROADMAP MODEL
// ============================================================

class RoadmapStage {
  final String title;
  final String description;
  final List<String> skills;
  final IconData icon;
  final bool completed;
  final bool current;

  const RoadmapStage({
    required this.title,
    required this.description,
    required this.skills,
    required this.icon,
    required this.completed,
    required this.current,
  });
}