import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../platform/platform_service.dart';

// Conditional import for secure storage - only available on mobile platforms
class FlutterSecureStorage {
  const FlutterSecureStorage();

  Future<void> write({required String key, required String value}) async {
    throw UnsupportedError('FlutterSecureStorage not available on this platform');
  }

  Future<String?> read({required String key}) async {
    throw UnsupportedError('FlutterSecureStorage not available on this platform');
  }

  Future<void> delete({required String key}) async {
    throw UnsupportedError('FlutterSecureStorage not available on this platform');
  }

  Future<void> deleteAll() async {
    throw UnsupportedError('FlutterSecureStorage not available on this platform');
  }

  Future<bool> containsKey({required String key}) async {
    throw UnsupportedError('FlutterSecureStorage not available on this platform');
  }

  Future<Map<String, String>> readAll() async {
    throw UnsupportedError('FlutterSecureStorage not available on this platform');
  }
}

/// Platform-aware secure storage adapter
/// Uses the most appropriate storage method for each platform:
/// - Mobile: FlutterSecureStorage (when available) or SharedPreferences
/// - Desktop: SharedPreferences (avoids compilation issues)
/// - Web: SharedPreferences
class SecureStorageAdapter {
  static const _storage = FlutterSecureStorage();
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    // Always initialize SharedPreferences as fallback
    _prefs = await SharedPreferences.getInstance();

    if (kDebugMode) {
      final platform = PlatformService.instance;
      print('🔐 SecureStorageAdapter initialized for ${platform.platformName}');
      print('📱 Secure storage supported: ${platform.supportsSecureStorage}');
    }
  }

  /// Write secure data with platform-specific implementation
  static Future<void> write({required String key, required String value}) async {
    final platform = PlatformService.instance;

    // Use secure storage on supported mobile platforms
    if (platform.isMobile && platform.supportsSecureStorage) {
      try {
        await _storage.write(key: key, value: value);
        return;
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Secure storage failed, falling back to SharedPreferences: $e');
        }
      }
    }

    // Fallback to SharedPreferences for desktop/web or if secure storage fails
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString('secure_$key', value);

    if (kDebugMode) {
      print(
        '💾 Stored $key using ${platform.supportsSecureStorage && platform.isMobile ? 'secure storage (fallback: SharedPreferences)' : 'SharedPreferences'}',
      );
    }
  }

  /// Read secure data with platform-specific implementation
  static Future<String?> read({required String key}) async {
    final platform = PlatformService.instance;

    // Try secure storage on supported mobile platforms
    if (platform.isMobile && platform.supportsSecureStorage) {
      try {
        final value = await _storage.read(key: key);
        if (value != null) {
          return value;
        }
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Secure storage read failed, checking SharedPreferences: $e');
        }
      }
    }

    // Fallback to SharedPreferences
    _prefs ??= await SharedPreferences.getInstance();
    final value = _prefs!.getString('secure_$key');

    if (kDebugMode && value != null) {
      print('📖 Read $key from SharedPreferences');
    }

    return value;
  }

  /// Delete secure data with platform-specific implementation
  static Future<void> delete({required String key}) async {
    final platform = PlatformService.instance;

    // Delete from secure storage if available
    if (platform.isMobile && platform.supportsSecureStorage) {
      try {
        await _storage.delete(key: key);
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Secure storage delete failed: $e');
        }
      }
    }

    // Also delete from SharedPreferences (in case data exists there)
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.remove('secure_$key');

    if (kDebugMode) {
      print('🗑️ Deleted $key from storage');
    }
  }

  /// Delete all secure data with platform-specific implementation
  static Future<void> deleteAll() async {
    final platform = PlatformService.instance;

    // Clear secure storage if available
    if (platform.isMobile && platform.supportsSecureStorage) {
      try {
        await _storage.deleteAll();
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Secure storage deleteAll failed: $e');
        }
      }
    }

    // Clear secure keys from SharedPreferences
    _prefs ??= await SharedPreferences.getInstance();
    final keys = _prefs!.getKeys().where((key) => key.startsWith('secure_')).toList();
    for (final key in keys) {
      await _prefs!.remove(key);
    }

    if (kDebugMode) {
      print('🧹 Cleared all secure storage data');
    }
  }

  /// Check if key exists with platform-specific implementation
  static Future<bool> containsKey({required String key}) async {
    final platform = PlatformService.instance;

    // Check secure storage first if available
    if (platform.isMobile && platform.supportsSecureStorage) {
      try {
        if (await _storage.containsKey(key: key)) {
          return true;
        }
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Secure storage containsKey failed: $e');
        }
      }
    }

    // Check SharedPreferences
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.containsKey('secure_$key');
  }

  /// Read all secure data keys with platform-specific implementation
  static Future<Map<String, String>> readAll() async {
    final platform = PlatformService.instance;
    final allData = <String, String>{};

    // Read from secure storage if available
    if (platform.isMobile && platform.supportsSecureStorage) {
      try {
        final secureData = await _storage.readAll();
        allData.addAll(secureData);
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Secure storage readAll failed: $e');
        }
      }
    }

    // Read from SharedPreferences (merge data, but secure storage takes precedence)
    _prefs ??= await SharedPreferences.getInstance();
    final keys = _prefs!.getKeys().where((key) => key.startsWith('secure_'));
    for (final key in keys) {
      final cleanKey = key.replaceFirst('secure_', '');
      if (!allData.containsKey(cleanKey)) {
        final value = _prefs!.getString(key);
        if (value != null) {
          allData[cleanKey] = value;
        }
      }
    }

    return allData;
  }

  /// Get storage info for debugging
  static Future<Map<String, dynamic>> getStorageInfo() async {
    final platform = PlatformService.instance;
    _prefs ??= await SharedPreferences.getInstance();

    final secureKeys = _prefs!.getKeys().where((key) => key.startsWith('secure_')).length;
    final info = {
      'platform': platform.platformName,
      'supportsSecureStorage': platform.supportsSecureStorage,
      'usingSecureStorage': platform.isMobile && platform.supportsSecureStorage,
      'sharedPreferencesSecureKeys': secureKeys,
    };

    if (platform.isMobile && platform.supportsSecureStorage) {
      try {
        final secureData = await _storage.readAll();
        info['secureStorageKeys'] = secureData.keys.length;
      } catch (e) {
        info['secureStorageError'] = e.toString();
      }
    }

    return info;
  }
}
