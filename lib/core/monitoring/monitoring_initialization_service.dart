import 'package:flutter/material.dart';

import '../logging/app_logger.dart';
import '../monitoring/comprehensive_monitoring_service.dart';
import '../monitoring/monitoring_integration.dart';
import '../platform/platform_service.dart';

/// Main initialization service for comprehensive monitoring
/// Coordinates Firebase services, platform detection, and monitoring setup
class MonitoringInitializationService {
  static MonitoringInitializationService? _instance;
  static MonitoringInitializationService get instance =>
      _instance ??= MonitoringInitializationService._();

  MonitoringInitializationService._();

  bool _isInitialized = false;

  /// Initialize all monitoring services in the correct order
  Future<void> initializeMonitoring() async {
    if (_isInitialized) {
      AppLogger.info('📊 Monitoring already initialized');
      return;
    }

    try {
      AppLogger.info('🚀 Starting comprehensive monitoring initialization...');

      // 1. Initialize platform service first
      await PlatformService.instance.initialize();
      AppLogger.info('✅ Platform service initialized');

      // 2. Initialize comprehensive monitoring service
      await ComprehensiveMonitoringService.instance.initialize();
      AppLogger.info('✅ Comprehensive monitoring service initialized');

      // 3. Initialize monitoring integration helpers
      await MonitoringIntegration.initialize();
      AppLogger.info('✅ Monitoring integration initialized');

      _isInitialized = true;
      AppLogger.info('🎉 All monitoring services initialized successfully');

      // Track successful initialization
      await _trackInitializationSuccess();
    } catch (e) {
      AppLogger.error('❌ Failed to initialize monitoring: $e');

      // Try to record the initialization failure
      try {
        await ComprehensiveMonitoringService.instance.recordException(
          exception: e,
          reason: 'Monitoring initialization failed',
          fatal: false,
        );
      } catch (recordError) {
        AppLogger.error('Failed to record initialization error: $recordError');
      }

      rethrow;
    }
  }

  /// Track successful monitoring initialization
  Future<void> _trackInitializationSuccess() async {
    try {
      final tracker = await MonitoringIntegration.startRagQueryTracking(
        query: 'system_initialization',
        queryType: 'system_event',
        additionalMetadata: {
          'event_type': 'monitoring_init',
          'platform': PlatformService.instance.platformName,
          'features_available':
              PlatformService.instance.availableFeatures.length,
        },
      );

      await tracker.complete(
        success: true,
        additionalMetrics: {
          'initialization_complete': true,
          'services_count': 3, // Platform, Monitoring, Integration
        },
      );
    } catch (e) {
      AppLogger.warning('Failed to track initialization success: $e');
    }
  }

  /// Check if monitoring is properly initialized
  bool get isInitialized => _isInitialized;

  /// Get monitoring status for debugging
  Map<String, dynamic> get monitoringStatus {
    return {
      'initialized': _isInitialized,
      'platform_service': PlatformService.instance.platformName,
      'platform_features': PlatformService.instance.availableFeatures.length,
      'firebase_enabled': true, // Assuming Firebase is always available
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Dispose all monitoring services
  Future<void> dispose() async {
    if (!_isInitialized) return;

    try {
      AppLogger.info('🧹 Disposing monitoring services...');

      await MonitoringIntegration.dispose();
      await ComprehensiveMonitoringService.instance.dispose();

      _isInitialized = false;
      AppLogger.info('✅ Monitoring services disposed');
    } catch (e) {
      AppLogger.error('Failed to dispose monitoring services: $e');
    }
  }
}

/// Flutter app wrapper that initializes monitoring
class MonitoredApp extends StatefulWidget {
  final Widget child;
  final bool enableMonitoring;

  const MonitoredApp({
    super.key,
    required this.child,
    this.enableMonitoring = true,
  });

  @override
  State<MonitoredApp> createState() => _MonitoredAppState();
}

class _MonitoredAppState extends State<MonitoredApp>
    with WidgetsBindingObserver {
  bool _monitoringInitialized = false;
  String? _initializationError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (widget.enableMonitoring) {
      _initializeMonitoring();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (widget.enableMonitoring) {
      MonitoringInitializationService.instance.dispose();
    }
    super.dispose();
  }

  Future<void> _initializeMonitoring() async {
    try {
      await MonitoringInitializationService.instance.initializeMonitoring();

      if (mounted) {
        setState(() {
          _monitoringInitialized = true;
          _initializationError = null;
        });
      }
    } catch (e) {
      AppLogger.error('Monitoring initialization failed: $e');

      if (mounted) {
        setState(() {
          _monitoringInitialized = false;
          _initializationError = e.toString();
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Track app lifecycle events for monitoring
    if (_monitoringInitialized) {
      _trackAppLifecycleEvent(state);
    }
  }

  Future<void> _trackAppLifecycleEvent(AppLifecycleState state) async {
    try {
      final tracker = await MonitoringIntegration.startRagQueryTracking(
        query: 'app_lifecycle_${state.name}',
        queryType: 'system_event',
        additionalMetadata: {
          'lifecycle_state': state.name,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      await tracker.complete(
        success: true,
        additionalMetrics: {'app_state': state.name, 'monitoring_active': true},
      );
    } catch (e) {
      AppLogger.warning('Failed to track app lifecycle event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show initialization status for debugging
    if (!widget.enableMonitoring) {
      return widget.child;
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          widget.child,
          if (_initializationError != null)
            Positioned(
              bottom: 50,
              left: 16,
              right: 16,
              child: Material(
                color: Colors.orange.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Monitoring Init Error',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _initializationError!.length > 100
                                  ? '${_initializationError!.substring(0, 100)}...'
                                  : _initializationError!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _initializeMonitoring,
                        icon: const Icon(Icons.refresh, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (!_monitoringInitialized && _initializationError == null)
            const Positioned(
              bottom: 50,
              left: 16,
              right: 16,
              child: Material(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Initializing monitoring...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Debug widget for monitoring status
class MonitoringDebugWidget extends StatelessWidget {
  const MonitoringDebugWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final status = MonitoringInitializationService.instance.monitoringStatus;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  status['initialized'] ? Icons.check_circle : Icons.error,
                  color: status['initialized'] ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Monitoring Status',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...status.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${entry.key}:',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(flex: 3, child: Text('${entry.value}')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
