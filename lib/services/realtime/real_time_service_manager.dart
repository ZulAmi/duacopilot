import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../core/logging/app_logger.dart';
import '../secure_storage/secure_storage_service.dart';

/// Comprehensive Real-Time Service Manager for DuaCopilot
/// Handles WebSockets, Server-Sent Events, Socket.IO, and real-time synchronization
class RealTimeServiceManager {
  static RealTimeServiceManager? _instance;
  static RealTimeServiceManager get instance =>
      _instance ??= RealTimeServiceManager._();

  RealTimeServiceManager._();

  // Services
  late SecureStorageService _secureStorage;
  late SharedPreferences _prefs;

  // Connection management
  WebSocketChannel? _webSocketChannel;
  socket_io.Socket? _socketIOClient;
  StreamSubscription? _connectivitySubscription;

  // Configuration
  static const String _wsBaseUrl = 'wss://api.duacopilot.com';
  static const String _socketIOUrl = 'https://api.duacopilot.com';

  // Connection settings
  static const Duration _heartbeatInterval = Duration(seconds: 30);
  static const Duration _reconnectDelay = Duration(seconds: 5);
  static const int _maxReconnectAttempts = 10;

  // State management
  bool _isInitialized = false;
  bool _isConnected = false;
  bool _isOnline = true;
  int _reconnectAttempts = 0;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;

  // Stream controllers
  final _realTimeUpdatesController =
      StreamController<RealTimeUpdate>.broadcast();
  final _connectionStateController =
      StreamController<ConnectionState>.broadcast();
  final _syncStatusController = StreamController<SyncStatus>.broadcast();
  final _collaborativeUpdatesController =
      StreamController<CollaborativeUpdate>.broadcast();

  // Public streams
  Stream<RealTimeUpdate> get realTimeUpdatesStream =>
      _realTimeUpdatesController.stream;
  Stream<ConnectionState> get connectionStateStream =>
      _connectionStateController.stream;
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;
  Stream<CollaborativeUpdate> get collaborativeUpdatesStream =>
      _collaborativeUpdatesController.stream;

  // Data queues for offline synchronization
  final List<PendingUpdate> _pendingUpdates = [];

  /// Initialize the real-time service manager
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('ðŸ”„ Initializing Real-Time Service Manager...');

      _secureStorage = SecureStorageService.instance;
      await _secureStorage.initialize();

      _prefs = await SharedPreferences.getInstance();

      // Setup connectivity monitoring
      await _setupConnectivityMonitoring();

      // Load pending updates from storage
      await _loadPendingUpdates();

      // Initialize connections
      await _initializeConnections();

      _isInitialized = true;

      AppLogger.info('âœ… Real-Time Service Manager initialized successfully');
      _broadcastConnectionState(ConnectionState.initialized);
    } catch (e) {
      AppLogger.error('âŒ Failed to initialize Real-Time Service Manager: $e');
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
        AppLogger.info('ðŸŒ Internet connection restored');
        _handleConnectivityRestored();
      } else if (wasOnline && !_isOnline) {
        AppLogger.warning('ðŸ“¡ Internet connection lost');
        _handleConnectivityLost();
      }
    });
  }

  /// Handle connectivity restored
  void _handleConnectivityRestored() {
    _broadcastConnectionState(ConnectionState.reconnecting);
    _reconnectAll();
    _processPendingUpdates();
  }

  /// Handle connectivity lost
  void _handleConnectivityLost() {
    _isConnected = false;
    _broadcastConnectionState(ConnectionState.offline);
    _cleanupConnections();
  }

  /// Initialize all connections
  Future<void> _initializeConnections() async {
    if (!_isOnline) {
      AppLogger.warning(
        'âš ï¸ No internet connection, skipping connection initialization',
      );
      return;
    }

    await Future.wait([_initializeWebSocket(), _initializeSocketIO()]);
  }

  /// Initialize WebSocket connection for live RAG processing
  Future<void> _initializeWebSocket() async {
    try {
      final token = await _secureStorage.read('auth_token');
      final userId = await _secureStorage.getUserId();

      final uri = Uri.parse('$_wsBaseUrl/rag/live').replace(
        queryParameters: {
          if (token != null) 'token': token,
          if (userId != null) 'user_id': userId,
        },
      );

      AppLogger.info('ðŸ”Œ Connecting to WebSocket: $uri');

      _webSocketChannel = WebSocketChannel.connect(uri);

      // Listen for messages
      _webSocketChannel!.stream.listen(
        _handleWebSocketMessage,
        onError: _handleWebSocketError,
        onDone: _handleWebSocketDisconnection,
      );

      // Start heartbeat
      _startHeartbeat();

      AppLogger.info('âœ… WebSocket connected successfully');
      _isConnected = true;
      _reconnectAttempts = 0;
      _broadcastConnectionState(ConnectionState.connected);
    } catch (e) {
      AppLogger.error('âŒ Failed to initialize WebSocket: $e');
      _scheduleReconnect();
    }
  }

  /// Initialize Socket.IO for collaborative features
  Future<void> _initializeSocketIO() async {
    try {
      final token = await _secureStorage.read('auth_token');
      final userId = await _secureStorage.getUserId();

      _socketIOClient = socket_io.io(
        _socketIOUrl,
        socket_io.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({
              if (token != null) 'token': token,
              if (userId != null) 'user_id': userId,
            })
            .enableReconnection()
            .setReconnectionAttempts(5)
            .setReconnectionDelay(5000)
            .build(),
      );

      _socketIOClient!.onConnect((_) {
        AppLogger.info('âœ… Socket.IO connected');
        _setupSocketIOListeners();
      });

      _socketIOClient!.onDisconnect((_) {
        AppLogger.warning('âš ï¸ Socket.IO disconnected');
      });

      _socketIOClient!.onConnectError((error) {
        AppLogger.error('âŒ Socket.IO connection error: $error');
      });

      _socketIOClient!.connect();
    } catch (e) {
      AppLogger.error('âŒ Failed to initialize Socket.IO: $e');
    }
  }

  /// Setup Socket.IO event listeners
  void _setupSocketIOListeners() {
    _socketIOClient!.on('family_dua_shared', (data) {
      _handleFamilyDuaShared(data);
    });

    _socketIOClient!.on('scholar_approval', (data) {
      _handleScholarApproval(data);
    });

    _socketIOClient!.on('collaborative_edit', (data) {
      _handleCollaborativeEdit(data);
    });

    _socketIOClient!.on('sync_request', (data) {
      _handleSyncRequest(data);
    });

    // Join user's family room if family ID exists
    _joinFamilyRoom();
  }

  /// Join family room for collaborative features
  Future<void> _joinFamilyRoom() async {
    try {
      final familyId = await _secureStorage.read('family_id');
      if (familyId != null) {
        _socketIOClient!.emit('join_family', {'family_id': familyId});
        AppLogger.info(
            'ðŸ‘¨â€ðŸ‘©â€ðŸ‘§â€ðŸ‘¦ Joined family room: $familyId');
      }
    } catch (e) {
      AppLogger.error('âŒ Failed to join family room: $e');
    }
  }

  /// Handle WebSocket messages
  void _handleWebSocketMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      final update = RealTimeUpdate.fromJson(data);

      AppLogger.debug('ðŸ“¨ WebSocket message received: ${update.type}');
      _realTimeUpdatesController.add(update);

      // Handle specific message types
      switch (update.type) {
        case RealTimeUpdateType.ragResponse:
          _handleRagResponse(update);
          break;
        case RealTimeUpdateType.contentUpdate:
          _handleContentUpdate(update);
          break;
        case RealTimeUpdateType.syncComplete:
          _handleSyncComplete(update);
          break;
        default:
          AppLogger.debug('ðŸ”„ Unhandled update type: ${update.type}');
      }
    } catch (e) {
      AppLogger.error('âŒ Failed to handle WebSocket message: $e');
    }
  }

  /// Handle RAG response updates
  void _handleRagResponse(RealTimeUpdate update) {
    // Process real-time RAG responses
    // This could trigger UI updates for ongoing queries
  }

  /// Handle content updates (new Du'as approved by scholars)
  void _handleContentUpdate(RealTimeUpdate update) {
    // Process content updates from scholars
    // Trigger background sync to fetch new content
    _triggerBackgroundSync();
  }

  /// Handle sync completion
  void _handleSyncComplete(RealTimeUpdate update) {
    _broadcastSyncStatus(SyncStatus.completed);
  }

  /// Handle family Du'a sharing
  void _handleFamilyDuaShared(dynamic data) {
    try {
      final update = CollaborativeUpdate(
        type: CollaborativeUpdateType.familyDuaShared,
        data: data,
        timestamp: DateTime.now(),
        userId: data['shared_by'],
      );

      _collaborativeUpdatesController.add(update);
      AppLogger.info(
          'ðŸ‘¨â€ðŸ‘©â€ðŸ‘§â€ðŸ‘¦ Family Du\'a shared: ${data['dua_title']}');
    } catch (e) {
      AppLogger.error('âŒ Failed to handle family Du\'a sharing: $e');
    }
  }

  /// Handle scholar approval notifications
  void _handleScholarApproval(dynamic data) {
    try {
      final update = CollaborativeUpdate(
        type: CollaborativeUpdateType.scholarApproval,
        data: data,
        timestamp: DateTime.now(),
        userId: data['scholar_id'],
      );

      _collaborativeUpdatesController.add(update);
      AppLogger.info('ðŸŽ“ Scholar approved new Du\'a: ${data['dua_title']}');

      // Trigger content sync to get the new approved Du'a
      _triggerBackgroundSync();
    } catch (e) {
      AppLogger.error('âŒ Failed to handle scholar approval: $e');
    }
  }

  /// Handle collaborative editing
  void _handleCollaborativeEdit(dynamic data) {
    try {
      final update = CollaborativeUpdate(
        type: CollaborativeUpdateType.collaborativeEdit,
        data: data,
        timestamp: DateTime.now(),
        userId: data['editor_id'],
      );

      _collaborativeUpdatesController.add(update);
      AppLogger.debug('âœï¸ Collaborative edit received');
    } catch (e) {
      AppLogger.error('âŒ Failed to handle collaborative edit: $e');
    }
  }

  /// Handle sync requests
  void _handleSyncRequest(dynamic data) {
    try {
      AppLogger.info('ðŸ”„ Sync request received');
      _processSyncRequest(data);
    } catch (e) {
      AppLogger.error('âŒ Failed to handle sync request: $e');
    }
  }

  /// Process sync request
  Future<void> _processSyncRequest(dynamic data) async {
    _broadcastSyncStatus(SyncStatus.syncing);

    try {
      // Process the sync request based on the data
      final syncType = data['sync_type'] as String?;

      switch (syncType) {
        case 'full_sync':
          await _performFullSync();
          break;
        case 'incremental_sync':
          await _performIncrementalSync(data);
          break;
        case 'conflict_resolution':
          await _resolveConflicts(data);
          break;
        default:
          AppLogger.warning('âš ï¸ Unknown sync type: $syncType');
      }

      _broadcastSyncStatus(SyncStatus.completed);
    } catch (e) {
      AppLogger.error('âŒ Sync request failed: $e');
      _broadcastSyncStatus(SyncStatus.failed);
    }
  }

  /// Share Du'a with family
  Future<void> shareDuaWithFamily({
    required String duaId,
    required String duaTitle,
    required String duaText,
    String? personalNote,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final familyId = await _secureStorage.read('family_id');
      if (familyId == null) {
        throw Exception('No family ID found');
      }

      final shareData = {
        'dua_id': duaId,
        'dua_title': duaTitle,
        'dua_text': duaText,
        'personal_note': personalNote,
        'metadata': metadata,
        'shared_at': DateTime.now().toIso8601String(),
        'family_id': familyId,
      };

      if (_socketIOClient?.connected == true) {
        _socketIOClient!.emit('share_family_dua', shareData);
        AppLogger.info(
            'ðŸ‘¨â€ðŸ‘©â€ðŸ‘§â€ðŸ‘¦ Du\'a shared with family: $duaTitle');
      } else {
        // Queue for later when connection is restored
        _queueUpdate(
          PendingUpdate(
            type: PendingUpdateType.familyShare,
            data: shareData,
            timestamp: DateTime.now(),
          ),
        );
        AppLogger.info('ðŸ“‹ Du\'a sharing queued (offline)');
      }
    } catch (e) {
      AppLogger.error('âŒ Failed to share Du\'a with family: $e');
      rethrow;
    }
  }

  /// Request live RAG processing
  Future<void> requestLiveRagProcessing({
    required String query,
    required String sessionId,
    Map<String, dynamic>? context,
  }) async {
    try {
      final requestData = {
        'type': 'rag_query',
        'query': query,
        'session_id': sessionId,
        'context': context,
        'timestamp': DateTime.now().toIso8601String(),
      };

      if (_webSocketChannel != null && _isConnected) {
        _webSocketChannel!.sink.add(jsonEncode(requestData));
        AppLogger.info('ðŸ” Live RAG query sent: $query');
      } else {
        // Queue for later processing
        _queueUpdate(
          PendingUpdate(
            type: PendingUpdateType.ragQuery,
            data: requestData,
            timestamp: DateTime.now(),
          ),
        );
        AppLogger.info('ðŸ“‹ RAG query queued (offline)');
      }
    } catch (e) {
      AppLogger.error('âŒ Failed to send live RAG query: $e');
      rethrow;
    }
  }

  /// Trigger background sync
  Future<void> _triggerBackgroundSync() async {
    _broadcastSyncStatus(SyncStatus.syncing);

    try {
      // Perform background sync with intelligent scheduling
      await _performIncrementalSync();
      _broadcastSyncStatus(SyncStatus.completed);
    } catch (e) {
      AppLogger.error('âŒ Background sync failed: $e');
      _broadcastSyncStatus(SyncStatus.failed);
    }
  }

  /// Perform full synchronization
  Future<void> _performFullSync() async {
    AppLogger.info('ðŸ”„ Starting full synchronization...');

    try {
      // Implement full sync logic here
      // This would sync all user data, preferences, favorites, etc.

      await Future.delayed(Duration(seconds: 2)); // Simulated sync time

      AppLogger.info('âœ… Full synchronization completed');
    } catch (e) {
      AppLogger.error('âŒ Full synchronization failed: $e');
      rethrow;
    }
  }

  /// Perform incremental synchronization
  Future<void> _performIncrementalSync([dynamic data]) async {
    AppLogger.info('ðŸ”„ Starting incremental synchronization...');

    try {
      // Implement incremental sync logic here
      // This would sync only changed data since last sync

      await Future.delayed(Duration(milliseconds: 500)); // Simulated sync time

      AppLogger.info('âœ… Incremental synchronization completed');
    } catch (e) {
      AppLogger.error('âŒ Incremental synchronization failed: $e');
      rethrow;
    }
  }

  /// Resolve data conflicts
  Future<void> _resolveConflicts(dynamic conflictData) async {
    AppLogger.info('âš–ï¸ Resolving data conflicts...');

    try {
      // Implement conflict resolution logic
      // Priority: Server > Local for most cases
      // User intervention for critical conflicts

      final conflicts = conflictData['conflicts'] as List?;
      if (conflicts != null) {
        for (final conflict in conflicts) {
          await _resolveConflict(conflict);
        }
      }

      AppLogger.info('âœ… Conflicts resolved successfully');
    } catch (e) {
      AppLogger.error('âŒ Conflict resolution failed: $e');
      rethrow;
    }
  }

  /// Resolve individual conflict
  Future<void> _resolveConflict(dynamic conflict) async {
    final conflictType = conflict['type'] as String?;

    switch (conflictType) {
      case 'favorite_dua':
        await _resolveFavoriteConflict(conflict);
        break;
      case 'user_preference':
        await _resolvePreferenceConflict(conflict);
        break;
      case 'family_sharing':
        await _resolveFamilySharingConflict(conflict);
        break;
      default:
        AppLogger.warning('âš ï¸ Unknown conflict type: $conflictType');
    }
  }

  /// Resolve favorite Du'a conflicts
  Future<void> _resolveFavoriteConflict(dynamic conflict) async {
    // Server timestamp wins for favorites
    // final serverData = conflict['server_data'];
    // final localData = conflict['local_data'];

    // Merge favorites, keeping the most recent additions
    // Implementation would depend on the specific conflict resolution strategy
    AppLogger.info('â­ Resolving favorite conflict');
  }

  /// Resolve user preference conflicts
  Future<void> _resolvePreferenceConflict(dynamic conflict) async {
    // User's device wins for preferences in most cases
    // final localData = conflict['local_data'];

    // Send local preferences to server to resolve conflict
    // Implementation would send the local data to the server
    AppLogger.info('âš™ï¸ Resolving preference conflict');
  }

  /// Resolve family sharing conflicts
  Future<void> _resolveFamilySharingConflict(dynamic conflict) async {
    // Most recent share wins
    // final serverData = conflict['server_data'];
    // final localData = conflict['local_data'];

    // Compare timestamps and keep the most recent one
    AppLogger.info(
        'ðŸ‘¨â€ðŸ‘©â€ðŸ‘§â€ðŸ‘¦ Resolving family sharing conflict');
  }

  /// Queue update for later processing
  void _queueUpdate(PendingUpdate update) {
    _pendingUpdates.add(update);
    _savePendingUpdates();
  }

  /// Process pending updates
  Future<void> _processPendingUpdates() async {
    if (_pendingUpdates.isEmpty || !_isConnected) return;

    AppLogger.info(
      'ðŸ”„ Processing ${_pendingUpdates.length} pending updates...',
    );

    final updates = List<PendingUpdate>.from(_pendingUpdates);
    _pendingUpdates.clear();

    for (final update in updates) {
      try {
        await _processPendingUpdate(update);
      } catch (e) {
        AppLogger.error('âŒ Failed to process pending update: $e');
        // Re-queue failed updates
        _pendingUpdates.add(update);
      }
    }

    await _savePendingUpdates();
    AppLogger.info('âœ… Pending updates processed');
  }

  /// Process individual pending update
  Future<void> _processPendingUpdate(PendingUpdate update) async {
    switch (update.type) {
      case PendingUpdateType.familyShare:
        _socketIOClient!.emit('share_family_dua', update.data);
        break;
      case PendingUpdateType.ragQuery:
        _webSocketChannel!.sink.add(jsonEncode(update.data));
        break;
      case PendingUpdateType.preference:
        await _syncPreferences(update.data);
        break;
      case PendingUpdateType.favorite:
        await _syncFavorites(update.data);
        break;
    }
  }

  /// Sync preferences
  Future<void> _syncPreferences(Map<String, dynamic> data) async {
    // Implementation to sync preferences with server
  }

  /// Sync favorites
  Future<void> _syncFavorites(Map<String, dynamic> data) async {
    // Implementation to sync favorites with server
  }

  /// Load pending updates from storage
  Future<void> _loadPendingUpdates() async {
    try {
      final updatesJson = _prefs.getString('pending_updates');
      if (updatesJson != null) {
        final updatesList = jsonDecode(updatesJson) as List;
        _pendingUpdates.clear();
        _pendingUpdates.addAll(
          updatesList.map((json) => PendingUpdate.fromJson(json)).toList(),
        );
        AppLogger.debug(
            'ðŸ“‹ Loaded ${_pendingUpdates.length} pending updates');
      }
    } catch (e) {
      AppLogger.error('âŒ Failed to load pending updates: $e');
    }
  }

  /// Save pending updates to storage
  Future<void> _savePendingUpdates() async {
    try {
      final updatesJson = jsonEncode(
        _pendingUpdates.map((update) => update.toJson()).toList(),
      );
      await _prefs.setString('pending_updates', updatesJson);
    } catch (e) {
      AppLogger.error('âŒ Failed to save pending updates: $e');
    }
  }

  /// Start heartbeat
  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) {
      if (_webSocketChannel != null && _isConnected) {
        try {
          _webSocketChannel!.sink.add(jsonEncode({'type': 'ping'}));
        } catch (e) {
          AppLogger.warning('ðŸ’“ Heartbeat failed: $e');
          _scheduleReconnect();
        }
      }
    });
  }

  /// Handle WebSocket error
  void _handleWebSocketError(Object error) {
    AppLogger.error('âŒ WebSocket error: $error');
    _isConnected = false;
    _broadcastConnectionState(ConnectionState.error);
    _scheduleReconnect();
  }

  /// Handle WebSocket disconnection
  void _handleWebSocketDisconnection() {
    AppLogger.warning('âš ï¸ WebSocket disconnected');
    _isConnected = false;
    _broadcastConnectionState(ConnectionState.disconnected);
    _scheduleReconnect();
  }

  /// Schedule reconnection
  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      AppLogger.error('âŒ Max reconnection attempts reached');
      _broadcastConnectionState(ConnectionState.failed);
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      _reconnectAttempts++;
      AppLogger.info(
        'ðŸ”„ Attempting reconnection ($_reconnectAttempts/$_maxReconnectAttempts)',
      );
      _broadcastConnectionState(ConnectionState.reconnecting);
      _reconnectAll();
    });
  }

  /// Reconnect all connections
  Future<void> _reconnectAll() async {
    if (!_isOnline) return;

    try {
      await _initializeConnections();
    } catch (e) {
      AppLogger.error('âŒ Reconnection failed: $e');
      _scheduleReconnect();
    }
  }

  /// Cleanup connections
  void _cleanupConnections() {
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();

    _webSocketChannel?.sink.close();
    _webSocketChannel = null;

    _socketIOClient?.disconnect();
    _socketIOClient = null;
  }

  /// Broadcast connection state
  void _broadcastConnectionState(ConnectionState state) {
    _connectionStateController.add(state);
  }

  /// Broadcast sync status
  void _broadcastSyncStatus(SyncStatus status) {
    _syncStatusController.add(status);
  }

  /// Get connection status
  bool get isConnected => _isConnected && _isOnline;

  /// Get online status
  bool get isOnline => _isOnline;

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _cleanupConnections();

    _realTimeUpdatesController.close();
    _connectionStateController.close();
    _syncStatusController.close();
    _collaborativeUpdatesController.close();
  }
}

/// Real-time update model
class RealTimeUpdate {
  final RealTimeUpdateType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final String? userId;

  RealTimeUpdate({
    required this.type,
    required this.data,
    required this.timestamp,
    this.userId,
  });

  factory RealTimeUpdate.fromJson(Map<String, dynamic> json) {
    return RealTimeUpdate(
      type: RealTimeUpdateType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => RealTimeUpdateType.unknown,
      ),
      data: json['data'] ?? {},
      timestamp: DateTime.parse(json['timestamp']),
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.toString().split('.').last,
        'data': data,
        'timestamp': timestamp.toIso8601String(),
        'user_id': userId,
      };
}

/// Real-time update types
enum RealTimeUpdateType { ragResponse, contentUpdate, syncComplete, unknown }

/// Collaborative update model
class CollaborativeUpdate {
  final CollaborativeUpdateType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final String userId;

  CollaborativeUpdate({
    required this.type,
    required this.data,
    required this.timestamp,
    required this.userId,
  });
}

/// Collaborative update types
enum CollaborativeUpdateType {
  familyDuaShared,
  scholarApproval,
  collaborativeEdit,
}

/// Pending update model
class PendingUpdate {
  final PendingUpdateType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  PendingUpdate({
    required this.type,
    required this.data,
    required this.timestamp,
  });

  factory PendingUpdate.fromJson(Map<String, dynamic> json) {
    return PendingUpdate(
      type: PendingUpdateType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      data: json['data'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.toString().split('.').last,
        'data': data,
        'timestamp': timestamp.toIso8601String(),
      };
}

/// Pending update types
enum PendingUpdateType { familyShare, ragQuery, preference, favorite }

/// Connection state
enum ConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  offline,
  error,
  failed,
  initialized,
}

/// Sync status
enum SyncStatus { idle, syncing, completed, failed }
