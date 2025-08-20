import 'package:sqflite/sqflite.dart';

/// Mock database helper for web and fallback scenarios
/// Provides in-memory storage that behaves like a database but doesn't require SQLite
class MockDatabaseHelper {
  static final MockDatabaseHelper instance = MockDatabaseHelper._internal();
  
  // In-memory storage
  final Map<String, List<Map<String, dynamic>>> _tables = {};
  
  MockDatabaseHelper._internal() {
    _initializeTables();
  }

  void _initializeTables() {
    _tables['query_history'] = [];
    _tables['favorites'] = [];
    _tables['rag_cache'] = [];
    _tables['audio_cache'] = [];
  }

  Future<Database> get database async {
    throw UnsupportedError('MockDatabaseHelper does not provide actual Database instance');
  }

  // Mock query history operations
  Future<List<Map<String, dynamic>>> getQueryHistory({int? limit, int? offset}) async {
    final table = _tables['query_history'] ?? [];
    final sortedTable = List<Map<String, dynamic>>.from(table)
      ..sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));
    
    int start = offset ?? 0;
    int end = limit != null ? start + limit : sortedTable.length;
    
    if (start >= sortedTable.length) return [];
    if (end > sortedTable.length) end = sortedTable.length;
    
    return sortedTable.sublist(start, end);
  }

  Future<void> saveQueryHistory(Map<String, dynamic> queryHistory) async {
    final table = _tables['query_history']!;
    
    // Generate an ID if not present
    queryHistory['id'] = queryHistory['id'] ?? DateTime.now().millisecondsSinceEpoch;
    queryHistory['timestamp'] = queryHistory['timestamp'] ?? DateTime.now().millisecondsSinceEpoch;
    
    // Remove existing entry with same query to avoid duplicates
    table.removeWhere((item) => item['query'] == queryHistory['query']);
    
    // Add new entry
    table.add(Map<String, dynamic>.from(queryHistory));
    
    // Keep only last 100 entries to prevent memory bloat
    if (table.length > 100) {
      table.sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));
      _tables['query_history'] = table.take(100).toList();
    }
  }

  Future<void> deleteQueryHistory(int id) async {
    final table = _tables['query_history']!;
    table.removeWhere((item) => item['id'] == id);
  }

  Future<void> clearQueryHistory() async {
    _tables['query_history']?.clear();
  }

  // Mock favorites operations
  Future<List<Map<String, dynamic>>> getFavorites({int? limit, int? offset}) async {
    final table = _tables['favorites'] ?? [];
    final sortedTable = List<Map<String, dynamic>>.from(table)
      ..sort((a, b) => (b['created_at'] as int).compareTo(a['created_at'] as int));
    
    int start = offset ?? 0;
    int end = limit != null ? start + limit : sortedTable.length;
    
    if (start >= sortedTable.length) return [];
    if (end > sortedTable.length) end = sortedTable.length;
    
    return sortedTable.sublist(start, end);
  }

  Future<void> saveFavorite(Map<String, dynamic> favorite) async {
    final table = _tables['favorites']!;
    
    // Generate an ID if not present
    favorite['id'] = favorite['id'] ?? DateTime.now().millisecondsSinceEpoch;
    favorite['created_at'] = favorite['created_at'] ?? DateTime.now().millisecondsSinceEpoch;
    
    // Check if already exists
    if (!table.any((item) => item['query'] == favorite['query'])) {
      table.add(Map<String, dynamic>.from(favorite));
    }
  }

  Future<void> deleteFavorite(int id) async {
    final table = _tables['favorites']!;
    table.removeWhere((item) => item['id'] == id);
  }

  Future<bool> isFavorite(String query) async {
    final table = _tables['favorites'] ?? [];
    return table.any((item) => item['query'] == query);
  }

  // Mock RAG cache operations
  Future<Map<String, dynamic>?> getCachedRagResponse(String query) async {
    final table = _tables['rag_cache'] ?? [];
    
    // Simple exact match for mock
    for (final item in table) {
      if (item['query'] == query) {
        // Check if cache is still valid (24 hours)
        final timestamp = item['timestamp'] as int;
        final now = DateTime.now().millisecondsSinceEpoch;
        final ageHours = (now - timestamp) / (1000 * 60 * 60);
        
        if (ageHours < 24) {
          return Map<String, dynamic>.from(item);
        } else {
          // Remove expired cache
          table.removeWhere((cacheItem) => cacheItem['query'] == query);
        }
      }
    }
    
    return null;
  }

  Future<void> cacheRagResponse(String query, Map<String, dynamic> response) async {
    final table = _tables['rag_cache']!;
    
    // Remove existing cache for this query
    table.removeWhere((item) => item['query'] == query);
    
    // Add new cache entry
    final cacheEntry = {
      'query': query,
      'response': response,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    
    table.add(cacheEntry);
    
    // Keep only last 50 cached responses to prevent memory bloat
    if (table.length > 50) {
      table.sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));
      _tables['rag_cache'] = table.take(50).toList();
    }
  }

  Future<void> clearCache() async {
    _tables['rag_cache']?.clear();
    _tables['audio_cache']?.clear();
  }

  // Statistics for debugging
  Map<String, int> getStorageStats() {
    return {
      'query_history_count': _tables['query_history']?.length ?? 0,
      'favorites_count': _tables['favorites']?.length ?? 0,
      'rag_cache_count': _tables['rag_cache']?.length ?? 0,
      'audio_cache_count': _tables['audio_cache']?.length ?? 0,
    };
  }

  // Clear all data
  Future<void> resetAllData() async {
    _tables.clear();
    _initializeTables();
  }
}
