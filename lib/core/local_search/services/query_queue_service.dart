import 'package:duacopilot/core/logging/app_logger.dart';

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/local_search_models.dart';
import '../storage/local_vector_storage.dart';

/// Queue management service for handling offline and pending queries
class QueryQueueService {
  static QueryQueueService? _instance;
  static QueryQueueService get instance => _instance ??= QueryQueueService._();

  QueryQueueService._();

  // Queue storage
  final List<PendingQuery> _pendingQueries = [];
  final List<PendingQuery> _processingQueries = [];

  // Configuration
  static const String _queueStorageKey = 'pending_queries_queue';
  static const int _maxRetryAttempts = 3;
  static const int _maxQueueSize = 100;

  // State management
  bool _isInitialized = false;
  bool _isProcessing = false;
  Timer? _processingTimer;
  Timer? _connectivityCheckTimer;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  // Callbacks
  Function(PendingQuery)? _onQueryProcessed;
  Function(PendingQuery, String)? _onQueryFailed;
  Function(int)? _onQueueSizeChanged;

  /// Initialize the queue service
  Future<void> initialize({
    Function(PendingQuery)? onQueryProcessed,
    Function(PendingQuery, String)? onQueryFailed,
    Function(int)? onQueueSizeChanged,
  }) async {
    if (_isInitialized) return;

    try {
      _onQueryProcessed = onQueryProcessed;
      _onQueryFailed = onQueryFailed;
      _onQueueSizeChanged = onQueueSizeChanged;

      // Load existing queue from storage
      await _loadQueueFromStorage();

      // Set up connectivity monitoring
      await _setupConnectivityMonitoring();

      // Start processing if network is available
      _startPeriodicProcessing();

      _isInitialized = true;
      AppLogger.debug(
        'Query queue service initialized with ${_pendingQueries.length} pending queries',
      );
    } catch (e) {
      AppLogger.debug('Error initializing query queue service: $e');
      throw Exception('Failed to initialize queue service: $e');
    }
  }

  /// Add a query to the queue
  Future<String> enqueueQuery({
    required String query,
    required String language,
    Map<String, dynamic>? context,
    int priority = 0,
    String? localResponseId,
  }) async {
    await _ensureInitialized();

    try {
      // Check queue size limit
      if (_pendingQueries.length >= _maxQueueSize) {
        await _evictOldQueries();
      }

      final pendingQuery = PendingQuery(
        id: _generateQueryId(),
        query: query,
        language: language,
        createdAt: DateTime.now(),
        context: context ?? {},
        priority: priority,
        localResponseId: localResponseId,
      );

      // Add to queue (priority sorted)
      _insertQueryByPriority(pendingQuery);

      // Save to persistent storage
      await _saveQueueToStorage();

      // Store in local vector storage for persistence
      await LocalVectorStorage.instance.storePendingQuery(pendingQuery);

      // Notify about queue size change
      _onQueueSizeChanged?.call(_pendingQueries.length);

      // Try immediate processing if connected
      if (await _isConnected()) {
        _processNextQuery();
      }

      print('Enqueued query: ${query.substring(0, 50)}...');
      return pendingQuery.id;
    } catch (e) {
      AppLogger.debug('Error enqueuing query: $e');
      throw Exception('Failed to enqueue query: $e');
    }
  }

  /// Remove a query from the queue
  Future<bool> dequeueQuery(String queryId) async {
    await _ensureInitialized();

    try {
      final index = _pendingQueries.indexWhere((q) => q.id == queryId);
      if (index != -1) {
        _pendingQueries.removeAt(index);
        await _saveQueueToStorage();
        await LocalVectorStorage.instance.removePendingQuery(queryId);
        _onQueueSizeChanged?.call(_pendingQueries.length);
        return true;
      }
      return false;
    } catch (e) {
      AppLogger.debug('Error dequeuing query: $e');
      return false;
    }
  }

  /// Get all pending queries
  List<PendingQuery> getPendingQueries({bool sortByPriority = true}) {
    if (sortByPriority) {
      final sorted = List<PendingQuery>.from(_pendingQueries);
      sorted.sort((a, b) {
        final priorityComparison = b.priority.compareTo(a.priority);
        if (priorityComparison != 0) return priorityComparison;
        return a.createdAt.compareTo(b.createdAt);
      });
      return sorted;
    }
    return List.from(_pendingQueries);
  }

  /// Get queries currently being processed
  List<PendingQuery> getProcessingQueries() {
    return List.from(_processingQueries);
  }

  /// Get queue statistics
  Map<String, dynamic> getQueueStats() {
    final now = DateTime.now();
    final oldQueries =
        _pendingQueries
            .where((q) => now.difference(q.createdAt).inHours > 24)
            .length;

    final priorityDistribution = <int, int>{};
    final languageDistribution = <String, int>{};

    for (final query in _pendingQueries) {
      priorityDistribution[query.priority] =
          (priorityDistribution[query.priority] ?? 0) + 1;
      languageDistribution[query.language] =
          (languageDistribution[query.language] ?? 0) + 1;
    }

    return {
      'total_pending': _pendingQueries.length,
      'currently_processing': _processingQueries.length,
      'old_queries_24h': oldQueries,
      'max_queue_size': _maxQueueSize,
      'priority_distribution': priorityDistribution,
      'language_distribution': languageDistribution,
      'is_processing': _isProcessing,
      'last_connectivity_check': _lastConnectivityCheck?.toIso8601String(),
      'is_connected': _lastConnectivityResult,
    };
  }

  /// Manually trigger queue processing
  Future<void> processQueue() async {
    await _ensureInitialized();

    if (!await _isConnected()) {
      AppLogger.debug('No network connection, skipping queue processing');
      return;
    }

    if (_isProcessing) {
      AppLogger.debug('Queue processing already in progress');
      return;
    }

    await _processQueueInternal();
  }

  /// Clear all pending queries
  Future<void> clearQueue() async {
    await _ensureInitialized();

    try {
      _pendingQueries.clear();
      _processingQueries.clear();
      await _saveQueueToStorage();
      await LocalVectorStorage.instance.clearPendingQueries();
      _onQueueSizeChanged?.call(0);
      AppLogger.debug('Queue cleared');
    } catch (e) {
      AppLogger.debug('Error clearing queue: $e');
    }
  }

  /// Update query priority
  Future<void> updateQueryPriority(String queryId, int newPriority) async {
    await _ensureInitialized();

    try {
      final index = _pendingQueries.indexWhere((q) => q.id == queryId);
      if (index != -1) {
        final query = _pendingQueries[index];
        final updated = query.copyWith(priority: newPriority);
        _pendingQueries[index] = updated;

        // Re-sort the queue
        _sortQueueByPriority();

        await _saveQueueToStorage();
        await LocalVectorStorage.instance.storePendingQuery(updated);
      }
    } catch (e) {
      AppLogger.debug('Error updating query priority: $e');
    }
  }

  /// Mark query as processed with local response
  Future<void> markQueryProcessedLocally(
    String queryId,
    String localResponseId,
  ) async {
    await _ensureInitialized();

    try {
      final index = _pendingQueries.indexWhere((q) => q.id == queryId);
      if (index != -1) {
        final query = _pendingQueries[index];
        final updated = query.copyWith(
          isProcessed: true,
          localResponseId: localResponseId,
        );
        _pendingQueries[index] = updated;

        await _saveQueueToStorage();
        await LocalVectorStorage.instance.markQueryProcessed(
          queryId,
          localResponseId,
        );
      }
    } catch (e) {
      AppLogger.debug('Error marking query as processed locally: $e');
    }
  }

  /// Dispose and cleanup
  Future<void> dispose() async {
    _processingTimer?.cancel();
    _connectivityCheckTimer?.cancel();
    await _connectivitySubscription?.cancel();

    await _saveQueueToStorage();
    _isInitialized = false;

    AppLogger.debug('Query queue service disposed');
  }

  // Private methods

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  String _generateQueryId() {
    return 'query_${DateTime.now().millisecondsSinceEpoch}_${_pendingQueries.length}';
  }

  void _insertQueryByPriority(PendingQuery query) {
    int insertIndex = _pendingQueries.length;

    for (int i = 0; i < _pendingQueries.length; i++) {
      if (_pendingQueries[i].priority < query.priority) {
        insertIndex = i;
        break;
      }
    }

    _pendingQueries.insert(insertIndex, query);
  }

  void _sortQueueByPriority() {
    _pendingQueries.sort((a, b) {
      final priorityComparison = b.priority.compareTo(a.priority);
      if (priorityComparison != 0) return priorityComparison;
      return a.createdAt.compareTo(b.createdAt);
    });
  }

  Future<void> _loadQueueFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getString(_queueStorageKey);

      if (queueJson != null) {
        final queueData = jsonDecode(queueJson) as List;
        final queries =
            queueData
                .map(
                  (json) => PendingQuery.fromJson(json as Map<String, dynamic>),
                )
                .toList();

        _pendingQueries.clear();
        _pendingQueries.addAll(queries);

        // Also load from local vector storage (backup)
        final storageQueries = await LocalVectorStorage.instance
            .getPendingQueries(unprocessedOnly: true);

        // Merge and deduplicate
        final existingIds = _pendingQueries.map((q) => q.id).toSet();
        for (final query in storageQueries) {
          if (!existingIds.contains(query.id)) {
            _pendingQueries.add(query);
          }
        }

        _sortQueueByPriority();
        AppLogger.debug(
          'Loaded ${_pendingQueries.length} queries from storage',
        );
      }
    } catch (e) {
      AppLogger.debug('Error loading queue from storage: $e');
    }
  }

  Future<void> _saveQueueToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = jsonEncode(
        _pendingQueries.map((q) => q.toJson()).toList(),
      );
      await prefs.setString(_queueStorageKey, queueJson);
    } catch (e) {
      AppLogger.debug('Error saving queue to storage: $e');
    }
  }

  DateTime? _lastConnectivityCheck;
  bool _lastConnectivityResult = false;

  Future<void> _setupConnectivityMonitoring() async {
    try {
      // Check initial connectivity
      _lastConnectivityResult = await _isConnected();
      _lastConnectivityCheck = DateTime.now();

      // Monitor connectivity changes
      _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
        ConnectivityResult result,
      ) {
        _lastConnectivityResult = result != ConnectivityResult.none;
        _lastConnectivityCheck = DateTime.now();

        if (_lastConnectivityResult && _pendingQueries.isNotEmpty) {
          AppLogger.debug('Network connection restored, processing queue');
          _processQueueInternal();
        }
      });

      // Periodic connectivity check
      _connectivityCheckTimer = Timer.periodic(Duration(minutes: 2), (_) async {
        _lastConnectivityResult = await _isConnected();
        _lastConnectivityCheck = DateTime.now();
      });
    } catch (e) {
      AppLogger.debug('Error setting up connectivity monitoring: $e');
    }
  }

  Future<bool> _isConnected() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      AppLogger.debug('Error checking connectivity: $e');
      return false;
    }
  }

  void _startPeriodicProcessing() {
    _processingTimer = Timer.periodic(Duration(minutes: 5), (_) async {
      if (await _isConnected() && _pendingQueries.isNotEmpty) {
        await _processQueueInternal();
      }
    });
  }

  Future<void> _processQueueInternal() async {
    if (_isProcessing || _pendingQueries.isEmpty) return;

    _isProcessing = true;

    try {
      final batchSize = 3; // Process up to 3 queries at once
      final toProcess = _pendingQueries.take(batchSize).toList();

      for (final query in toProcess) {
        if (!_processingQueries.contains(query)) {
          _processingQueries.add(query);
          _processQuery(query);
        }
      }
    } catch (e) {
      AppLogger.debug('Error processing queue: $e');
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _processQuery(PendingQuery query) async {
    try {
      // In a real implementation, this would call the actual RAG service
      // For now, we simulate processing
      await Future.delayed(Duration(seconds: 2));

      // Simulate success/failure
      final success = DateTime.now().millisecond % 10 > 2; // 80% success rate

      if (success) {
        // Remove from pending and processing queues
        _pendingQueries.removeWhere((q) => q.id == query.id);
        _processingQueries.removeWhere((q) => q.id == query.id);

        // Mark as processed in storage
        await LocalVectorStorage.instance.markQueryProcessed(query.id, null);

        // Notify callback
        _onQueryProcessed?.call(query);

        print(
          'Successfully processed query: ${query.query.substring(0, 50)}...',
        );
      } else {
        // Handle failure
        await _handleQueryFailure(query, 'Simulated processing failure');
      }

      // Update storage and notify
      await _saveQueueToStorage();
      _onQueueSizeChanged?.call(_pendingQueries.length);
    } catch (e) {
      await _handleQueryFailure(query, 'Processing error: $e');
    }
  }

  Future<void> _handleQueryFailure(PendingQuery query, String error) async {
    try {
      _processingQueries.removeWhere((q) => q.id == query.id);

      final updatedQuery = query.copyWith(retryCount: query.retryCount + 1);

      if (updatedQuery.retryCount >= _maxRetryAttempts) {
        // Max retries reached, remove from queue
        _pendingQueries.removeWhere((q) => q.id == query.id);
        await LocalVectorStorage.instance.removePendingQuery(query.id);

        _onQueryFailed?.call(query, 'Max retry attempts reached: $error');
        print(
          'Query failed after $_maxRetryAttempts attempts: ${query.query.substring(0, 50)}...',
        );
      } else {
        // Schedule retry
        final index = _pendingQueries.indexWhere((q) => q.id == query.id);
        if (index != -1) {
          _pendingQueries[index] = updatedQuery;
          await LocalVectorStorage.instance.storePendingQuery(updatedQuery);
        }

        print(
          'Query failed (attempt ${updatedQuery.retryCount}), will retry: ${query.query.substring(0, 50)}...',
        );
      }
    } catch (e) {
      AppLogger.debug('Error handling query failure: $e');
    }
  }

  Future<void> _evictOldQueries() async {
    try {
      // Remove oldest queries first
      _pendingQueries.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      final toRemove = (_pendingQueries.length * 0.1).ceil(); // Remove 10%
      for (int i = 0; i < toRemove && _pendingQueries.isNotEmpty; i++) {
        final query = _pendingQueries.removeAt(0);
        await LocalVectorStorage.instance.removePendingQuery(query.id);
      }

      AppLogger.debug('Evicted $toRemove old queries from queue');
    } catch (e) {
      AppLogger.debug('Error evicting old queries: $e');
    }
  }

  Future<void> _processNextQuery() async {
    if (_pendingQueries.isNotEmpty && await _isConnected()) {
      final nextQuery = _pendingQueries.first;
      await _processQuery(nextQuery);
    }
  }

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Get current queue size
  int get queueSize => _pendingQueries.length;

  /// Check if currently processing
  bool get isProcessing => _isProcessing;
}
