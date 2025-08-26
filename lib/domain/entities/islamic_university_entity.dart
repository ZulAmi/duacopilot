import 'package:freezed_annotation/freezed_annotation.dart';

part 'islamic_university_entity.freezed.dart';
part 'islamic_university_entity.g.dart';

/// Islamic Scholar Profile with authentication
@freezed
class IslamicScholar with _$IslamicScholar {
  const factory IslamicScholar({
    required String id,
    required String name,
    required String arabicName,
    required String title,
    required String institution,
    required String country,
    required String specialization,
    required String biography,
    required String arabicBiography,
    required bool isVerified,
    required String profileImageUrl,
    @Default([]) List<String> credentials,
    @Default([]) List<String> languages,
    @Default([]) List<String> subjects,
    @Default(0.0) double rating,
    @Default(0) int totalStudents,
    @Default(0) int coursesCount,
    @Default(0) int sessionsCount,
    DateTime? birthDate,
    DateTime? verifiedAt,
    DateTime? createdAt,
  }) = _IslamicScholar;

  factory IslamicScholar.fromJson(Map<String, dynamic> json) =>
      _$IslamicScholarFromJson(json);
}

/// Learning Path for structured Islamic education
@freezed
class IslamicLearningPath with _$IslamicLearningPath {
  const factory IslamicLearningPath({
    required String id,
    required String title,
    required String description,
    required LearningLevel level,
    required List<String> courseIds,
    required int estimatedHours,
    @Default([]) List<String> prerequisites,
    @Default([]) List<String> skills,
    @Default([]) List<String> tags,
    String? coverImageUrl,
    @Default(false) bool isPremium,
    @Default(0.0) double rating,
    @Default(0) int enrolledCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _IslamicLearningPath;

  factory IslamicLearningPath.fromJson(Map<String, dynamic> json) =>
      _$IslamicLearningPathFromJson(json);
}

/// Learning levels for progressive education
enum LearningLevel {
  beginner('Beginner', '🌱'),
  intermediate('Intermediate', '🌿'),
  advanced('Advanced', '🌳'),
  scholar('Scholar', '📚');

  const LearningLevel(this.label, this.emoji);
  final String label;
  final String emoji;
}

/// Premium Islamic Course with security features
@freezed
class PremiumCourse with _$PremiumCourse {
  const factory PremiumCourse({
    required String id,
    required String title,
    required String arabicTitle,
    required String description,
    required String shortDescription,
    required String scholarId,
    required CourseCategory category,
    required LearningLevel level,
    required List<String> lessonIds,
    required int duration, // in minutes
    required double price,
    @Default(0.0) double discountPrice,
    @Default(false) bool isPremium,
    @Default(false) bool isPublished,
    @Default([]) List<String> tags,
    @Default([]) List<String> languages,
    String? coverImageUrl,
    String? previewVideoUrl,

    // Course metadata
    @Default(0.0) double rating,
    @Default(0) int reviewsCount,
    @Default(0) int enrolledCount,
    @Default(0) int completionCount,
    @Default(Duration.zero) Duration averageCompletionTime,

    // Security & DRM
    @Default(true) bool requiresAuthentication,
    @Default(false) bool allowDownload,
    @Default(CertificationType.completion) CertificationType certificateType,

    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PremiumCourse;

  factory PremiumCourse.fromJson(Map<String, dynamic> json) =>
      _$PremiumCourseFromJson(json);
}

/// Course categories for organization
enum CourseCategory {
  quran('Quran & Tajweed', '📖'),
  hadith('Hadith Studies', '📜'),
  fiqh('Fiqh & Jurisprudence', '⚖️'),
  aqeedah('Aqeedah & Beliefs', '🕌'),
  seerah('Seerah & History', '📚'),
  arabic('Arabic Language', '🔤'),
  spirituality('Spirituality & Tasawwuf', '💚'),
  family('Family & Marriage', '👪'),
  finance('Islamic Finance', '💰'),
  ethics('Ethics & Morals', '🤲');

  const CourseCategory(this.label, this.emoji);
  final String label;
  final String emoji;
}

/// Certificate types for achievements
enum CertificationType { completion, proficiency, mastery }

/// Course Lesson with multimedia content
@freezed
class CourseLesson with _$CourseLesson {
  const factory CourseLesson({
    required String id,
    required String courseId,
    required String title,
    required String description,
    required int orderIndex,
    required LessonType type,
    required int duration, // in minutes
    @Default(false) bool isFree,
    @Default(false) bool isLocked,

    // Content URLs with DRM protection
    String? videoUrl,
    String? audioUrl,
    String? documentUrl,
    @Default([]) List<String> attachments,

    // Interactive elements
    @Default([]) List<String> quizIds,
    @Default([]) List<String> exerciseIds,
    String? notesContent,

    // Progress tracking
    @Default(0) int viewCount,
    @Default(Duration.zero) Duration averageWatchTime,
    @Default(0.0) double completionRate,

    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CourseLesson;

  factory CourseLesson.fromJson(Map<String, dynamic> json) =>
      _$CourseLessonFromJson(json);
}

/// Lesson content types
enum LessonType { video, audio, text, interactive, quiz, live }

/// Interactive Quiz for Islamic knowledge testing
@freezed
class IslamicQuiz with _$IslamicQuiz {
  const factory IslamicQuiz({
    required String id,
    required String title,
    required String description,
    required QuizType type,
    required List<String> questionIds,
    required int timeLimit, // in minutes, 0 for no limit
    required int passingScore, // percentage
    @Default(1) int maxAttempts,
    @Default(false) bool shuffleQuestions,
    @Default(false) bool showCorrectAnswers,
    @Default(false) bool allowReview,

    // Gamification
    @Default(0) int points,
    @Default([]) List<String> badges,

    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _IslamicQuiz;

  factory IslamicQuiz.fromJson(Map<String, dynamic> json) =>
      _$IslamicQuizFromJson(json);
}

/// Quiz types for different assessments
enum QuizType { practice, assessment, certification, challenge }

/// Quiz Question with multiple formats
@freezed
class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required String id,
    required String quizId,
    required String question,
    required String arabicQuestion,
    required QuestionType type,
    required List<String> options,
    required List<int> correctAnswerIndices, // indices of correct options
    required int points,
    String? explanation,
    String? arabicExplanation,
    String? reference, // Quran/Hadith reference
    String? imageUrl,
    String? audioUrl,
    @Default(DifficultyLevel.medium) DifficultyLevel difficulty,
    @Default([]) List<String> tags,

    // Analytics
    @Default(0) int totalAttempts,
    @Default(0) int correctAttempts,
    @Default(0.0) double successRate,

    DateTime? createdAt,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}

/// Question types for varied assessment
enum QuestionType {
  multipleChoice,
  trueFalse,
  fillInTheBlank,
  shortAnswer,
  matching,
  ordering,
  arabicTranslation,
  quranicVerse,
}

/// Difficulty levels for progressive learning
enum DifficultyLevel { easy, medium, hard, expert }

/// Live Q&A Session with scholars
@freezed
class LiveQASession with _$LiveQASession {
  const factory LiveQASession({
    required String id,
    required String title,
    required String description,
    required String scholarId,
    required DateTime scheduledStart,
    required Duration duration,
    required SessionStatus status,
    @Default(100) int maxParticipants,
    @Default(0) int currentParticipants,
    @Default([]) List<String> topics,
    @Default([]) List<String> languages,

    // Session URLs (encrypted)
    String? streamUrl,
    String? chatRoomId,
    String? recordingUrl,

    // Registration & Access
    @Default(false) bool requiresRegistration,
    @Default(false) bool isPremiumOnly,
    @Default(0.0) double price,

    // Moderation
    @Default(true) bool moderationEnabled,
    @Default([]) List<String> moderatorIds,
    @Default(true) bool allowAnonymousQuestions,

    DateTime? actualStart,
    DateTime? actualEnd,
    DateTime? createdAt,
  }) = _LiveQASession;

  factory LiveQASession.fromJson(Map<String, dynamic> json) =>
      _$LiveQASessionFromJson(json);
}

/// Session status tracking
enum SessionStatus { scheduled, starting, live, ended, cancelled, recorded }

/// User's personalized curriculum
@freezed
class PersonalizedCurriculum with _$PersonalizedCurriculum {
  const factory PersonalizedCurriculum({
    required String id,
    required String userId,
    required String title,
    required List<String> interests,
    required LearningLevel currentLevel,
    required LearningLevel targetLevel,
    required List<String> pathIds,
    required List<String> courseIds,
    @Default(Duration(hours: 1)) Duration dailyGoal,
    @Default([]) List<StudyGoal> goals,
    @Default(CurriculumStatus.active) CurriculumStatus status,

    // Progress tracking
    @Default(0.0) double overallProgress,
    @Default(0) int completedCourses,
    @Default(0) int totalStudyTime, // in minutes
    @Default(0) int streakDays,
    DateTime? lastStudyDate,

    // AI-generated recommendations
    @Default([]) List<String> recommendedCourses,
    @Default([]) List<String> recommendedScholars,
    DateTime? lastRecommendationUpdate,

    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PersonalizedCurriculum;

  factory PersonalizedCurriculum.fromJson(Map<String, dynamic> json) =>
      _$PersonalizedCurriculumFromJson(json);
}

/// Study goals for motivation
@freezed
class StudyGoal with _$StudyGoal {
  const factory StudyGoal({
    required String id,
    required String title,
    required GoalType type,
    required int targetValue,
    required int currentValue,
    required DateTime deadline,
    @Default(false) bool isCompleted,
    String? reward,
    DateTime? completedAt,
  }) = _StudyGoal;

  factory StudyGoal.fromJson(Map<String, dynamic> json) =>
      _$StudyGoalFromJson(json);
}

/// Types of study goals
enum GoalType {
  dailyStudyTime,
  weeklyLessons,
  monthlyQuizzes,
  courseCompletion,
  certificateEarned,
  streakMaintained,
}

/// Curriculum status
enum CurriculumStatus { active, paused, completed, archived }

/// Certificate earned by user
@freezed
class IslamicCertificate with _$IslamicCertificate {
  const factory IslamicCertificate({
    required String id,
    required String userId,
    required String courseId,
    required String title,
    required String issuingInstitution,
    required String scholarName,
    required DateTime issuedDate,
    required CertificationType type,
    required double finalScore,

    // Verification
    required String certificateHash,
    required String blockchainId, // For tamper-proof verification
    @Default(true) bool isVerifiable,

    // Design & Download
    String? templateUrl,
    String? downloadUrl,
    @Default([]) List<String> skillsEarned,

    // Sharing & Privacy
    @Default(false) bool isPublic,
    @Default(true) bool allowSharing,

    DateTime? expiryDate,
    DateTime? lastVerified,
  }) = _IslamicCertificate;

  factory IslamicCertificate.fromJson(Map<String, dynamic> json) =>
      _$IslamicCertificateFromJson(json);
}

/// User learning progress tracking
@freezed
class LearningProgress with _$LearningProgress {
  const factory LearningProgress({
    required String userId,
    required String itemId, // courseId, lessonId, or quizId
    required ProgressType type,
    required double progress, // 0.0 to 1.0
    @Default(0) int timeSpent, // in minutes
    @Default(0) int attempts,
    @Default(0.0) double bestScore,
    @Default([]) List<String> completedSections,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? lastActivityAt,
  }) = _LearningProgress;

  factory LearningProgress.fromJson(Map<String, dynamic> json) =>
      _$LearningProgressFromJson(json);
}

/// Progress tracking types
enum ProgressType { course, lesson, quiz, path, goal }

/// Learning analytics for insights
@freezed
class LearningAnalytics with _$LearningAnalytics {
  const factory LearningAnalytics({
    required String userId,
    @Default(0) int totalCourses,
    @Default(0) int completedCourses,
    @Default(0) int totalLessons,
    @Default(0) int completedLessons,
    @Default(0) int totalQuizzes,
    @Default(0) int passedQuizzes,
    @Default(0) int certificatesEarned,
    @Default(0) int studyStreak,
    @Default(0) int longestStreak,
    @Default(0) int totalStudyTime, // in minutes
    @Default(0.0) double averageQuizScore,
    @Default({}) Map<CourseCategory, int> categoryProgress,
    @Default({}) Map<String, int> scholarInteractions,
    @Default([]) List<String> favoriteTopics,
    DateTime? firstStudyDate,
    DateTime? lastStudyDate,
    DateTime? updatedAt,
  }) = _LearningAnalytics;

  factory LearningAnalytics.fromJson(Map<String, dynamic> json) =>
      _$LearningAnalyticsFromJson(json);
}
