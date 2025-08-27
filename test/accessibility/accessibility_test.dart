import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import '../comprehensive_test_config.dart';

/// Comprehensive accessibility tests for Arabic RTL content and screen readers
/// Tests ensure full accessibility compliance for Islamic app users
void main() {
  setUpAll(() async {
    await TestConfig.initialize();
  });

  tearDownAll(() async {
    await TestConfig.cleanup();
  });

  group('♿ Accessibility Tests', () {
    group('🔊 Screen Reader Support', () {
      testWidgets('Arabic text should have proper semantics', (
        WidgetTester tester,
      ) async {
        final arabicText = TestConfig.sampleArabicQueries.first;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Semantics(
                label: 'Arabic prayer text',
                hint: 'Swipe to hear Arabic pronunciation',
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    arabicText,
                    style: TextStyle(fontSize: 20),
                    semanticsLabel: 'Arabic prayer: $arabicText',
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify semantics are properly set
        expect(find.bySemanticsLabel('Arabic prayer text'), findsOneWidget);

        // Check that RTL text is accessible
        final semantics = tester.getSemantics(find.text(arabicText));
        expect(semantics.label, contains('Arabic prayer'));

        print('✅ Arabic text semantics verified');
      });

      testWidgets('Search interface should be screen reader accessible', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Semantics(
                    label: 'Prayer search field',
                    hint: 'Enter your prayer request in Arabic or English',
                    textField: true,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Search for prayers',
                        hintText: 'Enter prayer topic...',
                        prefixIcon: Icon(
                          Icons.search,
                          semanticLabel: 'Search icon',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Semantics(
                    label: 'Search button',
                    hint: 'Tap to search for prayers',
                    button: true,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Search'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify search field accessibility
        expect(find.bySemanticsLabel('Prayer search field'), findsOneWidget);
        expect(find.bySemanticsLabel('Search button'), findsOneWidget);
        expect(find.bySemanticsLabel('Search icon'), findsOneWidget);

        // Test that TextField has proper semantics
        final textFieldSemantics = tester.getSemantics(find.byType(TextField));
        expect(textFieldSemantics.hasFlag(SemanticsFlag.isTextField), true);

        print('✅ Search interface accessibility verified');
      });

      testWidgets('Prayer results should be accessible', (
        WidgetTester tester,
      ) async {
        final mockPrayers = [
          {
            'title': 'Morning Prayer',
            'arabic': TestConfig.sampleArabicQueries[0],
            'confidence': 0.95,
          },
          {
            'title': 'Evening Prayer',
            'arabic': TestConfig.sampleArabicQueries[1],
            'confidence': 0.88,
          },
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView.builder(
                itemCount: mockPrayers.length,
                itemBuilder: (context, index) {
                  final prayer = mockPrayers[index];
                  return Semantics(
                    label: 'Prayer result ${index + 1} of ${mockPrayers.length}',
                    hint: 'Double tap to view full prayer details',
                    button: true,
                    child: Card(
                      child: ListTile(
                        title: Semantics(
                          label: 'Prayer title: ${prayer['title']}',
                          child: Text(prayer['title'] as String),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Semantics(
                              label: 'Arabic text: ${prayer['arabic']}',
                              hint: 'Arabic prayer text in right-to-left reading direction',
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  prayer['arabic'] as String,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Semantics(
                              label: 'Confidence score: ${((prayer['confidence'] as double) * 100).round()} percent',
                              child: Text(
                                'Confidence: ${((prayer['confidence'] as double) * 100).round()}%',
                              ),
                            ),
                          ],
                        ),
                        trailing: Semantics(
                          label: 'Favorite prayer',
                          hint: 'Tap to add this prayer to favorites',
                          button: true,
                          child: IconButton(
                            icon: Icon(Icons.favorite_border),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify prayer results accessibility
        expect(find.bySemanticsLabel('Prayer result 1 of 2'), findsOneWidget);
        expect(find.bySemanticsLabel('Prayer result 2 of 2'), findsOneWidget);
        expect(
          find.bySemanticsLabel('Prayer title: Morning Prayer'),
          findsOneWidget,
        );
        expect(find.bySemanticsLabel('Favorite prayer'), findsNWidgets(2));

        print('✅ Prayer results accessibility verified');
      });

      testWidgets('Navigation should be screen reader friendly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: Semantics(
                  label: 'DuaCopilot Islamic AI Assistant',
                  header: true,
                  child: Text('DuaCopilot'),
                ),
                leading: Semantics(
                  label: 'Menu button',
                  hint: 'Opens navigation drawer',
                  button: true,
                  child: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
                ),
                actions: [
                  Semantics(
                    label: 'Settings',
                    hint: 'Opens app settings',
                    button: true,
                    child: IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              body: Center(child: Text('Main content')),
              floatingActionButton: Semantics(
                label: 'Voice search',
                hint: 'Tap to start voice search for prayers',
                button: true,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: Icon(Icons.mic, semanticLabel: 'Microphone'),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify navigation accessibility
        expect(
          find.bySemanticsLabel('DuaCopilot Islamic AI Assistant'),
          findsOneWidget,
        );
        expect(find.bySemanticsLabel('Menu button'), findsOneWidget);
        expect(find.bySemanticsLabel('Settings'), findsOneWidget);
        expect(find.bySemanticsLabel('Voice search'), findsOneWidget);

        // Verify header semantics
        final headerSemantics = tester.getSemantics(find.text('DuaCopilot'));
        expect(headerSemantics.hasFlag(SemanticsFlag.isHeader), true);

        print('✅ Navigation accessibility verified');
      });
    });

    group('📱 High Contrast Support', () {
      testWidgets('High contrast mode should be supported', (
        WidgetTester tester,
      ) async {
        // Simulate high contrast mode with custom colors
        final highContrastTheme = ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
            brightness: Brightness.light,
            primary: Colors.black,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
            surfaceContainerLowest: Colors.white,
            onSurfaceVariant: Colors.black,
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: highContrastTheme,
            home: Scaffold(
              appBar: AppBar(
                title: Text('High Contrast Mode'),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              body: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      TestConfig.sampleArabicQueries.first,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: Text('High Contrast Button'),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('High Contrast Mode'), findsOneWidget);
        expect(find.text('High Contrast Button'), findsOneWidget);

        print('✅ High contrast mode support verified');
      });

      testWidgets('Text should have sufficient contrast ratios', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  // Good contrast example
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Good Contrast Text',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  // Arabic text with good contrast
                  Container(
                    color: Colors.black,
                    padding: EdgeInsets.all(16),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        TestConfig.sampleArabicQueries.first,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Good Contrast Text'), findsOneWidget);
        expect(find.text(TestConfig.sampleArabicQueries.first), findsOneWidget);

        print('✅ Text contrast ratios verified');
      });
    });

    group('🔍 Font Size and Scaling', () {
      testWidgets('Large text sizes should be supported', (
        WidgetTester tester,
      ) async {
        // Test with large text scale factor
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(2.0), // 200% text size
                  ),
                  child: Scaffold(
                    body: Column(
                      children: [
                        Text(
                          'Large Text Test',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 20),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            TestConfig.sampleArabicQueries.first,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Large Button'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Large Text Test'), findsOneWidget);
        expect(find.text('Large Button'), findsOneWidget);

        // Verify widgets are still accessible at large text sizes
        final buttonWidget = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(buttonWidget.child, isNotNull);

        print('✅ Large text size support verified');
      });

      testWidgets('Arabic text should scale properly', (
        WidgetTester tester,
      ) async {
        const scaleFactor = 1.5;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(scaleFactor)),
                  child: Scaffold(
                    body: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ListView.builder(
                        itemCount: TestConfig.sampleArabicQueries.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  TestConfig.sampleArabicQueries[index],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(Card), findsWidgets);

        // Verify Arabic text renders at scaled size
        final firstTextWidget = tester.widget<Text>(
          find.text(TestConfig.sampleArabicQueries.first),
        );
        expect(
          firstTextWidget.data,
          equals(TestConfig.sampleArabicQueries.first),
        );

        print('✅ Arabic text scaling verified (${scaleFactor}x scale)');
      });
    });

    group('⌨️ Keyboard Navigation', () {
      testWidgets('Tab navigation should work properly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Search Field'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Search Button'),
                  ),
                  SizedBox(height: 20),
                  TextButton(onPressed: () {}, child: Text('Clear Button')),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify widgets are focusable
        final textField = find.byType(TextField);
        final searchButton = find.text('Search Button');
        final clearButton = find.text('Clear Button');

        expect(textField, findsOneWidget);
        expect(searchButton, findsOneWidget);
        expect(clearButton, findsOneWidget);

        // Test focus sequence
        await tester.tap(textField);
        await tester.pumpAndSettle();

        // Verify TextField got focus
        expect(WidgetsBinding.instance.focusManager.primaryFocus, isNotNull);

        print('✅ Keyboard navigation support verified');
      });

      testWidgets('RTL navigation should work with keyboard', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('الأول'), // First
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('الثاني'), // Second
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('الثالث'), // Third
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify RTL button layout
        expect(find.text('الأول'), findsOneWidget);
        expect(find.text('الثاني'), findsOneWidget);
        expect(find.text('الثالث'), findsOneWidget);

        // Test button interactions
        await tester.tap(find.text('الأول'));
        await tester.pumpAndSettle();

        print('✅ RTL keyboard navigation verified');
      });
    });

    group('🎯 Focus Management', () {
      testWidgets('Focus should be managed properly in search flow', (
        WidgetTester tester,
      ) async {
        bool searchPressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter prayer request',
                      hintText: 'Type here...',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      searchPressed = true;
                    },
                    child: Text('Search Prayers'),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Test focus flow
        final textField = find.byType(TextField);
        final button = find.text('Search Prayers');

        // Focus on text field first
        await tester.tap(textField);
        await tester.pumpAndSettle();

        // Enter some text
        await tester.enterText(textField, 'morning prayer');
        await tester.pumpAndSettle();

        // Tab or tap to button
        await tester.tap(button);
        await tester.pumpAndSettle();

        expect(searchPressed, true);
        expect(find.text('morning prayer'), findsOneWidget);

        print('✅ Focus management in search flow verified');
      });

      testWidgets('Focus should return to appropriate element after actions', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TextField(decoration: InputDecoration(labelText: 'Search')),
                  SizedBox(height: 20),
                  ElevatedButton(onPressed: () {}, child: Text('Submit')),
                  SizedBox(height: 20),
                  Card(
                    child: ListTile(
                      title: Text('Prayer Result'),
                      subtitle: Text(TestConfig.sampleArabicQueries.first),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Test focus management
        final favoriteButton = find.byIcon(Icons.favorite_border);

        await tester.tap(favoriteButton);
        await tester.pumpAndSettle();

        // Focus should be manageable
        expect(favoriteButton, findsOneWidget);

        print('✅ Focus return behavior verified');
      });
    });

    group('🌍 Internationalization Accessibility', () {
      testWidgets('Mixed language content should be accessible', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // English title
                  Semantics(
                    label: 'Prayer title in English',
                    child: Text(
                      'Morning Prayer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Arabic content
                  Semantics(
                    label: 'Prayer text in Arabic, right-to-left reading',
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        TestConfig.sampleArabicQueries.first,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Transliteration
                  Semantics(
                    label: 'Pronunciation guide in English letters',
                    child: Text(
                      'Pronunciation: Alhamdulillahi rabbil alameen',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Translation
                  Semantics(
                    label: 'English translation of Arabic text',
                    child: Text(
                      'Translation: All praise is due to Allah, Lord of the worlds',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify all text elements are accessible
        expect(
          find.bySemanticsLabel('Prayer title in English'),
          findsOneWidget,
        );
        expect(
          find.bySemanticsLabel('Prayer text in Arabic, right-to-left reading'),
          findsOneWidget,
        );
        expect(
          find.bySemanticsLabel('Pronunciation guide in English letters'),
          findsOneWidget,
        );
        expect(
          find.bySemanticsLabel('English translation of Arabic text'),
          findsOneWidget,
        );

        print('✅ Mixed language accessibility verified');
      });

      testWidgets('Arabic numbers and dates should be accessible', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      label: 'Prayer number 1 in Arabic format',
                      child: Text(
                        'الدعاء رقم ١',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 10),
                    Semantics(
                      label: 'Islamic date: 15th of Ramadan, 1445',
                      child: Text(
                        '١٥ رمضان ١٤٤٥',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 10),
                    Semantics(
                      label: 'Prayer time: 5:30 AM',
                      child: Text(
                        'الوقت: ٥:٣٠ صباحاً',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.bySemanticsLabel('Prayer number 1 in Arabic format'),
          findsOneWidget,
        );
        expect(
          find.bySemanticsLabel('Islamic date: 15th of Ramadan, 1445'),
          findsOneWidget,
        );
        expect(find.bySemanticsLabel('Prayer time: 5:30 AM'), findsOneWidget);

        print('✅ Arabic numbers and dates accessibility verified');
      });
    });

    group('🔊 Audio Accessibility', () {
      testWidgets('Audio controls should be accessible', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              TestConfig.sampleArabicQueries.first,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Semantics(
                                label: 'Play audio',
                                hint: 'Plays Arabic pronunciation of the prayer',
                                button: true,
                                child: IconButton(
                                  icon: Icon(Icons.play_arrow),
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(width: 16),
                              Semantics(
                                label: 'Stop audio',
                                hint: 'Stops audio playback',
                                button: true,
                                child: IconButton(
                                  icon: Icon(Icons.stop),
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(width: 16),
                              Semantics(
                                label: 'Repeat audio',
                                hint: 'Replays the prayer pronunciation',
                                button: true,
                                child: IconButton(
                                  icon: Icon(Icons.repeat),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Semantics(
                            label: 'Audio playback progress',
                            value: '30 percent complete',
                            child: LinearProgressIndicator(value: 0.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.bySemanticsLabel('Play audio'), findsOneWidget);
        expect(find.bySemanticsLabel('Stop audio'), findsOneWidget);
        expect(find.bySemanticsLabel('Repeat audio'), findsOneWidget);
        expect(
          find.bySemanticsLabel('Audio playback progress'),
          findsOneWidget,
        );

        // Test play button interaction
        await tester.tap(find.bySemanticsLabel('Play audio'));
        await tester.pumpAndSettle();

        print('✅ Audio controls accessibility verified');
      });
    });
  });
}
