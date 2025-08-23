/// Islamic course difficulty levels
enum CourseDifficulty { beginner, intermediate, advanced }

/// Course categories for Islamic learning
enum CourseCategory { quran, hadith, fiqh, aqeedah, history, duas, arabic, family, children, spirituality }

/// Islamic course model for education marketplace
class IslamicCourse {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String instructorTitle;
  final String? instructorBio;
  final String? instructorImageUrl;
  final String thumbnailUrl;
  final String? videoPreviewUrl;
  final CourseCategory category;
  final CourseDifficulty difficulty;
  final double price;
  final double originalPrice;
  final int durationMinutes;
  final int lessonCount;
  final int enrolledCount;
  final double rating;
  final int reviewCount;
  final List<String> features;
  final List<String> topics;
  final List<String> prerequisites;
  final bool isPopular;
  final bool isNew;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String language;
  final bool hasSubtitles;
  final bool hasCertificate;
  final bool isLifetimeAccess;

  const IslamicCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.instructorTitle,
    this.instructorBio,
    this.instructorImageUrl,
    required this.thumbnailUrl,
    this.videoPreviewUrl,
    required this.category,
    required this.difficulty,
    required this.price,
    required this.originalPrice,
    required this.durationMinutes,
    required this.lessonCount,
    required this.enrolledCount,
    required this.rating,
    required this.reviewCount,
    required this.features,
    required this.topics,
    required this.prerequisites,
    this.isPopular = false,
    this.isNew = false,
    required this.createdAt,
    this.updatedAt,
    this.language = 'English',
    this.hasSubtitles = false,
    this.hasCertificate = false,
    this.isLifetimeAccess = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'instructor': instructor,
    'instructorTitle': instructorTitle,
    'instructorBio': instructorBio,
    'instructorImageUrl': instructorImageUrl,
    'thumbnailUrl': thumbnailUrl,
    'videoPreviewUrl': videoPreviewUrl,
    'category': category.name,
    'difficulty': difficulty.name,
    'price': price,
    'originalPrice': originalPrice,
    'durationMinutes': durationMinutes,
    'lessonCount': lessonCount,
    'enrolledCount': enrolledCount,
    'rating': rating,
    'reviewCount': reviewCount,
    'features': features,
    'topics': topics,
    'prerequisites': prerequisites,
    'isPopular': isPopular,
    'isNew': isNew,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'language': language,
    'hasSubtitles': hasSubtitles,
    'hasCertificate': hasCertificate,
    'isLifetimeAccess': isLifetimeAccess,
  };

  factory IslamicCourse.fromJson(Map<String, dynamic> json) => IslamicCourse(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    instructor: json['instructor'],
    instructorTitle: json['instructorTitle'],
    instructorBio: json['instructorBio'],
    instructorImageUrl: json['instructorImageUrl'],
    thumbnailUrl: json['thumbnailUrl'],
    videoPreviewUrl: json['videoPreviewUrl'],
    category: CourseCategory.values.firstWhere((e) => e.name == json['category']),
    difficulty: CourseDifficulty.values.firstWhere((e) => e.name == json['difficulty']),
    price: (json['price'] as num).toDouble(),
    originalPrice: (json['originalPrice'] as num).toDouble(),
    durationMinutes: json['durationMinutes'],
    lessonCount: json['lessonCount'],
    enrolledCount: json['enrolledCount'],
    rating: (json['rating'] as num).toDouble(),
    reviewCount: json['reviewCount'],
    features: List<String>.from(json['features']),
    topics: List<String>.from(json['topics']),
    prerequisites: List<String>.from(json['prerequisites']),
    isPopular: json['isPopular'] ?? false,
    isNew: json['isNew'] ?? false,
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    language: json['language'] ?? 'English',
    hasSubtitles: json['hasSubtitles'] ?? false,
    hasCertificate: json['hasCertificate'] ?? false,
    isLifetimeAccess: json['isLifetimeAccess'] ?? true,
  );

  /// Calculate discount percentage
  double get discountPercentage {
    if (originalPrice <= price) return 0.0;
    return ((originalPrice - price) / originalPrice * 100);
  }

  /// Check if course is on sale
  bool get isOnSale => price < originalPrice;

  /// Get formatted duration
  String get formattedDuration {
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Get category display name
  String get categoryDisplayName {
    switch (category) {
      case CourseCategory.quran:
        return 'Quran Studies';
      case CourseCategory.hadith:
        return 'Hadith Studies';
      case CourseCategory.fiqh:
        return 'Islamic Jurisprudence';
      case CourseCategory.aqeedah:
        return 'Islamic Beliefs';
      case CourseCategory.history:
        return 'Islamic History';
      case CourseCategory.duas:
        return 'Duas & Supplications';
      case CourseCategory.arabic:
        return 'Arabic Language';
      case CourseCategory.family:
        return 'Family & Marriage';
      case CourseCategory.children:
        return 'Children\'s Education';
      case CourseCategory.spirituality:
        return 'Islamic Spirituality';
    }
  }

  /// Get difficulty display name
  String get difficultyDisplayName {
    switch (difficulty) {
      case CourseDifficulty.beginner:
        return 'Beginner';
      case CourseDifficulty.intermediate:
        return 'Intermediate';
      case CourseDifficulty.advanced:
        return 'Advanced';
    }
  }
}

/// Course enrollment model
class CourseEnrollment {
  final String id;
  final String userId;
  final String courseId;
  final DateTime enrolledAt;
  final double progress;
  final DateTime? completedAt;
  final bool isFavorite;
  final DateTime? lastAccessedAt;
  final int currentLessonIndex;
  final Map<String, dynamic>? certificateData;

  const CourseEnrollment({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.enrolledAt,
    this.progress = 0.0,
    this.completedAt,
    this.isFavorite = false,
    this.lastAccessedAt,
    this.currentLessonIndex = 0,
    this.certificateData,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'courseId': courseId,
    'enrolledAt': enrolledAt.toIso8601String(),
    'progress': progress,
    'completedAt': completedAt?.toIso8601String(),
    'isFavorite': isFavorite,
    'lastAccessedAt': lastAccessedAt?.toIso8601String(),
    'currentLessonIndex': currentLessonIndex,
    'certificateData': certificateData,
  };

  factory CourseEnrollment.fromJson(Map<String, dynamic> json) => CourseEnrollment(
    id: json['id'],
    userId: json['userId'],
    courseId: json['courseId'],
    enrolledAt: DateTime.parse(json['enrolledAt']),
    progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    isFavorite: json['isFavorite'] ?? false,
    lastAccessedAt: json['lastAccessedAt'] != null ? DateTime.parse(json['lastAccessedAt']) : null,
    currentLessonIndex: json['currentLessonIndex'] ?? 0,
    certificateData: json['certificateData'],
  );

  /// Check if course is completed
  bool get isCompleted => completedAt != null || progress >= 100.0;

  /// Get progress percentage as integer
  int get progressPercentage => progress.round();
}

/// Course review model
class CourseReview {
  final String id;
  final String userId;
  final String courseId;
  final String userName;
  final String? userImageUrl;
  final double rating;
  final String review;
  final DateTime createdAt;
  final bool isVerifiedPurchase;
  final List<String>? helpfulUserIds;

  const CourseReview({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.userName,
    this.userImageUrl,
    required this.rating,
    required this.review,
    required this.createdAt,
    this.isVerifiedPurchase = false,
    this.helpfulUserIds,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'courseId': courseId,
    'userName': userName,
    'userImageUrl': userImageUrl,
    'rating': rating,
    'review': review,
    'createdAt': createdAt.toIso8601String(),
    'isVerifiedPurchase': isVerifiedPurchase,
    'helpfulUserIds': helpfulUserIds,
  };

  factory CourseReview.fromJson(Map<String, dynamic> json) => CourseReview(
    id: json['id'],
    userId: json['userId'],
    courseId: json['courseId'],
    userName: json['userName'],
    userImageUrl: json['userImageUrl'],
    rating: (json['rating'] as num).toDouble(),
    review: json['review'],
    createdAt: DateTime.parse(json['createdAt']),
    isVerifiedPurchase: json['isVerifiedPurchase'] ?? false,
    helpfulUserIds: json['helpfulUserIds'] != null ? List<String>.from(json['helpfulUserIds']) : null,
  );

  /// Get formatted time ago
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    }
  }

  /// Get helpful count
  int get helpfulCount => helpfulUserIds?.length ?? 0;
}

/// Sample Islamic courses for marketplace
class SampleIslamicCourses {
  static final List<IslamicCourse> courses = [
    IslamicCourse(
      id: 'quran-001',
      title: 'Complete Quran Recitation with Tajweed',
      description:
          'Master the art of beautiful Quran recitation with proper Tajweed rules. This comprehensive course covers all aspects of correct pronunciation and melodious recitation.',
      instructor: 'Sheikh Ahmad Al-Mahmoud',
      instructorTitle: 'Certified Qari & Islamic Scholar',
      instructorBio:
          'Sheikh Ahmad has been teaching Quran recitation for over 15 years and holds Ijazah in multiple Quranic recitations.',
      thumbnailUrl: 'https://example.com/quran-course.jpg',
      category: CourseCategory.quran,
      difficulty: CourseDifficulty.beginner,
      price: 79.99,
      originalPrice: 129.99,
      durationMinutes: 1200, // 20 hours
      lessonCount: 40,
      enrolledCount: 1547,
      rating: 4.8,
      reviewCount: 234,
      features: [
        'Step-by-step Tajweed rules',
        'Audio pronunciation guides',
        'Practice exercises',
        'Certificate of completion',
        'Lifetime access',
      ],
      topics: [
        'Arabic alphabet and pronunciation',
        'Tajweed rules and application',
        'Common recitation mistakes',
        'Melodious recitation techniques',
      ],
      prerequisites: [],
      isPopular: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      hasCertificate: true,
      hasSubtitles: true,
    ),

    IslamicCourse(
      id: 'hadith-001',
      title: 'Understanding Sahih Bukhari',
      description:
          'Deep dive into the most authentic collection of Prophet Muhammad\'s sayings and actions. Learn the science of Hadith and its practical applications.',
      instructor: 'Dr. Fatima Al-Zahra',
      instructorTitle: 'PhD in Islamic Studies',
      thumbnailUrl: 'https://example.com/hadith-course.jpg',
      category: CourseCategory.hadith,
      difficulty: CourseDifficulty.intermediate,
      price: 99.99,
      originalPrice: 149.99,
      durationMinutes: 1800, // 30 hours
      lessonCount: 60,
      enrolledCount: 892,
      rating: 4.9,
      reviewCount: 156,
      features: [
        'Authentic Hadith texts',
        'Arabic with translations',
        'Practical life applications',
        'Q&A sessions',
        'Study materials',
      ],
      topics: [
        'Science of Hadith authentication',
        'Key themes in Sahih Bukhari',
        'Prophet\'s character and conduct',
        'Islamic ethics and morals',
      ],
      prerequisites: ['Basic Arabic reading', 'Introduction to Islam'],
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      hasCertificate: true,
    ),

    IslamicCourse(
      id: 'fiqh-001',
      title: 'Islamic Jurisprudence for Modern Muslims',
      description:
          'Navigate contemporary Islamic legal issues with confidence. Learn how classical Islamic law applies to modern life situations.',
      instructor: 'Sheikh Muhammad Ibn Saleem',
      instructorTitle: 'Mufti & Legal Scholar',
      thumbnailUrl: 'https://example.com/fiqh-course.jpg',
      category: CourseCategory.fiqh,
      difficulty: CourseDifficulty.advanced,
      price: 119.99,
      originalPrice: 179.99,
      durationMinutes: 2400, // 40 hours
      lessonCount: 80,
      enrolledCount: 634,
      rating: 4.7,
      reviewCount: 98,
      features: [
        'Modern legal applications',
        'Case study discussions',
        'Q&A with scholars',
        'Reference materials',
        'Interactive discussions',
      ],
      topics: [
        'Prayer and worship rulings',
        'Financial transactions',
        'Family law in Islam',
        'Contemporary medical ethics',
      ],
      prerequisites: ['Islamic theology basics', 'Arabic comprehension'],
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      hasCertificate: true,
    ),

    IslamicCourse(
      id: 'arabic-001',
      title: 'Quranic Arabic Mastery',
      description:
          'Learn Arabic specifically for understanding the Quran. Build vocabulary and grammar skills to comprehend the holy text directly.',
      instructor: 'Ustadh Yusuf Al-Dimashqi',
      instructorTitle: 'Arabic Language Specialist',
      thumbnailUrl: 'https://example.com/arabic-course.jpg',
      category: CourseCategory.arabic,
      difficulty: CourseDifficulty.beginner,
      price: 59.99,
      originalPrice: 89.99,
      durationMinutes: 900, // 15 hours
      lessonCount: 30,
      enrolledCount: 2341,
      rating: 4.6,
      reviewCount: 445,
      features: [
        'Interactive vocabulary builder',
        'Grammar exercises',
        'Quranic text analysis',
        'Speaking practice',
        'Mobile-friendly lessons',
      ],
      topics: [
        'Arabic root system',
        'Essential Quranic vocabulary',
        'Basic grammar patterns',
        'Text comprehension skills',
      ],
      prerequisites: [],
      isNew: true,
      isPopular: true,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      hasSubtitles: true,
    ),

    IslamicCourse(
      id: 'family-001',
      title: 'Building Islamic Families',
      description:
          'Create a harmonious Islamic household. Learn the rights and responsibilities of spouses, parenting guidance, and family conflict resolution.',
      instructor: 'Sister Khadija Mohammed',
      instructorTitle: 'Family Counselor & Islamic Studies Graduate',
      thumbnailUrl: 'https://example.com/family-course.jpg',
      category: CourseCategory.family,
      difficulty: CourseDifficulty.intermediate,
      price: 69.99,
      originalPrice: 99.99,
      durationMinutes: 600, // 10 hours
      lessonCount: 20,
      enrolledCount: 1123,
      rating: 4.8,
      reviewCount: 267,
      features: [
        'Real-life scenarios',
        'Islamic parenting tips',
        'Marriage guidance',
        'Conflict resolution',
        'Community resources',
      ],
      topics: ['Spousal rights in Islam', 'Islamic child-rearing', 'Extended family relations', 'Household management'],
      prerequisites: [],
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      hasCertificate: true,
    ),
  ];

  /// Get courses by category
  static List<IslamicCourse> getCoursesByCategory(CourseCategory category) {
    return courses.where((course) => course.category == category).toList();
  }

  /// Get popular courses
  static List<IslamicCourse> getPopularCourses() {
    return courses.where((course) => course.isPopular).toList();
  }

  /// Get new courses
  static List<IslamicCourse> getNewCourses() {
    return courses.where((course) => course.isNew).toList();
  }

  /// Get courses on sale
  static List<IslamicCourse> getCoursesOnSale() {
    return courses.where((course) => course.isOnSale).toList();
  }

  /// Get courses by difficulty
  static List<IslamicCourse> getCoursesByDifficulty(CourseDifficulty difficulty) {
    return courses.where((course) => course.difficulty == difficulty).toList();
  }

  /// Search courses by query
  static List<IslamicCourse> searchCourses(String query) {
    final lowercaseQuery = query.toLowerCase();
    return courses
        .where(
          (course) =>
              course.title.toLowerCase().contains(lowercaseQuery) ||
              course.description.toLowerCase().contains(lowercaseQuery) ||
              course.instructor.toLowerCase().contains(lowercaseQuery) ||
              course.topics.any((topic) => topic.toLowerCase().contains(lowercaseQuery)),
        )
        .toList();
  }
}
