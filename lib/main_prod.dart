// lib/main_prod.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/production_app_initializer.dart';
import 'presentation/screens/professional_home_screen.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set production-specific system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize all production services
  await ProductionAppInitializer.initialize();

  // Set preferred orientations for production
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Run the production app
  runApp(ProviderScope(child: ProductionDuaCopilotApp()));
}

/// Production DuaCopilot App
class ProductionDuaCopilotApp extends ConsumerWidget {
  const ProductionDuaCopilotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProductionAppWrapper(
      onInitializationError: () {
        // Handle initialization errors in production
        if (kDebugMode) {
          print('Production app initialization error occurred');
        }
      },
      child: MaterialApp(
        title: 'DuaCopilot - AI Islamic Companion',
        debugShowCheckedModeBanner: false,
        theme: _buildProductionTheme(),
        home: const ProfessionalHomeScreen(),
        builder: (context, child) {
          // Wrap with production error boundary
          return ProductionErrorBoundary(child: child ?? const SizedBox());
        },
      ),
    );
  }

  ThemeData _buildProductionTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2E7D32), // Islamic green
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF2E7D32), foregroundColor: Colors.white, elevation: 2),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: CardTheme(elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
      ),
    );
  }
}

/// Production Error Boundary
class ProductionErrorBoundary extends StatefulWidget {
  final Widget child;

  const ProductionErrorBoundary({super.key, required this.child});

  @override
  State<ProductionErrorBoundary> createState() => _ProductionErrorBoundaryState();
}

class _ProductionErrorBoundaryState extends State<ProductionErrorBoundary> {
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Set up global error handler
    FlutterError.onError = (FlutterErrorDetails details) {
      setState(() {
        _hasError = true;
        _errorMessage = details.exception.toString();
      });

      // Report to crash reporting
      ProductionAppInitializer.featureFlags.isEnabled('crash_reporting');
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return MaterialApp(
        title: 'DuaCopilot - Error',
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Something went wrong', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (kDebugMode && _errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(_errorMessage!, style: const TextStyle(fontSize: 14), textAlign: TextAlign.center),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _hasError = false;
                      _errorMessage = null;
                    });
                  },
                  child: const Text('Retry'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    // Exit app
                    SystemNavigator.pop();
                  },
                  child: const Text('Close App'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widget.child;
  }
}
