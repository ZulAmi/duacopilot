import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock FlutterSecureStorage for Windows compatibility
class FlutterSecureStorage {
  const FlutterSecureStorage();

  Future<void> write({required String key, required String value}) async {
    // This will never be called on Windows due to platform check
    throw UnsupportedError('FlutterSecureStorage not available on Windows');
  }

  Future<String?> read({required String key}) async {
    throw UnsupportedError('FlutterSecureStorage not available on Windows');
  }

  Future<void> delete({required String key}) async {
    throw UnsupportedError('FlutterSecureStorage not available on Windows');
  }

  Future<void> deleteAll() async {
    throw UnsupportedError('FlutterSecureStorage not available on Windows');
  }

  Future<bool> containsKey({required String key}) async {
    throw UnsupportedError('FlutterSecureStorage not available on Windows');
  }

  Future<Map<String, String>> readAll() async {
    throw UnsupportedError('FlutterSecureStorage not available on Windows');
  }
}

/// Platform-aware secure storage adapter
/// Uses flutter_secure_storage on mobile/web, SharedPreferences on Windows for compatibility
class SecureStorageAdapter {
  static const _storage = FlutterSecureStorage();
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  /// Write secure data with platform-specific implementation
  static Future<void> write({required String key, required String value}) async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      // Use SharedPreferences on Windows to avoid ATL dependency
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.setString('secure_$key', value);
    } else {
      // Use secure storage on other platforms
      await _storage.write(key: key, value: value);
    }
  }

  /// Read secure data with platform-specific implementation
  static Future<String?> read({required String key}) async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      // Use SharedPreferences on Windows
      _prefs ??= await SharedPreferences.getInstance();
      return _prefs!.getString('secure_$key');
    } else {
      // Use secure storage on other platforms
      return await _storage.read(key: key);
    }
  }

  /// Delete secure data with platform-specific implementation
  static Future<void> delete({required String key}) async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      // Use SharedPreferences on Windows
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.remove('secure_$key');
    } else {
      // Use secure storage on other platforms
      await _storage.delete(key: key);
    }
  }

  /// Delete all secure data with platform-specific implementation
  static Future<void> deleteAll() async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      // Clear only secure keys on Windows
      _prefs ??= await SharedPreferences.getInstance();
      final keys = _prefs!.getKeys().where((key) => key.startsWith('secure_')).toList();
      for (final key in keys) {
        await _prefs!.remove(key);
      }
    } else {
      // Use secure storage on other platforms
      await _storage.deleteAll();
    }
  }

  /// Check if key exists with platform-specific implementation
  static Future<bool> containsKey({required String key}) async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      // Use SharedPreferences on Windows
      _prefs ??= await SharedPreferences.getInstance();
      return _prefs!.containsKey('secure_$key');
    } else {
      // Use secure storage on other platforms
      return await _storage.containsKey(key: key);
    }
  }

  /// Read all secure data keys with platform-specific implementation
  static Future<Map<String, String>> readAll() async {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      // Use SharedPreferences on Windows
      _prefs ??= await SharedPreferences.getInstance();
      final Map<String, String> result = {};
      final keys = _prefs!.getKeys().where((key) => key.startsWith('secure_'));
      for (final key in keys) {
        final value = _prefs!.getString(key);
        if (value != null) {
          result[key.replaceFirst('secure_', '')] = value;
        }
      }
      return result;
    } else {
      // Use secure storage on other platforms
      return await _storage.readAll();
    }
  }
}
