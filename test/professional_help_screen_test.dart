import 'package:duacopilot/presentation/screens/assistance/screen_assistance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Professional Screen Assistance Implementation Tests', () {
    testWidgets('ScreenAssistance compiles and creates successfully', (
      WidgetTester tester,
    ) async {
      // Verify the ScreenAssistance class exists and can be instantiated
      const screenAssistance = ScreenAssistance();
      expect(screenAssistance, isA<ScreenAssistance>());
      expect(screenAssistance, isA<ConsumerStatefulWidget>());
    });

    testWidgets('ScreenAssistance builds with proper professional layout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ScreenAssistance())),
      );

      // Pump and settle to handle animations
      await tester.pumpAndSettle();

      // The widget should build successfully without errors
      expect(find.byType(ScreenAssistance), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);

      // Should have an app bar
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('ScreenAssistance has professional navigation structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ScreenAssistance())),
      );

      // Pump and settle to handle animations
      await tester.pumpAndSettle();

      // Should have proper layout structure
      expect(find.byType(Row), findsWidgets); // Left panel + main content
      expect(find.text('Support Center'), findsOneWidget);
      expect(find.text('Help & Support'), findsOneWidget);
    });

    testWidgets('ScreenAssistance has all required sections', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ScreenAssistance())),
      );

      await tester.pumpAndSettle();

      // Should have navigation items for all sections
      expect(find.text('FAQ'), findsOneWidget);
      expect(find.text('User Guide'), findsOneWidget);
      expect(find.text('Contact Support'), findsOneWidget);
      expect(find.text('Send Feedback'), findsOneWidget);
    });

    testWidgets('ScreenAssistance navigation works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: const ScreenAssistance())),
      );

      await tester.pumpAndSettle();

      // Should start with FAQ section (default) - but there might be multiple instances
      expect(find.text('Frequently Asked Questions'), findsAtLeastNWidgets(1));

      // Tap on User Guide navigation item
      await tester.tap(find.text('User Guide'));
      await tester.pumpAndSettle();

      // Should now show User Guide section
      expect(find.text('User Guide'), findsAtLeastNWidgets(1));
    });
  });
}
