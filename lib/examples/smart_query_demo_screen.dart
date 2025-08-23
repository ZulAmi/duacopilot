import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/query_context.dart';
import '../presentation/providers/rag_provider.dart';
import '../presentation/providers/rag_state_models.dart';

/// Example widget demonstrating smart query enhancement features
class SmartQueryDemoScreen extends ConsumerStatefulWidget {
  const SmartQueryDemoScreen({super.key});

  @override
  ConsumerState<SmartQueryDemoScreen> createState() =>
      _SmartQueryDemoScreenState();
}

/// _SmartQueryDemoScreenState class implementation
class _SmartQueryDemoScreenState extends ConsumerState<SmartQueryDemoScreen> {
  final TextEditingController _queryController = TextEditingController();
  String _selectedLanguage = 'en';
  String? _selectedLocation;
  Map<String, dynamic> _userPreferences = {};

  @override
  void initState() {
    super.initState();
    _initializeDefaults();
  }

  void _initializeDefaults() {
    _userPreferences = {
      'preferred_school': 'Hanafi',
      'difficulty_level': 'intermediate',
      'preferred_categories': ['daily_prayers', 'guidance'],
      'emotional_sensitivity': 'moderate',
    };
  }

  @override
  Widget build(BuildContext context) {
    final ragState = ref.watch(ragApiProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Query Enhancement Demo'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Configuration Panel
          _buildConfigurationPanel(),

          // Query Input
          _buildQueryInput(),

          // Enhancement Options
          _buildEnhancementOptions(),

          // Results Display
          Expanded(
            child: ragState.when(
              data: (data) => _buildResults(data),
              loading: () => _buildLoading(),
              error: (error, stack) => _buildError(error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationPanel() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Smart Enhancement Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Language Selection
            Row(
              children: [
                Text('Language: '),
                DropdownButton<String>(
                  value: _selectedLanguage,
                  items: [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                    DropdownMenuItem(value: 'ur', child: Text('اردو')),
                    DropdownMenuItem(
                      value: 'id',
                      child: Text('Bahasa Indonesia'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value ?? 'en';
                    });
                  },
                ),
              ],
            ),

            // Location Input
            Row(
              children: [
                Text('Location: '),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your location (optional)',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    onChanged: (value) {
                      _selectedLocation = value.isEmpty ? null : value;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueryInput() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Your Query',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _queryController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: _getHintText(),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _performEnhancedSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Search with Smart Enhancement'),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: _clearQuery,
                  icon: Icon(Icons.clear),
                  tooltip: 'Clear query',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancementOptions() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enhancement Features',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildFeatureChip('Text Preprocessing', Icons.text_format),
                _buildFeatureChip('Islamic Terminology', Icons.book),
                _buildFeatureChip('Intent Classification', Icons.psychology),
                _buildFeatureChip('Context Injection', Icons.location_on),
                _buildFeatureChip('Multi-language Support', Icons.language),
                _buildFeatureChip('Security Validation', Icons.security),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label, style: TextStyle(fontSize: 12)),
      backgroundColor: Colors.teal.shade50,
    );
  }

  Widget _buildResults(RagStateData data) {
    if (data.apiState == RagApiState.loading) {
      return _buildLoading();
    }

    if (data.response == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Enter a query to see smart enhancement in action',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Try: "I\'m feeling anxious before my exam"',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Original Query
          _buildInfoCard(
            'Original Query',
            data.currentQuery ?? 'Unknown',
            Icons.edit,
            Colors.blue,
          ),

          // Enhanced Metadata
          if (data.metadata != null) ...[
            _buildInfoCard(
              'Enhanced Query',
              data.metadata!['enhanced_query']?.toString() ?? 'Not enhanced',
              Icons.auto_fix_high,
              Colors.purple,
            ),

            _buildInfoCard(
              'Detected Intent',
              data.metadata!['intent']?.toString() ?? 'Unknown',
              Icons.psychology,
              Colors.orange,
            ),

            if (data.metadata!['semantic_tags'] != null)
              _buildTagsCard(
                'Semantic Tags',
                List<String>.from(data.metadata!['semantic_tags']),
                Icons.tag,
                Colors.green,
              ),
          ],

          // Response
          _buildInfoCard(
            'Response',
            data.response!.response,
            Icons.chat_bubble,
            Colors.teal,
          ),

          // Confidence Score
          _buildConfidenceCard(data.confidence ?? 0.0),

          // Processing Steps
          if (data.metadata?['processing_steps'] != null)
            _buildProcessingStepsCard(
              List<String>.from(data.metadata!['processing_steps']),
            ),

          // Cache Status
          _buildInfoCard(
            'Cache Status',
            data.isFromCache ? 'Retrieved from cache' : 'Fresh API response',
            data.isFromCache ? Icons.cached : Icons.cloud_download,
            data.isFromCache ? Colors.green : Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsCard(
    String title,
    List<String> tags,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children:
                  tags
                      .map(
                        (tag) => Chip(
                          label: Text(tag, style: TextStyle(fontSize: 12)),
                          backgroundColor: color.withValues(alpha: 0.1),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfidenceCard(double confidence) {
    final percentage = (confidence * 100).round();
    final color =
        confidence > 0.7
            ? Colors.green
            : confidence > 0.4
            ? Colors.orange
            : Colors.red;

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: color, size: 20),
                SizedBox(width: 8),
                Text(
                  'Enhancement Confidence',
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: confidence,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                SizedBox(width: 8),
                Text('$percentage%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingStepsCard(List<String> steps) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list, color: Colors.indigo, size: 20),
                SizedBox(width: 8),
                Text(
                  'Processing Steps',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.indigo,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(step.replaceAll('_', ' ').toUpperCase()),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.teal),
          SizedBox(height: 16),
          Text('Enhancing query and searching...'),
          SizedBox(height: 8),
          Text(
            'Applying smart preprocessing, intent classification, and context enhancement',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text('Error occurred'),
          SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _performEnhancedSearch,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _getHintText() {
    switch (_selectedLanguage) {
      case 'ar':
        return 'مثال: أشعر بالقلق قبل الامتحان، ما الدعاء المناسب؟';
      case 'ur':
        return 'مثال: امتحان سے پہلے گھبراہٹ ہو رہی ہے، کیا دعا پڑھوں؟';
      case 'id':
        return 'Contoh: Saya merasa cemas sebelum ujian, doa apa yang cocok?';
      default:
        return 'Example: I\'m feeling anxious before my exam, what dua should I recite?';
    }
  }

  void _performEnhancedSearch() {
    final query = _queryController.text.trim();
    if (query.isEmpty) return;

    // Create context with current information
    final context = QueryContext(
      timestamp: DateTime.now(),
      location: _selectedLocation,
      deviceLanguage: _selectedLanguage,
      userPreferences: _userPreferences,
    );

    // Perform enhanced query
    ref
        .read(ragApiProvider.notifier)
        .performQuery(
          query,
          language: _selectedLanguage,
          context: context,
          userPreferences: _userPreferences,
        );
  }

  void _clearQuery() {
    _queryController.clear();
    ref.read(ragApiProvider.notifier).clearQuery();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }
}
