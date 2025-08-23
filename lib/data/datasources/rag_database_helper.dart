import 'package:duacopilot/core/logging/app_logger.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/query_history.dart';

/// RagDatabaseHelper class implementation
class RagDatabaseHelper {
  static const String _dbName = 'rag_dua_copilot.db';
  static const int _currentVersion = 3; // Updated for comprehensive RAG models

  static Database? _database;
  static final RagDatabaseHelper instance = RagDatabaseHelper._();

  RagDatabaseHelper._();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _currentVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  // Configure database for foreign key support
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // Create tables for new database
  Future<void> _onCreate(Database db, int version) async {
    await _createAllTables(db);
    await _insertDefaultData(db);
  }

  // Handle database upgrades with proper migration strategies
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    AppLogger.debug('🔄 Upgrading RAG database from version $oldVersion to $newVersion');

    // Migration strategy: progressive upgrades
    for (int version = oldVersion + 1; version <= newVersion; version++) {
      await _performMigration(db, version);
    }
  }

  Future<void> _performMigration(Database db, int toVersion) async {
    switch (toVersion) {
      case 2:
        await _migrateToV2(db);
        break;
      case 3:
        await _migrateToV3(db);
        break;
      default:
        AppLogger.debug('⚠️ No migration defined for version $toVersion');
    }
  }

  // Migration to version 2: Add semantic search and enhanced RAG features
  Future<void> _migrateToV2(Database db) async {
    AppLogger.debug('📊 Migrating to version 2: Enhanced RAG features');

    // Add semantic_hash column to query_history if not exists
    try {
      await db.execute('''
        ALTER TABLE query_history 
        ADD COLUMN semantic_hash TEXT
      ''');
    } catch (e) {
      AppLogger.debug('Column semantic_hash might already exist: $e');
    }

    // Create dua_responses table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS dua_responses (
        id TEXT PRIMARY KEY,
        query TEXT NOT NULL,
        response TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        response_time INTEGER NOT NULL,
        confidence REAL NOT NULL,
        session_id TEXT,
        tokens_used INTEGER,
        model TEXT,
        metadata TEXT,
        is_favorite INTEGER DEFAULT 0,
        is_from_cache INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    // Create dua_sources table for enhanced response sources
    await db.execute('''
      CREATE TABLE IF NOT EXISTS dua_sources (
        id TEXT PRIMARY KEY,
        dua_response_id TEXT NOT NULL,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        relevance_score REAL NOT NULL,
        url TEXT,
        reference TEXT,
        category TEXT,
        metadata TEXT,
        FOREIGN KEY (dua_response_id) REFERENCES dua_responses (id) ON DELETE CASCADE
      )
    ''');

    // Update existing query_history with semantic hashes
    await _updateSemanticHashes(db);
  }

  // Migration to version 3: Add comprehensive RAG models
  Future<void> _migrateToV3(Database db) async {
    AppLogger.debug('🚀 Migrating to version 3: Comprehensive RAG models');

    // Create dua_recommendations table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS dua_recommendations (
        id TEXT PRIMARY KEY,
        arabic_text TEXT NOT NULL,
        transliteration TEXT NOT NULL,
        translation TEXT NOT NULL,
        confidence REAL NOT NULL,
        category TEXT,
        source TEXT,
        reference TEXT,
        audio_url TEXT,
        audio_file_name TEXT,
        repetitions INTEGER,
        tags TEXT,
        metadata TEXT,
        is_favorite INTEGER DEFAULT 0,
        has_audio INTEGER DEFAULT 0,
        is_downloaded INTEGER DEFAULT 0,
        created_at INTEGER,
        last_accessed INTEGER
      )
    ''');

    // Create enhanced user_preferences table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_preferences (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        key TEXT NOT NULL,
        value TEXT NOT NULL,
        type TEXT NOT NULL,
        category TEXT,
        description TEXT,
        metadata TEXT,
        is_system INTEGER DEFAULT 0,
        is_active INTEGER DEFAULT 1,
        created_at INTEGER,
        updated_at INTEGER,
        UNIQUE(user_id, key)
      )
    ''');

    // Create audio_cache table for downloaded audio management
    await db.execute('''
      CREATE TABLE IF NOT EXISTS audio_cache (
        id TEXT PRIMARY KEY,
        dua_id TEXT NOT NULL,
        file_name TEXT NOT NULL,
        local_path TEXT NOT NULL,
        file_size_bytes INTEGER NOT NULL,
        quality TEXT NOT NULL,
        status TEXT NOT NULL,
        original_url TEXT,
        reciter TEXT,
        language TEXT,
        metadata TEXT,
        play_count INTEGER DEFAULT 0,
        is_favorite INTEGER DEFAULT 0,
        downloaded_at INTEGER,
        last_played INTEGER,
        expires_at INTEGER
      )
    ''');

    // Enhanced query_history with more RAG context
    try {
      await db.execute('ALTER TABLE query_history ADD COLUMN context TEXT');
      await db.execute(
        'ALTER TABLE query_history ADD COLUMN last_accessed INTEGER',
      );
      await db.execute(
        'ALTER TABLE query_history ADD COLUMN access_count INTEGER DEFAULT 0',
      );
    } catch (e) {
      AppLogger.debug('Enhanced query_history columns might already exist: $e');
    }
  }

  Future<void> _createAllTables(Database db) async {
    // Create query_history table (base table)
    await db.execute('''
      CREATE TABLE query_history (
        id TEXT PRIMARY KEY,
        query TEXT NOT NULL,
        response TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        response_time INTEGER NOT NULL,
        semantic_hash TEXT,
        confidence REAL,
        session_id TEXT,
        tags TEXT,
        context TEXT,
        metadata TEXT,
        is_favorite INTEGER DEFAULT 0,
        is_from_cache INTEGER DEFAULT 0,
        last_accessed INTEGER,
        access_count INTEGER DEFAULT 0
      )
    ''');

    // Create dua_responses table
    await db.execute('''
      CREATE TABLE dua_responses (
        id TEXT PRIMARY KEY,
        query TEXT NOT NULL,
        response TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        response_time INTEGER NOT NULL,
        confidence REAL NOT NULL,
        session_id TEXT,
        tokens_used INTEGER,
        model TEXT,
        metadata TEXT,
        is_favorite INTEGER DEFAULT 0,
        is_from_cache INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    // Create dua_sources table
    await db.execute('''
      CREATE TABLE dua_sources (
        id TEXT PRIMARY KEY,
        dua_response_id TEXT NOT NULL,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        relevance_score REAL NOT NULL,
        url TEXT,
        reference TEXT,
        category TEXT,
        metadata TEXT,
        FOREIGN KEY (dua_response_id) REFERENCES dua_responses (id) ON DELETE CASCADE
      )
    ''');

    // Create dua_recommendations table
    await db.execute('''
      CREATE TABLE dua_recommendations (
        id TEXT PRIMARY KEY,
        arabic_text TEXT NOT NULL,
        transliteration TEXT NOT NULL,
        translation TEXT NOT NULL,
        confidence REAL NOT NULL,
        category TEXT,
        source TEXT,
        reference TEXT,
        audio_url TEXT,
        audio_file_name TEXT,
        repetitions INTEGER,
        tags TEXT,
        metadata TEXT,
        is_favorite INTEGER DEFAULT 0,
        has_audio INTEGER DEFAULT 0,
        is_downloaded INTEGER DEFAULT 0,
        created_at INTEGER,
        last_accessed INTEGER
      )
    ''');

    // Create user_preferences table
    await db.execute('''
      CREATE TABLE user_preferences (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        key TEXT NOT NULL,
        value TEXT NOT NULL,
        type TEXT NOT NULL,
        category TEXT,
        description TEXT,
        metadata TEXT,
        is_system INTEGER DEFAULT 0,
        is_active INTEGER DEFAULT 1,
        created_at INTEGER,
        updated_at INTEGER,
        UNIQUE(user_id, key)
      )
    ''');

    // Create audio_cache table
    await db.execute('''
      CREATE TABLE audio_cache (
        id TEXT PRIMARY KEY,
        dua_id TEXT NOT NULL,
        file_name TEXT NOT NULL,
        local_path TEXT NOT NULL,
        file_size_bytes INTEGER NOT NULL,
        quality TEXT NOT NULL,
        status TEXT NOT NULL,
        original_url TEXT,
        reciter TEXT,
        language TEXT,
        metadata TEXT,
        play_count INTEGER DEFAULT 0,
        is_favorite INTEGER DEFAULT 0,
        downloaded_at INTEGER,
        last_played INTEGER,
        expires_at INTEGER
      )
    ''');

    // Create indexes for optimized queries
    await _createIndexes(db);
  }

  Future<void> _createIndexes(Database db) async {
    // Query history indexes for semantic search
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_query_history_semantic_hash ON query_history(semantic_hash)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_query_history_timestamp ON query_history(timestamp DESC)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_query_history_session ON query_history(session_id)',
    );

    // Dua responses indexes
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_dua_responses_timestamp ON dua_responses(timestamp DESC)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_dua_responses_confidence ON dua_responses(confidence DESC)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_dua_responses_session ON dua_responses(session_id)',
    );

    // Dua sources indexes
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_dua_sources_response_id ON dua_sources(dua_response_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_dua_sources_relevance ON dua_sources(relevance_score DESC)',
    );

    // Dua recommendations indexes
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_dua_recommendations_category ON dua_recommendations(category)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_dua_recommendations_confidence ON dua_recommendations(confidence DESC)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_dua_recommendations_favorite ON dua_recommendations(is_favorite)',
    );

    // User preferences indexes
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_user_preferences_user_key ON user_preferences(user_id, key)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_user_preferences_category ON user_preferences(category)',
    );

    // Audio cache indexes
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_audio_cache_dua_id ON audio_cache(dua_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_audio_cache_status ON audio_cache(status)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_audio_cache_downloaded ON audio_cache(downloaded_at DESC)',
    );
  }

  Future<void> _insertDefaultData(Database db) async {
    // Insert default user preferences for RAG context
    final defaultPrefs = [
      {
        'id': 'default_lang',
        'user_id': 'default',
        'key': 'language',
        'value': 'en',
        'type': 'string',
        'category': 'localization',
        'description': 'Default interface language',
        'is_system': 1,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'default_region',
        'user_id': 'default',
        'key': 'region',
        'value': 'global',
        'type': 'string',
        'category': 'localization',
        'description': 'Default regional settings',
        'is_system': 1,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      {
        'id': 'default_audio_quality',
        'user_id': 'default',
        'key': 'audio_quality',
        'value': 'medium',
        'type': 'string',
        'category': 'audio',
        'description': 'Default audio quality setting',
        'is_system': 1,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
    ];

    for (final pref in defaultPrefs) {
      await db.insert('user_preferences', pref);
    }
  }

  Future<void> _updateSemanticHashes(Database db) async {
    // Update existing query_history entries with semantic hashes
    final results = await db.query(
      'query_history',
      where: 'semantic_hash IS NULL',
    );

    for (final row in results) {
      final query = row['query'] as String;
      final semanticHash = QueryHistoryHelper.generateSemanticHash(query);

      await db.update(
        'query_history',
        {'semantic_hash': semanticHash},
        where: 'id = ?',
        whereArgs: [row['id']],
      );
    }
  }

  // Database maintenance and cleanup methods
  Future<void> cleanupExpiredCache() async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;

    // Clean expired audio cache
    await db.delete(
      'audio_cache',
      where: 'expires_at IS NOT NULL AND expires_at < ? AND is_favorite = 0',
      whereArgs: [now],
    );

    // Clean old query history (keep last 1000 entries)
    await db.execute('''
      DELETE FROM query_history 
      WHERE id NOT IN (
        SELECT id FROM query_history 
        ORDER BY timestamp DESC 
        LIMIT 1000
      )
    ''');
  }

  Future<void> vacuum() async {
    final db = await database;
    await db.execute('VACUUM');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  // Database integrity check
  Future<bool> checkIntegrity() async {
    try {
      final db = await database;
      final result = await db.rawQuery('PRAGMA integrity_check');
      return result.isNotEmpty && result.first['integrity_check'] == 'ok';
    } catch (e) {
      AppLogger.debug('❌ Database integrity check failed: $e');
      return false;
    }
  }

  // Get database statistics
  Future<Map<String, int>> getDatabaseStats() async {
    final db = await database;
    final stats = <String, int>{};

    final tables = [
      'query_history',
      'dua_responses',
      'dua_sources',
      'dua_recommendations',
      'user_preferences',
      'audio_cache',
    ];

    for (final table in tables) {
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM $table');
      stats[table] = result.first['count'] as int;
    }

    return stats;
  }
}
