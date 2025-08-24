// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'islamic_university_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IslamicScholarImpl _$$IslamicScholarImplFromJson(
  Map<String, dynamic> json,
) => _$IslamicScholarImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  arabicName: json['arabicName'] as String,
  title: json['title'] as String,
  institution: json['institution'] as String,
  country: json['country'] as String,
  specialization: json['specialization'] as String,
  biography: json['biography'] as String,
  arabicBiography: json['arabicBiography'] as String,
  isVerified: json['isVerified'] as bool,
  profileImageUrl: json['profileImageUrl'] as String,
  credentials:
      (json['credentials'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  languages:
      (json['languages'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  subjects:
      (json['subjects'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  totalStudents: (json['totalStudents'] as num?)?.toInt() ?? 0,
  coursesCount: (json['coursesCount'] as num?)?.toInt() ?? 0,
  sessionsCount: (json['sessionsCount'] as num?)?.toInt() ?? 0,
  birthDate:
      json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
  verifiedAt:
      json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$IslamicScholarImplToJson(
  _$IslamicScholarImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'arabicName': instance.arabicName,
  'title': instance.title,
  'institution': instance.institution,
  'country': instance.country,
  'specialization': instance.specialization,
  'biography': instance.biography,
  'arabicBiography': instance.arabicBiography,
  'isVerified': instance.isVerified,
  'profileImageUrl': instance.profileImageUrl,
  'credentials': instance.credentials,
  'languages': instance.languages,
  'subjects': instance.subjects,
  'rating': instance.rating,
  'totalStudents': instance.totalStudents,
  'coursesCount': instance.coursesCount,
  'sessionsCount': instance.sessionsCount,
  'birthDate': instance.birthDate?.toIso8601String(),
  'verifiedAt': instance.verifiedAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
};

_$IslamicLearningPathImpl _$$IslamicLearningPathImplFromJson(
  Map<String, dynamic> json,
) => _$IslamicLearningPathImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  level: $enumDecode(_$LearningLevelEnumMap, json['level']),
  courseIds:
      (json['courseIds'] as List<dynamic>).map((e) => e as String).toList(),
  estimatedHours: (json['estimatedHours'] as num).toInt(),
  prerequisites:
      (json['prerequisites'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  skills:
      (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  coverImageUrl: json['coverImageUrl'] as String?,
  isPremium: json['isPremium'] as bool? ?? false,
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  enrolledCount: (json['enrolledCount'] as num?)?.toInt() ?? 0,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$IslamicLearningPathImplToJson(
  _$IslamicLearningPathImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'level': _$LearningLevelEnumMap[instance.level]!,
  'courseIds': instance.courseIds,
  'estimatedHours': instance.estimatedHours,
  'prerequisites': instance.prerequisites,
  'skills': instance.skills,
  'tags': instance.tags,
  'coverImageUrl': instance.coverImageUrl,
  'isPremium': instance.isPremium,
  'rating': instance.rating,
  'enrolledCount': instance.enrolledCount,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$LearningLevelEnumMap = {
  LearningLevel.beginner: 'beginner',
  LearningLevel.intermediate: 'intermediate',
  LearningLevel.advanced: 'advanced',
  LearningLevel.scholar: 'scholar',
};

_$PremiumCourseImpl _$$PremiumCourseImplFromJson(Map<String, dynamic> json) =>
    _$PremiumCourseImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      arabicTitle: json['arabicTitle'] as String,
      description: json['description'] as String,
      shortDescription: json['shortDescription'] as String,
      scholarId: json['scholarId'] as String,
      category: $enumDecode(_$CourseCategoryEnumMap, json['category']),
      level: $enumDecode(_$LearningLevelEnumMap, json['level']),
      lessonIds:
          (json['lessonIds'] as List<dynamic>).map((e) => e as String).toList(),
      duration: (json['duration'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discountPrice'] as num?)?.toDouble() ?? 0.0,
      isPremium: json['isPremium'] as bool? ?? false,
      isPublished: json['isPublished'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      languages:
          (json['languages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      coverImageUrl: json['coverImageUrl'] as String?,
      previewVideoUrl: json['previewVideoUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
      enrolledCount: (json['enrolledCount'] as num?)?.toInt() ?? 0,
      completionCount: (json['completionCount'] as num?)?.toInt() ?? 0,
      averageCompletionTime:
          json['averageCompletionTime'] == null
              ? Duration.zero
              : Duration(
                microseconds: (json['averageCompletionTime'] as num).toInt(),
              ),
      requiresAuthentication: json['requiresAuthentication'] as bool? ?? true,
      allowDownload: json['allowDownload'] as bool? ?? false,
      certificateType:
          $enumDecodeNullable(
            _$CertificationTypeEnumMap,
            json['certificateType'],
          ) ??
          CertificationType.completion,
      publishedAt:
          json['publishedAt'] == null
              ? null
              : DateTime.parse(json['publishedAt'] as String),
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PremiumCourseImplToJson(_$PremiumCourseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'arabicTitle': instance.arabicTitle,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'scholarId': instance.scholarId,
      'category': _$CourseCategoryEnumMap[instance.category]!,
      'level': _$LearningLevelEnumMap[instance.level]!,
      'lessonIds': instance.lessonIds,
      'duration': instance.duration,
      'price': instance.price,
      'discountPrice': instance.discountPrice,
      'isPremium': instance.isPremium,
      'isPublished': instance.isPublished,
      'tags': instance.tags,
      'languages': instance.languages,
      'coverImageUrl': instance.coverImageUrl,
      'previewVideoUrl': instance.previewVideoUrl,
      'rating': instance.rating,
      'reviewsCount': instance.reviewsCount,
      'enrolledCount': instance.enrolledCount,
      'completionCount': instance.completionCount,
      'averageCompletionTime': instance.averageCompletionTime.inMicroseconds,
      'requiresAuthentication': instance.requiresAuthentication,
      'allowDownload': instance.allowDownload,
      'certificateType': _$CertificationTypeEnumMap[instance.certificateType]!,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$CourseCategoryEnumMap = {
  CourseCategory.quran: 'quran',
  CourseCategory.hadith: 'hadith',
  CourseCategory.fiqh: 'fiqh',
  CourseCategory.aqeedah: 'aqeedah',
  CourseCategory.seerah: 'seerah',
  CourseCategory.arabic: 'arabic',
  CourseCategory.spirituality: 'spirituality',
  CourseCategory.family: 'family',
  CourseCategory.finance: 'finance',
  CourseCategory.ethics: 'ethics',
};

const _$CertificationTypeEnumMap = {
  CertificationType.completion: 'completion',
  CertificationType.proficiency: 'proficiency',
  CertificationType.mastery: 'mastery',
};

_$CourseLessonImpl _$$CourseLessonImplFromJson(
  Map<String, dynamic> json,
) => _$CourseLessonImpl(
  id: json['id'] as String,
  courseId: json['courseId'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  orderIndex: (json['orderIndex'] as num).toInt(),
  type: $enumDecode(_$LessonTypeEnumMap, json['type']),
  duration: (json['duration'] as num).toInt(),
  isFree: json['isFree'] as bool? ?? false,
  isLocked: json['isLocked'] as bool? ?? false,
  videoUrl: json['videoUrl'] as String?,
  audioUrl: json['audioUrl'] as String?,
  documentUrl: json['documentUrl'] as String?,
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  quizIds:
      (json['quizIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  exerciseIds:
      (json['exerciseIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  notesContent: json['notesContent'] as String?,
  viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
  averageWatchTime:
      json['averageWatchTime'] == null
          ? Duration.zero
          : Duration(microseconds: (json['averageWatchTime'] as num).toInt()),
  completionRate: (json['completionRate'] as num?)?.toDouble() ?? 0.0,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$CourseLessonImplToJson(_$CourseLessonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'title': instance.title,
      'description': instance.description,
      'orderIndex': instance.orderIndex,
      'type': _$LessonTypeEnumMap[instance.type]!,
      'duration': instance.duration,
      'isFree': instance.isFree,
      'isLocked': instance.isLocked,
      'videoUrl': instance.videoUrl,
      'audioUrl': instance.audioUrl,
      'documentUrl': instance.documentUrl,
      'attachments': instance.attachments,
      'quizIds': instance.quizIds,
      'exerciseIds': instance.exerciseIds,
      'notesContent': instance.notesContent,
      'viewCount': instance.viewCount,
      'averageWatchTime': instance.averageWatchTime.inMicroseconds,
      'completionRate': instance.completionRate,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$LessonTypeEnumMap = {
  LessonType.video: 'video',
  LessonType.audio: 'audio',
  LessonType.text: 'text',
  LessonType.interactive: 'interactive',
  LessonType.quiz: 'quiz',
  LessonType.live: 'live',
};

_$IslamicQuizImpl _$$IslamicQuizImplFromJson(
  Map<String, dynamic> json,
) => _$IslamicQuizImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  type: $enumDecode(_$QuizTypeEnumMap, json['type']),
  questionIds:
      (json['questionIds'] as List<dynamic>).map((e) => e as String).toList(),
  timeLimit: (json['timeLimit'] as num).toInt(),
  passingScore: (json['passingScore'] as num).toInt(),
  maxAttempts: (json['maxAttempts'] as num?)?.toInt() ?? 1,
  shuffleQuestions: json['shuffleQuestions'] as bool? ?? false,
  showCorrectAnswers: json['showCorrectAnswers'] as bool? ?? false,
  allowReview: json['allowReview'] as bool? ?? false,
  points: (json['points'] as num?)?.toInt() ?? 0,
  badges:
      (json['badges'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$IslamicQuizImplToJson(_$IslamicQuizImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': _$QuizTypeEnumMap[instance.type]!,
      'questionIds': instance.questionIds,
      'timeLimit': instance.timeLimit,
      'passingScore': instance.passingScore,
      'maxAttempts': instance.maxAttempts,
      'shuffleQuestions': instance.shuffleQuestions,
      'showCorrectAnswers': instance.showCorrectAnswers,
      'allowReview': instance.allowReview,
      'points': instance.points,
      'badges': instance.badges,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$QuizTypeEnumMap = {
  QuizType.practice: 'practice',
  QuizType.assessment: 'assessment',
  QuizType.certification: 'certification',
  QuizType.challenge: 'challenge',
};

_$QuizQuestionImpl _$$QuizQuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuizQuestionImpl(
      id: json['id'] as String,
      quizId: json['quizId'] as String,
      question: json['question'] as String,
      arabicQuestion: json['arabicQuestion'] as String,
      type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      correctAnswerIndices:
          (json['correctAnswerIndices'] as List<dynamic>)
              .map((e) => (e as num).toInt())
              .toList(),
      points: (json['points'] as num).toInt(),
      explanation: json['explanation'] as String?,
      arabicExplanation: json['arabicExplanation'] as String?,
      reference: json['reference'] as String?,
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      difficulty:
          $enumDecodeNullable(_$DifficultyLevelEnumMap, json['difficulty']) ??
          DifficultyLevel.medium,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      totalAttempts: (json['totalAttempts'] as num?)?.toInt() ?? 0,
      correctAttempts: (json['correctAttempts'] as num?)?.toInt() ?? 0,
      successRate: (json['successRate'] as num?)?.toDouble() ?? 0.0,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$QuizQuestionImplToJson(_$QuizQuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quizId': instance.quizId,
      'question': instance.question,
      'arabicQuestion': instance.arabicQuestion,
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'options': instance.options,
      'correctAnswerIndices': instance.correctAnswerIndices,
      'points': instance.points,
      'explanation': instance.explanation,
      'arabicExplanation': instance.arabicExplanation,
      'reference': instance.reference,
      'imageUrl': instance.imageUrl,
      'audioUrl': instance.audioUrl,
      'difficulty': _$DifficultyLevelEnumMap[instance.difficulty]!,
      'tags': instance.tags,
      'totalAttempts': instance.totalAttempts,
      'correctAttempts': instance.correctAttempts,
      'successRate': instance.successRate,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$QuestionTypeEnumMap = {
  QuestionType.multipleChoice: 'multipleChoice',
  QuestionType.trueFalse: 'trueFalse',
  QuestionType.fillInTheBlank: 'fillInTheBlank',
  QuestionType.shortAnswer: 'shortAnswer',
  QuestionType.matching: 'matching',
  QuestionType.ordering: 'ordering',
  QuestionType.arabicTranslation: 'arabicTranslation',
  QuestionType.quranicVerse: 'quranicVerse',
};

const _$DifficultyLevelEnumMap = {
  DifficultyLevel.easy: 'easy',
  DifficultyLevel.medium: 'medium',
  DifficultyLevel.hard: 'hard',
  DifficultyLevel.expert: 'expert',
};

_$LiveQASessionImpl _$$LiveQASessionImplFromJson(
  Map<String, dynamic> json,
) => _$LiveQASessionImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  scholarId: json['scholarId'] as String,
  scheduledStart: DateTime.parse(json['scheduledStart'] as String),
  duration: Duration(microseconds: (json['duration'] as num).toInt()),
  status: $enumDecode(_$SessionStatusEnumMap, json['status']),
  maxParticipants: (json['maxParticipants'] as num?)?.toInt() ?? 100,
  currentParticipants: (json['currentParticipants'] as num?)?.toInt() ?? 0,
  topics:
      (json['topics'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  languages:
      (json['languages'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  streamUrl: json['streamUrl'] as String?,
  chatRoomId: json['chatRoomId'] as String?,
  recordingUrl: json['recordingUrl'] as String?,
  requiresRegistration: json['requiresRegistration'] as bool? ?? false,
  isPremiumOnly: json['isPremiumOnly'] as bool? ?? false,
  price: (json['price'] as num?)?.toDouble() ?? 0.0,
  moderationEnabled: json['moderationEnabled'] as bool? ?? true,
  moderatorIds:
      (json['moderatorIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  allowAnonymousQuestions: json['allowAnonymousQuestions'] as bool? ?? true,
  actualStart:
      json['actualStart'] == null
          ? null
          : DateTime.parse(json['actualStart'] as String),
  actualEnd:
      json['actualEnd'] == null
          ? null
          : DateTime.parse(json['actualEnd'] as String),
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$LiveQASessionImplToJson(_$LiveQASessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'scholarId': instance.scholarId,
      'scheduledStart': instance.scheduledStart.toIso8601String(),
      'duration': instance.duration.inMicroseconds,
      'status': _$SessionStatusEnumMap[instance.status]!,
      'maxParticipants': instance.maxParticipants,
      'currentParticipants': instance.currentParticipants,
      'topics': instance.topics,
      'languages': instance.languages,
      'streamUrl': instance.streamUrl,
      'chatRoomId': instance.chatRoomId,
      'recordingUrl': instance.recordingUrl,
      'requiresRegistration': instance.requiresRegistration,
      'isPremiumOnly': instance.isPremiumOnly,
      'price': instance.price,
      'moderationEnabled': instance.moderationEnabled,
      'moderatorIds': instance.moderatorIds,
      'allowAnonymousQuestions': instance.allowAnonymousQuestions,
      'actualStart': instance.actualStart?.toIso8601String(),
      'actualEnd': instance.actualEnd?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$SessionStatusEnumMap = {
  SessionStatus.scheduled: 'scheduled',
  SessionStatus.starting: 'starting',
  SessionStatus.live: 'live',
  SessionStatus.ended: 'ended',
  SessionStatus.cancelled: 'cancelled',
  SessionStatus.recorded: 'recorded',
};

_$PersonalizedCurriculumImpl _$$PersonalizedCurriculumImplFromJson(
  Map<String, dynamic> json,
) => _$PersonalizedCurriculumImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  interests:
      (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
  currentLevel: $enumDecode(_$LearningLevelEnumMap, json['currentLevel']),
  targetLevel: $enumDecode(_$LearningLevelEnumMap, json['targetLevel']),
  pathIds: (json['pathIds'] as List<dynamic>).map((e) => e as String).toList(),
  courseIds:
      (json['courseIds'] as List<dynamic>).map((e) => e as String).toList(),
  dailyGoal:
      json['dailyGoal'] == null
          ? const Duration(hours: 1)
          : Duration(microseconds: (json['dailyGoal'] as num).toInt()),
  goals:
      (json['goals'] as List<dynamic>?)
          ?.map((e) => StudyGoal.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  status:
      $enumDecodeNullable(_$CurriculumStatusEnumMap, json['status']) ??
      CurriculumStatus.active,
  overallProgress: (json['overallProgress'] as num?)?.toDouble() ?? 0.0,
  completedCourses: (json['completedCourses'] as num?)?.toInt() ?? 0,
  totalStudyTime: (json['totalStudyTime'] as num?)?.toInt() ?? 0,
  streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
  lastStudyDate:
      json['lastStudyDate'] == null
          ? null
          : DateTime.parse(json['lastStudyDate'] as String),
  recommendedCourses:
      (json['recommendedCourses'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  recommendedScholars:
      (json['recommendedScholars'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  lastRecommendationUpdate:
      json['lastRecommendationUpdate'] == null
          ? null
          : DateTime.parse(json['lastRecommendationUpdate'] as String),
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$PersonalizedCurriculumImplToJson(
  _$PersonalizedCurriculumImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'title': instance.title,
  'interests': instance.interests,
  'currentLevel': _$LearningLevelEnumMap[instance.currentLevel]!,
  'targetLevel': _$LearningLevelEnumMap[instance.targetLevel]!,
  'pathIds': instance.pathIds,
  'courseIds': instance.courseIds,
  'dailyGoal': instance.dailyGoal.inMicroseconds,
  'goals': instance.goals,
  'status': _$CurriculumStatusEnumMap[instance.status]!,
  'overallProgress': instance.overallProgress,
  'completedCourses': instance.completedCourses,
  'totalStudyTime': instance.totalStudyTime,
  'streakDays': instance.streakDays,
  'lastStudyDate': instance.lastStudyDate?.toIso8601String(),
  'recommendedCourses': instance.recommendedCourses,
  'recommendedScholars': instance.recommendedScholars,
  'lastRecommendationUpdate':
      instance.lastRecommendationUpdate?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$CurriculumStatusEnumMap = {
  CurriculumStatus.active: 'active',
  CurriculumStatus.paused: 'paused',
  CurriculumStatus.completed: 'completed',
  CurriculumStatus.archived: 'archived',
};

_$StudyGoalImpl _$$StudyGoalImplFromJson(Map<String, dynamic> json) =>
    _$StudyGoalImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      type: $enumDecode(_$GoalTypeEnumMap, json['type']),
      targetValue: (json['targetValue'] as num).toInt(),
      currentValue: (json['currentValue'] as num).toInt(),
      deadline: DateTime.parse(json['deadline'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      reward: json['reward'] as String?,
      completedAt:
          json['completedAt'] == null
              ? null
              : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$StudyGoalImplToJson(_$StudyGoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': _$GoalTypeEnumMap[instance.type]!,
      'targetValue': instance.targetValue,
      'currentValue': instance.currentValue,
      'deadline': instance.deadline.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'reward': instance.reward,
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$GoalTypeEnumMap = {
  GoalType.dailyStudyTime: 'dailyStudyTime',
  GoalType.weeklyLessons: 'weeklyLessons',
  GoalType.monthlyQuizzes: 'monthlyQuizzes',
  GoalType.courseCompletion: 'courseCompletion',
  GoalType.certificateEarned: 'certificateEarned',
  GoalType.streakMaintained: 'streakMaintained',
};

_$IslamicCertificateImpl _$$IslamicCertificateImplFromJson(
  Map<String, dynamic> json,
) => _$IslamicCertificateImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  courseId: json['courseId'] as String,
  title: json['title'] as String,
  issuingInstitution: json['issuingInstitution'] as String,
  scholarName: json['scholarName'] as String,
  issuedDate: DateTime.parse(json['issuedDate'] as String),
  type: $enumDecode(_$CertificationTypeEnumMap, json['type']),
  finalScore: (json['finalScore'] as num).toDouble(),
  certificateHash: json['certificateHash'] as String,
  blockchainId: json['blockchainId'] as String,
  isVerifiable: json['isVerifiable'] as bool? ?? true,
  templateUrl: json['templateUrl'] as String?,
  downloadUrl: json['downloadUrl'] as String?,
  skillsEarned:
      (json['skillsEarned'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  isPublic: json['isPublic'] as bool? ?? false,
  allowSharing: json['allowSharing'] as bool? ?? true,
  expiryDate:
      json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
  lastVerified:
      json['lastVerified'] == null
          ? null
          : DateTime.parse(json['lastVerified'] as String),
);

Map<String, dynamic> _$$IslamicCertificateImplToJson(
  _$IslamicCertificateImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'courseId': instance.courseId,
  'title': instance.title,
  'issuingInstitution': instance.issuingInstitution,
  'scholarName': instance.scholarName,
  'issuedDate': instance.issuedDate.toIso8601String(),
  'type': _$CertificationTypeEnumMap[instance.type]!,
  'finalScore': instance.finalScore,
  'certificateHash': instance.certificateHash,
  'blockchainId': instance.blockchainId,
  'isVerifiable': instance.isVerifiable,
  'templateUrl': instance.templateUrl,
  'downloadUrl': instance.downloadUrl,
  'skillsEarned': instance.skillsEarned,
  'isPublic': instance.isPublic,
  'allowSharing': instance.allowSharing,
  'expiryDate': instance.expiryDate?.toIso8601String(),
  'lastVerified': instance.lastVerified?.toIso8601String(),
};

_$LearningProgressImpl _$$LearningProgressImplFromJson(
  Map<String, dynamic> json,
) => _$LearningProgressImpl(
  userId: json['userId'] as String,
  itemId: json['itemId'] as String,
  type: $enumDecode(_$ProgressTypeEnumMap, json['type']),
  progress: (json['progress'] as num).toDouble(),
  timeSpent: (json['timeSpent'] as num?)?.toInt() ?? 0,
  attempts: (json['attempts'] as num?)?.toInt() ?? 0,
  bestScore: (json['bestScore'] as num?)?.toDouble() ?? 0.0,
  completedSections:
      (json['completedSections'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  startedAt:
      json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
  completedAt:
      json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
  lastActivityAt:
      json['lastActivityAt'] == null
          ? null
          : DateTime.parse(json['lastActivityAt'] as String),
);

Map<String, dynamic> _$$LearningProgressImplToJson(
  _$LearningProgressImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'itemId': instance.itemId,
  'type': _$ProgressTypeEnumMap[instance.type]!,
  'progress': instance.progress,
  'timeSpent': instance.timeSpent,
  'attempts': instance.attempts,
  'bestScore': instance.bestScore,
  'completedSections': instance.completedSections,
  'startedAt': instance.startedAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'lastActivityAt': instance.lastActivityAt?.toIso8601String(),
};

const _$ProgressTypeEnumMap = {
  ProgressType.course: 'course',
  ProgressType.lesson: 'lesson',
  ProgressType.quiz: 'quiz',
  ProgressType.path: 'path',
  ProgressType.goal: 'goal',
};

_$LearningAnalyticsImpl _$$LearningAnalyticsImplFromJson(
  Map<String, dynamic> json,
) => _$LearningAnalyticsImpl(
  userId: json['userId'] as String,
  totalCourses: (json['totalCourses'] as num?)?.toInt() ?? 0,
  completedCourses: (json['completedCourses'] as num?)?.toInt() ?? 0,
  totalLessons: (json['totalLessons'] as num?)?.toInt() ?? 0,
  completedLessons: (json['completedLessons'] as num?)?.toInt() ?? 0,
  totalQuizzes: (json['totalQuizzes'] as num?)?.toInt() ?? 0,
  passedQuizzes: (json['passedQuizzes'] as num?)?.toInt() ?? 0,
  certificatesEarned: (json['certificatesEarned'] as num?)?.toInt() ?? 0,
  studyStreak: (json['studyStreak'] as num?)?.toInt() ?? 0,
  longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
  totalStudyTime: (json['totalStudyTime'] as num?)?.toInt() ?? 0,
  averageQuizScore: (json['averageQuizScore'] as num?)?.toDouble() ?? 0.0,
  categoryProgress:
      (json['categoryProgress'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          $enumDecode(_$CourseCategoryEnumMap, k),
          (e as num).toInt(),
        ),
      ) ??
      const {},
  scholarInteractions:
      (json['scholarInteractions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
  favoriteTopics:
      (json['favoriteTopics'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  firstStudyDate:
      json['firstStudyDate'] == null
          ? null
          : DateTime.parse(json['firstStudyDate'] as String),
  lastStudyDate:
      json['lastStudyDate'] == null
          ? null
          : DateTime.parse(json['lastStudyDate'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$LearningAnalyticsImplToJson(
  _$LearningAnalyticsImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'totalCourses': instance.totalCourses,
  'completedCourses': instance.completedCourses,
  'totalLessons': instance.totalLessons,
  'completedLessons': instance.completedLessons,
  'totalQuizzes': instance.totalQuizzes,
  'passedQuizzes': instance.passedQuizzes,
  'certificatesEarned': instance.certificatesEarned,
  'studyStreak': instance.studyStreak,
  'longestStreak': instance.longestStreak,
  'totalStudyTime': instance.totalStudyTime,
  'averageQuizScore': instance.averageQuizScore,
  'categoryProgress': instance.categoryProgress.map(
    (k, e) => MapEntry(_$CourseCategoryEnumMap[k]!, e),
  ),
  'scholarInteractions': instance.scholarInteractions,
  'favoriteTopics': instance.favoriteTopics,
  'firstStudyDate': instance.firstStudyDate?.toIso8601String(),
  'lastStudyDate': instance.lastStudyDate?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
