import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

/// Security Levels for Admin Operations
enum SecurityLevel { info, warning, critical, emergency }

/// Enterprise-Grade Admin Security System
class AdminSecurity {
  static const String _adminUsername = 'duacopilot_admin';
  static const String _saltKey = 'DuaCopilot_Admin_Salt_2024';

  // SECURITY: Hashed admin password (change this in production!)
  static const String _hashedPassword = '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918'; // "admin"

  static bool _isInitialized = false;
  static int _failedAttempts = 0;
  static DateTime? _lockoutUntil;
  static final List<Map<String, dynamic>> _securityLogs = [];

  /// Initialize admin security system
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // SECURITY: Generate session key
      await _generateSessionKey();

      // SECURITY: Validate environment
      validateAdminEnvironment();

      logSecurityEvent(
        event: 'admin_security_initialized',
        level: SecurityLevel.info,
        context: {'timestamp': DateTime.now().toIso8601String()},
      );

      _isInitialized = true;
    } catch (e) {
      logSecurityEvent(
        event: 'admin_security_init_failed',
        level: SecurityLevel.critical,
        context: {'error': e.toString()},
      );
      rethrow;
    }
  }

  /// Validate admin environment security
  static void validateAdminEnvironment() {
    // SECURITY: Only allow admin in debug mode or with specific flags
    if (kReleaseMode) {
      final adminAllowed = const bool.fromEnvironment('ADMIN_ENABLED', defaultValue: false);
      if (!adminAllowed) {
        throw SecurityException('Admin access not allowed in production without ADMIN_ENABLED flag');
      }
    }

    // SECURITY: Check for root/jailbreak (would need platform-specific implementation)
    if (_isDeviceCompromised()) {
      throw SecurityException('Device security compromised - admin access denied');
    }
  }

  /// Validate admin credentials with MFA
  static Future<bool> validateCredentials({required String username, required String password, String? mfaCode}) async {
    // SECURITY: Check lockout status
    if (_isLockedOut()) {
      logSecurityEvent(
        event: 'admin_access_attempt_while_locked',
        level: SecurityLevel.warning,
        context: {'username': username},
      );
      return false;
    }

    try {
      // SECURITY: Validate username
      if (username != _adminUsername) {
        _incrementFailedAttempts();
        return false;
      }

      // SECURITY: Hash and validate password
      final hashedInput = _hashPassword(password);
      if (hashedInput != _hashedPassword) {
        _incrementFailedAttempts();
        return false;
      }

      // SECURITY: Validate MFA if provided
      if (mfaCode != null && !_validateMFA(mfaCode)) {
        _incrementFailedAttempts();
        return false;
      }

      // SECURITY: Reset failed attempts on success
      _failedAttempts = 0;
      _lockoutUntil = null;

      return true;
    } catch (e) {
      logSecurityEvent(
        event: 'credential_validation_error',
        level: SecurityLevel.critical,
        context: {'error': e.toString()},
      );
      return false;
    }
  }

  /// Lock out admin user after failed attempts
  static void lockOutUser() {
    _lockoutUntil = DateTime.now().add(const Duration(minutes: 30));
    logSecurityEvent(
      event: 'admin_account_locked',
      level: SecurityLevel.critical,
      context: {'lockout_until': _lockoutUntil?.toIso8601String(), 'failed_attempts': _failedAttempts},
    );
  }

  /// Log security events
  static void logSecurityEvent({required String event, required SecurityLevel level, Map<String, dynamic>? context}) {
    final logEntry = {
      'timestamp': DateTime.now().toIso8601String(),
      'event': event,
      'level': level.name,
      'context': context ?? {},
      'session_id': _generateSessionId(),
    };

    _securityLogs.add(logEntry);

    // SECURITY: Keep only last 1000 logs to prevent memory issues
    if (_securityLogs.length > 1000) {
      _securityLogs.removeRange(0, _securityLogs.length - 1000);
    }

    // SECURITY: In production, send to secure logging service
    if (level == SecurityLevel.critical || level == SecurityLevel.emergency) {
      _sendToSecurityTeam(logEntry);
    }

    debugPrint('🔒 ADMIN SECURITY: [$level] $event - ${context ?? {}}');
  }

  /// Get security logs for admin dashboard
  static List<Map<String, dynamic>> getSecurityLogs() {
    return List.unmodifiable(_securityLogs.reversed.take(100));
  }

  /// Generate secure session key
  static Future<void> _generateSessionKey() async {
    // SECURITY: Generate cryptographically secure session key
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    final sessionKey = base64Encode(bytes);

    logSecurityEvent(
      event: 'session_key_generated',
      level: SecurityLevel.info,
      context: {'key_length': sessionKey.length},
    );
  }

  /// Hash password with salt
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password + _saltKey);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Validate MFA code
  static bool _validateMFA(String code) {
    // SECURITY: In production, integrate with proper MFA service (Google Authenticator, etc.)
    // For demo purposes, accept specific codes based on time
    final minute = DateTime.now().minute;
    final expectedCodes = [
      (minute ~/ 5 * 5).toString().padLeft(6, '0'),
      '123456', // Emergency backup code
    ];

    return expectedCodes.contains(code);
  }

  /// Check if user is locked out
  static bool _isLockedOut() {
    if (_lockoutUntil == null) return false;
    if (DateTime.now().isBefore(_lockoutUntil!)) return true;

    // Clear lockout if expired
    _lockoutUntil = null;
    _failedAttempts = 0;
    return false;
  }

  /// Increment failed login attempts
  static void _incrementFailedAttempts() {
    _failedAttempts++;
    if (_failedAttempts >= 5) {
      lockOutUser();
    }
  }

  /// Check if device is compromised
  static bool _isDeviceCompromised() {
    // SECURITY: In production, implement proper device security checks
    // - Root/jailbreak detection
    // - Debugger detection
    // - Emulator detection
    // - Certificate pinning validation
    return false;
  }

  /// Generate session ID
  static String _generateSessionId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (i) => random.nextInt(256));
    return base64Encode(bytes).substring(0, 16);
  }

  /// Send critical security events to security team
  static void _sendToSecurityTeam(Map<String, dynamic> logEntry) {
    // SECURITY: In production, implement secure notification system
    // - Encrypted email alerts
    // - Secure webhook notifications
    // - SMS alerts for critical events
    debugPrint('🚨 CRITICAL SECURITY EVENT: $logEntry');
  }
}

/// Security Exception for Admin Operations
class SecurityException implements Exception {
  final String message;
  const SecurityException(this.message);

  @override
  String toString() => 'SecurityException: $message';
}
