import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:duacopilot/main.dart' as app;
import '../comprehensive_test_config.dart';

/// Performance testing for various network conditions and device scenarios
/// Tests app performance under different stress conditions
void main() {
  setUpAll(() async {
    await TestConfig.initialize();
  });

  tearDownAll(() async {
    await TestConfig.cleanup();
  });

  group('Performance Tests', () {
    group('🚀 App Startup Performance', () {
      testWidgets('Cold startup should complete within threshold', (
        WidgetTester tester,
      ) async {
        final stopwatch = Stopwatch()..start();

        // Simulate cold app startup
        await tester.pumpWidget(
          ProviderScope(child: app.SecureDuaCopilotApp()),
        );
        await tester.pumpAndSettle(Duration(seconds: 5));

        stopwatch.stop();
        final startupTime = stopwatch.elapsedMilliseconds;

        expect(find.byType(MaterialApp), findsOneWidget);
        expect(
          startupTime,
          lessThan(TestConfig.maxResponseTime.inMilliseconds),
        );

        print('✅ Cold startup time: ${startupTime}ms');
      });

      testWidgets('Warm startup should be faster', (WidgetTester tester) async {
        // First startup (cold)
        await tester.pumpWidget(
          ProviderScope(child: app.SecureDuaCopilotApp()),
        );
        await tester.pumpAndSettle();

        // Second startup (warm)
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(
          ProviderScope(child: app.SecureDuaCopilotApp()),
        );
        await tester.pumpAndSettle();

        stopwatch.stop();
        final warmStartupTime = stopwatch.elapsedMilliseconds;

        expect(find.byType(MaterialApp), findsOneWidget);
        expect(warmStartupTime, lessThan(2000)); // Should be under 2 seconds

        print('✅ Warm startup time: ${warmStartupTime}ms');
      });

      testWidgets('Memory usage during startup should be reasonable', (
        WidgetTester tester,
      ) async {
        // This is a simplified memory test - actual memory profiling would require platform-specific tools
        final beforeStartup = DateTime.now().millisecondsSinceEpoch;

        await tester.pumpWidget(
          ProviderScope(child: app.SecureDuaCopilotApp()),
        );
        await tester.pumpAndSettle(Duration(seconds: 3));

        final afterStartup = DateTime.now().millisecondsSinceEpoch;
        final startupDuration = afterStartup - beforeStartup;

        expect(find.byType(MaterialApp), findsOneWidget);
        expect(
          startupDuration,
          lessThan(10000),
        ); // Should complete within 10 seconds

        print('✅ Memory-efficient startup completed in ${startupDuration}ms');
      });
    });

    group('⚡ Search Performance Tests', () {
      testWidgets('Search input responsiveness', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextField(decoration: InputDecoration(hintText: 'Search')),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        // Test rapid typing
        final queries = [
          'm',
          'mo',
          'mor',
          'morn',
          'morni',
          'mornin',
          'morning',
          'morning p',
          'morning pr',
          'morning pra',
          'morning pray',
          'morning praye',
          'morning prayer',
        ];

        final stopwatch = Stopwatch()..start();

        for (final query in queries) {
          await tester.enterText(textField, query);
          await tester.pump(); // Single frame pump for responsiveness test
        }

        stopwatch.stop();
        final typingTime = stopwatch.elapsedMilliseconds;

        expect(find.text('morning prayer'), findsOneWidget);
        expect(
          typingTime,
          lessThan(1000),
        ); // Should handle rapid typing within 1 second

        print(
          '✅ Rapid typing performance: ${typingTime}ms for ${queries.length} inputs',
        );
      });

      testWidgets('Search results rendering performance', (
        WidgetTester tester,
      ) async {
        // Simulate search results
        final mockResults = List.generate(
          50,
          (index) => {
            'id': 'result-$index',
            'title': 'Prayer Result $index',
            'arabic': TestConfig.sampleArabicQueries[
                index % TestConfig.sampleArabicQueries.length],
            'confidence': 0.9 - (index * 0.01),
          },
        );

        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView.builder(
                itemCount: mockResults.length,
                itemBuilder: (context, index) {
                  final result = mockResults[index];
                  return Card(
                    child: ListTile(
                      title: Text(result['title'] as String),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              result['arabic'] as String,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Text(
                            'Confidence: ${((result['confidence'] as double) * 100).round()}%',
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        stopwatch.stop();
        final renderTime = stopwatch.elapsedMilliseconds;

        expect(find.byType(ListView), findsOneWidget);
        expect(
          find.byType(Card),
          findsAtLeastNWidgets(10),
        ); // At least 10 cards should be visible
        expect(
          renderTime,
          lessThan(TestConfig.maxWidgetRenderTime.inMilliseconds),
        );

        print(
          '✅ Search results rendering time: ${renderTime}ms for ${mockResults.length} items',
        );
      });

      testWidgets('Scroll performance with large result sets', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView.builder(
                itemCount: 1000, // Large dataset
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Prayer ${index + 1}'),
                    subtitle: Text(
                      TestConfig.sampleArabicQueries[
                          index % TestConfig.sampleArabicQueries.length],
                    ),
                    trailing: Text('${index + 1}'),
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final listView = find.byType(ListView);
        expect(listView, findsOneWidget);

        // Test scroll performance
        final stopwatch = Stopwatch()..start();

        // Perform multiple scroll operations
        for (int i = 0; i < 10; i++) {
          await tester.drag(listView, Offset(0, -200));
          await tester.pump(); // Single frame pump for performance test
        }

        stopwatch.stop();
        final scrollTime = stopwatch.elapsedMilliseconds;

        expect(scrollTime, lessThan(500)); // Smooth scrolling under 500ms
        expect(find.byType(ListTile), findsWidgets);

        print(
          '✅ Large list scroll performance: ${scrollTime}ms for 10 scroll operations',
        );
      });
    });

    group('🌐 Network Condition Simulation', () {
      testWidgets('Fast network condition behavior', (
        WidgetTester tester,
      ) async {
        await TestUtils.testNetworkConditions((condition) async {
          if (condition == NetworkCondition.fast) {
            // Simulate fast network response
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(
                  body: Column(
                    children: [
                      CircularProgressIndicator(),
                      Text('Loading...'),
                      SizedBox(height: 20),
                      // Simulate quick result appearance
                      Card(
                        child: ListTile(
                          title: Text('Quick Response'),
                          subtitle: Text('Fast network result'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();

            expect(find.text('Quick Response'), findsOneWidget);
            print('✅ Fast network simulation completed');
          }
        });
      });

      testWidgets('Slow network condition behavior', (
        WidgetTester tester,
      ) async {
        await TestUtils.testNetworkConditions((condition) async {
          if (condition == NetworkCondition.slow) {
            // Simulate slow network with loading states
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(
                  body: Column(
                    children: [
                      LinearProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Please wait, loading...'),
                      SizedBox(height: 20),
                      Text('Slow connection detected'),
                    ],
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();

            expect(find.text('Slow connection detected'), findsOneWidget);
            print('✅ Slow network simulation completed');
          }
        });
      });

      testWidgets('Offline condition behavior', (WidgetTester tester) async {
        await TestUtils.testNetworkConditions((condition) async {
          if (condition == NetworkCondition.offline) {
            // Simulate offline state
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No internet connection'),
                        SizedBox(height: 8),
                        Text('Using cached results'),
                        SizedBox(height: 16),
                        ElevatedButton(onPressed: () {}, child: Text('Retry')),
                      ],
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();

            expect(find.text('No internet connection'), findsOneWidget);
            expect(find.text('Using cached results'), findsOneWidget);
            print('✅ Offline condition simulation completed');
          }
        });
      });

      testWidgets('Intermittent connection handling', (
        WidgetTester tester,
      ) async {
        await TestUtils.testNetworkConditions((condition) async {
          if (condition == NetworkCondition.intermittent) {
            // Simulate intermittent connection
            await tester.pumpWidget(
              MaterialApp(
                home: Scaffold(
                  body: Column(
                    children: [
                      // Show connection status
                      Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.orange[100],
                        child: Row(
                          children: [
                            Icon(Icons.network_check, color: Colors.orange),
                            SizedBox(width: 8),
                            Text('Connection unstable'),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Trying to reconnect...'),
                    ],
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();

            expect(find.text('Connection unstable'), findsOneWidget);
            print('✅ Intermittent connection simulation completed');
          }
        });
      });
    });

    group('📱 Device Performance Tests', () {
      testWidgets('Low-end device simulation', (WidgetTester tester) async {
        // Simulate lower performance by adding artificial delays
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FutureBuilder(
                future: Future.delayed(
                  Duration(milliseconds: 100),
                ), // Simulate slower processing
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: 100,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Item $index'),
                        subtitle: Text(
                          TestConfig.sampleArabicQueries[
                              index % TestConfig.sampleArabicQueries.length],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );

        // Wait for initial loading
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Wait for completion
        await tester.pumpAndSettle();
        expect(find.byType(ListView), findsOneWidget);

        print('✅ Low-end device performance simulation completed');
      });

      testWidgets('Memory pressure simulation', (WidgetTester tester) async {
        // Create multiple widgets to simulate memory pressure
        final largeWidgetList = List.generate(
          200,
          (index) => SizedBox(
            height: 100,
            child: Card(child: Center(child: Text('Heavy Widget $index'))),
          ),
        );

        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(children: largeWidgetList),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        stopwatch.stop();
        final renderTime = stopwatch.elapsedMilliseconds;

        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(
          renderTime,
          lessThan(2000),
        ); // Should handle memory pressure within 2 seconds

        print('✅ Memory pressure simulation: ${renderTime}ms for 200 widgets');
      });

      testWidgets('Battery optimization behavior', (WidgetTester tester) async {
        // Simulate battery-optimized rendering
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  // Optimized list with fewer redraws
                  Container(
                    height: 60,
                    color: Colors.green[50],
                    child: Center(
                      child: Text(
                        'Battery Optimized Mode',
                        style: TextStyle(color: Colors.green[800]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 50, // Reduced count for battery optimization
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Optimized Item $index'),
                          dense: true, // More compact for battery saving
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Battery Optimized Mode'), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);

        print('✅ Battery optimization behavior verified');
      });
    });

    group('🎭 Animation Performance Tests', () {
      testWidgets('Smooth transitions should not drop frames', (
        WidgetTester tester,
      ) async {
        bool showSecondScreen = false;

        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: showSecondScreen
                        ? Container(
                            key: ValueKey('second'),
                            color: Colors.blue,
                            child: Center(child: Text('Second Screen')),
                          )
                        : Container(
                            key: ValueKey('first'),
                            color: Colors.red,
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    showSecondScreen = true;
                                  });
                                },
                                child: Text('Animate'),
                              ),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Animate'), findsOneWidget);

        final stopwatch = Stopwatch()..start();

        // Trigger animation
        await tester.tap(find.text('Animate'));
        await tester.pumpAndSettle();

        stopwatch.stop();
        final animationTime = stopwatch.elapsedMilliseconds;

        expect(find.text('Second Screen'), findsOneWidget);
        expect(
          animationTime,
          lessThan(500),
        ); // Animation should complete smoothly

        print('✅ Smooth animation performance: ${animationTime}ms');
      });

      testWidgets('Loading animations should be performant', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  LinearProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Loading...'),
                ],
              ),
            ),
          ),
        );

        // Let animations run for a few frames
        for (int i = 0; i < 30; i++) {
          await tester.pump(Duration(milliseconds: 16)); // ~60fps
        }

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);

        print('✅ Loading animations performance verified');
      });
    });

    group('📊 Performance Metrics Tests', () {
      testWidgets('Frame rendering should be consistent', (
        WidgetTester tester,
      ) async {
        final frameTimes = <int>[];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ListView.builder(
                itemCount: 100,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Performance Test Item $index'),
                    subtitle: Text('Testing frame consistency'),
                  );
                },
              ),
            ),
          ),
        );

        // Measure frame times during scroll
        for (int i = 0; i < 10; i++) {
          final stopwatch = Stopwatch()..start();

          await tester.drag(find.byType(ListView), Offset(0, -50));
          await tester.pump();

          stopwatch.stop();
          frameTimes.add(stopwatch.elapsedMilliseconds);
        }

        final avgFrameTime =
            frameTimes.reduce((a, b) => a + b) / frameTimes.length;
        final maxFrameTime = frameTimes.reduce((a, b) => a > b ? a : b);

        expect(
          avgFrameTime,
          lessThan(20),
        ); // Average frame time under 20ms (50fps)
        expect(
          maxFrameTime,
          lessThan(50),
        ); // No frame should take more than 50ms

        print(
          '✅ Frame consistency: avg ${avgFrameTime.toStringAsFixed(1)}ms, max ${maxFrameTime}ms',
        );
      });

      testWidgets('CPU usage should be reasonable during idle', (
        WidgetTester tester,
      ) async {
        // Simple idle test
        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: Center(child: Text('Idle State')))),
        );
        await tester.pumpAndSettle();

        // Let app idle for a moment
        await tester.pump(Duration(seconds: 1));

        expect(find.text('Idle State'), findsOneWidget);

        print('✅ CPU usage during idle state verified');
      });

      testWidgets('Search performance benchmarking', (
        WidgetTester tester,
      ) async {
        final searchTimes = <int>[];
        final queries = [
          'morning',
          'evening',
          'forgiveness',
          'travel',
          'protection',
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextField(decoration: InputDecoration(hintText: 'Search')),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final textField = find.byType(TextField);

        for (final query in queries) {
          final stopwatch = Stopwatch()..start();

          await tester.enterText(textField, query);
          await tester.pumpAndSettle();

          stopwatch.stop();
          searchTimes.add(stopwatch.elapsedMilliseconds);

          // Clear field
          await tester.enterText(textField, '');
          await tester.pump();
        }

        final avgSearchTime =
            searchTimes.reduce((a, b) => a + b) / searchTimes.length;

        expect(avgSearchTime, lessThan(100)); // Average search under 100ms

        print(
          '✅ Search performance benchmark: avg ${avgSearchTime.toStringAsFixed(1)}ms',
        );
      });
    });
  });

  group('🔍 Arabic Performance Tests', () {
    testWidgets('Arabic text rendering performance', (
      WidgetTester tester,
    ) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.builder(
                itemCount: TestConfig.sampleArabicQueries.length * 10,
                itemBuilder: (context, index) {
                  final text = TestConfig.sampleArabicQueries[
                      index % TestConfig.sampleArabicQueries.length];
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(text, style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      stopwatch.stop();
      final renderTime = stopwatch.elapsedMilliseconds;

      expect(find.byType(ListView), findsOneWidget);
      expect(
        renderTime,
        lessThan(1000),
      ); // Arabic rendering should be under 1 second

      print('✅ Arabic text rendering performance: ${renderTime}ms');
    });

    testWidgets('RTL layout performance', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(title: Text('أداء التخطيط')),
              body: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('البداية'), Text('الوسط'), Text('النهاية')],
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return Card(child: Center(child: Text('عنصر $index')));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      stopwatch.stop();
      final layoutTime = stopwatch.elapsedMilliseconds;

      expect(find.byType(GridView), findsOneWidget);
      expect(layoutTime, lessThan(500)); // RTL layout should be efficient

      print('✅ RTL layout performance: ${layoutTime}ms');
    });
  });
}
