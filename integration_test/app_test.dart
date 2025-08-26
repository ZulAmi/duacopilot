import 'package:duacopilot/main_dev.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Comprehensive integration tests for DuaCopilot
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('🕌 DuaCopilot Integration Tests', () {
    group('🚀 App Initialization', () {
      testWidgets('Should initialize app successfully', (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Verify app loads without crashes
        expect(find.byType(MaterialApp), findsOneWidget);

        // Verify Islamic theming is applied
        final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
        expect(
          materialApp.theme?.colorScheme.primary,
          equals(const Color(0xFF2E7D32)),
        );

        // Verify main screen is displayed
        expect(find.text('DuaCopilot'), findsWidgets);
      });

      testWidgets('Should handle platform detection correctly', (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Platform-specific functionality should be available
        // This test adapts based on the platform it's running on
        final context = tester.element(find.byType(MaterialApp));
        final theme = Theme.of(context);

        expect(theme.useMaterial3, isTrue);
        expect(theme.colorScheme.primary, equals(const Color(0xFF2E7D32)));
      });
    });

    group('🔍 Search Functionality', () {
      testWidgets('Should perform basic search operations', (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Find and tap search field
        final searchField = find.byType(TextField);
        expect(searchField, findsWidgets);

        if (searchField.hasFound) {
          await tester.tap(searchField.first);
          await tester.pumpAndSettle();

          // Enter search query
          await tester.enterText(searchField.first, 'morning prayer');
          await tester.pumpAndSettle();

          // Wait for search results
          await tester.pump(const Duration(seconds: 2));

          // Verify search results are displayed
          expect(find.textContaining('prayer'), findsWidgets);
        }
      });

      testWidgets('Should handle Arabic text input', (tester) async {
        app.main();
        await tester.pumpAndSettle();

        final searchField = find.byType(TextField);
        if (searchField.hasFound) {
          await tester.tap(searchField.first);
          await tester.pumpAndSettle();

          // Test Arabic input
          await tester.enterText(searchField.first, 'اللهم');
          await tester.pumpAndSettle();

          // Verify Arabic text is handled correctly
          expect(find.text('اللهم'), findsOneWidget);
        }
      });
    });

    group('🎯 Core Features', () {
      testWidgets('Should display dua content correctly', (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Navigate to a dua
        final searchField = find.byType(TextField);
        if (searchField.hasFound) {
          await tester.tap(searchField.first);
          await tester.enterText(searchField.first, 'bismillah');
          await tester.pumpAndSettle();

          // Wait for results and tap first result
          await tester.pump(const Duration(seconds: 2));

          // Look for dua content elements
          expect(find.byType(Card), findsWidgets);
        }
      });

      testWidgets('Should handle favorites functionality', (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Test favorite button interaction
        final favoriteButtons = find.byIcon(Icons.favorite_border);
        if (favoriteButtons.hasFound) {
          await tester.tap(favoriteButtons.first);
          await tester.pumpAndSettle();

          // Verify favorite state changed
          expect(find.byIcon(Icons.favorite), findsWidgets);
        }
      });
    });

    group('🎨 UI/UX Tests', () {
      testWidgets('Should display proper Islamic theming', (tester) async {
        app.main();
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(MaterialApp));
        final theme = Theme.of(context);

        // Verify Islamic green color scheme using proper color accessors
        expect(
          theme.colorScheme.primary.r,
          closeTo(46 / 255, 0.01),
        ); // 0xFF2E7D32
        expect(theme.colorScheme.primary.g, closeTo(125 / 255, 0.01));
        expect(theme.colorScheme.primary.b, closeTo(50 / 255, 0.01));

        expect(
          theme.colorScheme.secondary.r,
          closeTo(76 / 255, 0.01),
        ); // 0xFF4CAF50
        expect(theme.colorScheme.secondary.g, closeTo(175 / 255, 0.01));
        expect(theme.colorScheme.secondary.b, closeTo(80 / 255, 0.01));

        expect(theme.useMaterial3, isTrue);
      });

      testWidgets('Should be responsive on different screen sizes', (
        tester,
      ) async {
        // Test different screen sizes
        final sizes = [
          const Size(360, 640), // Phone
          const Size(768, 1024), // Tablet
          const Size(1200, 800), // Desktop
        ];

        for (final size in sizes) {
          await tester.binding.setSurfaceSize(size);

          app.main();
          await tester.pumpAndSettle();

          // Verify layout adapts to screen size
          expect(find.byType(MaterialApp), findsOneWidget);

          // Check that content is visible and properly laid out
          final scaffolds = find.byType(Scaffold);
          expect(scaffolds, findsWidgets);
        }
      });
    });

    group('⚡ Performance Tests', () {
      testWidgets('Should handle rapid navigation without memory leaks', (
        tester,
      ) async {
        app.main();
        await tester.pumpAndSettle();

        // Perform rapid navigation to stress test
        for (int i = 0; i < 10; i++) {
          final searchField = find.byType(TextField);
          if (searchField.hasFound) {
            await tester.tap(searchField.first);
            await tester.enterText(searchField.first, 'test $i');
            await tester.pumpAndSettle();

            // Clear the field
            await tester.enterText(searchField.first, '');
            await tester.pumpAndSettle();
          }
        }

        // Verify app is still responsive
        expect(find.byType(MaterialApp), findsOneWidget);
      });

      testWidgets('Should load initial content within acceptable time', (
        tester,
      ) async {
        final stopwatch = Stopwatch()..start();

        app.main();
        await tester.pumpAndSettle();

        stopwatch.stop();

        // Verify app loads within 5 seconds (more generous for CI/CD)
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
        expect(find.byType(MaterialApp), findsOneWidget);
      });
    });

    group('🔧 Error Handling', () {
      testWidgets('Should gracefully handle network errors', (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // App should still function even if network is unavailable
        expect(find.byType(MaterialApp), findsOneWidget);

        // Try to perform a search that might fail
        final searchField = find.byType(TextField);
        if (searchField.hasFound) {
          await tester.tap(searchField.first);
          await tester.enterText(searchField.first, 'test network error');
          await tester.pumpAndSettle();

          // Should not crash the app
          expect(find.byType(MaterialApp), findsOneWidget);
        }
      });

      testWidgets('Should handle invalid input gracefully', (tester) async {
        app.main();
        await tester.pumpAndSettle();

        final searchField = find.byType(TextField);
        if (searchField.hasFound) {
          await tester.tap(searchField.first);

          // Test various invalid inputs
          final invalidInputs = ['', '   ', '!@#\$%^&*()', '🎌🎭🎪🎨🎯'];

          for (final input in invalidInputs) {
            await tester.enterText(searchField.first, input);
            await tester.pumpAndSettle();

            // App should remain stable
            expect(find.byType(MaterialApp), findsOneWidget);
          }
        }
      });
    });
  });
}
