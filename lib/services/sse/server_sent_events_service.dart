import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/logging/app_logger.dart';
import '../secure_storage/secure_storage_service.dart';

/// Server-Sent Events (SSE) Service for pushing new relevant Du'as
/// Handles real-time updates from scholars and content approvals
class ServerSentEventsService {
  static ServerSentEventsService? _instance;
  static ServerSentEventsService get instance =>
      _instance ??= ServerSentEventsService._();

  ServerSentEventsService._();

  // Service dependencies
  late SecureStorageService _secureStorage;
  late SharedPreferences _prefs;

  // SSE Configuration
  static const String _sseEndpoint = 'https://api.duacopilot.com/sse/events';
  static const Duration _reconnectDelay = Duration(seconds: 5);
  static const int _maxReconnectAttempts = 10;

  // Connection management
  http.Client? _httpClient;
  StreamSubscription? _sseSubscription;
  StreamSubscription? _connectivitySubscription;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;

  // State tracking
  bool _isInitialized = false;
  bool _isConnected = false;
  bool _isOnline = true;
  int _reconnectAttempts = 0;
  DateTime? _lastEventTime;

  // Stream controllers for different event types
  final _scholarApprovalController =
      StreamController<ScholarApprovalEvent>.broadcast();
  final _contentUpdateController =
      StreamController<ContentUpdateEvent>.broadcast();
  final _systemNotificationController =
      StreamController<SystemNotificationEvent>.broadcast();
  final _connectionStateController =
      StreamController<SSEConnectionState>.broadcast();

  // Public event streams
  Stream<ScholarApprovalEvent> get scholarApprovalStream =>
      _scholarApprovalController.stream;
  Stream<ContentUpdateEvent> get contentUpdateStream =>
      _contentUpdateController.stream;
  Stream<SystemNotificationEvent> get systemNotificationStream =>
      _systemNotificationController.stream;
  Stream<SSEConnectionState> get connectionStateStream =>
      _connectionStateController.stream;

  /// Initialize the SSE service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('🔄 Initializing Server-Sent Events Service...');

      _secureStorage = SecureStorageService.instance;
      await _secureStorage.initialize();

      _prefs = await SharedPreferences.getInstance();

      // Setup connectivity monitoring
      await _setupConnectivityMonitoring();

      // Start SSE connection
      await _startSSEConnection();

      _isInitialized = true;
      AppLogger.info('✅ Server-Sent Events Service initialized');
    } catch (e) {
      AppLogger.error('❌ Failed to initialize SSE service: $e');
      rethrow;
    }
  }

  /// Setup connectivity monitoring
  Future<void> _setupConnectivityMonitoring() async {
    final connectivity = Connectivity();
    _isOnline =
        await connectivity.checkConnectivity() != ConnectivityResult.none;

    _connectivitySubscription = connectivity.onConnectivityChanged.listen((
      result,
    ) {
      final wasOnline = _isOnline;
      _isOnline = result != ConnectivityResult.none;

      if (!wasOnline && _isOnline) {
        AppLogger.info('🌐 Internet restored, reconnecting to SSE...');
        _handleConnectivityRestored();
      } else if (wasOnline && !_isOnline) {
        AppLogger.warning('📡 Internet lost, disconnecting SSE...');
        _handleConnectivityLost();
      }
    });
  }

  /// Handle connectivity restored
  void _handleConnectivityRestored() {
    _connectionStateController.add(SSEConnectionState.reconnecting);
    _startSSEConnection();
  }

  /// Handle connectivity lost
  void _handleConnectivityLost() {
    _isConnected = false;
    _connectionStateController.add(SSEConnectionState.offline);
    _cleanupConnection();
  }

  /// Start SSE connection
  Future<void> _startSSEConnection() async {
    if (!_isOnline) {
      AppLogger.warning('⚠️ No internet connection, skipping SSE connection');
      return;
    }

    try {
      await _cleanupConnection();

      final token = await _secureStorage.read('auth_token');
      final userId = await _secureStorage.getUserId();

      _httpClient = http.Client();

      final uri = Uri.parse(_sseEndpoint).replace(
        queryParameters: {
          if (token != null) 'token': token,
          if (userId != null) 'user_id': userId,
          'stream': 'true',
        },
      );

      AppLogger.info('🔌 Connecting to SSE endpoint: $uri');

      final request = http.Request('GET', uri)
        ..headers.addAll({
          'Accept': 'text/event-stream',
          'Cache-Control': 'no-cache',
          'Connection': 'keep-alive',
        });

      final streamedResponse = await _httpClient!.send(request);

      if (streamedResponse.statusCode == 200) {
        AppLogger.info('✅ SSE connection established');
        _isConnected = true;
        _reconnectAttempts = 0;
        _connectionStateController.add(SSEConnectionState.connected);

        // Listen to the SSE stream
        _sseSubscription = streamedResponse.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(
              _handleSSEMessage,
              onError: _handleSSEError,
              onDone: _handleSSEDisconnection,
            );

        // Start heartbeat monitoring
        _startHeartbeatMonitoring();
      } else {
        throw Exception(
          'SSE connection failed with status: ${streamedResponse.statusCode}',
        );
      }
    } catch (e) {
      AppLogger.error('❌ Failed to start SSE connection: $e');
      _scheduleReconnect();
    }
  }

  /// Handle SSE message
  void _handleSSEMessage(String line) {
    if (line.isEmpty) return;

    try {
      _lastEventTime = DateTime.now();

      if (line.startsWith('data: ')) {
        final data = line.substring(6); // Remove 'data: ' prefix

        if (data.trim() == 'ping') {
          AppLogger.debug('💓 SSE heartbeat received');
          return;
        }

        final eventData = jsonDecode(data);
        final eventType = eventData['type'] as String?;

        AppLogger.debug('📨 SSE message received: $eventType');

        switch (eventType) {
          case 'scholar_approval':
            _handleScholarApprovalEvent(eventData);
            break;
          case 'content_update':
            _handleContentUpdateEvent(eventData);
            break;
          case 'system_notification':
            _handleSystemNotificationEvent(eventData);
            break;
          default:
            AppLogger.debug('🔄 Unhandled SSE event type: $eventType');
        }
      } else if (line.startsWith('event: ')) {
        // Handle event type line if needed
        final eventType = line.substring(7);
        AppLogger.debug('📋 SSE event type: $eventType');
      } else if (line.startsWith('id: ')) {
        // Handle event ID if needed
        final eventId = line.substring(4);
        AppLogger.debug('🆔 SSE event ID: $eventId');
      }
    } catch (e) {
      AppLogger.error('❌ Failed to handle SSE message: $e');
    }
  }

  /// Handle scholar approval event
  void _handleScholarApprovalEvent(Map<String, dynamic> eventData) {
    try {
      final event = ScholarApprovalEvent.fromJson(eventData);
      _scholarApprovalController.add(event);

      AppLogger.info('🎓 Scholar approved new Du\'a: ${event.duaTitle}');

      // Save notification for offline viewing
      _saveNotificationForOffline('scholar_approval', eventData);
    } catch (e) {
      AppLogger.error('❌ Failed to handle scholar approval event: $e');
    }
  }

  /// Handle content update event
  void _handleContentUpdateEvent(Map<String, dynamic> eventData) {
    try {
      final event = ContentUpdateEvent.fromJson(eventData);
      _contentUpdateController.add(event);

      AppLogger.info('📚 Content updated: ${event.title}');

      // Save notification for offline viewing
      _saveNotificationForOffline('content_update', eventData);
    } catch (e) {
      AppLogger.error('❌ Failed to handle content update event: $e');
    }
  }

  /// Handle system notification event
  void _handleSystemNotificationEvent(Map<String, dynamic> eventData) {
    try {
      final event = SystemNotificationEvent.fromJson(eventData);
      _systemNotificationController.add(event);

      AppLogger.info('📢 System notification: ${event.title}');

      // Save notification for offline viewing
      _saveNotificationForOffline('system_notification', eventData);
    } catch (e) {
      AppLogger.error('❌ Failed to handle system notification event: $e');
    }
  }

  /// Save notification for offline viewing
  Future<void> _saveNotificationForOffline(
    String type,
    Map<String, dynamic> data,
  ) async {
    try {
      final notifications = await _getOfflineNotifications();
      notifications.add({
        'type': type,
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
        'read': false,
      });

      // Keep only last 100 notifications
      if (notifications.length > 100) {
        notifications.removeAt(0);
      }

      await _prefs.setString(
        'offline_notifications',
        jsonEncode(notifications),
      );
    } catch (e) {
      AppLogger.error('❌ Failed to save offline notification: $e');
    }
  }

  /// Get offline notifications
  Future<List<dynamic>> _getOfflineNotifications() async {
    try {
      final notificationsJson = _prefs.getString('offline_notifications');
      if (notificationsJson != null) {
        return jsonDecode(notificationsJson) as List<dynamic>;
      }
    } catch (e) {
      AppLogger.error('❌ Failed to get offline notifications: $e');
    }
    return [];
  }

  /// Start heartbeat monitoring
  void _startHeartbeatMonitoring() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(Duration(seconds: 30), (_) {
      final now = DateTime.now();
      if (_lastEventTime != null &&
          now.difference(_lastEventTime!).inSeconds > 60) {
        AppLogger.warning(
          '⚠️ No SSE events received for 60 seconds, reconnecting...',
        );
        _scheduleReconnect();
      }
    });
  }

  /// Handle SSE error
  void _handleSSEError(Object error) {
    AppLogger.error('❌ SSE error: $error');
    _isConnected = false;
    _connectionStateController.add(SSEConnectionState.error);
    _scheduleReconnect();
  }

  /// Handle SSE disconnection
  void _handleSSEDisconnection() {
    AppLogger.warning('⚠️ SSE connection closed');
    _isConnected = false;
    _connectionStateController.add(SSEConnectionState.disconnected);
    _scheduleReconnect();
  }

  /// Schedule reconnection with exponential backoff
  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      AppLogger.error('❌ Max SSE reconnection attempts reached');
      _connectionStateController.add(SSEConnectionState.failed);
      return;
    }

    _reconnectTimer?.cancel();

    final delay = Duration(
      seconds:
          _reconnectDelay.inSeconds * (1 << _reconnectAttempts.clamp(0, 5)),
    );

    _reconnectTimer = Timer(delay, () {
      _reconnectAttempts++;
      AppLogger.info(
        '🔄 Attempting SSE reconnection ($_reconnectAttempts/$_maxReconnectAttempts)',
      );
      _connectionStateController.add(SSEConnectionState.reconnecting);
      _startSSEConnection();
    });
  }

  /// Cleanup connection resources
  Future<void> _cleanupConnection() async {
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();

    await _sseSubscription?.cancel();
    _sseSubscription = null;

    _httpClient?.close();
    _httpClient = null;
  }

  /// Get connection status
  bool get isConnected => _isConnected && _isOnline;

  /// Get last event time
  DateTime? get lastEventTime => _lastEventTime;

  /// Get unread offline notifications count
  Future<int> getUnreadNotificationsCount() async {
    try {
      final notifications = await _getOfflineNotifications();
      return notifications.where((n) => n['read'] == false).length;
    } catch (e) {
      return 0;
    }
  }

  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final notifications = await _getOfflineNotifications();
      for (final notification in notifications) {
        if (notification['data']['id'] == notificationId) {
          notification['read'] = true;
          break;
        }
      }
      await _prefs.setString(
        'offline_notifications',
        jsonEncode(notifications),
      );
    } catch (e) {
      AppLogger.error('❌ Failed to mark notification as read: $e');
    }
  }

  /// Get all offline notifications
  Future<List<Map<String, dynamic>>> getAllOfflineNotifications() async {
    try {
      final notifications = await _getOfflineNotifications();
      return notifications.cast<Map<String, dynamic>>();
    } catch (e) {
      AppLogger.error('❌ Failed to get all offline notifications: $e');
      return [];
    }
  }

  /// Clear all offline notifications
  Future<void> clearAllOfflineNotifications() async {
    try {
      await _prefs.remove('offline_notifications');
    } catch (e) {
      AppLogger.error('❌ Failed to clear offline notifications: $e');
    }
  }

  /// Force reconnection
  Future<void> forceReconnect() async {
    _reconnectAttempts = 0;
    await _startSSEConnection();
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _cleanupConnection();

    _scholarApprovalController.close();
    _contentUpdateController.close();
    _systemNotificationController.close();
    _connectionStateController.close();
  }
}

/// Scholar Approval Event
class ScholarApprovalEvent {
  final String id;
  final String duaId;
  final String duaTitle;
  final String duaText;
  final String scholarName;
  final String scholarId;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  ScholarApprovalEvent({
    required this.id,
    required this.duaId,
    required this.duaTitle,
    required this.duaText,
    required this.scholarName,
    required this.scholarId,
    required this.timestamp,
    this.metadata,
  });

  factory ScholarApprovalEvent.fromJson(Map<String, dynamic> json) {
    return ScholarApprovalEvent(
      id: json['id'],
      duaId: json['dua_id'],
      duaTitle: json['dua_title'],
      duaText: json['dua_text'],
      scholarName: json['scholar_name'],
      scholarId: json['scholar_id'],
      timestamp: DateTime.parse(json['timestamp']),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dua_id': duaId,
    'dua_title': duaTitle,
    'dua_text': duaText,
    'scholar_name': scholarName,
    'scholar_id': scholarId,
    'timestamp': timestamp.toIso8601String(),
    'metadata': metadata,
  };
}

/// Content Update Event
class ContentUpdateEvent {
  final String id;
  final String title;
  final String description;
  final String category;
  final String
  updateType; // 'new_content', 'updated_content', 'removed_content'
  final DateTime timestamp;
  final Map<String, dynamic>? data;

  ContentUpdateEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.updateType,
    required this.timestamp,
    this.data,
  });

  factory ContentUpdateEvent.fromJson(Map<String, dynamic> json) {
    return ContentUpdateEvent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      updateType: json['update_type'],
      timestamp: DateTime.parse(json['timestamp']),
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'update_type': updateType,
    'timestamp': timestamp.toIso8601String(),
    'data': data,
  };
}

/// System Notification Event
class SystemNotificationEvent {
  final String id;
  final String title;
  final String message;
  final String priority; // 'low', 'medium', 'high', 'urgent'
  final String? actionUrl;
  final DateTime timestamp;
  final DateTime? expiresAt;
  final Map<String, dynamic>? metadata;

  SystemNotificationEvent({
    required this.id,
    required this.title,
    required this.message,
    required this.priority,
    required this.timestamp,
    this.actionUrl,
    this.expiresAt,
    this.metadata,
  });

  factory SystemNotificationEvent.fromJson(Map<String, dynamic> json) {
    return SystemNotificationEvent(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      priority: json['priority'],
      timestamp: DateTime.parse(json['timestamp']),
      actionUrl: json['action_url'],
      expiresAt:
          json['expires_at'] != null
              ? DateTime.parse(json['expires_at'])
              : null,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'priority': priority,
    'timestamp': timestamp.toIso8601String(),
    'action_url': actionUrl,
    'expires_at': expiresAt?.toIso8601String(),
    'metadata': metadata,
  };
}

/// SSE Connection State
enum SSEConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  offline,
  error,
  failed,
}
