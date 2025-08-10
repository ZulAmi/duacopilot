/// Main performance optimization integration file for RAG
library performance_integration;

/// This file brings together all performance optimizations for the DuaCopilot app
export 'arabic_scroll_physics.dart';
export 'background_processing.dart';
export 'media_optimization.dart';
export 'performance_monitoring.dart';
export 'platform_optimizer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'arabic_scroll_physics.dart';
import 'background_processing.dart';
import 'media_optimization.dart';
import 'performance_monitoring.dart';
import 'platform_optimizer.dart';

/// Main performance manager that coordinates all optimizations
class RagPerformanceManager {
  static final RagPerformanceManager _instance =
      RagPerformanceManager._internal();
  factory RagPerformanceManager() => _instance;
  RagPerformanceManager._internal();

  late final RagPerformanceMonitor _performanceMonitor;
  late final RagBackgroundProcessor _backgroundProcessor;
  late final PlatformOptimizer _platformOptimizer;
  late final RagImageCacheManager _imageCacheManager;

  bool _isInitialized = false;

  /// Initialize all performance components
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize performance monitoring
      _performanceMonitor = RagPerformanceMonitor();
      await _performanceMonitor.recordAppStart();

      // Initialize background processing
      _backgroundProcessor = RagBackgroundProcessor();

      // Initialize platform optimizer
      _platformOptimizer = PlatformOptimizer();

      // Initialize image cache manager
      _imageCacheManager = RagImageCacheManager();

      _isInitialized = true;

      if (kDebugMode) {
        debugPrint('RAG Performance Manager initialized successfully');
      }
    } catch (e) {
      debugPrint('Error initializing RAG Performance Manager: $e');
    }
  }

  /// Get performance monitor instance
  RagPerformanceMonitor get performanceMonitor {
    assert(_isInitialized, 'RagPerformanceManager must be initialized first');
    return _performanceMonitor;
  }

  /// Get background processor instance
  RagBackgroundProcessor get backgroundProcessor {
    assert(_isInitialized, 'RagPerformanceManager must be initialized first');
    return _backgroundProcessor;
  }

  /// Get platform optimizer instance
  PlatformOptimizer get platformOptimizer {
    assert(_isInitialized, 'RagPerformanceManager must be initialized first');
    return _platformOptimizer;
  }

  /// Get image cache manager instance
  RagImageCacheManager get imageCacheManager {
    assert(_isInitialized, 'RagPerformanceManager must be initialized first');
    return _imageCacheManager;
  }

  /// Dispose all resources
  Future<void> dispose() async {
    try {
      // Dispose resources if needed
      _isInitialized = false;
    } catch (e) {
      debugPrint('Error disposing RAG Performance Manager: $e');
    }
  }
}

/// Widget that provides performance optimizations to its child
class PerformanceOptimizedApp extends StatefulWidget {
  final Widget child;
  final bool enableArabicScrollOptimization;
  final bool enablePerformanceMonitoring;

  const PerformanceOptimizedApp({
    super.key,
    required this.child,
    this.enableArabicScrollOptimization = true,
    this.enablePerformanceMonitoring = true,
  });

  @override
  State<PerformanceOptimizedApp> createState() =>
      _PerformanceOptimizedAppState();
}

class _PerformanceOptimizedAppState extends State<PerformanceOptimizedApp> {
  final RagPerformanceManager _performanceManager = RagPerformanceManager();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePerformance();
  }

  Future<void> _initializePerformance() async {
    try {
      await _performanceManager.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing performance optimizations: $e');
    }
  }

  @override
  void dispose() {
    _performanceManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    Widget child = widget.child;

    // Wrap with Arabic scroll optimization if enabled
    if (widget.enableArabicScrollOptimization) {
      child = ScrollConfiguration(
        behavior: ArabicScrollBehavior(isRTL: true),
        child: child,
      );
    }

    // Wrap with performance monitoring if enabled
    if (widget.enablePerformanceMonitoring) {
      child = buildPerformanceMonitoredWidget(
        child: child,
        name: 'PerformanceOptimizedApp',
        attributes: {
          'arabic_scroll': widget.enableArabicScrollOptimization.toString(),
        },
      );
    }

    return child;
  }
}

/// Helper functions for easy access to performance features
class PerformanceHelpers {
  /// Create an optimized image widget
  static Widget createOptimizedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return OptimizedRagImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }

  /// Extract keywords in background
  static Future<List<String>> extractKeywordsInBackground(String text) {
    return RagBackgroundProcessor.extractKeywords(text: text);
  }

  /// Analyze sentiment in background
  static Future<SentimentAnalysisResult> analyzeSentimentInBackground(
    String text,
  ) {
    return RagBackgroundProcessor.analyzeSentiment(text: text, language: 'ar');
  }

  /// Measure execution time with automatic monitoring
  static Future<T> measurePerformance<T>({
    required String operationName,
    required Future<T> Function() operation,
    Map<String, String>? attributes,
  }) {
    return PerformanceUtils.measureExecutionTime(
      operationName: operationName,
      operation: operation,
      attributes: attributes,
    );
  }

  /// Get platform-specific configuration
  static PlatformConfig getPlatformConfig() {
    return PlatformOptimizer.getPlatformConfig();
  }

  static IOSConfig getIOSConfig() {
    return IOSConfig();
  }

  static AndroidConfig getAndroidConfig() {
    return AndroidConfig();
  }

  static WebConfig getWebConfig() {
    return WebConfig();
  }

  static WindowsConfig getWindowsConfig() {
    return WindowsConfig();
  }
}

/// Extension to add performance monitoring to existing widgets
extension WidgetPerformanceExtension on Widget {
  /// Wrap widget with performance monitoring
  Widget withPerformanceMonitoring({
    required String name,
    Map<String, String>? attributes,
  }) {
    return buildPerformanceMonitoredWidget(
      child: this,
      name: name,
      attributes: attributes,
    );
  }

  /// Wrap widget with Arabic scroll optimization
  Widget withArabicScrollOptimization({bool isRTL = true}) {
    return ScrollConfiguration(
      behavior: ArabicScrollBehavior(isRTL: isRTL),
      child: this,
    );
  }
}
