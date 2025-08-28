// AWS Services Abstraction Layer
// Replaces Firebase services with AWS equivalents

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/logging/app_logger.dart';

/// AWS Authentication Service (replaces Firebase Auth)
class AWSAuthService {
  static const String _baseUrl = 'https://your-api-gateway-url.amazonaws.com';
  static const String _tokenKey = 'aws_jwt_token';

  // Development mode flag - true when using placeholder URLs
  static bool get _isDevelopmentMode => _baseUrl.contains('your-api-gateway-url');

  /// Sign in with email and password (replaces FirebaseAuth.signInWithEmailAndPassword)
  static Future<AWSUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // In development mode, return mock user without network call
    if (_isDevelopmentMode) {
      AppLogger.debug('AWS Auth: Development mode - returning mock user');
      return AWSUser(
        uid: 'dev_user_123',
        email: email,
        displayName: 'Development User',
      );
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        final user = AWSUser.fromJson(data['user']);

        // Store JWT token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);

        return user;
      }
      return null;
    } catch (e) {
      AppLogger.error('AWS Auth Sign In Error: $e');
      return null;
    }
  }

  /// Create user with email and password (replaces FirebaseAuth.createUserWithEmailAndPassword)
  static Future<AWSUser?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // In development mode, return mock user without network call
    if (_isDevelopmentMode) {
      AppLogger.debug('AWS Auth: Development mode - returning mock user');
      return AWSUser(
        uid: 'dev_user_456',
        email: email,
        displayName: 'Development User',
      );
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final token = data['token'];
        final user = AWSUser.fromJson(data['user']);

        // Store JWT token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);

        return user;
      }
      return null;
    } catch (e) {
      AppLogger.error('AWS Auth Sign Up Error: $e');
      return null;
    }
  }

  /// Sign out (replaces FirebaseAuth.signOut)
  static Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
    } catch (e) {
      AppLogger.error('AWS Auth Sign Out Error: $e');
    }
  }

  /// Get current user (replaces FirebaseAuth.currentUser)
  static Future<AWSUser?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$_baseUrl/auth/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AWSUser.fromJson(data);
      }
      return null;
    } catch (e) {
      AppLogger.error('AWS Auth Get User Error: $e');
      return null;
    }
  }

  /// Get JWT token for API requests
  static Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      AppLogger.error('AWS Auth Get Token Error: $e');
      return null;
    }
  }
}

/// AWS User class (replaces Firebase User)
class AWSUser {
  final String uid;
  final String email;
  final String? displayName;
  final bool emailVerified;

  AWSUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.emailVerified = false,
  });

  factory AWSUser.fromJson(Map<String, dynamic> json) {
    return AWSUser(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'],
      emailVerified: json['emailVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'emailVerified': emailVerified,
    };
  }
}

/// AWS Storage Service (replaces Firebase Storage)
class AWSStorageService {
  static const String _baseUrl = 'https://your-api-gateway-url.amazonaws.com';

  /// Upload file to S3 (replaces Firebase Storage upload)
  static Future<String?> uploadFile({
    required String path,
    required List<int> bytes,
    required String contentType,
  }) async {
    try {
      final token = await AWSAuthService.getAuthToken();
      if (token == null) throw Exception('User not authenticated');

      final response = await http.post(
        Uri.parse('$_baseUrl/storage/upload'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'path': path,
          'contentType': contentType,
          'data': base64Encode(bytes),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['url'];
      }
      return null;
    } catch (e) {
      AppLogger.error('AWS Storage Upload Error: $e');
      return null;
    }
  }

  /// Get download URL (replaces Firebase Storage getDownloadURL)
  static Future<String?> getDownloadURL(String path) async {
    try {
      final token = await AWSAuthService.getAuthToken();
      if (token == null) throw Exception('User not authenticated');

      final response = await http.get(
        Uri.parse('$_baseUrl/storage/url?path=$path'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['url'];
      }
      return null;
    } catch (e) {
      AppLogger.error('AWS Storage Get URL Error: $e');
      return null;
    }
  }

  /// Delete file (replaces Firebase Storage delete)
  static Future<bool> deleteFile(String path) async {
    try {
      final token = await AWSAuthService.getAuthToken();
      if (token == null) throw Exception('User not authenticated');

      final response = await http.delete(
        Uri.parse('$_baseUrl/storage/delete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'path': path}),
      );

      return response.statusCode == 200;
    } catch (e) {
      AppLogger.error('AWS Storage Delete Error: $e');
      return false;
    }
  }
}

/// AWS Analytics Service (replaces Firebase Analytics)
class AWSAnalyticsService {
  static const String _baseUrl = 'https://your-api-gateway-url.amazonaws.com';

  // Development mode flag - true when using placeholder URLs
  static bool get _isDevelopmentMode => _baseUrl.contains('your-api-gateway-url');

  /// Log event (replaces FirebaseAnalytics.logEvent)
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    // In development mode, just log the event locally without network call
    if (_isDevelopmentMode) {
      AppLogger.debug('AWS Analytics (Dev): Event "$name" with parameters: $parameters');
      return;
    }

    try {
      final token = await AWSAuthService.getAuthToken();

      final response = await http.post(
        Uri.parse('$_baseUrl/analytics/event'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': name,
          'parameters': parameters ?? {},
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }),
      );

      if (response.statusCode != 200) {
        AppLogger.warning('Analytics event failed: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('AWS Analytics Error: $e');
    }
  }

  /// Set user property (replaces FirebaseAnalytics.setUserProperty)
  static Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    // In development mode, just log the property locally
    if (_isDevelopmentMode) {
      AppLogger.debug('AWS Analytics (Dev): User property "$name" = "$value"');
      return;
    }

    try {
      final token = await AWSAuthService.getAuthToken();
      if (token == null) return; // Skip if not authenticated

      final response = await http.post(
        Uri.parse('$_baseUrl/analytics/user-property'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': name,
          'value': value,
        }),
      );

      if (response.statusCode != 200) {
        AppLogger.warning('User property failed: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('AWS Analytics User Property Error: $e');
    }
  }

  /// Set user ID (replaces FirebaseAnalytics.setUserId)
  static Future<void> setUserId(String? id) async {
    await setUserProperty(name: 'user_id', value: id);
  }
}

/// AWS Remote Config Service (replaces Firebase Remote Config)
class AWSRemoteConfigService {
  static const String _baseUrl = 'https://your-api-gateway-url.amazonaws.com';
  static Map<String, dynamic> _cachedConfig = {};

  // Development mode flag - true when using placeholder URLs
  static bool get _isDevelopmentMode => _baseUrl.contains('your-api-gateway-url');

  /// Fetch and activate config (replaces RemoteConfig.fetchAndActivate)
  static Future<bool> fetchAndActivate() async {
    // In development mode, return default config
    if (_isDevelopmentMode) {
      AppLogger.debug('AWS Remote Config (Dev): Using default development config');
      _cachedConfig = {
        'feature_flags': {
          'enhanced_rag_enabled': true,
          'offline_mode_enabled': true,
          'premium_features_enabled': false,
        },
        'app_settings': {
          'max_query_length': 500,
          'cache_timeout_minutes': 60,
        }
      };
      return true;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/config'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _cachedConfig = data['config'] ?? {};

        // Cache config locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('aws_remote_config', json.encode(_cachedConfig));

        return true;
      }
      return false;
    } catch (e) {
      AppLogger.error('AWS Remote Config Error: $e');

      // Try to load cached config
      try {
        final prefs = await SharedPreferences.getInstance();
        final cached = prefs.getString('aws_remote_config');
        if (cached != null) {
          _cachedConfig = json.decode(cached);
        }
      } catch (_) {}

      return false;
    }
  }

  /// Get string value (replaces RemoteConfig.getString)
  static String getString(String key, {String defaultValue = ''}) {
    return _cachedConfig[key]?.toString() ?? defaultValue;
  }

  /// Get bool value (replaces RemoteConfig.getBool)
  static bool getBool(String key, {bool defaultValue = false}) {
    final value = _cachedConfig[key];
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return defaultValue;
  }

  /// Get int value (replaces RemoteConfig.getInt)
  static int getInt(String key, {int defaultValue = 0}) {
    final value = _cachedConfig[key];
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  /// Get double value (replaces RemoteConfig.getDouble)
  static double getDouble(String key, {double defaultValue = 0.0}) {
    final value = _cachedConfig[key];
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }
}

/// AWS Crash Reporting Service (replaces Firebase Crashlytics)
class AWSCrashReportingService {
  static const String _baseUrl = 'https://your-api-gateway-url.amazonaws.com';

  /// Record error (replaces FirebaseCrashlytics.recordError)
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    try {
      final token = await AWSAuthService.getAuthToken();

      final response = await http.post(
        Uri.parse('$_baseUrl/crash-reporting'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'exception': exception.toString(),
          'stackTrace': stackTrace?.toString(),
          'reason': reason,
          'fatal': fatal,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'platform': 'flutter',
        }),
      );

      if (response.statusCode != 200) {
        AppLogger.warning('Crash report failed: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('AWS Crash Reporting Error: $e');
    }
  }

  /// Log message (replaces FirebaseCrashlytics.log)
  static Future<void> log(String message) async {
    try {
      final token = await AWSAuthService.getAuthToken();

      final response = await http.post(
        Uri.parse('$_baseUrl/crash-reporting/log'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'message': message,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }),
      );

      if (response.statusCode != 200) {
        AppLogger.warning('Crash log failed: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('AWS Crash Log Error: $e');
    }
  }

  /// Set user identifier (replaces FirebaseCrashlytics.setUserIdentifier)
  static Future<void> setUserIdentifier(String identifier) async {
    // This could be implemented as part of the crash reporting context
    AppLogger.debug('User identifier set: $identifier');
  }
}

/// AWS Performance Monitoring (replaces Firebase Performance)
class AWSPerformanceService {
  static const String _baseUrl = 'https://your-api-gateway-url.amazonaws.com';

  /// Start trace (replaces FirebasePerformance.startTrace)
  static AWSTrace trace(String name) {
    return AWSTrace(name);
  }
}

/// AWS Performance Trace (replaces Firebase Trace)
class AWSTrace {
  final String name;
  final DateTime _startTime;
  final Map<String, String> _attributes = {};

  AWSTrace(this.name) : _startTime = DateTime.now();

  /// Put attribute (replaces Trace.putAttribute)
  void putAttribute(String key, String value) {
    _attributes[key] = value;
  }

  /// Stop trace (replaces Trace.stop)
  Future<void> stop() async {
    try {
      final duration = DateTime.now().difference(_startTime).inMilliseconds;
      final token = await AWSAuthService.getAuthToken();

      final response = await http.post(
        Uri.parse('${AWSPerformanceService._baseUrl}/performance'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': name,
          'duration': duration,
          'attributes': _attributes,
          'timestamp': _startTime.millisecondsSinceEpoch,
        }),
      );

      if (response.statusCode != 200) {
        AppLogger.warning('Performance trace failed: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('AWS Performance Trace Error: $e');
    }
  }
}

/// AWS Messaging Service (replaces Firebase Messaging)
class AWSMessagingService {
  static const String _baseUrl = 'https://your-api-gateway-url.amazonaws.com';

  /// Get FCM token (stub - would integrate with SNS device tokens)
  static Future<String?> getToken() async {
    try {
      // This would integrate with your push notification service (SNS)
      // For now, return a placeholder
      return 'aws-device-token-placeholder';
    } catch (e) {
      AppLogger.error('AWS Messaging Get Token Error: $e');
      return null;
    }
  }

  /// Subscribe to topic (replaces FirebaseMessaging.subscribeToTopic)
  static Future<void> subscribeToTopic(String topic) async {
    try {
      final token = await AWSAuthService.getAuthToken();
      final deviceToken = await getToken();

      if (token == null || deviceToken == null) return;

      final response = await http.post(
        Uri.parse('$_baseUrl/messaging/subscribe'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'topic': topic,
          'deviceToken': deviceToken,
        }),
      );

      if (response.statusCode != 200) {
        AppLogger.warning('Topic subscription failed: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('AWS Messaging Subscribe Error: $e');
    }
  }

  /// Unsubscribe from topic (replaces FirebaseMessaging.unsubscribeFromTopic)
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      final token = await AWSAuthService.getAuthToken();
      final deviceToken = await getToken();

      if (token == null || deviceToken == null) return;

      final response = await http.post(
        Uri.parse('$_baseUrl/messaging/unsubscribe'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'topic': topic,
          'deviceToken': deviceToken,
        }),
      );

      if (response.statusCode != 200) {
        AppLogger.warning('Topic unsubscription failed: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('AWS Messaging Unsubscribe Error: $e');
    }
  }
}
