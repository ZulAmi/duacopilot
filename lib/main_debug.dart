import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Debug Test',
      home: Scaffold(
        body: Center(
          child: Text(
            'HELLO WORLD - Debug Test Working!',
            style: TextStyle(fontSize: 24, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
