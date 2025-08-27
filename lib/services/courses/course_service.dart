import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/islamic_course_models.dart';

/// Service for managing Islamic course enrollments and progress
class CourseService {
  static const String _enrollmentsKey = 'course_enrollments';

  late final SharedPreferences _prefs;
  static CourseService? _instance;

  // Private constructor
  CourseService._();

  /// Singleton instance
  static CourseService get instance {
    _instance ??= CourseService._();
    return _instance!;
  }

  /// Initialize the service
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      print('CourseService initialized');
    } catch (e) {
      print('Failed to initialize CourseService: $e');
      rethrow;
    }
  }

  /// Get all enrolled courses
  List<CourseEnrollment> getEnrolledCourses() {
    try {
      final enrollmentsJson = _prefs.getStringList(_enrollmentsKey) ?? [];
      return enrollmentsJson
          .map((json) => CourseEnrollment.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('Failed to get enrolled courses: $e');
      return [];
    }
  }

  /// Check if user is enrolled in a course
  bool isEnrolledInCourse(String courseId) {
    final enrollments = getEnrolledCourses();
    return enrollments.any((enrollment) => enrollment.courseId == courseId);
  }

  /// Get enrollment for a specific course
  CourseEnrollment? getEnrollment(String courseId) {
    final enrollments = getEnrolledCourses();
    try {
      return enrollments.firstWhere(
        (enrollment) => enrollment.courseId == courseId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Enroll in a course
  Future<bool> enrollInCourse(String courseId, String userId) async {
    try {
      // Check if already enrolled
      if (isEnrolledInCourse(courseId)) {
        print('User already enrolled in course: $courseId');
        return false;
      }

      final enrollment = CourseEnrollment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        courseId: courseId,
        userId: userId,
        enrolledAt: DateTime.now(),
        progress: 0,
      );

      final enrollments = getEnrolledCourses();
      enrollments.add(enrollment);

      final enrollmentsJson =
          enrollments.map((e) => jsonEncode(e.toJson())).toList();

      await _prefs.setStringList(_enrollmentsKey, enrollmentsJson);

      print('Successfully enrolled in course: $courseId');
      return true;
    } catch (e) {
      print('Failed to enroll in course: $e');
      return false;
    }
  }

  /// Update course progress
  Future<bool> updateCourseProgress(String courseId, double progress) async {
    try {
      final enrollments = getEnrolledCourses();
      final enrollmentIndex = enrollments.indexWhere(
        (e) => e.courseId == courseId,
      );

      if (enrollmentIndex == -1) {
        print('No enrollment found for course: $courseId');
        return false;
      }

      // Update progress by creating a new enrollment object
      enrollments[enrollmentIndex] = CourseEnrollment(
        id: enrollments[enrollmentIndex].id,
        courseId: enrollments[enrollmentIndex].courseId,
        userId: enrollments[enrollmentIndex].userId,
        enrolledAt: enrollments[enrollmentIndex].enrolledAt,
        progress: progress,
        completedAt: progress >= 100 ? DateTime.now() : null,
        isFavorite: enrollments[enrollmentIndex].isFavorite,
        lastAccessedAt: DateTime.now(),
        currentLessonIndex: enrollments[enrollmentIndex].currentLessonIndex,
        certificateData: enrollments[enrollmentIndex].certificateData,
      );

      final enrollmentsJson =
          enrollments.map((e) => jsonEncode(e.toJson())).toList();

      await _prefs.setStringList(_enrollmentsKey, enrollmentsJson);

      print('Updated progress for course $courseId: $progress%');
      return true;
    } catch (e) {
      print('Failed to update course progress: $e');
      return false;
    }
  }

  /// Complete a course
  Future<bool> completeCourse(String courseId) async {
    try {
      return await updateCourseProgress(courseId, 100);
    } catch (e) {
      print('Failed to complete course: $e');
      return false;
    }
  }

  /// Get course progress
  double getCourseProgress(String courseId) {
    final enrollment = getEnrollment(courseId);
    return enrollment?.progress ?? 0.0;
  }

  /// Check if course is completed
  bool isCourseCompleted(String courseId) {
    final enrollment = getEnrollment(courseId);
    return enrollment?.completedAt != null;
  }

  /// Get completion statistics
  Map<String, dynamic> getCompletionStats() {
    final enrollments = getEnrolledCourses();
    final completed = enrollments.where((e) => e.completedAt != null).length;
    final inProgress = enrollments
        .where((e) => e.completedAt == null && e.progress > 0)
        .length;
    final notStarted = enrollments.where((e) => e.progress == 0).length;

    return {
      'total': enrollments.length,
      'completed': completed,
      'inProgress': inProgress,
      'notStarted': notStarted,
      'completionRate':
          enrollments.isNotEmpty ? (completed / enrollments.length) * 100 : 0,
    };
  }

  /// Toggle favorite status for a course
  Future<bool> toggleCourseFavorite(String courseId) async {
    try {
      final enrollments = getEnrolledCourses();
      final enrollmentIndex = enrollments.indexWhere(
        (e) => e.courseId == courseId,
      );

      if (enrollmentIndex == -1) {
        print('No enrollment found for course: $courseId');
        return false;
      }

      final currentEnrollment = enrollments[enrollmentIndex];
      enrollments[enrollmentIndex] = CourseEnrollment(
        id: currentEnrollment.id,
        courseId: currentEnrollment.courseId,
        userId: currentEnrollment.userId,
        enrolledAt: currentEnrollment.enrolledAt,
        progress: currentEnrollment.progress,
        completedAt: currentEnrollment.completedAt,
        isFavorite: !currentEnrollment.isFavorite,
        lastAccessedAt: DateTime.now(),
        currentLessonIndex: currentEnrollment.currentLessonIndex,
        certificateData: currentEnrollment.certificateData,
      );

      final enrollmentsJson =
          enrollments.map((e) => jsonEncode(e.toJson())).toList();

      await _prefs.setStringList(_enrollmentsKey, enrollmentsJson);

      print('Toggled favorite for course: $courseId');
      return true;
    } catch (e) {
      print('Failed to toggle course favorite: $e');
      return false;
    }
  }

  /// Clear all course data (for testing/reset)
  Future<void> clearAllCourseData() async {
    try {
      await _prefs.remove(_enrollmentsKey);
      print('Cleared all course data');
    } catch (e) {
      print('Failed to clear course data: $e');
    }
  }
}
