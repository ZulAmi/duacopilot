import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/professional_theme.dart';
import '../../services/ai/conversational_memory_service.dart';
import '../../services/ai/interactive_learning_companion_service.dart';
import '../../services/ai/islamic_personality_service.dart';
import '../../services/ai/proactive_spiritual_companion_service.dart';

/// Revolutionary AI Islamic Companion Screen
/// The first truly intelligent Islamic spiritual companion
class RevolutionaryVoiceCompanionScreen extends ConsumerStatefulWidget {
  const RevolutionaryVoiceCompanionScreen({super.key});

  @override
  ConsumerState<RevolutionaryVoiceCompanionScreen> createState() => _RevolutionaryVoiceCompanionScreenState();
}

class _RevolutionaryVoiceCompanionScreenState extends ConsumerState<RevolutionaryVoiceCompanionScreen>
    with SingleTickerProviderStateMixin {
  // Services
  late IslamicPersonalityService _personalityService;
  late ConversationalMemoryService _memoryService;
  late ProactiveSpiritualCompanionService _companionService;
  late InteractiveLearningCompanionService _learningService;

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _colorAnimation;

  // State management
  bool _isListening = false;
  bool _isProcessing = false;
  String _companionResponse = '';
  String _userInput = '';
  final List<String> _conversationHistory = [];
  List<String> _suggestionChips = [];
  CompanionMode _currentMode = CompanionMode.companion;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _setupAnimations();
    _initializeCompanion();
  }

  /// Initialize all AI services
  Future<void> _initializeServices() async {
    _personalityService = IslamicPersonalityService.instance;
    _memoryService = ConversationalMemoryService.instance;
    _companionService = ProactiveSpiritualCompanionService.instance;
    _learningService = InteractiveLearningCompanionService.instance;

    // Initialize all services
    await Future.wait([
      _personalityService.initialize(),
      _memoryService.initialize(),
      _companionService.initialize(),
      _learningService.initialize(),
    ]);
  }

  /// Setup animations
  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: ProfessionalTheme.primaryEmerald,
      end: ProfessionalTheme.secondaryGold,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.repeat(reverse: true);
  }

  /// Initialize companion with greeting
  Future<void> _initializeCompanion() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final greeting = await _generatePersonalizedGreeting();
    setState(() {
      _companionResponse = greeting;
      _suggestionChips = [
        'Teach me about Islam',
        'I need spiritual guidance',
        'Let\'s have a conversation',
        'Help with my prayers',
      ];
    });
  }

  /// Generate personalized greeting based on user history and time
  Future<String> _generatePersonalizedGreeting() async {
    final hour = DateTime.now().hour;
    final context = await _memoryService.getConversationalContext();

    String timeGreeting;
    if (hour < 12) {
      timeGreeting = 'Blessed morning to you!';
    } else if (hour < 18) {
      timeGreeting = 'May your afternoon be filled with barakah!';
    } else {
      timeGreeting = 'Peace and tranquility this evening!';
    }

    return '''
$timeGreeting

Assalamu Alaikum, my dear brother/sister in faith! I'm your AI Islamic companion, here to walk alongside you on your spiritual journey.

${context.recentTurns.isNotEmpty ? 'I remember our last conversation about ${context.currentTopic}. How has your heart been since then?' : 'I\'m here to be your friend, teacher, and guide in all things Islamic. What draws your heart today?'}

Remember, the Prophet ﷺ said: "The believer is not one who eats his fill while his neighbor goes hungry." 

How may I serve your soul today?
''';
  }

  /// Handle voice input (simplified for demo)
  Future<void> _handleVoiceInput() async {
    if (_isListening) {
      await _stopListening();
    } else {
      await _startListening();
    }
  }

  /// Start voice listening
  Future<void> _startListening() async {
    setState(() {
      _isListening = true;
    });

    // Simulate voice input for demo
    await Future.delayed(const Duration(seconds: 2));

    final simulatedInput = "Tell me about prayer in Islam";
    setState(() {
      _userInput = simulatedInput;
      _isProcessing = true;
      _isListening = false;
    });

    await _processUserInput(simulatedInput);
  }

  /// Stop voice listening
  Future<void> _stopListening() async {
    setState(() {
      _isListening = false;
    });
  }

  /// Process user input with full AI pipeline
  Future<void> _processUserInput(String input) async {
    // Add to conversation history
    _conversationHistory.add('User: $input');

    // Detect emotion and intent
    final emotion = await _detectEmotion(input);
    final topic = await _extractTopic(input);

    // Get conversational context
    final context = await _memoryService.getConversationalContext();

    // Generate response based on current mode
    String response;
    List<String> suggestions = [];

    switch (_currentMode) {
      case CompanionMode.learning:
        final learningResponse = await _learningService.processLearningInteraction(input);
        response = learningResponse.response;
        suggestions = learningResponse.suggestedResponses ?? [];
        break;

      case CompanionMode.companion:
        response = await _generateCompanionResponse(
          input,
          emotion,
          topic,
          context,
        );
        suggestions = await _generateContextualSuggestions(
          context,
          emotion,
          topic,
        );
        break;

      case CompanionMode.guidance:
        response = await _generateGuidanceResponse(input, emotion, topic);
        suggestions = await _generateGuidanceSuggestions(topic);
        break;
    }

    // Personalize response with Islamic personality
    final personalizedResponse = await _personalityService.generatePersonalizedResponse(
      originalResponse: response,
      userQuery: input,
      detectedEmotion: emotion,
      timeContext: _getTimeContext(),
    );

    // Add to conversation memory
    await _memoryService.addConversationTurn(
      userInput: input,
      assistantResponse: personalizedResponse,
      detectedEmotion: emotion,
      topic: topic,
      metadata: {
        'mode': _currentMode.name,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );

    // Update UI
    setState(() {
      _companionResponse = personalizedResponse;
      _suggestionChips = suggestions;
      _conversationHistory.add(
        'Companion: ${personalizedResponse.substring(0, 100)}...',
      );
      _isProcessing = false;
    });

    // Update spiritual profile
    await _companionService.updateSpiritualProfile(
      interaction: input,
      topic: topic,
      emotion: emotion,
    );
  }

  /// Generate companion response
  Future<String> _generateCompanionResponse(
    String input,
    String emotion,
    String topic,
    ConversationalContext context,
  ) async {
    return '''
SubhanAllah, I feel the sincerity in your words about $topic.

Prayer (Salah) is one of the most beautiful gifts Allah has given us - it's our direct connection with our Creator. When we pray, we're not just performing movements; we're having a conversation with Allah, expressing our gratitude, seeking guidance, and finding peace.

The Prophet ﷺ said: "Prayer is the key to Paradise." Each prayer is an opportunity to cleanse our hearts and realign our purpose.

Based on our conversation, I sense you're seeking deeper understanding. Would you like me to guide you through the spiritual meanings behind each prayer position, or would you prefer to learn about the practical steps first?

What resonates most with your soul from what we've discussed?
''';
  }

  /// Generate contextual suggestions
  Future<List<String>> _generateContextualSuggestions(
    ConversationalContext context,
    String emotion,
    String topic,
  ) async {
    return [
      'Explain prayer movements',
      'Share a beautiful dua',
      'Tell me about spiritual benefits',
      'How do I focus during prayer?',
    ];
  }

  /// Generate guidance response
  Future<String> _generateGuidanceResponse(
    String input,
    String emotion,
    String topic,
  ) async {
    if (emotion == 'sadness' || emotion == 'distress') {
      return '''
My dear friend, I hear the pain in your heart. Allah knows every tear you shed.

The Prophet ﷺ said: "No fatigue, nor disease, nor sorrow, nor sadness, nor hurt, nor distress befalls a Muslim, not even a prick of a thorn, but that Allah expiates some of his sins for that."

Your struggle is temporary, but Allah's mercy is eternal. Would you like to explore some duas that bring comfort to the heart?
''';
    }

    return 'Let me provide guidance based on Islamic teachings about $topic...';
  }

  /// Generate guidance suggestions
  Future<List<String>> _generateGuidanceSuggestions(String topic) async {
    return [
      'Share a comforting dua',
      'Tell me about sabr (patience)',
      'How do I trust Allah\'s plan?',
      'Teach me about dhikr',
    ];
  }

  /// Simple emotion detection
  Future<String> _detectEmotion(String input) async {
    final lowerInput = input.toLowerCase();

    if (lowerInput.contains(RegExp(r'sad|depressed|down|difficult|hard'))) {
      return 'sadness';
    } else if (lowerInput.contains(
      RegExp(r'happy|grateful|blessed|alhamdulillah'),
    )) {
      return 'joy';
    } else if (lowerInput.contains(RegExp(r'worried|anxious|afraid|scared'))) {
      return 'anxiety';
    }

    return 'neutral';
  }

  /// Extract topic from input
  Future<String> _extractTopic(String input) async {
    final lowerInput = input.toLowerCase();

    if (lowerInput.contains('pray')) return 'prayer';
    if (lowerInput.contains('quran')) return 'quran';
    if (lowerInput.contains('prophet')) return 'prophet';
    if (lowerInput.contains('allah')) return 'faith';
    if (lowerInput.contains('dua')) return 'dua';
    if (lowerInput.contains('islam')) return 'islam';

    return 'general';
  }

  /// Get time context
  String _getTimeContext() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 18) return 'afternoon';
    return 'evening';
  }

  /// Switch companion mode
  void _switchMode(CompanionMode mode) {
    setState(() {
      _currentMode = mode;
    });

    String modeMessage;
    switch (mode) {
      case CompanionMode.companion:
        modeMessage = '🤲 I\'m here as your spiritual companion. Let\'s have a heart-to-heart conversation.';
        break;
      case CompanionMode.learning:
        modeMessage =
            '📚 Learning mode activated! I\'m excited to teach you about Islam. What would you like to explore?';
        break;
      case CompanionMode.guidance:
        modeMessage = '🌙 Guidance mode ready. Share what\'s troubling your heart, and I\'ll provide Islamic wisdom.';
        break;
    }

    setState(() {
      _companionResponse = modeMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ProfessionalTheme.primaryEmerald.withOpacity(0.1),
              ProfessionalTheme.secondaryGold.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with mode selection
              _buildHeader(),

              // Main companion interface
              Expanded(child: _buildCompanionInterface()),

              // Voice interaction controls
              _buildVoiceControls(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build header with mode selection
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              // Back button
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios),
                color: ProfessionalTheme.primaryEmerald,
                tooltip: 'Go back',
              ),
              Icon(
                Icons.mosque,
                color: ProfessionalTheme.primaryEmerald,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'AI Islamic Companion',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: ProfessionalTheme.primaryEmerald,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Mode selection
          Row(
            children: [
              Expanded(
                child: _buildModeButton(
                  CompanionMode.companion,
                  '🤲 Companion',
                  'Spiritual friendship',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildModeButton(
                  CompanionMode.learning,
                  '📚 Learning',
                  'Islamic education',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildModeButton(
                  CompanionMode.guidance,
                  '🌙 Guidance',
                  'Seek Islamic advice',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build mode selection button
  Widget _buildModeButton(CompanionMode mode, String title, String subtitle) {
    final isSelected = _currentMode == mode;

    return GestureDetector(
      onTap: () => _switchMode(mode),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? ProfessionalTheme.primaryEmerald.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: ProfessionalTheme.primaryEmerald) : null,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? ProfessionalTheme.primaryEmerald : Colors.grey[600],
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build main companion interface
  Widget _buildCompanionInterface() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Companion response
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: ProfessionalTheme.primaryEmerald.withOpacity(0.1),
                      child: Icon(
                        Icons.psychology,
                        color: ProfessionalTheme.primaryEmerald,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your Islamic Companion',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_isProcessing)
                  const Center(child: CircularProgressIndicator())
                else
                  Text(
                    _companionResponse,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(height: 1.6),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Suggestion chips
          if (_suggestionChips.isNotEmpty) _buildSuggestionChips(),

          const SizedBox(height: 20),

          // Conversation history
          if (_conversationHistory.isNotEmpty) _buildConversationHistory(),
        ],
      ),
    );
  }

  /// Build suggestion chips
  Widget _buildSuggestionChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggestions:',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _suggestionChips
              .map(
                (suggestion) => GestureDetector(
                  onTap: () => _processUserInput(suggestion),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: ProfessionalTheme.secondaryGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ProfessionalTheme.secondaryGold.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      suggestion,
                      style: TextStyle(
                        color: ProfessionalTheme.secondaryGold,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  /// Build conversation history
  Widget _buildConversationHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Conversation:',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: ListView.builder(
            itemCount: _conversationHistory.length,
            itemBuilder: (context, index) {
              final message = _conversationHistory[index];
              final isUser = message.startsWith('User:');

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUser ? Colors.grey[100] : ProfessionalTheme.primaryEmerald.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build voice controls
  Widget _buildVoiceControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Main voice button
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isListening ? _pulseAnimation.value : 1.0,
                child: GestureDetector(
                  onTap: _handleVoiceInput,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _isListening ? _colorAnimation.value : ProfessionalTheme.primaryEmerald,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_isListening ? _colorAnimation.value : ProfessionalTheme.primaryEmerald)!
                              .withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          Text(
            _isListening
                ? 'Listening... Speak your heart'
                : _isProcessing
                    ? 'Processing your words...'
                    : 'Tap to speak with your companion',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),

          if (_userInput.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'You said: "$_userInput"',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _companionService.dispose();
    super.dispose();
  }
}

/// Companion operation modes
enum CompanionMode {
  companion, // General spiritual companionship
  learning, // Interactive Islamic education
  guidance, // Specific spiritual guidance
}
