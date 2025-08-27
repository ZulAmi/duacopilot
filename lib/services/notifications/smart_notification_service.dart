import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../../domain/entities/dua_entity.dart';
import '../../domain/entities/context_entity.dart';

/// _TimeOfDay class implementation
class _TimeOfDay {
  final int hour;
  final int minute;

  const _TimeOfDay(this.hour, this.minute);
}

/// SmartNotificationService class implementation
class SmartNotificationService {
  static SmartNotificationService? _instance;
  static SmartNotificationService get instance =>
      _instance ??= SmartNotificationService._();

  SmartNotificationService._();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  // Notification channels
  static const String _prayerChannelId = 'prayer_reminders';
  static const String _duaChannelId = 'dua_suggestions';
  static const String _habitChannelId = 'habit_tracking';
  static const String _contextChannelId = 'contextual_suggestions';

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone data
      tz.initializeTimeZones();

      // Android initialization
      const AndroidInitializationSettings androidInitSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization
      const DarwinInitializationSettings iosInitSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidInitSettings,
        iOS: iosInitSettings,
      );

      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Create notification channels for Android
      if (Platform.isAndroid) {
        await _createNotificationChannels();
      }

      // Request permissions
      await _requestPermissions();

      _isInitialized = true;
      debugPrint('Smart notification service initialized');
    } catch (e) {
      debugPrint('Failed to initialize notification service: $e');
      rethrow;
    }
  }

  Future<void> _createNotificationChannels() async {
    final List<AndroidNotificationChannel> channels = [
      const AndroidNotificationChannel(
        _prayerChannelId,
        'Prayer Reminders',
        description: 'Notifications for prayer times and related Du\'as',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      ),
      const AndroidNotificationChannel(
        _duaChannelId,
        'Du\'a Suggestions',
        description: 'Smart suggestions for relevant Du\'as',
        importance: Importance.defaultImportance,
        enableVibration: false,
        playSound: true,
      ),
      const AndroidNotificationChannel(
        _habitChannelId,
        'Habit Tracking',
        description: 'Reminders for daily Du\'a practice',
        importance: Importance.defaultImportance,
        enableVibration: true,
        playSound: false,
      ),
      const AndroidNotificationChannel(
        _contextChannelId,
        'Contextual Suggestions',
        description: 'Location and time-based Du\'a recommendations',
        importance: Importance.low,
        enableVibration: false,
        playSound: false,
      ),
    ];

    for (final channel in channels) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
    } else if (Platform.isIOS) {
      final IOSFlutterLocalNotificationsPlugin? iosImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      await iosImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      _handleNotificationAction(payload);
    }
  }

  void _handleNotificationAction(String payload) {
    try {
      // Parse payload and handle different notification types
      debugPrint('Notification tapped with payload: $payload');
      // TODO: Implement navigation to relevant Du'a or action
    } catch (e) {
      debugPrint('Error handling notification action: $e');
    }
  }

  /// Schedule prayer time notifications
  Future<void> schedulePrayerNotifications(
    PrayerTimes prayerTimes,
    UserPreferences preferences,
  ) async {
    await _ensureInitialized();

    if (!preferences.notifications.prayerReminders) return;

    final prayers = [
      ('Fajr', prayerTimes.fajr),
      ('Dhuhr', prayerTimes.dhuhr),
      ('Asr', prayerTimes.asr),
      ('Maghrib', prayerTimes.maghrib),
      ('Isha', prayerTimes.isha),
    ];

    for (int i = 0; i < prayers.length; i++) {
      final (prayerName, prayerTime) = prayers[i];
      final notificationTime = prayerTime.subtract(const Duration(minutes: 10));

      if (notificationTime.isAfter(DateTime.now())) {
        await _scheduleNotification(
          id: 1000 + i,
          title: '$prayerName Prayer Time Approaching',
          body:
              'It\'s time for $prayerName prayer. Consider reciting related Du\'as.',
          scheduledTime: notificationTime,
          channelId: _prayerChannelId,
          payload: 'prayer:$prayerName',
        );
      }
    }
  }

  /// Schedule contextual Du'a suggestions based on location and time
  Future<void> scheduleContextualSuggestions(
    List<SmartSuggestion> suggestions,
    UserPreferences preferences,
  ) async {
    await _ensureInitialized();

    if (!preferences.notifications.contextualSuggestions) return;

    for (int i = 0; i < suggestions.length && i < 5; i++) {
      final suggestion = suggestions[i];

      await _scheduleNotification(
        id: 2000 + i,
        title: 'Du\'a Suggestion',
        body: suggestion.reason,
        scheduledTime: suggestion.timestamp,
        channelId: _contextChannelId,
        payload: 'suggestion:${suggestion.duaId}',
      );
    }
  }

  /// Schedule daily Du'a reminders
  Future<void> scheduleDailyReminders(UserPreferences preferences) async {
    await _ensureInitialized();

    if (!preferences.notifications.dailyDua) return;

    // Morning reminder
    await _scheduleRepeatingNotification(
      id: 3001,
      title: 'Morning Du\'a',
      body: 'Start your day with beautiful Du\'as and dhikr',
      time: _TimeOfDay(7, 0),
      channelId: _duaChannelId,
      payload: 'daily:morning',
    );

    // Evening reminder
    await _scheduleRepeatingNotification(
      id: 3002,
      title: 'Evening Du\'a',
      body: 'End your day with gratitude and remembrance',
      time: _TimeOfDay(19, 0),
      channelId: _duaChannelId,
      payload: 'daily:evening',
    );
  }

  /// Schedule habit tracking reminders
  Future<void> scheduleHabitReminders(
    HabitStats habits,
    UserPreferences preferences,
  ) async {
    await _ensureInitialized();

    if (!preferences.notifications.habitReminders) return;

    // Check if user hasn't practiced today
    final today = DateTime.now();
    final lastActivity = habits.lastActivity;

    if (!_isSameDay(today, lastActivity)) {
      final reminderTime = today.add(const Duration(hours: 2));

      await _scheduleNotification(
        id: 4001,
        title: 'Du\'a Practice Reminder',
        body:
            'Keep your ${habits.currentStreak}-day streak going! Take a moment for Du\'a.',
        scheduledTime: reminderTime,
        channelId: _habitChannelId,
        payload: 'habit:practice',
      );
    }
  }

  /// Schedule smart suggestions based on user patterns
  Future<void> scheduleSmartSuggestions(
    UserContext userContext,
    List<DuaEntity> suggestedDuas,
  ) async {
    await _ensureInitialized();

    if (!userContext.preferences.notifications.enabled) return;

    final suggestions = _generateTimeBasedSuggestions(
      userContext,
      suggestedDuas,
    );

    for (int i = 0; i < suggestions.length && i < 3; i++) {
      final suggestion = suggestions[i];
      final scheduledTime = DateTime.now().add(Duration(hours: i + 1));

      await _scheduleNotification(
        id: 5000 + i,
        title: 'Personalized Du\'a',
        body: suggestion.reason,
        scheduledTime: scheduledTime,
        channelId: _contextChannelId,
        payload: 'smart:${suggestion.duaId}',
      );
    }
  }

  List<SmartSuggestion> _generateTimeBasedSuggestions(
    UserContext userContext,
    List<DuaEntity> duas,
  ) {
    final suggestions = <SmartSuggestion>[];
    final now = DateTime.now();

    // Time-based suggestions
    if (_isNearPrayerTime(userContext.time.prayerTimes)) {
      final relevantDuas = duas
          .where(
            (dua) =>
                dua.category.toLowerCase().contains('prayer') ||
                dua.category.toLowerCase().contains('salah'),
          )
          .toList();

      for (final dua in relevantDuas.take(2)) {
        suggestions.add(
          SmartSuggestion(
            duaId: dua.id,
            type: SuggestionType.timeBased,
            confidence: 0.8,
            reason: 'Perfect time for prayer-related Du\'as',
            timestamp: now,
            trigger: SuggestionTrigger.prayerTime,
          ),
        );
      }
    }

    // Evening suggestions
    if (_isEvening(now)) {
      final eveningDuas = duas
          .where(
            (dua) =>
                dua.category.toLowerCase().contains('evening') ||
                dua.category.toLowerCase().contains('night'),
          )
          .toList();

      for (final dua in eveningDuas.take(1)) {
        suggestions.add(
          SmartSuggestion(
            duaId: dua.id,
            type: SuggestionType.timeBased,
            confidence: 0.7,
            reason: 'Evening Du\'as for peace and protection',
            timestamp: now,
            trigger: SuggestionTrigger.timePattern,
          ),
        );
      }
    }

    return suggestions;
  }

  bool _isNearPrayerTime(PrayerTimes prayerTimes) {
    final nextPrayer = prayerTimes.nextPrayer;

    if (nextPrayer != null) {
      return nextPrayer.remaining.inMinutes <= 30;
    }

    return false;
  }

  bool _isEvening(DateTime time) {
    return time.hour >= 17 && time.hour <= 21;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String channelId,
    String? payload,
  }) async {
    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          _getChannelName(channelId),
          channelDescription: _getChannelDescription(channelId),
          importance: _getChannelImportance(channelId),
          priority: Priority.high,
          showWhen: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _scheduleRepeatingNotification({
    required int id,
    required String title,
    required String body,
    required _TimeOfDay time,
    required String channelId,
    String? payload,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(time),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          _getChannelName(channelId),
          channelDescription: _getChannelDescription(channelId),
          importance: _getChannelImportance(channelId),
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(_TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  String _getChannelName(String channelId) {
    switch (channelId) {
      case _prayerChannelId:
        return 'Prayer Reminders';
      case _duaChannelId:
        return 'Du\'a Suggestions';
      case _habitChannelId:
        return 'Habit Tracking';
      case _contextChannelId:
        return 'Contextual Suggestions';
      default:
        return 'Du\'a Notifications';
    }
  }

  String _getChannelDescription(String channelId) {
    switch (channelId) {
      case _prayerChannelId:
        return 'Notifications for prayer times and related Du\'as';
      case _duaChannelId:
        return 'Smart suggestions for relevant Du\'as';
      case _habitChannelId:
        return 'Reminders for daily Du\'a practice';
      case _contextChannelId:
        return 'Location and time-based Du\'a recommendations';
      default:
        return 'General Du\'a notifications';
    }
  }

  Importance _getChannelImportance(String channelId) {
    switch (channelId) {
      case _prayerChannelId:
        return Importance.high;
      case _duaChannelId:
        return Importance.defaultImportance;
      case _habitChannelId:
        return Importance.defaultImportance;
      case _contextChannelId:
        return Importance.low;
      default:
        return Importance.defaultImportance;
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
}
