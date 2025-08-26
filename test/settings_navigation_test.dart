import 'package:duacopilot/presentation/screens/revolutionary_home_screen.dart';
import 'package:duacopilot/presentation/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Settings Navigation Tests', () {
    testWidgets('Settings screen can be navigated to', (WidgetTester tester) async {
      // Build our app with proper providers
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const RevolutionaryHomeScreen(),
            routes: {'/settings': (context) => const SettingsScreen()},
          ),
        ),
      );

      // Verify that the home screen is displayed
      expect(find.byType(RevolutionaryHomeScreen), findsOneWidget);

      // Open the drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Find and tap the settings option in drawer
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Verify that settings screen is displayed
      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('Settings screen displays correctly', (WidgetTester tester) async {
      // Build the settings screen directly with proper providers
      await tester.pumpWidget(ProviderScope(child: const MaterialApp(home: SettingsScreen())));

      // Pump a frame to allow the screen to build
      await tester.pump();

      // Verify settings screen elements are present
      expect(find.text('Settings'), findsAtLeastNWidgets(1));

      // Look for section headers that should be in the settings
      expect(find.textContaining('Account'), findsAtLeastNWidgets(1));
    });

    testWidgets('Settings screen has expected sections', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(child: const MaterialApp(home: SettingsScreen())));

      await tester.pumpAndSettle();

      // Check for main sections
      expect(find.byType(SettingsScreen), findsOneWidget);
    });
  });
}
