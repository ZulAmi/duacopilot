import 'dart:async';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../core/storage/secure_storage_service.dart';
import '../../../domain/entities/context_entity.dart' hide PrayerType;
import '../../../domain/entities/qibla_entity.dart';

/// PrayerTrackerService - Comprehensive prayer tracking and reminder system
class PrayerTrackerService {
  static const String _trackerStorageKey = 'prayer_tracker_data';
  static const String _remindersStorageKey = 'prayer_reminders';

  final SecureStorageService _secureStorage;
  final FlutterLocalNotificationsPlugin _notifications;

  final StreamController<PrayerTracker> _trackerController = StreamController<PrayerTracker>.broadcast();
  final StreamController<Map<PrayerType, PrayerCompletion>> _prayersController =
      StreamController<Map<PrayerType, PrayerCompletion>>.broadcast();

  PrayerTracker? _currentTracker;
  List<PrayerReminder> _reminders = [];
  Timer? _reminderTimer;

  PrayerTrackerService(this._secureStorage, this._notifications);

  /// Get prayer tracker stream
  Stream<PrayerTracker> get trackerStream => _trackerController.stream;

  /// Get prayers completion stream
  Stream<Map<PrayerType, PrayerCompletion>> get prayersStream => _prayersController.stream;

  /// Initialize prayer tracker service
  Future<bool> initialize() async {
    try {
      // Initialize notifications
      await _initializeNotifications();

      // Load today's tracker or create new
      await _loadOrCreateTodayTracker();

      // Load reminders and set up scheduling
      await _loadReminders();
      await _scheduleReminders();

      // Start reminder timer for real-time updates
      _startReminderTimer();

      return true;
    } catch (e) {
      print('Failed to initialize PrayerTrackerService: $e');
      return false;
    }
  }

  /// Initialize local notifications
  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notifications.initialize(initSettings);
  }

  /// Load or create today's prayer tracker
  Future<void> _loadOrCreateTodayTracker() async {
    try {
      final today = DateTime.now();
      final todayKey = _getTodayKey(today);

      final trackerJson = await _secureStorage.getValue('${_trackerStorageKey}_$todayKey');

      if (trackerJson != null) {
        _currentTracker = PrayerTracker.fromJson(jsonDecode(trackerJson));
      } else {
        await _createTodayTracker(today);
      }

      if (_currentTracker != null) {
        _trackerController.add(_currentTracker!);
        _prayersController.add(_currentTracker!.prayers);
      }
    } catch (e) {
      print('Failed to load today tracker: $e');
      await _createTodayTracker(DateTime.now());
    }
  }

  /// Create new tracker for today
  Future<void> _createTodayTracker(DateTime date) async {
    try {
      final trackerId = 'tracker_${date.millisecondsSinceEpoch}';

      // Get prayer times for today (would integrate with prayer times API)
      final prayerTimes = await _getPrayerTimes(date);

      final prayers = <PrayerType, PrayerCompletion>{
        PrayerType.fajr: PrayerCompletion(
          type: PrayerType.fajr,
          scheduledTime: prayerTimes.fajr,
          status: PrayerCompletionStatus.missed,
        ),
        PrayerType.dhuhr: PrayerCompletion(
          type: PrayerType.dhuhr,
          scheduledTime: prayerTimes.dhuhr,
          status: PrayerCompletionStatus.missed,
        ),
        PrayerType.asr: PrayerCompletion(
          type: PrayerType.asr,
          scheduledTime: prayerTimes.asr,
          status: PrayerCompletionStatus.missed,
        ),
        PrayerType.maghrib: PrayerCompletion(
          type: PrayerType.maghrib,
          scheduledTime: prayerTimes.maghrib,
          status: PrayerCompletionStatus.missed,
        ),
        PrayerType.isha: PrayerCompletion(
          type: PrayerType.isha,
          scheduledTime: prayerTimes.isha,
          status: PrayerCompletionStatus.missed,
        ),
      };

      _currentTracker = PrayerTracker(
        id: trackerId,
        userId: 'current_user', // In production, get from user service
        date: date,
        prayers: prayers,
        dailyStats: _calculateDailyStats(prayers),
      );

      await _saveTracker();
    } catch (e) {
      print('Failed to create today tracker: $e');
    }
  }

  /// Get prayer times (mock implementation - integrate with real API)
  Future<PrayerTimes> _getPrayerTimes(DateTime date) async {
    // This would integrate with a prayer times API like Al-Quran Cloud
    // For now, return mock times based on approximate calculations
    final baseHour = 6; // Fajr base hour

    return PrayerTimes(
      fajr: DateTime(date.year, date.month, date.day, baseHour),
      sunrise: DateTime(date.year, date.month, date.day, baseHour + 1, 30),
      dhuhr: DateTime(date.year, date.month, date.day, 12, 15),
      asr: DateTime(date.year, date.month, date.day, 15, 30),
      maghrib: DateTime(date.year, date.month, date.day, 18, 45),
      isha: DateTime(date.year, date.month, date.day, 20, 15),
    );
  }

  /// Calculate daily prayer statistics
  PrayerStats _calculateDailyStats(Map<PrayerType, PrayerCompletion> prayers) {
    final total = prayers.length;
    final completed = prayers.values.where((p) => p.status == PrayerCompletionStatus.completed).length;
    final missed = prayers.values.where((p) => p.status == PrayerCompletionStatus.missed).length;

    final completionRate = total > 0 ? (completed / total) * 100 : 0.0;

    final prayerCounts = <PrayerType, int>{};
    for (final prayer in prayers.values) {
      if (prayer.status == PrayerCompletionStatus.completed) {
        prayerCounts[prayer.type] = 1;
      }
    }

    final totalTime = prayers.values
        .where((p) => p.duration != null)
        .fold(Duration.zero, (sum, p) => sum + p.duration!);

    return PrayerStats(
      totalPrayers: total,
      completedPrayers: completed,
      missedPrayers: missed,
      completionRate: completionRate,
      totalPrayerTime: totalTime,
      prayerCounts: prayerCounts,
    );
  }

  /// Mark prayer as completed
  Future<void> markPrayerCompleted({
    required PrayerType prayerType,
    DateTime? completedAt,
    String? location,
    bool isInCongregation = false,
    Duration? duration,
    String? notes,
    double? qiblaAccuracy,
  }) async {
    if (_currentTracker == null) return;

    try {
      final completion = _currentTracker!.prayers[prayerType];
      if (completion == null) return;

      final updatedCompletion = completion.copyWith(
        completedAt: completedAt ?? DateTime.now(),
        status: PrayerCompletionStatus.completed,
        location: location,
        isInCongregation: isInCongregation,
        duration: duration,
        notes: notes,
        qiblaAccuracy: qiblaAccuracy,
      );

      final updatedPrayers = Map<PrayerType, PrayerCompletion>.from(_currentTracker!.prayers);
      updatedPrayers[prayerType] = updatedCompletion;

      _currentTracker = _currentTracker!.copyWith(
        prayers: updatedPrayers,
        dailyStats: _calculateDailyStats(updatedPrayers),
      );

      await _saveTracker();

      _trackerController.add(_currentTracker!);
      _prayersController.add(_currentTracker!.prayers);

      // Cancel reminder for this prayer
      await _cancelPrayerReminder(prayerType);
    } catch (e) {
      print('Failed to mark prayer completed: $e');
    }
  }

  /// Mark prayer as missed
  Future<void> markPrayerMissed({required PrayerType prayerType, String? reason}) async {
    if (_currentTracker == null) return;

    try {
      final completion = _currentTracker!.prayers[prayerType];
      if (completion == null) return;

      final updatedCompletion = completion.copyWith(status: PrayerCompletionStatus.missed, notes: reason);

      final updatedPrayers = Map<PrayerType, PrayerCompletion>.from(_currentTracker!.prayers);
      updatedPrayers[prayerType] = updatedCompletion;

      _currentTracker = _currentTracker!.copyWith(
        prayers: updatedPrayers,
        dailyStats: _calculateDailyStats(updatedPrayers),
      );

      await _saveTracker();

      _trackerController.add(_currentTracker!);
      _prayersController.add(_currentTracker!.prayers);
    } catch (e) {
      print('Failed to mark prayer missed: $e');
    }
  }

  /// Schedule prayer to make up later
  Future<void> scheduleMakeupPrayer({required PrayerType prayerType, required DateTime makeupTime}) async {
    if (_currentTracker == null) return;

    try {
      final completion = _currentTracker!.prayers[prayerType];
      if (completion == null) return;

      final updatedCompletion = completion.copyWith(status: PrayerCompletionStatus.makeup);

      final updatedPrayers = Map<PrayerType, PrayerCompletion>.from(_currentTracker!.prayers);
      updatedPrayers[prayerType] = updatedCompletion;

      _currentTracker = _currentTracker!.copyWith(
        prayers: updatedPrayers,
        dailyStats: _calculateDailyStats(updatedPrayers),
      );

      await _saveTracker();

      // Schedule makeup reminder
      await _scheduleMakeupReminder(prayerType, makeupTime);

      _trackerController.add(_currentTracker!);
      _prayersController.add(_currentTracker!.prayers);
    } catch (e) {
      print('Failed to schedule makeup prayer: $e');
    }
  }

  /// Add prayer reminder
  Future<void> addPrayerReminder({
    required PrayerType prayerType,
    required bool isEnabled,
    Duration? advanceNotification,
    String? customMessage,
  }) async {
    try {
      final reminder = PrayerReminder(
        id: 'reminder_${prayerType.name}_${DateTime.now().millisecondsSinceEpoch}',
        prayerType: prayerType,
        scheduledTime: await _getNextPrayerTime(prayerType),
        isEnabled: isEnabled,
        advanceNotification: advanceNotification ?? const Duration(minutes: 15),
        customMessage: customMessage,
        repeatType: ReminderRepeat.daily,
      );

      _reminders.add(reminder);
      await _saveReminders();

      if (isEnabled) {
        await _scheduleNotification(reminder);
      }
    } catch (e) {
      print('Failed to add prayer reminder: $e');
    }
  }

  /// Get next prayer time for a specific prayer type
  Future<DateTime> _getNextPrayerTime(PrayerType prayerType) async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final prayerTimes = await _getPrayerTimes(tomorrow);

    switch (prayerType) {
      case PrayerType.fajr:
        return prayerTimes.fajr;
      case PrayerType.dhuhr:
        return prayerTimes.dhuhr;
      case PrayerType.asr:
        return prayerTimes.asr;
      case PrayerType.maghrib:
        return prayerTimes.maghrib;
      case PrayerType.isha:
        return prayerTimes.isha;
    }
  }

  /// Schedule notification for prayer reminder
  Future<void> _scheduleNotification(PrayerReminder reminder) async {
    try {
      final scheduleTime = reminder.scheduledTime.subtract(reminder.advanceNotification ?? const Duration(minutes: 15));

      const androidDetails = AndroidNotificationDetails(
        'prayer_reminders',
        'Prayer Reminders',
        channelDescription: 'Notifications for prayer times',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('adhan'),
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'adhan.mp3',
      );

      const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

      final message = reminder.customMessage ?? 'It\'s time for ${_getPrayerDisplayName(reminder.prayerType)} prayer';

      await _notifications.zonedSchedule(
        reminder.hashCode,
        '🕌 Prayer Time',
        message,
        _convertToTZDateTime(scheduleTime),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      print('Failed to schedule notification: $e');
    }
  }

  /// Convert DateTime to TZDateTime (placeholder implementation)
  dynamic _convertToTZDateTime(DateTime dateTime) {
    // In production, use timezone package to convert properly
    return dateTime;
  }

  /// Get prayer display name
  String _getPrayerDisplayName(PrayerType prayerType) {
    switch (prayerType) {
      case PrayerType.fajr:
        return 'Fajr';
      case PrayerType.dhuhr:
        return 'Dhuhr';
      case PrayerType.asr:
        return 'Asr';
      case PrayerType.maghrib:
        return 'Maghrib';
      case PrayerType.isha:
        return 'Isha';
    }
  }

  /// Cancel prayer reminder notification
  Future<void> _cancelPrayerReminder(PrayerType prayerType) async {
    try {
      final reminder = _reminders.firstWhere(
        (r) => r.prayerType == prayerType,
        orElse: () => throw StateError('Reminder not found'),
      );

      await _notifications.cancel(reminder.hashCode);
    } catch (e) {
      print('Failed to cancel prayer reminder: $e');
    }
  }

  /// Schedule makeup prayer reminder
  Future<void> _scheduleMakeupReminder(PrayerType prayerType, DateTime makeupTime) async {
    final makeupReminder = PrayerReminder(
      id: 'makeup_${prayerType.name}_${makeupTime.millisecondsSinceEpoch}',
      prayerType: prayerType,
      scheduledTime: makeupTime,
      isEnabled: true,
      customMessage: 'Time for ${_getPrayerDisplayName(prayerType)} makeup prayer',
      repeatType: ReminderRepeat.none,
    );

    await _scheduleNotification(makeupReminder);
  }

  /// Load reminders from storage
  Future<void> _loadReminders() async {
    try {
      final remindersJson = await _secureStorage.getValue(_remindersStorageKey) ?? '[]';
      _reminders = (jsonDecode(remindersJson) as List).map((r) => PrayerReminder.fromJson(r)).toList();
    } catch (e) {
      print('Failed to load reminders: $e');
      _reminders = [];
    }
  }

  /// Save reminders to storage
  Future<void> _saveReminders() async {
    try {
      final remindersJson = jsonEncode(_reminders.map((r) => r.toJson()).toList());
      await _secureStorage.saveValue(_remindersStorageKey, remindersJson);
    } catch (e) {
      print('Failed to save reminders: $e');
    }
  }

  /// Schedule all active reminders
  Future<void> _scheduleReminders() async {
    for (final reminder in _reminders) {
      if (reminder.isEnabled) {
        await _scheduleNotification(reminder);
      }
    }
  }

  /// Start reminder timer for real-time updates
  void _startReminderTimer() {
    _reminderTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkPrayerTimes();
    });
  }

  /// Check prayer times and update statuses
  void _checkPrayerTimes() {
    if (_currentTracker == null) return;

    final now = DateTime.now();
    bool needsUpdate = false;

    final updatedPrayers = Map<PrayerType, PrayerCompletion>.from(_currentTracker!.prayers);

    for (final entry in updatedPrayers.entries) {
      final prayer = entry.value;

      // Auto-mark as missed if prayer time has passed and not completed
      if (prayer.status != PrayerCompletionStatus.completed &&
          prayer.status != PrayerCompletionStatus.makeup &&
          now.isAfter(_getNextPrayerDeadline(prayer))) {
        updatedPrayers[entry.key] = prayer.copyWith(status: PrayerCompletionStatus.missed);
        needsUpdate = true;
      }
    }

    if (needsUpdate) {
      _currentTracker = _currentTracker!.copyWith(
        prayers: updatedPrayers,
        dailyStats: _calculateDailyStats(updatedPrayers),
      );

      _trackerController.add(_currentTracker!);
      _prayersController.add(_currentTracker!.prayers);
      _saveTracker();
    }
  }

  /// Get deadline for prayer (when it becomes missed)
  DateTime _getNextPrayerDeadline(PrayerCompletion prayer) {
    // Each prayer has until the next prayer time to be completed
    switch (prayer.type) {
      case PrayerType.fajr:
        return prayer.scheduledTime.add(const Duration(hours: 1));
      case PrayerType.dhuhr:
        return prayer.scheduledTime.add(const Duration(hours: 2));
      case PrayerType.asr:
        return prayer.scheduledTime.add(const Duration(hours: 1, minutes: 30));
      case PrayerType.maghrib:
        return prayer.scheduledTime.add(const Duration(minutes: 45));
      case PrayerType.isha:
        return prayer.scheduledTime.add(const Duration(hours: 2));
    }
  }

  /// Save current tracker to storage
  Future<void> _saveTracker() async {
    if (_currentTracker == null) return;

    try {
      final todayKey = _getTodayKey(_currentTracker!.date);
      final trackerJson = jsonEncode(_currentTracker!.toJson());
      await _secureStorage.saveValue('${_trackerStorageKey}_$todayKey', trackerJson);
    } catch (e) {
      print('Failed to save tracker: $e');
    }
  }

  /// Get today's storage key
  String _getTodayKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Get current prayer tracker
  PrayerTracker? get currentTracker => _currentTracker;

  /// Get prayer reminders
  List<PrayerReminder> get reminders => _reminders;

  /// Get prayer completion for specific prayer
  PrayerCompletion? getPrayerCompletion(PrayerType prayerType) {
    return _currentTracker?.prayers[prayerType];
  }

  /// Check if prayer is completed
  bool isPrayerCompleted(PrayerType prayerType) {
    final completion = getPrayerCompletion(prayerType);
    return completion?.status == PrayerCompletionStatus.completed;
  }

  /// Get today's completion rate
  double getTodayCompletionRate() {
    return _currentTracker?.dailyStats.completionRate ?? 0.0;
  }

  /// Dispose service and clean up resources
  void dispose() {
    _trackerController.close();
    _prayersController.close();
    _reminderTimer?.cancel();
  }
}
