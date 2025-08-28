import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:workmanager/workmanager.dart';

import '../../core/logging/app_logger.dart';
import 'platform_optimization_service.dart';

/// Enhanced background task optimizer with platform-specific optimizations
class EnhancedBackgroundTaskOptimizer {
  static EnhancedBackgroundTaskOptimizer? _instance;
  static EnhancedBackgroundTaskOptimizer get instance => _instance ??= EnhancedBackgroundTaskOptimizer._();

  EnhancedBackgroundTaskOptimizer._();

  final PlatformOptimizationService _platformService = PlatformOptimizationService.instance;

  // Background task configuration
  Map<String, dynamic> _backgroundConfig = {};
  bool _isInitialized = false;
  bool _isBackgroundServiceRunning = false;

  // Task management
  final Map<String, BackgroundTaskInfo> _activeTasks = {};
  final Map<String, Timer> _taskTimers = {};

  /// Initialize background task optimizer
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('⚙️ Initializing enhanced background task optimizer...');

      // Configure based on platform capabilities
      await _configurePlatformSpecificBackground();

      // Initialize background services
      await _initializeBackgroundServices();

      _isInitialized = true;
      AppLogger.info('✅ Enhanced background task optimizer initialized');
    } catch (e) {
      AppLogger.error('❌ Failed to initialize background task optimizer: $e');
      rethrow;
    }
  }

  Future<void> _configurePlatformSpecificBackground() async {
    final platformType = _platformService.platformType;

    switch (platformType) {
      case PlatformType.ios:
        await _configureIOSBackground();
        break;
      case PlatformType.android:
        await _configureAndroidBackground();
        break;
      case PlatformType.web:
        await _configureWebBackground();
        break;
      default:
        await _configureDefaultBackground();
        break;
    }

    AppLogger.debug('⚙️ Background configured for: ${platformType.name}');
    AppLogger.debug('🛠️ Configuration: $_backgroundConfig');
  }

  Future<void> _configureIOSBackground() async {
    _backgroundConfig = {
      'backgroundRefresh': true,
      'backgroundProcessing': true,
      'timeLimit': 30, // iOS background execution time limit in seconds
      'taskTypes': ['background-processing', 'background-app-refresh'],
      'maxConcurrentTasks': 3,
      'adaptiveBatching': true,
      'lowPowerModeHandling': true,
    };

    AppLogger.info('🍎 iOS background configuration applied');
  }

  Future<void> _configureAndroidBackground() async {
    final apiLevel = _platformService.deviceInfo.capabilities['apiLevel'] as int? ?? 21;

    _backgroundConfig = {
      'foregroundService': true,
      'workManager': true,
      'wakeLocks': apiLevel >= 23,
      'dozeOptimization': apiLevel >= 23,
      'backgroundAppLimits': apiLevel >= 26,
      'maxConcurrentTasks': 5,
      'adaptiveBatching': true,
      'batteryOptimizationWhitelist': apiLevel >= 23,
    };

    AppLogger.info(
      '🤖 Android background configuration applied (API $apiLevel)',
    );
  }

  Future<void> _configureWebBackground() async {
    _backgroundConfig = {
      'serviceWorkers': true,
      'webWorkers': true,
      'backgroundSync': false, // Limited support in web
      'maxConcurrentTasks': 2,
      'adaptiveBatching': false,
    };

    AppLogger.info('🌐 Web background configuration applied');
  }

  Future<void> _configureDefaultBackground() async {
    _backgroundConfig = {
      'basicTasking': true,
      'maxConcurrentTasks': 1,
      'adaptiveBatching': false,
    };
  }

  Future<void> _initializeBackgroundServices() async {
    final platformType = _platformService.platformType;

    switch (platformType) {
      case PlatformType.ios:
        await _initializeIOSBackgroundServices();
        break;
      case PlatformType.android:
        await _initializeAndroidBackgroundServices();
        break;
      case PlatformType.web:
        await _initializeWebBackgroundServices();
        break;
      default:
        break;
    }
  }

  Future<void> _initializeIOSBackgroundServices() async {
    try {
      AppLogger.info('🍎 Initializing iOS background services...');

      // For iOS, we would register background tasks with BGTaskScheduler
      // This is a placeholder implementation
      AppLogger.debug('⚙️ iOS background tasks registered');
    } catch (e) {
      AppLogger.warning('⚠️ iOS background services initialization failed: $e');
    }
  }

  Future<void> _initializeAndroidBackgroundServices() async {
    try {
      AppLogger.info('🤖 Initializing Android background services...');

      // Initialize WorkManager
      if (_backgroundConfig['workManager'] == true) {
        await _initializeWorkManager();
      }

      // Initialize foreground service if needed
      if (_backgroundConfig['foregroundService'] == true) {
        await _initializeForegroundService();
      }

      AppLogger.debug('⚙️ Android background services initialized');
    } catch (e) {
      AppLogger.warning(
        '⚠️ Android background services initialization failed: $e',
      );
    }
  }

  Future<void> _initializeWebBackgroundServices() async {
    try {
      AppLogger.info('🌐 Initializing Web background services...');

      // For web, we would register service workers
      // This is a placeholder implementation
      AppLogger.debug('⚙️ Web background services initialized');
    } catch (e) {
      AppLogger.warning('⚠️ Web background services initialization failed: $e');
    }
  }

  Future<void> _initializeWorkManager() async {
    if (!kIsWeb) {
      try {
        await Workmanager().initialize(
          _workManagerCallbackDispatcher,
          isInDebugMode: kDebugMode,
        );
        AppLogger.info('📓 WorkManager initialized');
      } catch (e) {
        AppLogger.warning('⚠️ WorkManager initialization failed: $e');
      }
    }
  }

  Future<void> _initializeForegroundService() async {
    try {
      final service = FlutterBackgroundService();

      await service.configure(
        iosConfiguration: IosConfiguration(
          autoStart: false,
          onForeground: _onStart,
          onBackground: _onIosBackground,
        ),
        androidConfiguration: AndroidConfiguration(
          onStart: _onStart,
          autoStart: false,
          isForegroundMode: true,
          autoStartOnBoot: false,
          initialNotificationTitle: 'DuaCopilot Background Service',
          initialNotificationContent: 'Running Islamic background tasks',
          foregroundServiceNotificationId: 888,
        ),
      );

      AppLogger.info('🛎️ Foreground service configured');
    } catch (e) {
      AppLogger.warning('⚠️ Foreground service initialization failed: $e');
    }
  }

  @pragma('vm:entry-point')
  static void _onStart(ServiceInstance service) async {
    AppLogger.info('🛎️ Background service started');

    // Handle background tasks
    service.on('background_task').listen((event) async {
      final taskData = event;
      if (taskData is Map<String, dynamic>) {
        await _handleBackgroundTask(taskData);
      }
    });
  }

  @pragma('vm:entry-point')
  static bool _onIosBackground(ServiceInstance service) {
    AppLogger.info('🍎 iOS background service running');
    return true;
  }

  static Future<void> _handleBackgroundTask(
    Map<String, dynamic> taskData,
  ) async {
    final taskId = taskData['taskId'] as String?;
    final taskType = taskData['taskType'] as String?;

    if (taskId != null && taskType != null) {
      AppLogger.info('⚙️ Handling background task: $taskId ($taskType)');

      switch (taskType) {
        case 'sync_data':
          await _performDataSync(taskData);
          break;
        case 'update_cache':
          await _performCacheUpdate(taskData);
          break;
        case 'notification_check':
          await _performNotificationCheck(taskData);
          break;
        default:
          AppLogger.warning('⚠️ Unknown background task type: $taskType');
          break;
      }
    }
  }

  static Future<void> _performDataSync(Map<String, dynamic> taskData) async {
    AppLogger.debug('⚙️ Performing background data sync');
    // Implement data synchronization logic
    await Future.delayed(const Duration(seconds: 2));
    AppLogger.debug('✅ Background data sync completed');
  }

  static Future<void> _performCacheUpdate(Map<String, dynamic> taskData) async {
    AppLogger.debug('🧱 Performing background cache update');
    // Implement cache update logic
    await Future.delayed(const Duration(seconds: 1));
    AppLogger.debug('✅ Background cache update completed');
  }

  static Future<void> _performNotificationCheck(
    Map<String, dynamic> taskData,
  ) async {
    AppLogger.debug('🔔 Performing background notification check');
    // Implement notification check logic
    await Future.delayed(const Duration(milliseconds: 500));
    AppLogger.debug('✅ Background notification check completed');
  }

  /// Schedule a background task with platform-specific optimizations
  Future<void> scheduleTask({
    required String taskId,
    required Duration interval,
    required Map<String, dynamic> data,
    BackgroundTaskPriority priority = BackgroundTaskPriority.normal,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      AppLogger.info('📓 Scheduling background task: $taskId');
      AppLogger.debug('⏱️ Interval: $interval, Priority: ${priority.name}');

      final taskInfo = BackgroundTaskInfo(
        id: taskId,
        interval: interval,
        data: data,
        priority: priority,
        createdAt: DateTime.now(),
        lastExecuted: null,
      );

      await _scheduleTaskForPlatform(taskInfo);

      _activeTasks[taskId] = taskInfo;
      AppLogger.info('✅ Background task scheduled: $taskId');
    } catch (e) {
      AppLogger.error('❌ Failed to schedule background task: $e');
      rethrow;
    }
  }

  Future<void> _scheduleTaskForPlatform(BackgroundTaskInfo taskInfo) async {
    final platformType = _platformService.platformType;

    switch (platformType) {
      case PlatformType.ios:
        await _scheduleIOSTask(taskInfo);
        break;
      case PlatformType.android:
        await _scheduleAndroidTask(taskInfo);
        break;
      case PlatformType.web:
        await _scheduleWebTask(taskInfo);
        break;
      default:
        await _scheduleDefaultTask(taskInfo);
        break;
    }
  }

  Future<void> _scheduleIOSTask(BackgroundTaskInfo taskInfo) async {
    // For iOS, we would use BGTaskScheduler
    // This is a simplified implementation
    AppLogger.debug('🍎 Scheduling iOS background task: ${taskInfo.id}');

    // Use timer as fallback
    await _scheduleTimerTask(taskInfo);
  }

  Future<void> _scheduleAndroidTask(BackgroundTaskInfo taskInfo) async {
    if (_backgroundConfig['workManager'] == true && !kIsWeb) {
      try {
        // Schedule with WorkManager
        await Workmanager().registerPeriodicTask(
          taskInfo.id,
          taskInfo.id,
          frequency: taskInfo.interval,
          constraints: Constraints(
            networkType: NetworkType.connected,
            requiresBatteryNotLow: taskInfo.priority == BackgroundTaskPriority.low,
            requiresCharging: false,
            requiresDeviceIdle: taskInfo.priority == BackgroundTaskPriority.low,
          ),
          inputData: taskInfo.data,
        );

        AppLogger.debug(
          '🤖 Scheduled Android WorkManager task: ${taskInfo.id}',
        );
      } catch (e) {
        AppLogger.warning(
          '⚠️ WorkManager scheduling failed, using timer fallback: $e',
        );
        await _scheduleTimerTask(taskInfo);
      }
    } else {
      await _scheduleTimerTask(taskInfo);
    }
  }

  Future<void> _scheduleWebTask(BackgroundTaskInfo taskInfo) async {
    // For web, we use timers (service workers would be more appropriate)
    AppLogger.debug('🌐 Scheduling Web timer task: ${taskInfo.id}');
    await _scheduleTimerTask(taskInfo);
  }

  Future<void> _scheduleDefaultTask(BackgroundTaskInfo taskInfo) async {
    await _scheduleTimerTask(taskInfo);
  }

  Future<void> _scheduleTimerTask(BackgroundTaskInfo taskInfo) async {
    // Cancel existing timer if any
    _taskTimers[taskInfo.id]?.cancel();

    // Schedule new timer
    _taskTimers[taskInfo.id] = Timer.periodic(taskInfo.interval, (timer) async {
      await _executeTask(taskInfo.id, taskInfo.data);
    });

    AppLogger.debug('⏰ Timer scheduled for task: ${taskInfo.id}');
  }

  Future<void> _executeTask(String taskId, Map<String, dynamic> data) async {
    try {
      AppLogger.debug('▶️ Executing background task: $taskId');

      // Update last executed time
      if (_activeTasks.containsKey(taskId)) {
        _activeTasks[taskId] = _activeTasks[taskId]!.copyWith(
          lastExecuted: DateTime.now(),
        );
      }

      // Execute task based on platform
      await _executeTaskForPlatform(taskId, data);

      AppLogger.debug('✅ Background task completed: $taskId');
    } catch (e) {
      AppLogger.error('❌ Background task execution failed: $taskId - $e');
    }
  }

  Future<void> _executeTaskForPlatform(
    String taskId,
    Map<String, dynamic> data,
  ) async {
    final platformType = _platformService.platformType;

    if (_backgroundConfig['foregroundService'] == true && platformType == PlatformType.android) {
      // Use foreground service for Android
      await _executeThroughForegroundService(taskId, data);
    } else {
      // Execute directly
      await _handleBackgroundTask({
        'taskId': taskId,
        'taskType': data['taskType'] ?? 'unknown',
        ...data,
      });
    }
  }

  Future<void> _executeThroughForegroundService(
    String taskId,
    Map<String, dynamic> data,
  ) async {
    try {
      final service = FlutterBackgroundService();

      if (await service.isRunning()) {
        service.invoke('background_task', {
          'taskId': taskId,
          'taskType': data['taskType'] ?? 'unknown',
          ...data,
        });
      } else {
        // Start service and then execute
        await service.startService();
        await Future.delayed(const Duration(seconds: 1));
        service.invoke('background_task', {
          'taskId': taskId,
          'taskType': data['taskType'] ?? 'unknown',
          ...data,
        });
      }
    } catch (e) {
      AppLogger.warning(
        '⚠️ Foreground service execution failed, using direct execution: $e',
      );
      await _handleBackgroundTask({
        'taskId': taskId,
        'taskType': data['taskType'] ?? 'unknown',
        ...data,
      });
    }
  }

  /// Cancel a scheduled background task
  Future<void> cancelTask(String taskId) async {
    try {
      AppLogger.info('🗙 Cancelling background task: $taskId');

      // Cancel timer if exists
      _taskTimers[taskId]?.cancel();
      _taskTimers.remove(taskId);

      // Cancel platform-specific task
      if (!kIsWeb && _backgroundConfig['workManager'] == true) {
        await Workmanager().cancelByUniqueName(taskId);
      }

      // Remove from active tasks
      _activeTasks.remove(taskId);

      AppLogger.info('✅ Background task cancelled: $taskId');
    } catch (e) {
      AppLogger.error('❌ Failed to cancel background task: $e');
    }
  }

  /// Cancel all background tasks
  Future<void> cancelAllTasks() async {
    try {
      AppLogger.info('🗙 Cancelling all background tasks...');

      // Cancel all timers
      for (final timer in _taskTimers.values) {
        timer.cancel();
      }
      _taskTimers.clear();

      // Cancel WorkManager tasks
      if (!kIsWeb && _backgroundConfig['workManager'] == true) {
        await Workmanager().cancelAll();
      }

      // Clear active tasks
      _activeTasks.clear();

      AppLogger.info('✅ All background tasks cancelled');
    } catch (e) {
      AppLogger.error('❌ Failed to cancel all background tasks: $e');
    }
  }

  /// Get information about active background tasks
  List<BackgroundTaskInfo> getActiveTasks() {
    return _activeTasks.values.toList();
  }

  /// Get current background configuration
  Map<String, dynamic> getCurrentConfiguration() {
    return Map.unmodifiable(_backgroundConfig);
  }

  /// Get optimal background configuration for current platform
  Map<String, dynamic> getOptimalConfiguration() {
    final platformType = _platformService.platformType;
    final capabilities = _platformService.deviceInfo.capabilities;

    switch (platformType) {
      case PlatformType.ios:
        return {
          'backgroundRefreshEnabled': true,
          'backgroundProcessingEnabled': true,
          'timeLimit': 30,
          'batchingEnabled': true,
          'lowPowerModeHandling': true,
        };

      case PlatformType.android:
        final apiLevel = capabilities['apiLevel'] as int? ?? 21;
        return {
          'workManagerEnabled': true,
          'foregroundServiceEnabled': true,
          'dozeOptimizationEnabled': apiLevel >= 23,
          'batteryOptimizationWhitelistEnabled': apiLevel >= 23,
          'batchingEnabled': true,
        };

      case PlatformType.web:
        return {
          'serviceWorkersEnabled': true,
          'webWorkersEnabled': true,
          'backgroundSyncEnabled': false,
          'batchingEnabled': false,
        };

      default:
        return {'basicTaskingEnabled': true, 'batchingEnabled': false};
    }
  }

  /// Cleanup resources
  Future<void> dispose() async {
    await cancelAllTasks();

    // Stop background service if running
    if (_isBackgroundServiceRunning) {
      try {
        final service = FlutterBackgroundService();
        service.invoke('stop_service');
        _isBackgroundServiceRunning = false;
      } catch (e) {
        AppLogger.warning('⚠️ Failed to stop background service: $e');
      }
    }

    _isInitialized = false;
    _backgroundConfig.clear();

    AppLogger.info('🧹 Enhanced background task optimizer disposed');
  }
}

/// Background task information
class BackgroundTaskInfo {
  final String id;
  final Duration interval;
  final Map<String, dynamic> data;
  final BackgroundTaskPriority priority;
  final DateTime createdAt;
  final DateTime? lastExecuted;

  BackgroundTaskInfo({
    required this.id,
    required this.interval,
    required this.data,
    required this.priority,
    required this.createdAt,
    this.lastExecuted,
  });

  BackgroundTaskInfo copyWith({
    String? id,
    Duration? interval,
    Map<String, dynamic>? data,
    BackgroundTaskPriority? priority,
    DateTime? createdAt,
    DateTime? lastExecuted,
  }) {
    return BackgroundTaskInfo(
      id: id ?? this.id,
      interval: interval ?? this.interval,
      data: data ?? this.data,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      lastExecuted: lastExecuted ?? this.lastExecuted,
    );
  }
}

/// WorkManager callback dispatcher
@pragma('vm:entry-point')
void _workManagerCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      AppLogger.info('🔧 Executing WorkManager task: $task');

      await EnhancedBackgroundTaskOptimizer._handleBackgroundTask({
        'taskId': task,
        'taskType': inputData?['taskType'] ?? 'unknown',
        ...?inputData,
      });

      AppLogger.info('✅ WorkManager task completed: $task');
      return true;
    } catch (e) {
      AppLogger.error('❌ WorkManager task failed: $task - $e');
      return false;
    }
  });
}
