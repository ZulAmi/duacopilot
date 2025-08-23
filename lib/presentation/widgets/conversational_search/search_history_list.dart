import 'package:flutter/material.dart';

/// SearchHistoryItem class implementation
class SearchHistoryItem {
  final String id;
  final String query;
  final String response;
  final DateTime timestamp;
  final bool success;
  final double? confidence;
  final int? responseTime;
  final List<String>? sources;

  const SearchHistoryItem({
    required this.id,
    required this.query,
    required this.response,
    required this.timestamp,
    required this.success,
    this.confidence,
    this.responseTime,
    this.sources,
  });
}

/// SemanticGroup class implementation
class SemanticGroup {
  final String title;
  final List<SearchHistoryItem> items;
  final double similarity;
  final String category;

  const SemanticGroup({required this.title, required this.items, required this.similarity, required this.category});
}

/// SearchHistoryListView class implementation
class SearchHistoryListView extends StatefulWidget {
  final List<SearchHistoryItem> historyItems;
  final Function(String) onItemTapped;
  final Function(String)? onItemDeleted;
  final bool groupBySemantic;
  final bool showGroupHeaders;
  final int maxItemsPerGroup;

  const SearchHistoryListView({
    super.key,
    required this.historyItems,
    required this.onItemTapped,
    this.onItemDeleted,
    this.groupBySemantic = true,
    this.showGroupHeaders = true,
    this.maxItemsPerGroup = 5,
  });

  @override
  State<SearchHistoryListView> createState() => _SearchHistoryListViewState();
}

/// _SearchHistoryListViewState class implementation
class _SearchHistoryListViewState extends State<SearchHistoryListView> {
  List<SemanticGroup> _semanticGroups = [];
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _buildSemanticGroups();
  }

  @override
  void didUpdateWidget(SearchHistoryListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.historyItems != widget.historyItems) {
      _buildSemanticGroups();
    }
  }

  void _buildSemanticGroups() {
    if (!widget.groupBySemantic) {
      _semanticGroups = [
        SemanticGroup(title: 'All Searches', items: widget.historyItems, similarity: 1.0, category: 'general'),
      ];
      return;
    }

    final groups = <String, List<SearchHistoryItem>>{};

    for (final item in widget.historyItems) {
      final category = _categorizeQuery(item.query);
      groups.putIfAbsent(category, () => []).add(item);
    }

    _semanticGroups =
        groups.entries.map((entry) {
          final category = entry.key;
          final items = entry.value;

          // Sort items within group by timestamp (newest first)
          items.sort((a, b) => b.timestamp.compareTo(a.timestamp));

          return SemanticGroup(
            title: _getCategoryDisplayName(category),
            items: items,
            similarity: 1.0,
            category: category,
          );
        }).toList();

    // Sort groups by most recent item in each group
    _semanticGroups.sort((a, b) {
      final aLatest = a.items.isNotEmpty ? a.items.first.timestamp : DateTime(1970);
      final bLatest = b.items.isNotEmpty ? b.items.first.timestamp : DateTime(1970);
      return bLatest.compareTo(aLatest);
    });
  }

  String _categorizeQuery(String query) {
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('morning') || lowerQuery.contains('fajr')) {
      return 'morning_prayers';
    }
    if (lowerQuery.contains('evening') || lowerQuery.contains('maghrib') || lowerQuery.contains('isha')) {
      return 'evening_prayers';
    }
    if (lowerQuery.contains('prayer') || lowerQuery.contains('salah') || lowerQuery.contains('namaz')) {
      return 'prayer_related';
    }
    if (lowerQuery.contains('travel') || lowerQuery.contains('journey')) {
      return 'travel';
    }
    if (lowerQuery.contains('food') || lowerQuery.contains('eating') || lowerQuery.contains('meal')) {
      return 'food_duas';
    }
    if (lowerQuery.contains('sleep') || lowerQuery.contains('night') || lowerQuery.contains('bed')) {
      return 'sleep_duas';
    }
    if (lowerQuery.contains('forgive') || lowerQuery.contains('istighfar') || lowerQuery.contains('repent')) {
      return 'forgiveness';
    }
    if (lowerQuery.contains('protect') || lowerQuery.contains('safety') || lowerQuery.contains('evil')) {
      return 'protection';
    }
    if (lowerQuery.contains('quran') || lowerQuery.contains('verse') || lowerQuery.contains('ayah')) {
      return 'quran';
    }
    if (lowerQuery.contains('dhikr') || lowerQuery.contains('remembr') || lowerQuery.contains('tasbih')) {
      return 'remembrance';
    }

    return 'general';
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'morning_prayers':
        return 'Morning Prayers';
      case 'evening_prayers':
        return 'Evening Prayers';
      case 'prayer_related':
        return 'Prayer & Salah';
      case 'travel':
        return 'Travel Duas';
      case 'food_duas':
        return 'Food & Meals';
      case 'sleep_duas':
        return 'Sleep & Rest';
      case 'forgiveness':
        return 'Forgiveness';
      case 'protection':
        return 'Protection';
      case 'quran':
        return 'Quran & Verses';
      case 'remembrance':
        return 'Dhikr & Remembrance';
      default:
        return 'General Searches';
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'morning_prayers':
        return Icons.wb_sunny;
      case 'evening_prayers':
        return Icons.nightlight_round;
      case 'prayer_related':
        return Icons.schedule;
      case 'travel':
        return Icons.flight;
      case 'food_duas':
        return Icons.restaurant;
      case 'sleep_duas':
        return Icons.bedtime;
      case 'forgiveness':
        return Icons.favorite;
      case 'protection':
        return Icons.shield;
      case 'quran':
        return Icons.menu_book;
      case 'remembrance':
        return Icons.psychology;
      default:
        return Icons.search;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'morning_prayers':
        return Colors.orange;
      case 'evening_prayers':
        return Colors.indigo;
      case 'prayer_related':
        return Colors.green;
      case 'travel':
        return Colors.blue;
      case 'food_duas':
        return Colors.brown;
      case 'sleep_duas':
        return Colors.purple;
      case 'forgiveness':
        return Colors.red;
      case 'protection':
        return Colors.teal;
      case 'quran':
        return Colors.deepPurple;
      case 'remembrance':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.historyItems.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _semanticGroups.length,
      itemBuilder: (context, groupIndex) {
        final group = _semanticGroups[groupIndex];
        return _buildSemanticGroup(group, groupIndex);
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.history, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'No Search History',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Text(
            'Your search history will appear here',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSemanticGroup(SemanticGroup group, int groupIndex) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final categoryColor = _getCategoryColor(group.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showGroupHeaders && widget.groupBySemantic) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(_getCategoryIcon(group.category), size: 16, color: categoryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      group.title,
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${group.items.length}',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          ...group.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            if (index >= widget.maxItemsPerGroup && !_isExpanded) {
              if (index == widget.maxItemsPerGroup) {
                return _buildExpandButton(group.items.length - widget.maxItemsPerGroup);
              }
              return const SizedBox.shrink();
            }

            return _buildHistoryItem(item, categoryColor);
          }),
        ],
      ),
    );
  }

  Widget _buildExpandButton(int hiddenCount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                _isExpanded ? 'Show Less' : 'Show $hiddenCount More',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(SearchHistoryItem item, Color categoryColor) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onItemTapped(item.query),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.query,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.onItemDeleted != null)
                      IconButton(
                        onPressed: () => widget.onItemDeleted!(item.id),
                        icon: Icon(Icons.close, size: 16, color: colorScheme.onSurfaceVariant),
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.response,
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      _formatTimestamp(item.timestamp),
                      style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    if (item.confidence != null) ...[
                      const SizedBox(width: 16),
                      Icon(Icons.psychology, size: 12, color: categoryColor),
                      const SizedBox(width: 4),
                      Text(
                        '${(item.confidence! * 100).toInt()}%',
                        style: textTheme.labelSmall?.copyWith(color: categoryColor),
                      ),
                    ],
                    if (item.responseTime != null) ...[
                      const SizedBox(width: 16),
                      Icon(Icons.speed, size: 12, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        '${item.responseTime}ms',
                        style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: item.success ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.success ? 'Success' : 'Failed',
                        style: textTheme.labelSmall?.copyWith(
                          color: item.success ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
