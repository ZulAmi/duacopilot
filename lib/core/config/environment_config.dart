import 'dart:io';

import 'package:flutter/foundation.dart';

/// Secure Environment Configuration Manager
/// Handles API keys and sensitive configuration without exposing in code
class EnvironmentConfig {
  static const String _envFile = '.env';
  static final Map<String, String> _cache = {};

  /// Initialize environment configuration
  static Future<void> initialize() async {
    if (kIsWeb) return; // Skip for web platform

    try {
      final file = File(_envFile);
      if (await file.exists()) {
        final contents = await file.readAsString();
        _parseEnvFile(contents);
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Environment file not found or could not be read: $e');
        print('💡 Create a .env file with your API keys for local development');
      }
    }
  }

  /// Parse environment file contents
  static void _parseEnvFile(String contents) {
    final lines = contents.split('\n');
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

      final parts = trimmed.split('=');
      if (parts.length >= 2) {
        final key = parts[0].trim();
        final value = parts.sublist(1).join('=').trim();
        _cache[key] = value;
      }
    }
  }

  /// Get environment variable value
  static String? get(String key) {
    // Try cache first
    if (_cache.containsKey(key)) {
      return _cache[key];
    }

    // Try platform environment variables
    return Platform.environment[key];
  }

  /// Get OpenAI API key
  static String? get openAiApiKey => get('OPENAI_API_KEY');

  /// Get Claude API key
  static String? get claudeApiKey => get('CLAUDE_API_KEY');

  /// Get Gemini API key
  static String? get geminiApiKey => get('GEMINI_API_KEY');

  /// Get HuggingFace API key
  static String? get huggingFaceApiKey => get('HUGGINGFACE_API_KEY');

  /// Check if API key is configured for provider
  static bool hasApiKeyForProvider(String provider) {
    switch (provider.toLowerCase()) {
      case 'openai':
        return openAiApiKey?.isNotEmpty == true;
      case 'claude':
        return claudeApiKey?.isNotEmpty == true;
      case 'gemini':
        return geminiApiKey?.isNotEmpty == true;
      case 'huggingface':
        return huggingFaceApiKey?.isNotEmpty == true;
      case 'ollama':
        return true; // Local model, no API key needed
      default:
        return false;
    }
  }

  /// Get debug mode setting
  static bool get debugMode => get('DEBUG_MODE')?.toLowerCase() == 'true';

  /// Get log level
  static String get logLevel => get('LOG_LEVEL') ?? 'info';
}
