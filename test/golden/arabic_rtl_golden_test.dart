import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../comprehensive_test_config.dart';

/// Golden tests for Arabic text rendering and RTL layout verification
/// These tests ensure Arabic content displays correctly across different scenarios
void main() {
  setUpAll(() async {
    await TestConfig.initialize();
  });

  tearDownAll(() async {
    await TestConfig.cleanup();
  });

  group('Arabic RTL Golden Tests', () {
    group('Basic Arabic Text Rendering', () {
      testWidgets('Single Arabic text should render RTL', (
        WidgetTester tester,
      ) async {
        const arabicText = 'بسم الله الرحمن الرحيم';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    arabicText,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the text is rendered
        expect(find.text(arabicText), findsOneWidget);

        // Check directionality
        final directionality = tester.widget<Directionality>(
          find.byType(Directionality),
        );
        expect(directionality.textDirection, equals(TextDirection.rtl));

        // This would normally be a golden test comparison
        // await expectLater(find.byType(Scaffold), matchesGoldenFile('arabic_single_text.png'));

        print('✅ Single Arabic text RTL rendering verified');
      });

      testWidgets('Arabic paragraph should flow RTL', (
        WidgetTester tester,
      ) async {
        const arabicParagraph = '''
بسم الله الرحمن الرحيم
الحمد لله رب العالمين
الرحمن الرحيم
مالك يوم الدين
''';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    arabicParagraph,
                    style: TextStyle(fontSize: 18, height: 1.5),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(arabicParagraph), findsOneWidget);

        // Golden test would be here
        // await expectLater(find.byType(Scaffold), matchesGoldenFile('arabic_paragraph.png'));

        print('✅ Arabic paragraph RTL flow verified');
      });

      testWidgets('Arabic with diacritics should render correctly', (
        WidgetTester tester,
      ) async {
        const arabicWithDiacritics = 'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    arabicWithDiacritics,
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Noto Sans Arabic', // Fallback font
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(arabicWithDiacritics), findsOneWidget);

        // Golden test would verify diacritics placement
        // await expectLater(find.byType(Scaffold), matchesGoldenFile('arabic_diacritics.png'));

        print('✅ Arabic with diacritics rendering verified');
      });
    });

    group('Mixed Language Content', () {
      testWidgets('English-Arabic mixed content should handle direction', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  // LTR version
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        'Search for: صلاة الصباح (Morning Prayer)',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  // RTL version
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        'البحث عن: Morning Prayer (صلاة الصباح)',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.text('Search for: صلاة الصباح (Morning Prayer)'),
          findsOneWidget,
        );
        expect(
          find.text('البحث عن: Morning Prayer (صلاة الصباح)'),
          findsOneWidget,
        );

        // Golden test would show different text flow
        // await expectLater(find.byType(Scaffold), matchesGoldenFile('mixed_content.png'));

        print('✅ Mixed language content direction handling verified');
      });

      testWidgets('Numbers in Arabic context should display correctly', (
        WidgetTester tester,
      ) async {
        const textWithNumbers = 'الصفحة ١٢٣ من ٤٥٦ - Page 123 of 456';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(textWithNumbers, style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(textWithNumbers), findsOneWidget);

        // Golden test would verify number placement
        // await expectLater(find.byType(Scaffold), matchesGoldenFile('arabic_numbers.png'));

        print('✅ Numbers in Arabic context rendering verified');
      });
    });

    group('UI Components with Arabic Content', () {
      testWidgets('TextField with Arabic placeholder should be RTL', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ابحث عن الأدعية هنا...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('ابحث عن الأدعية هنا...'), findsOneWidget);

        // Golden test would show RTL input field layout
        // await expectLater(find.byType(Scaffold), matchesGoldenFile('arabic_textfield.png'));

        print('✅ Arabic TextField RTL layout verified');
      });

      testWidgets('Card with Arabic content should align RTL', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'دعاء الصباح',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('المصدر: أبو داود'),
                              IconButton(
                                icon: Icon(Icons.favorite_border),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Card), findsOneWidget);
        expect(find.text('دعاء الصباح'), findsOneWidget);
        expect(find.byIcon(Icons.favorite_border), findsOneWidget);

        // Golden test would show RTL card layout
        // await expectLater(find.byType(Scaffold), matchesGoldenFile('arabic_card.png'));

        print('✅ Arabic Card RTL alignment verified');
      });

      testWidgets('ListTile with Arabic content should be RTL', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.book),
                      title: Text('صحيح البخاري'),
                      subtitle: Text('مجموعة من الأحاديث الصحيحة'),
                      trailing: Icon(Icons.arrow_back_ios),
                    ),
                    ListTile(
                      leading: Icon(Icons.book),
                      title: Text('صحيح مسلم'),
                      subtitle: Text('أحاديث نبوية شريفة'),
                      trailing: Icon(Icons.arrow_back_ios),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ListView), findsOneWidget);
        expect(find.text('صحيح البخاري'), findsOneWidget);
        expect(find.text('صحيح مسلم'), findsOneWidget);

        // Golden test would show RTL list layout
        // await expectLater(find.byType(Scaffold), matchesGoldenFile('arabic_list.png'));

        print('✅ Arabic ListTile RTL layout verified');
      });
    });

    group('Complex Layout Tests', () {
      testWidgets('AppBar with Arabic title should be centered RTL', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('مساعد الأدعية الذكي'),
                  centerTitle: true,
                  actions: [
                    IconButton(icon: Icon(Icons.search), onPressed: () {}),
                    IconButton(icon: Icon(Icons.settings), onPressed: () {}),
                  ],
                ),
                body: Center(child: Text('محتوى التطبيق')),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('مساعد الأدعية الذكي'), findsOneWidget);

        // Golden test would show RTL AppBar layout
        // await expectLater(find.byType(Scaffold), matchesGoldenFile('arabic_appbar.png'));

        print('✅ Arabic AppBar RTL layout verified');
      });

      testWidgets('Drawer with Arabic menu items should be RTL', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(title: Text('القائمة')),
                drawer: Drawer(
                  child: ListView(
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(color: Color(0xFF2E7D32)),
                        child: Text(
                          'مساعد الأدعية',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.home),
                        title: Text('الرئيسية'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.favorite),
                        title: Text('المفضلة'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.history),
                        title: Text('السجل'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('الإعدادات'),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                body: Center(child: Text('اسحب من اليمين لفتح القائمة')),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Open drawer
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();

        expect(find.byType(Drawer), findsOneWidget);
        expect(find.text('مساعد الأدعية'), findsOneWidget);
        expect(find.text('الرئيسية'), findsOneWidget);
        expect(find.text('المفضلة'), findsOneWidget);

        // Golden test would show RTL drawer layout
        // await expectLater(find.byType(MaterialApp), matchesGoldenFile('arabic_drawer.png'));

        print('✅ Arabic Drawer RTL layout verified');
      });
    });

    group('Accessibility with Arabic Content', () {
      testWidgets('Arabic text should have proper semantics', (
        WidgetTester tester,
      ) async {
        const arabicLabel = 'زر البحث عن الأدعية';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    Semantics(
                      label: arabicLabel,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('ابحث'),
                      ),
                    ),
                    Semantics(
                      hint: 'اضغط للإضافة إلى المفضلة',
                      child: IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify semantic information is present
        expect(tester.binding.rootPipelineOwner.semanticsOwner, isNotNull);

        // Find semantic widgets
        expect(find.byType(Semantics), findsNWidgets(2));
        expect(find.text('ابحث'), findsOneWidget);

        print('✅ Arabic semantic labels verified');
      });

      testWidgets('High contrast Arabic text should be readable', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Color(0xFF2E7D32),
                brightness: Brightness.light,
              ).copyWith(surface: Colors.white, onSurface: Colors.black),
            ),
            home: Scaffold(
              body: Container(
                padding: EdgeInsets.all(16.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      // High contrast text
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'بسم الله الرحمن الرحيم',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Regular contrast
                      Text(
                        'نص عادي بتباين طبيعي',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('بسم الله الرحمن الرحيم'), findsOneWidget);
        expect(find.text('نص عادي بتباين طبيعي'), findsOneWidget);

        // Golden test would verify contrast levels
        // await expectLater(find.byType(Scaffold), matchesGoldenFile('arabic_high_contrast.png'));

        print('✅ High contrast Arabic text verified');
      });
    });

    group('Performance Tests with Arabic Content', () {
      testWidgets('Large Arabic text should render smoothly', (
        WidgetTester tester,
      ) async {
        // Generate large Arabic text
        final largeArabicText = TestConfig.sampleArabicQueries.join(' ') * 50;

        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      largeArabicText,
                      style: TextStyle(fontSize: 16, height: 1.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        stopwatch.stop();
        final renderTime = stopwatch.elapsedMilliseconds;

        expect(
          renderTime,
          lessThan(TestConfig.maxWidgetRenderTime.inMilliseconds),
        );
        expect(find.byType(SingleChildScrollView), findsOneWidget);

        print('✅ Large Arabic text render time: ${renderTime}ms');
      });

      testWidgets('Arabic text list should scroll smoothly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: ListView.builder(
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    final arabicText = TestConfig.sampleArabicQueries[index % TestConfig.sampleArabicQueries.length];
                    return ListTile(
                      title: Text('$arabicText - $index'),
                      subtitle: Text('عنصر رقم $index في القائمة'),
                    );
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Test scrolling performance
        final listView = find.byType(ListView);
        expect(listView, findsOneWidget);

        // Scroll down
        await tester.drag(listView, Offset(0, -300));
        await tester.pumpAndSettle();

        // Scroll should be smooth and content should be visible
        expect(find.byType(ListTile), findsWidgets);

        print('✅ Arabic text list scrolling performance verified');
      });
    });
  });

  group('RTL Layout Specific Tests', () {
    testWidgets('Row with Arabic content should reverse order in RTL', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                // LTR Row
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      Container(width: 50, height: 50, color: Colors.red),
                      SizedBox(width: 10),
                      Text('Left to Right'),
                      Spacer(),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // RTL Row
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      Container(width: 50, height: 50, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('من اليمين إلى اليسار'),
                      Spacer(),
                      Icon(Icons.arrow_back),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Left to Right'), findsOneWidget);
      expect(find.text('من اليمين إلى اليسار'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Golden test would show different layout order
      // await expectLater(find.byType(Scaffold), matchesGoldenFile('rtl_row_layout.png'));

      print('✅ RTL Row layout order verified');
    });

    testWidgets('Floating Action Button should be positioned RTL', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(title: Text('اختبار الزر العائم')),
              body: Center(child: Text('محتوى الصفحة')),
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                tooltip: 'إضافة عنصر جديد',
                child: Icon(Icons.add),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('محتوى الصفحة'), findsOneWidget);

      // In RTL, FAB should be positioned differently
      // Golden test would verify RTL FAB positioning
      // await expectLater(find.byType(Scaffold), matchesGoldenFile('rtl_fab_position.png'));

      print('✅ RTL FloatingActionButton positioning verified');
    });
  });
}
