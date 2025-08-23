import 'package:duacopilot/core/logging/app_logger.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../domain/entities/dua_entity.dart';

/// FavoritesService class implementation
class FavoritesService {
  static const String _favoritesKey = 'favorite_duas';
  static const String _recentlyViewedKey = 'recently_viewed_duas';

  static Future<List<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
    return favoritesJson;
  }

  static Future<void> addToFavorites(String duaId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteIds();
    if (!favorites.contains(duaId)) {
      favorites.add(duaId);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  static Future<void> removeFromFavorites(String duaId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteIds();
    favorites.remove(duaId);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  static Future<bool> isFavorite(String duaId) async {
    final favorites = await getFavoriteIds();
    return favorites.contains(duaId);
  }

  static Future<void> toggleFavorite(String duaId) async {
    if (await isFavorite(duaId)) {
      await removeFromFavorites(duaId);
    } else {
      await addToFavorites(duaId);
    }
  }

  static Future<void> addToRecentlyViewed(DuaEntity dua) async {
    final prefs = await SharedPreferences.getInstance();
    final recentJson = prefs.getStringList(_recentlyViewedKey) ?? [];

    // Convert DuaEntity to JSON string
    final duaJson = json.encode(dua.toJson());

    // Remove if already exists to avoid duplicates
    recentJson.removeWhere((item) {
      final itemData = json.decode(item);
      return itemData['id'] == dua.id;
    });

    // Add to beginning of list
    recentJson.insert(0, duaJson);

    // Keep only last 20 items
    if (recentJson.length > 20) {
      recentJson.removeRange(20, recentJson.length);
    }

    await prefs.setStringList(_recentlyViewedKey, recentJson);
  }

  static Future<List<DuaEntity>> getRecentlyViewed() async {
    final prefs = await SharedPreferences.getInstance();
    final recentJson = prefs.getStringList(_recentlyViewedKey) ?? [];

    return recentJson.map((item) {
      final duaData = json.decode(item);
      return DuaEntity.fromJson(duaData);
    }).toList();
  }

  static Future<void> clearRecentlyViewed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentlyViewedKey);
  }

  static Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }

  // Sync favorites with cloud (placeholder for future implementation)
  static Future<void> syncWithCloud(String userId) async {
    // This would implement cloud sync with Firebase or similar
    // For now, it's a placeholder
    AppLogger.debug('Cloud sync for user $userId - Feature coming soon');
  }

  // Export favorites to share or backup
  static Future<String> exportFavorites() async {
    final favoriteIds = await getFavoriteIds();
    final favorites = <Map<String, dynamic>>[];

    for (final id in favoriteIds) {
      // In a real app, fetch full dua data
      favorites.add({'id': id, 'timestamp': DateTime.now().toIso8601String()});
    }

    return json.encode({
      'favorites': favorites,
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0',
    });
  }

  // Import favorites from backup
  static Future<void> importFavorites(String backupJson) async {
    try {
      final data = json.decode(backupJson);
      final favorites = data['favorites'] as List;

      final prefs = await SharedPreferences.getInstance();
      final favoriteIds =
          favorites.map((item) => item['id'] as String).toList();

      await prefs.setStringList(_favoritesKey, favoriteIds);
    } catch (e) {
      throw Exception('Invalid backup format');
    }
  }
}
