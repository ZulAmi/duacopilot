import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/logging/app_logger.dart';
import '../secure_storage/secure_storage_service.dart';

/// Firebase Messaging Service for Scholar-Approved Content
/// Handles push notifications for new Du'as and content updates
class FirebaseMessagingService {
  static FirebaseMessagingService? _instance;
  static FirebaseMessagingService get instance => _instance ??= FirebaseMessagingService._();

  FirebaseMessagingService._();

  // Service dependencies
  late FirebaseMessaging _firebaseMessaging;
  late SecureStorageService _secureStorage;
  late SharedPreferences _prefs;

  // State management
  bool _isInitialized = false;
  String? _fcmToken;

  // Stream controllers for different notification types
  final _scholarApprovalController = StreamController<ScholarApprovalNotification>.broadcast();
  final _contentUpdateController = StreamController<ContentUpdateNotification>.broadcast();
  final _familyNotificationController = StreamController<FamilyNotification>.broadcast();
  final _systemNotificationController = StreamController<SystemNotification>.broadcast();

  // Public notification streams
  Stream<ScholarApprovalNotification> get scholarApprovalStream => _scholarApprovalController.stream;
  Stream<ContentUpdateNotification> get contentUpdateStream => _contentUpdateController.stream;
  Stream<FamilyNotification> get familyNotificationStream => _familyNotificationController.stream;
  Stream<SystemNotification> get systemNotificationStream => _systemNotificationController.stream;

  // Notification preferences
  bool _scholarApprovalEnabled = true;
  bool _contentUpdateEnabled = true;
  bool _familyNotificationsEnabled = true;
  bool _systemNotificationsEnabled = true;

  /// Initialize Firebase Messaging service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('🔄 Initializing Firebase Messaging Service...');

      _firebaseMessaging = FirebaseMessaging.instance;
      _secureStorage = SecureStorageService.instance;
      await _secureStorage.initialize();

      _prefs = await SharedPreferences.getInstance();

      // Load notification preferences
      await _loadNotificationPreferences();

      // Request notification permissions
      await _requestPermissions();

      // Get FCM token
      await _getFCMToken();

      // Setup message handlers
      _setupMessageHandlers();

      // Setup token refresh listener
      _setupTokenRefreshListener();

      _isInitialized = true;
      AppLogger.info('✅ Firebase Messaging Service initialized');
    } catch (e) {
      AppLogger.error('❌ Failed to initialize Firebase Messaging: $e');
      rethrow;
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
          AppLogger.info('✅ Push notifications authorized');
          break;
        case AuthorizationStatus.provisional:
          AppLogger.info('âš ï¸ Push notifications provisionally authorized');
          break;
        case AuthorizationStatus.denied:
          AppLogger.warning('❌ Push notifications denied');
          break;
        case AuthorizationStatus.notDetermined:
          AppLogger.warning('âš ï¸ Push notification permission not determined');
          break;
      }

      // Store permission status
      await _prefs.setBool(
        'notification_permission_granted',
        settings.authorizationStatus == AuthorizationStatus.authorized,
      );
    } catch (e) {
      AppLogger.error('❌ Failed to request notification permissions: $e');
    }
  }

  /// Get FCM token for push notifications
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      if (_fcmToken != null) {
        AppLogger.info(
          '📱 FCM Token obtained: ${_fcmToken!.substring(0, 20)}...',
        );

        // Store token securely
        await _secureStorage.write('fcm_token', _fcmToken!);

        // TODO: Send token to server for targeting
        await _sendTokenToServer(_fcmToken!);
      } else {
        AppLogger.warning('âš ï¸ Failed to obtain FCM token');
      }
    } catch (e) {
      AppLogger.error('❌ Failed to get FCM token: $e');
    }
  }

  /// Setup message handlers for different app states
  void _setupMessageHandlers() {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppLogger.info(
        '📨 Foreground message received: ${message.notification?.title}',
      );
      _handleMessage(message, MessageSource.foreground);
    });

    // Handle messages when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppLogger.info(
        '📱 App opened from background message: ${message.notification?.title}',
      );
      _handleMessage(message, MessageSource.background);
    });

    // Handle messages when app is opened from terminated state
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        AppLogger.info(
          '🚀 App opened from terminated state message: ${message.notification?.title}',
        );
        _handleMessage(message, MessageSource.terminated);
      }
    });
  }

  /// Setup FCM token refresh listener
  void _setupTokenRefreshListener() {
    _firebaseMessaging.onTokenRefresh.listen((String token) {
      AppLogger.info('🔄 FCM Token refreshed');
      _fcmToken = token;
      _secureStorage.write('fcm_token', token);
      _sendTokenToServer(token);
    });
  }

  /// Handle incoming push messages
  void _handleMessage(RemoteMessage message, MessageSource source) {
    try {
      final data = message.data;
      final notificationType = data['type'] as String?;

      // Save notification for offline access
      _saveNotificationLocally(message, source);

      switch (notificationType) {
        case 'scholar_approval':
          if (_scholarApprovalEnabled) {
            _handleScholarApprovalNotification(message, source);
          }
          break;
        case 'content_update':
          if (_contentUpdateEnabled) {
            _handleContentUpdateNotification(message, source);
          }
          break;
        case 'family_notification':
          if (_familyNotificationsEnabled) {
            _handleFamilyNotification(message, source);
          }
          break;
        case 'system_notification':
          if (_systemNotificationsEnabled) {
            _handleSystemNotification(message, source);
          }
          break;
        default:
          AppLogger.debug('🔄 Unhandled notification type: $notificationType');
      }
    } catch (e) {
      AppLogger.error('❌ Failed to handle push message: $e');
    }
  }

  /// Handle scholar approval notifications
  void _handleScholarApprovalNotification(
    RemoteMessage message,
    MessageSource source,
  ) {
    try {
      final notification = ScholarApprovalNotification(
        id: message.data['id'] ?? message.messageId ?? '',
        duaId: message.data['dua_id'] ?? '',
        duaTitle: message.data['dua_title'] ?? message.notification?.title ?? '',
        duaText: message.data['dua_text'] ?? '',
        scholarName: message.data['scholar_name'] ?? '',
        scholarId: message.data['scholar_id'] ?? '',
        approvedAt: DateTime.tryParse(message.data['approved_at'] ?? '') ?? DateTime.now(),
        messageSource: source,
        notificationBody: message.notification?.body,
        imageUrl: message.notification?.android?.imageUrl,
      );

      _scholarApprovalController.add(notification);
      AppLogger.info(
        '🎓 Scholar approval notification processed: ${notification.duaTitle}',
      );
    } catch (e) {
      AppLogger.error('❌ Failed to handle scholar approval notification: $e');
    }
  }

  /// Handle content update notifications
  void _handleContentUpdateNotification(
    RemoteMessage message,
    MessageSource source,
  ) {
    try {
      final notification = ContentUpdateNotification(
        id: message.data['id'] ?? message.messageId ?? '',
        title: message.data['content_title'] ?? message.notification?.title ?? '',
        description: message.data['content_description'] ?? message.notification?.body ?? '',
        category: message.data['category'] ?? '',
        updateType: message.data['update_type'] ?? 'new_content',
        updatedAt: DateTime.tryParse(message.data['updated_at'] ?? '') ?? DateTime.now(),
        messageSource: source,
        imageUrl: message.notification?.android?.imageUrl,
        actionUrl: message.data['action_url'],
      );

      _contentUpdateController.add(notification);
      AppLogger.info(
        '📚 Content update notification processed: ${notification.title}',
      );
    } catch (e) {
      AppLogger.error('❌ Failed to handle content update notification: $e');
    }
  }

  /// Handle family notifications
  void _handleFamilyNotification(RemoteMessage message, MessageSource source) {
    try {
      final notification = FamilyNotification(
        id: message.data['id'] ?? message.messageId ?? '',
        familyId: message.data['family_id'] ?? '',
        fromMemberId: message.data['from_member_id'] ?? '',
        fromMemberName: message.data['from_member_name'] ?? '',
        notificationType: message.data['notification_type'] ?? '',
        title: message.data['family_title'] ?? message.notification?.title ?? '',
        message: message.data['family_message'] ?? message.notification?.body ?? '',
        timestamp: DateTime.tryParse(message.data['timestamp'] ?? '') ?? DateTime.now(),
        messageSource: source,
        data: message.data,
      );

      _familyNotificationController.add(notification);
      AppLogger.info(
        '👨‍👩‍👧‍👦 Family notification processed: ${notification.title}',
      );
    } catch (e) {
      AppLogger.error('❌ Failed to handle family notification: $e');
    }
  }

  /// Handle system notifications
  void _handleSystemNotification(RemoteMessage message, MessageSource source) {
    try {
      final notification = SystemNotification(
        id: message.data['id'] ?? message.messageId ?? '',
        title: message.data['system_title'] ?? message.notification?.title ?? '',
        message: message.data['system_message'] ?? message.notification?.body ?? '',
        priority: message.data['priority'] ?? 'medium',
        category: message.data['category'] ?? 'general',
        timestamp: DateTime.tryParse(message.data['timestamp'] ?? '') ?? DateTime.now(),
        messageSource: source,
        actionUrl: message.data['action_url'],
        imageUrl: message.notification?.android?.imageUrl,
        expiresAt: DateTime.tryParse(message.data['expires_at'] ?? ''),
      );

      _systemNotificationController.add(notification);
      AppLogger.info('📢 System notification processed: ${notification.title}');
    } catch (e) {
      AppLogger.error('❌ Failed to handle system notification: $e');
    }
  }

  /// Save notification locally for offline access
  Future<void> _saveNotificationLocally(
    RemoteMessage message,
    MessageSource source,
  ) async {
    try {
      final notifications = await _getLocalNotifications();

      final localNotification = {
        'id': message.data['id'] ?? message.messageId ?? '',
        'type': message.data['type'] ?? 'unknown',
        'title': message.notification?.title ?? '',
        'body': message.notification?.body ?? '',
        'data': message.data,
        'source': source.toString(),
        'timestamp': DateTime.now().toIso8601String(),
        'read': false,
      };

      notifications.add(localNotification);

      // Keep only last 200 notifications
      if (notifications.length > 200) {
        notifications.removeAt(0);
      }

      await _prefs.setString('local_notifications', jsonEncode(notifications));
    } catch (e) {
      AppLogger.error('❌ Failed to save notification locally: $e');
    }
  }

  /// Get local notifications
  Future<List<dynamic>> _getLocalNotifications() async {
    try {
      final notificationsJson = _prefs.getString('local_notifications');
      if (notificationsJson != null) {
        return jsonDecode(notificationsJson) as List<dynamic>;
      }
    } catch (e) {
      AppLogger.error('❌ Failed to get local notifications: $e');
    }
    return [];
  }

  /// Send FCM token to server for targeting
  Future<void> _sendTokenToServer(String token) async {
    try {
      // TODO: Implement API call to send token to server
      // This would typically involve an HTTP POST request to your backend

      final userId = await _secureStorage.getUserId();

      AppLogger.debug('📤 Sending FCM token to server for user: $userId');

      // Simulated server call
      await Future.delayed(Duration(milliseconds: 500));

      AppLogger.info('✅ FCM token sent to server');
    } catch (e) {
      AppLogger.error('❌ Failed to send FCM token to server: $e');
    }
  }

  /// Subscribe to topic for scholar approval notifications
  Future<void> subscribeToScholarApprovals() async {
    try {
      await _firebaseMessaging.subscribeToTopic('scholar_approvals');
      _scholarApprovalEnabled = true;
      await _saveNotificationPreferences();
      AppLogger.info('📚 Subscribed to scholar approval notifications');
    } catch (e) {
      AppLogger.error('❌ Failed to subscribe to scholar approvals: $e');
    }
  }

  /// Unsubscribe from scholar approval notifications
  Future<void> unsubscribeFromScholarApprovals() async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic('scholar_approvals');
      _scholarApprovalEnabled = false;
      await _saveNotificationPreferences();
      AppLogger.info('🔕 Unsubscribed from scholar approval notifications');
    } catch (e) {
      AppLogger.error('❌ Failed to unsubscribe from scholar approvals: $e');
    }
  }

  /// Subscribe to content update notifications
  Future<void> subscribeToContentUpdates() async {
    try {
      await _firebaseMessaging.subscribeToTopic('content_updates');
      _contentUpdateEnabled = true;
      await _saveNotificationPreferences();
      AppLogger.info('📚 Subscribed to content update notifications');
    } catch (e) {
      AppLogger.error('❌ Failed to subscribe to content updates: $e');
    }
  }

  /// Unsubscribe from content update notifications
  Future<void> unsubscribeFromContentUpdates() async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic('content_updates');
      _contentUpdateEnabled = false;
      await _saveNotificationPreferences();
      AppLogger.info('🔕 Unsubscribed from content update notifications');
    } catch (e) {
      AppLogger.error('❌ Failed to unsubscribe from content updates: $e');
    }
  }

  /// Subscribe to family notifications
  Future<void> subscribeToFamilyNotifications(String familyId) async {
    try {
      await _firebaseMessaging.subscribeToTopic('family_$familyId');
      _familyNotificationsEnabled = true;
      await _saveNotificationPreferences();
      AppLogger.info(
        '👨‍👩‍👧‍👦 Subscribed to family notifications: $familyId',
      );
    } catch (e) {
      AppLogger.error('❌ Failed to subscribe to family notifications: $e');
    }
  }

  /// Unsubscribe from family notifications
  Future<void> unsubscribeFromFamilyNotifications(String familyId) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic('family_$familyId');
      _familyNotificationsEnabled = false;
      await _saveNotificationPreferences();
      AppLogger.info('🔕 Unsubscribed from family notifications: $familyId');
    } catch (e) {
      AppLogger.error('❌ Failed to unsubscribe from family notifications: $e');
    }
  }

  /// Load notification preferences
  Future<void> _loadNotificationPreferences() async {
    try {
      _scholarApprovalEnabled = _prefs.getBool('scholar_approval_notifications') ?? true;
      _contentUpdateEnabled = _prefs.getBool('content_update_notifications') ?? true;
      _familyNotificationsEnabled = _prefs.getBool('family_notifications') ?? true;
      _systemNotificationsEnabled = _prefs.getBool('system_notifications') ?? true;
    } catch (e) {
      AppLogger.error('❌ Failed to load notification preferences: $e');
    }
  }

  /// Save notification preferences
  Future<void> _saveNotificationPreferences() async {
    try {
      await _prefs.setBool(
        'scholar_approval_notifications',
        _scholarApprovalEnabled,
      );
      await _prefs.setBool(
        'content_update_notifications',
        _contentUpdateEnabled,
      );
      await _prefs.setBool('family_notifications', _familyNotificationsEnabled);
      await _prefs.setBool('system_notifications', _systemNotificationsEnabled);
    } catch (e) {
      AppLogger.error('❌ Failed to save notification preferences: $e');
    }
  }

  /// Get unread notifications count
  Future<int> getUnreadNotificationsCount() async {
    try {
      final notifications = await _getLocalNotifications();
      return notifications.where((n) => n['read'] == false).length;
    } catch (e) {
      AppLogger.error('❌ Failed to get unread notifications count: $e');
      return 0;
    }
  }

  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final notifications = await _getLocalNotifications();
      for (final notification in notifications) {
        if (notification['id'] == notificationId) {
          notification['read'] = true;
          break;
        }
      }
      await _prefs.setString('local_notifications', jsonEncode(notifications));
    } catch (e) {
      AppLogger.error('❌ Failed to mark notification as read: $e');
    }
  }

  /// Get all local notifications
  Future<List<Map<String, dynamic>>> getAllNotifications() async {
    try {
      final notifications = await _getLocalNotifications();
      return notifications.cast<Map<String, dynamic>>();
    } catch (e) {
      AppLogger.error('❌ Failed to get all notifications: $e');
      return [];
    }
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      await _prefs.remove('local_notifications');
      AppLogger.info('🗑️ All notifications cleared');
    } catch (e) {
      AppLogger.error('❌ Failed to clear all notifications: $e');
    }
  }

  /// Get notification preferences
  Map<String, bool> getNotificationPreferences() {
    return {
      'scholar_approval_enabled': _scholarApprovalEnabled,
      'content_update_enabled': _contentUpdateEnabled,
      'family_notifications_enabled': _familyNotificationsEnabled,
      'system_notifications_enabled': _systemNotificationsEnabled,
    };
  }

  /// Update notification preferences
  Future<void> updateNotificationPreferences({
    bool? scholarApprovalEnabled,
    bool? contentUpdateEnabled,
    bool? familyNotificationsEnabled,
    bool? systemNotificationsEnabled,
  }) async {
    if (scholarApprovalEnabled != null) {
      _scholarApprovalEnabled = scholarApprovalEnabled;
      if (scholarApprovalEnabled) {
        await subscribeToScholarApprovals();
      } else {
        await unsubscribeFromScholarApprovals();
      }
    }

    if (contentUpdateEnabled != null) {
      _contentUpdateEnabled = contentUpdateEnabled;
      if (contentUpdateEnabled) {
        await subscribeToContentUpdates();
      } else {
        await unsubscribeFromContentUpdates();
      }
    }

    if (familyNotificationsEnabled != null) {
      _familyNotificationsEnabled = familyNotificationsEnabled;
      // Family-specific subscription handled elsewhere
    }

    if (systemNotificationsEnabled != null) {
      _systemNotificationsEnabled = systemNotificationsEnabled;
    }

    await _saveNotificationPreferences();
  }

  /// Get FCM token
  String? get fcmToken => _fcmToken;

  /// Check if notifications are enabled
  bool get areNotificationsEnabled =>
      _scholarApprovalEnabled || _contentUpdateEnabled || _familyNotificationsEnabled || _systemNotificationsEnabled;

  /// Dispose resources
  void dispose() {
    _scholarApprovalController.close();
    _contentUpdateController.close();
    _familyNotificationController.close();
    _systemNotificationController.close();
  }
}

/// Scholar Approval Notification
class ScholarApprovalNotification {
  final String id;
  final String duaId;
  final String duaTitle;
  final String duaText;
  final String scholarName;
  final String scholarId;
  final DateTime approvedAt;
  final MessageSource messageSource;
  final String? notificationBody;
  final String? imageUrl;

  ScholarApprovalNotification({
    required this.id,
    required this.duaId,
    required this.duaTitle,
    required this.duaText,
    required this.scholarName,
    required this.scholarId,
    required this.approvedAt,
    required this.messageSource,
    this.notificationBody,
    this.imageUrl,
  });
}

/// Content Update Notification
class ContentUpdateNotification {
  final String id;
  final String title;
  final String description;
  final String category;
  final String updateType;
  final DateTime updatedAt;
  final MessageSource messageSource;
  final String? imageUrl;
  final String? actionUrl;

  ContentUpdateNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.updateType,
    required this.updatedAt,
    required this.messageSource,
    this.imageUrl,
    this.actionUrl,
  });
}

/// Family Notification
class FamilyNotification {
  final String id;
  final String familyId;
  final String fromMemberId;
  final String fromMemberName;
  final String notificationType;
  final String title;
  final String message;
  final DateTime timestamp;
  final MessageSource messageSource;
  final Map<String, dynamic> data;

  FamilyNotification({
    required this.id,
    required this.familyId,
    required this.fromMemberId,
    required this.fromMemberName,
    required this.notificationType,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.messageSource,
    required this.data,
  });
}

/// System Notification
class SystemNotification {
  final String id;
  final String title;
  final String message;
  final String priority;
  final String category;
  final DateTime timestamp;
  final MessageSource messageSource;
  final String? actionUrl;
  final String? imageUrl;
  final DateTime? expiresAt;

  SystemNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.priority,
    required this.category,
    required this.timestamp,
    required this.messageSource,
    this.actionUrl,
    this.imageUrl,
    this.expiresAt,
  });
}

/// Message Source enum
enum MessageSource { foreground, background, terminated }
