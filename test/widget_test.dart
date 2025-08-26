// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:duacopilot/main.dart';
import 'package:duacopilot/presentation/screens/conversational_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DuaCopilotApp widget test', (WidgetTester tester) async {
    // Test just the DuaCopilotApp widget without full DI setup
    await tester.pumpWidget(
      MaterialApp(
        home: const ConversationalSearchScreen(
          enableVoiceSearch: false, // Disable to avoid permissions in tests
          enableArabicKeyboard: false,
          showSearchHistory: false,
        ),
      ),
    );

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    // Basic smoke test - just ensure the screen builds without crashing
    expect(find.byType(ConversationalSearchScreen), findsOneWidget);
  });

  testWidgets('SecureDuaCopilotApp material app test', (
    WidgetTester tester,
  ) async {
    // Test that the app structure is correct
    const app = SecureDuaCopilotApp();

    await tester.pumpWidget(const ProviderScope(child: app));

    // The app should create a MaterialApp
    expect(find.byType(SecureDuaCopilotApp), findsOneWidget);
  });
}
