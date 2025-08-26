import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../core/logging/app_logger.dart';

/// Simple notification service for proactive spiritual companion
class NotificationService {
  static NotificationService? _instance;
  static NotificationService get instance => _instance ??= NotificationService._();

  NotificationService._();

  late FlutterLocalNotificationsPlugin _notifications;
  bool _isInitialized = false;

  /// Initialize notifications
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _notifications = FlutterLocalNotificationsPlugin();

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);

      await _notifications.initialize(initSettings);
      _isInitialized = true;

      AppLogger.info('Notification Service initialized');
    } catch (e) {
      AppLogger.error('Failed to initialize notifications: $e');
      rethrow;
    }
  }

  /// Show notification
  Future<void> showNotification({required int id, required String title, required String body, String? payload}) async {
    if (!_isInitialized) await initialize();

    try {
      const androidDetails = AndroidNotificationDetails(
        'duacopilot_spiritual',
        'Spiritual Companion',
        channelDescription: 'Proactive spiritual guidance and reminders',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      await _notifications.show(id, title, body, notificationDetails, payload: payload);
    } catch (e) {
      AppLogger.error('Failed to show notification: $e');
    }
  }
}
