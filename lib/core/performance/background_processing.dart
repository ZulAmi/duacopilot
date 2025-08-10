import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import '../../domain/entities/rag_response.dart';

/// Background processing utility for heavy text processing in RAG responses
class RagBackgroundProcessor {
  static final Map<String, Isolate> _activeIsolates = {};
  static final Map<String, ReceivePort> _receivePorts = {};
  static final Map<String, SendPort> _sendPorts = {};

  /// Process large text content in background isolate
  static Future<ProcessedTextResult> processLargeText({
    required String text,
    required TextProcessingOptions options,
    String? isolateId,
  }) async {
    try {
      final result = await compute(
        _processTextInIsolate,
        TextProcessingTask(text: text, options: options),
      );

      return result;
    } catch (e) {
      debugPrint('Text processing failed: $e');
      return ProcessedTextResult(
        originalText: text,
        processedText: text,
        wordCount: text.split(' ').length,
        characterCount: text.length,
        arabicWordCount: 0,
        englishWordCount: 0,
        sentences: [text],
        keywords: [],
        processingTime: Duration.zero,
        error: e.toString(),
      );
    }
  }

  /// Process multiple RAG responses in parallel
  static Future<List<ProcessedRagResponse>> processRagResponses({
    required List<RagResponse> responses,
    required RagProcessingOptions options,
    int? maxConcurrentTasks,
  }) async {
    final concurrency = maxConcurrentTasks ?? _getOptimalConcurrency();
    final results = <ProcessedRagResponse>[];

    // Process responses in batches to avoid overwhelming the system
    for (int i = 0; i < responses.length; i += concurrency) {
      final batch = responses.skip(i).take(concurrency).toList();
      final batchResults = await Future.wait(
        batch.map(
          (response) => _processRagResponseInIsolate(response, options),
        ),
      );
      results.addAll(batchResults);
    }

    return results;
  }

  /// Extract keywords from text using background processing
  static Future<List<String>> extractKeywords({
    required String text,
    int maxKeywords = 10,
    double minRelevanceScore = 0.3,
  }) async {
    return await compute(
      _extractKeywordsInIsolate,
      KeywordExtractionTask(
        text: text,
        maxKeywords: maxKeywords,
        minRelevanceScore: minRelevanceScore,
      ),
    );
  }

  /// Analyze text sentiment in background
  static Future<SentimentAnalysisResult> analyzeSentiment({
    required String text,
    required String language,
  }) async {
    return await compute(
      _analyzeSentimentInIsolate,
      SentimentAnalysisTask(text: text, language: language),
    );
  }

  /// Create persistent isolate for long-running tasks
  static Future<String> createPersistentIsolate({
    required String isolateId,
    required Function entryPoint,
  }) async {
    if (_activeIsolates.containsKey(isolateId)) {
      return isolateId; // Already exists
    }

    final receivePort = ReceivePort();
    _receivePorts[isolateId] = receivePort;

    final isolate = await Isolate.spawn(
      _persistentIsolateEntryPoint,
      receivePort.sendPort,
    );

    _activeIsolates[isolateId] = isolate;

    // Wait for isolate to send its SendPort
    final sendPort = await receivePort.first as SendPort;
    _sendPorts[isolateId] = sendPort;

    return isolateId;
  }

  /// Send task to persistent isolate
  static Future<T> sendTaskToPersistentIsolate<T>({
    required String isolateId,
    required Map<String, dynamic> taskData,
  }) async {
    final sendPort = _sendPorts[isolateId];
    if (sendPort == null) {
      throw StateError('Isolate $isolateId not found');
    }

    final responsePort = ReceivePort();
    sendPort.send({'task': taskData, 'responsePort': responsePort.sendPort});

    final result = await responsePort.first;
    responsePort.close();

    return result as T;
  }

  /// Terminate persistent isolate
  static Future<void> terminateIsolate(String isolateId) async {
    final isolate = _activeIsolates[isolateId];
    final receivePort = _receivePorts[isolateId];

    if (isolate != null) {
      isolate.kill(priority: Isolate.immediate);
      _activeIsolates.remove(isolateId);
    }

    if (receivePort != null) {
      receivePort.close();
      _receivePorts.remove(isolateId);
    }

    _sendPorts.remove(isolateId);
  }

  /// Terminate all active isolates
  static Future<void> terminateAllIsolates() async {
    final isolateIds = List<String>.from(_activeIsolates.keys);
    for (final id in isolateIds) {
      await terminateIsolate(id);
    }
  }

  /// Get optimal concurrency based on platform
  static int _getOptimalConcurrency() {
    if (kIsWeb) {
      return 2; // Limited for web
    } else if (Platform.isIOS || Platform.isAndroid) {
      return 3; // Conservative for mobile
    } else {
      return 4; // More aggressive for desktop
    }
  }

  /// Entry point for persistent isolates
  static void _persistentIsolateEntryPoint(SendPort mainSendPort) {
    final receivePort = ReceivePort();
    mainSendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      final taskData = message['task'] as Map<String, dynamic>;
      final responsePort = message['responsePort'] as SendPort;

      try {
        final result = _processPersistentTask(taskData);
        responsePort.send(result);
      } catch (e) {
        responsePort.send({'error': e.toString()});
      }
    });
  }

  /// Process task in persistent isolate
  static dynamic _processPersistentTask(Map<String, dynamic> taskData) {
    final taskType = taskData['type'] as String;

    switch (taskType) {
      case 'textAnalysis':
        return _analyzeTextTask(taskData);
      case 'jsonParsing':
        return _parseJsonTask(taskData);
      case 'encryption':
        return _encryptionTask(taskData);
      default:
        throw UnimplementedError('Task type $taskType not supported');
    }
  }

  static Map<String, dynamic> _analyzeTextTask(Map<String, dynamic> taskData) {
    final text = taskData['text'] as String;
    // Implement text analysis logic
    return {
      'wordCount': text.split(' ').length,
      'characterCount': text.length,
      'sentiment': 'neutral', // Placeholder
    };
  }

  static Map<String, dynamic> _parseJsonTask(Map<String, dynamic> taskData) {
    final jsonString = taskData['json'] as String;
    return json.decode(jsonString);
  }

  static Map<String, dynamic> _encryptionTask(Map<String, dynamic> taskData) {
    final data = taskData['data'] as String;
    // Implement encryption logic
    return {'encrypted': base64Encode(utf8.encode(data))};
  }

  /// Process RAG response in isolate
  static Future<ProcessedRagResponse> _processRagResponseInIsolate(
    RagResponse response,
    RagProcessingOptions options,
  ) async {
    return await compute(
      _processRagResponse,
      RagProcessingTask(response: response, options: options),
    );
  }
}

/// Process text in isolate (top-level function required for compute)
ProcessedTextResult _processTextInIsolate(TextProcessingTask task) {
  final stopwatch = Stopwatch()..start();

  try {
    final text = task.text;
    final options = task.options;

    // Word counting
    final words = text.split(RegExp(r'\s+'));
    final wordCount = words.length;

    // Character counting
    final characterCount = text.length;

    // Language-specific word counting
    final arabicWords = words.where(
      (word) => RegExp(r'[\u0600-\u06FF]').hasMatch(word),
    );
    final englishWords = words.where(
      (word) => RegExp(r'[a-zA-Z]').hasMatch(word),
    );

    // Sentence splitting
    final sentences =
        text
            .split(RegExp(r'[.!?]+'))
            .where((s) => s.trim().isNotEmpty)
            .map((s) => s.trim())
            .toList();

    // Simple keyword extraction
    final keywords = _extractSimpleKeywords(text, options.maxKeywords);

    stopwatch.stop();

    return ProcessedTextResult(
      originalText: text,
      processedText:
          options.removeExtraSpaces ? _removeExtraSpaces(text) : text,
      wordCount: wordCount,
      characterCount: characterCount,
      arabicWordCount: arabicWords.length,
      englishWordCount: englishWords.length,
      sentences: sentences,
      keywords: keywords,
      processingTime: stopwatch.elapsed,
    );
  } catch (e) {
    stopwatch.stop();
    return ProcessedTextResult(
      originalText: task.text,
      processedText: task.text,
      wordCount: 0,
      characterCount: 0,
      arabicWordCount: 0,
      englishWordCount: 0,
      sentences: [],
      keywords: [],
      processingTime: stopwatch.elapsed,
      error: e.toString(),
    );
  }
}

/// Extract keywords in isolate
List<String> _extractKeywordsInIsolate(KeywordExtractionTask task) {
  return _extractSimpleKeywords(task.text, task.maxKeywords);
}

/// Analyze sentiment in isolate
SentimentAnalysisResult _analyzeSentimentInIsolate(SentimentAnalysisTask task) {
  // Simple sentiment analysis implementation
  final text = task.text.toLowerCase();

  // Basic positive/negative word lists (simplified)
  final positiveWords = ['good', 'great', 'excellent', 'amazing', 'wonderful'];
  final negativeWords = [
    'bad',
    'terrible',
    'awful',
    'horrible',
    'disappointing',
  ];

  int positiveCount = 0;
  int negativeCount = 0;

  for (final word in positiveWords) {
    positiveCount += word.allMatches(text).length;
  }

  for (final word in negativeWords) {
    negativeCount += word.allMatches(text).length;
  }

  double score = 0.0;
  String sentiment = 'neutral';

  if (positiveCount > negativeCount) {
    score = (positiveCount / (positiveCount + negativeCount + 1));
    sentiment = 'positive';
  } else if (negativeCount > positiveCount) {
    score = -(negativeCount / (positiveCount + negativeCount + 1));
    sentiment = 'negative';
  }

  return SentimentAnalysisResult(
    sentiment: sentiment,
    score: score,
    confidence: (positiveCount + negativeCount) / 10.0, // Simplified confidence
  );
}

/// Process RAG response
ProcessedRagResponse _processRagResponse(RagProcessingTask task) {
  final response = task.response;
  final options = task.options;

  final textResult = _processTextInIsolate(
    TextProcessingTask(
      text: response.response,
      options: TextProcessingOptions(
        maxKeywords: options.extractKeywords ? 5 : 0,
        removeExtraSpaces: options.normalizeText,
      ),
    ),
  );

  SentimentAnalysisResult? sentiment;
  if (options.analyzeSentiment) {
    sentiment = _analyzeSentimentInIsolate(
      SentimentAnalysisTask(
        text: response.response,
        language: 'en', // Default to English
      ),
    );
  }

  return ProcessedRagResponse(
    originalResponse: response,
    textAnalysis: textResult,
    sentiment: sentiment,
    processingTime: DateTime.now(),
  );
}

/// Helper functions
List<String> _extractSimpleKeywords(String text, int maxKeywords) {
  final words =
      text
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s]'), '')
          .split(RegExp(r'\s+'))
          .where((word) => word.length > 3) // Only words longer than 3 chars
          .toList();

  // Count word frequency
  final wordCount = <String, int>{};
  for (final word in words) {
    wordCount[word] = (wordCount[word] ?? 0) + 1;
  }

  // Sort by frequency and return top keywords
  final sortedWords =
      wordCount.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

  return sortedWords.take(maxKeywords).map((e) => e.key).toList();
}

String _removeExtraSpaces(String text) {
  return text.replaceAll(RegExp(r'\s+'), ' ').trim();
}

/// Data classes for background processing
class TextProcessingTask {
  final String text;
  final TextProcessingOptions options;

  const TextProcessingTask({required this.text, required this.options});
}

class TextProcessingOptions {
  final int maxKeywords;
  final bool removeExtraSpaces;
  final bool extractSentences;

  const TextProcessingOptions({
    this.maxKeywords = 10,
    this.removeExtraSpaces = true,
    this.extractSentences = true,
  });
}

class ProcessedTextResult {
  final String originalText;
  final String processedText;
  final int wordCount;
  final int characterCount;
  final int arabicWordCount;
  final int englishWordCount;
  final List<String> sentences;
  final List<String> keywords;
  final Duration processingTime;
  final String? error;

  const ProcessedTextResult({
    required this.originalText,
    required this.processedText,
    required this.wordCount,
    required this.characterCount,
    required this.arabicWordCount,
    required this.englishWordCount,
    required this.sentences,
    required this.keywords,
    required this.processingTime,
    this.error,
  });
}

class KeywordExtractionTask {
  final String text;
  final int maxKeywords;
  final double minRelevanceScore;

  const KeywordExtractionTask({
    required this.text,
    required this.maxKeywords,
    required this.minRelevanceScore,
  });
}

class SentimentAnalysisTask {
  final String text;
  final String language;

  const SentimentAnalysisTask({required this.text, required this.language});
}

class SentimentAnalysisResult {
  final String sentiment;
  final double score;
  final double confidence;

  const SentimentAnalysisResult({
    required this.sentiment,
    required this.score,
    required this.confidence,
  });
}

class RagProcessingTask {
  final RagResponse response;
  final RagProcessingOptions options;

  const RagProcessingTask({required this.response, required this.options});
}

class RagProcessingOptions {
  final bool extractKeywords;
  final bool analyzeSentiment;
  final bool normalizeText;
  final bool extractEntities;

  const RagProcessingOptions({
    this.extractKeywords = true,
    this.analyzeSentiment = false,
    this.normalizeText = true,
    this.extractEntities = false,
  });
}

class ProcessedRagResponse {
  final RagResponse originalResponse;
  final ProcessedTextResult textAnalysis;
  final SentimentAnalysisResult? sentiment;
  final DateTime processingTime;

  const ProcessedRagResponse({
    required this.originalResponse,
    required this.textAnalysis,
    this.sentiment,
    required this.processingTime,
  });
}
