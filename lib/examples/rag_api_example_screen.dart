import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/rag_api_client.dart';
import '../services/rag_service.dart';
import '../data/models/rag_response_models.dart';

/// Example screen demonstrating RAG API integration usage
class RagApiExampleScreen extends StatefulWidget {
  const RagApiExampleScreen({super.key});

  @override
  State<RagApiExampleScreen> createState() => _RagApiExampleScreenState();
}

/// _RagApiExampleScreenState class implementation
class _RagApiExampleScreenState extends State<RagApiExampleScreen> {
  late RagService _ragService;
  final TextEditingController _searchController = TextEditingController();

  RagSearchResponse? _currentResponse;
  List<PopularDuaItem> _popularDuas = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeRagService();
  }

  Future<void> _initializeRagService() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiClient = RagApiClient();

      // Set your API token here
      // apiClient.setAuthToken('your-api-token');

      _ragService = RagService(apiClient, prefs);
      await _ragService.initialize();

      // Load popular Du'as on startup
      await _loadPopularDuas();

      // Listen to search results stream
      _ragService.searchResults.listen((response) {
        if (mounted) {
          setState(() {
            _currentResponse = response;
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to initialize RAG service: $e';
      });
    }
  }

  Future<void> _searchDuas(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _ragService.searchDuas(
        query: query,
        language: 'en',
        additionalContext: {
          'user_timezone': DateTime.now().timeZoneName,
          'search_time': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      setState(() {
        _error = 'Search failed: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPopularDuas() async {
    try {
      final response = await _ragService.getPopularDuas(page: 1, limit: 10, timeframe: 'week');

      setState(() {
        _popularDuas = response.duas;
      });
    } catch (e) {
      debugPrint('Failed to load popular Du\'as: $e');
    }
  }

  Future<void> _submitFeedback(String duaId, String queryId, bool isHelpful) async {
    try {
      await _ragService.submitFeedback(
        duaId: duaId,
        queryId: queryId,
        feedbackType: isHelpful ? FeedbackType.helpful : FeedbackType.notHelpful,
        rating: isHelpful ? 5.0 : 2.0,
        comment: isHelpful ? 'Very helpful' : 'Not relevant',
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feedback submitted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit feedback: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RAG API Integration Example'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Search Du\'as', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Enter your situation or feeling...',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => _searchDuas(_searchController.text),
                        ),
                      ),
                      onSubmitted: _searchDuas,
                    ),
                    if (_isLoading) ...[const SizedBox(height: 16), const Center(child: CircularProgressIndicator())],
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer)),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Search Results Section
            if (_currentResponse != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Search Results', style: Theme.of(context).textTheme.titleLarge),
                          const Spacer(),
                          Chip(label: Text('Confidence: ${(_currentResponse!.confidence * 100).toStringAsFixed(1)}%')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Reasoning: ${_currentResponse!.reasoning}', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: _currentResponse!.recommendations.length,
                          itemBuilder: (context, index) {
                            final recommendation = _currentResponse!.recommendations[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(
                                  recommendation.dua.arabicText,
                                  style: const TextStyle(fontFamily: 'Amiri', fontSize: 18),
                                  textDirection: TextDirection.rtl,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(recommendation.dua.transliteration),
                                    Text(recommendation.dua.translation, style: Theme.of(context).textTheme.bodyMedium),
                                    Row(
                                      children: [
                                        Text(
                                          'Relevance: ${(recommendation.relevanceScore * 100).toStringAsFixed(1)}%',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.thumb_up),
                                          onPressed:
                                              () => _submitFeedback(
                                                recommendation.dua.id,
                                                _currentResponse!.queryId,
                                                true,
                                              ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.thumb_down),
                                          onPressed:
                                              () => _submitFeedback(
                                                recommendation.dua.id,
                                                _currentResponse!.queryId,
                                                false,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                isThreeLine: true,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Popular Du'as Section
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Popular Du\'as', style: Theme.of(context).textTheme.titleLarge),
                          const Spacer(),
                          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadPopularDuas),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child:
                            _popularDuas.isEmpty
                                ? const Center(child: Text('No popular Du\'as loaded'))
                                : ListView.builder(
                                  itemCount: _popularDuas.length,
                                  itemBuilder: (context, index) {
                                    final popularDua = _popularDuas[index];
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: ListTile(
                                        leading: CircleAvatar(child: Text('${popularDua.rank}')),
                                        title: Text(
                                          popularDua.dua.arabicText,
                                          style: const TextStyle(fontFamily: 'Amiri', fontSize: 16),
                                          textDirection: TextDirection.rtl,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              popularDua.dua.translation,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              children: [
                                                Chip(
                                                  label: Text(popularDua.category),
                                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  '${popularDua.trendData.views} views',
                                                  style: Theme.of(context).textTheme.bodySmall,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        isThreeLine: true,
                                        onTap: () {
                                          // Navigate to detailed Du'a view
                                          _showDuaDetails(popularDua.dua.id);
                                        },
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDuaDetails(String duaId) async {
    try {
      showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()));

      final details = await _ragService.getDuaDetails(duaId);

      Navigator.of(context).pop(); // Close loading dialog

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Du\'a Details'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      details.dua.arabicText,
                      style: const TextStyle(fontFamily: 'Amiri', fontSize: 20),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 16),
                    Text('Transliteration:', style: Theme.of(context).textTheme.titleSmall),
                    Text(details.dua.transliteration),
                    const SizedBox(height: 16),
                    Text('Translation:', style: Theme.of(context).textTheme.titleSmall),
                    Text(details.dua.translation),
                    if (details.audio != null) ...[
                      const SizedBox(height: 16),
                      Text('Audio:', style: Theme.of(context).textTheme.titleSmall),
                      Text('Reciter: ${details.audio!.reciter}'),
                      Text('Duration: ${details.audio!.durationMs ~/ 1000}s'),
                    ],
                    if (details.tags.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text('Tags:', style: Theme.of(context).textTheme.titleSmall),
                      Wrap(spacing: 8, children: details.tags.map((tag) => Chip(label: Text(tag))).toList()),
                    ],
                  ],
                ),
              ),
              actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
            ),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load Du\'a details: $e')));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _ragService.dispose();
    super.dispose();
  }
}
