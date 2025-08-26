// lib/services/production/monitoring_dashboard.dart
import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import statements removed - using direct Firebase calls instead

/// Real-time monitoring dashboard for production environment
class MonitoringDashboard {
  static const String _cacheKey = 'monitoring_dashboard_data';
  static const Duration _refreshInterval = Duration(minutes: 5);

  static MonitoringDashboard? _instance;
  static MonitoringDashboard get instance =>
      _instance ??= MonitoringDashboard._();
  MonitoringDashboard._();

  final StreamController<DashboardData> _dataController =
      StreamController<DashboardData>.broadcast();
  Timer? _refreshTimer;
  DashboardData? _lastData;

  /// Stream of dashboard data updates
  Stream<DashboardData> get dataStream => _dataController.stream;

  /// Current dashboard data
  DashboardData? get currentData => _lastData;

  /// Initialize monitoring dashboard
  Future<void> initialize() async {
    try {
      // Load cached data
      await _loadCachedData();

      // Start real-time monitoring
      await _startMonitoring();

      // Refresh data immediately
      await refreshData();

      // Setup periodic refresh
      _refreshTimer = Timer.periodic(_refreshInterval, (_) => refreshData());

      debugPrint('MonitoringDashboard: Initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('MonitoringDashboard: Initialization error - $e');
      await FirebaseCrashlytics.instance.recordError(
        MonitoringException(
          'Failed to initialize monitoring dashboard',
          e.toString(),
        ),
        stackTrace,
      );
    }
  }

  /// Refresh dashboard data
  Future<void> refreshData() async {
    try {
      final data = await _collectDashboardData();
      _lastData = data;

      // Cache data
      await _cacheData(data);

      // Notify listeners
      if (!_dataController.isClosed) {
        _dataController.add(data);
      }

      debugPrint('MonitoringDashboard: Data refreshed - ${data.summary}');
    } catch (e, stackTrace) {
      debugPrint('MonitoringDashboard: Refresh error - $e');
      await FirebaseCrashlytics.instance.recordError(
        MonitoringException('Failed to refresh dashboard data', e.toString()),
        stackTrace,
      );
    }
  }

  /// Collect comprehensive dashboard data
  Future<DashboardData> _collectDashboardData() async {
    final now = DateTime.now();

    // Collect metrics from various sources
    final appMetrics = await _collectAppMetrics();
    final ragMetrics = await _collectRAGMetrics();
    final errorMetrics = await _collectErrorMetrics();
    final performanceMetrics = await _collectPerformanceMetrics();
    final userMetrics = await _collectUserMetrics();
    final systemHealth = await _collectSystemHealth();

    return DashboardData(
      timestamp: now,
      appMetrics: appMetrics,
      ragMetrics: ragMetrics,
      errorMetrics: errorMetrics,
      performanceMetrics: performanceMetrics,
      userMetrics: userMetrics,
      systemHealth: systemHealth,
    );
  }

  /// Collect application metrics
  Future<AppMetrics> _collectAppMetrics() async {
    final prefs = await SharedPreferences.getInstance();

    // Get session data
    final sessionCount = prefs.getInt('total_sessions') ?? 0;
    final activeUsers = prefs.getInt('active_users_today') ?? 0;
    final appVersion = prefs.getString('app_version') ?? 'unknown';
    final buildNumber = prefs.getString('build_number') ?? 'unknown';

    // Calculate uptime
    final launchTime = prefs.getInt('app_launch_time');
    final uptime =
        launchTime != null
            ? DateTime.now().difference(
              DateTime.fromMillisecondsSinceEpoch(launchTime),
            )
            : Duration.zero;

    return AppMetrics(
      version: appVersion,
      buildNumber: buildNumber,
      uptime: uptime,
      sessionCount: sessionCount,
      activeUsers: activeUsers,
      memoryUsage: _getMemoryUsage(),
      platformInfo: _getPlatformInfo(),
    );
  }

  /// Collect RAG system metrics
  Future<RAGMetrics> _collectRAGMetrics() async {
    final prefs = await SharedPreferences.getInstance();

    // Get RAG query statistics
    final totalQueries = prefs.getInt('rag_total_queries') ?? 0;
    final successfulQueries = prefs.getInt('rag_successful_queries') ?? 0;
    final failedQueries = prefs.getInt('rag_failed_queries') ?? 0;
    final avgResponseTime = prefs.getDouble('rag_avg_response_time') ?? 0.0;
    final cacheHitRate = prefs.getDouble('rag_cache_hit_rate') ?? 0.0;

    // Get recent query metrics
    final recentQueries = await _getRecentRAGQueries();

    return RAGMetrics(
      totalQueries: totalQueries,
      successfulQueries: successfulQueries,
      failedQueries: failedQueries,
      successRate: totalQueries > 0 ? successfulQueries / totalQueries : 0.0,
      averageResponseTime: avgResponseTime,
      cacheHitRate: cacheHitRate,
      recentQueries: recentQueries,
      indexHealth: await _checkRAGIndexHealth(),
    );
  }

  /// Collect error and crash metrics
  Future<ErrorMetrics> _collectErrorMetrics() async {
    final prefs = await SharedPreferences.getInstance();

    // Get error statistics
    final totalErrors = prefs.getInt('total_errors_today') ?? 0;
    final crashCount = prefs.getInt('crash_count_today') ?? 0;
    final networkErrors = prefs.getInt('network_errors_today') ?? 0;
    final ragErrors = prefs.getInt('rag_errors_today') ?? 0;

    // Get recent errors
    final recentErrors = await _getRecentErrors();

    return ErrorMetrics(
      totalErrors: totalErrors,
      crashCount: crashCount,
      networkErrors: networkErrors,
      ragErrors: ragErrors,
      errorRate: await _calculateErrorRate(),
      recentErrors: recentErrors,
    );
  }

  /// Collect performance metrics
  Future<PerformanceMetrics> _collectPerformanceMetrics() async {
    final prefs = await SharedPreferences.getInstance();

    // Get performance data
    final appStartTime = prefs.getDouble('app_start_time') ?? 0.0;
    final frameRenderTime = prefs.getDouble('avg_frame_render_time') ?? 16.7;
    final networkLatency = prefs.getDouble('avg_network_latency') ?? 0.0;
    final cpuUsage = await _getCPUUsage();

    return PerformanceMetrics(
      appStartTime: appStartTime,
      averageFrameRenderTime: frameRenderTime,
      networkLatency: networkLatency,
      cpuUsage: cpuUsage,
      batteryLevel: await _getBatteryLevel(),
      networkType: await _getNetworkType(),
    );
  }

  /// Collect user engagement metrics
  Future<UserMetrics> _collectUserMetrics() async {
    final prefs = await SharedPreferences.getInstance();

    return UserMetrics(
      dailyActiveUsers: prefs.getInt('daily_active_users') ?? 0,
      sessionDuration: Duration(
        milliseconds: prefs.getInt('avg_session_duration') ?? 0,
      ),
      screenViews: prefs.getInt('total_screen_views') ?? 0,
      userActions: prefs.getInt('total_user_actions') ?? 0,
      retentionRate: prefs.getDouble('user_retention_rate') ?? 0.0,
    );
  }

  /// Collect system health indicators
  Future<SystemHealth> _collectSystemHealth() async {
    final health = SystemHealth();

    // Check various system components
    health.firebaseConnected = await _checkFirebaseConnection();
    health.ragServiceHealthy = await _checkRAGServiceHealth();
    health.cacheHealthy = await _checkCacheHealth();
    health.analyticsWorking = await _checkAnalyticsHealth();
    health.crashReportingWorking = await _checkCrashReportingHealth();

    // Calculate overall health score
    health.overallScore = _calculateHealthScore(health);

    return health;
  }

  /// Load cached dashboard data
  Future<void> _loadCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString(_cacheKey);

      if (cachedJson != null) {
        final cachedData = json.decode(cachedJson);
        _lastData = DashboardData.fromJson(cachedData);
      }
    } catch (e) {
      debugPrint('MonitoringDashboard: Failed to load cached data - $e');
    }
  }

  /// Cache dashboard data
  Future<void> _cacheData(DashboardData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = json.encode(data.toJson());
      await prefs.setString(_cacheKey, jsonData);
    } catch (e) {
      debugPrint('MonitoringDashboard: Failed to cache data - $e');
    }
  }

  /// Start real-time monitoring
  Future<void> _startMonitoring() async {
    // Setup Firebase Analytics observer
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

    // Setup Crashlytics
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    // Setup Performance monitoring
    FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
  }

  /// Get recent RAG queries
  Future<List<RAGQueryInfo>> _getRecentRAGQueries() async {
    final prefs = await SharedPreferences.getInstance();
    final queriesJson = prefs.getString('recent_rag_queries') ?? '[]';
    final queriesList = json.decode(queriesJson) as List;

    return queriesList.map((q) => RAGQueryInfo.fromJson(q)).take(10).toList();
  }

  /// Get recent errors
  Future<List<ErrorInfo>> _getRecentErrors() async {
    final prefs = await SharedPreferences.getInstance();
    final errorsJson = prefs.getString('recent_errors') ?? '[]';
    final errorsList = json.decode(errorsJson) as List;

    return errorsList.map((e) => ErrorInfo.fromJson(e)).take(10).toList();
  }

  /// Check RAG index health
  Future<double> _checkRAGIndexHealth() async {
    try {
      // Simulate RAG index health check
      // In reality, this would ping the RAG service
      await Future.delayed(const Duration(milliseconds: 100));
      return 0.95; // 95% healthy
    } catch (e) {
      return 0.0;
    }
  }

  /// Calculate current error rate
  Future<double> _calculateErrorRate() async {
    final prefs = await SharedPreferences.getInstance();
    final totalRequests = prefs.getInt('total_requests_today') ?? 1;
    final totalErrors = prefs.getInt('total_errors_today') ?? 0;

    return totalErrors / totalRequests;
  }

  /// Get memory usage information
  MemoryUsage _getMemoryUsage() {
    // In a real implementation, you'd use platform channels to get actual memory usage
    return MemoryUsage(
      used: 45.2, // MB
      available: 128.0, // MB
      percentage: 0.353,
    );
  }

  /// Get platform information
  PlatformInfo _getPlatformInfo() {
    return PlatformInfo(
      platform: defaultTargetPlatform.name,
      version: 'Unknown', // Would get from platform channel
      device: 'Unknown', // Would get from platform channel
    );
  }

  /// Get CPU usage
  Future<double> _getCPUUsage() async {
    // Mock CPU usage - in reality, get from platform channel
    return 0.15; // 15%
  }

  /// Get battery level
  Future<double> _getBatteryLevel() async {
    // Mock battery level - in reality, get from platform channel
    return 0.85; // 85%
  }

  /// Get network type
  Future<String> _getNetworkType() async {
    // Mock network type - in reality, get from connectivity package
    return 'wifi';
  }

  /// Check Firebase connection
  Future<bool> _checkFirebaseConnection() async {
    try {
      await FirebaseAnalytics.instance.logEvent(name: 'health_check');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check RAG service health
  Future<bool> _checkRAGServiceHealth() async {
    try {
      // Mock RAG service health check
      await Future.delayed(const Duration(milliseconds: 200));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check cache health
  Future<bool> _checkCacheHealth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('health_check', DateTime.now().toIso8601String());
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check analytics health
  Future<bool> _checkAnalyticsHealth() async {
    try {
      await FirebaseAnalytics.instance.logEvent(name: 'dashboard_health_check');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check crash reporting health
  Future<bool> _checkCrashReportingHealth() async {
    try {
      await FirebaseCrashlytics.instance.setCustomKey(
        'health_check',
        DateTime.now().toIso8601String(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Calculate overall system health score
  double _calculateHealthScore(SystemHealth health) {
    int healthyComponents = 0;
    int totalComponents = 5;

    if (health.firebaseConnected) healthyComponents++;
    if (health.ragServiceHealthy) healthyComponents++;
    if (health.cacheHealthy) healthyComponents++;
    if (health.analyticsWorking) healthyComponents++;
    if (health.crashReportingWorking) healthyComponents++;

    return healthyComponents / totalComponents;
  }

  /// Dispose resources
  void dispose() {
    _refreshTimer?.cancel();
    _dataController.close();
  }
}

/// Dashboard data model
class DashboardData {
  final DateTime timestamp;
  final AppMetrics appMetrics;
  final RAGMetrics ragMetrics;
  final ErrorMetrics errorMetrics;
  final PerformanceMetrics performanceMetrics;
  final UserMetrics userMetrics;
  final SystemHealth systemHealth;

  DashboardData({
    required this.timestamp,
    required this.appMetrics,
    required this.ragMetrics,
    required this.errorMetrics,
    required this.performanceMetrics,
    required this.userMetrics,
    required this.systemHealth,
  });

  String get summary =>
      'Health: ${(systemHealth.overallScore * 100).toStringAsFixed(1)}%, '
      'Queries: ${ragMetrics.totalQueries}, '
      'Errors: ${errorMetrics.totalErrors}';

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'appMetrics': appMetrics.toJson(),
    'ragMetrics': ragMetrics.toJson(),
    'errorMetrics': errorMetrics.toJson(),
    'performanceMetrics': performanceMetrics.toJson(),
    'userMetrics': userMetrics.toJson(),
    'systemHealth': systemHealth.toJson(),
  };

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
    timestamp: DateTime.parse(json['timestamp']),
    appMetrics: AppMetrics.fromJson(json['appMetrics']),
    ragMetrics: RAGMetrics.fromJson(json['ragMetrics']),
    errorMetrics: ErrorMetrics.fromJson(json['errorMetrics']),
    performanceMetrics: PerformanceMetrics.fromJson(json['performanceMetrics']),
    userMetrics: UserMetrics.fromJson(json['userMetrics']),
    systemHealth: SystemHealth.fromJson(json['systemHealth']),
  );
}

/// Application metrics
class AppMetrics {
  final String version;
  final String buildNumber;
  final Duration uptime;
  final int sessionCount;
  final int activeUsers;
  final MemoryUsage memoryUsage;
  final PlatformInfo platformInfo;

  AppMetrics({
    required this.version,
    required this.buildNumber,
    required this.uptime,
    required this.sessionCount,
    required this.activeUsers,
    required this.memoryUsage,
    required this.platformInfo,
  });

  Map<String, dynamic> toJson() => {
    'version': version,
    'buildNumber': buildNumber,
    'uptime': uptime.inMilliseconds,
    'sessionCount': sessionCount,
    'activeUsers': activeUsers,
    'memoryUsage': memoryUsage.toJson(),
    'platformInfo': platformInfo.toJson(),
  };

  factory AppMetrics.fromJson(Map<String, dynamic> json) => AppMetrics(
    version: json['version'],
    buildNumber: json['buildNumber'],
    uptime: Duration(milliseconds: json['uptime']),
    sessionCount: json['sessionCount'],
    activeUsers: json['activeUsers'],
    memoryUsage: MemoryUsage.fromJson(json['memoryUsage']),
    platformInfo: PlatformInfo.fromJson(json['platformInfo']),
  );
}

/// RAG system metrics
class RAGMetrics {
  final int totalQueries;
  final int successfulQueries;
  final int failedQueries;
  final double successRate;
  final double averageResponseTime;
  final double cacheHitRate;
  final List<RAGQueryInfo> recentQueries;
  final double indexHealth;

  RAGMetrics({
    required this.totalQueries,
    required this.successfulQueries,
    required this.failedQueries,
    required this.successRate,
    required this.averageResponseTime,
    required this.cacheHitRate,
    required this.recentQueries,
    required this.indexHealth,
  });

  Map<String, dynamic> toJson() => {
    'totalQueries': totalQueries,
    'successfulQueries': successfulQueries,
    'failedQueries': failedQueries,
    'successRate': successRate,
    'averageResponseTime': averageResponseTime,
    'cacheHitRate': cacheHitRate,
    'recentQueries': recentQueries.map((q) => q.toJson()).toList(),
    'indexHealth': indexHealth,
  };

  factory RAGMetrics.fromJson(Map<String, dynamic> json) => RAGMetrics(
    totalQueries: json['totalQueries'],
    successfulQueries: json['successfulQueries'],
    failedQueries: json['failedQueries'],
    successRate: json['successRate'],
    averageResponseTime: json['averageResponseTime'],
    cacheHitRate: json['cacheHitRate'],
    recentQueries:
        (json['recentQueries'] as List)
            .map((q) => RAGQueryInfo.fromJson(q))
            .toList(),
    indexHealth: json['indexHealth'],
  );
}

/// Error metrics
class ErrorMetrics {
  final int totalErrors;
  final int crashCount;
  final int networkErrors;
  final int ragErrors;
  final double errorRate;
  final List<ErrorInfo> recentErrors;

  ErrorMetrics({
    required this.totalErrors,
    required this.crashCount,
    required this.networkErrors,
    required this.ragErrors,
    required this.errorRate,
    required this.recentErrors,
  });

  Map<String, dynamic> toJson() => {
    'totalErrors': totalErrors,
    'crashCount': crashCount,
    'networkErrors': networkErrors,
    'ragErrors': ragErrors,
    'errorRate': errorRate,
    'recentErrors': recentErrors.map((e) => e.toJson()).toList(),
  };

  factory ErrorMetrics.fromJson(Map<String, dynamic> json) => ErrorMetrics(
    totalErrors: json['totalErrors'],
    crashCount: json['crashCount'],
    networkErrors: json['networkErrors'],
    ragErrors: json['ragErrors'],
    errorRate: json['errorRate'],
    recentErrors:
        (json['recentErrors'] as List)
            .map((e) => ErrorInfo.fromJson(e))
            .toList(),
  );
}

/// Performance metrics
class PerformanceMetrics {
  final double appStartTime;
  final double averageFrameRenderTime;
  final double networkLatency;
  final double cpuUsage;
  final double batteryLevel;
  final String networkType;

  PerformanceMetrics({
    required this.appStartTime,
    required this.averageFrameRenderTime,
    required this.networkLatency,
    required this.cpuUsage,
    required this.batteryLevel,
    required this.networkType,
  });

  Map<String, dynamic> toJson() => {
    'appStartTime': appStartTime,
    'averageFrameRenderTime': averageFrameRenderTime,
    'networkLatency': networkLatency,
    'cpuUsage': cpuUsage,
    'batteryLevel': batteryLevel,
    'networkType': networkType,
  };

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) =>
      PerformanceMetrics(
        appStartTime: json['appStartTime'],
        averageFrameRenderTime: json['averageFrameRenderTime'],
        networkLatency: json['networkLatency'],
        cpuUsage: json['cpuUsage'],
        batteryLevel: json['batteryLevel'],
        networkType: json['networkType'],
      );
}

/// User engagement metrics
class UserMetrics {
  final int dailyActiveUsers;
  final Duration sessionDuration;
  final int screenViews;
  final int userActions;
  final double retentionRate;

  UserMetrics({
    required this.dailyActiveUsers,
    required this.sessionDuration,
    required this.screenViews,
    required this.userActions,
    required this.retentionRate,
  });

  Map<String, dynamic> toJson() => {
    'dailyActiveUsers': dailyActiveUsers,
    'sessionDuration': sessionDuration.inMilliseconds,
    'screenViews': screenViews,
    'userActions': userActions,
    'retentionRate': retentionRate,
  };

  factory UserMetrics.fromJson(Map<String, dynamic> json) => UserMetrics(
    dailyActiveUsers: json['dailyActiveUsers'],
    sessionDuration: Duration(milliseconds: json['sessionDuration']),
    screenViews: json['screenViews'],
    userActions: json['userActions'],
    retentionRate: json['retentionRate'],
  );
}

/// System health indicators
class SystemHealth {
  bool firebaseConnected = false;
  bool ragServiceHealthy = false;
  bool cacheHealthy = false;
  bool analyticsWorking = false;
  bool crashReportingWorking = false;
  double overallScore = 0.0;

  SystemHealth();

  Map<String, dynamic> toJson() => {
    'firebaseConnected': firebaseConnected,
    'ragServiceHealthy': ragServiceHealthy,
    'cacheHealthy': cacheHealthy,
    'analyticsWorking': analyticsWorking,
    'crashReportingWorking': crashReportingWorking,
    'overallScore': overallScore,
  };

  factory SystemHealth.fromJson(Map<String, dynamic> json) {
    final health = SystemHealth();
    health.firebaseConnected = json['firebaseConnected'];
    health.ragServiceHealthy = json['ragServiceHealthy'];
    health.cacheHealthy = json['cacheHealthy'];
    health.analyticsWorking = json['analyticsWorking'];
    health.crashReportingWorking = json['crashReportingWorking'];
    health.overallScore = json['overallScore'];
    return health;
  }
}

/// Supporting data models
class MemoryUsage {
  final double used;
  final double available;
  final double percentage;

  MemoryUsage({
    required this.used,
    required this.available,
    required this.percentage,
  });

  Map<String, dynamic> toJson() => {
    'used': used,
    'available': available,
    'percentage': percentage,
  };

  factory MemoryUsage.fromJson(Map<String, dynamic> json) => MemoryUsage(
    used: json['used'],
    available: json['available'],
    percentage: json['percentage'],
  );
}

class PlatformInfo {
  final String platform;
  final String version;
  final String device;

  PlatformInfo({
    required this.platform,
    required this.version,
    required this.device,
  });

  Map<String, dynamic> toJson() => {
    'platform': platform,
    'version': version,
    'device': device,
  };

  factory PlatformInfo.fromJson(Map<String, dynamic> json) => PlatformInfo(
    platform: json['platform'],
    version: json['version'],
    device: json['device'],
  );
}

class RAGQueryInfo {
  final String query;
  final double responseTime;
  final bool success;
  final DateTime timestamp;

  RAGQueryInfo({
    required this.query,
    required this.responseTime,
    required this.success,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'query': query,
    'responseTime': responseTime,
    'success': success,
    'timestamp': timestamp.toIso8601String(),
  };

  factory RAGQueryInfo.fromJson(Map<String, dynamic> json) => RAGQueryInfo(
    query: json['query'],
    responseTime: json['responseTime'],
    success: json['success'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

class ErrorInfo {
  final String error;
  final String stackTrace;
  final String type;
  final DateTime timestamp;

  ErrorInfo({
    required this.error,
    required this.stackTrace,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'error': error,
    'stackTrace': stackTrace,
    'type': type,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ErrorInfo.fromJson(Map<String, dynamic> json) => ErrorInfo(
    error: json['error'],
    stackTrace: json['stackTrace'],
    type: json['type'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

/// Custom exception for monitoring
class MonitoringException implements Exception {
  final String message;
  final String? details;

  MonitoringException(this.message, [this.details]);

  @override
  String toString() =>
      'MonitoringException: $message${details != null ? ' - $details' : ''}';
}
