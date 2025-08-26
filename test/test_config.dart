// Professional Test Configuration for DuaCopilot
import 'package:duacopilot/core/di/injection_container.dart' as di;
import 'package:duacopilot/core/logging/app_logger.dart';
import 'package:duacopilot/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';

// Simple GetIt instance for testing
final getIt = GetIt.instance;

// initializes the registration of main dependencies inside of GetIt
GetIt init(GetIt getIt, {String? environment}) {
  // Initialize main dependencies
  return getIt;
}

// initializes the registration of test dependencies inside of GetIt
GetIt initGetItTest(GetIt getIt, {String? environment}) {
  // Initialize test-specific dependencies
  return getIt;
}

/// Test configuration for DuaCopilot Islamic app
/// Handles test environment setup with Islamic app considerations
class TestConfig {
  static const String testDatabaseName = 'duacopilot_test.db';
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration longTimeout = Duration(minutes: 2);

  /// Prayer time calculation test tolerance (for time-sensitive tests)
  static const Duration prayerTimeTestTolerance = Duration(minutes: 1);

  /// Test location for Islamic features (Mecca coordinates for testing)
  static const double testLatitude = 21.4225;
  static const double testLongitude = 39.8262;

  static Future<void> setupTestEnvironment() async {
    try {
      // Initialize test-specific dependencies
      await configureTestDependencies();

      // Initialize logger for testing (using debug method instead of initialize)
      AppLogger.debug('Test environment setup - Logging initialized');

      // Set test environment variables
      const String.fromEnvironment('FLUTTER_ENV', defaultValue: 'test');

      AppLogger.info('Test environment setup completed');
      AppLogger.info('Test Environment Initialized');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to setup test environment', e, stackTrace);
      rethrow;
    }
  }

  static Future<void> configureTestDependencies() async {
    try {
      // Initialize main dependency injection for testing
      await di.init();
      AppLogger.debug('Test dependencies configured successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to configure test dependencies', e, stackTrace);
      rethrow;
    }
  }

  static void cleanupTestEnvironment() {
    try {
      // Cleanup test artifacts
      AppLogger.info('Test environment cleanup started');

      // Reset GetIt for clean test isolation
      getIt.reset();

      AppLogger.info('Test environment cleanup completed');
      AppLogger.debug('Test logs cleared');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to cleanup test environment', e, stackTrace);
    }
  }

  /// Setup for Islamic feature tests (prayer times, Qibla, etc.)
  static Future<void> setupIslamicFeatureTests() async {
    AppLogger.info(
      'Islamic Feature Tests Setup - Location: Mecca ($testLatitude, $testLongitude)',
    );
  }
}

/// Helper class for integration testing with Islamic app considerations
class IntegrationTestHelper {
  static final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  static Future<void> initializeApp() async {
    try {
      await TestConfig.setupTestEnvironment();

      // Initialize main app
      app.main();

      // Convert surface for screenshot capabilities
      await binding.convertFlutterSurfaceToImage();

      AppLogger.info('Integration test app initialized');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize test app', e, stackTrace);
      rethrow;
    }
  }

  static Future<void> takeScreenshot(String name) async {
    try {
      await binding.takeScreenshot(name);
      AppLogger.info('Screenshot taken: $name');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to take screenshot: $name', e, stackTrace);
    }
  }

  static Future<void> delay([Duration? duration]) async {
    final delayDuration = duration ?? const Duration(milliseconds: 500);
    await Future.delayed(delayDuration);
  }

  /// Wait for prayer time calculations to complete
  static Future<void> waitForPrayerCalculation({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    AppLogger.info('Waiting for prayer time calculation');
    await delay(timeout);
  }

  /// Wait for Qibla direction calculation
  static Future<void> waitForQiblaCalculation({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    AppLogger.info('Waiting for Qibla calculation');
    await delay(timeout);
  }
}
