import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/local_search/providers/local_search_providers.dart';
import '../core/local_search/models/local_search_models.dart';

/// Demo screen for local semantic search functionality
class LocalSearchDemoScreen extends ConsumerStatefulWidget {
  const LocalSearchDemoScreen({super.key});

  @override
  ConsumerState<LocalSearchDemoScreen> createState() => _LocalSearchDemoScreenState();
}

/// _LocalSearchDemoScreenState class implementation
class _LocalSearchDemoScreenState extends ConsumerState<LocalSearchDemoScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLanguage = 'en';
  bool _forceOffline = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeService();
    });
  }

  Future<void> _initializeService() async {
    try {
      await ref.read(localSearchServiceProvider).initialize();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Local search service initialized successfully'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to initialize: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchStateProvider);
    final offlineStatus = ref.watch(offlineStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Semantic Search Demo'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(offlineStatus ? Icons.cloud_off : Icons.cloud, color: offlineStatus ? Colors.red : Colors.green),
            onPressed: () => _showStatusDialog(context),
          ),
        ],
      ),
      body: Column(children: [_buildSearchHeader(), _buildSearchResults(searchState)]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showActionsDialog(context),
        icon: const Icon(Icons.settings),
        label: const Text('Actions'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[50], border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
      child: Column(
        children: [
          // Search input
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search for Du\'a or Islamic guidance',
              hintText: 'e.g., morning dua, travel prayer...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(icon: const Icon(Icons.send), onPressed: _performSearch),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onSubmitted: (_) => _performSearch(),
          ),
          const SizedBox(height: 16),

          // Options
          Row(
            children: [
              // Language selection
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedLanguage,
                  decoration: const InputDecoration(labelText: 'Language', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                    DropdownMenuItem(value: 'ur', child: Text('اردو')),
                    DropdownMenuItem(value: 'id', child: Text('Bahasa')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),

              // Force offline toggle
              Expanded(
                child: SwitchListTile(
                  title: const Text('Force Offline'),
                  value: _forceOffline,
                  onChanged: (value) {
                    setState(() {
                      _forceOffline = value;
                    });
                  },
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(SearchState searchState) {
    if (searchState.isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (searchState.hasError) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: ${searchState.error}'),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _performSearch, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (!searchState.hasResults) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Enter a query to search for Du\'a and Islamic guidance',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildSampleQueries(),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: Column(
        children: [
          _buildSearchMetadata(searchState),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: searchState.results.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _buildResultCard(searchState.results[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchMetadata(SearchState searchState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: searchState.isOnline ? Colors.green[50] : Colors.orange[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Icon(
            searchState.isOnline ? Icons.cloud : Icons.cloud_off,
            color: searchState.isOnline ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${searchState.results.length} results from ${searchState.source}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Confidence: ${(searchState.confidence * 100).toInt()}% | '
                  '${searchState.isOnline ? 'Online' : 'Offline'} search',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          if (searchState.processingTime != null)
            Text(
              '${searchState.processingTime!.inMilliseconds}ms',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
        ],
      ),
    );
  }

  Widget _buildResultCard(LocalSearchResult result) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with quality indicators
            Row(
              children: [
                Expanded(child: Text(result.query, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                _buildQualityChip(result),
              ],
            ),
            const SizedBox(height: 8),

            // Response text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
              child: Text(result.response, style: const TextStyle(fontSize: 14, height: 1.5)),
            ),
            const SizedBox(height: 12),

            // Metadata
            Row(
              children: [
                Icon(
                  result.isOffline ? Icons.offline_bolt : Icons.cloud,
                  size: 16,
                  color: result.isOffline ? Colors.orange : Colors.green,
                ),
                const SizedBox(width: 4),
                Text('Source: ${result.source}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const Spacer(),
                Text(
                  'Confidence: ${(result.confidence * 100).toInt()}%',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityChip(LocalSearchResult result) {
    final quality = result.quality;
    Color chipColor;

    switch (quality.qualityLevel) {
      case 'Excellent':
        chipColor = Colors.green;
        break;
      case 'Good':
        chipColor = Colors.blue;
        break;
      case 'Fair':
        chipColor = Colors.orange;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(quality.qualityLevel, style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: chipColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildSampleQueries() {
    final sampleQueries = ['morning dua', 'travel prayer', 'dua before eating', 'evening remembrance'];

    return Column(
      children: [
        const Text('Try these sample queries:'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children:
              sampleQueries.map((query) {
                return ActionChip(
                  label: Text(query),
                  onPressed: () {
                    _searchController.text = query;
                    _performSearch();
                  },
                );
              }).toList(),
        ),
      ],
    );
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      ref
          .read(searchStateProvider.notifier)
          .search(query: query, language: _selectedLanguage, forceOffline: _forceOffline);
    }
  }

  void _showStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Search Service Status'),
            content: Consumer(
              builder: (context, ref, child) {
                return FutureBuilder<Map<String, dynamic>>(
                  future: ref.read(localSearchServiceProvider).getSearchStats(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    final stats = snapshot.data ?? {};
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Online: ${!ref.watch(offlineStatusProvider)}'),
                        Text('Queue Size: ${stats['queue']?['total_pending'] ?? 0}'),
                        Text('Embeddings: ${stats['embeddings']?['embeddings_count'] ?? 0}'),
                        Text('Templates: ${stats['templates']?['en']?['total_templates'] ?? 0}'),
                      ],
                    );
                  },
                );
              },
            ),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
          ),
    );
  }

  void _showActionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Actions'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Preload Popular Queries'),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      await ref.read(localSearchServiceProvider).preloadPopularQueries();
                      if (mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Popular queries preloaded')));
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.sync),
                  title: const Text('Sync Pending Queries'),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      await ref.read(localSearchServiceProvider).syncPendingQueries();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sync completed')));
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Clear Offline Data'),
                  onTap: () async {
                    Navigator.pop(context);
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Confirm'),
                            content: const Text('Clear all offline data?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Clear')),
                            ],
                          ),
                    );

                    if (confirm == true) {
                      try {
                        await ref.read(localSearchServiceProvider).clearOfflineData();
                        if (mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(const SnackBar(content: Text('Offline data cleared')));
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      }
                    }
                  },
                ),
              ],
            ),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
          ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
