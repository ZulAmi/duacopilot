import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/rag_provider.dart';
import '../providers/rag_debug_provider.dart';
import '../providers/rag_state_models.dart';

/// Example widget demonstrating robust RAG state management
class RagExampleScreen extends ConsumerStatefulWidget {
  const RagExampleScreen({super.key});

  @override
  ConsumerState<RagExampleScreen> createState() => _RagExampleScreenState();
}

class _RagExampleScreenState extends ConsumerState<RagExampleScreen> {
  final TextEditingController _queryController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch all RAG providers
    final ragApiState = ref.watch(ragApiProvider);
    final ragCache = ref.watch(ragCacheProvider);
    final ragFilter = ref.watch(ragFilterProvider);
    final ragWebSocket = ref.watch(ragWebSocketProvider);
    final ragDebug = ref.watch(ragDebugProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RAG State Management Demo'),
        actions: [
          // Debug mode toggle
          IconButton(
            icon: Icon(
              ragDebug.isDebugEnabled
                  ? Icons.bug_report
                  : Icons.bug_report_outlined,
            ),
            onPressed: () {
              ref
                  .read(ragDebugProvider.notifier)
                  .setDebugMode(!ragDebug.isDebugEnabled);
            },
          ),
          // Clear cache
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () async {
              await ref.read(ragCacheProvider.notifier).clear();
              if (mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Cache cleared')));
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Connection Status
          _buildConnectionStatus(ragWebSocket),

          // Query Input
          _buildQueryInput(),

          // Filter Controls
          _buildFilterControls(ragFilter),

          // Response Display
          Expanded(child: _buildResponseArea(ragApiState, ragCache)),

          // Debug Panel (if enabled)
          if (ragDebug.isDebugEnabled) _buildDebugPanel(ragDebug),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(WebSocketState webSocketState) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (webSocketState.connectionState) {
      case WebSocketConnectionState.connected:
        statusColor = Colors.green;
        statusText = 'Connected';
        statusIcon = Icons.wifi;
        break;
      case WebSocketConnectionState.connecting:
        statusColor = Colors.orange;
        statusText = 'Connecting...';
        statusIcon = Icons.wifi_protected_setup;
        break;
      case WebSocketConnectionState.reconnecting:
        statusColor = Colors.orange;
        statusText = 'Reconnecting...';
        statusIcon = Icons.refresh;
        break;
      case WebSocketConnectionState.error:
        statusColor = Colors.red;
        statusText = 'Error: ${webSocketState.error}';
        statusIcon = Icons.wifi_off;
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Disconnected';
        statusIcon = Icons.wifi_off;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      color: statusColor.withOpacity(0.1),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 16),
          const SizedBox(width: 8),
          Text(statusText, style: TextStyle(color: statusColor, fontSize: 12)),
          const Spacer(),
          if (webSocketState.lastConnected != null)
            Text(
              'Last: ${_formatTime(webSocketState.lastConnected!)}',
              style: TextStyle(color: statusColor, fontSize: 10),
            ),
        ],
      ),
    );
  }

  Widget _buildQueryInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _queryController,
              decoration: const InputDecoration(
                hintText: 'Enter your question...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: _performQuery,
            ),
          ),
          const SizedBox(width: 8),
          Consumer(
            builder: (context, ref, child) {
              final ragApiState = ref.watch(ragApiProvider);
              final isLoading =
                  ragApiState.value?.apiState == RagApiState.loading;

              return ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : () => _performQuery(_queryController.text),
                child:
                    isLoading
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('Ask'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterControls(RagFilterConfig filterConfig) {
    return ExpansionTile(
      title: const Text('Filter Settings'),
      leading: const Icon(Icons.filter_alt),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Confidence threshold
              Row(
                children: [
                  const Text('Min Confidence:'),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Slider(
                      value: filterConfig.minConfidence,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      label: filterConfig.minConfidence.toStringAsFixed(1),
                      onChanged: (value) {
                        ref
                            .read(ragFilterProvider.notifier)
                            .updateMinConfidence(value);
                      },
                    ),
                  ),
                ],
              ),

              // Max results
              Row(
                children: [
                  const Text('Max Results:'),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Slider(
                      value: filterConfig.maxResults.toDouble(),
                      min: 1,
                      max: 100,
                      divisions: 99,
                      label: filterConfig.maxResults.toString(),
                      onChanged: (value) {
                        ref
                            .read(ragFilterProvider.notifier)
                            .updateMaxResults(value.round());
                      },
                    ),
                  ),
                ],
              ),

              // Language filter
              Wrap(
                children: [
                  FilterChip(
                    label: const Text('English'),
                    selected: filterConfig.languageFilter.contains('en'),
                    onSelected: (selected) {
                      final languages = [...filterConfig.languageFilter];
                      if (selected) {
                        languages.add('en');
                      } else {
                        languages.remove('en');
                      }
                      ref
                          .read(ragFilterProvider.notifier)
                          .updateLanguageFilter(languages);
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Arabic'),
                    selected: filterConfig.languageFilter.contains('ar'),
                    onSelected: (selected) {
                      final languages = [...filterConfig.languageFilter];
                      if (selected) {
                        languages.add('ar');
                      } else {
                        languages.remove('ar');
                      }
                      ref
                          .read(ragFilterProvider.notifier)
                          .updateLanguageFilter(languages);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResponseArea(
    AsyncValue<RagStateData> ragApiState,
    Map<String, CachedRagEntry> cache,
  ) {
    return ragApiState.when(
      data: (state) {
        return Column(
          children: [
            // State indicator
            _buildStateIndicator(state),

            // Response content
            Expanded(child: _buildResponseContent(state)),

            // Cache status
            _buildCacheStatus(cache),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text('Error: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(ragApiProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildStateIndicator(RagStateData state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: _getStateColor(state.apiState).withOpacity(0.1),
      child: Row(
        children: [
          Icon(
            _getStateIcon(state.apiState),
            size: 16,
            color: _getStateColor(state.apiState),
          ),
          const SizedBox(width: 8),
          Text(
            _getStateText(state),
            style: TextStyle(
              color: _getStateColor(state.apiState),
              fontSize: 12,
            ),
          ),
          const Spacer(),
          if (state.confidence != null)
            Text(
              'Confidence: ${(state.confidence! * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 10),
            ),
        ],
      ),
    );
  }

  Widget _buildResponseContent(RagStateData state) {
    if (state.response == null) {
      return const Center(child: Text('Enter a question to get started'));
    }

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Query
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Question:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(state.response!.query),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Response
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Answer:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      if (state.isFromCache)
                        const Chip(
                          label: Text('Cached', style: TextStyle(fontSize: 10)),
                          backgroundColor: Colors.green,
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(state.response!.response),

                  const SizedBox(height: 16),

                  // Metadata
                  if (state.response!.sources?.isNotEmpty == true) ...[
                    const Text(
                      'Sources:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...state.response!.sources!.map(
                      (source) => Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          '• $source',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),

                  // Response time and metadata
                  Row(
                    children: [
                      Text(
                        'Response time: ${state.response!.responseTime}ms',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Tokens: ${state.response!.tokensUsed}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCacheStatus(Map<String, CachedRagEntry> cache) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      color: Colors.grey.withOpacity(0.1),
      child: Text(
        'Cache: ${cache.length} entries',
        style: const TextStyle(fontSize: 10, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDebugPanel(RagDebugState debugState) {
    final metrics = ref.read(ragDebugProvider.notifier).getPerformanceMetrics();

    return Container(
      height: 120,
      padding: const EdgeInsets.all(8),
      color: Colors.black.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Debug Info:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDebugMetric('API Calls', '${metrics['apiCalls']}'),
              _buildDebugMetric(
                'Avg Response',
                '${metrics['averageResponseTime'].toStringAsFixed(0)}ms',
              ),
              _buildDebugMetric(
                'Cache Hit Rate',
                '${metrics['cacheHitRate'].toStringAsFixed(1)}%',
              ),
              _buildDebugMetric(
                'Error Rate',
                '${metrics['errorRate'].toStringAsFixed(1)}%',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(ragDebugProvider.notifier).clearLogs();
                  },
                  child: const Text('Clear Logs'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final data =
                        ref.read(ragDebugProvider.notifier).exportDebugData();
                    // Export debug data (implement actual export functionality)
                    print('Debug data exported: $data');
                  },
                  child: const Text('Export'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDebugMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  void _performQuery(String query) {
    if (query.trim().isEmpty) return;

    ref.read(ragApiProvider.notifier).performQuery(query.trim());

    // Log the query for debugging
    ref
        .read(ragDebugProvider.notifier)
        .logStateTransition('ragApiProvider', 'idle', 'loading');
  }

  Color _getStateColor(RagApiState state) {
    switch (state) {
      case RagApiState.idle:
        return Colors.grey;
      case RagApiState.loading:
      case RagApiState.retrying:
        return Colors.blue;
      case RagApiState.success:
        return Colors.green;
      case RagApiState.error:
        return Colors.red;
    }
  }

  IconData _getStateIcon(RagApiState state) {
    switch (state) {
      case RagApiState.idle:
        return Icons.help_outline;
      case RagApiState.loading:
        return Icons.hourglass_empty;
      case RagApiState.retrying:
        return Icons.refresh;
      case RagApiState.success:
        return Icons.check_circle;
      case RagApiState.error:
        return Icons.error;
    }
  }

  String _getStateText(RagStateData state) {
    switch (state.apiState) {
      case RagApiState.idle:
        return 'Ready';
      case RagApiState.loading:
        return 'Processing...';
      case RagApiState.retrying:
        return 'Retrying... (${state.retryCount}/3)';
      case RagApiState.success:
        return 'Success ${state.isFromCache ? '(Cached)' : ''}';
      case RagApiState.error:
        return 'Error: ${state.error ?? 'Unknown error'}';
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else {
      return '${diff.inHours}h ago';
    }
  }
}
