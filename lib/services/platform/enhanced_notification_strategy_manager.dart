import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../core/logging/app_logger.dart';
import '../../domain/entities/dua_entity.dart';
import 'platform_optimization_service.dart';

/// Enhanced notification strategy manager with platform-specific optimizations
class EnhancedNotificationStrategyManager {
  static EnhancedNotificationStrategyManager? _instance;
  static EnhancedNotificationStrategyManager get instance => _instance ??= EnhancedNotificationStrategyManager._();

  EnhancedNotificationStrategyManager._();

  final PlatformOptimizationService _platformService = PlatformOptimizationService.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // Notification configuration
  final Map<String, dynamic> _notificationConfig = {};
  bool _isInitialized = false;
  int _notificationId = 0;

  // Platform-specific notification strategies
  late NotificationStrategy _currentStrategy;

  /// Initialize notification strategy manager
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info(
        '🔔 Initializing enhanced notification strategy manager...',
      );

      // Initialize platform-specific notifications
      await _initializePlatformNotifications();

      // Select optimal notification strategy
      _selectNotificationStrategy();

      // Configure notification channels
      await _setupNotificationChannels();

      _isInitialized = true;
      AppLogger.info('✅ Enhanced notification strategy manager initialized');
    } catch (e) {
      AppLogger.error('❌ Failed to initialize notification manager: $e');
      rethrow;
    }
  }

  Future<void> _initializePlatformNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      requestCriticalPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions
    await _requestNotificationPermissions();
  }

  Future<void> _requestNotificationPermissions() async {
    final platformType = _platformService.platformType;

    switch (platformType) {
      case PlatformType.android:
        await _requestAndroidPermissions();
        break;
      case PlatformType.ios:
        await _requestIOSPermissions();
        break;
      default:
        break;
    }
  }

  Future<void> _requestAndroidPermissions() async {
    final androidImplementation =
        _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final granted = await androidImplementation.requestNotificationsPermission();
      AppLogger.info(
        '🤖 Android notifications permission: ${granted == true ? 'granted' : 'denied'}',
      );

      // Request exact alarms permission for Android 12+
      final exactAlarmsGranted = await androidImplementation.requestExactAlarmsPermission();
      AppLogger.info(
        '⏰ Android exact alarms permission: ${exactAlarmsGranted == true ? 'granted' : 'denied'}',
      );
    }
  }

  Future<void> _requestIOSPermissions() async {
    final iosImplementation =
        _localNotifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    if (iosImplementation != null) {
      final granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
        critical: false,
      );
      AppLogger.info(
        '🍎 iOS notifications permission: ${granted == true ? 'granted' : 'denied'}',
      );
    }
  }

  void _selectNotificationStrategy() {
    final platformType = _platformService.platformType;
    final capabilities = _platformService.deviceInfo.capabilities;

    switch (platformType) {
      case PlatformType.ios:
        _currentStrategy = IOSNotificationStrategy(capabilities);
        break;
      case PlatformType.android:
        _currentStrategy = AndroidNotificationStrategy(capabilities);
        break;
      case PlatformType.web:
        _currentStrategy = WebNotificationStrategy(capabilities);
        break;
      default:
        _currentStrategy = DefaultNotificationStrategy(capabilities);
        break;
    }

    AppLogger.info(
      '📓 Selected notification strategy: ${_currentStrategy.runtimeType}',
    );
  }

  Future<void> _setupNotificationChannels() async {
    final channels = _currentStrategy.getNotificationChannels();

    for (final channel in channels) {
      await _createNotificationChannel(channel);
    }

    AppLogger.info('📢 Setup ${channels.length} notification channels');
  }

  Future<void> _createNotificationChannel(
    NotificationChannelConfig channel,
  ) async {
    final platformType = _platformService.platformType;

    if (platformType == PlatformType.android) {
      final androidImplementation =
          _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final androidChannel = AndroidNotificationChannel(
          channel.id,
          channel.name,
          description: channel.description,
          importance: _mapImportance(channel.importance),
          enableVibration: channel.enableVibration,
          playSound: channel.playSound,
          sound: channel.soundPath != null ? RawResourceAndroidNotificationSound(channel.soundPath!) : null,
          enableLights: channel.enableLights,
          ledColor: channel.ledColor,
        );

        await androidImplementation.createNotificationChannel(androidChannel);
        AppLogger.debug('🔔 Created Android channel: ${channel.id}');
      }
    }
  }

  Importance _mapImportance(ChannelImportance importance) {
    switch (importance) {
      case ChannelImportance.min:
        return Importance.min;
      case ChannelImportance.low:
        return Importance.low;
      case ChannelImportance.defaultImportance:
        return Importance.defaultImportance;
      case ChannelImportance.high:
        return Importance.high;
      case ChannelImportance.max:
        return Importance.max;
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    AppLogger.info('🔔 Notification tapped: ${response.payload}');

    // Handle notification tap based on payload
    if (response.payload != null) {
      _handleNotificationPayload(response.payload!);
    }
  }

  void _handleNotificationPayload(String payload) {
    try {
      // Parse payload and navigate to appropriate screen
      final parts = payload.split(':');
      final action = parts.isNotEmpty ? parts[0] : 'unknown';
      final data = parts.length > 1 ? parts[1] : '';

      switch (action) {
        case 'dua':
          AppLogger.info('📖 Opening Du\'a: $data');
          // Navigate to specific dua
          break;
        case 'prayer_reminder':
          AppLogger.info('🧘 Opening prayer reminder: $data');
          // Navigate to prayer times
          break;
        case 'search':
          AppLogger.info('🔍 Opening search: $data');
          // Navigate to search with query
          break;
        default:
          AppLogger.info('🏠 Opening home screen');
          // Navigate to home
          break;
      }
    } catch (e) {
      AppLogger.warning('⚠️ Failed to handle notification payload: $e');
    }
  }

  /// Show platform-optimized notification
  Future<void> showOptimizedNotification({
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
    NotificationPriority priority = NotificationPriority.normal,
    String? channelId,
    DuaEntity? dua,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final notificationId = _getNextNotificationId();
      final effectiveChannelId = channelId ?? 'general';

      // Build platform-specific notification
      final notification = await _currentStrategy.buildNotification(
        id: notificationId,
        title: title,
        body: body,
        channelId: effectiveChannelId,
        priority: priority,
        imageUrl: imageUrl,
        data: data,
        dua: dua,
      );

      // Show notification
      await _localNotifications.show(
        notificationId,
        notification.title,
        notification.body,
        notification.details,
        payload: notification.payload,
      );

      AppLogger.info('🔔 Showed notification: $title');
      AppLogger.debug(
        '📓 Channel: $effectiveChannelId, Priority: ${priority.name}',
      );
    } catch (e) {
      AppLogger.error('❌ Failed to show notification: $e');
    }
  }

  /// Show Du'a reminder notification
  Future<void> showDuaReminder({
    required DuaEntity dua,
    String? customMessage,
    NotificationPriority priority = NotificationPriority.normal,
  }) async {
    final title = customMessage ?? 'Time for Du\'a';
    final body = dua.category.isNotEmpty ? dua.category : 'Don\'t forget your supplications';

    await showOptimizedNotification(
      title: title,
      body: body,
      channelId: 'dua_reminders',
      priority: priority,
      dua: dua,
      data: {'type': 'dua_reminder', 'duaId': dua.id, 'category': dua.category},
    );
  }

  /// Show prayer time notification
  Future<void> showPrayerTimeNotification({
    required String prayerName,
    required DateTime prayerTime,
    String? customMessage,
  }) async {
    final title = customMessage ?? 'Prayer Time';
    final body = 'Time for $prayerName prayer';

    await showOptimizedNotification(
      title: title,
      body: body,
      channelId: 'prayer_times',
      priority: NotificationPriority.high,
      data: {
        'type': 'prayer_time',
        'prayerName': prayerName,
        'prayerTime': prayerTime.toIso8601String(),
      },
    );
  }

  /// Show Islamic event notification
  Future<void> showIslamicEventNotification({
    required String eventName,
    required DateTime eventDate,
    String? description,
  }) async {
    final title = 'Islamic Event';
    final body = description ?? 'Today is $eventName';

    await showOptimizedNotification(
      title: title,
      body: body,
      channelId: 'islamic_events',
      priority: NotificationPriority.normal,
      data: {
        'type': 'islamic_event',
        'eventName': eventName,
        'eventDate': eventDate.toIso8601String(),
      },
    );
  }

  /// Schedule notification for later delivery
  Future<void> scheduleNotification({
    required DateTime scheduledDate,
    required String title,
    required String body,
    String? channelId,
    NotificationPriority priority = NotificationPriority.normal,
    Map<String, dynamic>? data,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final notificationId = _getNextNotificationId();
      final effectiveChannelId = channelId ?? 'general';

      // Build platform-specific notification
      final notification = await _currentStrategy.buildNotification(
        id: notificationId,
        title: title,
        body: body,
        channelId: effectiveChannelId,
        priority: priority,
        data: data,
      );

      // For now, just show immediate notification
      // TODO: Implement proper timezone-aware scheduling
      await _localNotifications.show(
        notificationId,
        notification.title,
        notification.body,
        notification.details,
        payload: notification.payload,
      );

      AppLogger.info(
        '⏰ Scheduled notification: $title for ${scheduledDate.toLocal()}',
      );
    } catch (e) {
      AppLogger.error('❌ Failed to schedule notification: $e');
    }
  }

  /// Cancel notification by ID
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
    AppLogger.info('❌ Cancelled notification: $id');
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
    AppLogger.info('❌ Cancelled all notifications');
  }

  int _getNextNotificationId() {
    _notificationId++;
    if (_notificationId > 999999) {
      _notificationId = 1;
    }
    return _notificationId;
  }

  /// Get current notification configuration
  Map<String, dynamic> getCurrentConfiguration() {
    return Map.unmodifiable(_notificationConfig);
  }

  /// Get optimal notification configuration
  Map<String, dynamic> getOptimalConfiguration() {
    return _currentStrategy.getOptimalConfiguration();
  }

  /// Check if notifications are supported
  bool get areNotificationsSupported => _platformService.isFeatureSupported('supportsNotifications');

  /// Cleanup resources
  Future<void> dispose() async {
    _isInitialized = false;
    _notificationConfig.clear();
    AppLogger.info('🧹 Enhanced notification strategy manager disposed');
  }
}

/// Base notification strategy
abstract class NotificationStrategy {
  final Map<String, dynamic> capabilities;

  NotificationStrategy(this.capabilities);

  List<NotificationChannelConfig> getNotificationChannels();
  Future<PlatformNotification> buildNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    NotificationPriority priority = NotificationPriority.normal,
    String? imageUrl,
    Map<String, dynamic>? data,
    DuaEntity? dua,
  });
  Map<String, dynamic> getOptimalConfiguration();
}

/// iOS-specific notification strategy
class IOSNotificationStrategy extends NotificationStrategy {
  IOSNotificationStrategy(super.capabilities);

  @override
  List<NotificationChannelConfig> getNotificationChannels() {
    return [
      NotificationChannelConfig(
        id: 'general',
        name: 'General',
        description: 'General app notifications',
        importance: ChannelImportance.defaultImportance,
      ),
      NotificationChannelConfig(
        id: 'dua_reminders',
        name: 'Du\'a Reminders',
        description: 'Reminders for daily Du\'as',
        importance: ChannelImportance.high,
        enableVibration: true,
        playSound: true,
      ),
      NotificationChannelConfig(
        id: 'prayer_times',
        name: 'Prayer Times',
        description: 'Prayer time notifications',
        importance: ChannelImportance.high,
        enableVibration: true,
        playSound: true,
      ),
      NotificationChannelConfig(
        id: 'islamic_events',
        name: 'Islamic Events',
        description: 'Islamic calendar events and holidays',
        importance: ChannelImportance.defaultImportance,
      ),
    ];
  }

  @override
  Future<PlatformNotification> buildNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    NotificationPriority priority = NotificationPriority.normal,
    String? imageUrl,
    Map<String, dynamic>? data,
    DuaEntity? dua,
  }) async {
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: channelId == 'prayer_times' ? 'prayer_notification.aiff' : null,
      badgeNumber: 1,
      threadIdentifier: channelId,
      categoryIdentifier: _getCategoryIdentifier(channelId),
    );

    final details = NotificationDetails(iOS: iosDetails);
    final payload = _buildPayload(data, dua);

    return PlatformNotification(
      id: id,
      title: title,
      body: body,
      details: details,
      payload: payload,
    );
  }

  String _getCategoryIdentifier(String channelId) {
    switch (channelId) {
      case 'dua_reminders':
        return 'DUA_REMINDER_CATEGORY';
      case 'prayer_times':
        return 'PRAYER_TIME_CATEGORY';
      case 'islamic_events':
        return 'ISLAMIC_EVENT_CATEGORY';
      default:
        return 'GENERAL_CATEGORY';
    }
  }

  @override
  Map<String, dynamic> getOptimalConfiguration() {
    return {
      'soundEnabled': true,
      'badgeEnabled': true,
      'alertEnabled': true,
      'criticalAlertsEnabled': false,
      'groupingEnabled': true,
      'categoryActionsEnabled': true,
    };
  }

  String? _buildPayload(Map<String, dynamic>? data, DuaEntity? dua) {
    if (dua != null) {
      return 'dua:${dua.id}';
    }

    if (data != null) {
      final type = data['type'] as String?;
      if (type != null) {
        switch (type) {
          case 'prayer_time':
            return 'prayer_reminder:${data['prayerName']}';
          case 'islamic_event':
            return 'islamic_event:${data['eventName']}';
          default:
            return type;
        }
      }
    }

    return null;
  }
}

/// Android-specific notification strategy
class AndroidNotificationStrategy extends NotificationStrategy {
  AndroidNotificationStrategy(super.capabilities);

  @override
  List<NotificationChannelConfig> getNotificationChannels() {
    return [
      NotificationChannelConfig(
        id: 'general',
        name: 'General',
        description: 'General app notifications',
        importance: ChannelImportance.defaultImportance,
      ),
      NotificationChannelConfig(
        id: 'dua_reminders',
        name: 'Du\'a Reminders',
        description: 'Reminders for daily Du\'as',
        importance: ChannelImportance.high,
        enableVibration: true,
        playSound: true,
        ledColor: const Color(0xFF00FF00),
      ),
      NotificationChannelConfig(
        id: 'prayer_times',
        name: 'Prayer Times',
        description: 'Prayer time notifications',
        importance: ChannelImportance.high,
        enableVibration: true,
        playSound: true,
        soundPath: 'prayer_notification',
        ledColor: const Color(0xFF0000FF),
      ),
      NotificationChannelConfig(
        id: 'islamic_events',
        name: 'Islamic Events',
        description: 'Islamic calendar events and holidays',
        importance: ChannelImportance.defaultImportance,
        enableLights: true,
        ledColor: const Color(0xFFFFD700),
      ),
    ];
  }

  @override
  Future<PlatformNotification> buildNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    NotificationPriority priority = NotificationPriority.normal,
    String? imageUrl,
    Map<String, dynamic>? data,
    DuaEntity? dua,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance: _mapPriorityToImportance(priority),
      priority: _mapPriorityToPriority(priority),
      icon: '@mipmap/ic_launcher',
      largeIcon: imageUrl != null ? const DrawableResourceAndroidBitmap('@mipmap/ic_launcher') : null,
      styleInformation: _getStyleInformation(body, dua),
      actions: _getNotificationActions(channelId),
      groupKey: channelId,
      setAsGroupSummary: false,
      autoCancel: true,
      ongoing: false,
      enableVibration: channelId == 'prayer_times' || channelId == 'dua_reminders',
      vibrationPattern: _getVibrationPattern(channelId),
    );

    final details = NotificationDetails(android: androidDetails);
    final payload = _buildPayload(data, dua);

    return PlatformNotification(
      id: id,
      title: title,
      body: body,
      details: details,
      payload: payload,
    );
  }

  String _getChannelName(String channelId) {
    switch (channelId) {
      case 'dua_reminders':
        return 'Du\'a Reminders';
      case 'prayer_times':
        return 'Prayer Times';
      case 'islamic_events':
        return 'Islamic Events';
      default:
        return 'General';
    }
  }

  String _getChannelDescription(String channelId) {
    switch (channelId) {
      case 'dua_reminders':
        return 'Reminders for daily Du\'as';
      case 'prayer_times':
        return 'Prayer time notifications';
      case 'islamic_events':
        return 'Islamic calendar events and holidays';
      default:
        return 'General app notifications';
    }
  }

  Importance _mapPriorityToImportance(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Importance.low;
      case NotificationPriority.normal:
        return Importance.defaultImportance;
      case NotificationPriority.high:
        return Importance.high;
      case NotificationPriority.urgent:
        return Importance.max;
    }
  }

  Priority _mapPriorityToPriority(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Priority.low;
      case NotificationPriority.normal:
        return Priority.defaultPriority;
      case NotificationPriority.high:
        return Priority.high;
      case NotificationPriority.urgent:
        return Priority.max;
    }
  }

  StyleInformation? _getStyleInformation(String body, DuaEntity? dua) {
    if (dua != null && dua.translation.isNotEmpty) {
      return BigTextStyleInformation(
        body,
        htmlFormatBigText: false,
        contentTitle: dua.category,
        htmlFormatContentTitle: false,
        summaryText: 'Du\'a Copilot',
        htmlFormatSummaryText: false,
      );
    }

    return BigTextStyleInformation(body);
  }

  List<AndroidNotificationAction>? _getNotificationActions(String channelId) {
    switch (channelId) {
      case 'dua_reminders':
        return [
          const AndroidNotificationAction(
            'read_dua',
            'Read Du\'a',
            icon: DrawableResourceAndroidBitmap('@drawable/ic_book'),
          ),
          const AndroidNotificationAction(
            'play_audio',
            'Play Audio',
            icon: DrawableResourceAndroidBitmap('@drawable/ic_play'),
          ),
        ];
      case 'prayer_times':
        return [
          const AndroidNotificationAction(
            'view_prayer_times',
            'View Times',
            icon: DrawableResourceAndroidBitmap('@drawable/ic_schedule'),
          ),
        ];
      default:
        return null;
    }
  }

  Int64List? _getVibrationPattern(String channelId) {
    switch (channelId) {
      case 'prayer_times':
        return Int64List.fromList([0, 1000, 500, 1000]);
      case 'dua_reminders':
        return Int64List.fromList([0, 500, 250, 500]);
      default:
        return null;
    }
  }

  @override
  Map<String, dynamic> getOptimalConfiguration() {
    final apiLevel = capabilities['apiLevel'] as int? ?? 21;

    return {
      'channelGroupsEnabled': apiLevel >= 26,
      'bigTextStyleEnabled': apiLevel >= 16,
      'expandableNotificationsEnabled': apiLevel >= 16,
      'notificationActionsEnabled': apiLevel >= 19,
      'customSoundsEnabled': true,
      'vibrationPatternsEnabled': true,
      'ledLightsEnabled': true,
    };
  }

  String? _buildPayload(Map<String, dynamic>? data, DuaEntity? dua) {
    if (dua != null) {
      return 'dua:${dua.id}';
    }

    if (data != null) {
      final type = data['type'] as String?;
      if (type != null) {
        switch (type) {
          case 'prayer_time':
            return 'prayer_reminder:${data['prayerName']}';
          case 'islamic_event':
            return 'islamic_event:${data['eventName']}';
          default:
            return type;
        }
      }
    }

    return null;
  }
}

/// Web-specific notification strategy
class WebNotificationStrategy extends NotificationStrategy {
  WebNotificationStrategy(super.capabilities);

  @override
  List<NotificationChannelConfig> getNotificationChannels() {
    return [
      NotificationChannelConfig(
        id: 'general',
        name: 'General',
        description: 'General app notifications',
        importance: ChannelImportance.defaultImportance,
      ),
    ];
  }

  @override
  Future<PlatformNotification> buildNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    NotificationPriority priority = NotificationPriority.normal,
    String? imageUrl,
    Map<String, dynamic>? data,
    DuaEntity? dua,
  }) async {
    // Web notifications are handled differently
    final details = const NotificationDetails();

    return PlatformNotification(
      id: id,
      title: title,
      body: body,
      details: details,
      payload: null,
    );
  }

  @override
  Map<String, dynamic> getOptimalConfiguration() {
    return {
      'webPushEnabled': true,
      'browserNotificationsEnabled': true,
      'serviceWorkerEnabled': true,
    };
  }
}

/// Default notification strategy
class DefaultNotificationStrategy extends NotificationStrategy {
  DefaultNotificationStrategy(super.capabilities);

  @override
  List<NotificationChannelConfig> getNotificationChannels() {
    return [
      NotificationChannelConfig(
        id: 'general',
        name: 'General',
        description: 'General app notifications',
        importance: ChannelImportance.defaultImportance,
      ),
    ];
  }

  @override
  Future<PlatformNotification> buildNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    NotificationPriority priority = NotificationPriority.normal,
    String? imageUrl,
    Map<String, dynamic>? data,
    DuaEntity? dua,
  }) async {
    const details = NotificationDetails();

    return PlatformNotification(
      id: id,
      title: title,
      body: body,
      details: details,
      payload: null,
    );
  }

  @override
  Map<String, dynamic> getOptimalConfiguration() {
    return {'basicNotificationsEnabled': false};
  }
}

/// Notification channel configuration
class NotificationChannelConfig {
  final String id;
  final String name;
  final String description;
  final ChannelImportance importance;
  final bool enableVibration;
  final bool playSound;
  final String? soundPath;
  final bool enableLights;
  final Color? ledColor;

  NotificationChannelConfig({
    required this.id,
    required this.name,
    required this.description,
    this.importance = ChannelImportance.defaultImportance,
    this.enableVibration = false,
    this.playSound = true,
    this.soundPath,
    this.enableLights = false,
    this.ledColor,
  });
}

/// Channel importance levels
enum ChannelImportance { min, low, defaultImportance, high, max }

/// Platform notification wrapper
class PlatformNotification {
  final int id;
  final String title;
  final String body;
  final NotificationDetails details;
  final String? payload;

  PlatformNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.details,
    this.payload,
  });
}
