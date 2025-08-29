import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/offline/offline_search_models.dart';
import '../../domain/repositories/rag_repository.dart';

/// Queue management service for handling pending queries when offline
class QueryQueueService {
  static const String _pendingQueriesKey = 'pending_queries_queue';
  static const String _failedQueriesKey = 'failed_queries_queue';
  static const String _processingStatusKey = 'queue_processing_status';
  static const int _maxRetryAttempts = 3;

  final SharedPreferences _prefs;
  final RagRepository _ragRepository;
  final Connectivity _connectivity;

  bool _isProcessing = false;
  List<PendingQuery> _pendingQueries = [];
  List<PendingQuery> _failedQueries = [];

  QueryQueueService(this._prefs, this._ragRepository, this._connectivity);

  /// Initialize the queue service
  Future<void> initialize() async {
    await _loadQueueFromStorage();
    _startConnectivityMonitoring();
    print('QueryQueueService initialized with ${_pendingQueries.length} pending queries');
  }

  /// Add a query to the pending queue
  Future<String> queueQuery({
    required String query,
    required String language,
    required Map<String, dynamic> context,
    String? location,
    String? fallbackResultId,
  }) async {
    final pendingQuery = PendingQuery(
      id: _generateQueryId(),
      query: query,
      language: language,
      timestamp: DateTime.now(),
      context: context,
      location: location,
      fallbackResultId: fallbackResultId,
    );

    _pendingQueries.add(pendingQuery);
    await _saveQueueToStorage();

    // Try to process immediately if online
    _tryProcessQueue();

    return pendingQuery.id;
  }

  /// Get the current queue status
  Map<String, dynamic> getQueueStatus() {
    return {
      'pending_count': _pendingQueries.length,
      'failed_count': _failedQueries.length,
      'is_processing': _isProcessing,
      'oldest_pending': _pendingQueries.isNotEmpty ? _pendingQueries.first.timestamp.toIso8601String() : null,
      'total_retry_attempts': _failedQueries.fold<int>(0, (sum, query) => sum + query.retryCount),
    };
  }

  /// Get all pending queries
  List<PendingQuery> getPendingQueries() {
    return List.unmodifiable(_pendingQueries);
  }

  /// Get all failed queries
  List<PendingQuery> getFailedQueries() {
    return List.unmodifiable(_failedQueries);
  }

  /// Manually trigger queue processing
  Future<void> processQueue() async {
    await _tryProcessQueue();
  }

  /// Clear completed and old queries
  Future<void> cleanQueue({Duration maxAge = const Duration(days: 7)}) async {
    final now = DateTime.now();

    // Remove old failed queries
    _failedQueries.removeWhere((query) => now.difference(query.timestamp) > maxAge);

    // Remove expired pending queries
    _pendingQueries.removeWhere((query) => now.difference(query.timestamp) > maxAge);

    await _saveQueueToStorage();
    print('Queue cleaned: ${_pendingQueries.length} pending, ${_failedQueries.length} failed');
  }

  /// Remove a specific query from the queue
  Future<bool> removeQuery(String queryId) async {
    bool removed = false;

    _pendingQueries.removeWhere((q) {
      if (q.id == queryId) {
        removed = true;
        return true;
      }
      return false;
    });

    _failedQueries.removeWhere((q) {
      if (q.id == queryId) {
        removed = true;
        return true;
      }
      return false;
    });

    if (removed) {
      await _saveQueueToStorage();
    }

    return removed;
  }

  /// Retry all failed queries
  Future<void> retryFailedQueries() async {
    if (_failedQueries.isEmpty) return;

    // Move failed queries back to pending with incremented retry count
    final toRetry = _failedQueries.where((q) => q.retryCount < _maxRetryAttempts).toList();

    for (final query in toRetry) {
      final retryQuery = PendingQuery(
        id: query.id,
        query: query.query,
        language: query.language,
        timestamp: DateTime.now(), // Update timestamp for retry
        context: query.context,
        retryCount: query.retryCount + 1,
        status: PendingQueryStatus.pending,
        location: query.location,
        fallbackResultId: query.fallbackResultId,
      );

      _pendingQueries.add(retryQuery);
      _failedQueries.remove(query);
    }

    // Remove queries that exceeded max retry attempts
    _failedQueries.removeWhere((q) => q.retryCount >= _maxRetryAttempts);

    await _saveQueueToStorage();
    await _tryProcessQueue();

    print('Retried ${toRetry.length} failed queries');
  }

  // Private methods

  Future<void> _loadQueueFromStorage() async {
    try {
      // Load pending queries
      final pendingJson = _prefs.getString(_pendingQueriesKey);
      if (pendingJson != null) {
        final List<dynamic> pendingList = json.decode(pendingJson);
        _pendingQueries = pendingList.map((item) => PendingQuery.fromJson(Map<String, dynamic>.from(item))).toList();
      }

      // Load failed queries
      final failedJson = _prefs.getString(_failedQueriesKey);
      if (failedJson != null) {
        final List<dynamic> failedList = json.decode(failedJson);
        _failedQueries = failedList.map((item) => PendingQuery.fromJson(Map<String, dynamic>.from(item))).toList();
      }

      // Clean expired queries on load
      await cleanQueue();
    } catch (e) {
      print('Error loading queue from storage: $e');
      _pendingQueries.clear();
      _failedQueries.clear();
    }
  }

  Future<void> _saveQueueToStorage() async {
    try {
      // Save pending queries
      final pendingJson = json.encode(_pendingQueries.map((q) => q.toJson()).toList());
      await _prefs.setString(_pendingQueriesKey, pendingJson);

      // Save failed queries
      final failedJson = json.encode(_failedQueries.map((q) => q.toJson()).toList());
      await _prefs.setString(_failedQueriesKey, failedJson);
    } catch (e) {
      print('Error saving queue to storage: $e');
    }
  }

  void _startConnectivityMonitoring() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        print('Connection restored, processing queue...');
        _tryProcessQueue();
      }
    });
  }

  Future<void> _tryProcessQueue() async {
    if (_isProcessing || _pendingQueries.isEmpty) {
      return;
    }

    // Check if online
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('No internet connection, queue processing postponed');
      return;
    }

    _isProcessing = true;
    await _prefs.setBool(_processingStatusKey, true);

    try {
      final queriesToProcess = List<PendingQuery>.from(_pendingQueries);
      _pendingQueries.clear(); // Clear the list as we process

      for (final query in queriesToProcess) {
        await _processQuery(query);

        // Small delay between queries to avoid overwhelming the API
        await Future.delayed(const Duration(milliseconds: 500));
      }

      await _saveQueueToStorage();
    } finally {
      _isProcessing = false;
      await _prefs.setBool(_processingStatusKey, false);
    }

    print('Queue processing completed');
  }

  Future<void> _processQuery(PendingQuery query) async {
    try {
      print('Processing query: ${query.query}');

      // Make the actual API call through RAG repository
      final result = await _ragRepository.searchRag(query.query);

      result.fold(
        (failure) => throw Exception('Query failed: $failure'),
        (response) {
          print('Query completed successfully: ${query.id}');
          // Optionally, you can emit an event here to notify UI about the successful processing
        },
      );
      // For now, we just log it
    } catch (e) {
      print('Failed to process query ${query.id}: $e');

      // Move to failed queries if retry limit not exceeded
      if (query.retryCount < _maxRetryAttempts) {
        final failedQuery = PendingQuery(
          id: query.id,
          query: query.query,
          language: query.language,
          timestamp: query.timestamp,
          context: query.context,
          retryCount: query.retryCount + 1,
          status: PendingQueryStatus.failed,
          location: query.location,
          fallbackResultId: query.fallbackResultId,
        );
        _failedQueries.add(failedQuery);
      } else {
        // Mark as expired if max retries exceeded
        print('Query expired after max retries: ${query.id}');
      }
    }
  }

  String _generateQueryId() {
    return 'query_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().hashCode.abs()}';
  }

  /// Get statistics about queue performance
  Map<String, dynamic> getQueueStatistics() {
    final now = DateTime.now();

    // Calculate average queue time for failed queries
    double avgQueueTime = 0.0;
    if (_failedQueries.isNotEmpty) {
      final totalTime = _failedQueries.fold<int>(0, (sum, query) => sum + now.difference(query.timestamp).inMinutes);
      avgQueueTime = totalTime / _failedQueries.length;
    }

    // Calculate retry statistics
    final retryStats = <int, int>{};
    for (final query in _failedQueries) {
      retryStats[query.retryCount] = (retryStats[query.retryCount] ?? 0) + 1;
    }

    return {
      'queue_status': getQueueStatus(),
      'average_queue_time_minutes': avgQueueTime,
      'retry_statistics': retryStats,
      'languages_in_queue': _getAllLanguagesInQueue(),
      'oldest_query_age_hours':
          _pendingQueries.isNotEmpty ? now.difference(_pendingQueries.first.timestamp).inHours : 0,
    };
  }

  Set<String> _getAllLanguagesInQueue() {
    final languages = <String>{};
    languages.addAll(_pendingQueries.map((q) => q.language));
    languages.addAll(_failedQueries.map((q) => q.language));
    return languages;
  }
}

/// Extension methods for PendingQuery to help with queue management
extension PendingQueryExtensions on PendingQuery {
  /// Check if query is eligible for retry
  bool get canRetry => retryCount < 3 && status == PendingQueryStatus.failed;

  /// Check if query has expired
  bool get isExpired {
    final age = DateTime.now().difference(timestamp);
    return age.inDays > 7 || status == PendingQueryStatus.expired;
  }

  /// Get priority score for processing order
  double get priorityScore {
    // Older queries get higher priority
    final ageHours = DateTime.now().difference(timestamp).inHours;

    // Queries with fewer retries get higher priority
    final retryPenalty = retryCount * 10;

    return ageHours.toDouble() - retryPenalty;
  }
}
