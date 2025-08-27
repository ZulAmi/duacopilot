import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../core/logging/app_logger.dart';
import '../secure_storage/secure_storage_service.dart';

/// Intelligent Background Sync Service using WorkManager
/// Handles offline data synchronization with smart scheduling
class IntelligentBackgroundSyncService {
  static IntelligentBackgroundSyncService? _instance;
  static IntelligentBackgroundSyncService get instance =>
      _instance ??= IntelligentBackgroundSyncService._();

  IntelligentBackgroundSyncService._();

  // Service dependencies
  late SharedPreferences _prefs;

  // Background task identifiers
  static const String _periodicSyncTask = 'periodic_sync_task';
  static const String _urgentSyncTask = 'urgent_sync_task';
  static const String _contentUpdateTask = 'content_update_task';
  static const String _familySyncTask = 'family_sync_task';

  // Configuration constants
  static const Duration _minSyncInterval = Duration(minutes: 15);
  static const Duration _maxSyncInterval = Duration(hours: 4);
  static const Duration _urgentSyncDelay = Duration(minutes: 2);

  // State tracking
  bool _isInitialized = false;
  bool _isEnabled = true;
  DateTime? _lastSyncTime;
  int _consecutiveFailures = 0;

  // Usage pattern tracking
  final Map<String, DateTime> _usagePatterns = {};
  final List<int> _activeHours = [];

  /// Initialize the background sync service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info(
          'ðŸ”„ Initializing Intelligent Background Sync Service...');

      _prefs = await SharedPreferences.getInstance();

      // Load saved state
      await _loadState();

      // Initialize WorkManager
      await _initializeWorkManager();

      // Schedule intelligent sync tasks
      await _scheduleIntelligentSync();

      // Load usage patterns
      await _loadUsagePatterns();

      _isInitialized = true;
      AppLogger.info('âœ… Intelligent Background Sync Service initialized');
    } catch (e) {
      AppLogger.error('âŒ Failed to initialize background sync service: $e');
      rethrow;
    }
  }

  /// Initialize WorkManager with callback dispatcher
  Future<void> _initializeWorkManager() async {
    try {
      await Workmanager().initialize(
        _callbackDispatcher,
        isInDebugMode: false, // Set to true for debugging
      );
      AppLogger.info('ðŸ“± WorkManager initialized');
    } catch (e) {
      AppLogger.error('âŒ Failed to initialize WorkManager: $e');
      // Continue without WorkManager if initialization fails
      _isEnabled = false;
    }
  }

  /// Schedule intelligent sync based on usage patterns
  Future<void> _scheduleIntelligentSync() async {
    if (!_isEnabled) return;

    try {
      // Cancel existing tasks
      await _cancelAllTasks();

      // Schedule periodic sync with intelligent timing
      final optimalInterval = _calculateOptimalSyncInterval();

      await Workmanager().registerPeriodicTask(
        _periodicSyncTask,
        _periodicSyncTask,
        frequency: optimalInterval,
        initialDelay: Duration(minutes: 5),
        constraints: Constraints(
            networkType: NetworkType.connected, requiresBatteryNotLow: true),
        inputData: {'sync_type': 'periodic', 'priority': 'normal'},
      );

      // Schedule content update checks during active hours
      if (_activeHours.isNotEmpty) {
        await _scheduleContentUpdateChecks();
      }

      AppLogger.info(
          'ðŸ“… Intelligent sync scheduled (${optimalInterval.inMinutes}min intervals)');
    } catch (e) {
      AppLogger.error('âŒ Failed to schedule intelligent sync: $e');
    }
  }

  /// Schedule content update checks during user's active hours
  Future<void> _scheduleContentUpdateChecks() async {
    try {
      await Workmanager().registerPeriodicTask(
        _contentUpdateTask,
        _contentUpdateTask,
        frequency:
            Duration(hours: 2), // Check every 2 hours during active periods
        constraints: Constraints(networkType: NetworkType.connected),
        inputData: {
          'sync_type': 'content_update',
          'priority': 'low',
          'active_hours': _activeHours
        },
      );

      AppLogger.info('ðŸ“š Content update checks scheduled');
    } catch (e) {
      AppLogger.error('âŒ Failed to schedule content updates: $e');
    }
  }

  /// Calculate optimal sync interval based on usage patterns
  Duration _calculateOptimalSyncInterval() {
    // Start with default interval
    Duration interval = Duration(hours: 1);

    // Analyze usage frequency
    final now = DateTime.now();
    final recentUsage = _usagePatterns.entries
        .where((entry) => now.difference(entry.value).inDays <= 7)
        .length;

    if (recentUsage > 20) {
      // Heavy usage - sync more frequently
      interval = _minSyncInterval;
    } else if (recentUsage > 10) {
      // Moderate usage
      interval = Duration(minutes: 30);
    } else if (recentUsage < 3) {
      // Light usage - sync less frequently
      interval = _maxSyncInterval;
    }

    // Consider battery optimization
    if (_consecutiveFailures > 2) {
      // Increase interval after consecutive failures
      interval = Duration(seconds: interval.inSeconds * 2);
    }

    // Ensure within bounds
    if (interval < _minSyncInterval) interval = _minSyncInterval;
    if (interval > _maxSyncInterval) interval = _maxSyncInterval;

    return interval;
  }

  /// Schedule urgent sync for critical updates
  Future<void> scheduleUrgentSync(
      {required String reason, Map<String, dynamic>? data}) async {
    if (!_isEnabled) return;

    try {
      await Workmanager().registerOneOffTask(
        '${_urgentSyncTask}_${DateTime.now().millisecondsSinceEpoch}',
        _urgentSyncTask,
        initialDelay: _urgentSyncDelay,
        constraints: Constraints(networkType: NetworkType.connected),
        inputData: {
          'sync_type': 'urgent',
          'priority': 'high',
          'reason': reason,
          'data': data ?? {}
        },
      );

      AppLogger.info('ðŸš¨ Urgent sync scheduled: $reason');
    } catch (e) {
      AppLogger.error('âŒ Failed to schedule urgent sync: $e');
    }
  }

  /// Schedule family sync for collaborative features
  Future<void> scheduleFamilySync(
      {required String familyId, required String action}) async {
    if (!_isEnabled) return;

    try {
      await Workmanager().registerOneOffTask(
        '${_familySyncTask}_${DateTime.now().millisecondsSinceEpoch}',
        _familySyncTask,
        initialDelay: Duration(seconds: 30), // Quick sync for family actions
        constraints: Constraints(networkType: NetworkType.connected),
        inputData: {
          'sync_type': 'family',
          'priority': 'high',
          'family_id': familyId,
          'action': action
        },
      );

      AppLogger.info(
          'ðŸ‘¨â€ðŸ‘©â€ðŸ‘§â€ðŸ‘¦ Family sync scheduled: $action');
    } catch (e) {
      AppLogger.error('âŒ Failed to schedule family sync: $e');
    }
  }

  /// Record usage pattern for intelligent scheduling
  void recordUsage(String feature) {
    _usagePatterns[feature] = DateTime.now();
    _updateActiveHours();
    _saveUsagePatterns();
  }

  /// Update active hours based on usage patterns
  void _updateActiveHours() {
    final now = DateTime.now();
    final currentHour = now.hour;

    if (!_activeHours.contains(currentHour)) {
      _activeHours.add(currentHour);

      // Keep only recent active hours (last 30 days worth)
      if (_activeHours.length > 24) {
        _activeHours.removeAt(0);
      }
    }
  }

  /// Load saved state from preferences
  Future<void> _loadState() async {
    try {
      final lastSyncString = _prefs.getString('last_sync_time');
      if (lastSyncString != null) {
        _lastSyncTime = DateTime.parse(lastSyncString);
      }

      _consecutiveFailures = _prefs.getInt('consecutive_failures') ?? 0;
      _isEnabled = _prefs.getBool('sync_enabled') ?? true;
    } catch (e) {
      AppLogger.error('âŒ Failed to load sync state: $e');
    }
  }

  /// Save current state to preferences
  Future<void> _saveState() async {
    try {
      if (_lastSyncTime != null) {
        await _prefs.setString(
            'last_sync_time', _lastSyncTime!.toIso8601String());
      }

      await _prefs.setInt('consecutive_failures', _consecutiveFailures);
      await _prefs.setBool('sync_enabled', _isEnabled);
    } catch (e) {
      AppLogger.error('âŒ Failed to save sync state: $e');
    }
  }

  /// Load usage patterns from preferences
  Future<void> _loadUsagePatterns() async {
    try {
      final patternsJson = _prefs.getString('usage_patterns');
      if (patternsJson != null) {
        final patterns = jsonDecode(patternsJson) as Map<String, dynamic>;
        _usagePatterns.clear();

        patterns.forEach((key, value) {
          _usagePatterns[key] = DateTime.parse(value);
        });
      }

      final activeHoursJson = _prefs.getString('active_hours');
      if (activeHoursJson != null) {
        final hours = jsonDecode(activeHoursJson) as List<dynamic>;
        _activeHours.clear();
        _activeHours.addAll(hours.cast<int>());
      }
    } catch (e) {
      AppLogger.error('âŒ Failed to load usage patterns: $e');
    }
  }

  /// Save usage patterns to preferences
  Future<void> _saveUsagePatterns() async {
    try {
      final patterns = <String, String>{};
      _usagePatterns.forEach((key, value) {
        patterns[key] = value.toIso8601String();
      });

      await _prefs.setString('usage_patterns', jsonEncode(patterns));
      await _prefs.setString('active_hours', jsonEncode(_activeHours));
    } catch (e) {
      AppLogger.error('âŒ Failed to save usage patterns: $e');
    }
  }

  /// Cancel all background tasks
  Future<void> _cancelAllTasks() async {
    try {
      await Workmanager().cancelAll();
    } catch (e) {
      AppLogger.error('âŒ Failed to cancel tasks: $e');
    }
  }

  /// Enable or disable background sync
  Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
    await _saveState();

    if (enabled) {
      await _scheduleIntelligentSync();
    } else {
      await _cancelAllTasks();
    }

    AppLogger.info(
        'âš™ï¸ Background sync ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Get sync statistics
  Map<String, dynamic> getSyncStats() {
    return {
      'is_enabled': _isEnabled,
      'last_sync_time': _lastSyncTime?.toIso8601String(),
      'consecutive_failures': _consecutiveFailures,
      'usage_patterns_count': _usagePatterns.length,
      'active_hours': _activeHours,
      'next_sync_interval': _calculateOptimalSyncInterval().inMinutes,
    };
  }

  /// Force immediate sync
  Future<void> forceSyncNow() async {
    await scheduleUrgentSync(reason: 'Manual sync requested');
  }

  /// Dispose resources
  void dispose() {
    _saveState();
    _saveUsagePatterns();
  }
}

/// WorkManager callback dispatcher
/// This function runs in a separate isolate
@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      AppLogger.info('ðŸ”„ Executing background task: $task');

      switch (task) {
        case IntelligentBackgroundSyncService._periodicSyncTask:
          await _executePeriodicSync(inputData);
          break;

        case IntelligentBackgroundSyncService._urgentSyncTask:
          await _executeUrgentSync(inputData);
          break;

        case IntelligentBackgroundSyncService._contentUpdateTask:
          await _executeContentUpdateTask(inputData);
          break;

        case IntelligentBackgroundSyncService._familySyncTask:
          await _executeFamilySync(inputData);
          break;

        default:
          AppLogger.warning('âš ï¸ Unknown background task: $task');
          return false;
      }

      AppLogger.info('âœ… Background task completed: $task');
      return true;
    } catch (e) {
      AppLogger.error('âŒ Background task failed: $task - $e');
      return false;
    }
  });
}

/// Execute periodic background sync
Future<void> _executePeriodicSync(Map<String, dynamic>? inputData) async {
  try {
    // Initialize services in background isolate
    final prefs = await SharedPreferences.getInstance();
    final secureStorage = SecureStorageService.instance;
    await secureStorage.initialize();

    // Check connectivity
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      AppLogger.info('âš ï¸ No connectivity, skipping periodic sync');
      return;
    }

    // Perform incremental sync
    await _performBackgroundSync(
        syncType: 'incremental',
        priority: inputData?['priority'] as String? ?? 'normal');

    // Update last sync time
    await prefs.setString('last_sync_time', DateTime.now().toIso8601String());
  } catch (e) {
    AppLogger.error('âŒ Periodic sync failed: $e');
    rethrow;
  }
}

/// Execute urgent sync task
Future<void> _executeUrgentSync(Map<String, dynamic>? inputData) async {
  try {
    final reason = inputData?['reason'] as String? ?? 'Unknown';
    AppLogger.info('ðŸš¨ Executing urgent sync: $reason');

    await _performBackgroundSync(
      syncType: 'urgent',
      priority: 'high',
      data: inputData?['data'] as Map<String, dynamic>?,
    );
  } catch (e) {
    AppLogger.error('âŒ Urgent sync failed: $e');
    rethrow;
  }
}

/// Execute content update task
Future<void> _executeContentUpdateTask(Map<String, dynamic>? inputData) async {
  try {
    final activeHours = inputData?['active_hours'] as List<dynamic>?;
    final currentHour = DateTime.now().hour;

    // Only run during user's active hours if specified
    if (activeHours != null && activeHours.isNotEmpty) {
      if (!activeHours.contains(currentHour)) {
        AppLogger.info('â° Outside active hours, skipping content update');
        return;
      }
    }

    await _performBackgroundSync(syncType: 'content_update', priority: 'low');
  } catch (e) {
    AppLogger.error('âŒ Content update task failed: $e');
    rethrow;
  }
}

/// Execute family sync task
Future<void> _executeFamilySync(Map<String, dynamic>? inputData) async {
  try {
    final familyId = inputData?['family_id'] as String?;
    final action = inputData?['action'] as String?;

    AppLogger.info(
        'ðŸ‘¨â€ðŸ‘©â€ðŸ‘§â€ðŸ‘¦ Executing family sync: $action for family $familyId');

    await _performBackgroundSync(
        syncType: 'family', priority: 'high', data: inputData);
  } catch (e) {
    AppLogger.error('âŒ Family sync failed: $e');
    rethrow;
  }
}

/// Perform the actual background synchronization
Future<void> _performBackgroundSync({
  required String syncType,
  required String priority,
  Map<String, dynamic>? data,
}) async {
  try {
    AppLogger.info(
        'ðŸ”„ Performing background sync: $syncType ($priority priority)');

    // Simulate sync operations based on type
    switch (syncType) {
      case 'incremental':
        await _syncUserPreferences();
        await _syncFavorites();
        await _syncRecentQueries();
        break;

      case 'urgent':
        await _syncCriticalData(data);
        break;

      case 'content_update':
        await _checkForContentUpdates();
        break;

      case 'family':
        await _syncFamilyData(data);
        break;
    }

    // Add artificial delay to simulate real sync work
    await Future.delayed(Duration(seconds: 1 + Random().nextInt(3)));

    AppLogger.info('âœ… Background sync completed: $syncType');
  } catch (e) {
    AppLogger.error('âŒ Background sync operation failed: $e');
    rethrow;
  }
}

/// Sync user preferences
Future<void> _syncUserPreferences() async {
  AppLogger.debug('ðŸ”„ Syncing user preferences...');
  // Implementation would sync preferences with server
  await Future.delayed(Duration(milliseconds: 500));
}

/// Sync favorites
Future<void> _syncFavorites() async {
  AppLogger.debug('ðŸ”„ Syncing favorites...');
  // Implementation would sync favorites with server
  await Future.delayed(Duration(milliseconds: 300));
}

/// Sync recent queries
Future<void> _syncRecentQueries() async {
  AppLogger.debug('ðŸ”„ Syncing recent queries...');
  // Implementation would sync query history with server
  await Future.delayed(Duration(milliseconds: 200));
}

/// Sync critical data for urgent updates
Future<void> _syncCriticalData(Map<String, dynamic>? data) async {
  AppLogger.debug('ðŸš¨ Syncing critical data...');
  // Implementation would sync critical updates immediately
  await Future.delayed(Duration(milliseconds: 800));
}

/// Check for content updates from scholars
Future<void> _checkForContentUpdates() async {
  AppLogger.debug('ðŸ“š Checking for content updates...');
  // Implementation would check for new approved Du'as from scholars
  await Future.delayed(Duration(milliseconds: 600));
}

/// Sync family collaborative data
Future<void> _syncFamilyData(Map<String, dynamic>? data) async {
  AppLogger.debug('ðŸ‘¨â€ðŸ‘©â€ðŸ‘§â€ðŸ‘¦ Syncing family data...');
  // Implementation would sync family sharing and collaborative features
  await Future.delayed(Duration(milliseconds: 400));
}
