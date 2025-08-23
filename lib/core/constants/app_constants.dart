/// AppConstants class implementation
class AppConstants {
  // API Configuration
  static const String defaultRagApiUrl = 'https://api.example.com/rag';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;

  // Database Configuration
  static const String databaseName = 'duacopilot.db';
  static const int databaseVersion = 1;

  // Cache Configuration
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheEntries = 1000;

  // Audio Configuration
  static const List<String> supportedAudioFormats = [
    'mp3',
    'wav',
    'aac',
    'm4a',
  ];
  static const int maxDownloadConcurrency = 3;

  // Background Task Configuration
  static const String syncTaskName = 'cache_sync_task';
  static const String audioDownloadTaskName = 'audio_download_task';
  static const Duration backgroundSyncInterval = Duration(hours: 6);

  // UI Configuration
  static const int searchDebounceMs = 500;
  static const int itemsPerPage = 20;

  // Storage Keys
  static const String lastSyncKey = 'last_sync_timestamp';
  static const String userPreferencesKey = 'user_preferences';
  static const String apiTokenKey = 'api_token';
  static const String ragApiUrlKey = 'rag_api_url';
}

/// ErrorMessages class implementation
class ErrorMessages {
  static const String networkError = 'Network connection failed';
  static const String serverError = 'Server error occurred';
  static const String cacheError = 'Local storage error';
  static const String validationError = 'Invalid input provided';
  static const String authenticationError = 'Authentication failed';
  static const String permissionError = 'Permission denied';
  static const String unexpectedError = 'An unexpected error occurred';

  // RAG specific errors
  static const String ragApiNotConfigured = 'RAG API not configured';
  static const String ragQueryEmpty = 'Query cannot be empty';
  static const String ragResponseEmpty = 'No response from RAG API';

  // Audio specific errors
  static const String audioDownloadFailed = 'Audio download failed';
  static const String audioFormatNotSupported = 'Audio format not supported';
  static const String audioFileNotFound = 'Audio file not found';
}

/// AppStrings class implementation
class AppStrings {
  static const String appName = 'DuaCopilot';
  static const String searchHint = 'Ask me anything...';
  static const String noResults = 'No results found';
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String favorites = 'Favorites';
  static const String history = 'History';
  static const String settings = 'Settings';
  static const String offline = 'Offline';
  static const String online = 'Online';
}
