import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logger/logger.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';  // Using mock implementation

import '../models/rag_request_model.dart';
import '../models/rag_response_model.dart';
import '../../core/exceptions/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../core/storage/secure_storage_service.dart'; // Using mock implementation

/// RagApiService class implementation
class RagApiService {
  static const String _baseUrl = 'https://api.example.com/v1';
  static const String _wsUrl = 'wss://api.example.com/v1/ws';
  static const Duration _timeout = Duration(seconds: 30);
  static const Duration _connectTimeout = Duration(seconds: 15);
  static const Duration _receiveTimeout = Duration(seconds: 30);

  final Dio _dio;
  final NetworkInfo _networkInfo;
  final SecureStorageService
      _secureStorage; // Changed to use our mock implementation
  final Logger _logger;
  final Connectivity _connectivity;

  WebSocketChannel? _wsChannel;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  Timer? _heartbeatTimer;

  // Cache for responses
  final Map<String, RagResponseModel> _responseCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(minutes: 10);

  RagApiService({
    required NetworkInfo networkInfo,
    required SecureStorageService
        secureStorage, // Changed to use our mock implementation
    Logger? logger,
  })  : _networkInfo = networkInfo,
        _secureStorage = secureStorage,
        _logger = logger ?? Logger(),
        _connectivity = Connectivity(),
        _dio = Dio() {
    _setupDio();
    _setupConnectivityMonitoring();
  }

  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _timeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add authentication interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          _logger.d('ðŸ“¤ Request: ${options.method} ${options.path}');
          _logger.d('ðŸ“¤ Headers: ${options.headers}');
          _logger.d('ðŸ“¤ Data: ${options.data}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d(
            'ðŸ“¥ Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          _logger.d('ðŸ“¥ Data: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.e('âŒ Error: ${error.message}');
          _logger.e('âŒ Response: ${error.response?.data}');
          handler.next(error);
        },
      ),
    );

    // Simple retry logic without dio_retry dependency
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (_shouldRetry(error)) {
            _logger.w('ðŸ”„ Retrying request after error: ${error.message}');
            try {
              await Future.delayed(Duration(seconds: 1));
              final response = await _dio.fetch(error.requestOptions);
              handler.resolve(response);
              return;
            } catch (retryError) {
              _logger.e('ðŸ”„ Retry failed: $retryError');
            }
          }
          handler.next(error);
        },
      ),
    );

    // Add caching interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Check cache for GET requests
          if (options.method == 'GET') {
            final cacheKey = _generateCacheKey(options);
            final cachedResponse = _getCachedResponse(cacheKey);
            if (cachedResponse != null) {
              _logger.d('ðŸ’¾ Cache hit for: ${options.path}');
              handler.resolve(
                Response(
                  requestOptions: options,
                  data: cachedResponse.toJson(),
                  statusCode: 200,
                ),
              );
              return;
            }
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          // Cache successful responses
          if (response.statusCode == 200 &&
              response.requestOptions.method == 'GET') {
            final cacheKey = _generateCacheKey(response.requestOptions);
            try {
              final ragResponse = RagResponseModel.fromJson(response.data);
              _cacheResponse(cacheKey, ragResponse);
              _logger.d(
                'ðŸ’¾ Cached response for: ${response.requestOptions.path}',
              );
            } catch (e) {
              _logger.w('ðŸ’¾ Failed to cache response: $e');
            }
          }
          handler.next(response);
        },
      ),
    );
  }

  bool _shouldRetry(DioException error) {
    // Retry on network errors
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return true;
    }

    // Retry on server errors (5xx) or rate limiting (429)
    if (error.response?.statusCode != null) {
      final statusCode = error.response!.statusCode!;
      return (statusCode >= 500 && statusCode < 600) || statusCode == 429;
    }

    return false;
  }

  void _setupConnectivityMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      ConnectivityResult result,
    ) {
      _logger.i('ðŸ“¶ Connectivity changed: $result');
      if (result == ConnectivityResult.none) {
        _onConnectionLost();
      } else {
        _onConnectionRestored();
      }
    });
  }

  void _onConnectionLost() {
    _logger.w('ðŸ“¶ Connection lost - closing WebSocket');
    _closeWebSocket();
  }

  void _onConnectionRestored() {
    _logger.i('ðŸ“¶ Connection restored');
    // Optionally reconnect WebSocket if it was previously connected
  }

  Future<String?> _getAuthToken() async {
    try {
      // return await _secureStorage.read(key: 'rag_api_token');  // Original FlutterSecureStorage API
      return await _secureStorage.getValue(
        'rag_api_token',
      ); // Our SecureStorageService API
    } catch (e) {
      _logger.e('ðŸ” Failed to get auth token: $e');
      return null;
    }
  }

  Future<void> setAuthToken(String token) async {
    try {
      // await _secureStorage.write(key: 'rag_api_token', value: token);  // Original FlutterSecureStorage API
      await _secureStorage.saveValue(
        'rag_api_token',
        token,
      ); // Our SecureStorageService API
      _logger.d('ðŸ” Auth token saved');
    } catch (e) {
      _logger.e('ðŸ” Failed to save auth token: $e');
    }
  }

  String _generateCacheKey(RequestOptions options) {
    final uri = options.uri.toString();
    final data = options.data?.toString() ?? '';
    return '$uri:$data'.hashCode.toString();
  }

  RagResponseModel? _getCachedResponse(String key) {
    final timestamp = _cacheTimestamps[key];
    if (timestamp == null) return null;

    if (DateTime.now().difference(timestamp) > _cacheExpiry) {
      _responseCache.remove(key);
      _cacheTimestamps.remove(key);
      return null;
    }

    return _responseCache[key];
  }

  void _cacheResponse(String key, RagResponseModel response) {
    _responseCache[key] = response;
    _cacheTimestamps[key] = DateTime.now();

    // Clean old cache entries
    _cleanExpiredCache();
  }

  void _cleanExpiredCache() {
    final now = DateTime.now();
    final expiredKeys = <String>[];

    for (final entry in _cacheTimestamps.entries) {
      if (now.difference(entry.value) > _cacheExpiry) {
        expiredKeys.add(entry.key);
      }
    }

    for (final key in expiredKeys) {
      _responseCache.remove(key);
      _cacheTimestamps.remove(key);
    }
  }

  Future<RagResponseModel> queryRag(RagRequestModel request) async {
    try {
      if (!await _networkInfo.isConnected) {
        throw NetworkException('No internet connection');
      }

      _logger.i('ðŸ¤– Making RAG query: ${request.query}');

      final response = await _dio.post('/rag/query', data: request.toJson());

      if (response.statusCode == 200) {
        final ragResponse = RagResponseModel.fromJson(response.data);
        _logger.i('âœ… RAG query successful: ${ragResponse.id}');
        return ragResponse;
      } else {
        throw ServerException('Failed to query RAG: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _logger.e('âŒ RAG query failed: ${e.message}');
      throw _handleDioException(e);
    } catch (e) {
      _logger.e('âŒ Unexpected error during RAG query: $e');
      throw ServerException('Unexpected error: $e');
    }
  }

  Future<List<RagResponseModel>> getQueryHistory({
    int? limit,
    String? sessionId,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        throw NetworkException('No internet connection');
      }

      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (sessionId != null) queryParams['session_id'] = sessionId;

      final response = await _dio.get(
        '/rag/history',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['history'] ?? [];
        return data.map((json) => RagResponseModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to get history: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // WebSocket functionality for real-time updates
  Future<void> connectWebSocket({String? sessionId}) async {
    try {
      _closeWebSocket();

      final token = await _getAuthToken();
      final uri = Uri.parse(_wsUrl).replace(
        queryParameters: {
          if (token != null) 'token': token,
          if (sessionId != null) 'session_id': sessionId,
        },
      );

      _logger.i('ðŸ”Œ Connecting to WebSocket: $uri');
      _wsChannel = WebSocketChannel.connect(uri);

      // Start heartbeat
      _startHeartbeat();

      _logger.i('âœ… WebSocket connected');
    } catch (e) {
      _logger.e('âŒ Failed to connect WebSocket: $e');
      throw NetworkException('Failed to connect to real-time updates: $e');
    }
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (_wsChannel != null) {
        try {
          _wsChannel!.sink.add(json.encode({'type': 'ping'}));
        } catch (e) {
          _logger.w('ðŸ’“ Heartbeat failed: $e');
          timer.cancel();
        }
      }
    });
  }

  Stream<RagResponseModel>? get realTimeUpdates {
    if (_wsChannel == null) return null;

    return _wsChannel!.stream.map((data) {
      try {
        final Map<String, dynamic> json = jsonDecode(data);
        if (json['type'] == 'rag_response') {
          return RagResponseModel.fromJson(json['data']);
        }
        throw FormatException('Invalid message type: ${json['type']}');
      } catch (e) {
        _logger.e('âŒ Failed to parse WebSocket message: $e');
        rethrow;
      }
    }).handleError((error) {
      _logger.e('âŒ WebSocket stream error: $error');
    });
  }

  void _closeWebSocket() {
    _heartbeatTimer?.cancel();
    _wsChannel?.sink.close();
    _wsChannel = null;
    _logger.d('ðŸ”Œ WebSocket closed');
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerException('Request timeout - please try again');

      case DioExceptionType.connectionError:
        return NetworkException('Connection error - check your internet');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
          case 400:
            return ServerException('Invalid request format');
          case 401:
            return ServerException('Authentication failed');
          case 403:
            return ServerException('Access forbidden');
          case 404:
            return ServerException('RAG service not found');
          case 429:
            return ServerException('Rate limit exceeded - please wait');
          case 500:
            return ServerException('Internal server error');
          case 502:
          case 503:
          case 504:
            return ServerException('RAG service temporarily unavailable');
          default:
            return ServerException('Server error: $statusCode');
        }

      case DioExceptionType.cancel:
        return ServerException('Request was cancelled');

      default:
        return ServerException('Network error: ${e.message}');
    }
  }

  void clearCache() {
    _responseCache.clear();
    _cacheTimestamps.clear();
    _logger.d('ðŸ’¾ Cache cleared');
  }

  Future<void> dispose() async {
    _closeWebSocket();
    _connectivitySubscription?.cancel();
    _dio.close();
    clearCache();
    _logger.d('ðŸ§¹ RagApiService disposed');
  }
}
