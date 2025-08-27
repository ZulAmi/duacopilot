import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/monitoring/monitoring_integration.dart';

/// Comprehensive monitoring dashboard for RAG analytics
class MonitoringDashboard extends ConsumerStatefulWidget {
  const MonitoringDashboard({super.key});

  @override
  ConsumerState<MonitoringDashboard> createState() =>
      _MonitoringDashboardState();
}

class _MonitoringDashboardState extends ConsumerState<MonitoringDashboard> {
  RagAnalyticsSummary? _analyticsSummary;
  bool _isLoading = true;
  String? _error;
  Duration _selectedTimeWindow = const Duration(hours: 24);

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final summary = await MonitoringIntegration.getRagAnalyticsSummary(
        timeWindow: _selectedTimeWindow,
      );
      setState(() {
        _analyticsSummary = summary;
        _isLoading = false;
      });
    } catch (e) {
      AppLogger.error('Failed to load analytics: $e');
      setState(() {
        _error = 'Failed to load analytics: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RAG Monitoring Dashboard'),
        actions: [
          PopupMenuButton<Duration>(
            icon: const Icon(Icons.access_time),
            onSelected: (duration) {
              setState(() {
                _selectedTimeWindow = duration;
              });
              _loadAnalytics();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Duration(hours: 1),
                child: Text('Last Hour'),
              ),
              const PopupMenuItem(
                value: Duration(hours: 6),
                child: Text('Last 6 Hours'),
              ),
              const PopupMenuItem(
                value: Duration(hours: 24),
                child: Text('Last 24 Hours'),
              ),
              const PopupMenuItem(
                value: Duration(days: 7),
                child: Text('Last Week'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalytics,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading analytics...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAnalytics,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_analyticsSummary == null) {
      return const Center(child: Text('No analytics data available'));
    }

    return RefreshIndicator(
      onRefresh: _loadAnalytics,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCards(),
            const SizedBox(height: 24),
            _buildQueryTypeAnalysis(),
            const SizedBox(height: 24),
            _buildTrendingTopics(),
            const SizedBox(height: 24),
            _buildGeographicData(),
            const SizedBox(height: 24),
            _buildABTestResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    final overview = _analyticsSummary!.overview;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Overview', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildMetricCard(
              'Total Queries',
              overview.totalQueries.toString(),
              Icons.search,
              Colors.blue,
            ),
            _buildMetricCard(
              'Success Rate',
              '${(overview.successRate * 100).toStringAsFixed(1)}%',
              Icons.check_circle,
              Colors.green,
            ),
            _buildMetricCard(
              'User Satisfaction',
              '${overview.avgUserRating.toStringAsFixed(1)}/5.0',
              Icons.star,
              Colors.orange,
            ),
            _buildMetricCard(
              'Feedback Responses',
              overview.totalSatisfactionResponses.toString(),
              Icons.feedback,
              Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueryTypeAnalysis() {
    final queryTypes = _analyticsSummary!.queryTypes;

    if (queryTypes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Query Type Performance',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: queryTypes.entries.map((entry) {
                final type = entry.key;
                final stats = entry.value;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          type.replaceAll('_', ' ').toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(child: Text('${stats.count}')),
                      Expanded(
                        child: Text(
                          '${(stats.successRate * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: stats.successRate > 0.8
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${stats.avgTimeMs.toStringAsFixed(0)}ms',
                        ),
                      ),
                      Expanded(
                        child: Text(
                          stats.avgConfidence.toStringAsFixed(2),
                          style: TextStyle(
                            color: stats.avgConfidence > 0.8
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingTopics() {
    final topics = _analyticsSummary!.trendingTopics;

    if (topics.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trending Topics',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: topics.take(10).map((topic) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      topic.count.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    topic.topic.replaceAll('_', ' ').toUpperCase(),
                  ),
                  trailing: Icon(
                    Icons.trending_up,
                    color: Colors.green[600],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGeographicData() {
    final geo = _analyticsSummary!.geographicData;

    if (geo.totalGeographicQueries == 0) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Geographic Usage',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Queries: ${geo.totalGeographicQueries}'),
                    Text('Unique Regions: ${geo.uniqueRegions}'),
                  ],
                ),
                const SizedBox(height: 16),
                ...geo.topRegions.map((region) {
                  return ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text('Region ${region.region}'),
                    trailing: Chip(
                      label: Text(region.count.toString()),
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.2),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildABTestResults() {
    final abTests = _analyticsSummary!.abTests;

    if (abTests.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'A/B Test Configuration',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: abTests.map((test) {
                return ListTile(
                  leading: const Icon(Icons.science),
                  title: Text(
                    test.experiment.replaceAll('_', ' ').toUpperCase(),
                  ),
                  subtitle: Text('Variant: ${test.variant}'),
                  trailing: Text(
                    'Since ${test.assignedAt.day}/${test.assignedAt.month}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

/// Provider for monitoring dashboard data
final monitoringDashboardProvider =
    FutureProvider.family<RagAnalyticsSummary, Duration>((
  ref,
  timeWindow,
) async {
  return await MonitoringIntegration.getRagAnalyticsSummary(
    timeWindow: timeWindow,
  );
});

/// Simple monitoring widget for embedding in other screens
class QuickMonitoringWidget extends ConsumerWidget {
  const QuickMonitoringWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(
      monitoringDashboardProvider(const Duration(hours: 1)),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Quick Stats (1h)',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MonitoringDashboard(),
                      ),
                    );
                  },
                  child: const Text('Details'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            analyticsAsync.when(
              data: (summary) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Queries: ${summary.overview.totalQueries}'),
                      Text(
                        'Success: ${(summary.overview.successRate * 100).toStringAsFixed(1)}%',
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rating: ${summary.overview.avgUserRating.toStringAsFixed(1)}/5',
                      ),
                      Text(
                        'Feedback: ${summary.overview.totalSatisfactionResponses}',
                      ),
                    ],
                  ),
                ],
              ),
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text(
                'Error loading stats',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
