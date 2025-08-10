import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'duacopilot.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Query History Table
    await db.execute('''
      CREATE TABLE query_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        query TEXT NOT NULL,
        response TEXT,
        timestamp INTEGER NOT NULL,
        response_time INTEGER,
        success INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Cache Table for RAG responses
    await db.execute('''
      CREATE TABLE rag_cache (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        query_hash TEXT UNIQUE NOT NULL,
        query TEXT NOT NULL,
        response TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        expires_at INTEGER NOT NULL
      )
    ''');

    // User Preferences
    await db.execute('''
      CREATE TABLE user_preferences (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Audio Downloads
    await db.execute('''
      CREATE TABLE audio_downloads (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url TEXT NOT NULL,
        local_path TEXT NOT NULL,
        title TEXT,
        duration INTEGER,
        file_size INTEGER,
        download_status TEXT NOT NULL DEFAULT 'pending',
        created_at INTEGER NOT NULL,
        completed_at INTEGER
      )
    ''');

    // Favorites
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id TEXT NOT NULL,
        item_type TEXT NOT NULL,
        title TEXT,
        content TEXT,
        metadata TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Background Sync Status
    await db.execute('''
      CREATE TABLE sync_status (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sync_type TEXT NOT NULL,
        last_sync INTEGER NOT NULL,
        status TEXT NOT NULL,
        error_message TEXT
      )
    ''');

    // Create indexes for better performance
    await db.execute(
      'CREATE INDEX idx_query_history_timestamp ON query_history(timestamp)',
    );
    await db.execute(
      'CREATE INDEX idx_rag_cache_query_hash ON rag_cache(query_hash)',
    );
    await db.execute(
      'CREATE INDEX idx_rag_cache_expires_at ON rag_cache(expires_at)',
    );
    await db.execute(
      'CREATE INDEX idx_audio_downloads_status ON audio_downloads(download_status)',
    );
    await db.execute('CREATE INDEX idx_favorites_type ON favorites(item_type)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database schema upgrades here
    if (oldVersion < newVersion) {
      // Add upgrade logic as needed
    }
  }

  // Clean up expired cache entries
  Future<void> cleanupExpiredCache() async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.delete('rag_cache', where: 'expires_at < ?', whereArgs: [now]);
  }

  // Get database statistics
  Future<Map<String, int>> getDatabaseStats() async {
    final db = await database;
    final stats = <String, int>{};

    final tables = [
      'query_history',
      'rag_cache',
      'user_preferences',
      'audio_downloads',
      'favorites',
      'sync_status',
    ];

    for (final table in tables) {
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM $table');
      stats[table] = result.first['count'] as int;
    }

    return stats;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
