import 'dart:async';

import '../../core/logging/app_logger.dart';
import '../background/intelligent_background_sync_service.dart';
import '../collaborative/collaborative_service.dart';
import '../messaging/firebase_messaging_service.dart';
import '../realtime/real_time_service_manager.dart';
import '../sse/server_sent_events_service.dart';

/// Real-Time Integration Service
/// Coordinates all real-time services and provides unified interface
class RealTimeIntegrationService {
  static RealTimeIntegrationService? _instance;
  static RealTimeIntegrationService get instance =>
      _instance ??= RealTimeIntegrationService._();

  RealTimeIntegrationService._();

  // Service instances
  late RealTimeServiceManager _realTimeManager;
  late IntelligentBackgroundSyncService _backgroundSync;
  late ServerSentEventsService _sseService;
  late CollaborativeService _collaborativeService;
  late FirebaseMessagingService _messagingService;

  // State management
  bool _isInitialized = false;
  bool _isActive = false;

  // Stream subscriptions for service coordination
  final List<StreamSubscription> _subscriptions = [];

  /// Initialize all real-time services
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('ðŸš€ Initializing Real-Time Integration Service...');

      // Initialize all service instances
      _realTimeManager = RealTimeServiceManager.instance;
      _backgroundSync = IntelligentBackgroundSyncService.instance;
      _sseService = ServerSentEventsService.instance;
      _collaborativeService = CollaborativeService.instance;
      _messagingService = FirebaseMessagingService.instance;

      // Initialize services in order
      await _realTimeManager.initialize();
      await _backgroundSync.initialize();
      await _sseService.initialize();
      await _collaborativeService.initialize();
      await _messagingService.initialize();

      // Setup service coordination
      _setupServiceCoordination();

      _isInitialized = true;
      _isActive = true;

      AppLogger.info(
        'âœ… Real-Time Integration Service initialized successfully',
      );

      // Record usage for intelligent background sync
      _backgroundSync.recordUsage('real_time_service_init');
    } catch (e) {
      AppLogger.error(
        'âŒ Failed to initialize Real-Time Integration Service: $e',
      );
      rethrow;
    }
  }

  /// Setup coordination between different services
  void _setupServiceCoordination() {
    // Coordinate SSE with Firebase Messaging
    _subscriptions.add(
      _sseService.scholarApprovalStream.listen((approval) {
        // When SSE receives scholar approval, record usage for background sync
        _backgroundSync.recordUsage('scholar_approval_received');

        // Schedule urgent sync for new content
        _backgroundSync.scheduleUrgentSync(
          reason: 'Scholar approved new Du\'a: ${approval.duaTitle}',
          data: {
            'dua_id': approval.duaId,
            'dua_title': approval.duaTitle,
            'scholar_name': approval.scholarName,
          },
        );
      }),
    );

    // Coordinate SSE content updates with background sync
    _subscriptions.add(
      _sseService.contentUpdateStream.listen((update) {
        _backgroundSync.recordUsage('content_update_received');

        // Schedule background sync for content updates
        _backgroundSync.scheduleUrgentSync(
          reason: 'Content updated: ${update.title}',
          data: {
            'content_id': update.id,
            'content_title': update.title,
            'update_type': update.updateType,
          },
        );
      }),
    );

    // Coordinate collaborative service with background sync
    _subscriptions.add(
      _collaborativeService.familyDuaSharedStream.listen((share) {
        _backgroundSync.recordUsage('family_dua_shared');

        // Schedule family sync for collaborative data
        _backgroundSync.scheduleFamilySync(
          familyId: share.familyId,
          action: 'dua_shared_${share.duaId}',
        );
      }),
    );

    // Coordinate Firebase messaging with other services
    _subscriptions.add(
      _messagingService.scholarApprovalStream.listen((approval) {
        _backgroundSync.recordUsage('push_notification_scholar_approval');

        // If we have collaborative service active, share with family
        if (_collaborativeService.hasFamily) {
          AppLogger.info(
            'ðŸ“² Scholar approval push received, coordinating with family sharing',
          );
        }
      }),
    );

    // Coordinate WebSocket reconnection with SSE
    _subscriptions.add(
      _realTimeManager.connectionStateStream.listen((state) {
        switch (state) {
          case ConnectionState.connected:
            AppLogger.info(
              'ðŸ”— WebSocket connected, coordinating real-time services',
            );
            _backgroundSync.recordUsage('websocket_connected');
            break;
          case ConnectionState.offline:
            AppLogger.info(
              'ðŸ“± WebSocket offline, relying on SSE and push notifications',
            );
            break;
          case ConnectionState.failed:
            AppLogger.warning(
                'âš ï¸ WebSocket failed, scheduling urgent sync');
            _backgroundSync.scheduleUrgentSync(
              reason: 'WebSocket connection failed, forcing sync',
            );
            break;
          default:
            break;
        }
      }),
    );

    // Coordinate prayer sessions
    _subscriptions.add(
      _collaborativeService.prayerSessionStream.listen((session) {
        _backgroundSync.recordUsage('prayer_session_activity');

        AppLogger.info('ðŸ¤² Prayer session activity: ${session.sessionName}');

        // Schedule family sync for prayer session data
        _backgroundSync.scheduleFamilySync(
          familyId: session.familyId,
          action: 'prayer_session_${session.status}',
        );
      }),
    );
  }

  /// Share Du'a with family using multiple channels
  Future<void> shareDuaWithFamily({
    required String duaId,
    required String duaTitle,
    required String duaText,
    String? personalNote,
    List<String>? tags,
    String? category,
  }) async {
    try {
      AppLogger.info(
        'ðŸ“¤ Sharing Du\'a with family through multiple channels: $duaTitle',
      );

      // Primary: Use collaborative service
      await _collaborativeService.shareDuaWithFamily(
        duaId: duaId,
        duaTitle: duaTitle,
        duaText: duaText,
        personalNote: personalNote,
        tags: tags,
        category: category,
      );

      // Backup: Use real-time manager
      await _realTimeManager.shareDuaWithFamily(
        duaId: duaId,
        duaTitle: duaTitle,
        duaText: duaText,
        personalNote: personalNote,
        metadata: {'tags': tags, 'category': category},
      );

      // Record usage for intelligent sync
      _backgroundSync.recordUsage('family_dua_shared');

      AppLogger.info('âœ… Du\'a shared with family successfully');
    } catch (e) {
      AppLogger.error('âŒ Failed to share Du\'a with family: $e');
      rethrow;
    }
  }

  /// Request live RAG processing with fallback options
  Future<void> requestLiveRagProcessing({
    required String query,
    required String sessionId,
    Map<String, dynamic>? context,
  }) async {
    try {
      AppLogger.info('ðŸ” Requesting live RAG processing: $query');

      // Primary: Use WebSocket connection
      await _realTimeManager.requestLiveRagProcessing(
        query: query,
        sessionId: sessionId,
        context: context,
      );

      // Record usage for intelligent sync
      _backgroundSync.recordUsage('live_rag_query');

      AppLogger.info('âœ… Live RAG processing requested');
    } catch (e) {
      AppLogger.error('âŒ Failed to request live RAG processing: $e');

      // Fallback: Schedule background processing
      await _backgroundSync.scheduleUrgentSync(
        reason: 'Live RAG failed, scheduling background processing',
        data: {'query': query, 'session_id': sessionId, 'context': context},
      );
    }
  }

  /// Start family prayer session
  Future<void> startFamilyPrayerSession({
    required String sessionName,
    required List<String> duaIds,
    int? durationMinutes,
    String? description,
  }) async {
    try {
      AppLogger.info('ðŸ¤² Starting family prayer session: $sessionName');

      await _collaborativeService.startFamilyPrayerSession(
        sessionName: sessionName,
        duaIds: duaIds,
        durationMinutes: durationMinutes,
        description: description,
      );

      // Record usage for intelligent sync
      _backgroundSync.recordUsage('family_prayer_session_started');

      AppLogger.info('âœ… Family prayer session started successfully');
    } catch (e) {
      AppLogger.error('âŒ Failed to start family prayer session: $e');
      rethrow;
    }
  }

  /// Create family group with full integration
  Future<void> createFamily({
    required String familyName,
    String? description,
  }) async {
    try {
      AppLogger.info(
        'ðŸ‘¨â€ðŸ‘©â€ðŸ‘§â€ðŸ‘¦ Creating family with real-time integration: $familyName',
      );

      // Create family through collaborative service
      await _collaborativeService.createFamily(
        familyName: familyName,
        description: description,
      );

      // Subscribe to family notifications
      // (Family ID is set internally by collaborative service)
      final familyInfo = _collaborativeService.getFamilyInfo();
      final familyId = familyInfo['family_id'] as String?;

      if (familyId != null) {
        await _messagingService.subscribeToFamilyNotifications(familyId);
      }

      // Record usage for intelligent sync
      _backgroundSync.recordUsage('family_created');

      // Schedule family sync to establish initial data
      if (familyId != null) {
        await _backgroundSync.scheduleFamilySync(
          familyId: familyId,
          action: 'family_created',
        );
      }

      AppLogger.info('âœ… Family created with full real-time integration');
    } catch (e) {
      AppLogger.error('âŒ Failed to create family with integration: $e');
      rethrow;
    }
  }

  /// Get comprehensive real-time status
  Map<String, dynamic> getRealTimeStatus() {
    return {
      'is_initialized': _isInitialized,
      'is_active': _isActive,
      'services_status': {
        'websocket_connected': _realTimeManager.isConnected,
        'sse_connected': _sseService.isConnected,
        'collaborative_connected': _collaborativeService.isConnected,
        'messaging_enabled': _messagingService.areNotificationsEnabled,
        'background_sync_enabled': true, // Always available
      },
      'connectivity': {
        'real_time_manager_online': _realTimeManager.isOnline,
        'sse_last_event': _sseService.lastEventTime?.toIso8601String(),
      },
      'family_info': _collaborativeService.getFamilyInfo(),
      'sync_stats': _backgroundSync.getSyncStats(),
      'notification_preferences':
          _messagingService.getNotificationPreferences(),
    };
  }

  /// Get all active streams for UI integration
  Map<String, Stream> getActiveStreams() {
    return {
      // Real-time updates
      'real_time_updates': _realTimeManager.realTimeUpdatesStream,
      'connection_state': _realTimeManager.connectionStateStream,
      'sync_status': _realTimeManager.syncStatusStream,
      'collaborative_updates': _realTimeManager.collaborativeUpdatesStream,

      // SSE events
      'scholar_approvals': _sseService.scholarApprovalStream,
      'content_updates': _sseService.contentUpdateStream,
      'system_notifications': _sseService.systemNotificationStream,
      'sse_connection_state': _sseService.connectionStateStream,

      // Collaborative features
      'family_dua_shared': _collaborativeService.familyDuaSharedStream,
      'family_member_joined': _collaborativeService.familyMemberJoinedStream,
      'family_member_left': _collaborativeService.familyMemberLeftStream,
      'collaborative_edit': _collaborativeService.collaborativeEditStream,
      'family_activity': _collaborativeService.familyActivityStream,
      'prayer_session': _collaborativeService.prayerSessionStream,

      // Push notifications
      'push_scholar_approval': _messagingService.scholarApprovalStream,
      'push_content_update': _messagingService.contentUpdateStream,
      'push_family_notification': _messagingService.familyNotificationStream,
      'push_system_notification': _messagingService.systemNotificationStream,
    };
  }

  /// Force full synchronization across all services
  Future<void> forceFullSync() async {
    try {
      AppLogger.info(
          'ðŸ”„ Forcing full synchronization across all services...');

      // Force sync on background service
      await _backgroundSync.forceSyncNow();

      // Force reconnection on SSE
      await _sseService.forceReconnect();

      // Record usage
      _backgroundSync.recordUsage('manual_full_sync');

      AppLogger.info('âœ… Full synchronization completed');
    } catch (e) {
      AppLogger.error('âŒ Failed to force full sync: $e');
    }
  }

  /// Update notification preferences across services
  Future<void> updateNotificationPreferences({
    bool? scholarApprovalEnabled,
    bool? contentUpdateEnabled,
    bool? familyNotificationsEnabled,
    bool? systemNotificationsEnabled,
  }) async {
    try {
      await _messagingService.updateNotificationPreferences(
        scholarApprovalEnabled: scholarApprovalEnabled,
        contentUpdateEnabled: contentUpdateEnabled,
        familyNotificationsEnabled: familyNotificationsEnabled,
        systemNotificationsEnabled: systemNotificationsEnabled,
      );

      AppLogger.info('âš™ï¸ Notification preferences updated');
    } catch (e) {
      AppLogger.error('âŒ Failed to update notification preferences: $e');
    }
  }

  /// Pause all real-time services (for battery saving)
  Future<void> pauseRealTimeServices() async {
    try {
      AppLogger.info('â¸ï¸ Pausing real-time services for battery saving...');

      _isActive = false;

      // Cancel all subscriptions
      for (final subscription in _subscriptions) {
        await subscription.cancel();
      }
      _subscriptions.clear();

      // Disable background sync temporarily
      await _backgroundSync.setEnabled(false);

      AppLogger.info('â¸ï¸ Real-time services paused');
    } catch (e) {
      AppLogger.error('âŒ Failed to pause real-time services: $e');
    }
  }

  /// Resume all real-time services
  Future<void> resumeRealTimeServices() async {
    try {
      AppLogger.info('â–¶ï¸ Resuming real-time services...');

      _isActive = true;

      // Re-enable background sync
      await _backgroundSync.setEnabled(true);

      // Re-setup service coordination
      _setupServiceCoordination();

      // Force reconnection on all services
      await forceFullSync();

      AppLogger.info('â–¶ï¸ Real-time services resumed');
    } catch (e) {
      AppLogger.error('âŒ Failed to resume real-time services: $e');
    }
  }

  /// Check if real-time services are active
  bool get isActive => _isActive && _isInitialized;

  /// Dispose all resources
  void dispose() {
    AppLogger.info('ðŸ—‘ï¸ Disposing Real-Time Integration Service...');

    // Cancel all subscriptions
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    // Dispose all services
    _realTimeManager.dispose();
    _backgroundSync.dispose();
    _sseService.dispose();
    _collaborativeService.dispose();
    _messagingService.dispose();

    _isActive = false;
    _isInitialized = false;

    AppLogger.info('âœ… Real-Time Integration Service disposed');
  }
}
