// AWS Backend Configuration for Flutter App
// This will replace your current hardcoded URLs

class AWSConfig {
  // These will be set after AWS deployment
  static const String _awsApiUrl = String.fromEnvironment(
    'AWS_API_URL',
    defaultValue: 'https://YOUR-API-ID.execute-api.us-east-1.amazonaws.com/prod',
  );

  static const String _awsWebSocketUrl = String.fromEnvironment(
    'AWS_WS_URL',
    defaultValue: 'wss://YOUR-WS-ID.execute-api.us-east-1.amazonaws.com/prod',
  );

  // API Endpoints for AWS Lambda
  static String get baseUrl => _awsApiUrl;

  // AI Services
  static String get aiChat => '$baseUrl/api/v1/ai/chat';
  static String get classifyIntent => '$baseUrl/api/v1/ai/intent';
  static String get generateEmbeddings => '$baseUrl/api/v1/ai/embeddings';

  // Authentication
  static String get register => '$baseUrl/api/v1/auth/register';
  static String get login => '$baseUrl/api/v1/auth/login';
  static String get updateLastLogin => '$baseUrl/api/v1/auth/update-login';

  // Islamic Content
  static String get getDuas => '$baseUrl/api/v1/content/duas';
  static String get searchQuran => '$baseUrl/api/v1/content/quran';
  static String get getPrayerTimes => '$baseUrl/api/v1/content/prayer-times';
  static String get getQiblaDirection => '$baseUrl/api/v1/content/qibla';

  // Analytics
  static String get logEvent => '$baseUrl/api/v1/analytics/event';
  static String get getUserAnalytics => '$baseUrl/api/v1/analytics/user';

  // Notifications
  static String get sendNotification => '$baseUrl/api/v1/notifications/send';
  static String get updateFcmToken => '$baseUrl/api/v1/notifications/token';

  // WebSocket & Real-time
  static String get webSocket => _awsWebSocketUrl;
  static String get serverSentEvents => '$baseUrl/api/v1/events/stream';

  // Health Check
  static String get health => '$baseUrl/api/v1/health';

  // Configuration for different stages
  static Map<String, String> getStageConfig(String stage) {
    switch (stage.toLowerCase()) {
      case 'production':
        return {
          'apiBaseUrl': _awsApiUrl.replaceAll('/prod', '/production'),
          'websocketUrl': _awsWebSocketUrl.replaceAll('/prod', '/production'),
          'stage': 'production',
        };
      case 'staging':
        return {
          'apiBaseUrl': _awsApiUrl.replaceAll('/prod', '/staging'),
          'websocketUrl': _awsWebSocketUrl.replaceAll('/prod', '/staging'),
          'stage': 'staging',
        };
      case 'development':
      default:
        return {
          'apiBaseUrl': _awsApiUrl.replaceAll('/prod', '/dev'),
          'websocketUrl': _awsWebSocketUrl.replaceAll('/prod', '/dev'),
          'stage': 'development',
        };
    }
  }
}
