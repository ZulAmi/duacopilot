// Test import to verify our fixed screen compiles correctly
import 'package:flutter/material.dart';
import 'package:duacopilot/presentation/screens/conversational_search_screen.dart';

void main() {
  runApp(TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      home: const ConversationalSearchScreen(),
    );
  }
}
