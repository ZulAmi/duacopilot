import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../config/rag_config.dart';
import '../../core/exceptions/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../core/storage/secure_storage_service.dart';
import '../models/rag_request_model.dart';
import '../models/rag_response_model.dart';
import 'islamic_rag_service.dart';

/// TRUE RAG API Service with Islamic Knowledge Retrieval
/// Architecture: RETRIEVE Islamic content → AUGMENT prompts → GENERATE responses
class RagApiService {
  final Dio _dio;
  final NetworkInfo _networkInfo;
  final SecureStorageService _secureStorage;
  final IslamicRagService _islamicRagService;
  final Logger _logger;

  RagApiService({
    required NetworkInfo networkInfo,
    required SecureStorageService secureStorage,
    required IslamicRagService islamicRagService,
    Logger? logger,
  }) : _networkInfo = networkInfo,
       _secureStorage = secureStorage,
       _islamicRagService = islamicRagService,
       _logger = logger ?? Logger(),
       _dio = Dio() {
    _setupDio();
  }

  void _setupDio() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 15),
    );

    // Add logging interceptor
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: false, // Don't log sensitive data
        responseBody: false,
        logPrint: (obj) => _logger.d(obj.toString()),
      ),
    );

    // Add auth interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await _addAuthHeaders(options);
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            _logger.w('🔑 Authentication failed, clearing token');
            await _secureStorage.deleteValue('rag_api_token');
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<void> _addAuthHeaders(RequestOptions options) async {
    final token = await _getApiKey();
    if (token == null) {
      throw NetworkException('No API key configured');
    }

    switch (RagConfig.currentProvider) {
      case 'openai':
        options.headers['Authorization'] = 'Bearer $token';
        options.headers['Content-Type'] = 'application/json';
        options.baseUrl = RagConfig.openAiApiUrl;
        break;
      case 'claude':
        options.headers['x-api-key'] = token;
        options.headers['Content-Type'] = 'application/json';
        options.headers['anthropic-version'] = '2023-06-01';
        options.baseUrl = RagConfig.claudeApiUrl;
        break;
      case 'gemini':
        options.queryParameters['key'] = token;
        options.headers['Content-Type'] = 'application/json';
        options.baseUrl = RagConfig.geminiApiUrl;
        break;
      case 'ollama':
        options.headers['Content-Type'] = 'application/json';
        options.baseUrl = RagConfig.ollamaApiUrl;
        break;
      case 'huggingface':
        options.headers['Authorization'] = 'Bearer $token';
        options.headers['Content-Type'] = 'application/json';
        options.baseUrl = RagConfig.huggingFaceApiUrl;
        break;
    }
  }

  Future<RagResponseModel> queryRag(RagRequestModel request) async {
    try {
      if (!await _networkInfo.isConnected) {
        throw NetworkException('No internet connection');
      }

      _logger.i('🤖 Making RAG query to ${RagConfig.currentProvider}: ${request.query}');

      final startTime = DateTime.now();
      final response = await _makeProviderRequest(request);
      final endTime = DateTime.now();
      final responseTime = endTime.difference(startTime).inMilliseconds;

      final ragResponse = RagResponseModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        query: request.query,
        response: response['content'] ?? '',
        timestamp: endTime,
        responseTime: responseTime,
        sources: List<String>.from(response['sources'] ?? []),
        metadata: response['metadata'] ?? {},
      );

      _logger.i('✅ RAG query successful: ${ragResponse.id}');
      return ragResponse;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      _logger.e('❌ RAG query failed: $e');
      throw ServerException('RAG query failed: $e');
    }
  }

  Future<Map<String, dynamic>> _makeProviderRequest(RagRequestModel request) async {
    switch (RagConfig.currentProvider) {
      case 'openai':
        return await _makeOpenAiRequest(request);
      case 'claude':
        return await _makeClaudeRequest(request);
      case 'gemini':
        return await _makeGeminiRequest(request);
      case 'ollama':
        return await _makeOllamaRequest(request);
      case 'huggingface':
        return await _makeHuggingFaceRequest(request);
      default:
        throw ServerException('Unknown provider: ${RagConfig.currentProvider}');
    }
  }

  Future<Map<String, dynamic>> _makeOpenAiRequest(RagRequestModel request) async {
    _logger.i('🔍 Starting TRUE RAG process for OpenAI...');

    // STEP 1: RETRIEVE - Get Islamic knowledge from Quran/Hadith
    String retrievedContext = '';
    List<String> retrievedSources = [];
    double retrievalConfidence = 0.0;

    try {
      _logger.i('📚 Retrieving Islamic knowledge for: ${request.query}');
      final islamicResponse = await _islamicRagService.processQuery(
        query: request.query,
        language: 'en',
        includeAudio: false,
      );

      if (islamicResponse.response.isNotEmpty) {
        retrievedContext = islamicResponse.response;
        retrievedSources =
            islamicResponse.sources
                .map((source) => source.reference ?? source.title)
                .where((ref) => ref.isNotEmpty)
                .toList();
        retrievalConfidence = islamicResponse.confidence;
        _logger.i('✅ Retrieved ${retrievedSources.length} Islamic sources');
      }
    } catch (e) {
      _logger.w('⚠️ Islamic knowledge retrieval failed: $e');
      // Continue with general Islamic prompting if retrieval fails
    }

    // STEP 2: AUGMENT - Build enhanced prompt with retrieved knowledge
    final augmentedPrompt = _buildAugmentedPrompt(
      originalQuery: request.query,
      retrievedContext: retrievedContext,
      sources: retrievedSources,
    );

    _logger.i('🔗 Built augmented prompt with ${retrievedContext.isEmpty ? 'general' : 'specific'} Islamic context');

    // STEP 3: GENERATE - Send augmented prompt to OpenAI
    final response = await _dio.post(
      '/chat/completions',
      data: {
        'model': RagConfig.openAiModel,
        'messages': [
          {'role': 'system', 'content': RagConfig.islamicSystemPrompt},
          {'role': 'user', 'content': augmentedPrompt},
        ],
        'max_tokens': 1200,
        'temperature': 0.7,
      },
    );

    final content = response.data['choices'][0]['message']['content'];

    // Enhanced response with TRUE RAG metadata
    final ragSources = ['OpenAI GPT-4 (RAG Enhanced)'];
    if (retrievedSources.isNotEmpty) {
      ragSources.addAll(retrievedSources);
    }

    return {
      'content': content,
      'confidence': retrievedContext.isNotEmpty ? 0.95 : 0.85, // Higher confidence with retrieved context
      'sources': ragSources,
      'metadata': {
        'provider': 'openai',
        'model': RagConfig.openAiModel,
        'rag_enabled': true,
        'retrieved_context_length': retrievedContext.length,
        'retrieval_confidence': retrievalConfidence,
        'sources_count': retrievedSources.length,
        'tokens_used': response.data['usage']['total_tokens'],
      },
    };
  }

  Future<Map<String, dynamic>> _makeClaudeRequest(RagRequestModel request) async {
    _logger.i('🔍 Starting TRUE RAG process for Claude...');

    // STEP 1: RETRIEVE - Get Islamic knowledge
    String retrievedContext = '';
    List<String> retrievedSources = [];
    double retrievalConfidence = 0.0;

    try {
      _logger.i('📚 Retrieving Islamic knowledge for: ${request.query}');
      final islamicResponse = await _islamicRagService.processQuery(
        query: request.query,
        language: 'en',
        includeAudio: false,
      );

      if (islamicResponse.response.isNotEmpty) {
        retrievedContext = islamicResponse.response;
        retrievedSources =
            islamicResponse.sources
                .map((source) => source.reference ?? source.title)
                .where((ref) => ref.isNotEmpty)
                .toList();
        retrievalConfidence = islamicResponse.confidence;
        _logger.i('✅ Retrieved ${retrievedSources.length} Islamic sources');
      }
    } catch (e) {
      _logger.w('⚠️ Islamic knowledge retrieval failed: $e');
    }

    // STEP 2: AUGMENT - Build enhanced prompt
    final augmentedPrompt = _buildAugmentedPrompt(
      originalQuery: request.query,
      retrievedContext: retrievedContext,
      sources: retrievedSources,
    );

    _logger.i('🔗 Built augmented prompt for Claude');

    // STEP 3: GENERATE - Send to Claude
    final response = await _dio.post(
      '/messages',
      data: {
        'model': RagConfig.claudeModel,
        'system': RagConfig.islamicSystemPrompt,
        'messages': [
          {'role': 'user', 'content': augmentedPrompt},
        ],
        'max_tokens': 1200,
      },
    );

    final content = response.data['content'][0]['text'];

    // Enhanced response with TRUE RAG metadata
    final ragSources = ['Anthropic Claude (RAG Enhanced)'];
    if (retrievedSources.isNotEmpty) {
      ragSources.addAll(retrievedSources);
    }

    return {
      'content': content,
      'confidence': retrievedContext.isNotEmpty ? 0.95 : 0.85,
      'sources': ragSources,
      'metadata': {
        'provider': 'claude',
        'model': RagConfig.claudeModel,
        'rag_enabled': true,
        'retrieved_context_length': retrievedContext.length,
        'retrieval_confidence': retrievalConfidence,
        'sources_count': retrievedSources.length,
        'tokens_used': response.data['usage']['output_tokens'],
      },
    };
  }

  Future<Map<String, dynamic>> _makeGeminiRequest(RagRequestModel request) async {
    _logger.i('🔍 Starting TRUE RAG process for Gemini...');

    // STEP 1: RETRIEVE - Get Islamic knowledge
    String retrievedContext = '';
    List<String> retrievedSources = [];
    double retrievalConfidence = 0.0;

    try {
      _logger.i('📚 Retrieving Islamic knowledge for: ${request.query}');
      final islamicResponse = await _islamicRagService.processQuery(
        query: request.query,
        language: 'en',
        includeAudio: false,
      );

      if (islamicResponse.response.isNotEmpty) {
        retrievedContext = islamicResponse.response;
        retrievedSources =
            islamicResponse.sources
                .map((source) => source.reference ?? source.title)
                .where((ref) => ref.isNotEmpty)
                .toList();
        retrievalConfidence = islamicResponse.confidence;
        _logger.i('✅ Retrieved ${retrievedSources.length} Islamic sources');
      }
    } catch (e) {
      _logger.w('⚠️ Islamic knowledge retrieval failed: $e');
    }

    // STEP 2: AUGMENT - Build enhanced prompt
    final augmentedPrompt = _buildAugmentedPrompt(
      originalQuery: request.query,
      retrievedContext: retrievedContext,
      sources: retrievedSources,
    );

    _logger.i('🔗 Built augmented prompt for Gemini');

    // STEP 3: GENERATE - Send to Gemini
    final response = await _dio.post(
      '/models/${RagConfig.geminiModel}:generateContent',
      data: {
        'contents': [
          {
            'parts': [
              {'text': augmentedPrompt},
            ],
          },
        ],
      },
    );

    final content = response.data['candidates'][0]['content']['parts'][0]['text'];

    // Enhanced response with TRUE RAG metadata
    final ragSources = ['Google Gemini (RAG Enhanced)'];
    if (retrievedSources.isNotEmpty) {
      ragSources.addAll(retrievedSources);
    }

    return {
      'content': content,
      'confidence': retrievedContext.isNotEmpty ? 0.95 : 0.85,
      'sources': ragSources,
      'metadata': {
        'provider': 'gemini',
        'model': RagConfig.geminiModel,
        'rag_enabled': true,
        'retrieved_context_length': retrievedContext.length,
        'retrieval_confidence': retrievalConfidence,
        'sources_count': retrievedSources.length,
      },
    };
  }

  Future<Map<String, dynamic>> _makeOllamaRequest(RagRequestModel request) async {
    final response = await _dio.post(
      '/generate',
      data: {
        'model': RagConfig.ollamaModel,
        'prompt': '${RagConfig.islamicSystemPrompt}\n\nUser Query: ${request.query}',
        'stream': false,
      },
    );

    return {
      'content': response.data['response'],
      'confidence': 0.8,
      'sources': ['Ollama Local'],
      'metadata': {'provider': 'ollama', 'model': RagConfig.ollamaModel},
    };
  }

  Future<Map<String, dynamic>> _makeHuggingFaceRequest(RagRequestModel request) async {
    final response = await _dio.post(
      '/${RagConfig.huggingFaceModel}',
      data: {
        'inputs': '${RagConfig.islamicSystemPrompt}\n\nUser Query: ${request.query}',
        'parameters': {'max_length': 1000, 'temperature': 0.7},
      },
    );

    return {
      'content': response.data[0]['generated_text'],
      'confidence': 0.75,
      'sources': ['Hugging Face'],
      'metadata': {'provider': 'huggingface', 'model': RagConfig.huggingFaceModel},
    };
  }

  Future<String?> _getApiKey() async {
    try {
      return await _secureStorage.getValue('${RagConfig.currentProvider}_api_key');
    } catch (e) {
      _logger.e('🔐 Failed to get API key: $e');
      return null;
    }
  }

  Future<void> setApiKey(String key) async {
    try {
      await _secureStorage.saveValue('${RagConfig.currentProvider}_api_key', key);
      _logger.d('🔐 API key saved for ${RagConfig.currentProvider}');
    } catch (e) {
      _logger.e('🔐 Failed to save API key: $e');
    }
  }

  ServerException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ServerException('Connection timeout');
      case DioExceptionType.receiveTimeout:
        return ServerException('Receive timeout');
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        final message = e.response?.data?['error']?['message'] ?? 'Server error';
        return ServerException('Server error ($status): $message');
      case DioExceptionType.cancel:
        return ServerException('Request cancelled');
      case DioExceptionType.unknown:
        return ServerException('Network error: ${e.message}');
      default:
        return ServerException('Unknown error: ${e.message}');
    }
  }

  /// Build augmented prompt with retrieved Islamic context
  /// This is the core of the RAG system - combining user query with retrieved knowledge
  String _buildAugmentedPrompt({
    required String originalQuery,
    required String retrievedContext,
    required List<String> sources,
  }) {
    if (retrievedContext.isEmpty) {
      // Fallback to original query if no context retrieved
      return originalQuery;
    }

    // TRUE RAG: Augment user query with retrieved Islamic knowledge
    return '''
User Query: "$originalQuery"

Retrieved Islamic Knowledge:
$retrievedContext

Sources: ${sources.join(', ')}

Instructions:
1. Use the retrieved Islamic knowledge above to provide a comprehensive answer
2. Reference specific Quranic verses or Hadith mentioned in the retrieved content
3. If the retrieved content doesn't fully answer the question, supplement with your Islamic knowledge
4. Always maintain authenticity and cite sources properly
5. Provide practical guidance along with the spiritual context

Please provide a detailed Islamic response based on the retrieved knowledge and the user's question.''';
  }

  void dispose() {
    _dio.close();
  }
}
