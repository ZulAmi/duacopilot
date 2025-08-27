import 'package:flutter/material.dart';

void main() {
  print('🚀 App starting...');

  try {
    runApp(const DebugApp());
    print('✅ runApp called successfully');
  } catch (e, stackTrace) {
    print('❌ Error in runApp: $e');
    print('Stack trace: $stackTrace');
  }
}

class DebugApp extends StatelessWidget {
  const DebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('🏗️ Building DebugApp...');

    return MaterialApp(
      title: 'Debug Test',
      debugShowCheckedModeBanner: false,
      home: const DebugHome(),
    );
  }
}

class DebugHome extends StatefulWidget {
  const DebugHome({super.key});

  @override
  State<DebugHome> createState() => _DebugHomeState();
}

class _DebugHomeState extends State<DebugHome> {
  @override
  void initState() {
    super.initState();
    print('🔧 DebugHome initState called');
  }

  @override
  Widget build(BuildContext context) {
    print('🏗️ Building DebugHome widget...');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.red,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '🎉 SUCCESS!',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'DuaCopilot Flutter Web Demo',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'If you can see this, the deployment works!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
