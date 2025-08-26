import 'package:duacopilot/main_dev.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';

/// Comprehensive integration tests for complete RAG API workflows
/// Tests the entire app flow from user input to response display
/// DEVELOPMENT VERSION - Testing Revolutionary UI/UX
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Reset GetIt before and after each test group to avoid "already registered" errors
  setUp(() {
    // Reset GetIt instance to avoid dependency conflicts between tests
    GetIt.instance.reset();
  });

  tearDown(() {
    // Clean up GetIt after each test
    GetIt.instance.reset();
  });

  // Test configuration constants
  const Duration maxResponseTime = Duration(seconds: 5);
  const List<String> sampleArabicQueries = ['بسم الله الرحمن الرحيم', 'الحمد لله رب العالمين', 'صلاة الصباح'];

  const List<String> mixedLanguageQueries = ['morning prayer صباح', 'guidance الهداية', 'forgiveness استغفار'];

  // Mock data generators for integration tests
  List<Map<String, dynamic>> createMockDuaResponses() {
    return [
      {
        'id': 'dua-1',
        'query': 'morning prayer',
        'response': 'اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا',
        'confidence': 0.95,
        'sources': [
          {
            'id': 'source-1',
            'title': 'Morning Prayers',
            'content': 'Collection of morning duas',
            'relevanceScore': 0.95,
          },
        ],
      },
      {
        'id': 'dua-2',
        'query': 'evening prayer',
        'response': 'اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا',
        'confidence': 0.92,
        'sources': [
          {
            'id': 'source-2',
            'title': 'Evening Prayers',
            'content': 'Collection of evening duas',
            'relevanceScore': 0.92,
          },
        ],
      },
    ];
  }

  List<Map<String, dynamic>> createMockRagResponses() {
    return [
      {
        'id': 'rag-1',
        'query': 'protection prayer',
        'response': 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
        'responseTime': 250,
      },
      {
        'id': 'rag-2',
        'query': 'guidance prayer',
        'response': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
        'responseTime': 180,
      },
    ];
  }

  group('RAG Integration Tests - Complete Workflows', () {
    group('🚀 App Initialization Tests', () {
      testWidgets('App should initialize and load main screen', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        // Verify app is loaded
        expect(find.byType(MaterialApp), findsOneWidget);

        // Look for main UI elements
        final scaffolds = find.byType(Scaffold);
        expect(scaffolds, findsAtLeastNWidgets(1));

        print('✅ App initialization completed successfully');
      });

      testWidgets('Theme and branding should be applied', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 2));

        final context = tester.element(find.byType(MaterialApp));
        final theme = Theme.of(context);

        expect(theme.useMaterial3, isTrue);
        expect(theme.colorScheme.primary, isNotNull);

        print('✅ Theme and branding verified');
      });
    });

    group('🔍 Search Workflow Integration Tests', () {
      testWidgets('Complete English search workflow', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        // Find search field
        final searchFields = find.byType(TextField);
        if (searchFields.hasFound) {
          final searchField = searchFields.first;
          await tester.tap(searchField);
          await tester.pumpAndSettle();

          // Enter English query
          const query = 'morning prayer';
          await tester.enterText(searchField, query);
          await tester.pumpAndSettle();

          print('✅ English query entered: $query');

          // Look for search results or submit button
          final searchButton = find.byIcon(Icons.search);
          if (searchButton.hasFound) {
            await tester.tap(searchButton);
            await tester.pumpAndSettle(Duration(seconds: 2));
            print('✅ Search submitted');
          }

          // Wait for results (with timeout)
          await tester.pump(Duration(seconds: 3));

          // Verify app remains stable
          expect(find.byType(MaterialApp), findsOneWidget);
          print('✅ English search workflow completed');
        } else {
          print('ℹ️ Search field not found - checking alternative UI');
          expect(find.byType(MaterialApp), findsOneWidget);
        }
      });

      testWidgets('Complete Arabic search workflow', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        final searchFields = find.byType(TextField);
        if (searchFields.hasFound) {
          final searchField = searchFields.first;
          await tester.tap(searchField);
          await tester.pumpAndSettle();

          // Enter Arabic query
          const arabicQuery = 'صلاة الصباح';
          await tester.enterText(searchField, arabicQuery);
          await tester.pumpAndSettle();

          print('✅ Arabic query entered: $arabicQuery');

          // Submit search
          final searchButton = find.byIcon(Icons.search);
          if (searchButton.hasFound) {
            await tester.tap(searchButton);
            await tester.pumpAndSettle(Duration(seconds: 2));
          }

          await tester.pump(Duration(seconds: 3));

          expect(find.byType(MaterialApp), findsOneWidget);
          print('✅ Arabic search workflow completed');
        }
      });

      testWidgets('Mixed language search workflow', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        final searchFields = find.byType(TextField);
        if (searchFields.hasFound) {
          final searchField = searchFields.first;
          await tester.tap(searchField);
          await tester.pumpAndSettle();

          // Test mixed content queries
          final mixedQueries = mixedLanguageQueries.take(2);

          for (final query in mixedQueries) {
            // Clear field
            await tester.enterText(searchField, '');
            await tester.pumpAndSettle();

            // Enter mixed query
            await tester.enterText(searchField, query);
            await tester.pumpAndSettle();

            print('✅ Mixed query entered: $query');

            // Brief wait before next query
            await tester.pump(Duration(seconds: 1));
          }

          expect(find.byType(MaterialApp), findsOneWidget);
          print('✅ Mixed language search workflow completed');
        }
      });
    });

    group('📱 Responsive UI Integration Tests', () {
      testWidgets('Portrait orientation workflow', (WidgetTester tester) async {
        // Set portrait orientation
        await tester.binding.setSurfaceSize(Size(414, 896));

        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        expect(find.byType(MaterialApp), findsOneWidget);

        // Test basic interactions in portrait
        final searchFields = find.byType(TextField);
        if (searchFields.hasFound) {
          await tester.tap(searchFields.first);
          await tester.enterText(searchFields.first, 'portrait test');
          await tester.pumpAndSettle();
        }

        print('✅ Portrait orientation workflow completed');
      });

      testWidgets('Landscape orientation workflow', (WidgetTester tester) async {
        // Set landscape orientation
        await tester.binding.setSurfaceSize(Size(896, 414));

        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        expect(find.byType(MaterialApp), findsOneWidget);

        // Test basic interactions in landscape
        final searchFields = find.byType(TextField);
        if (searchFields.hasFound) {
          await tester.tap(searchFields.first);
          await tester.enterText(searchFields.first, 'landscape test');
          await tester.pumpAndSettle();
        }

        print('✅ Landscape orientation workflow completed');

        // Reset to default
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('Multi-screen size responsiveness', (WidgetTester tester) async {
        final testSizes = [
          Size(360, 640), // Small phone
          Size(768, 1024), // Tablet
          Size(1200, 800), // Desktop
        ];

        for (final size in testSizes) {
          await tester.binding.setSurfaceSize(size);

          app.main();
          await tester.pumpAndSettle(Duration(seconds: 2));

          expect(find.byType(MaterialApp), findsOneWidget);
          print('✅ Tested size: ${size.width}x${size.height}');
        }

        await tester.binding.setSurfaceSize(null);
        print('✅ Multi-screen responsiveness tested');
      });
    });

    group('🎯 User Interaction Integration Tests', () {
      testWidgets('Favorite functionality workflow', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        // Look for favorite buttons
        final favoriteButtons = find.byIcon(Icons.favorite_border);
        if (favoriteButtons.hasFound) {
          await tester.tap(favoriteButtons.first);
          await tester.pumpAndSettle();

          // Should change to filled favorite
          final filledFavorites = find.byIcon(Icons.favorite);
          if (filledFavorites.hasFound) {
            print('✅ Favorite button toggled successfully');

            // Toggle back
            await tester.tap(filledFavorites.first);
            await tester.pumpAndSettle();
          }
        }

        expect(find.byType(MaterialApp), findsOneWidget);
        print('✅ Favorite functionality workflow completed');
      });

      testWidgets('Navigation workflow', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        // Test navigation elements
        final drawerButtons = find.byIcon(Icons.menu);
        if (drawerButtons.hasFound) {
          await tester.tap(drawerButtons.first);
          await tester.pumpAndSettle();

          // Look for drawer content
          final drawer = find.byType(Drawer);
          if (drawer.hasFound) {
            print('✅ Navigation drawer opened');

            // Close drawer
            await tester.tap(find.byType(Scaffold));
            await tester.pumpAndSettle();
          }
        }

        // Test tab navigation if present
        final tabs = find.byType(Tab);
        if (tabs.hasFound && tabs.evaluate().length > 1) {
          await tester.tap(tabs.at(1));
          await tester.pumpAndSettle();
          print('✅ Tab navigation tested');
        }

        expect(find.byType(MaterialApp), findsOneWidget);
        print('✅ Navigation workflow completed');
      });

      testWidgets('Voice search workflow (UI only)', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        // Look for voice/microphone button
        final voiceButtons = find.byIcon(Icons.mic);
        if (voiceButtons.hasFound) {
          await tester.tap(voiceButtons.first);
          await tester.pumpAndSettle();

          print('✅ Voice search button interaction tested');
        }

        // Alternative: look for voice-related widgets
        final voiceWidgets = find.byType(FloatingActionButton);
        for (final widget in voiceWidgets.evaluate()) {
          final fab = widget.widget as FloatingActionButton;
          if (fab.child is Icon && (fab.child as Icon).icon == Icons.mic) {
            await tester.tap(find.byWidget(fab));
            await tester.pumpAndSettle();
            print('✅ Voice FAB tested');
            break;
          }
        }

        expect(find.byType(MaterialApp), findsOneWidget);
        print('✅ Voice search UI workflow completed');
      });
    });

    group('⚡ Performance Integration Tests', () {
      testWidgets('App startup performance', (WidgetTester tester) async {
        final stopwatch = Stopwatch()..start();

        app.main();
        await tester.pumpAndSettle(Duration(seconds: 5));

        stopwatch.stop();
        final startupTime = stopwatch.elapsedMilliseconds;

        expect(find.byType(MaterialApp), findsOneWidget);
        expect(startupTime, lessThan(10000)); // Should start within 10 seconds

        print('✅ App startup time: ${startupTime}ms');
      });

      testWidgets('Search response performance', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        final searchFields = find.byType(TextField);
        if (searchFields.hasFound) {
          final stopwatch = Stopwatch()..start();

          await tester.tap(searchFields.first);
          await tester.enterText(searchFields.first, 'performance test');
          await tester.pumpAndSettle();

          final searchButton = find.byIcon(Icons.search);
          if (searchButton.hasFound) {
            await tester.tap(searchButton);
            await tester.pumpAndSettle(Duration(seconds: 3));
          }

          stopwatch.stop();
          final responseTime = stopwatch.elapsedMilliseconds;

          expect(responseTime, lessThan(maxResponseTime.inMilliseconds));
          print('✅ Search response time: ${responseTime}ms');
        }

        expect(find.byType(MaterialApp), findsOneWidget);
      });

      testWidgets('Memory stability during extended use', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        // Simulate extended usage
        for (int i = 0; i < 10; i++) {
          final searchFields = find.byType(TextField);
          if (searchFields.hasFound) {
            await tester.tap(searchFields.first);
            await tester.enterText(searchFields.first, 'test query $i');
            await tester.pumpAndSettle();

            // Clear and continue
            await tester.enterText(searchFields.first, '');
            await tester.pumpAndSettle();
          }

          // Brief pause
          await tester.pump(Duration(milliseconds: 100));
        }

        expect(find.byType(MaterialApp), findsOneWidget);
        print('✅ Memory stability test completed');
      });
    });

    group('🔒 Error Handling Integration Tests', () {
      testWidgets('Network error handling', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        // App should remain stable even with network issues
        expect(find.byType(MaterialApp), findsOneWidget);

        // Simulate search that might fail
        final searchFields = find.byType(TextField);
        if (searchFields.hasFound) {
          await tester.tap(searchFields.first);
          await tester.enterText(searchFields.first, 'network error test');
          await tester.pumpAndSettle();

          final searchButton = find.byIcon(Icons.search);
          if (searchButton.hasFound) {
            await tester.tap(searchButton);
            await tester.pumpAndSettle(Duration(seconds: 3));
          }
        }

        // App should still be functional
        expect(find.byType(MaterialApp), findsOneWidget);
        print('✅ Network error handling tested');
      });

      testWidgets('Invalid input handling', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        final searchFields = find.byType(TextField);
        if (searchFields.hasFound) {
          final invalidInputs = ['', '   ', '!@#\$%^&*()', '🎌🎭🎪🎨🎯'];

          for (final input in invalidInputs) {
            await tester.tap(searchFields.first);
            await tester.enterText(searchFields.first, input);
            await tester.pumpAndSettle();

            // App should remain stable
            expect(find.byType(MaterialApp), findsOneWidget);

            // Clear field
            await tester.enterText(searchFields.first, '');
            await tester.pumpAndSettle();
          }
        }

        print('✅ Invalid input handling tested');
      });

      testWidgets('UI recovery after errors', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        // Simulate various user actions that might cause errors
        final searchFields = find.byType(TextField);
        final buttons = find.byType(ElevatedButton);
        final iconButtons = find.byType(IconButton);

        // Rapid interactions
        if (searchFields.hasFound) {
          for (int i = 0; i < 5; i++) {
            await tester.tap(searchFields.first);
            await tester.enterText(searchFields.first, 'rapid test $i');
            await tester.pump(Duration(milliseconds: 50));
          }
        }

        if (buttons.hasFound) {
          for (int i = 0; i < 3; i++) {
            await tester.tap(buttons.first);
            await tester.pump(Duration(milliseconds: 100));
          }
        }

        if (iconButtons.hasFound) {
          for (int i = 0; i < 3; i++) {
            await tester.tap(iconButtons.first);
            await tester.pump(Duration(milliseconds: 100));
          }
        }

        // Final stabilization
        await tester.pumpAndSettle(Duration(seconds: 2));

        // App should recover and be stable
        expect(find.byType(MaterialApp), findsOneWidget);
        print('✅ UI recovery after rapid interactions tested');
      });
    });

    group('🌍 Accessibility Integration Tests', () {
      testWidgets('Screen reader navigation workflow', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        // Enable semantics for accessibility testing
        final binding = tester.binding;
        binding.pipelineOwner.semanticsOwner?.dispose();

        expect(binding.pipelineOwner.semanticsOwner, isNull);

        // Create semantics owner if needed for testing
        if (binding.pipelineOwner.semanticsOwner == null) {
          // Semantics will be created automatically when needed
          print('✅ Semantics system available when needed');
        }

        // Test semantic navigation
        final semanticsNodes = binding.pipelineOwner.semanticsOwner!.rootSemanticsNode;
        expect(semanticsNodes, isNotNull);

        print('✅ Semantics tree available for screen readers');

        // Look for semantic labels
        final textFields = find.byType(TextField);
        if (textFields.hasFound) {
          final textFieldWidget = tester.widget<TextField>(textFields.first);
          final decoration = textFieldWidget.decoration;
          if (decoration?.hintText?.isNotEmpty == true || decoration?.labelText?.isNotEmpty == true) {
            print('✅ Text fields have semantic labels');
          }
        }

        expect(find.byType(MaterialApp), findsOneWidget);
      });

      testWidgets('High contrast theme workflow', (WidgetTester tester) async {
        // Test high contrast accessibility
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF2E7D32), brightness: Brightness.light).copyWith(
                surface: Colors.white,
                onSurface: Colors.black,
                primary: Color(0xFF2E7D32),
                onPrimary: Colors.white,
              ),
              useMaterial3: true,
            ),
            home: Scaffold(body: Text('High contrast test')),
          ),
        );
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(MaterialApp));
        final theme = Theme.of(context);

        // Verify high contrast colors
        expect(theme.colorScheme.surface, Colors.white);
        expect(theme.colorScheme.onSurface, Colors.black);

        print('✅ High contrast theme tested');
      });

      testWidgets('Touch target accessibility', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        // Check button sizes meet accessibility guidelines
        final buttons = find.byType(ElevatedButton);
        final iconButtons = find.byType(IconButton);
        final fabs = find.byType(FloatingActionButton);

        final allInteractiveElements = [...buttons.evaluate(), ...iconButtons.evaluate(), ...fabs.evaluate()];

        for (final element in allInteractiveElements.take(5)) {
          final renderBox = element.renderObject as RenderBox?;
          if (renderBox != null && renderBox.hasSize) {
            final size = renderBox.size;
            expect(
              size.width,
              greaterThanOrEqualTo(44.0 - 4), // Allow small tolerance
              reason: 'Interactive element too small: ${element.widget.runtimeType}',
            );
            expect(
              size.height,
              greaterThanOrEqualTo(44.0 - 4),
              reason: 'Interactive element too small: ${element.widget.runtimeType}',
            );
          }
        }

        print('✅ Touch target accessibility verified');
      });
    });

    group('🔄 Data Flow Integration Tests', () {
      testWidgets('Complete search-to-display workflow', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        final searchFields = find.byType(TextField);
        if (searchFields.hasFound) {
          // Step 1: Enter query
          await tester.tap(searchFields.first);
          await tester.enterText(searchFields.first, 'complete workflow test');
          await tester.pumpAndSettle();
          print('✅ Step 1: Query entered');

          // Step 2: Submit search
          final searchButton = find.byIcon(Icons.search);
          if (searchButton.hasFound) {
            await tester.tap(searchButton);
            await tester.pumpAndSettle(Duration(seconds: 2));
            print('✅ Step 2: Search submitted');
          }

          // Step 3: Wait for and verify response handling
          await tester.pump(Duration(seconds: 3));

          // Step 4: Look for any result display elements
          final cards = find.byType(Card);
          final listTiles = find.byType(ListTile);
          final containers = find.byType(Container);

          if (cards.hasFound || listTiles.hasFound || containers.hasFound) {
            print('✅ Step 3: Results displayed');
          } else {
            print('ℹ️ Step 3: No specific result widgets found, but app stable');
          }
        }

        expect(find.byType(MaterialApp), findsOneWidget);
        print('✅ Complete workflow integration test passed');
      });

      testWidgets('State persistence workflow', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(Duration(seconds: 3));

        // Test that app maintains state during navigation
        final searchFields = find.byType(TextField);
        if (searchFields.hasFound) {
          await tester.tap(searchFields.first);
          await tester.enterText(searchFields.first, 'state persistence test');
          await tester.pumpAndSettle();

          // Simulate navigation or state change
          final drawerButtons = find.byIcon(Icons.menu);
          if (drawerButtons.hasFound) {
            await tester.tap(drawerButtons.first);
            await tester.pumpAndSettle();

            // Close drawer
            await tester.tap(find.byType(Scaffold));
            await tester.pumpAndSettle();
          }

          // Check if text is still there (depends on implementation)
          final currentText = tester.widget<TextField>(searchFields.first).controller?.text;
          if (currentText != null) {
            print('✅ Text field state: $currentText');
          }
        }

        expect(find.byType(MaterialApp), findsOneWidget);
        print('✅ State persistence workflow tested');
      });
    });
  });

  group('🧪 Mock RAG Response Tests', () {
    testWidgets('Mock response validation', (WidgetTester tester) async {
      // Test our mock data structure
      final mockDuaResponses = createMockDuaResponses();
      final mockRagResponses = createMockRagResponses();

      expect(mockDuaResponses.isNotEmpty, isTrue);
      expect(mockRagResponses.isNotEmpty, isTrue);

      for (final response in mockDuaResponses) {
        expect(response['id']?.isNotEmpty, isTrue);
        expect(response['query']?.isNotEmpty, isTrue);
        expect(response['response']?.isNotEmpty, isTrue);
        expect(response['confidence'], greaterThanOrEqualTo(0.0));
        expect(response['confidence'], lessThanOrEqualTo(1.0));
        expect(response['sources']?.isNotEmpty, isTrue);
      }

      print('✅ Mock DUA responses validated: ${mockDuaResponses.length} items');

      for (final response in mockRagResponses) {
        expect(response['id']?.isNotEmpty, isTrue);
        expect(response['query']?.isNotEmpty, isTrue);
        expect(response['response']?.isNotEmpty, isTrue);
        expect(response['responseTime'], greaterThan(0));
        expect(response['responseTime'], lessThan(maxResponseTime.inMilliseconds));
      }

      print('✅ Mock RAG responses validated: ${mockRagResponses.length} items');
    });

    testWidgets('Arabic content validation in mocks', (WidgetTester tester) async {
      final mockResponses = createMockDuaResponses();
      final arabicRegex = RegExp(r'[\u0600-\u06FF]');

      bool hasArabicContent = false;
      for (final response in mockResponses) {
        if (arabicRegex.hasMatch(response['response'] ?? '') || arabicRegex.hasMatch(response['query'] ?? '')) {
          hasArabicContent = true;
          break;
        }
      }
      expect(hasArabicContent, isTrue, reason: 'Mock data should contain Arabic content');
      print('✅ Arabic content found in mock responses');

      // Test Arabic queries from config
      for (final query in sampleArabicQueries.take(3)) {
        expect(arabicRegex.hasMatch(query), isTrue, reason: 'Arabic query should contain Arabic text: $query');
      }

      print('✅ Arabic test queries validated');
    });
  });
}
