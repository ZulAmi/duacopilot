import 'package:duacopilot/core/monitoring/monitoring_initialization_service.dart';
import 'package:duacopilot/core/monitoring/monitoring_integration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Monitoring Integration Tests', () {
    setUp(() {
      // Initialize WidgetsBinding for tests
      WidgetsFlutterBinding.ensureInitialized();
    });

    test('MonitoringInitializationService should be available', () {
      // Test that the singleton instance exists
      expect(MonitoringInitializationService.instance, isNotNull);
      expect(MonitoringInitializationService.instance.isInitialized, isFalse);
    });

    test('MonitoringIntegration should have required methods', () {
      // Test that MonitoringIntegration has the required static methods
      expect(MonitoringIntegration.startRagQueryTracking, isNotNull);
      expect(MonitoringIntegration.showSatisfactionDialog, isNotNull);
      expect(MonitoringIntegration.recordRagException, isNotNull);
    });

    testWidgets('MonitoredApp widget should render child correctly', (
      tester,
    ) async {
      // Create a simple test widget
      const testChild = Text('Test Child');

      // Wrap with MonitoredApp
      await tester.pumpWidget(
        const MaterialApp(
          home: MonitoredApp(
            enableMonitoring: false, // Disable for test to avoid Firebase init
            child: testChild,
          ),
        ),
      );

      // Verify the child widget is rendered
      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('MonitoredApp should show initialization status', (
      tester,
    ) async {
      // Create test widget with monitoring enabled
      await tester.pumpWidget(
        const MaterialApp(
          home: MonitoredApp(enableMonitoring: true, child: Text('Test Child')),
        ),
      );

      // Should show initialization indicator
      expect(find.text('Initializing monitoring...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    test(
      'MonitoringInitializationService status should provide debug info',
      () {
        final status =
            MonitoringInitializationService.instance.monitoringStatus;

        expect(status, isA<Map<String, dynamic>>());
        expect(status.containsKey('initialized'), isTrue);
        expect(status.containsKey('platform_service'), isTrue);
        expect(status.containsKey('timestamp'), isTrue);
      },
    );
  });

  group('Monitoring Service Integration', () {
    test(
      'MonitoringInitializationService should have proper lifecycle methods',
      () {
        // Test that the monitoring initialization service has required methods
        final initService = MonitoringInitializationService.instance;

        expect(initService, isNotNull);
        expect(initService.monitoringStatus, isA<Map<String, dynamic>>());
        expect(initService.isInitialized, isFalse);
      },
    );

    test('MonitoringIntegration should have A/B testing methods', () {
      // Test A/B testing variant methods exist
      expect(MonitoringIntegration.getRagIntegrationVariant, isNotNull);
      expect(MonitoringIntegration.getResponseFormatVariant, isNotNull);
      expect(MonitoringIntegration.getCacheStrategyVariant, isNotNull);
    });

    test('MonitoringIntegration should have analytics methods', () {
      // Test analytics and tracking methods exist
      expect(MonitoringIntegration.recordABTestConversion, isNotNull);
      expect(MonitoringIntegration.getRagAnalyticsSummary, isNotNull);
      expect(MonitoringIntegration.dispose, isNotNull);
    });

    test('Service lifecycle should be manageable', () async {
      final initService = MonitoringInitializationService.instance;

      // Should start uninitialized
      expect(initService.isInitialized, isFalse);

      // Should be able to dispose safely even when not initialized
      await initService.dispose();
      expect(initService.isInitialized, isFalse);
    });
  });
}
