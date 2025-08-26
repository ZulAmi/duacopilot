import 'package:flutter/material.dart';

import '../core/logging/app_logger.dart';
import '../core/monitoring/monitoring_integration.dart';

/// Example showing comprehensive monitoring integration with RAG queries
class MonitoredRagExample extends StatefulWidget {
  const MonitoredRagExample({super.key});

  @override
  State<MonitoredRagExample> createState() => _MonitoredRagExampleState();
}

class _MonitoredRagExampleState extends State<MonitoredRagExample> {
  final _queryController = TextEditingController();
  bool _isProcessing = false;
  String? _result;
  String? _error;
  RagQueryTracker? _currentTracker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitored RAG Queries'),
        actions: [IconButton(icon: const Icon(Icons.analytics), onPressed: _showAnalyticsSummary)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter a query to test comprehensive monitoring:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            TextField(
              controller: _queryController,
              decoration: const InputDecoration(
                hintText: 'e.g., What is the dua for traveling?',
                border: OutlineInputBorder(),
              ),
              onSubmitted: _isProcessing ? null : _processQuery,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isProcessing ? null : () => _processQuery(_queryController.text),
              child:
                  _isProcessing
                      ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                          SizedBox(width: 8),
                          Text('Processing...'),
                        ],
                      )
                      : const Text('Process Query with Monitoring'),
            ),
            const SizedBox(height: 24),
            if (_result != null || _error != null) ...[
              Text('Result:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_result != null)
                        Text(_result!)
                      else if (_error != null)
                        Text('Error: $_error', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                      const SizedBox(height: 16),
                      if (_currentTracker != null)
                        ElevatedButton(
                          onPressed: () => _showSatisfactionDialog(),
                          child: const Text('Rate This Response'),
                        ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            _buildABTestingSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildABTestingSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('A/B Testing Configuration', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            FutureBuilder<Map<String, String>>(
              future: _getABTestVariants(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children:
                        snapshot.data!.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(entry.key.replaceAll('_', ' ').toUpperCase())),
                                Expanded(
                                  child: Chip(
                                    label: Text(entry.value),
                                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, String>> _getABTestVariants() async {
    return {
      'rag_integration': await MonitoringIntegration.getRagIntegrationVariant(),
      'response_format': await MonitoringIntegration.getResponseFormatVariant(),
      'cache_strategy': await MonitoringIntegration.getCacheStrategyVariant(),
    };
  }

  Future<void> _processQuery(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isProcessing = true;
      _result = null;
      _error = null;
      _currentTracker = null;
    });

    RagQueryTracker? tracker;

    try {
      // Start comprehensive monitoring
      tracker = await MonitoringIntegration.startRagQueryTracking(
        query: query,
        queryType: _detectQueryType(query),
        additionalMetadata: {'ui_component': 'monitored_rag_example', 'user_input': true},
      );

      AppLogger.info('🔍 Started monitoring for query: ${tracker.traceId}');

      // Simulate RAG processing with different outcomes based on A/B test
      final ragVariant = await MonitoringIntegration.getRagIntegrationVariant();
      final result = await _simulateRagProcessing(query, ragVariant);

      setState(() {
        _result = result;
        _currentTracker = tracker;
      });

      // Complete monitoring with success
      await tracker.complete(
        success: true,
        confidence: 0.85,
        responseLength: result.length,
        sources: ['Islamic Knowledge Base', 'Quran', 'Hadith Collection'],
        additionalMetrics: {'ab_variant': ragVariant, 'simulated': true},
      );

      // Record A/B test conversion
      await MonitoringIntegration.recordABTestConversion(
        experimentName: 'rag_integration_approach',
        outcome: 'successful_response',
        additionalData: {'query_length': query.length, 'response_length': result.length, 'confidence': 0.85},
      );
    } catch (e) {
      AppLogger.error('Query processing failed: $e');

      setState(() {
        _error = e.toString();
      });

      // Record exception
      await MonitoringIntegration.recordRagException(
        exception: e,
        queryId: tracker?.traceId,
        queryType: _detectQueryType(query),
        ragService: 'simulated_rag',
      );

      // Complete monitoring with error
      await tracker?.complete(success: false, errorMessage: e.toString());
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  String _detectQueryType(String query) {
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('dua') || lowerQuery.contains('prayer')) {
      return 'dua_request';
    } else if (lowerQuery.contains('quran') || lowerQuery.contains('verse')) {
      return 'quran_search';
    } else if (lowerQuery.contains('hadith')) {
      return 'hadith_search';
    } else {
      return 'general_query';
    }
  }

  Future<String> _simulateRagProcessing(String query, String variant) async {
    // Simulate processing delay
    await Future.delayed(Duration(milliseconds: 500 + (variant.hashCode % 1000)));

    // Simulate different responses based on A/B test variant
    switch (variant) {
      case 'api_first':
        return 'API-First Response: This is a comprehensive response from our primary RAG service for "$query". The response includes detailed Islamic guidance with source citations and contextual information.';

      case 'cache_first':
        return 'Cache-First Response: Retrieved from intelligent cache for "$query". This cached response provides quick access to previously processed Islamic knowledge with verified accuracy.';

      case 'hybrid':
        return 'Hybrid Response: Combined API and cache approach for "$query". This balanced response leverages both fresh data and cached knowledge for optimal accuracy and speed.';

      default:
        return 'Default Response: Standard processing for "$query". This response provides Islamic guidance based on authenticated sources and scholarly interpretation.';
    }
  }

  Future<void> _showSatisfactionDialog() async {
    if (_currentTracker == null) return;

    await MonitoringIntegration.showSatisfactionDialog(
      context,
      _currentTracker!.traceId,
      onCompleted: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Thank you for your feedback!'), backgroundColor: Colors.green));
      },
    );
  }

  Future<void> _showAnalyticsSummary() async {
    try {
      final summary = await MonitoringIntegration.getRagAnalyticsSummary(timeWindow: const Duration(hours: 1));

      if (mounted) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Analytics Summary (1h)'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildSummaryRow('Total Queries', '${summary.overview.totalQueries}'),
                      _buildSummaryRow('Success Rate', '${(summary.overview.successRate * 100).toStringAsFixed(1)}%'),
                      _buildSummaryRow('Avg Rating', '${summary.overview.avgUserRating.toStringAsFixed(1)}/5'),
                      _buildSummaryRow('Feedback Count', '${summary.overview.totalSatisfactionResponses}'),
                      const SizedBox(height: 16),
                      const Text('Trending Topics:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ...summary.trendingTopics.take(3).map((topic) => _buildSummaryRow(topic.topic, '${topic.count}')),
                    ],
                  ),
                ),
                actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
              ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load analytics: $e'), backgroundColor: Colors.red));
      }
    }
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))],
      ),
    );
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }
}

/// Advanced monitoring example with geographic tracking
class GeographicMonitoringExample extends StatelessWidget {
  const GeographicMonitoringExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Geographic Usage Tracking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Privacy-Compliant Location Tracking', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    const Text('This app tracks geographic usage patterns while maintaining user privacy:'),
                    const SizedBox(height: 8),
                    const Text('• Location coordinates are rounded to ~10km accuracy'),
                    const Text('• No personal identification is stored with location data'),
                    const Text('• Data is aggregated for analytics only'),
                    const Text('• Users can opt-out through app settings'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _simulateGeographicQuery(context),
                      child: const Text('Simulate Geographic Query'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _simulateGeographicQuery(BuildContext context) async {
    try {
      final tracker = await MonitoringIntegration.startRagQueryTracking(
        query: 'What are the prayer times for my location?',
        queryType: 'location_based_query',
        additionalMetadata: {'includes_location': true, 'privacy_compliant': true},
      );

      // Simulate processing
      await Future.delayed(const Duration(seconds: 2));

      await tracker.complete(
        success: true,
        confidence: 0.92,
        responseLength: 150,
        sources: ['Islamic Calendar API', 'Location Services'],
        additionalMetrics: {'location_accuracy': 'city_level', 'privacy_preserved': true},
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Geographic query tracked with privacy protection'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
  }
}
