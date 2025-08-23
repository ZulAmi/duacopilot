import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../../domain/entities/query_history.dart';

/// HistoryWidget class implementation
class HistoryWidget extends ConsumerStatefulWidget {
  const HistoryWidget({super.key});

  @override
  ConsumerState<HistoryWidget> createState() => _HistoryWidgetState();
}

/// _HistoryWidgetState class implementation
class _HistoryWidgetState extends ConsumerState<HistoryWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _filterText = '';

  @override
  Widget build(BuildContext context) {
    final asyncHistory = ref.watch(queryHistoryProvider);
    final filteredHistory = ref.watch(
      filteredQueryHistoryProvider(_filterText),
    );

    return Column(
      children: [
        // Search filter
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search history...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon:
                _filterText.isNotEmpty
                    ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _filterText = '';
                        });
                      },
                      icon: const Icon(Icons.clear),
                    )
                    : null,
          ),
          onChanged: (value) {
            setState(() {
              _filterText = value;
            });
          },
        ),
        const SizedBox(height: 16),

        // History list
        Expanded(
          child: asyncHistory.when(
            data: (history) {
              final displayHistory =
                  _filterText.isEmpty ? history : filteredHistory;

              if (displayHistory.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _filterText.isEmpty ? Icons.history : Icons.search_off,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _filterText.isEmpty
                            ? 'No search history yet'
                            : 'No results found',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _filterText.isEmpty
                            ? 'Your search queries will appear here'
                            : 'Try a different search term',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: displayHistory.length,
                itemBuilder: (context, index) {
                  final item = displayHistory[index];
                  return HistoryTile(
                    queryHistory: item,
                    onTap: () => _repeatQuery(item.query),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading history',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(queryHistoryProvider);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ],
    );
  }

  void _repeatQuery(String query) {
    // Navigate back to search page and perform the query
    ref.read(searchProvider.notifier).search(query);
    // If this widget is in a tab/page view, you might want to switch tabs here
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

/// HistoryTile class implementation
class HistoryTile extends StatelessWidget {
  final QueryHistory queryHistory;
  final VoidCallback? onTap;

  const HistoryTile({super.key, required this.queryHistory, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          queryHistory.success ? Icons.check_circle : Icons.error,
          color:
              queryHistory.success
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.error,
        ),
        title: Text(
          queryHistory.query,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (queryHistory.response != null &&
                queryHistory.response!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  queryHistory.response!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatTimestamp(queryHistory.timestamp),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (queryHistory.responseTime != null) ...[
                    const SizedBox(width: 12),
                    Icon(
                      Icons.timer,
                      size: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${queryHistory.responseTime}ms',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: onTap,
          icon: const Icon(Icons.replay),
          tooltip: 'Repeat query',
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
