import 'dart:math';

import 'package:flutter/material.dart';

import '../logging/app_logger.dart';
import '../monitoring/aws_monitoring_services.dart';

/// Integration helper for comprehensive monitoring with RAG queries
/// Provides easy-to-use methods for tracking RAG performance and user satisfaction
class MonitoringIntegration {
  static final AWSRagMonitoringAdapter _monitoring = AWSRagMonitoringAdapter.instance;

  /// Initialize monitoring system
  static Future<void> initialize() async {
    await _monitoring.initialize();
    AppLogger.info('ðŸ“Š Monitoring integration ready');
  }

  /// Track a RAG query from start to finish with comprehensive metrics
  static Future<RagQueryTracker> startRagQueryTracking({
    required String query,
    required String queryType,
    String? userId,
    String? sessionId,
    Map<String, dynamic>? additionalMetadata,
  }) async {
    final traceId = await _monitoring.startRagQueryTracking(
      query: query,
      queryType: queryType,
      metadata: {
        if (userId != null) 'user_id': userId,
        if (sessionId != null) 'session_id': sessionId,
        ...?additionalMetadata,
      },
    );

    return RagQueryTracker._(traceId, query, queryType);
  }

  /// Get current A/B test variant for RAG integration
  static Future<String> getRagIntegrationVariant() async {
    return await _monitoring.getABTestVariant('rag_integration_approach');
  }

  /// Get UI response format variant
  static Future<String> getResponseFormatVariant() async {
    return await _monitoring.getABTestVariant('ui_response_format');
  }

  /// Get cache strategy variant
  static Future<String> getCacheStrategyVariant() async {
    return await _monitoring.getABTestVariant('cache_strategy');
  }

  /// Record A/B test conversion (successful query completion)
  static Future<void> recordABTestConversion({
    required String experimentName,
    required String outcome,
    Map<String, dynamic>? additionalData,
  }) async {
    final variant = await _monitoring.getABTestVariant(experimentName);
    await _monitoring.trackABTestResult(
      experimentName: experimentName,
      variant: variant,
      outcome: outcome,
      additionalData: additionalData,
    );
  }

  /// Record exception with RAG context
  static Future<void> recordRagException({
    required dynamic exception,
    StackTrace? stackTrace,
    String? queryId,
    String? queryType,
    String? ragService,
    bool fatal = false,
  }) async {
    await _monitoring.recordException(
      exception: exception,
      stackTrace: stackTrace,
      reason: 'RAG query processing error',
      additionalInfo: {
        if (queryId != null) 'query_id': queryId,
        if (queryType != null) 'query_type': queryType,
        if (ragService != null) 'rag_service': ragService,
        'context': 'rag_processing',
      },
      fatal: fatal,
    );
  }

  /// Get comprehensive analytics for dashboard
  static Future<RagAnalyticsSummary> getRagAnalyticsSummary({
    Duration? timeWindow,
  }) async {
    final rawData = await _monitoring.getAnalyticsSummary(
      timeWindow: timeWindow,
    );
    return RagAnalyticsSummary.fromMap(rawData);
  }

  /// Show user satisfaction dialog and track response
  static Future<void> showSatisfactionDialog(
    BuildContext context,
    String traceId, {
    VoidCallback? onCompleted,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => RagSatisfactionDialog(
        traceId: traceId,
        onRatingSubmitted: (rating, feedback, tags) async {
          await _monitoring.trackUserSatisfaction(
            traceId: traceId,
            rating: rating,
            feedback: feedback,
            tags: tags,
          );
          onCompleted?.call();
        },
      ),
    );
  }

  /// Dispose monitoring resources
  static Future<void> dispose() async {
    await _monitoring.dispose();
  }
}

/// RAG Query Tracker for individual query monitoring
class RagQueryTracker {
  final String _traceId;
  final String _query;
  final String _queryType;

  RagQueryTracker._(this._traceId, this._query, this._queryType);

  String get traceId => _traceId;
  String get query => _query;
  String get queryType => _queryType;

  /// Complete tracking with success metrics
  Future<void> complete({
    required bool success,
    String? errorMessage,
    double? confidence,
    int? responseLength,
    List<String>? sources,
    Duration? cacheHitTime,
    Map<String, dynamic>? additionalMetrics,
  }) async {
    await AWSRagMonitoringAdapter.instance.completeRagQueryTracking(
      traceId: _traceId,
      success: success,
      errorMessage: errorMessage,
      confidence: confidence,
      responseLength: responseLength,
      sources: sources,
      cacheHitTime: cacheHitTime,
    );

    // Track A/B test conversion if successful
    if (success) {
      await MonitoringIntegration.recordABTestConversion(
        experimentName: 'rag_integration_approach',
        outcome: 'query_success',
        additionalData: {
          'confidence': confidence ?? 0.0,
          'response_length': responseLength ?? 0,
          'cache_hit': cacheHitTime != null,
          ...?additionalMetrics,
        },
      );
    }
  }

  /// Record user satisfaction for this query
  Future<void> recordSatisfaction({
    required int rating,
    String? feedback,
    List<String>? tags,
  }) async {
    await AWSRagMonitoringAdapter.instance.trackUserSatisfaction(
      traceId: _traceId,
      rating: rating,
      feedback: feedback,
      tags: tags,
    );
  }
}

/// Adapter that re-implements the previous ComprehensiveMonitoringService RAG-specific
/// APIs on top of the new AWS monitoring services. This avoids bringing back the
/// removed Firebase-based implementation while preserving higher-level integration.
class AWSRagMonitoringAdapter {
  AWSRagMonitoringAdapter._();
  static final AWSRagMonitoringAdapter instance = AWSRagMonitoringAdapter._();

  bool _initialized = false;
  final Map<String, DateTime> _queryStarts = {};
  final Random _rand = Random();

  Future<void> initialize() async {
    if (_initialized) return;
    await AWSComprehensiveMonitoringService.initialize();
    _initialized = true;
    AppLogger.debug('✅ AWS RAG Monitoring Adapter initialized');
  }

  String _newTraceId() {
    final ts = DateTime.now().microsecondsSinceEpoch;
    final r = _rand.nextInt(1 << 32);
    return 'rag_${ts.toRadixString(16)}_${r.toRadixString(16)}';
  }

  Future<String> startRagQueryTracking({
    required String query,
    required String queryType,
    required Map<String, dynamic> metadata,
  }) async {
    final id = _newTraceId();
    _queryStarts[id] = DateTime.now();
    await AWSSimpleMonitoringService.trackUserAction(
      action: 'rag_query_start',
      category: 'rag',
      properties: {
        'trace_id': id,
        'query_type': queryType,
        'query_length': query.length,
        ...metadata.map((k, v) => MapEntry(k, v.toString())),
      },
    );
    return id;
  }

  Future<void> completeRagQueryTracking({
    required String traceId,
    required bool success,
    String? errorMessage,
    double? confidence,
    int? responseLength,
    List<String>? sources,
    Duration? cacheHitTime,
  }) async {
    final start = _queryStarts.remove(traceId);
    final durationMs = start != null ? DateTime.now().difference(start).inMilliseconds : -1;
    await AWSComprehensiveMonitoringService.trackEvent(
      name: 'rag_query_complete',
      parameters: {
        'trace_id': traceId,
        'success': success,
        if (errorMessage != null) 'error': errorMessage,
        if (confidence != null) 'confidence': confidence,
        if (responseLength != null) 'response_length': responseLength,
        if (sources != null) 'sources': sources.join(','),
        if (cacheHitTime != null) 'cache_hit_ms': cacheHitTime.inMilliseconds,
        'duration_ms': durationMs,
      },
    );
  }

  Future<String> getABTestVariant(String experimentName) async {
    // Placeholder: always control variant
    return 'control';
  }

  Future<void> trackABTestResult({
    required String experimentName,
    required String variant,
    required String outcome,
    Map<String, dynamic>? additionalData,
  }) async {
    await AWSComprehensiveMonitoringService.trackEvent(
      name: 'ab_test_result',
      parameters: {
        'experiment': experimentName,
        'variant': variant,
        'outcome': outcome,
        ...?additionalData?.map((k, v) => MapEntry(k, v.toString())),
      },
    );
  }

  Future<void> recordException({
    required dynamic exception,
    StackTrace? stackTrace,
    required String reason,
    Map<String, dynamic>? additionalInfo,
    bool fatal = false,
  }) async {
    await AWSSimpleMonitoringService.recordError(
      exception,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
    if (additionalInfo != null && additionalInfo.isNotEmpty) {
      await AWSSimpleMonitoringService.log('exception_meta: ${additionalInfo.toString()}');
    }
  }

  Future<Map<String, dynamic>> getAnalyticsSummary({
    Duration? timeWindow,
  }) async {
    final windowHrs = timeWindow?.inHours ?? 1;
    return {
      'session_id': 'sess_${DateTime.now().millisecondsSinceEpoch}',
      'generated_at': DateTime.now().toIso8601String(),
      'time_window_hours': windowHrs,
      'overview': {
        'total_queries': 0,
        'success_rate': 0.0,
        'avg_user_rating': 0.0,
        'total_satisfaction_responses': 0,
      },
      'query_types': <String, dynamic>{},
      'trending_topics': <dynamic>[],
      'geographic_data': {
        'total_geographic_queries': 0,
        'unique_regions': 0,
        'top_regions': <dynamic>[],
      },
      'ab_tests': <dynamic>[],
    };
  }

  Future<void> trackUserSatisfaction({
    required String traceId,
    required int rating,
    String? feedback,
    List<String>? tags,
  }) async {
    await AWSComprehensiveMonitoringService.trackEvent(
      name: 'rag_user_satisfaction',
      parameters: {
        'trace_id': traceId,
        'rating': rating,
        if (feedback != null) 'feedback': feedback,
        if (tags != null && tags.isNotEmpty) 'tags': tags.join(','),
      },
    );
  }

  Future<void> dispose() async {
    _queryStarts.clear();
  }
}

/// Analytics summary specifically for RAG queries
class RagAnalyticsSummary {
  final String sessionId;
  final DateTime generatedAt;
  final int timeWindowHours;
  final RagOverviewMetrics overview;
  final Map<String, RagQueryTypeStats> queryTypes;
  final List<TrendingTopic> trendingTopics;
  final RagGeographicData geographicData;
  final List<ABTestResult> abTests;

  RagAnalyticsSummary({
    required this.sessionId,
    required this.generatedAt,
    required this.timeWindowHours,
    required this.overview,
    required this.queryTypes,
    required this.trendingTopics,
    required this.geographicData,
    required this.abTests,
  });

  factory RagAnalyticsSummary.fromMap(Map<String, dynamic> data) {
    final overview = data['overview'] as Map<String, dynamic>;
    final queryTypesData = data['query_types'] as Map<String, dynamic>;
    final trendingData = data['trending_topics'] as List<dynamic>;
    final geographicRaw = data['geographic_data'] as Map<String, dynamic>;
    final abTestsData = data['ab_tests'] as List<dynamic>;

    return RagAnalyticsSummary(
      sessionId: data['session_id'] as String,
      generatedAt: DateTime.parse(data['generated_at'] as String),
      timeWindowHours: data['time_window_hours'] as int,
      overview: RagOverviewMetrics.fromMap(overview),
      queryTypes: queryTypesData.map(
        (key, value) => MapEntry(
          key,
          RagQueryTypeStats.fromMap(value as Map<String, dynamic>),
        ),
      ),
      trendingTopics: trendingData
          .map(
            (item) => TrendingTopic.fromMap(item as Map<String, dynamic>),
          )
          .toList(),
      geographicData: RagGeographicData.fromMap(geographicRaw),
      abTests: abTestsData.map((item) => ABTestResult.fromMap(item as Map<String, dynamic>)).toList(),
    );
  }
}

class RagOverviewMetrics {
  final int totalQueries;
  final double successRate;
  final double avgUserRating;
  final int totalSatisfactionResponses;

  RagOverviewMetrics({
    required this.totalQueries,
    required this.successRate,
    required this.avgUserRating,
    required this.totalSatisfactionResponses,
  });

  factory RagOverviewMetrics.fromMap(Map<String, dynamic> data) {
    return RagOverviewMetrics(
      totalQueries: data['total_queries'] as int,
      successRate: (data['success_rate'] as num).toDouble(),
      avgUserRating: (data['avg_user_rating'] as num).toDouble(),
      totalSatisfactionResponses: data['total_satisfaction_responses'] as int,
    );
  }
}

class RagQueryTypeStats {
  final int count;
  final int successCount;
  final double successRate;
  final int totalTimeMs;
  final double avgTimeMs;
  final double avgConfidence;

  RagQueryTypeStats({
    required this.count,
    required this.successCount,
    required this.successRate,
    required this.totalTimeMs,
    required this.avgTimeMs,
    required this.avgConfidence,
  });

  factory RagQueryTypeStats.fromMap(Map<String, dynamic> data) {
    final count = data['count'] as int;
    final successCount = data['success_count'] as int;
    final totalTimeMs = data['total_time_ms'] as int;

    return RagQueryTypeStats(
      count: count,
      successCount: successCount,
      successRate: count > 0 ? successCount / count : 0.0,
      totalTimeMs: totalTimeMs,
      avgTimeMs: count > 0 ? totalTimeMs / count : 0.0,
      avgConfidence: (data['avg_confidence'] as num).toDouble(),
    );
  }
}

class TrendingTopic {
  final String topic;
  final int count;

  TrendingTopic({required this.topic, required this.count});

  factory TrendingTopic.fromMap(Map<String, dynamic> data) {
    return TrendingTopic(
      topic: data['topic'] as String,
      count: data['count'] as int,
    );
  }
}

class RagGeographicData {
  final int totalGeographicQueries;
  final int uniqueRegions;
  final List<RegionUsage> topRegions;

  RagGeographicData({
    required this.totalGeographicQueries,
    required this.uniqueRegions,
    required this.topRegions,
  });

  factory RagGeographicData.fromMap(Map<String, dynamic> data) {
    if (data.containsKey('error')) {
      return RagGeographicData(
        totalGeographicQueries: 0,
        uniqueRegions: 0,
        topRegions: [],
      );
    }

    final topRegionsData = data['top_regions'] as List<dynamic>;

    return RagGeographicData(
      totalGeographicQueries: data['total_geographic_queries'] as int,
      uniqueRegions: data['unique_regions'] as int,
      topRegions: topRegionsData.map((item) => RegionUsage.fromMap(item as Map<String, dynamic>)).toList(),
    );
  }
}

class RegionUsage {
  final String region;
  final int count;

  RegionUsage({required this.region, required this.count});

  factory RegionUsage.fromMap(Map<String, dynamic> data) {
    return RegionUsage(
      region: data['region'] as String,
      count: data['count'] as int,
    );
  }
}

class ABTestResult {
  final String experiment;
  final String variant;
  final DateTime assignedAt;

  ABTestResult({
    required this.experiment,
    required this.variant,
    required this.assignedAt,
  });

  factory ABTestResult.fromMap(Map<String, dynamic> data) {
    return ABTestResult(
      experiment: data['experiment'] as String,
      variant: data['variant'] as String,
      assignedAt: DateTime.parse(data['assigned_at'] as String),
    );
  }
}

/// User satisfaction dialog widget
class RagSatisfactionDialog extends StatefulWidget {
  final String traceId;
  final Function(int rating, String? feedback, List<String> tags) onRatingSubmitted;

  const RagSatisfactionDialog({
    super.key,
    required this.traceId,
    required this.onRatingSubmitted,
  });

  @override
  State<RagSatisfactionDialog> createState() => _RagSatisfactionDialogState();
}

class _RagSatisfactionDialogState extends State<RagSatisfactionDialog> {
  int _rating = 0;
  final _feedbackController = TextEditingController();
  final Set<String> _selectedTags = {};

  final List<String> _availableTags = [
    'Helpful',
    'Accurate',
    'Fast',
    'Complete',
    'Clear',
    'Relevant',
    'Needs improvement',
    'Too slow',
    'Inaccurate',
    'Incomplete',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rate this Response'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('How would you rate this response?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return IconButton(
                  onPressed: () => setState(() => _rating = starIndex),
                  icon: Icon(
                    starIndex <= _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                );
              }),
            ),
            if (_rating > 0) ...[
              const SizedBox(height: 16),
              const Text('Additional feedback (optional):'),
              const SizedBox(height: 8),
              TextField(
                controller: _feedbackController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Tell us more about your experience...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Quick tags:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _availableTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _rating > 0
              ? () {
                  widget.onRatingSubmitted(
                    _rating,
                    _feedbackController.text.trim().isEmpty ? null : _feedbackController.text.trim(),
                    _selectedTags.toList(),
                  );
                  Navigator.of(context).pop();
                }
              : null,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
}
