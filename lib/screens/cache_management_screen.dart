import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/cache/providers/cache_providers.dart';
import '../core/cache/models/cache_models.dart';
import '../core/cache/services/analytics_service.dart';

/// Cache management and analytics screen
class CacheManagementScreen extends ConsumerStatefulWidget {
  const CacheManagementScreen({super.key});

  @override
  ConsumerState<CacheManagementScreen> createState() =>
      _CacheManagementScreenState();
}

class _CacheManagementScreenState extends ConsumerState<CacheManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchPattern = '';
  QueryType? _selectedQueryType;
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cache Management'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'Analytics', icon: Icon(Icons.analytics)),
            Tab(text: 'Popular', icon: Icon(Icons.trending_up)),
            Tab(text: 'Operations', icon: Icon(Icons.settings)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildAnalyticsTab(),
          _buildPopularQueriesTab(),
          _buildOperationsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Consumer(
      builder: (context, ref, child) {
        final metricsAsync = ref.watch(cacheMetricsProvider);

        return RefreshIndicator(
          onRefresh: () async {
            ref.read(cacheMetricsProvider.notifier).updateMetrics();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cache Status Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        'Hit Ratio',
                        '${(metricsAsync.hitRatio * 100).toStringAsFixed(1)}%',
                        Icons.thumb_up,
                        metricsAsync.hitRatio > 0.7
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        'Total Requests',
                        '${metricsAsync.hitCount + metricsAsync.missCount}',
                        Icons.insights,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        'Cache Entries',
                        '${metricsAsync.entryCount}',
                        Icons.storage,
                        Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        'Compression',
                        '${(metricsAsync.averageCompressionRatio * 100).toStringAsFixed(0)}%',
                        Icons.compress,
                        Colors.indigo,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Strategy Performance
                const Text(
                  'Strategy Performance',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                if (metricsAsync.strategyUsage.isNotEmpty)
                  ...metricsAsync.strategyUsage.entries.map(
                    (entry) => _buildStrategyCard(entry.key, entry.value),
                  ),

                const SizedBox(height: 24),

                // Cache Size Breakdown
                const Text(
                  'Cache Statistics',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                _buildStatisticsCard(metricsAsync),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsTab() {
    return Consumer(
      builder: (context, ref, child) {
        final analyticsAsync = ref.watch(cacheAnalyticsProvider);
        final performanceAsync = ref.watch(
          cachePerformanceProvider(const Duration(hours: 24)),
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Performance Metrics
              const Text(
                'Performance Metrics (24h)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              performanceAsync.when(
                data: (performance) => _buildPerformanceCards(performance),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error: $error'),
              ),

              const SizedBox(height: 24),

              // Analytics Summary
              if (analyticsAsync != null) ...[
                const Text(
                  'Analytics Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildAnalyticsSummary(analyticsAsync),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopularQueriesTab() {
    return Consumer(
      builder: (context, ref, child) {
        final popularQueriesAsync = ref.watch(
          popularQueriesProvider(
            PopularQueriesRequest(
              limit: 50,
              language: _selectedLanguage,
              queryType: _selectedQueryType,
            ),
          ),
        );

        final trendingQueriesAsync = ref.watch(
          trendingQueriesProvider(const TrendingQueriesRequest(limit: 20)),
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filters
              _buildQueryFilters(),

              const SizedBox(height: 24),

              // Popular Queries
              const Text(
                'Popular Queries',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              popularQueriesAsync.when(
                data: (queries) => _buildPopularQueriesList(queries),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error: $error'),
              ),

              const SizedBox(height: 24),

              // Trending Queries
              const Text(
                'Trending Queries',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              trendingQueriesAsync.when(
                data: (queries) => _buildTrendingQueriesList(queries),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error: $error'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOperationsTab() {
    return Consumer(
      builder: (context, ref, child) {
        final operationState = ref.watch(cacheOperationsProvider);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cache Operations
              const Text(
                'Cache Operations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Operation Status
              if (operationState.isLoading) const LinearProgressIndicator(),

              if (operationState.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(child: Text(operationState.error!)),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          ref
                              .read(cacheOperationsProvider.notifier)
                              .clearState();
                        },
                      ),
                    ],
                  ),
                ),

              if (operationState.lastOperation != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    border: Border.all(color: Colors.green.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(child: Text(operationState.lastOperation!)),
                      if (operationState.operationTimestamp != null)
                        Text(
                          '${operationState.operationTimestamp!.hour}:${operationState.operationTimestamp!.minute}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                    ],
                  ),
                ),

              // Operation Buttons
              _buildOperationButtons(ref, operationState.isLoading),

              const SizedBox(height: 24),

              // Search and Invalidate
              _buildSearchInvalidateSection(ref),

              const SizedBox(height: 24),

              // Prewarming Section
              _buildPrewarmingSection(ref),

              const SizedBox(height: 24),

              // Model Update Section
              _buildModelUpdateSection(ref),
            ],
          ),
        );
      },
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrategyCard(String strategy, int count) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.policy, color: Colors.teal),
        title: Text(strategy.replaceAll('_', ' ').toUpperCase()),
        trailing: Chip(
          label: Text('$count'),
          backgroundColor: Colors.teal.shade50,
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(CacheMetrics metrics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow('Cache Hits', '${metrics.hitCount}'),
            _buildStatRow('Cache Misses', '${metrics.missCount}'),
            _buildStatRow('Evictions', '${metrics.evictionCount}'),
            _buildStatRow(
              'Total Size',
              '${(metrics.totalSize / 1024).toStringAsFixed(1)} KB',
            ),
            _buildStatRow(
              'Avg Retrieval Time',
              '${metrics.averageRetrievalTime.inMilliseconds}ms',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPerformanceCards(CachePerformanceMetrics performance) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Hits',
                '${performance.hitCount}',
                Icons.check_circle,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Misses',
                '${performance.missCount}',
                Icons.cancel,
                Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Avg Hit Time',
                '${performance.averageHitTime.inMilliseconds}ms',
                Icons.speed,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                'Avg Miss Time',
                '${performance.averageMissTime.inMilliseconds}ms',
                Icons.access_time,
                Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyticsSummary(CacheAnalyticsSummary summary) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow('Unique Queries', '${summary.totalUniqueQueries}'),
            _buildStatRow('Total Events', '${summary.totalEvents}'),
            _buildStatRow(
              'Popular Queries',
              '${summary.popularQueries.length}',
            ),
            _buildStatRow(
              'Trending Queries',
              '${summary.trendingQueries.length}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueryFilters() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filters',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<QueryType?>(
                    value: _selectedQueryType,
                    decoration: const InputDecoration(
                      labelText: 'Query Type',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem<QueryType?>(
                        value: null,
                        child: Text('All Types'),
                      ),
                      ...QueryType.values.map(
                        (type) => DropdownMenuItem<QueryType?>(
                          value: type,
                          child: Text(type.name.toUpperCase()),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedQueryType = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    value: _selectedLanguage,
                    decoration: const InputDecoration(
                      labelText: 'Language',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text('All Languages'),
                      ),
                      DropdownMenuItem<String?>(
                        value: 'en',
                        child: Text('English'),
                      ),
                      DropdownMenuItem<String?>(
                        value: 'ar',
                        child: Text('Arabic'),
                      ),
                      DropdownMenuItem<String?>(
                        value: 'ur',
                        child: Text('Urdu'),
                      ),
                      DropdownMenuItem<String?>(
                        value: 'id',
                        child: Text('Indonesian'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularQueriesList(List<PopularQuery> queries) {
    if (queries.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No popular queries found')),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: queries.length,
      itemBuilder: (context, index) {
        final query = queries[index];
        return Card(
          child: ListTile(
            title: Text(
              query.query,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${query.language.toUpperCase()} • ${query.queryType.name} • ${query.accessCount} accesses',
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${(query.cacheHitRatio * 100).toStringAsFixed(0)}%'),
                Text(
                  'hit ratio',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendingQueriesList(List<TrendingQuery> queries) {
    if (queries.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No trending queries found')),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: queries.length,
      itemBuilder: (context, index) {
        final query = queries[index];
        return Card(
          child: ListTile(
            leading: Icon(Icons.trending_up, color: Colors.green),
            title: Text(
              query.query,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${query.totalAccesses} total accesses • +${query.dailyGrowthRate.toStringAsFixed(1)}/day',
            ),
            trailing: Text(
              '${query.trendScore.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOperationButtons(WidgetRef ref, bool isLoading) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    isLoading
                        ? null
                        : () =>
                            ref
                                .read(cacheOperationsProvider.notifier)
                                .clearAllCache(),
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear All Cache'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                    isLoading
                        ? null
                        : () =>
                            ref
                                .read(cacheOperationsProvider.notifier)
                                .prewarmCache(),
                icon: const Icon(Icons.autorenew),
                label: const Text('Prewarm Cache'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchInvalidateSection(WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search & Invalidate',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search Pattern',
                hintText: 'Enter text to search in cached queries',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchPattern = value;
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    _searchPattern.isEmpty
                        ? null
                        : () => ref
                            .read(cacheOperationsProvider.notifier)
                            .invalidateByPattern(_searchPattern),
                icon: const Icon(Icons.search_off),
                label: const Text('Invalidate Matching Entries'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrewarmingSection(WidgetRef ref) {
    int _prewarmLimit = 50;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cache Prewarming',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Prewarming loads popular queries into cache to improve performance.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Query Limit',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _prewarmLimit = int.tryParse(value) ?? 50;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed:
                      () => ref
                          .read(cacheOperationsProvider.notifier)
                          .prewarmCache(limit: _prewarmLimit),
                  child: const Text('Start Prewarming'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelUpdateSection(WidgetRef ref) {
    final _modelVersionController = TextEditingController();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Model Update',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Invalidate cache when RAG model is updated.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _modelVersionController,
              decoration: const InputDecoration(
                labelText: 'Model Version',
                hintText: 'e.g., v2.1.0',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final version = _modelVersionController.text.trim();
                  if (version.isNotEmpty) {
                    ref
                        .read(cacheOperationsProvider.notifier)
                        .handleModelUpdate(modelVersion: version);
                  }
                },
                icon: const Icon(Icons.update),
                label: const Text('Process Model Update'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
