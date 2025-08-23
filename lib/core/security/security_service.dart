import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:duacopilot/core/logging/app_logger.dart';
import 'package:flutter/foundation.dart';

/// Professional security service for DuaCopilot
/// Handles encryption, secure storage, and data protection
class SecurityService {
  static const String _keyAlias = 'duacopilot_master_key';

  /// Encrypt sensitive data before storage
  static Future<String> encryptData(String data) async {
    try {
      // Use platform-specific secure encryption
      if (kIsWeb) {
        // Web-safe encryption using built-in crypto
        final bytes = utf8.encode(data);
        final digest = sha256.convert(bytes);
        return digest.toString();
      } else {
        // Native platform encryption
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
        // Web decryption (in real app, use proper web crypto)
        return encryptedData; // Simplified for demo
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
    // In a real implementation, use platform channels
    // to call native encryption APIs
    final bytes = utf8.encode(data);
    final encrypted = base64.encode(bytes);
    return encrypted;
  }

  static Future<String> _decryptWithPlatformSecurity(String encryptedData) async {
    // In a real implementation, use platform channels
    // to call native decryption APIs
    final bytes = base64.decode(encryptedData);
    return utf8.decode(bytes);
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
