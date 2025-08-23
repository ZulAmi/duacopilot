import 'package:flutter/material.dart';
import '../core/performance/performance_integration.dart';

/// Example showing how to use the performance optimization system
class PerformanceOptimizedExampleApp extends StatelessWidget {
  const PerformanceOptimizedExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap your app with performance optimizations
    return PerformanceOptimizedApp(
      enableArabicScrollOptimization: true,
      enablePerformanceMonitoring: true,
      child: MaterialApp(
        title: 'DuaCopilot - Performance Optimized',
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Amiri', // Arabic font
        ),
        home: const ExampleHomePage(),
      ),
    );
  }
}

/// ExampleHomePage class implementation
class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

/// _ExampleHomePageState class implementation
class _ExampleHomePageState extends State<ExampleHomePage> {
  final List<String> _ragResponses = [
    'اللهم اغفر لي ذنبي',
    'سبحان الله وبحمده',
    'لا إله إلا الله',
    'الحمد لله رب العالمين',
    'اللهم صل على محمد',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performance Optimized RAG')),
      body: Column(
        children: [
          // Performance monitoring example
          _buildPerformanceDemo(),

          // Arabic scroll optimization example
          Expanded(child: _buildOptimizedArabicList()),

          // Media optimization example
          _buildMediaOptimizationDemo(),
        ],
      ),
    );
  }

  Widget _buildPerformanceDemo() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Monitoring Demo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _demonstratePerformanceMeasurement,
              child: const Text('Measure RAG Operation'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _demonstrateBackgroundProcessing,
              child: const Text('Background Text Analysis'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptimizedArabicList() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Arabic Optimized List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            // Use Arabic scroll optimization
            child: ListView.builder(
              itemCount: _ragResponses.length * 10, // Simulate large list
              itemBuilder: (context, index) {
                final response = _ragResponses[index % _ragResponses.length];
                return ListTile(
                  title: Text(
                    response,
                    style: const TextStyle(fontSize: 16),
                    textDirection: TextDirection.rtl,
                  ),
                  subtitle: Text('Response ${index + 1}'),
                  leading: const Icon(Icons.message),
                );
              },
            ).withArabicScrollOptimization(isRTL: true),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaOptimizationDemo() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Media Optimization Demo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: PerformanceHelpers.createOptimizedImage(
                    imageUrl:
                        'https://via.placeholder.com/150x100/4CAF50/FFFFFF?text=Islamic+Art',
                    width: 150,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: const CircularProgressIndicator(),
                    errorWidget: const Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Optimized image loading with smart caching and compression.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _demonstratePerformanceMeasurement() async {
    // Demonstrate performance measurement
    final result = await PerformanceHelpers.measurePerformance(
      operationName: 'demo_rag_operation',
      operation: () async {
        // Simulate RAG processing
        await Future.delayed(const Duration(milliseconds: 500));
        return 'Processed Arabic query successfully';
      },
      attributes: {
        'query_type': 'demo',
        'language': 'arabic',
        'user_interface': 'example_app',
      },
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Operation completed: $result'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _demonstrateBackgroundProcessing() async {
    const arabicText = 'اللهم اغفر لي ذنبي وخطئي وجهلي';

    try {
      // Extract keywords in background
      final keywords = await PerformanceHelpers.extractKeywordsInBackground(
        arabicText,
      );

      // Analyze sentiment in background
      final sentiment = await PerformanceHelpers.analyzeSentimentInBackground(
        arabicText,
      );

      if (mounted) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Background Analysis Results'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Keywords: ${keywords.join(', ')}'),
                    const SizedBox(height: 8),
                    Text('Sentiment: ${sentiment.sentiment}'),
                    Text(
                      'Confidence: ${sentiment.confidence.toStringAsFixed(2)}',
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Analysis failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Example of how to add performance monitoring to existing widgets
class PerformanceMonitoredWidget extends StatelessWidget {
  final String content;

  const PerformanceMonitoredWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        content,
        style: const TextStyle(fontSize: 16),
        textDirection: TextDirection.rtl,
      ),
    ).withPerformanceMonitoring(
      name: 'arabic_content_display',
      attributes: {
        'content_length': content.length.toString(),
        'content_type': 'arabic_text',
      },
    );
  }
}

/// Example of platform-specific optimizations
class PlatformAwareExample extends StatelessWidget {
  const PlatformAwareExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Get platform-specific configuration
    final platformConfig = PerformanceHelpers.getPlatformConfig();

    return AnimatedContainer(
      duration: platformConfig.pageTransitionDuration,
      curve: Curves.easeInOut,
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Platform: ${platformConfig.platformName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Animation Duration: ${platformConfig.pageTransitionDuration.inMilliseconds}ms',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Max Network Requests: ${platformConfig.maxConcurrentNetworkRequests}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'High Refresh Rate: ${platformConfig.enableHighRefreshRate ? 'Enabled' : 'Disabled'}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
