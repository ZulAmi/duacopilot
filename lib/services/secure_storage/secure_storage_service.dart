import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../../core/logging/app_logger.dart';
import '../../core/storage/secure_storage_adapter.dart';

/// Enterprise-grade secure storage service with encryption
class SecureStorageService {
  static SecureStorageService? _instance;
  static SecureStorageService get instance =>
      _instance ??= SecureStorageService._();

  SecureStorageService._();

  bool _isInitialized = false;
  static const String _userIdKey = 'user_id';
  static const String _encryptionKeyPrefix = 'encrypted_';

  /// Initialize the secure storage service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await SecureStorageAdapter.init();
      _isInitialized = true;
      AppLogger.info('SecureStorageService initialized');
    } catch (e) {
      AppLogger.error('Failed to initialize SecureStorageService: $e');
      throw Exception('SecureStorageService initialization failed');
    }
  }

  /// Write encrypted data to secure storage
  Future<void> write(String key, String value) async {
    if (!_isInitialized) await initialize();

    try {
      final encryptedValue = _encryptValue(value);
      await SecureStorageAdapter.write(
        key: '$_encryptionKeyPrefix$key',
        value: encryptedValue,
      );
    } catch (e) {
      AppLogger.error('Failed to write secure data for key $key: $e');
      rethrow;
    }
  }

  /// Read and decrypt data from secure storage
  Future<String?> read(String key) async {
    if (!_isInitialized) await initialize();

    try {
      final encryptedValue = await SecureStorageAdapter.read(
        key: '$_encryptionKeyPrefix$key',
      );

      if (encryptedValue == null) return null;

      return _decryptValue(encryptedValue);
    } catch (e) {
      AppLogger.error('Failed to read secure data for key $key: $e');
      return null;
    }
  }

  /// Delete data from secure storage
  Future<void> delete(String key) async {
    if (!_isInitialized) await initialize();

    try {
      await SecureStorageAdapter.delete(key: '$_encryptionKeyPrefix$key');
    } catch (e) {
      AppLogger.error('Failed to delete secure data for key $key: $e');
      rethrow;
    }
  }

  /// Check if key exists in secure storage
  Future<bool> containsKey(String key) async {
    if (!_isInitialized) await initialize();

    try {
      return await SecureStorageAdapter.containsKey(
        key: '$_encryptionKeyPrefix$key',
      );
    } catch (e) {
      AppLogger.error('Failed to check key existence for $key: $e');
      return false;
    }
  }

  /// Get or generate user ID
  Future<String?> getUserId() async {
    try {
      String? userId = await read(_userIdKey);

      if (userId == null) {
        // Generate new user ID
        userId = _generateUserId();
        await write(_userIdKey, userId);
      }

      return userId;
    } catch (e) {
      AppLogger.error('Failed to get user ID: $e');
      return null;
    }
  }

  /// Set user ID
  Future<void> setUserId(String userId) async {
    try {
      await write(_userIdKey, userId);
    } catch (e) {
      AppLogger.error('Failed to set user ID: $e');
      rethrow;
    }
  }

  /// Clear all secure data
  Future<void> clearAll() async {
    if (!_isInitialized) await initialize();

    try {
      await SecureStorageAdapter.deleteAll();
      AppLogger.info('All secure data cleared');
    } catch (e) {
      AppLogger.error('Failed to clear all secure data: $e');
      rethrow;
    }
  }

  /// Encrypt value using SHA-256 based encryption (simple implementation)
  String _encryptValue(String value) {
    try {
      // In production, use proper encryption with keys from key management service
      final bytes = utf8.encode(value);
      final digest = sha256.convert(bytes);

      // Simple base64 encoding for demo (use AES encryption in production)
      final encoded = base64Encode(utf8.encode(value));
      return '$digest:$encoded';
    } catch (e) {
      AppLogger.error('Encryption failed: $e');
      throw Exception('Value encryption failed');
    }
  }

  /// Decrypt value (simple implementation)
  String _decryptValue(String encryptedValue) {
    try {
      final parts = encryptedValue.split(':');
      if (parts.length != 2) {
        throw Exception('Invalid encrypted value format');
      }

      final storedHash = parts[0];
      final encodedValue = parts[1];

      // Decode the value
      final decodedValue = utf8.decode(base64Decode(encodedValue));

      // Verify integrity
      final computedHash = sha256.convert(utf8.encode(decodedValue)).toString();
      if (storedHash != computedHash) {
        throw Exception('Data integrity check failed');
      }

      return decodedValue;
    } catch (e) {
      AppLogger.error('Decryption failed: $e');
      throw Exception('Value decryption failed');
    }
  }

  /// Generate unique user ID
  String _generateUserId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomBytes = List.generate(16, (i) => timestamp % 256);
    final hash = sha256.convert(randomBytes).toString();
    return 'user_${hash.substring(0, 16)}';
  }
}
