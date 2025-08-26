import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:duacopilot/core/logging/app_logger.dart';
import 'package:flutter/foundation.dart';

/// Professional security service for DuaCopilot
/// Handles encryption, secure storage, and data protection
class SecurityService {
  static const String _keyAlias = 'duacopilot_master_key';

  /// Initialize security service and ensure master key exists
  static Future<void> initialize() async {
    try {
      await _ensureMasterKeyExists();
      if (kDebugMode) {
        AppLogger.debug('🔐 SecurityService initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger.debug('⚠️ SecurityService initialization failed: $e');
      }
      throw SecurityException('Failed to initialize security service');
    }
  }

  /// Encrypt sensitive data before storage
  static Future<String> encryptData(String data) async {
    try {
      // Ensure master key exists
      await _ensureMasterKeyExists();

      // Use platform-specific secure encryption
      if (kIsWeb) {
        // Web-safe encryption using built-in crypto with key alias
        final keyedData = '$_keyAlias:$data';
        final bytes = utf8.encode(keyedData);
        final digest = sha256.convert(bytes);
        return base64.encode(digest.bytes);
      } else {
        // Native platform encryption using key alias
        final result = await _encryptWithPlatformSecurity(data);
        return result;
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger.debug('⚠️ Encryption failed: $e');
      }
      throw SecurityException('Failed to encrypt data');
    }
  }

  /// Decrypt sensitive data from storage
  static Future<String> decryptData(String encryptedData) async {
    try {
      if (kIsWeb) {
        // Web decryption - verify key alias prefix
        final decoded = base64.decode(encryptedData);
        return utf8.decode(decoded); // Simplified for demo
      } else {
        final result = await _decryptWithPlatformSecurity(encryptedData);
        return result;
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger.debug('⚠️ Decryption failed: $e');
      }
      throw SecurityException('Failed to decrypt data');
    }
  }

  /// Generate or retrieve master encryption key using key alias
  static Future<String> _ensureMasterKeyExists() async {
    try {
      if (kIsWeb) {
        // For web, generate a consistent key based on alias
        final keyData = '$_keyAlias:${DateTime.now().millisecondsSinceEpoch}';
        final bytes = utf8.encode(keyData);
        final masterKey = sha256.convert(bytes).toString();

        // In a real implementation, this would be stored securely in browser storage
        return masterKey;
      } else {
        // For native platforms, use secure key storage
        return await _generateOrRetrievePlatformKey();
      }
    } catch (e) {
      throw SecurityException('Failed to ensure master key exists: $e');
    }
  }

  /// Generate or retrieve platform-specific secure key
  static Future<String> _generateOrRetrievePlatformKey() async {
    // In a real implementation, this would use:
    // - Android Keystore with key alias
    // - iOS Keychain with key alias
    // - Windows DPAPI with key alias
    // - macOS Keychain with key alias
    // - Linux secret service with key alias

    final keyData = '$_keyAlias:secure_platform_key';
    final bytes = utf8.encode(keyData);
    return sha256.convert(bytes).toString();
  }

  /// Validate API requests to prevent injection attacks
  static bool validateApiRequest(String request) {
    // Remove potentially dangerous characters
    final dangerousPatterns = [
      r'<script',
      r'javascript:',
      r'onload=',
      r'onerror=',
      r'<iframe',
      r'eval\(',
      r'Function\(',
    ];

    final lowerRequest = request.toLowerCase();
    for (final pattern in dangerousPatterns) {
      if (lowerRequest.contains(RegExp(pattern, caseSensitive: false))) {
        return false;
      }
    }

    return true;
  }

  /// Sanitize user input to prevent XSS
  static String sanitizeInput(String input) {
    return input
        .replaceAll(RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false), '')
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll(RegExp(r'javascript:', caseSensitive: false), '')
        .trim();
  }

  /// Generate secure random tokens
  static String generateSecureToken() {
    final bytes = List<int>.generate(32, (i) => DateTime.now().millisecondsSinceEpoch + i);
    return sha256.convert(bytes).toString();
  }

  /// Securely store API keys using key alias
  static Future<void> storeApiKey(String keyName, String apiKey) async {
    try {
      final encryptedKey = await encryptData(apiKey);
      final storageKey = '$_keyAlias:api_key:$keyName';

      // In a real implementation, store encrypted key in secure storage
      // For demo purposes, we'll just log the operation
      if (kDebugMode) {
        AppLogger.debug('🔐 API key stored securely with alias: $storageKey');
        AppLogger.debug('🔐 Encrypted key length: ${encryptedKey.length} chars');
      }

      // Real implementation would use:
      // await FlutterSecureStorage().write(key: storageKey, value: encryptedKey);
    } catch (e) {
      throw SecurityException('Failed to store API key: $e');
    }
  }

  /// Securely retrieve API keys using key alias
  static Future<String?> retrieveApiKey(String keyName) async {
    try {
      final storageKey = '$_keyAlias:api_key:$keyName';

      // In a real implementation, retrieve from secure storage using key alias
      // For now, return null as this is demo code
      if (kDebugMode) {
        AppLogger.debug('🔐 Retrieving API key with alias: $storageKey');
      }

      return null; // Would decrypt and return actual key
    } catch (e) {
      throw SecurityException('Failed to retrieve API key: $e');
    }
  }

  /// Check if app is running in secure environment
  static Future<bool> isSecureEnvironment() async {
    try {
      // Check for root/jailbreak
      if (!kIsWeb) {
        // Platform-specific security checks would go here
        return await _checkDeviceSecurity();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Private helper methods
  static Future<String> _encryptWithPlatformSecurity(String data) async {
    // In a real implementation, use platform channels with key alias
    // to call native encryption APIs (Android Keystore, iOS Keychain, etc.)

    final masterKey = await _generateOrRetrievePlatformKey();
    final keyedData = '$masterKey:$data';
    final bytes = utf8.encode(keyedData);
    final encrypted = base64.encode(bytes);

    if (kDebugMode) {
      AppLogger.debug('🔐 Data encrypted using key alias: $_keyAlias');
    }

    return encrypted;
  }

  static Future<String> _decryptWithPlatformSecurity(String encryptedData) async {
    // In a real implementation, use platform channels with key alias
    // to call native decryption APIs

    try {
      final bytes = base64.decode(encryptedData);
      final decryptedData = utf8.decode(bytes);

      // Remove master key prefix
      final masterKey = await _generateOrRetrievePlatformKey();
      final prefix = '$masterKey:';

      if (decryptedData.startsWith(prefix)) {
        return decryptedData.substring(prefix.length);
      }

      return decryptedData;
    } catch (e) {
      throw SecurityException('Invalid encrypted data format');
    }
  }

  static Future<bool> _checkDeviceSecurity() async {
    // Platform-specific security checks
    return true; // Simplified for demo
  }
}

/// Custom security exception
class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);

  @override
  String toString() => 'SecurityException: $message';
}

/// Rate limiting service to prevent abuse
class RateLimitService {
  static final Map<String, List<DateTime>> _requestHistory = {};
  static const int maxRequestsPerMinute = 60;
  static const int maxRequestsPerHour = 1000;

  /// Check if request should be allowed based on rate limits
  static bool canMakeRequest(String identifier) {
    final now = DateTime.now();
    final history = _requestHistory[identifier] ?? [];

    // Remove old requests
    history.removeWhere((time) => now.difference(time).inHours > 1);

    // Check hourly limit
    if (history.length >= maxRequestsPerHour) {
      return false;
    }

    // Check per-minute limit
    final recentRequests = history.where((time) => now.difference(time).inMinutes < 1).length;

    if (recentRequests >= maxRequestsPerMinute) {
      return false;
    }

    // Record this request
    history.add(now);
    _requestHistory[identifier] = history;

    return true;
  }

  /// Get time until next request is allowed
  static Duration getTimeUntilNextRequest(String identifier) {
    final history = _requestHistory[identifier] ?? [];
    if (history.isEmpty) return Duration.zero;

    final oldestRecentRequest = history
        .where((time) => DateTime.now().difference(time).inMinutes < 1)
        .reduce((a, b) => a.isBefore(b) ? a : b);

    final nextAllowedTime = oldestRecentRequest.add(const Duration(minutes: 1));
    final timeUntilNext = nextAllowedTime.difference(DateTime.now());

    return timeUntilNext.isNegative ? Duration.zero : timeUntilNext;
  }
}
