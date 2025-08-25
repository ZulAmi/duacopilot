import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../core/logging/app_logger.dart';
import '../secure_storage/secure_storage_service.dart';

/// Collaborative Features Service for Family Du'a Sharing
/// Handles real-time family collaboration, sharing, and group activities
class CollaborativeService {
  static CollaborativeService? _instance;
  static CollaborativeService get instance => _instance ??= CollaborativeService._();

  CollaborativeService._();

  // Service dependencies
  late SecureStorageService _secureStorage;
  late SharedPreferences _prefs;

  // Socket.IO connection
  IO.Socket? _socket;

  // State management
  bool _isInitialized = false;
  bool _isConnected = false;
  bool _isOnline = true;
  String? _currentFamilyId;
  String? _currentUserId;

  // Stream controllers for collaborative events
  final _familyDuaSharedController = StreamController<FamilyDuaShare>.broadcast();
  final _familyMemberJoinedController = StreamController<FamilyMemberJoined>.broadcast();
  final _familyMemberLeftController = StreamController<FamilyMemberLeft>.broadcast();
  final _collaborativeEditController = StreamController<CollaborativeEdit>.broadcast();
  final _familyActivityController = StreamController<FamilyActivity>.broadcast();
  final _prayerSessionController = StreamController<PrayerSession>.broadcast();

  // Public streams
  Stream<FamilyDuaShare> get familyDuaSharedStream => _familyDuaSharedController.stream;
  Stream<FamilyMemberJoined> get familyMemberJoinedStream => _familyMemberJoinedController.stream;
  Stream<FamilyMemberLeft> get familyMemberLeftStream => _familyMemberLeftController.stream;
  Stream<CollaborativeEdit> get collaborativeEditStream => _collaborativeEditController.stream;
  Stream<FamilyActivity> get familyActivityStream => _familyActivityController.stream;
  Stream<PrayerSession> get prayerSessionStream => _prayerSessionController.stream;

  // Family data caching
  final Map<String, FamilyMember> _familyMembers = {};
  final List<FamilyDuaShare> _recentShares = [];
  final List<FamilyActivity> _recentActivities = [];

  /// Initialize the collaborative service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('🔄 Initializing Collaborative Service...');

      _secureStorage = SecureStorageService.instance;
      await _secureStorage.initialize();

      _prefs = await SharedPreferences.getInstance();

      // Load user and family data
      await _loadUserAndFamilyData();

      // Setup connectivity monitoring
      await _setupConnectivityMonitoring();

      // Initialize Socket.IO connection if family exists
      if (_currentFamilyId != null) {
        await _initializeSocketConnection();
      }

      _isInitialized = true;
      AppLogger.info('✅ Collaborative Service initialized');
    } catch (e) {
      AppLogger.error('❌ Failed to initialize Collaborative Service: $e');
      rethrow;
    }
  }

  /// Load user and family data
  Future<void> _loadUserAndFamilyData() async {
    _currentUserId = await _secureStorage.getUserId();
    _currentFamilyId = await _secureStorage.read('family_id');

    if (_currentFamilyId != null) {
      AppLogger.info('👨‍👩‍👧‍👦 Found family ID: $_currentFamilyId');
      await _loadFamilyMembers();
      await _loadRecentShares();
      await _loadRecentActivities();
    } else {
      AppLogger.info('👤 No family associated with this user');
    }
  }

  /// Setup connectivity monitoring
  Future<void> _setupConnectivityMonitoring() async {
    final connectivity = Connectivity();
    _isOnline = await connectivity.checkConnectivity() != ConnectivityResult.none;

    connectivity.onConnectivityChanged.listen((result) {
      final wasOnline = _isOnline;
      _isOnline = result != ConnectivityResult.none;

      if (!wasOnline && _isOnline && _currentFamilyId != null) {
        AppLogger.info('🌐 Internet restored, reconnecting to family collaboration...');
        _initializeSocketConnection();
      } else if (wasOnline && !_isOnline) {
        AppLogger.warning('📡 Internet lost, collaborative features offline');
        _isConnected = false;
        _socket?.disconnect();
      }
    });
  }

  /// Initialize Socket.IO connection for real-time collaboration
  Future<void> _initializeSocketConnection() async {
    if (!_isOnline || _currentFamilyId == null) return;

    try {
      final token = await _secureStorage.read('auth_token');

      _socket = IO.io(
        'https://api.duacopilot.com',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({if (token != null) 'token': token, 'user_id': _currentUserId, 'family_id': _currentFamilyId})
            .enableReconnection()
            .setReconnectionAttempts(5)
            .setReconnectionDelay(5000)
            .build(),
      );

      _socket!.onConnect((_) {
        AppLogger.info('✅ Connected to collaborative server');
        _isConnected = true;
        _setupSocketListeners();
        _joinFamilyRoom();
      });

      _socket!.onDisconnect((_) {
        AppLogger.warning('⚠️ Disconnected from collaborative server');
        _isConnected = false;
      });

      _socket!.onConnectError((error) {
        AppLogger.error('❌ Collaborative connection error: $error');
        _isConnected = false;
      });

      _socket!.connect();
    } catch (e) {
      AppLogger.error('❌ Failed to initialize socket connection: $e');
    }
  }

  /// Setup Socket.IO event listeners
  void _setupSocketListeners() {
    _socket!.on('family_dua_shared', (data) {
      _handleFamilyDuaShared(data);
    });

    _socket!.on('family_member_joined', (data) {
      _handleFamilyMemberJoined(data);
    });

    _socket!.on('family_member_left', (data) {
      _handleFamilyMemberLeft(data);
    });

    _socket!.on('collaborative_edit', (data) {
      _handleCollaborativeEdit(data);
    });

    _socket!.on('family_activity', (data) {
      _handleFamilyActivity(data);
    });

    _socket!.on('prayer_session_started', (data) {
      _handlePrayerSessionStarted(data);
    });

    _socket!.on('prayer_session_joined', (data) {
      _handlePrayerSessionJoined(data);
    });

    _socket!.on('prayer_session_ended', (data) {
      _handlePrayerSessionEnded(data);
    });
  }

  /// Join family room for collaborative features
  void _joinFamilyRoom() {
    if (_socket?.connected == true && _currentFamilyId != null) {
      _socket!.emit('join_family', {'family_id': _currentFamilyId, 'user_id': _currentUserId});
      AppLogger.info('👨‍👩‍👧‍👦 Joined family room: $_currentFamilyId');
    }
  }

  /// Share Du'a with family
  Future<void> shareDuaWithFamily({
    required String duaId,
    required String duaTitle,
    required String duaText,
    String? personalNote,
    List<String>? tags,
    String? category,
  }) async {
    try {
      if (_currentFamilyId == null) {
        throw Exception('No family associated with this user');
      }

      final shareData = {
        'dua_id': duaId,
        'dua_title': duaTitle,
        'dua_text': duaText,
        'personal_note': personalNote,
        'tags': tags ?? [],
        'category': category,
        'shared_by': _currentUserId,
        'shared_at': DateTime.now().toIso8601String(),
        'family_id': _currentFamilyId,
      };

      if (_isConnected) {
        _socket!.emit('share_family_dua', shareData);
        AppLogger.info('📤 Du\'a shared with family: $duaTitle');
      } else {
        // Queue for later when connection is restored
        await _queueFamilyShare(shareData);
        AppLogger.info('📋 Du\'a sharing queued (offline): $duaTitle');
      }

      // Add to local cache
      final share = FamilyDuaShare.fromJson(shareData);
      _recentShares.insert(0, share);
      if (_recentShares.length > 50) {
        _recentShares.removeLast();
      }
      await _saveRecentShares();
    } catch (e) {
      AppLogger.error('❌ Failed to share Du\'a with family: $e');
      rethrow;
    }
  }

  /// Start a family prayer session
  Future<void> startFamilyPrayerSession({
    required String sessionName,
    required List<String> duaIds,
    int? durationMinutes,
    String? description,
  }) async {
    try {
      if (_currentFamilyId == null) {
        throw Exception('No family associated with this user');
      }

      final sessionData = {
        'session_id': 'session_${DateTime.now().millisecondsSinceEpoch}',
        'session_name': sessionName,
        'dua_ids': duaIds,
        'duration_minutes': durationMinutes,
        'description': description,
        'started_by': _currentUserId,
        'started_at': DateTime.now().toIso8601String(),
        'family_id': _currentFamilyId,
        'status': 'active',
      };

      if (_isConnected) {
        _socket!.emit('start_prayer_session', sessionData);
        AppLogger.info('🤲 Started family prayer session: $sessionName');
      } else {
        AppLogger.warning('⚠️ Cannot start prayer session while offline');
        throw Exception('Cannot start prayer session while offline');
      }
    } catch (e) {
      AppLogger.error('❌ Failed to start family prayer session: $e');
      rethrow;
    }
  }

  /// Join an active family prayer session
  Future<void> joinFamilyPrayerSession(String sessionId) async {
    try {
      if (!_isConnected) {
        throw Exception('Cannot join prayer session while offline');
      }

      _socket!.emit('join_prayer_session', {
        'session_id': sessionId,
        'user_id': _currentUserId,
        'family_id': _currentFamilyId,
        'joined_at': DateTime.now().toIso8601String(),
      });

      AppLogger.info('🤲 Joined family prayer session: $sessionId');
    } catch (e) {
      AppLogger.error('❌ Failed to join prayer session: $e');
      rethrow;
    }
  }

  /// Leave a family prayer session
  Future<void> leaveFamilyPrayerSession(String sessionId) async {
    try {
      if (!_isConnected) return;

      _socket!.emit('leave_prayer_session', {
        'session_id': sessionId,
        'user_id': _currentUserId,
        'family_id': _currentFamilyId,
        'left_at': DateTime.now().toIso8601String(),
      });

      AppLogger.info('👋 Left family prayer session: $sessionId');
    } catch (e) {
      AppLogger.error('❌ Failed to leave prayer session: $e');
    }
  }

  /// Create a family group
  Future<void> createFamily({required String familyName, String? description}) async {
    try {
      final familyId = 'family_${DateTime.now().millisecondsSinceEpoch}';

      // Save family information
      await _secureStorage.write('family_id', familyId);
      await _secureStorage.write('family_name', familyName);

      _currentFamilyId = familyId;

      // Initialize family data
      final creator = FamilyMember(
        id: _currentUserId!,
        name: await _secureStorage.read('user_name') ?? 'Me',
        role: 'admin',
        joinedAt: DateTime.now(),
        isOnline: true,
      );

      _familyMembers[_currentUserId!] = creator;
      await _saveFamilyMembers();

      // Connect to collaborative features
      if (_isOnline) {
        await _initializeSocketConnection();
      }

      AppLogger.info('👨‍👩‍👧‍👦 Created family: $familyName ($familyId)');
    } catch (e) {
      AppLogger.error('❌ Failed to create family: $e');
      rethrow;
    }
  }

  /// Join an existing family
  Future<void> joinFamily(String familyId, String inviteCode) async {
    try {
      // Validate invite code (in real app, this would be done server-side)

      // Save family information
      await _secureStorage.write('family_id', familyId);
      _currentFamilyId = familyId;

      // Connect to collaborative features
      if (_isOnline) {
        await _initializeSocketConnection();
      }

      AppLogger.info('👨‍👩‍👧‍👦 Joined family: $familyId');
    } catch (e) {
      AppLogger.error('❌ Failed to join family: $e');
      rethrow;
    }
  }

  /// Leave the current family
  Future<void> leaveFamily() async {
    try {
      if (_currentFamilyId == null) return;

      if (_isConnected) {
        _socket!.emit('leave_family', {
          'family_id': _currentFamilyId,
          'user_id': _currentUserId,
          'left_at': DateTime.now().toIso8601String(),
        });
      }

      // Clean up local data
      await _secureStorage.delete('family_id');
      await _secureStorage.delete('family_name');
      _currentFamilyId = null;
      _familyMembers.clear();
      _recentShares.clear();
      _recentActivities.clear();

      // Disconnect socket
      _socket?.disconnect();
      _isConnected = false;

      AppLogger.info('👋 Left family');
    } catch (e) {
      AppLogger.error('❌ Failed to leave family: $e');
    }
  }

  /// Handle family Du'a shared event
  void _handleFamilyDuaShared(dynamic data) {
    try {
      final share = FamilyDuaShare.fromJson(data);
      _familyDuaSharedController.add(share);

      // Add to local cache
      _recentShares.insert(0, share);
      if (_recentShares.length > 50) {
        _recentShares.removeLast();
      }
      _saveRecentShares();

      AppLogger.info('📥 Family Du\'a received: ${share.duaTitle}');
    } catch (e) {
      AppLogger.error('❌ Failed to handle family Du\'a shared: $e');
    }
  }

  /// Handle family member joined event
  void _handleFamilyMemberJoined(dynamic data) {
    try {
      final event = FamilyMemberJoined.fromJson(data);
      _familyMemberJoinedController.add(event);

      // Add to family members cache
      _familyMembers[event.member.id] = event.member;
      _saveFamilyMembers();

      AppLogger.info('👨‍👩‍👧‍👦 Family member joined: ${event.member.name}');
    } catch (e) {
      AppLogger.error('❌ Failed to handle family member joined: $e');
    }
  }

  /// Handle family member left event
  void _handleFamilyMemberLeft(dynamic data) {
    try {
      final event = FamilyMemberLeft.fromJson(data);
      _familyMemberLeftController.add(event);

      // Remove from family members cache
      _familyMembers.remove(event.memberId);
      _saveFamilyMembers();

      AppLogger.info('👋 Family member left: ${event.memberName}');
    } catch (e) {
      AppLogger.error('❌ Failed to handle family member left: $e');
    }
  }

  /// Handle collaborative edit event
  void _handleCollaborativeEdit(dynamic data) {
    try {
      final edit = CollaborativeEdit.fromJson(data);
      _collaborativeEditController.add(edit);

      AppLogger.debug('✏️ Collaborative edit received: ${edit.type}');
    } catch (e) {
      AppLogger.error('❌ Failed to handle collaborative edit: $e');
    }
  }

  /// Handle family activity event
  void _handleFamilyActivity(dynamic data) {
    try {
      final activity = FamilyActivity.fromJson(data);
      _familyActivityController.add(activity);

      // Add to recent activities cache
      _recentActivities.insert(0, activity);
      if (_recentActivities.length > 100) {
        _recentActivities.removeLast();
      }
      _saveRecentActivities();

      AppLogger.debug('📋 Family activity: ${activity.type}');
    } catch (e) {
      AppLogger.error('❌ Failed to handle family activity: $e');
    }
  }

  /// Handle prayer session started event
  void _handlePrayerSessionStarted(dynamic data) {
    try {
      final session = PrayerSession.fromJson(data);
      _prayerSessionController.add(session);

      AppLogger.info('🤲 Prayer session started: ${session.sessionName}');
    } catch (e) {
      AppLogger.error('❌ Failed to handle prayer session started: $e');
    }
  }

  /// Handle prayer session joined event
  void _handlePrayerSessionJoined(dynamic data) {
    try {
      final session = PrayerSession.fromJson(data);
      _prayerSessionController.add(session);

      AppLogger.info('🤲 Member joined prayer session: ${session.sessionName}');
    } catch (e) {
      AppLogger.error('❌ Failed to handle prayer session joined: $e');
    }
  }

  /// Handle prayer session ended event
  void _handlePrayerSessionEnded(dynamic data) {
    try {
      final session = PrayerSession.fromJson(data);
      _prayerSessionController.add(session);

      AppLogger.info('🤲 Prayer session ended: ${session.sessionName}');
    } catch (e) {
      AppLogger.error('❌ Failed to handle prayer session ended: $e');
    }
  }

  /// Queue family share for later processing
  Future<void> _queueFamilyShare(Map<String, dynamic> shareData) async {
    try {
      final queuedShares = await _getQueuedShares();
      queuedShares.add(shareData);
      await _prefs.setString('queued_family_shares', jsonEncode(queuedShares));
    } catch (e) {
      AppLogger.error('❌ Failed to queue family share: $e');
    }
  }

  /// Get queued family shares
  Future<List<dynamic>> _getQueuedShares() async {
    try {
      final sharesJson = _prefs.getString('queued_family_shares');
      if (sharesJson != null) {
        return jsonDecode(sharesJson) as List<dynamic>;
      }
    } catch (e) {
      AppLogger.error('❌ Failed to get queued shares: $e');
    }
    return [];
  }

  /// Process queued family shares
  Future<void> _processQueuedShares() async {
    try {
      final queuedShares = await _getQueuedShares();
      if (queuedShares.isEmpty) return;

      for (final shareData in queuedShares) {
        try {
          _socket!.emit('share_family_dua', shareData);
        } catch (e) {
          AppLogger.error('❌ Failed to process queued share: $e');
        }
      }

      // Clear processed shares
      await _prefs.remove('queued_family_shares');
      AppLogger.info('✅ Processed ${queuedShares.length} queued family shares');
    } catch (e) {
      AppLogger.error('❌ Failed to process queued shares: $e');
    }
  }

  /// Load family members from storage
  Future<void> _loadFamilyMembers() async {
    try {
      final membersJson = _prefs.getString('family_members_$_currentFamilyId');
      if (membersJson != null) {
        final membersData = jsonDecode(membersJson) as Map<String, dynamic>;
        _familyMembers.clear();
        membersData.forEach((id, data) {
          _familyMembers[id] = FamilyMember.fromJson(data);
        });
      }
    } catch (e) {
      AppLogger.error('❌ Failed to load family members: $e');
    }
  }

  /// Save family members to storage
  Future<void> _saveFamilyMembers() async {
    try {
      if (_currentFamilyId == null) return;

      final membersData = <String, dynamic>{};
      _familyMembers.forEach((id, member) {
        membersData[id] = member.toJson();
      });

      await _prefs.setString('family_members_$_currentFamilyId', jsonEncode(membersData));
    } catch (e) {
      AppLogger.error('❌ Failed to save family members: $e');
    }
  }

  /// Load recent shares from storage
  Future<void> _loadRecentShares() async {
    try {
      final sharesJson = _prefs.getString('recent_shares_$_currentFamilyId');
      if (sharesJson != null) {
        final sharesData = jsonDecode(sharesJson) as List<dynamic>;
        _recentShares.clear();
        _recentShares.addAll(sharesData.map((data) => FamilyDuaShare.fromJson(data)).toList());
      }
    } catch (e) {
      AppLogger.error('❌ Failed to load recent shares: $e');
    }
  }

  /// Save recent shares to storage
  Future<void> _saveRecentShares() async {
    try {
      if (_currentFamilyId == null) return;

      final sharesData = _recentShares.map((share) => share.toJson()).toList();
      await _prefs.setString('recent_shares_$_currentFamilyId', jsonEncode(sharesData));
    } catch (e) {
      AppLogger.error('❌ Failed to save recent shares: $e');
    }
  }

  /// Load recent activities from storage
  Future<void> _loadRecentActivities() async {
    try {
      final activitiesJson = _prefs.getString('recent_activities_$_currentFamilyId');
      if (activitiesJson != null) {
        final activitiesData = jsonDecode(activitiesJson) as List<dynamic>;
        _recentActivities.clear();
        _recentActivities.addAll(activitiesData.map((data) => FamilyActivity.fromJson(data)).toList());
      }
    } catch (e) {
      AppLogger.error('❌ Failed to load recent activities: $e');
    }
  }

  /// Save recent activities to storage
  Future<void> _saveRecentActivities() async {
    try {
      if (_currentFamilyId == null) return;

      final activitiesData = _recentActivities.map((activity) => activity.toJson()).toList();
      await _prefs.setString('recent_activities_$_currentFamilyId', jsonEncode(activitiesData));
    } catch (e) {
      AppLogger.error('❌ Failed to save recent activities: $e');
    }
  }

  /// Get family information
  Map<String, dynamic> getFamilyInfo() {
    return {
      'family_id': _currentFamilyId,
      'is_connected': _isConnected,
      'member_count': _familyMembers.length,
      'recent_shares_count': _recentShares.length,
      'recent_activities_count': _recentActivities.length,
    };
  }

  /// Get family members
  List<FamilyMember> getFamilyMembers() {
    return _familyMembers.values.toList();
  }

  /// Get recent family shares
  List<FamilyDuaShare> getRecentShares() {
    return List.from(_recentShares);
  }

  /// Get recent family activities
  List<FamilyActivity> getRecentActivities() {
    return List.from(_recentActivities);
  }

  /// Check if user has family
  bool get hasFamily => _currentFamilyId != null;

  /// Check if connected to collaborative server
  bool get isConnected => _isConnected;

  /// Dispose resources
  void dispose() {
    _socket?.disconnect();

    _familyDuaSharedController.close();
    _familyMemberJoinedController.close();
    _familyMemberLeftController.close();
    _collaborativeEditController.close();
    _familyActivityController.close();
    _prayerSessionController.close();
  }
}

/// Family Member model
class FamilyMember {
  final String id;
  final String name;
  final String role; // 'admin', 'member'
  final DateTime joinedAt;
  final bool isOnline;
  final String? avatarUrl;
  final Map<String, dynamic>? preferences;

  FamilyMember({
    required this.id,
    required this.name,
    required this.role,
    required this.joinedAt,
    required this.isOnline,
    this.avatarUrl,
    this.preferences,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      joinedAt: DateTime.parse(json['joined_at']),
      isOnline: json['is_online'] ?? false,
      avatarUrl: json['avatar_url'],
      preferences: json['preferences'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role,
    'joined_at': joinedAt.toIso8601String(),
    'is_online': isOnline,
    'avatar_url': avatarUrl,
    'preferences': preferences,
  };
}

/// Family Du'a Share model
class FamilyDuaShare {
  final String duaId;
  final String duaTitle;
  final String duaText;
  final String? personalNote;
  final List<String> tags;
  final String? category;
  final String sharedBy;
  final DateTime sharedAt;
  final String familyId;

  FamilyDuaShare({
    required this.duaId,
    required this.duaTitle,
    required this.duaText,
    required this.sharedBy,
    required this.sharedAt,
    required this.familyId,
    this.personalNote,
    this.tags = const [],
    this.category,
  });

  factory FamilyDuaShare.fromJson(Map<String, dynamic> json) {
    return FamilyDuaShare(
      duaId: json['dua_id'],
      duaTitle: json['dua_title'],
      duaText: json['dua_text'],
      sharedBy: json['shared_by'],
      sharedAt: DateTime.parse(json['shared_at']),
      familyId: json['family_id'],
      personalNote: json['personal_note'],
      tags: List<String>.from(json['tags'] ?? []),
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() => {
    'dua_id': duaId,
    'dua_title': duaTitle,
    'dua_text': duaText,
    'personal_note': personalNote,
    'tags': tags,
    'category': category,
    'shared_by': sharedBy,
    'shared_at': sharedAt.toIso8601String(),
    'family_id': familyId,
  };
}

/// Family Member Joined event
class FamilyMemberJoined {
  final FamilyMember member;
  final DateTime timestamp;

  FamilyMemberJoined({required this.member, required this.timestamp});

  factory FamilyMemberJoined.fromJson(Map<String, dynamic> json) {
    return FamilyMemberJoined(
      member: FamilyMember.fromJson(json['member']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

/// Family Member Left event
class FamilyMemberLeft {
  final String memberId;
  final String memberName;
  final DateTime timestamp;

  FamilyMemberLeft({required this.memberId, required this.memberName, required this.timestamp});

  factory FamilyMemberLeft.fromJson(Map<String, dynamic> json) {
    return FamilyMemberLeft(
      memberId: json['member_id'],
      memberName: json['member_name'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

/// Collaborative Edit event
class CollaborativeEdit {
  final String type; // 'dua_edit', 'note_edit', 'tag_edit'
  final String targetId;
  final String editedBy;
  final Map<String, dynamic> changes;
  final DateTime timestamp;

  CollaborativeEdit({
    required this.type,
    required this.targetId,
    required this.editedBy,
    required this.changes,
    required this.timestamp,
  });

  factory CollaborativeEdit.fromJson(Map<String, dynamic> json) {
    return CollaborativeEdit(
      type: json['type'],
      targetId: json['target_id'],
      editedBy: json['edited_by'],
      changes: json['changes'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

/// Family Activity event
class FamilyActivity {
  final String type; // 'dua_shared', 'prayer_completed', 'member_joined', etc.
  final String actorId;
  final String actorName;
  final String? targetId;
  final String? targetName;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  FamilyActivity({
    required this.type,
    required this.actorId,
    required this.actorName,
    required this.timestamp,
    this.targetId,
    this.targetName,
    this.metadata,
  });

  factory FamilyActivity.fromJson(Map<String, dynamic> json) {
    return FamilyActivity(
      type: json['type'],
      actorId: json['actor_id'],
      actorName: json['actor_name'],
      timestamp: DateTime.parse(json['timestamp']),
      targetId: json['target_id'],
      targetName: json['target_name'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'actor_id': actorId,
    'actor_name': actorName,
    'timestamp': timestamp.toIso8601String(),
    'target_id': targetId,
    'target_name': targetName,
    'metadata': metadata,
  };
}

/// Prayer Session model
class PrayerSession {
  final String sessionId;
  final String sessionName;
  final List<String> duaIds;
  final int? durationMinutes;
  final String? description;
  final String startedBy;
  final DateTime startedAt;
  final String familyId;
  final String status; // 'active', 'completed', 'cancelled'
  final List<String> participants;

  PrayerSession({
    required this.sessionId,
    required this.sessionName,
    required this.duaIds,
    required this.startedBy,
    required this.startedAt,
    required this.familyId,
    required this.status,
    required this.participants,
    this.durationMinutes,
    this.description,
  });

  factory PrayerSession.fromJson(Map<String, dynamic> json) {
    return PrayerSession(
      sessionId: json['session_id'],
      sessionName: json['session_name'],
      duaIds: List<String>.from(json['dua_ids'] ?? []),
      startedBy: json['started_by'],
      startedAt: DateTime.parse(json['started_at']),
      familyId: json['family_id'],
      status: json['status'],
      participants: List<String>.from(json['participants'] ?? []),
      durationMinutes: json['duration_minutes'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'session_id': sessionId,
    'session_name': sessionName,
    'dua_ids': duaIds,
    'duration_minutes': durationMinutes,
    'description': description,
    'started_by': startedBy,
    'started_at': startedAt.toIso8601String(),
    'family_id': familyId,
    'status': status,
    'participants': participants,
  };
}
