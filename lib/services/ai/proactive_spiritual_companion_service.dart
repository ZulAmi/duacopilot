import 'dart:async';
import 'dart:math';

import '../../core/logging/app_logger.dart';
import '../notifications/notification_service.dart';
import '../secure_storage/secure_storage_service.dart';
import 'conversational_memory_service.dart';

/// Proactive Spiritual Companion Service
/// Acts as an active Islamic guide, not just reactive assistant
/// Features: Spiritual reminders, growth suggestions, personalized guidance
class ProactiveSpiritualCompanionService {
  static ProactiveSpiritualCompanionService? _instance;
  static ProactiveSpiritualCompanionService get instance =>
      _instance ??= ProactiveSpiritualCompanionService._();

  ProactiveSpiritualCompanionService._();

  late SecureStorageService _secureStorage;
  late NotificationService _notificationService;
  late ConversationalMemoryService _memoryService;
  bool _isInitialized = false;

  // Proactive engagement timers
  Timer? _spiritualReminderTimer;
  Timer? _checkInTimer;
  Timer? _learningOpportunityTimer;

  // User spiritual profile
  final Map<String, dynamic> _spiritualProfile = {
    'prayer_consistency': 0.0,
    'learning_engagement': 0.0,
    'emotional_patterns': <String>[],
    'growth_areas': <String>[],
    'spiritual_goals': <String>[],
    'preferred_reminder_style': 'gentle',
  };

  /// Initialize proactive spiritual companion
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _secureStorage = SecureStorageService.instance;
      _notificationService = NotificationService.instance;
      _memoryService = ConversationalMemoryService.instance;

      await _loadSpiritualProfile();
      _startProactiveEngagement();
      _isInitialized = true;

      AppLogger.info('Proactive Spiritual Companion Service initialized');
    } catch (e) {
      AppLogger.error('Failed to initialize Proactive Spiritual Companion: $e');
      rethrow;
    }
  }

  /// Start proactive spiritual engagement
  void _startProactiveEngagement() {
    // Check-in timer - periodic spiritual wellness checks
    _checkInTimer = Timer.periodic(const Duration(hours: 6), (timer) {
      _performSpiritualCheckIn();
    });

    // Learning opportunity timer - suggest learning moments
    _learningOpportunityTimer = Timer.periodic(const Duration(hours: 4), (
      timer,
    ) {
      _suggestLearningOpportunity();
    });

    // Spiritual reminder timer - contextual reminders
    _spiritualReminderTimer = Timer.periodic(const Duration(hours: 2), (timer) {
      _provideSpiritualReminder();
    });
  }

  /// Perform proactive spiritual check-in
  Future<void> _performSpiritualCheckIn() async {
    await _ensureInitialized();

    try {
      final context = await _memoryService.getConversationalContext();
      final checkInMessage = await _generateCheckInMessage(context);

      if (checkInMessage != null) {
        await _sendProactiveMessage(
          title: '🤲 Spiritual Check-In',
          message: checkInMessage,
          type: 'spiritual_checkin',
        );
      }
    } catch (e) {
      AppLogger.error('Failed to perform spiritual check-in: $e');
    }
  }

  /// Suggest learning opportunities
  Future<void> _suggestLearningOpportunity() async {
    await _ensureInitialized();

    try {
      final opportunity = await _identifyLearningOpportunity();

      if (opportunity != null) {
        await _sendProactiveMessage(
          title: '📚 Learning Opportunity',
          message: opportunity,
          type: 'learning_opportunity',
        );
      }
    } catch (e) {
      AppLogger.error('Failed to suggest learning opportunity: $e');
    }
  }

  /// Provide contextual spiritual reminders
  Future<void> _provideSpiritualReminder() async {
    await _ensureInitialized();

    try {
      final reminder = await _generateContextualReminder();

      if (reminder != null) {
        await _sendProactiveMessage(
          title: '🌙 Spiritual Reminder',
          message: reminder,
          type: 'spiritual_reminder',
        );
      }
    } catch (e) {
      AppLogger.error('Failed to provide spiritual reminder: $e');
    }
  }

  /// Generate personalized check-in message
  Future<String?> _generateCheckInMessage(ConversationalContext context) async {
    // Analyze recent emotional patterns
    final recentEmotions = context.emotionalProgression.take(10).toList();
    final hasNegativeEmotions = recentEmotions.any(
      (e) => ['sadness', 'anxiety', 'distress', 'anger'].contains(e),
    );

    // Generate appropriate check-in
    if (hasNegativeEmotions) {
      return _generateSupportiveCheckIn();
    } else if (context.sessionDuration.inHours > 24) {
      return _generateReconnectionCheckIn();
    } else if (_isSpecialTimeOfDay()) {
      return _generateTimeBasedCheckIn();
    }

    return null; // Don't check-in too frequently
  }

  /// Generate supportive check-in for difficult times
  String _generateSupportiveCheckIn() {
    final supportiveMessages = [
      'Assalamu Alaikum, my dear friend. I\'ve noticed you might be going through a challenging time. How is your heart today? Remember, Allah is always with you. 🤲',
      'Peace be upon you. Your spiritual companion is here. Would you like to talk about what\'s on your mind? Sometimes sharing our burdens lightens them. ✨',
      'I\'ve been thinking of you in my prayers. How are you feeling today? Remember, after every difficulty comes ease, just as Allah promises. 🌙',
    ];

    return supportiveMessages[Random().nextInt(supportiveMessages.length)];
  }

  /// Generate reconnection check-in
  String _generateReconnectionCheckIn() {
    final reconnectionMessages = [
      'Assalamu Alaikum! It\'s been a while since we connected. How has your spiritual journey been? I\'m here whenever you need guidance. 🕌',
      'Peace and blessings! I hope you\'re thriving in your faith. Would you like to share any recent reflections or perhaps explore something new together? 📚',
      'MashaAllah, time flies! How have you been connecting with Allah lately? I\'d love to hear about your spiritual experiences. 🌸',
    ];

    return reconnectionMessages[Random().nextInt(reconnectionMessages.length)];
  }

  /// Generate time-based check-in
  String _generateTimeBasedCheckIn() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 8) {
      return 'Blessed Fajr time! How did your morning prayer feel today? Starting the day with Allah\'s remembrance brings such peace. 🌅';
    } else if (hour >= 18 && hour < 21) {
      return 'As the day draws to a close, how has your heart been with Allah today? Maghrib is a beautiful time for reflection. 🌆';
    } else if (hour >= 21 && hour < 23) {
      return 'In these peaceful evening hours, would you like to end the day with some dhikr or reflection? Isha time is perfect for spiritual connection. 🌙';
    }

    return 'Peace be upon you! How is your spiritual state today? I\'m here to accompany you on your journey with Allah. ✨';
  }

  /// Identify learning opportunities
  Future<String?> _identifyLearningOpportunity() async {
    final context = await _memoryService.getConversationalContext();
    final recentTopics =
        context.recentTurns.map((t) => t.topic).toSet().toList();

    // Suggest deepening knowledge in recent topics
    if (recentTopics.contains('prayer')) {
      return 'I noticed you\'ve been asking about prayer recently. Would you like to explore the deeper spiritual meanings behind each prayer position? Each movement is a conversation with Allah. 🕌';
    } else if (recentTopics.contains('quran')) {
      return 'MashaAllah, your interest in the Quran is beautiful! Would you like to learn about the context behind a verse you\'ve been reflecting on? Understanding the circumstances of revelation can deepen our connection. 📖';
    } else if (recentTopics.contains('dhikr')) {
      return 'Your love for dhikr touches my heart! Shall we explore different forms of remembrance? I can teach you about the 99 Beautiful Names of Allah and their spiritual significance. ✨';
    }

    // Suggest new areas based on spiritual profile gaps
    final learningEngagement =
        _spiritualProfile['learning_engagement'] as double;
    if (learningEngagement < 0.5) {
      return _suggestNewLearningArea();
    }

    return null;
  }

  /// Suggest new learning areas
  String _suggestNewLearningArea() {
    final suggestions = [
      'Would you like to explore the beautiful science of Islamic astronomy? Understanding how our ancestors calculated prayer times and Islamic calendar can deepen our appreciation for Allah\'s creation. 🌙',
      'Shall we journey through the stories of the prophets? Each story holds timeless wisdom for our modern challenges. Which prophet\'s story speaks to your heart? 📚',
      'Would you be interested in learning about Islamic ethics and how they apply to our daily decisions? Islam provides guidance for every aspect of life. 🤲',
      'How about exploring the concept of Ihsan - excellence in worship? It\'s about worshipping Allah as if you see Him, and knowing that He sees you. ✨',
    ];

    return suggestions[Random().nextInt(suggestions.length)];
  }

  /// Generate contextual spiritual reminders
  Future<String?> _generateContextualReminder() async {
    final hour = DateTime.now().hour;
    final dayOfWeek = DateTime.now().weekday;

    // Friday reminders
    if (dayOfWeek == DateTime.friday) {
      return 'Jummah Mubarak! 🕌 Friday is the best day of the week. Have you sent blessings upon Prophet Muhammad ﷺ today? It\'s especially rewarded on Fridays.';
    }

    // Time-based reminders
    if (hour >= 6 && hour < 9) {
      return 'Morning reflection: "And it is He who sends down rain from heaven, and We produce thereby the vegetation of every kind." (6:99) How will you grow spiritually today? 🌱';
    } else if (hour >= 15 && hour < 17) {
      return 'Afternoon pause: The Prophet ﷺ said, "Remember often the destroyer of pleasures: death." Let this reminder motivate us to do good while we can. 🤲';
    } else if (hour >= 20 && hour < 22) {
      return 'Evening gratitude: Before sleep, let\'s count three blessings Allah gave you today. Gratitude transforms our hearts and draws us closer to Him. ✨';
    }

    // Random spiritual wisdom
    return _getRandomSpiritualWisdom();
  }

  /// Get random spiritual wisdom
  String _getRandomSpiritualWisdom() {
    final wisdom = [
      'Remember: "And Allah is with the patient ones." (2:153) Your perseverance in faith is seen and rewarded by Allah. 🤲',
      'Reflect: "And give good tidings to the patient, Who, when disaster strikes them, say, \'Indeed we belong to Allah, and indeed to Him we will return.\'" (2:155-156) 🌙',
      'Consider: The Prophet ﷺ said, "The believer is not one who eats his fill while his neighbor goes hungry." How can we serve others today? 🤝',
      'Ponder: "And it is He who created the heavens and earth in truth. And the day He says, \'Be,\' and it is, His word is the truth." (6:73) SubhanAllah! ✨',
    ];

    return wisdom[Random().nextInt(wisdom.length)];
  }

  /// Check if it's a special time for spiritual reminders
  bool _isSpecialTimeOfDay() {
    final hour = DateTime.now().hour;
    final minute = DateTime.now().minute;

    // Special Islamic times
    final specialTimes = [
      (5, 30), // After Fajr
      (6, 0), // Sunrise remembrance
      (12, 30), // After Dhuhr
      (15, 30), // Afternoon reflection
      (18, 30), // After Maghrib
      (21, 0), // Evening dhikr
    ];

    return specialTimes.any(
      (time) => hour == time.$1 && (minute - time.$2).abs() <= 5,
    );
  }

  /// Send proactive message to user
  Future<void> _sendProactiveMessage({
    required String title,
    required String message,
    required String type,
  }) async {
    try {
      // Check user preferences for proactive messaging
      final allowProactive = await _secureStorage.read(
        'allow_proactive_messages',
      );
      if (allowProactive == 'false') return;

      // Send notification
      await _notificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        body: message,
        payload: type,
      );

      // Log proactive engagement
      AppLogger.info('Sent proactive message: $type');
    } catch (e) {
      AppLogger.error('Failed to send proactive message: $e');
    }
  }

  /// Update spiritual profile based on user interactions
  Future<void> updateSpiritualProfile({
    required String interaction,
    required String topic,
    required String emotion,
  }) async {
    await _ensureInitialized();

    try {
      // Update learning engagement
      if (interaction.contains('question') || interaction.contains('learn')) {
        final current = _spiritualProfile['learning_engagement'] as double;
        _spiritualProfile['learning_engagement'] = (current + 0.1).clamp(
          0.0,
          1.0,
        );
      }

      // Track emotional patterns
      final emotionalPatterns =
          _spiritualProfile['emotional_patterns'] as List<String>;
      emotionalPatterns.add(emotion);
      if (emotionalPatterns.length > 50) {
        emotionalPatterns.removeRange(0, emotionalPatterns.length - 50);
      }

      // Update growth areas based on topics
      final growthAreas = _spiritualProfile['growth_areas'] as List<String>;
      if (!growthAreas.contains(topic) && topic != 'general') {
        growthAreas.add(topic);
      }

      await _saveSpiritualProfile();
    } catch (e) {
      AppLogger.error('Failed to update spiritual profile: $e');
    }
  }

  /// Load spiritual profile
  Future<void> _loadSpiritualProfile() async {
    try {
      final profileData = await _secureStorage.read('spiritual_profile');
      if (profileData != null) {
        final profile = Map<String, dynamic>.from(profileData as Map);
        _spiritualProfile.addAll(profile);
      }
    } catch (e) {
      AppLogger.debug('No previous spiritual profile found');
    }
  }

  /// Save spiritual profile
  Future<void> _saveSpiritualProfile() async {
    try {
      // Convert to JSON string for storage
      final jsonString = '''
{
  "prayer_consistency": ${_spiritualProfile['prayer_consistency']},
  "learning_engagement": ${_spiritualProfile['learning_engagement']},
  "emotional_patterns": ${_spiritualProfile['emotional_patterns']},
  "growth_areas": ${_spiritualProfile['growth_areas']},
  "spiritual_goals": ${_spiritualProfile['spiritual_goals']},
  "preferred_reminder_style": "${_spiritualProfile['preferred_reminder_style']}"
}
''';
      await _secureStorage.write('spiritual_profile', jsonString);
    } catch (e) {
      AppLogger.error('Failed to save spiritual profile: $e');
    }
  }

  /// Dispose of resources
  void dispose() {
    _checkInTimer?.cancel();
    _learningOpportunityTimer?.cancel();
    _spiritualReminderTimer?.cancel();
    _isInitialized = false;
  }

  /// Ensure service is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
}
