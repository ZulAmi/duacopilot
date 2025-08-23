import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../error/api_exceptions.dart';
import '../../data/models/rag_response_models.dart';

/// Flutter-optimized RAG API client for DuaCopilot
class RagApiClient {
  static const String _baseUrl = 'https://api.duacopilot.com';
  static const String _apiVersion = 'v1';
  static const Duration _timeout = Duration(seconds: 30);

  final http.Client _httpClient;
  final Map<String, String> _defaultHeaders;
  String? _authToken;

  RagApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client(),
      _defaultHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'DuaCopilot-Flutter/1.0',
      };

  /// Set authentication token for API requests
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Get headers with authentication
  Map<String, String> get _headers {
    final headers = Map<String, String>.from(_defaultHeaders);
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  /// Build API endpoint URL
  String _buildUrl(String endpoint) {
    return '$_baseUrl/api/$_apiVersion$endpoint';
  }

  /// Handle HTTP response and errors
  T _handleResponse<T>(http.Response response, T Function(Map<String, dynamic>) parser) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final Map<String, dynamic> data = json.decode(response.body);
        return parser(data);
      } catch (e) {
        throw GeneralApiException('Failed to parse response: $e');
      }
    } else {
      _handleHttpError(response);
    }
  }

  /// Handle HTTP errors with detailed error information
  Never _handleHttpError(http.Response response) {
    final statusCode = response.statusCode;
    String message = 'Unknown error occurred';

    try {
      final errorData = json.decode(response.body);
      message = errorData['message'] ?? errorData['error'] ?? message;
    } catch (_) {
      // Use default message if JSON parsing fails
    }

    switch (statusCode) {
      case 400:
        throw BadRequestException(message);
      case 401:
        throw UnauthorizedException(message);
      case 403:
        throw ForbiddenException(message);
      case 404:
        throw NotFoundException(message);
      case 429:
        throw RateLimitException(message);
      case 500:
        throw ServerException(message);
      default:
        throw GeneralApiException('HTTP $statusCode: $message', statusCode: statusCode);
    }
  }

  /// POST /api/v1/search: Natural language Du'a search with context
  Future<RagSearchResponse> searchDuas({
    required String query,
    String language = 'en',
    String? location,
    Map<String, dynamic>? additionalContext,
  }) async {
    final requestBody = {
      'query': query,
      'context': {'language': language, if (location != null) 'location': location, ...?additionalContext},
    };

    try {
      final response = await _httpClient
          .post(Uri.parse(_buildUrl('/search')), headers: _headers, body: json.encode(requestBody))
          .timeout(_timeout);

      return _handleResponse(response, (data) => RagSearchResponse.fromJson(data));
    } on TimeoutException {
      throw GeneralApiException('Search request timed out');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw GeneralApiException('Search failed: $e');
    }
  }

  /// GET /api/v1/dua/{id}: Detailed Du'a with audio URL and metadata
  Future<DetailedDuaResponse> getDuaById(String duaId) async {
    try {
      final response = await _httpClient.get(Uri.parse(_buildUrl('/dua/$duaId')), headers: _headers).timeout(_timeout);

      return _handleResponse(response, (data) => DetailedDuaResponse.fromJson(data));
    } on TimeoutException {
      throw GeneralApiException('Du\'a fetch request timed out');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw GeneralApiException('Failed to fetch Du\'a: $e');
    }
  }

  /// POST /api/v1/feedback: User feedback for RAG model improvement
  Future<FeedbackResponse> submitFeedback({
    required String duaId,
    required String queryId,
    required FeedbackType feedbackType,
    double? rating,
    String? comment,
    Map<String, dynamic>? metadata,
  }) async {
    final requestBody = {
      'dua_id': duaId,
      'query_id': queryId,
      'feedback_type': feedbackType.name,
      if (rating != null) 'rating': rating,
      if (comment != null) 'comment': comment,
      if (metadata != null) 'metadata': metadata,
      'timestamp': DateTime.now().toIso8601String(),
    };

    try {
      final response = await _httpClient
          .post(Uri.parse(_buildUrl('/feedback')), headers: _headers, body: json.encode(requestBody))
          .timeout(_timeout);

      return _handleResponse(response, (data) => FeedbackResponse.fromJson(data));
    } on TimeoutException {
      throw GeneralApiException('Feedback submission timed out');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw GeneralApiException('Failed to submit feedback: $e');
    }
  }

  /// GET /api/v1/popular: Trending Du'as with pagination support
  Future<PopularDuasResponse> getPopularDuas({
    int page = 1,
    int limit = 20,
    String? category,
    String? timeframe,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (category != null) 'category': category,
      if (timeframe != null) 'timeframe': timeframe,
    };

    final uri = Uri.parse(_buildUrl('/popular')).replace(queryParameters: queryParams);

    try {
      final response = await _httpClient.get(uri, headers: _headers).timeout(_timeout);

      return _handleResponse(response, (data) => PopularDuasResponse.fromJson(data));
    } on TimeoutException {
      throw GeneralApiException('Popular Du\'as request timed out');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw GeneralApiException('Failed to fetch popular Du\'as: $e');
    }
  }

  /// POST /api/v1/personalize: User preference updates for better recommendations
  Future<PersonalizationResponse> updatePersonalization({
    List<String>? preferredCategories,
    List<String>? preferredLanguages,
    Map<String, double>? topicPreferences,
    UserDemographics? demographics,
    Map<String, dynamic>? customPreferences,
  }) async {
    final requestBody = {
      if (preferredCategories != null) 'preferred_categories': preferredCategories,
      if (preferredLanguages != null) 'preferred_languages': preferredLanguages,
      if (topicPreferences != null) 'topic_preferences': topicPreferences,
      if (demographics != null) 'demographics': demographics.toJson(),
      if (customPreferences != null) 'custom_preferences': customPreferences,
      'updated_at': DateTime.now().toIso8601String(),
    };

    try {
      final response = await _httpClient
          .post(Uri.parse(_buildUrl('/personalize')), headers: _headers, body: json.encode(requestBody))
          .timeout(_timeout);

      return _handleResponse(response, (data) => PersonalizationResponse.fromJson(data));
    } on TimeoutException {
      throw GeneralApiException('Personalization update timed out');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw GeneralApiException('Failed to update personalization: $e');
    }
  }

  /// GET /api/v1/offline-cache: Essential Du'as for offline mode with audio URLs
  Future<OfflineCacheResponse> getOfflineCache({
    String? lastSyncTimestamp,
    List<String>? categories,
    String? language,
    int? maxSize,
  }) async {
    final queryParams = <String, String>{};
    if (lastSyncTimestamp != null) queryParams['last_sync'] = lastSyncTimestamp;
    if (categories != null) queryParams['categories'] = categories.join(',');
    if (language != null) queryParams['language'] = language;
    if (maxSize != null) queryParams['max_size'] = maxSize.toString();

    final uri = Uri.parse(_buildUrl('/offline-cache')).replace(queryParameters: queryParams);

    try {
      final response = await _httpClient.get(uri, headers: _headers).timeout(_timeout);

      return _handleResponse(response, (data) => OfflineCacheResponse.fromJson(data));
    } on TimeoutException {
      throw GeneralApiException('Offline cache request timed out');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw GeneralApiException('Failed to fetch offline cache: $e');
    }
  }

  /// Health check endpoint
  Future<bool> healthCheck() async {
    try {
      final response = await _httpClient
          .get(Uri.parse(_buildUrl('/health')), headers: _headers)
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Health check failed: $e');
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    _httpClient.close();
  }
}

/// Feedback types for RAG model improvement
enum FeedbackType { helpful, notHelpful, incorrect, inappropriate, missing, excellent }

/// User demographics for personalization
class UserDemographics {
  final String? ageGroup;
  final String? gender;
  final String? region;
  final String? religiousLevel;
  final List<String>? interests;

  const UserDemographics({this.ageGroup, this.gender, this.region, this.religiousLevel, this.interests});

  Map<String, dynamic> toJson() => {
    if (ageGroup != null) 'age_group': ageGroup,
    if (gender != null) 'gender': gender,
    if (region != null) 'region': region,
    if (religiousLevel != null) 'religious_level': religiousLevel,
    if (interests != null) 'interests': interests,
  };

  factory UserDemographics.fromJson(Map<String, dynamic> json) => UserDemographics(
    ageGroup: json['age_group'],
    gender: json['gender'],
    region: json['region'],
    religiousLevel: json['religious_level'],
    interests: json['interests']?.cast<String>(),
  );
}
