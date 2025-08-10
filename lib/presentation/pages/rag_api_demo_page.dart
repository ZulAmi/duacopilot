// Example usage of the comprehensive RAG API service
// This demonstrates all the advanced features implemented

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/rag_api_service.dart';
import '../../data/models/rag_request_model.dart';
import '../../core/di/injection_container.dart';

class RagApiServiceDemoPage extends ConsumerStatefulWidget {
  const RagApiServiceDemoPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RagApiServiceDemoPage> createState() =>
      _RagApiServiceDemoPageState();
}

class _RagApiServiceDemoPageState extends ConsumerState<RagApiServiceDemoPage> {
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  String _response = '';
  bool _isLoading = false;
  bool _isWebSocketConnected = false;

  late RagApiService _ragApiService;

  @override
  void initState() {
    super.initState();
    _ragApiService = sl<RagApiService>();
    _setupWebSocketListener();
  }

  void _setupWebSocketListener() {
    // Listen for real-time updates
    _ragApiService.realTimeUpdates?.listen(
      (response) {
        setState(() {
          _response = 'Real-time update: ${response.response}';
        });
      },
      onError: (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('WebSocket error: $error')));
      },
    );
  }

  Future<void> _setAuthToken() async {
    if (_tokenController.text.isNotEmpty) {
      await _ragApiService.setAuthToken(_tokenController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Auth token set successfully')),
      );
    }
  }

  Future<void> _queryRag() async {
    if (_queryController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _response = '';
    });

    try {
      final request = RagRequestModel(
        query: _queryController.text,
        sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
        includeMetadata: true,
        maxTokens: 500,
        temperature: 0.7,
      );

      final response = await _ragApiService.queryRag(request);

      setState(() {
        _response = '''
RAG Response:
ID: ${response.id}
Query: ${response.query}
Response: ${response.response}
Timestamp: ${response.timestamp}
Response Time: ${response.responseTime}ms
Metadata: ${response.metadata}
Sources: ${response.sources}
''';
      });
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getQueryHistory() async {
    setState(() {
      _isLoading = true;
      _response = '';
    });

    try {
      final history = await _ragApiService.getQueryHistory(limit: 10);

      setState(() {
        _response = '''
Query History (${history.length} items):
${history.map((h) => '• ${h.query} -> ${h.response.substring(0, 50)}...').join('\n')}
''';
      });
    } catch (e) {
      setState(() {
        _response = 'Error getting history: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _connectWebSocket() async {
    try {
      await _ragApiService.connectWebSocket(
        sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      setState(() {
        _isWebSocketConnected = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('WebSocket connected for real-time updates'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('WebSocket connection failed: $e')),
      );
    }
  }

  void _clearCache() {
    _ragApiService.clearCache();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cache cleared')));
  }

  @override
  void dispose() {
    _queryController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RAG API Service Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Auth Token Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Authentication',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _tokenController,
                      decoration: const InputDecoration(
                        labelText: 'API Token',
                        hintText: 'Enter your RAG API token',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _setAuthToken,
                      child: const Text('Set Auth Token'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Query Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RAG Query',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _queryController,
                      decoration: const InputDecoration(
                        labelText: 'Query',
                        hintText: 'Enter your question...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: _isLoading ? null : _queryRag,
                          child:
                              _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text('Query RAG'),
                        ),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _getQueryHistory,
                          child: const Text('Get History'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Advanced Features Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Advanced Features',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: _connectWebSocket,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _isWebSocketConnected ? Colors.green : null,
                          ),
                          child: Text(
                            _isWebSocketConnected
                                ? 'WebSocket Connected'
                                : 'Connect WebSocket',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _clearCache,
                          child: const Text('Clear Cache'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Response Section
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Response',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              _response.isEmpty
                                  ? 'No response yet...'
                                  : _response,
                              style: const TextStyle(fontFamily: 'monospace'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Features Summary
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RAG API Service Features:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '✅ Dio client with authentication interceptors and logging',
                    ),
                    const Text(
                      '✅ Custom retry logic for failed requests with exponential backoff',
                    ),
                    const Text(
                      '✅ Network connectivity monitoring using connectivity_plus',
                    ),
                    const Text(
                      '✅ Response caching with intelligent query caching',
                    ),
                    const Text(
                      '✅ WebSocket integration for real-time RAG updates',
                    ),
                    const Text(
                      '✅ Custom error handling for timeouts, rate limits, and server errors',
                    ),
                    const Text(
                      '✅ Secure token storage with flutter_secure_storage',
                    ),
                    const Text(
                      '✅ Comprehensive logging with structured log messages',
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
}
