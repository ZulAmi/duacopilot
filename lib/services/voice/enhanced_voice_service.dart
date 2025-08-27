import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../core/logging/app_logger.dart';
import '../../domain/entities/conversation_entity.dart';
import '../secure_storage/secure_storage_service.dart';

/// Enhanced voice service with sophisticated Arabic support and multilingual capabilities
/// Provides high-quality speech-to-text with contextual awareness for Islamic queries
class EnhancedVoiceService {
  static EnhancedVoiceService? _instance;
  static EnhancedVoiceService get instance => _instance ??= EnhancedVoiceService._();

  EnhancedVoiceService._();

  // Core services
  late stt.SpeechToText _speechToText;
  late SecureStorageService _secureStorage;

  // Configuration
  static const Duration _listeningTimeout = Duration(seconds: 30);
  static const Duration _pauseTimeout = Duration(seconds: 3);
  static const double _confidenceThreshold = 0.7;

  // Supported languages with Islamic context
  static const Map<String, String> _supportedLanguages = {
    'en-US': 'English',
    'ar-SA': 'Arabic (Saudi Arabia)',
    'ar-EG': 'Arabic (Egypt)',
    'ar-AE': 'Arabic (UAE)',
    'ur-PK': 'Urdu (Pakistan)',
    'ur-IN': 'Urdu (India)',
    'id-ID': 'Indonesian',
    'ms-MY': 'Malay',
    'tr-TR': 'Turkish',
    'fa-IR': 'Persian',
    'bn-BD': 'Bengali (Bangladesh)',
    'hi-IN': 'Hindi',
  };

  // State management
  bool _isInitialized = false;
  bool _isListening = false;
  bool _hasPermission = false;
  String _currentLanguage = 'en-US';
  String _preferredLanguage = 'en-US';

  // Stream controllers
  final _voiceStatusController = StreamController<VoiceStatus>.broadcast();
  final _voiceResultController = StreamController<VoiceQueryResult>.broadcast();
  final _languageDetectionController = StreamController<LanguageDetection>.broadcast();

  // Public streams
  Stream<VoiceStatus> get voiceStatusStream => _voiceStatusController.stream;
  Stream<VoiceQueryResult> get voiceResultStream => _voiceResultController.stream;
  Stream<LanguageDetection> get languageDetectionStream => _languageDetectionController.stream;

  // Arabic language processing
  final _arabicPreprocessor = ArabicTextPreprocessor();
  final _islamicTermsEnhancer = IslamicTermsEnhancer();

  /// Initialize voice service with permissions and language setup
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('Initializing Enhanced Voice Service...');

      _speechToText = stt.SpeechToText();
      _secureStorage = SecureStorageService.instance;

      // Request microphone permission
      await _requestPermissions();

      // Initialize speech recognition
      final isAvailable = await _speechToText.initialize(
        onError: _onSpeechError,
        onStatus: _onSpeechStatus,
        debugLogging: kDebugMode,
      );

      if (!isAvailable) {
        throw Exception('Speech recognition not available on this device');
      }

      // Load user preferences
      await _loadUserPreferences();

      // Detect available languages
      await _detectAvailableLanguages();

      _isInitialized = true;
      AppLogger.info('Enhanced Voice Service initialized successfully');

      _voiceStatusController.add(VoiceStatus.ready);
    } catch (e) {
      AppLogger.error('Failed to initialize Enhanced Voice Service: $e');
      _voiceStatusController.add(VoiceStatus.error(e.toString()));
      throw Exception('Voice service initialization failed');
    }
  }

  /// Start sophisticated voice listening with Arabic support
  Future<void> startListening({
    String? language,
    bool enableArabicEnhancements = true,
    bool enableIslamicTerms = true,
    Duration? timeout,
  }) async {
    await _ensureInitialized();

    if (!_hasPermission) {
      await _requestPermissions();
    }

    if (!_hasPermission) {
      throw Exception('Microphone permission not granted');
    }

    if (_isListening) {
      await stopListening();
    }

    try {
      final selectedLanguage = language ?? _preferredLanguage;

      AppLogger.info('Starting voice listening in language: $selectedLanguage');

      _isListening = true;
      _currentLanguage = selectedLanguage;

      _voiceStatusController.add(VoiceStatus.listening);

      await _speechToText.listen(
        onResult: (result) => _onSpeechResult(
          result,
          enableArabicEnhancements: enableArabicEnhancements,
          enableIslamicTerms: enableIslamicTerms,
        ),
        listenFor: timeout ?? _listeningTimeout,
        pauseFor: _pauseTimeout,
        listenOptions: stt.SpeechListenOptions(
          partialResults: true,
          cancelOnError: false,
          listenMode: stt.ListenMode.confirmation,
        ),
        localeId: selectedLanguage,
        onSoundLevelChange: _onSoundLevelChange,
      );

      // Start language detection if auto-detect is enabled
      if (language == null) {
        _startLanguageDetection();
      }
    } catch (e) {
      AppLogger.error('Failed to start voice listening: $e');
      _isListening = false;
      _voiceStatusController.add(VoiceStatus.error(e.toString()));
      rethrow;
    }
  }

  /// Stop voice listening
  Future<void> stopListening() async {
    if (!_isListening) return;

    try {
      await _speechToText.stop();
      _isListening = false;
      _voiceStatusController.add(VoiceStatus.stopped);

      AppLogger.info('Voice listening stopped');
    } catch (e) {
      AppLogger.error('Error stopping voice listening: $e');
      _voiceStatusController.add(VoiceStatus.error(e.toString()));
    }
  }

  /// Cancel current voice listening
  Future<void> cancelListening() async {
    if (!_isListening) return;

    try {
      await _speechToText.cancel();
      _isListening = false;
      _voiceStatusController.add(VoiceStatus.cancelled);

      AppLogger.info('Voice listening cancelled');
    } catch (e) {
      AppLogger.error('Error cancelling voice listening: $e');
      _voiceStatusController.add(VoiceStatus.error(e.toString()));
    }
  }

  /// Get available languages on device
  Future<List<stt.LocaleName>> getAvailableLanguages() async {
    await _ensureInitialized();

    try {
      final locales = await _speechToText.locales();

      // Filter to supported languages
      return locales.where((locale) => _supportedLanguages.containsKey(locale.localeId)).toList();
    } catch (e) {
      AppLogger.error('Failed to get available languages: $e');
      return [];
    }
  }

  /// Set preferred language
  Future<void> setPreferredLanguage(String languageCode) async {
    await _ensureInitialized();

    if (!_supportedLanguages.containsKey(languageCode)) {
      throw Exception('Unsupported language: $languageCode');
    }

    _preferredLanguage = languageCode;
    await _saveUserPreferences();

    AppLogger.info('Preferred language set to: $languageCode');
  }

  /// Check if currently listening
  bool get isListening => _isListening;

  /// Check if service has microphone permission
  bool get hasPermission => _hasPermission;

  /// Get current language
  String get currentLanguage => _currentLanguage;

  /// Get preferred language
  String get preferredLanguage => _preferredLanguage;

  /// Get supported languages
  Map<String, String> get supportedLanguages => _supportedLanguages;

  // Private helper methods

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  Future<void> _requestPermissions() async {
    try {
      final status = await Permission.microphone.request();
      _hasPermission = status == PermissionStatus.granted;

      if (!_hasPermission) {
        AppLogger.warning('Microphone permission not granted');
      }
    } catch (e) {
      AppLogger.error('Error requesting microphone permission: $e');
      _hasPermission = false;
    }
  }

  Future<void> _loadUserPreferences() async {
    try {
      final savedLanguage = await _secureStorage.read(
        'preferred_voice_language',
      );
      if (savedLanguage != null && _supportedLanguages.containsKey(savedLanguage)) {
        _preferredLanguage = savedLanguage;
      }
      AppLogger.debug('Loaded preferred language: $_preferredLanguage');
    } catch (e) {
      AppLogger.warning('Failed to load user preferences: $e');
    }
  }

  Future<void> _saveUserPreferences() async {
    try {
      await _secureStorage.write(
        'preferred_voice_language',
        _preferredLanguage,
      );
    } catch (e) {
      AppLogger.error('Failed to save user preferences: $e');
    }
  }

  Future<void> _detectAvailableLanguages() async {
    try {
      final locales = await _speechToText.locales();
      final availableSupported = locales
          .where(
            (locale) => _supportedLanguages.containsKey(locale.localeId),
          )
          .map((locale) => locale.localeId)
          .toList();

      AppLogger.info('Available supported languages: $availableSupported');

      // Auto-select best language if preferred not available
      if (!availableSupported.contains(_preferredLanguage)) {
        if (availableSupported.contains('en-US')) {
          _preferredLanguage = 'en-US';
        } else if (availableSupported.isNotEmpty) {
          _preferredLanguage = availableSupported.first;
        }
      }
    } catch (e) {
      AppLogger.warning('Failed to detect available languages: $e');
    }
  }

  void _startLanguageDetection() {
    // This would implement real-time language detection
    // For now, we'll use a simple heuristic based on speech patterns
  }

  void _onSpeechResult(
    dynamic result, {
    bool enableArabicEnhancements = true,
    bool enableIslamicTerms = true,
  }) async {
    try {
      var transcription = result.recognizedWords as String;
      final confidence = result.confidence as double;
      final alternatives = (result.alternates as List<dynamic>).map((alt) => alt.recognizedWords as String).toList();

      AppLogger.debug(
        'Raw transcription: $transcription (confidence: $confidence)',
      );

      // Apply Arabic text preprocessing if enabled
      if (enableArabicEnhancements && _isArabicLanguage(_currentLanguage)) {
        transcription = _arabicPreprocessor.processText(transcription);
      }

      // Apply Islamic terms enhancement
      if (enableIslamicTerms) {
        transcription = _islamicTermsEnhancer.enhanceText(
          transcription,
          _currentLanguage,
        );
      }

      // Detect if text contains Arabic
      final containsArabic = _containsArabic(transcription);

      // Auto-detect language if different from current
      final detectedLanguage = await _detectLanguage(transcription);
      if (detectedLanguage != _currentLanguage) {
        _languageDetectionController.add(
          LanguageDetection(
            detectedLanguage: detectedLanguage,
            confidence: confidence,
            originalLanguage: _currentLanguage,
          ),
        );
      }

      final voiceResult = VoiceQueryResult(
        transcription: transcription,
        confidence: confidence,
        detectedLanguage: detectedLanguage,
        duration: Duration(
          milliseconds: result.finalResult ? 0 : 100,
        ), // Approximate
        containsArabic: containsArabic,
        alternatives: alternatives,
        audioMetadata: {
          'is_final': result.finalResult,
          'has_confidence_rating': result.hasConfidenceRating,
          'confidence_rating': confidence,
          'original_language': _currentLanguage,
          'processing_time': DateTime.now().millisecondsSinceEpoch,
        },
      );

      _voiceResultController.add(voiceResult);

      if (result.finalResult && confidence >= _confidenceThreshold) {
        AppLogger.info('Final voice result: $transcription');
        await stopListening();
      }
    } catch (e) {
      AppLogger.error('Error processing speech result: $e');
    }
  }

  void _onSpeechError(dynamic error) {
    final errorMsg = error.errorMsg as String? ?? 'Unknown speech error';
    AppLogger.error('Speech recognition error: $errorMsg');
    _isListening = false;
    _voiceStatusController.add(VoiceStatus.error(errorMsg));
  }

  void _onSpeechStatus(String status) {
    AppLogger.debug('Speech recognition status: $status');

    switch (status) {
      case 'listening':
        _voiceStatusController.add(VoiceStatus.listening);
        break;
      case 'notListening':
        if (_isListening) {
          _isListening = false;
          _voiceStatusController.add(VoiceStatus.stopped);
        }
        break;
      case 'done':
        _isListening = false;
        _voiceStatusController.add(VoiceStatus.completed);
        break;
    }
  }

  void _onSoundLevelChange(double level) {
    _voiceStatusController.add(VoiceStatus.soundLevel(level));
  }

  bool _isArabicLanguage(String languageCode) {
    return languageCode.startsWith('ar-');
  }

  bool _containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  Future<String> _detectLanguage(String text) async {
    // Simple language detection based on script and common words
    if (_containsArabic(text)) {
      return 'ar-SA';
    }

    // Urdu detection (uses Arabic script but has distinct patterns)
    // Urdu common particles (previously garbled encoded): کے، میں، ہے
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(text) &&
        (text.contains('کے') || text.contains('میں') || text.contains('ہے'))) {
      return 'ur-PK';
    }

    // Persian detection
    // Persian common words (previously garbled encoded): در، است، که
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(text) &&
        (text.contains('در') || text.contains('است') || text.contains('که'))) {
      return 'fa-IR';
    }

    // Default to current language
    return _currentLanguage;
  }

  /// Cleanup resources
  void dispose() {
    _voiceStatusController.close();
    _voiceResultController.close();
    _languageDetectionController.close();
  }
}

/// Voice status states
abstract class VoiceStatus {
  const VoiceStatus();

  static const VoiceStatus ready = _ReadyStatus();
  static const VoiceStatus listening = _ListeningStatus();
  static const VoiceStatus stopped = _StoppedStatus();
  static const VoiceStatus completed = _CompletedStatus();
  static const VoiceStatus cancelled = _CancelledStatus();

  static VoiceStatus error(String message) => _ErrorStatus(message);
  static VoiceStatus soundLevel(double level) => _SoundLevelStatus(level);
}

class _ReadyStatus extends VoiceStatus {
  const _ReadyStatus();
}

class _ListeningStatus extends VoiceStatus {
  const _ListeningStatus();
}

class _StoppedStatus extends VoiceStatus {
  const _StoppedStatus();
}

class _CompletedStatus extends VoiceStatus {
  const _CompletedStatus();
}

class _CancelledStatus extends VoiceStatus {
  const _CancelledStatus();
}

class _ErrorStatus extends VoiceStatus {
  final String message;
  const _ErrorStatus(this.message);
}

class _SoundLevelStatus extends VoiceStatus {
  final double level;
  const _SoundLevelStatus(this.level);
}

/// Language detection result
class LanguageDetection {
  final String detectedLanguage;
  final double confidence;
  final String originalLanguage;

  LanguageDetection({
    required this.detectedLanguage,
    required this.confidence,
    required this.originalLanguage,
  });
}

/// Arabic text preprocessor for better recognition
class ArabicTextPreprocessor {
  /// Process Arabic text with diacritics normalization and cleaning
  String processText(String text) {
    var processed = text;

    // Remove diacritics for better matching
    processed = processed.replaceAll(RegExp(r'[\u064B-\u0652]'), '');

    // Normalize Arabic letters
    // Normalize mis-encoded Arabic letters to their base forms
    // (previously stored as garbled bytes like Ø£ -> أ)
    processed = processed.replaceAll('أ', 'ا').replaceAll('إ', 'ا').replaceAll('آ', 'ا').replaceAll('ة', 'ه');

    // Clean extra whitespace
    processed = processed.replaceAll(RegExp(r'\s+'), ' ').trim();

    return processed;
  }
}

/// Islamic terms enhancer for better context understanding
class IslamicTermsEnhancer {
  /// Common Islamic terms and their variations/corrections
  static const Map<String, List<String>> _islamicTerms = {
    // Corrected previously garbled Arabic variants
    'Allah': ['Allah', 'الله', 'الله'],
    'Muhammad': ['Muhammad', 'محمد', 'Prophet Muhammad'],
    'Quran': ['Quran', 'القرآن', 'Holy Quran'],
    'Salah': ['Salah', 'صلاة', 'Prayer'],
    'Dua': ['Dua', 'دعاء', 'Supplication'],
    'Dhikr': ['Dhikr', 'ذکر', 'Remembrance'],
    'Hajj': ['Hajj', 'حج', 'Pilgrimage'],
    'Ramadan': ['Ramadan', 'رمضان'],
    'Bismillah': ['Bismillah', 'بسم الله'],
    'Alhamdulillah': ['Alhamdulillah', 'الحمد لله'],
    'SubhanAllah': ['SubhanAllah', 'سبحان الله'],
    'Astaghfirullah': ['Astaghfirullah', 'استغفر الله'],
  };

  /// Enhance text with proper Islamic term recognition
  String enhanceText(String text, String language) {
    var enhanced = text;

    // Apply language-specific enhancements
    if (language.startsWith('ar-')) {
      enhanced = _enhanceArabicTerms(enhanced);
    } else if (language.startsWith('ur-')) {
      enhanced = _enhanceUrduTerms(enhanced);
    } else {
      enhanced = _enhanceEnglishTerms(enhanced);
    }

    return enhanced;
  }

  String _enhanceArabicTerms(String text) {
    // Apply Arabic-specific Islamic term corrections
    var enhanced = text;

    _islamicTerms.forEach((canonical, variations) {
      for (final variation in variations) {
        if (variation != canonical) {
          enhanced = enhanced.replaceAll(variation, canonical);
        }
      }
    });

    return enhanced;
  }

  String _enhanceUrduTerms(String text) {
    // Apply Urdu-specific Islamic term corrections
    return text; // Placeholder for Urdu enhancements
  }

  String _enhanceEnglishTerms(String text) {
    // Apply English Islamic term corrections and common mistakes
    var enhanced = text.toLowerCase();

    final corrections = {
      'inshallah': 'Inshallah',
      'mashallah': 'Mashallah',
      'subhanallah': 'SubhanAllah',
      'alhamdulillah': 'Alhamdulillah',
      'astaghfirullah': 'Astaghfirullah',
      'bismillah': 'Bismillah',
    };

    corrections.forEach((incorrect, correct) {
      enhanced = enhanced.replaceAll(incorrect, correct);
    });

    return enhanced;
  }
}
