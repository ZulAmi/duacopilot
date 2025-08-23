import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../config/rag_config.dart';
import '../../core/exceptions/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../core/storage/secure_storage_service.dart';
import '../models/rag_request_model.dart';
import '../models/rag_response_model.dart';

/// Production-ready RAG API Service with multiple provider support
class RagApiService {
  final Dio _dio;
  final NetworkInfo _networkInfo;
  final SecureStorageService _secureStorage;
  final Logger _logger;

  RagApiService({required NetworkInfo networkInfo, required SecureStorageService secureStorage, Logger? logger})
    : _networkInfo = networkInfo,
      _secureStorage = secureStorage,
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
    final response = await _dio.post(
      '/chat/completions',
      data: {
        'model': RagConfig.openAiModel,
        'messages': [
          {'role': 'system', 'content': RagConfig.islamicSystemPrompt},
          {'role': 'user', 'content': request.query},
        ],
        'max_tokens': 1000,
        'temperature': 0.7,
      },
    );

    final content = response.data['choices'][0]['message']['content'];
    return {
      'content': content,
      'confidence': 0.9,
      'sources': ['OpenAI GPT-4'],
      'metadata': {
        'provider': 'openai',
        'model': RagConfig.openAiModel,
        'tokens_used': response.data['usage']['total_tokens'],
      },
    };
  }

  Future<Map<String, dynamic>> _makeClaudeRequest(RagRequestModel request) async {
    final response = await _dio.post(
      '/messages',
      data: {
        'model': RagConfig.claudeModel,
        'system': RagConfig.islamicSystemPrompt,
        'messages': [
          {'role': 'user', 'content': request.query},
        ],
        'max_tokens': 1000,
      },
    );

    final content = response.data['content'][0]['text'];
    return {
      'content': content,
      'confidence': 0.9,
      'sources': ['Anthropic Claude'],
      'metadata': {
        'provider': 'claude',
        'model': RagConfig.claudeModel,
        'tokens_used': response.data['usage']['output_tokens'],
      },
    };
  }

  Future<Map<String, dynamic>> _makeGeminiRequest(RagRequestModel request) async {
    final prompt = '${RagConfig.islamicSystemPrompt}\n\nUser Query: ${request.query}';

    final response = await _dio.post(
      '/models/${RagConfig.geminiModel}:generateContent',
      data: {
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      },
    );

    final content = response.data['candidates'][0]['content']['parts'][0]['text'];
    return {
      'content': content,
      'confidence': 0.85,
      'sources': ['Google Gemini'],
      'metadata': {'provider': 'gemini', 'model': RagConfig.geminiModel},
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

  void dispose() {
    _dio.close();
  }
}
