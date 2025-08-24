import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/logging/app_logger.dart';
import '../../domain/entities/islamic_university_entity.dart';
import '../secure_storage/secure_storage_service.dart';
import '../subscription/subscription_service.dart';

/// Islamic Knowledge University Service - Premier Islamic Learning Platform
class IslamicUniversityService {
  static IslamicUniversityService? _instance;
  static IslamicUniversityService get instance => _instance ??= IslamicUniversityService._();

  IslamicUniversityService._();

  // Core dependencies
  late SharedPreferences _prefs;
  late SecureStorageService _secureStorage;
  late SubscriptionService _subscriptionService;

  // Service state
  bool _isInitialized = false;
  List<IslamicScholar> _scholars = [];
  List<PremiumCourse> _courses = [];
  List<IslamicLearningPath> _learningPaths = [];
  PersonalizedCurriculum? _userCurriculum;

  // Stream controllers for real-time updates
  final _progressController = StreamController<LearningProgress>.broadcast();
  final _certificateController = StreamController<IslamicCertificate>.broadcast();
  final _liveSessionController = StreamController<List<LiveQASession>>.broadcast();
  final _analyticsController = StreamController<LearningAnalytics>.broadcast();

  // Public streams
  Stream<LearningProgress> get progressStream => _progressController.stream;
  Stream<IslamicCertificate> get certificateStream => _certificateController.stream;
  Stream<List<LiveQASession>> get liveSessionStream => _liveSessionController.stream;
  Stream<LearningAnalytics> get analyticsStream => _analyticsController.stream;

  /// Initialize the Islamic University service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('Initializing Islamic University Service...');

      // Initialize dependencies
      _prefs = await SharedPreferences.getInstance();
      _secureStorage = SecureStorageService.instance;
      _subscriptionService = SubscriptionService.instance;

      // Load scholars, courses, and learning paths
      await _loadScholarsData();
      await _loadCoursesData();
      await _loadLearningPathsData();

      // Load user's personalized curriculum
      await _loadUserCurriculum();

      _isInitialized = true;
      AppLogger.info('Islamic University Service initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize Islamic University Service: $e');
      throw Exception('Islamic University Service initialization failed');
    }
  }

  /// Validate premium subscription for advanced learning features
  Future<void> _validatePremiumAccess() async {
    final hasSubscription = _subscriptionService.hasActiveSubscription;
    if (!hasSubscription) {
      throw Exception('Premium subscription required for Islamic University access');
    }
  }

  /// Load verified Islamic scholars data
  Future<void> _loadScholarsData() async {
    try {
      _scholars = _getVerifiedScholars();
      AppLogger.info('Loaded ${_scholars.length} verified Islamic scholars');
    } catch (e) {
      AppLogger.error('Failed to load scholars data: $e');
      _scholars = [];
    }
  }

  /// Get verified Islamic scholars with authentication
  List<IslamicScholar> _getVerifiedScholars() {
    final now = DateTime.now();
    return [
      IslamicScholar(
        id: 'scholar_yasir_qadhi',
        name: 'Dr. Yasir Qadhi',
        arabicName: 'د. ياسر قاضي',
        title: 'Dean of Academic Affairs',
        institution: 'Islamic Seminary of America',
        country: 'United States',
        specialization: 'Islamic Theology and History',
        biography:
            'Dr. Yasir Qadhi is a renowned Islamic scholar and educator with expertise in Islamic theology, history, and contemporary issues.',
        arabicBiography:
            'الدكتور ياسر قاضي عالم إسلامي مشهور ومربي له خبرة في اللاهوت الإسلامي والتاريخ والقضايا المعاصرة',
        isVerified: true,
        profileImageUrl: 'https://secure-cdn.duacopilot.com/scholars/yasir_qadhi.jpg',
        credentials: ['PhD in Islamic Studies - Yale University', 'BA in Islamic Studies - University of Medina'],
        languages: ['English', 'Arabic', 'Urdu'],
        subjects: ['Aqeedah', 'Seerah', 'Contemporary Islamic Issues'],
        rating: 4.9,
        totalStudents: 15000,
        coursesCount: 25,
        sessionsCount: 150,
        verifiedAt: now.subtract(const Duration(days: 365)),
        createdAt: now.subtract(const Duration(days: 800)),
      ),
      IslamicScholar(
        id: 'scholar_omar_suleiman',
        name: 'Dr. Omar Suleiman',
        arabicName: 'د. عمر سليمان',
        title: 'Imam and Islamic Scholar',
        institution: 'Yaqeen Institute',
        country: 'United States',
        specialization: 'Islamic Spirituality and Social Justice',
        biography:
            'Dr. Omar Suleiman is a prominent Islamic scholar known for his work in spirituality, social justice, and contemporary Islamic thought.',
        arabicBiography:
            'الدكتور عمر سليمان عالم إسلامي بارز معروف بعمله في الروحانية والعدالة الاجتماعية والفكر الإسلامي المعاصر',
        isVerified: true,
        profileImageUrl: 'https://secure-cdn.duacopilot.com/scholars/omar_suleiman.jpg',
        credentials: ['PhD in Islamic Studies', 'Masters in Islamic Finance'],
        languages: ['English', 'Arabic'],
        subjects: ['Spirituality', 'Social Justice', 'Islamic Ethics'],
        rating: 4.95,
        totalStudents: 12000,
        coursesCount: 18,
        sessionsCount: 120,
        verifiedAt: now.subtract(const Duration(days: 300)),
        createdAt: now.subtract(const Duration(days: 700)),
      ),
      IslamicScholar(
        id: 'scholar_nouman_ali_khan',
        name: 'Nouman Ali Khan',
        arabicName: 'نعمان علي خان',
        title: 'Arabic and Quranic Studies Expert',
        institution: 'Bayyinah Institute',
        country: 'United States',
        specialization: 'Arabic Language and Quranic Exegesis',
        biography:
            'Nouman Ali Khan is a renowned expert in Arabic language and Quranic studies, known for making Arabic accessible to English speakers.',
        arabicBiography:
            'نعمان علي خان خبير مشهور في اللغة العربية والدراسات القرآنية، معروف بجعل العربية متاحة للناطقين بالإنجليزية',
        isVerified: true,
        profileImageUrl: 'https://secure-cdn.duacopilot.com/scholars/nouman_ali_khan.jpg',
        credentials: ['Arabic Language Expert', 'Quranic Studies Specialist'],
        languages: ['English', 'Arabic', 'Urdu'],
        subjects: ['Arabic Language', 'Quran', 'Tajweed'],
        rating: 4.92,
        totalStudents: 25000,
        coursesCount: 30,
        sessionsCount: 200,
        verifiedAt: now.subtract(const Duration(days: 400)),
        createdAt: now.subtract(const Duration(days: 900)),
      ),
    ];
  }

  /// Load premium course catalog
  Future<void> _loadCoursesData() async {
    try {
      _courses = _getPremiumCourses();
      AppLogger.info('Loaded ${_courses.length} premium courses');
    } catch (e) {
      AppLogger.error('Failed to load courses data: $e');
      _courses = [];
    }
  }

  /// Get premium course catalog
  List<PremiumCourse> _getPremiumCourses() {
    final now = DateTime.now();
    return [
      PremiumCourse(
        id: 'course_arabic_foundations',
        title: 'Arabic Language Foundations',
        arabicTitle: 'أسس اللغة العربية',
        description: 'Master the fundamentals of Arabic language for Quranic understanding',
        shortDescription: 'Learn Arabic from scratch with expert guidance',
        scholarId: 'scholar_nouman_ali_khan',
        category: CourseCategory.arabic,
        level: LearningLevel.beginner,
        lessonIds: ['lesson_01', 'lesson_02', 'lesson_03'],
        duration: 1200, // 20 hours
        price: 199.99,
        isPremium: true,
        isPublished: true,
        tags: ['arabic', 'foundation', 'beginner'],
        languages: ['English', 'Arabic'],
        coverImageUrl: 'https://secure-cdn.duacopilot.com/courses/arabic_foundations.jpg',
        rating: 4.8,
        reviewsCount: 1250,
        enrolledCount: 8500,
        completionCount: 6200,
        averageCompletionTime: Duration(days: 45),
        requiresAuthentication: true,
        certificateType: CertificationType.completion,
        publishedAt: now.subtract(const Duration(days: 180)),
        createdAt: now.subtract(const Duration(days: 200)),
      ),
      PremiumCourse(
        id: 'course_aqeedah_mastery',
        title: 'Islamic Creed Mastery',
        arabicTitle: 'إتقان العقيدة الإسلامية',
        description: 'Comprehensive study of Islamic beliefs and theology',
        shortDescription: 'Deep dive into Islamic creed and beliefs',
        scholarId: 'scholar_yasir_qadhi',
        category: CourseCategory.aqeedah,
        level: LearningLevel.intermediate,
        lessonIds: ['lesson_aq_01', 'lesson_aq_02', 'lesson_aq_03'],
        duration: 1800, // 30 hours
        price: 299.99,
        discountPrice: 199.99,
        isPremium: true,
        isPublished: true,
        tags: ['aqeedah', 'theology', 'beliefs'],
        languages: ['English'],
        coverImageUrl: 'https://secure-cdn.duacopilot.com/courses/aqeedah_mastery.jpg',
        rating: 4.95,
        reviewsCount: 890,
        enrolledCount: 5200,
        completionCount: 3800,
        averageCompletionTime: Duration(days: 60),
        requiresAuthentication: true,
        certificateType: CertificationType.proficiency,
        publishedAt: now.subtract(const Duration(days: 120)),
        createdAt: now.subtract(const Duration(days: 150)),
      ),
      PremiumCourse(
        id: 'course_spiritual_development',
        title: 'Islamic Spiritual Development',
        arabicTitle: 'التطوير الروحي الإسلامي',
        description: 'Journey of spiritual growth through Islamic practices',
        shortDescription: 'Develop your Islamic spirituality',
        scholarId: 'scholar_omar_suleiman',
        category: CourseCategory.spirituality,
        level: LearningLevel.beginner,
        lessonIds: ['lesson_sp_01', 'lesson_sp_02', 'lesson_sp_03'],
        duration: 900, // 15 hours
        price: 149.99,
        isPremium: true,
        isPublished: true,
        tags: ['spirituality', 'growth', 'practice'],
        languages: ['English'],
        coverImageUrl: 'https://secure-cdn.duacopilot.com/courses/spiritual_development.jpg',
        rating: 4.9,
        reviewsCount: 1100,
        enrolledCount: 7200,
        completionCount: 5800,
        averageCompletionTime: Duration(days: 30),
        requiresAuthentication: true,
        certificateType: CertificationType.completion,
        publishedAt: now.subtract(const Duration(days: 90)),
        createdAt: now.subtract(const Duration(days: 120)),
      ),
    ];
  }

  /// Load structured learning paths
  Future<void> _loadLearningPathsData() async {
    try {
      _learningPaths = _getLearningPaths();
      AppLogger.info('Loaded ${_learningPaths.length} learning paths');
    } catch (e) {
      AppLogger.error('Failed to load learning paths: $e');
      _learningPaths = [];
    }
  }

  /// Get structured learning paths
  List<IslamicLearningPath> _getLearningPaths() {
    final now = DateTime.now();
    return [
      IslamicLearningPath(
        id: 'path_islamic_foundations',
        title: 'Islamic Knowledge Foundations',
        description: 'Complete beginner-friendly introduction to Islamic knowledge',
        level: LearningLevel.beginner,
        courseIds: ['course_aqeedah_mastery', 'course_spiritual_development'],
        estimatedHours: 45,
        skills: ['Basic Islamic Knowledge', 'Spiritual Practice', 'Prayer Understanding'],
        tags: ['foundations', 'beginner', 'comprehensive'],
        coverImageUrl: 'https://secure-cdn.duacopilot.com/paths/foundations.jpg',
        isPremium: true,
        rating: 4.8,
        enrolledCount: 3500,
        createdAt: now.subtract(const Duration(days: 100)),
      ),
      IslamicLearningPath(
        id: 'path_arabic_quran',
        title: 'Arabic for Quran Understanding',
        description: 'Master Arabic to understand Quran directly',
        level: LearningLevel.intermediate,
        courseIds: ['course_arabic_foundations'],
        estimatedHours: 60,
        prerequisites: ['Basic Islamic Knowledge'],
        skills: ['Arabic Reading', 'Quranic Vocabulary', 'Grammar Basics'],
        tags: ['arabic', 'quran', 'language'],
        coverImageUrl: 'https://secure-cdn.duacopilot.com/paths/arabic_quran.jpg',
        isPremium: true,
        rating: 4.9,
        enrolledCount: 2800,
        createdAt: now.subtract(const Duration(days: 80)),
      ),
    ];
  }

  /// Load user's personalized curriculum
  Future<void> _loadUserCurriculum() async {
    try {
      final curriculumJson = await _secureStorage.read('personalized_curriculum');
      if (curriculumJson != null) {
        final Map<String, dynamic> json = jsonDecode(curriculumJson);
        _userCurriculum = PersonalizedCurriculum.fromJson(json);
      }
    } catch (e) {
      AppLogger.error('Failed to load user curriculum: $e');
    }
  }

  /// Get all verified Islamic scholars
  List<IslamicScholar> getScholars() {
    return List.unmodifiable(_scholars);
  }

  /// Get scholar by ID
  IslamicScholar? getScholarById(String scholarId) {
    try {
      return _scholars.firstWhere((scholar) => scholar.id == scholarId);
    } catch (e) {
      return null;
    }
  }

  /// Get all premium courses
  Future<List<PremiumCourse>> getCourses() async {
    await _validatePremiumAccess();
    return List.unmodifiable(_courses);
  }

  /// Get courses by category
  Future<List<PremiumCourse>> getCoursesByCategory(CourseCategory category) async {
    await _validatePremiumAccess();
    return _courses.where((course) => course.category == category).toList();
  }

  /// Get courses by level
  Future<List<PremiumCourse>> getCoursesByLevel(LearningLevel level) async {
    await _validatePremiumAccess();
    return _courses.where((course) => course.level == level).toList();
  }

  /// Get courses by scholar
  Future<List<PremiumCourse>> getCoursesByScholar(String scholarId) async {
    await _validatePremiumAccess();
    return _courses.where((course) => course.scholarId == scholarId).toList();
  }

  /// Get all learning paths
  Future<List<IslamicLearningPath>> getLearningPaths() async {
    await _validatePremiumAccess();
    return List.unmodifiable(_learningPaths);
  }

  /// Enroll in a premium course
  Future<bool> enrollInCourse(String courseId) async {
    await _validatePremiumAccess();

    try {
      final course = _courses.firstWhere((c) => c.id == courseId);
      final userId = await _secureStorage.getUserId() ?? 'anonymous';

      // Create enrollment record
      final enrollment = {
        'userId': userId,
        'courseId': courseId,
        'enrolledAt': DateTime.now().toIso8601String(),
        'progress': 0.0,
        'status': 'active',
      };

      // Save enrollment
      final enrollmentsJson = await _secureStorage.read('course_enrollments') ?? '[]';
      final List<dynamic> enrollments = jsonDecode(enrollmentsJson);
      enrollments.add(enrollment);

      await _secureStorage.write('course_enrollments', jsonEncode(enrollments));

      AppLogger.info('Successfully enrolled in course: ${course.title}');
      return true;
    } catch (e) {
      AppLogger.error('Failed to enroll in course $courseId: $e');
      return false;
    }
  }

  /// Get user's enrolled courses
  Future<List<PremiumCourse>> getEnrolledCourses() async {
    await _validatePremiumAccess();

    try {
      final userId = await _secureStorage.getUserId() ?? 'anonymous';
      final enrollmentsJson = await _secureStorage.read('course_enrollments') ?? '[]';
      final List<dynamic> enrollments = jsonDecode(enrollmentsJson);

      final userEnrollments =
          enrollments.where((e) => e['userId'] == userId).map((e) => e['courseId'] as String).toList();

      return _courses.where((course) => userEnrollments.contains(course.id)).toList();
    } catch (e) {
      AppLogger.error('Failed to get enrolled courses: $e');
      return [];
    }
  }

  /// Create personalized curriculum based on user interests
  Future<PersonalizedCurriculum> createPersonalizedCurriculum({
    required List<String> interests,
    required LearningLevel currentLevel,
    required LearningLevel targetLevel,
    Duration dailyGoal = const Duration(hours: 1),
  }) async {
    await _validatePremiumAccess();

    try {
      final userId = await _secureStorage.getUserId() ?? 'anonymous';

      // Generate AI-recommended courses based on interests
      final recommendedCourses = _generateCourseRecommendations(interests, currentLevel);
      final recommendedPaths = _generatePathRecommendations(interests, currentLevel);

      final curriculum = PersonalizedCurriculum(
        id: 'curriculum_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        title: 'My Islamic Learning Journey',
        interests: interests,
        currentLevel: currentLevel,
        targetLevel: targetLevel,
        pathIds: recommendedPaths,
        courseIds: recommendedCourses,
        dailyGoal: dailyGoal,
        goals: _generateStudyGoals(targetLevel, dailyGoal),
        createdAt: DateTime.now(),
      );

      // Save curriculum
      await _saveCurriculum(curriculum);
      _userCurriculum = curriculum;

      AppLogger.info('Created personalized curriculum for user');
      return curriculum;
    } catch (e) {
      AppLogger.error('Failed to create personalized curriculum: $e');
      rethrow;
    }
  }

  /// Generate course recommendations based on interests
  List<String> _generateCourseRecommendations(List<String> interests, LearningLevel level) {
    final recommendations = <String>[];

    for (final interest in interests) {
      final matchingCourses =
          _courses
              .where(
                (course) =>
                    course.tags.any((tag) => tag.toLowerCase().contains(interest.toLowerCase())) &&
                    _isLevelAppropriate(course.level, level),
              )
              .take(2)
              .map((c) => c.id)
              .toList();

      recommendations.addAll(matchingCourses);
    }

    return recommendations.take(5).toList();
  }

  /// Generate learning path recommendations
  List<String> _generatePathRecommendations(List<String> interests, LearningLevel level) {
    return _learningPaths
        .where(
          (path) =>
              path.level == level &&
              path.tags.any((tag) => interests.any((interest) => tag.toLowerCase().contains(interest.toLowerCase()))),
        )
        .take(2)
        .map((p) => p.id)
        .toList();
  }

  /// Check if course level is appropriate for user level
  bool _isLevelAppropriate(LearningLevel courseLevel, LearningLevel userLevel) {
    final levels = LearningLevel.values;
    final courseIndex = levels.indexOf(courseLevel);
    final userIndex = levels.indexOf(userLevel);

    // Allow courses at same level or one level higher
    return courseIndex <= userIndex + 1;
  }

  /// Generate study goals based on target level and daily goal
  List<StudyGoal> _generateStudyGoals(LearningLevel targetLevel, Duration dailyGoal) {
    return [
      StudyGoal(
        id: 'goal_daily_study',
        title: 'Daily Study Goal',
        type: GoalType.dailyStudyTime,
        targetValue: dailyGoal.inMinutes,
        currentValue: 0,
        deadline: DateTime.now().add(const Duration(days: 1)),
      ),
      StudyGoal(
        id: 'goal_weekly_lessons',
        title: 'Weekly Lessons',
        type: GoalType.weeklyLessons,
        targetValue: 5,
        currentValue: 0,
        deadline: DateTime.now().add(const Duration(days: 7)),
      ),
      StudyGoal(
        id: 'goal_course_completion',
        title: 'Complete First Course',
        type: GoalType.courseCompletion,
        targetValue: 1,
        currentValue: 0,
        deadline: DateTime.now().add(const Duration(days: 30)),
      ),
    ];
  }

  /// Save curriculum to secure storage
  Future<void> _saveCurriculum(PersonalizedCurriculum curriculum) async {
    try {
      final json = curriculum.toJson();
      await _secureStorage.write('personalized_curriculum', jsonEncode(json));
    } catch (e) {
      AppLogger.error('Failed to save curriculum: $e');
      rethrow;
    }
  }

  /// Get user's personalized curriculum
  PersonalizedCurriculum? getUserCurriculum() {
    return _userCurriculum;
  }

  /// Update learning progress
  Future<void> updateProgress({
    required String itemId,
    required ProgressType type,
    required double progress,
    int timeSpent = 0,
  }) async {
    try {
      final userId = await _secureStorage.getUserId() ?? 'anonymous';

      final progressRecord = LearningProgress(
        userId: userId,
        itemId: itemId,
        type: type,
        progress: progress.clamp(0.0, 1.0),
        timeSpent: timeSpent,
        attempts: 1,
        lastActivityAt: DateTime.now(),
        startedAt: DateTime.now(), // In real app, track actual start time
        completedAt: progress >= 1.0 ? DateTime.now() : null,
      );

      // Save progress
      await _saveProgress(progressRecord);

      // Emit progress update
      _progressController.add(progressRecord);

      // Update analytics
      await _updateLearningAnalytics(progressRecord);

      // Check for goal achievements
      await _checkGoalAchievements(progressRecord);
    } catch (e) {
      AppLogger.error('Failed to update progress: $e');
    }
  }

  /// Save progress record
  Future<void> _saveProgress(LearningProgress progress) async {
    try {
      final progressJson = await _secureStorage.read('learning_progress') ?? '[]';
      final List<dynamic> progressList = jsonDecode(progressJson);

      // Remove existing progress for same item
      progressList.removeWhere(
        (p) => p['userId'] == progress.userId && p['itemId'] == progress.itemId && p['type'] == progress.type.name,
      );

      // Add new progress
      progressList.add(progress.toJson());

      await _secureStorage.write('learning_progress', jsonEncode(progressList));
    } catch (e) {
      AppLogger.error('Failed to save progress: $e');
    }
  }

  /// Update learning analytics
  Future<void> _updateLearningAnalytics(LearningProgress progress) async {
    try {
      final analytics = await _loadLearningAnalytics();

      var updatedAnalytics = analytics.copyWith(
        totalStudyTime: analytics.totalStudyTime + progress.timeSpent,
        lastStudyDate: DateTime.now(),
      );

      // Update specific counters based on progress type
      switch (progress.type) {
        case ProgressType.course:
          if (progress.progress >= 1.0) {
            updatedAnalytics = updatedAnalytics.copyWith(completedCourses: analytics.completedCourses + 1);
          }
          break;
        case ProgressType.lesson:
          if (progress.progress >= 1.0) {
            updatedAnalytics = updatedAnalytics.copyWith(completedLessons: analytics.completedLessons + 1);
          }
          break;
        case ProgressType.quiz:
          if (progress.progress >= 1.0) {
            updatedAnalytics = updatedAnalytics.copyWith(
              passedQuizzes: analytics.passedQuizzes + 1,
              averageQuizScore: (analytics.averageQuizScore + progress.bestScore) / 2,
            );
          }
          break;
        default:
          break;
      }

      await _saveLearningAnalytics(updatedAnalytics);
      _analyticsController.add(updatedAnalytics);
    } catch (e) {
      AppLogger.error('Failed to update learning analytics: $e');
    }
  }

  /// Load learning analytics
  Future<LearningAnalytics> _loadLearningAnalytics() async {
    try {
      final userId = await _secureStorage.getUserId() ?? 'anonymous';
      final analyticsJson = await _secureStorage.read('learning_analytics');

      if (analyticsJson != null) {
        return LearningAnalytics.fromJson(jsonDecode(analyticsJson));
      }

      return LearningAnalytics(userId: userId, firstStudyDate: DateTime.now(), updatedAt: DateTime.now());
    } catch (e) {
      AppLogger.error('Failed to load learning analytics: $e');

      final userId = await _secureStorage.getUserId() ?? 'anonymous';
      return LearningAnalytics(userId: userId, firstStudyDate: DateTime.now(), updatedAt: DateTime.now());
    }
  }

  /// Save learning analytics
  Future<void> _saveLearningAnalytics(LearningAnalytics analytics) async {
    try {
      final json = analytics.copyWith(updatedAt: DateTime.now()).toJson();
      await _secureStorage.write('learning_analytics', jsonEncode(json));
    } catch (e) {
      AppLogger.error('Failed to save learning analytics: $e');
    }
  }

  /// Check and update goal achievements
  Future<void> _checkGoalAchievements(LearningProgress progress) async {
    if (_userCurriculum == null) return;

    try {
      final updatedGoals = <StudyGoal>[];
      bool hasUpdates = false;

      for (final goal in _userCurriculum!.goals) {
        var updatedGoal = goal;

        // Update goal progress based on type
        switch (goal.type) {
          case GoalType.dailyStudyTime:
            if (!goal.isCompleted && progress.timeSpent > 0) {
              final newValue = goal.currentValue + progress.timeSpent;
              updatedGoal = goal.copyWith(
                currentValue: newValue,
                isCompleted: newValue >= goal.targetValue,
                completedAt: newValue >= goal.targetValue ? DateTime.now() : null,
              );
              hasUpdates = true;
            }
            break;
          case GoalType.courseCompletion:
            if (!goal.isCompleted && progress.type == ProgressType.course && progress.progress >= 1.0) {
              updatedGoal = goal.copyWith(
                currentValue: goal.currentValue + 1,
                isCompleted: true,
                completedAt: DateTime.now(),
              );
              hasUpdates = true;
            }
            break;
          default:
            break;
        }

        updatedGoals.add(updatedGoal);
      }

      if (hasUpdates) {
        _userCurriculum = _userCurriculum!.copyWith(goals: updatedGoals);
        await _saveCurriculum(_userCurriculum!);
      }
    } catch (e) {
      AppLogger.error('Failed to check goal achievements: $e');
    }
  }

  /// Generate certificate for course completion
  Future<IslamicCertificate> generateCertificate({required String courseId, required double finalScore}) async {
    await _validatePremiumAccess();

    try {
      final userId = await _secureStorage.getUserId() ?? 'anonymous';
      final course = _courses.firstWhere((c) => c.id == courseId);
      final scholar = _scholars.firstWhere((s) => s.id == course.scholarId);

      // Generate certificate hash for blockchain verification
      final certificateData = '$userId:$courseId:$finalScore:${DateTime.now().millisecondsSinceEpoch}';
      final certificateHash = sha256.convert(utf8.encode(certificateData)).toString();
      final blockchainId = _generateBlockchainId(certificateHash);

      final certificate = IslamicCertificate(
        id: 'cert_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        courseId: courseId,
        title: 'Certificate of Completion - ${course.title}',
        issuingInstitution: 'DuaCopilot Islamic University',
        scholarName: scholar.name,
        issuedDate: DateTime.now(),
        type: course.certificateType,
        finalScore: finalScore,
        certificateHash: certificateHash,
        blockchainId: blockchainId,
        skillsEarned: _extractSkillsFromCourse(course),
      );

      // Save certificate
      await _saveCertificate(certificate);

      // Emit certificate event
      _certificateController.add(certificate);

      AppLogger.info('Generated certificate for course: ${course.title}');
      return certificate;
    } catch (e) {
      AppLogger.error('Failed to generate certificate: $e');
      rethrow;
    }
  }

  /// Generate blockchain ID for certificate verification
  String _generateBlockchainId(String hash) {
    // In production, this would interact with actual blockchain
    return 'bc_${hash.substring(0, 16)}';
  }

  /// Extract skills from course data
  List<String> _extractSkillsFromCourse(PremiumCourse course) {
    // Map course categories to skills
    switch (course.category) {
      case CourseCategory.arabic:
        return ['Arabic Reading', 'Arabic Grammar', 'Vocabulary'];
      case CourseCategory.aqeedah:
        return ['Islamic Theology', 'Core Beliefs', 'Doctrinal Understanding'];
      case CourseCategory.spirituality:
        return ['Spiritual Practice', 'Mindfulness', 'Inner Development'];
      default:
        return ['Islamic Knowledge', 'Religious Understanding'];
    }
  }

  /// Save certificate to secure storage
  Future<void> _saveCertificate(IslamicCertificate certificate) async {
    try {
      final certificatesJson = await _secureStorage.read('user_certificates') ?? '[]';
      final List<dynamic> certificates = jsonDecode(certificatesJson);
      certificates.add(certificate.toJson());
      await _secureStorage.write('user_certificates', jsonEncode(certificates));
    } catch (e) {
      AppLogger.error('Failed to save certificate: $e');
      rethrow;
    }
  }

  /// Get user's certificates
  Future<List<IslamicCertificate>> getUserCertificates() async {
    try {
      final userId = await _secureStorage.getUserId() ?? 'anonymous';
      final certificatesJson = await _secureStorage.read('user_certificates') ?? '[]';
      final List<dynamic> certificates = jsonDecode(certificatesJson);

      return certificates.where((c) => c['userId'] == userId).map((json) => IslamicCertificate.fromJson(json)).toList();
    } catch (e) {
      AppLogger.error('Failed to get user certificates: $e');
      return [];
    }
  }

  /// Get learning analytics for user
  Future<LearningAnalytics> getLearningAnalytics() async {
    return await _loadLearningAnalytics();
  }

  /// Dispose of resources
  Future<void> dispose() async {
    _progressController.close();
    _certificateController.close();
    _liveSessionController.close();
    _analyticsController.close();
  }
}
