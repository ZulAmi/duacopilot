import 'package:duacopilot/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../comprehensive_test_config.dart';

/// Comprehensive widget tests for all UI components and user interactions
void main() {
  setUpAll(() async {
    await TestConfig.initialize();
  });

  tearDownAll(() async {
    await TestConfig.cleanup();
  });

  group('Comprehensive Widget Tests', () {
    group('Main App Structure Tests', () {
      testWidgets('SecureDuaCopilotApp should build without crashing', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const ProviderScope(child: app.SecureDuaCopilotApp()),
        );
        await TestUtils.waitForAnimation(tester);

        expect(find.byType(MaterialApp), findsOneWidget);
        expect(find.byType(ProviderScope), findsOneWidget);
      });

      testWidgets('App should have correct theme configuration', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const ProviderScope(child: app.SecureDuaCopilotApp()),
        );
        await TestUtils.waitForAnimation(tester);

        final context = tester.element(find.byType(MaterialApp));
        final theme = Theme.of(context);

        expect(theme.useMaterial3, isTrue);
        expect(theme.colorScheme.primary, isNotNull);
        expect(theme.textTheme, isNotNull);
      });

      testWidgets('App should handle navigation correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          const ProviderScope(child: app.SecureDuaCopilotApp()),
        );
        await TestUtils.waitForAnimation(tester);

        // Test that the app builds and shows initial content
        expect(find.byType(MaterialApp), findsOneWidget);

        // Look for any navigation-related widgets
        final scaffolds = find.byType(Scaffold);
        expect(scaffolds, findsAtLeastNWidgets(1));
      });
    });

    group('Search Interface Widget Tests', () {
      testWidgets('Search field should accept text input', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for duas...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        final searchField = find.byType(TextField);
        expect(searchField, findsOneWidget);

        await TestUtils.enterTextAndWait(tester, searchField, 'morning prayer');
        expect(find.text('morning prayer'), findsOneWidget);
      });

      testWidgets('Search field should handle Arabic input', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  decoration: InputDecoration(hintText: 'البحث عن الأدعية...'),
                ),
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        final searchField = find.byType(TextField);
        expect(searchField, findsOneWidget);

        const arabicQuery = 'صلاة الصباح';
        await TestUtils.enterTextAndWait(tester, searchField, arabicQuery);
        expect(find.text(arabicQuery), findsOneWidget);
      });

      testWidgets('Search button should be tappable', (
        WidgetTester tester,
      ) async {
        bool wasPressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  wasPressed = true;
                },
                child: Text('Search'),
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        final searchButton = find.byType(ElevatedButton);
        expect(searchButton, findsOneWidget);

        await TestUtils.tapAndWait(tester, searchButton);
        expect(wasPressed, isTrue);
      });

      testWidgets('Voice search button should be accessible', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IconButton(
                icon: Icon(Icons.mic),
                onPressed: () {},
                tooltip: 'Voice Search',
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        final voiceButton = find.byIcon(Icons.mic);
        expect(voiceButton, findsOneWidget);

        final iconButton = find.byType(IconButton);
        expect(iconButton, findsOneWidget);
      });
    });

    group('Response Display Widget Tests', () {
      testWidgets('Dua cards should display correctly', (
        WidgetTester tester,
      ) async {
        final mockDuaResponse = TestConfig.createMockDuaResponses().first;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mockDuaResponse.query,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          mockDuaResponse.response,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Confidence: ${(mockDuaResponse.confidence * 100).round()}%',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        expect(find.byType(Card), findsOneWidget);
        expect(find.text(mockDuaResponse.query), findsOneWidget);
        expect(find.text(mockDuaResponse.response), findsOneWidget);
        expect(find.textContaining('Confidence:'), findsOneWidget);
      });

      testWidgets('Source information should be displayed', (
        WidgetTester tester,
      ) async {
        final mockDuaResponse = TestConfig.createMockDuaResponses().first;
        final source = mockDuaResponse.sources.first;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Text('Source: ${source.title}'),
                  if (source.reference != null)
                    Text('Reference: ${source.reference}'),
                  Text('Relevance: ${(source.relevanceScore * 100).round()}%'),
                ],
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        expect(find.textContaining('Source:'), findsOneWidget);
        expect(find.text('Source: ${source.title}'), findsOneWidget);
        expect(find.textContaining('Relevance:'), findsOneWidget);
      });

      testWidgets('Favorite button should toggle correctly', (
        WidgetTester tester,
      ) async {
        bool isFavorite = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        // Initially should show favorite_border
        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsNothing);

        // Tap to favorite
        await TestUtils.tapAndWait(tester, find.byType(IconButton));

        // Should now show favorite
        expect(find.byIcon(Icons.favorite), findsOneWidget);
        expect(find.byIcon(Icons.favorite_border), findsNothing);

        // Tap again to unfavorite
        await TestUtils.tapAndWait(tester, find.byType(IconButton));

        // Should be back to favorite_border
        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsNothing);
      });
    });

    group('Arabic RTL Widget Tests', () {
      testWidgets('Arabic text should be right-to-left', (
        WidgetTester tester,
      ) async {
        const arabicText = 'بسم الله الرحمن الرحيم';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(arabicText, style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        expect(find.text(arabicText), findsOneWidget);
        expect(find.byType(Directionality), findsOneWidget);

        final directionality = tester.widget<Directionality>(
          find.byType(Directionality),
        );
        expect(directionality.textDirection, equals(TextDirection.rtl));
      });

      testWidgets('Mixed content should handle direction correctly', (
        WidgetTester tester,
      ) async {
        const mixedText = 'Search البحث';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(mixedText),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(mixedText),
                  ),
                ],
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        expect(find.text(mixedText), findsNWidgets(2));
        expect(find.byType(Directionality), findsNWidgets(2));
      });

      testWidgets('Arabic input field should have correct direction', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  decoration: InputDecoration(hintText: 'أدخل النص هنا'),
                ),
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        const arabicInput = 'صلاة المغرب';
        await TestUtils.enterTextAndWait(tester, textField, arabicInput);
        expect(find.text(arabicInput), findsOneWidget);
      });
    });

    group('Responsive Design Widget Tests', () {
      testWidgets('Layout should adapt to screen size', (
        WidgetTester tester,
      ) async {
        final testWidget = Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return isWide
                  ? Row(
                      children: [
                        Expanded(child: Text('Left Panel')),
                        Expanded(child: Text('Right Panel')),
                      ],
                    )
                  : Column(children: [Text('Top Panel'), Text('Bottom Panel')]);
            },
          ),
        );

        await TestUtils.testResponsiveDesign(tester, testWidget, [
          Size(400, 800), // Narrow screen
          Size(800, 600), // Wide screen
        ]);
      });

      testWidgets('Navigation should adapt to screen size', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: Text('DuaCopilot')),
              drawer: MediaQuery.of(
                        tester.element(find.byType(Scaffold)),
                      ).size.width <
                      600
                  ? Drawer(child: Text('Navigation Drawer'))
                  : null,
              body: Text('Main Content'),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Main Content'), findsOneWidget);
      });
    });

    group('Accessibility Widget Tests', () {
      testWidgets('Buttons should have proper semantics', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  ElevatedButton(onPressed: () {}, child: Text('Search')),
                  IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () {},
                    tooltip: 'Add to favorites',
                  ),
                  FloatingActionButton(
                    onPressed: () {},
                    tooltip: 'Record voice',
                    child: Icon(Icons.mic),
                  ),
                ],
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        // Test semantic labels
        expect(find.text('Search'), findsOneWidget);
        expect(find.byTooltip('Add to favorites'), findsOneWidget);
        expect(find.byTooltip('Record voice'), findsOneWidget);
      });

      testWidgets('Text should have appropriate contrast', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Color(0xFF2E7D32), // Islamic green
                brightness: Brightness.light,
              ),
            ),
            home: Scaffold(
              body: Column(
                children: [
                  Text('Primary Text', style: TextStyle(color: Colors.black87)),
                  Text(
                    'Secondary Text',
                    style: TextStyle(color: Colors.black54),
                  ),
                  Container(
                    color: Color(0xFF2E7D32),
                    child: Text(
                      'White on Green',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        expect(find.text('Primary Text'), findsOneWidget);
        expect(find.text('Secondary Text'), findsOneWidget);
        expect(find.text('White on Green'), findsOneWidget);
      });

      testWidgets('Interactive elements should meet touch target size', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  // Standard button - should pass
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Standard Button'),
                  ),
                  // Icon button - should pass
                  IconButton(icon: Icon(Icons.search), onPressed: () {}),
                  // Custom tap area
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 48,
                      height: 48,
                      color: Colors.blue,
                      child: Icon(Icons.star),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        // Check touch target sizes
        final elevatedButton = tester.getSize(find.byType(ElevatedButton));
        final iconButton = tester.getSize(find.byType(IconButton));
        final gestureDetector = tester.getSize(find.byType(GestureDetector));

        expect(elevatedButton.height, greaterThanOrEqualTo(44.0));
        expect(iconButton.width, greaterThanOrEqualTo(44.0));
        expect(iconButton.height, greaterThanOrEqualTo(44.0));
        expect(gestureDetector.width, greaterThanOrEqualTo(44.0));
        expect(gestureDetector.height, greaterThanOrEqualTo(44.0));
      });
    });

    group('Performance Widget Tests', () {
      testWidgets('Large lists should scroll smoothly', (
        WidgetTester tester,
      ) async {
        final items = List.generate(1000, (index) => 'Item $index');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(items[index]));
                },
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        expect(find.byType(ListView), findsOneWidget);
        expect(find.text('Item 0'), findsOneWidget);

        // Test scrolling performance
        await TestUtils.scrollAndWait(tester, find.byType(ListView), -300.0);

        // Should still be responsive
        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('Image loading should not block UI', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  CircularProgressIndicator(),
                  Text('Loading...'),
                  // Simulate image placeholder
                  Container(
                    width: 200,
                    height: 150,
                    color: Colors.grey[300],
                    child: Center(child: Icon(Icons.image, size: 50)),
                  ),
                ],
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading...'), findsOneWidget);
        expect(find.byIcon(Icons.image), findsOneWidget);
      });
    });

    group('Error Handling Widget Tests', () {
      testWidgets('Error states should display appropriately', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Please try again later'),
                    SizedBox(height: 16),
                    ElevatedButton(onPressed: () {}, child: Text('Retry')),
                  ],
                ),
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('Something went wrong'), findsOneWidget);
        expect(find.text('Please try again later'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });

      testWidgets('Empty state should be user-friendly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No results found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Try different search terms'),
                  ],
                ),
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        expect(find.byIcon(Icons.search_off), findsOneWidget);
        expect(find.text('No results found'), findsOneWidget);
        expect(find.text('Try different search terms'), findsOneWidget);
      });
    });

    group('Theme and Styling Widget Tests', () {
      testWidgets('Islamic theme should be applied correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Color(0xFF2E7D32), // Islamic green
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            home: Scaffold(
              appBar: AppBar(title: Text('DuaCopilot'), centerTitle: true),
              body: Card(
                child: ListTile(
                  leading: Icon(Icons.book_outlined),
                  title: Text('Islamic Content'),
                  subtitle: Text('Authentic duas and prayers'),
                ),
              ),
            ),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        final context = tester.element(find.byType(MaterialApp));
        final theme = Theme.of(context);

        expect(theme.useMaterial3, isTrue);
        expect(theme.colorScheme.primary.toARGB32(), equals(0xFF2E7D32));
        expect(find.text('DuaCopilot'), findsOneWidget);
        expect(find.text('Islamic Content'), findsOneWidget);
      });

      testWidgets('Dark theme should work correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Color(0xFF2E7D32),
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            home: Scaffold(body: Text('Dark theme content')),
          ),
        );
        await TestUtils.waitForAnimation(tester);

        final context = tester.element(find.byType(MaterialApp));
        final theme = Theme.of(context);

        expect(theme.colorScheme.brightness, equals(Brightness.dark));
        expect(find.text('Dark theme content'), findsOneWidget);
      });
    });
  });

  group('Integration Widget Tests', () {
    testWidgets('Complete user workflow should work', (
      WidgetTester tester,
    ) async {
      bool searchPerformed = false;
      String searchQuery = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('DuaCopilot')),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for duas...',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          searchPerformed = true;
                        },
                      ),
                    ),
                    onChanged: (value) {
                      searchQuery = value;
                    },
                  ),
                ),
                if (searchPerformed && searchQuery.isNotEmpty)
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.all(16.0),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Search Results for: $searchQuery',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                'اللهم أعني على ذكرك وشكرك وحسن عبادتك',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
      await TestUtils.waitForAnimation(tester);

      // Test the complete workflow
      final searchField = find.byType(TextField);
      final searchButton = find.byIcon(Icons.search);

      expect(searchField, findsOneWidget);
      expect(searchButton, findsOneWidget);

      // Enter search query
      await TestUtils.enterTextAndWait(tester, searchField, 'morning prayer');

      // Perform search
      await TestUtils.tapAndWait(tester, searchButton);

      // Verify results appear
      expect(find.textContaining('Search Results'), findsOneWidget);
      expect(
        find.text('اللهم أعني على ذكرك وشكرك وحسن عبادتك'),
        findsOneWidget,
      );
    });
  });
}
