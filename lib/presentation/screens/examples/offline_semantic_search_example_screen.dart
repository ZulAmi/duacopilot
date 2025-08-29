import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../data/models/rag_response_models.dart';
import '../../../services/enhanced_rag_service.dart';
import '../../../services/offline/offline_search_initialization_service.dart';

/// Example screen demonstrating offline semantic search functionality
class OfflineSemanticSearchExampleScreen extends StatefulWidget {
  const OfflineSemanticSearchExampleScreen({super.key});

  @override
  State<OfflineSemanticSearchExampleScreen> createState() =>
      _OfflineSemanticSearchExampleScreenState();
}

class _OfflineSemanticSearchExampleScreenState
    extends State<OfflineSemanticSearchExampleScreen> {
  final TextEditingController _queryController = TextEditingController();
  bool _isLoading = false;
  bool _isInitialized = false;
  RagSearchResponse? _lastResult;
  Map<String, dynamic>? _searchStats;
  String _selectedLanguage = 'en';
  bool _preferOffline = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    setState(() => _isLoading = true);

    try {
      // Initialize offline search if not already done
      if (!OfflineSearchInitializationService.isInitialized) {
        await OfflineSearchInitializationService.initializeOfflineSearch();
      }

      // Populate initial embeddings if needed
      await OfflineSearchInitializationService.populateInitialEmbeddings();

      // Get enhanced RAG service
      final enhancedRagService = GetIt.instance<EnhancedRagService>();
      _searchStats = await enhancedRagService.getSearchStatistics();

      setState(() => _isInitialized = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to initialize: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _performSearch() async {
    if (_queryController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final enhancedRagService = GetIt.instance<EnhancedRagService>();

      final result = await enhancedRagService.searchDuas(
        query: _queryController.text.trim(),
        language: _selectedLanguage,
        preferOffline: _preferOffline,
      );

      setState(() => _lastResult = result);

      // Update search statistics
      _searchStats = await enhancedRagService.getSearchStatistics();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Search failed: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Semantic Search Demo'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Initialization Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'System Status',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _isInitialized ? Icons.check_circle : Icons.error,
                          color: _isInitialized ? Colors.green : Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isInitialized
                              ? 'Offline Search Ready'
                              : 'Initializing...',
                        ),
                      ],
                    ),
                    if (_searchStats != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Capabilities: Online=${_searchStats!['capabilities']?['online_available']}, '
                        'Offline=${_searchStats!['capabilities']?['offline_available']}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Search Form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Du\'as',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // Query Input
                    TextField(
                      controller: _queryController,
                      decoration: const InputDecoration(
                        hintText:
                            'Enter your search query (e.g., "morning prayer", "forgiveness")',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _performSearch(),
                    ),

                    const SizedBox(height: 16),

                    // Language and Preference Controls
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedLanguage,
                            decoration: const InputDecoration(
                              labelText: 'Language',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'en',
                                child: Text('English'),
                              ),
                              DropdownMenuItem(
                                value: 'ar',
                                child: Text('Arabic'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() => _selectedLanguage = value ?? 'en');
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          children: [
                            const Text('Prefer Offline'),
                            Switch(
                              value: _preferOffline,
                              onChanged: (value) {
                                setState(() => _preferOffline = value);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Search Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isInitialized && !_isLoading
                            ? _performSearch
                            : null,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Search'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Results
            Expanded(
              child: _lastResult != null
                  ? _buildSearchResults()
                  : const Center(
                      child: Text(
                        'No search results yet. Try searching for something!',
                      ),
                    ),
            ),
          ],
        ),
      ),

      // Floating action button for quick actions
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "sync",
            mini: true,
            onPressed: _isInitialized ? _syncWithRemote : null,
            tooltip: 'Sync with Remote',
            child: const Icon(Icons.sync),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "stats",
            mini: true,
            onPressed: _showStatistics,
            tooltip: 'Show Statistics',
            child: const Icon(Icons.analytics),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final result = _lastResult!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Result Header
            Row(
              children: [
                Icon(
                  result.metadata?['search_type'] == 'online'
                      ? Icons.cloud_done
                      : Icons.offline_bolt,
                  color: result.metadata?['search_type'] == 'online'
                      ? Colors.blue
                      : Colors.green,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Results (${result.recommendations.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getQualityColor(result.metadata?['quality']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    result.metadata?['quality']?.toString().toUpperCase() ??
                        'UNKNOWN',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              result.reasoning,
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 16),

            // Results List
            Expanded(
              child: ListView.builder(
                itemCount: result.recommendations.length,
                itemBuilder: (context, index) {
                  final recommendation = result.recommendations[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Du'a Text
                          Text(
                            recommendation.dua.arabicText,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                            textDirection: TextDirection.rtl,
                          ),

                          if (recommendation
                              .dua.transliteration.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              recommendation.dua.transliteration,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontStyle: FontStyle.italic),
                            ),
                          ],

                          const SizedBox(height: 8),

                          Text(
                            recommendation.dua.translation,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                          const SizedBox(height: 12),

                          // Metadata
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  recommendation.dua.category.toUpperCase(),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${(recommendation.relevanceScore * 100).toInt()}% match',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),

                          if (recommendation.matchReason.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              recommendation.matchReason,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getQualityColor(String? quality) {
    switch (quality?.toLowerCase()) {
      case 'high':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.red;
      case 'cached':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _syncWithRemote() async {
    try {
      final enhancedRagService = GetIt.instance<EnhancedRagService>();
      await enhancedRagService.syncWithRemote();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Successfully synced with remote server')),
        );
      }

      // Update statistics
      _searchStats = await enhancedRagService.getSearchStatistics();
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sync failed: $e')));
      }
    }
  }

  void _showStatistics() {
    if (_searchStats == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Statistics'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Connection: ${_searchStats!['connection_status'] ? 'Online' : 'Offline'}',
              ),
              const SizedBox(height: 8),
              Text('Capabilities:'),
              Text(
                '  - Online: ${_searchStats!['capabilities']?['online_available']}',
              ),
              Text(
                '  - Offline: ${_searchStats!['capabilities']?['offline_available']}',
              ),
              const SizedBox(height: 8),
              if (_searchStats!['offline_stats'] != null) ...[
                Text('Offline Statistics:'),
                Text(
                  '  - Storage: ${_searchStats!['offline_stats']['storage']}',
                ),
                Text(
                  '  - Available Languages: ${_searchStats!['offline_stats']['available_languages']}',
                ),
                Text(
                  '  - Available Categories: ${_searchStats!['offline_stats']['available_categories']}',
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }
}

