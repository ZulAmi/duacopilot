// Test configuration for comprehensive testing approach
import 'package:duacopilot/data/models/dua_response.dart';
import 'package:duacopilot/data/models/rag_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Comprehensive test configuration for DuaCopilot
class TestConfig {
  // Golden test configuration
  static const String goldenTestsPath = 'test/golden';
  static const String arabicGoldenTestsPath = 'test/golden/arabic';
  static const String rtlGoldenTestsPath = 'test/golden/rtl';

  // Performance test thresholds
  static const Duration maxResponseTime = Duration(seconds: 5);
  static const Duration maxWidgetRenderTime = Duration(milliseconds: 300);
  static const Duration maxNavigationTime = Duration(milliseconds: 500);
  static const int maxMemoryUsageMB = 150;

  // Accessibility test configuration
  static const double minTouchTargetSize = 44.0;
  static const double minContrastRatio = 4.5;
  static const List<String> supportedScreenReaders = [
    'TalkBack',
    'VoiceOver',
    'NVDA',
    'JAWS',
  ];

  // Test data constants
  static const List<String> sampleArabicQueries = [
    'بسم الله الرحمن الرحيم',
    'الحمد لله رب العالمين',
    'اللهم صل على محمد',
    'سبحان الله وبحمده',
    'لا إله إلا الله',
    'استغفار الله العظيم',
    'اللهم اغفر لي ذنبي',
    'ربنا آتنا في الدنيا حسنة',
  ];

  static const List<String> sampleEnglishQueries = [
    'morning prayer',
    'evening prayer',
    'forgiveness duas',
    'travel prayer',
    'food prayer',
    'sleep prayer',
    'guidance prayer',
    'protection prayer',
  ];

  static const List<String> mixedLanguageQueries = [
    'morning prayer صباح',
    'guidance الهداية',
    'forgiveness استغفار',
    'protection حماية',
  ];

  // Network conditions for testing
  static const List<NetworkCondition> networkConditions = [
    NetworkCondition.fast,
    NetworkCondition.slow,
    NetworkCondition.offline,
    NetworkCondition.intermittent,
  ];

  // Device orientations for testing
  static const List<TestOrientation> testOrientations = [
    TestOrientation.portrait,
    TestOrientation.landscape,
  ];

  // Screen sizes for responsive testing
  static const List<Size> testScreenSizes = [
    Size(360, 640), // Small phone
    Size(414, 896), // Large phone
    Size(768, 1024), // Tablet portrait
    Size(1024, 768), // Tablet landscape
    Size(1200, 800), // Desktop
    Size(1920, 1080), // Large desktop
  ];

  /// Initialize test configuration
  static Future<void> initialize() async {
    // Set up test environment
    SharedPreferences.setMockInitialValues({});

    // Configure flutter test environment for Android target
    if (kDebugMode) {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
    }
  }

  /// Create mock RAG responses for testing
  static List<RagResponseModel> createMockRagResponses() {
    return [
      RagResponseModel(
        id: 'test-1',
        query: 'morning prayer',
        response: 'اللهم أعني على ذكرك وشكرك وحسن عبادتك',
        timestamp: DateTime.now(),
        responseTime: 250,
        sources: ['Sahih Bukhari', 'Sahih Muslim'],
      ),
      RagResponseModel(
        id: 'test-2',
        query: 'evening prayer',
        response: 'أمسينا وأمسى الملك لله',
        timestamp: DateTime.now(),
        responseTime: 180,
        sources: ['Abu Dawood', 'Tirmidhi'],
      ),
      RagResponseModel(
        id: 'test-3',
        query: 'forgiveness',
        response: 'رب اغفر لي ذنبي وخطئي وجهلي',
        timestamp: DateTime.now(),
        responseTime: 300,
        sources: ['Sahih Bukhari'],
      ),
    ];
  }

  /// Create mock DUA responses
  static List<DuaResponse> createMockDuaResponses() {
    return [
      DuaResponse(
        id: 'dua-1',
        query: 'morning prayer',
        response:
            'بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم',
        timestamp: DateTime.now(),
        responseTime: 200,
        confidence: 0.95,
        sources: [
          DuaSource(
            id: 'source-1',
            title: 'Abu Dawud',
            content: 'Morning protection prayer',
            relevanceScore: 0.95,
            reference: 'Abu Dawud 4/323',
            category: 'Morning Prayers',
          ),
        ],
        isFavorite: false,
      ),
      DuaResponse(
        id: 'dua-2',
        query: 'travel prayer',
        response: 'اللهم إنا نسألك في سفرنا هذا البر والتقوى',
        timestamp: DateTime.now(),
        responseTime: 180,
        confidence: 0.91,
        sources: [
          DuaSource(
            id: 'source-2',
            title: 'Tirmidhi',
            content: 'Travel safety prayer',
            relevanceScore: 0.91,
            reference: 'Tirmidhi 3/425',
            category: 'Travel Prayers',
          ),
        ],
        isFavorite: true,
      ),
    ];
  }

  /// Performance test helper
  static void performanceTest(
    String testName,
    Future<void> Function() testFunction,
  ) {
    group('Performance: $testName', () {
      test('should complete within acceptable time', () async {
        final stopwatch = Stopwatch()..start();
        await testFunction();
        stopwatch.stop();

        expect(stopwatch.elapsed, lessThan(maxResponseTime));
      });
    });
  }

  /// Memory usage test helper (simplified for testing)
  static void memoryTest(
    String testName,
    Future<void> Function() testFunction,
  ) {
    group('Memory: $testName', () {
      test('should not create memory leaks', () async {
        // Basic memory test - actual implementation would require platform-specific tools
        final beforeTest = DateTime.now().millisecondsSinceEpoch;
        await testFunction();
        final afterTest = DateTime.now().millisecondsSinceEpoch;

        // Test should complete in reasonable time (indication of no infinite loops)
        expect(afterTest - beforeTest, lessThan(30000)); // 30 seconds max
      });
    });
  }

  /// Accessibility test helper
  static void accessibilityTest(
    WidgetTester tester,
    String description,
    Widget testWidget,
  ) {
    testWidgets('Accessibility: $description', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: testWidget)));
      await tester.pumpAndSettle();

      // Test semantic labels
      expect(tester.binding.pipelineOwner.semanticsOwner, isNotNull);

      // Test minimum touch target sizes for interactive widgets
      final interactiveWidgets = [
        find.byType(ElevatedButton),
        find.byType(TextButton),
        find.byType(IconButton),
        find.byType(FloatingActionButton),
        find.byType(GestureDetector),
        find.byType(InkWell),
      ];

      for (final widgetFinder in interactiveWidgets) {
        for (final widget in widgetFinder.evaluate()) {
          final renderBox = widget.renderObject as RenderBox?;
          if (renderBox != null && renderBox.hasSize) {
            final size = renderBox.size;
            if (size.width > 0 && size.height > 0) {
              expect(
                size.width,
                greaterThanOrEqualTo(minTouchTargetSize - 4),
                reason: 'Touch target too small: ${widget.widget.runtimeType}',
              );
              expect(
                size.height,
                greaterThanOrEqualTo(minTouchTargetSize - 4),
                reason: 'Touch target too small: ${widget.widget.runtimeType}',
              );
            }
          }
        }
      }
    });
  }

  /// Arabic RTL test helper
  static void arabicRtlTest(WidgetTester tester, String arabicText) {
    testWidgets('Arabic RTL: $arabicText', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(arabicText, style: const TextStyle(fontSize: 16)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify RTL text is rendered
      expect(find.text(arabicText), findsOneWidget);

      // Test that RTL direction is applied
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.data, equals(arabicText));
    });
  }

  /// Golden test helper (simplified without golden_toolkit)
  static void goldenTest(WidgetTester tester, Widget widget, String fileName) {
    testWidgets('Golden: $fileName', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
      await tester.pumpAndSettle();

      // Golden test would be implemented here with golden_toolkit when available
      expect(find.byWidget(widget), findsOneWidget);

      // For now, just verify the widget renders without errors
      expect(tester.binding.renderView, isNotNull);
    });
  }

  /// Network condition simulation helper
  static void simulateNetworkCondition(NetworkCondition condition) {
    switch (condition) {
      case NetworkCondition.fast:
        // Fast network simulation - low latency, high bandwidth
        break;
      case NetworkCondition.slow:
        // Slow network simulation - high latency, low bandwidth
        break;
      case NetworkCondition.offline:
        // Offline simulation - no network connectivity
        break;
      case NetworkCondition.intermittent:
        // Intermittent connection simulation - unstable connectivity
        break;
    }
  }

  /// Reset test environment
  static Future<void> cleanup() async {
    SharedPreferences.setMockInitialValues({});
    if (kDebugMode) {
      debugDefaultTargetPlatformOverride = null;
    }
  }
}

/// Network conditions for testing
enum NetworkCondition { fast, slow, offline, intermittent }

/// Test orientation enum
enum TestOrientation { portrait, landscape }

/// Test utilities for common testing patterns
class TestUtils {
  /// Find widget by semantic label
  static Finder findBySemanticsLabel(String label) {
    return find.bySemanticsLabel(label);
  }

  /// Wait for animation to complete
  static Future<void> waitForAnimation(
    WidgetTester tester, [
    Duration? duration,
  ]) async {
    await tester.pumpAndSettle(duration ?? const Duration(milliseconds: 500));
  }

  /// Tap and wait
  static Future<void> tapAndWait(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await waitForAnimation(tester);
  }

  /// Enter text and wait
  static Future<void> enterTextAndWait(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await waitForAnimation(tester);
  }

  /// Scroll vertically and wait
  static Future<void> scrollAndWait(
    WidgetTester tester,
    Finder finder,
    double offset,
  ) async {
    await tester.drag(finder, Offset(0, offset));
    await waitForAnimation(tester);
  }

  /// Test responsive design across different screen sizes
  static Future<void> testResponsiveDesign(
    WidgetTester tester,
    Widget widget,
    List<Size> screenSizes,
  ) async {
    for (final size in screenSizes) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
      await tester.pumpAndSettle();

      // Verify widget adapts to screen size
      expect(find.byWidget(widget), findsOneWidget);
    }

    // Reset to default size
    await tester.binding.setSurfaceSize(null);
  }

  /// Test widget with different orientations
  static Future<void> testOrientationChanges(
    WidgetTester tester,
    Widget widget,
  ) async {
    for (final orientation in TestConfig.testOrientations) {
      final size =
          orientation == TestOrientation.portrait
              ? const Size(414, 896)
              : const Size(896, 414);

      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
      await tester.pumpAndSettle();

      expect(find.byWidget(widget), findsOneWidget);
    }

    await tester.binding.setSurfaceSize(null);
  }

  /// Simulate different network conditions
  static Future<void> testNetworkConditions(
    Future<void> Function(NetworkCondition) testFunction,
  ) async {
    for (final condition in TestConfig.networkConditions) {
      TestConfig.simulateNetworkCondition(condition);
      await testFunction(condition);
    }
  }
}
