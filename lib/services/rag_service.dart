import 'package:dio/dio.dart';
import '../domain/entities/rag_response.dart';

/// Service for RAG (Retrieval-Augmented Generation) operations
class RagService {
  final Dio _dio;
  static const String _baseUrl =
      'https://api.duacopilot.com'; // Replace with actual URL

  RagService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  /// Perform RAG query and get response
  Future<RagResponse> query(String query) async {
    try {
      final response = await _dio.post(
        '/rag/query',
        data: {'query': query, 'timestamp': DateTime.now().toIso8601String()},
      );

      // For now, return a mock response
      // In production, this would parse the actual API response
      return RagResponse(
        id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
        query: query,
        response: 'This is a mock RAG response for: $query',
        timestamp: DateTime.now(),
        responseTime: 500,
        metadata: {'source': 'mock'},
        sources: ['mock_source'],
        confidence: 0.85,
        sessionId: 'mock_session',
        tokensUsed: 100,
        model: 'mock_model',
      );
    } catch (error) {
      throw Exception('RAG service error: $error');
    }
  }

  /// Get similar responses
  Future<List<RagResponse>> getSimilar(String query, {int limit = 5}) async {
    try {
      final response = await _dio.post(
        '/rag/similar',
        data: {'query': query, 'limit': limit},
      );

      // For now, return mock responses
      return List.generate(
        limit,
        (index) => RagResponse(
          id: 'similar_${index}_${DateTime.now().millisecondsSinceEpoch}',
          query: query,
          response: 'Similar response $index for: $query',
          timestamp: DateTime.now(),
          responseTime: 300,
          metadata: {'source': 'similar', 'index': index},
          sources: ['similar_source_$index'],
          confidence: 0.7 + (index * 0.05),
          sessionId: 'similar_session',
          tokensUsed: 80,
          model: 'similarity_model',
        ),
      );
    } catch (error) {
      throw Exception('Similar responses error: $error');
    }
  }

  /// Check service health
  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (error) {
      return false;
    }
  }
}
