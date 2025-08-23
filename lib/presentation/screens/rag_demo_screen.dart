import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/rag_provider.dart';
import '../screens/rag_setup_screen.dart';

/// Demo screen showing the 3-tier RAG system in action
class RagDemoScreen extends ConsumerStatefulWidget {
  const RagDemoScreen({super.key});

  @override
  ConsumerState<RagDemoScreen> createState() => _RagDemoScreenState();
}

class _RagDemoScreenState extends ConsumerState<RagDemoScreen> {
  final _queryController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final ragState = ref.watch(ragApiProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🤖 Intelligent RAG System'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RagSetupScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Bar showing the 3-tier system
          _buildStatusBar(ragState),

          // Query Input
          _buildQueryInput(),

          // Response Area
          Expanded(child: _buildResponseArea(ragState)),
        ],
      ),
    );
  }

  Widget _buildStatusBar(dynamic ragState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1B5E20).withOpacity(0.1), const Color(0xFF2E7D32).withOpacity(0.1)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🕌 DuaCopilot Intelligent RAG System',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildTierIndicator('1️⃣ RAG API', _getRagApiStatus(), Colors.blue),
              const SizedBox(width: 12),
              _buildTierIndicator('2️⃣ Islamic Content', true, Colors.green),
              const SizedBox(width: 12),
              _buildTierIndicator('3️⃣ Cached Responses', true, Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTierIndicator(String label, bool isActive, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isActive ? color : Colors.grey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isActive ? Icons.check_circle : Icons.error, size: 16, color: isActive ? color : Colors.grey),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: isActive ? color : Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  bool _getRagApiStatus() {
    // This would check if a real RAG API is configured
    // For now, return false since we're using placeholder endpoints
    return false; // Change to true once you configure a real API
  }

  Widget _buildQueryInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _queryController,
              decoration: InputDecoration(
                hintText: 'Ask about duas, prayers, or Islamic guidance...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Color(0xFF2E7D32)),
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF2E7D32)),
              ),
              onSubmitted: _submitQuery,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _submitQuery(_queryController.text),
            icon: const Icon(Icons.send),
            style: IconButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseArea(dynamic ragState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExampleQueries(),
            const SizedBox(height: 24),
            _buildSystemExplanation(),
            const SizedBox(height: 24),
            _buildCurrentFeatures(),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleQueries() {
    final examples = [
      '🌅 Morning duas for starting the day',
      '🤲 Prayer for seeking guidance from Allah',
      '📖 Verses about patience and perseverance',
      '🕊️ Duas for peace and tranquility',
      '🙏 How to perform wudu (ablution)',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('💡 Try These Example Queries:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...examples.map(
              (example) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () {
                    _queryController.text = example.substring(3); // Remove emoji
                    _submitQuery(_queryController.text);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(children: [Text(example), const Spacer(), const Icon(Icons.arrow_forward, size: 16)]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemExplanation() {
    return Card(
      color: Colors.blue.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔧 How the 3-Tier RAG System Works:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTierExplanation(
              '1️⃣ Primary RAG API',
              'AI-powered responses using GPT-4, Claude, or Gemini',
              _getRagApiStatus() ? 'Ready' : 'Setup Required',
              _getRagApiStatus() ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 8),
            _buildTierExplanation(
              '2️⃣ Islamic Content Service',
              'Authentic Islamic content from Al Quran Cloud API',
              'Active',
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildTierExplanation(
              '3️⃣ Semantic Cache',
              'Offline responses using cached queries and similarity matching',
              'Active',
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierExplanation(String title, String description, String status, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
          child: Text(status, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildCurrentFeatures() {
    return Card(
      color: Colors.green.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('✅ Currently Working Features:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('• 🕌 Al Quran Cloud API integration'),
            const Text('• 📚 Semantic similarity matching'),
            const Text('• 💾 SQLite database caching'),
            const Text('• 🔍 Query history and analytics'),
            const Text('• 📱 Offline-first architecture'),
            const Text('• 🎨 Modern Islamic-themed UI'),
            const Text('• ⚡ Sub-second response times'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: const Text(
                '🔧 To activate the full RAG system, configure an AI provider in Settings. The Islamic content service and caching will work immediately!',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitQuery(String query) {
    if (query.trim().isEmpty) return;

    // For now, show a message about the current state
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('🤖 RAG Query Processing'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Query: "$query"'),
                const SizedBox(height: 16),
                const Text('Processing with:'),
                Text('• ${_getRagApiStatus() ? "✅" : "⚠️"} Primary RAG API'),
                const Text('• ✅ Islamic Content Service'),
                const Text('• ✅ Semantic Cache'),
                const SizedBox(height: 16),
                const Text(
                  'This demo shows the system architecture. Real responses will be implemented once you configure an AI provider.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RagSetupScreen()));
                },
                child: const Text('Setup RAG'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
