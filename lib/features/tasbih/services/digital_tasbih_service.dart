import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/storage/secure_storage_service.dart';
import '../../../domain/entities/tasbih_entity.dart';

/// DigitalTasbihService - Advanced digital tasbih with voice recognition
class DigitalTasbihService {
  static const String _sessionStorageKey = 'tasbih_sessions';
  static const String _settingsStorageKey = 'tasbih_settings';
  static const String _statsStorageKey = 'tasbih_stats';
  static const String _goalsStorageKey = 'tasbih_goals';
  static const String _achievementsStorageKey = 'tasbih_achievements';

  final SecureStorageService _secureStorage;
  final SpeechToText _speechToText = SpeechToText();

  final StreamController<TasbihSession> _sessionController = StreamController<TasbihSession>.broadcast();
  final StreamController<TasbihStats> _statsController = StreamController<TasbihStats>.broadcast();
  final StreamController<List<Achievement>> _achievementsController = StreamController<List<Achievement>>.broadcast();

  TasbihSession? _currentSession;
  TasbihSettings? _currentSettings;
  TasbihStats? _currentStats;
  List<TasbihGoal> _activeGoals = [];
  List<Achievement> _achievements = [];

  bool _isListening = false;
  bool _isInitialized = false;
  Timer? _sessionTimer;

  // Voice recognition patterns for different dhikr
  static const Map<TasbihType, List<String>> _dhikrPatterns = {
    TasbihType.subhanallah: ['subhanallah', 'subhan allah', 'سبحان الله'],
    TasbihType.alhamdulillah: ['alhamdulillah', 'alhamdu lillah', 'الحمد لله'],
    TasbihType.allahuakbar: ['allahu akbar', 'allah hu akbar', 'الله أكبر'],
    TasbihType.lailahaillallah: [
      'la ilaha illallah',
      'la ilaha illa allah',
      'لا إله إلا الله',
    ],
    TasbihType.astaghfirullah: [
      'astaghfirullah',
      'astagh firullah',
      'أستغفر الله',
    ],
  };

  DigitalTasbihService(this._secureStorage);

  // Getters for streams
  Stream<TasbihSession> get sessionStream => _sessionController.stream;
  Stream<TasbihStats> get statsStream => _statsController.stream;
  Stream<List<Achievement>> get achievementsStream => _achievementsController.stream;

  /// Initialize the tasbih service
  Future<bool> initialize() async {
    try {
      if (_isInitialized) return true;

      // Load settings and data
      await _loadSettings();
      await _loadStats();
      await _loadGoals();
      await _loadAchievements();

      // Initialize speech recognition if enabled
      if (_currentSettings?.voiceRecognition == true) {
        await _initializeSpeechRecognition();
      }

      _isInitialized = true;
      return true;
    } catch (e) {
      print('Failed to initialize TasbihService: $e');
      return false;
    }
  }

  /// Initialize speech recognition for voice counting
  Future<void> _initializeSpeechRecognition() async {
    try {
      final available = await _speechToText.initialize(
        onStatus: _onSpeechStatus,
        onError: _onSpeechError,
      );

      if (!available) {
        print('Speech recognition not available');
      }
    } catch (e) {
      print('Failed to initialize speech recognition: $e');
    }
  }

  /// Handle speech recognition status changes
  void _onSpeechStatus(String status) {
    _isListening = status == 'listening';
  }

  /// Handle speech recognition errors
  void _onSpeechError(dynamic error) {
    print('Speech recognition error: $error');
    _isListening = false;
  }

  /// Start a new tasbih session
  Future<TasbihSession> startSession({
    required TasbihType type,
    required int targetCount,
    TasbihGoal? goal,
  }) async {
    try {
      // End current session if exists
      if (_currentSession != null && _currentSession!.isCompleted != true) {
        await endSession();
      }

      final sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
      final settings = _currentSettings ?? _getDefaultSettings();

      _currentSession = TasbihSession(
        id: sessionId,
        userId: 'current_user', // In production, get from user service
        startTime: DateTime.now(),
        type: type,
        targetCount: targetCount,
        currentCount: 0,
        entries: [],
        settings: settings,
        goal: goal,
        isCompleted: false,
      );

      // Enable wakelock to prevent screen from turning off
      if (settings.autoSave) {
        await WakelockPlus.enable();
      }

      // Start voice recognition if enabled
      if (settings.voiceRecognition && !_isListening) {
        await _startVoiceRecognition(type);
      }

      // Start session timer
      _startSessionTimer();

      _sessionController.add(_currentSession!);
      return _currentSession!;
    } catch (e) {
      print('Failed to start tasbih session: $e');
      rethrow;
    }
  }

  /// Add count manually (touch input)
  Future<void> addCount({InputMethod method = InputMethod.touch}) async {
    if (_currentSession == null) return;

    try {
      final now = DateTime.now();
      final entry = TasbihEntry(
        timestamp: now,
        count: _currentSession!.currentCount + 1,
        inputMethod: method,
        dhikrText: _getDhikrText(_currentSession!.type),
        timeSinceLastEntry: _getTimeSinceLastEntry(),
      );

      final updatedEntries = [..._currentSession!.entries, entry];
      final newCount = _currentSession!.currentCount + 1;

      _currentSession = _currentSession!.copyWith(
        currentCount: newCount,
        entries: updatedEntries,
      );

      // Provide feedback
      await _provideFeedback();

      // Check for goal completion
      await _checkGoalCompletion();

      // Check for achievements
      await _checkAchievements();

      // Auto-complete session if target reached
      if (newCount >= _currentSession!.targetCount) {
        await _completeSession();
      }

      _sessionController.add(_currentSession!);
    } catch (e) {
      print('Failed to add count: $e');
    }
  }

  /// Start voice recognition for the session
  Future<void> _startVoiceRecognition(TasbihType type) async {
    if (!_speechToText.isAvailable) return;

    try {
      final patterns = _dhikrPatterns[type] ?? [];
      if (patterns.isEmpty) return;

      await _speechToText.listen(
        onResult: (result) => _onVoiceResult(result, type),
        listenFor: const Duration(minutes: 30), // Long session support
        pauseFor: const Duration(seconds: 3),
        listenOptions: SpeechListenOptions(
          partialResults: true,
        ),
        localeId: 'ar-SA', // Arabic locale for better recognition
      );
    } catch (e) {
      print('Failed to start voice recognition: $e');
    }
  }

  /// Handle voice recognition results
  void _onVoiceResult(dynamic result, TasbihType type) {
    if (_currentSession == null) return;

    final recognizedWords = result.recognizedWords?.toLowerCase() ?? '';
    final patterns = _dhikrPatterns[type] ?? [];

    for (final pattern in patterns) {
      if (recognizedWords.contains(pattern.toLowerCase())) {
        addCount(method: InputMethod.voice);
        break;
      }
    }
  }

  /// Provide haptic/audio feedback
  Future<void> _provideFeedback() async {
    if (_currentSettings == null) return;

    try {
      // Haptic feedback
      if (_currentSettings!.hapticFeedback) {
        final pattern = _getVibrationPattern(
          _currentSettings!.vibrationPattern,
        );
        if (await Vibration.hasVibrator() == true) {
          await Vibration.vibrate(pattern: pattern);
        } else {
          await HapticFeedback.lightImpact();
        }
      }

      // Sound feedback
      if (_currentSettings!.soundFeedback) {
        await SystemSound.play(SystemSoundType.click);
      }
    } catch (e) {
      print('Failed to provide feedback: $e');
    }
  }

  /// Get vibration pattern based on settings
  List<int> _getVibrationPattern(VibrationPattern? pattern) {
    switch (pattern) {
      case VibrationPattern.light:
        return [0, 50];
      case VibrationPattern.medium:
        return [0, 100];
      case VibrationPattern.strong:
        return [0, 200];
      case VibrationPattern.double:
        return [0, 50, 100, 50];
      default:
        return [0, 75];
    }
  }

  /// Get dhikr text for the type
  String _getDhikrText(TasbihType type) {
    switch (type) {
      case TasbihType.subhanallah:
        return 'سُبْحَانَ اللهِ';
      case TasbihType.alhamdulillah:
        return 'اَلْحَمْدُ للهِ';
      case TasbihType.allahuakbar:
        return 'اَللهُ أَكْبَرُ';
      case TasbihType.lailahaillallah:
        return 'لَا إِلٰهَ إِلَّا اللهُ';
      case TasbihType.astaghfirullah:
        return 'أَسْتَغْفِرُ اللهَ';
      default:
        return '';
    }
  }

  /// Get time since last entry
  Duration? _getTimeSinceLastEntry() {
    if (_currentSession?.entries.isEmpty == true) return null;

    final lastEntry = _currentSession!.entries.last;
    return DateTime.now().difference(lastEntry.timestamp);
  }

  /// Check goal completion
  Future<void> _checkGoalCompletion() async {
    if (_currentSession?.goal == null) return;

    final goal = _currentSession!.goal!;
    final currentCount = _currentSession!.currentCount;

    // Update goal progress
    final updatedGoal = goal.copyWith(currentProgress: currentCount);
    _currentSession = _currentSession!.copyWith(goal: updatedGoal);

    // Check if goal is completed
    if (currentCount >= goal.targetCount) {
      await _completeGoal(goal);
    }
  }

  /// Complete a goal
  Future<void> _completeGoal(TasbihGoal goal) async {
    try {
      final completedGoal = goal.copyWith(
        status: GoalStatus.completed,
        endDate: DateTime.now(),
      );

      // Save completed goal
      await _saveGoal(completedGoal);

      // Award achievement
      await _awardAchievement(
        id: 'goal_completed_${goal.id}',
        title: 'Goal Achieved!',
        description: 'Completed goal: ${goal.title}',
        category: AchievementCategory.milestone,
      );
    } catch (e) {
      print('Failed to complete goal: $e');
    }
  }

  /// Check for new achievements
  Future<void> _checkAchievements() async {
    if (_currentSession == null) return;

    final count = _currentSession!.currentCount;

    // Milestone achievements
    if (count == 33) {
      await _awardAchievement(
        id: 'first_33',
        title: 'First Tasbih',
        description: 'Completed your first 33 count tasbih',
        category: AchievementCategory.milestone,
      );
    } else if (count == 100) {
      await _awardAchievement(
        id: 'century',
        title: 'Century',
        description: 'Reached 100 counts in a session',
        category: AchievementCategory.milestone,
      );
    }

    // Speed achievements (if completed quickly)
    final sessionDuration = DateTime.now().difference(
      _currentSession!.startTime,
    );
    if (count >= 33 && sessionDuration.inMinutes < 2) {
      await _awardAchievement(
        id: 'speed_demon',
        title: 'Speed Demon',
        description: 'Completed 33 counts in under 2 minutes',
        category: AchievementCategory.speed,
      );
    }
  }

  /// Award achievement
  Future<void> _awardAchievement({
    required String id,
    required String title,
    required String description,
    required AchievementCategory category,
  }) async {
    try {
      // Check if already awarded
      if (_achievements.any((a) => a.id == id)) return;

      final achievement = Achievement(
        id: id,
        title: title,
        description: description,
        iconPath: 'assets/icons/achievement_${category.name}.png',
        unlockedAt: DateTime.now(),
        category: category,
        pointsEarned: _getAchievementPoints(category),
      );

      _achievements.add(achievement);
      await _saveAchievements();

      _achievementsController.add(_achievements);

      // Provide special feedback for achievements
      await HapticFeedback.heavyImpact();
    } catch (e) {
      print('Failed to award achievement: $e');
    }
  }

  /// Get points for achievement category
  int _getAchievementPoints(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.milestone:
        return 100;
      case AchievementCategory.speed:
        return 150;
      case AchievementCategory.consistency:
        return 200;
      case AchievementCategory.dedication:
        return 300;
      case AchievementCategory.family:
        return 250;
      case AchievementCategory.special:
        return 500;
    }
  }

  /// Complete current session
  Future<void> _completeSession() async {
    if (_currentSession == null) return;

    try {
      final completedSession = _currentSession!.copyWith(
        endTime: DateTime.now(),
        totalDuration: DateTime.now().difference(_currentSession!.startTime),
        isCompleted: true,
      );

      _currentSession = completedSession;

      // Save session
      await _saveSession(completedSession);

      // Update stats
      await _updateStats(completedSession);

      // Stop voice recognition
      if (_isListening) {
        await _speechToText.stop();
      }

      // Disable wakelock
      await WakelockPlus.disable();

      // Stop timer
      _sessionTimer?.cancel();

      _sessionController.add(_currentSession!);
    } catch (e) {
      print('Failed to complete session: $e');
    }
  }

  /// End current session without completion
  Future<void> endSession() async {
    if (_currentSession == null) return;

    try {
      await _completeSession();
      _currentSession = null;
    } catch (e) {
      print('Failed to end session: $e');
    }
  }

  /// Start session timer for duration tracking
  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSession != null) {
        final duration = DateTime.now().difference(_currentSession!.startTime);
        final updatedSession = _currentSession!.copyWith(
          totalDuration: duration,
        );
        _currentSession = updatedSession;
        _sessionController.add(_currentSession!);
      }
    });
  }

  /// Update overall statistics
  Future<void> _updateStats(TasbihSession session) async {
    try {
      final currentStats = _currentStats ?? _getDefaultStats();

      final updatedStats = currentStats.copyWith(
        totalSessions: currentStats.totalSessions + 1,
        totalCount: currentStats.totalCount + session.currentCount,
        totalTime: currentStats.totalTime + (session.totalDuration ?? Duration.zero),
        lastSession: session.endTime ?? session.startTime,
        countsByType: _updateCountsByType(currentStats.countsByType, session),
        dailyProgress: _updateDailyProgress(
          currentStats.dailyProgress,
          session,
        ),
      );

      _currentStats = updatedStats;
      await _saveStats();
      _statsController.add(_currentStats!);
    } catch (e) {
      print('Failed to update stats: $e');
    }
  }

  /// Update counts by type
  Map<TasbihType, int> _updateCountsByType(
    Map<TasbihType, int> currentCounts,
    TasbihSession session,
  ) {
    final updated = Map<TasbihType, int>.from(currentCounts);
    updated[session.type] = (updated[session.type] ?? 0) + session.currentCount;
    return updated;
  }

  /// Update daily progress
  Map<DateTime, int> _updateDailyProgress(
    Map<DateTime, int> currentProgress,
    TasbihSession session,
  ) {
    final today = DateTime(
      session.startTime.year,
      session.startTime.month,
      session.startTime.day,
    );

    final updated = Map<DateTime, int>.from(currentProgress);
    updated[today] = (updated[today] ?? 0) + session.currentCount;
    return updated;
  }

  /// Save session to secure storage
  Future<void> _saveSession(TasbihSession session) async {
    try {
      final sessionsJson = await _secureStorage.getValue(_sessionStorageKey) ?? '[]';
      final sessions = (jsonDecode(sessionsJson) as List).map((s) => TasbihSession.fromJson(s)).toList();

      sessions.add(session);

      // Keep only last 100 sessions for performance
      if (sessions.length > 100) {
        sessions.removeRange(0, sessions.length - 100);
      }

      final updatedJson = jsonEncode(sessions.map((s) => s.toJson()).toList());
      await _secureStorage.saveValue(_sessionStorageKey, updatedJson);
    } catch (e) {
      print('Failed to save session: $e');
    }
  }

  /// Load settings from storage
  Future<void> _loadSettings() async {
    try {
      final settingsJson = await _secureStorage.getValue(_settingsStorageKey);
      if (settingsJson != null) {
        _currentSettings = TasbihSettings.fromJson(jsonDecode(settingsJson));
      } else {
        _currentSettings = _getDefaultSettings();
      }
    } catch (e) {
      print('Failed to load settings: $e');
      _currentSettings = _getDefaultSettings();
    }
  }

  /// Get default tasbih settings
  TasbihSettings _getDefaultSettings() {
    return const TasbihSettings(
      hapticFeedback: true,
      soundFeedback: false,
      voiceRecognition: false,
      sensitivity: 0.7,
      animation: AnimationType.ripple,
      theme: ThemeStyle.classic,
      autoSave: true,
      familySharing: false,
      vibrationPattern: VibrationPattern.light,
    );
  }

  /// Save settings to storage
  Future<void> saveSettings(TasbihSettings settings) async {
    try {
      _currentSettings = settings;
      final settingsJson = jsonEncode(settings.toJson());
      await _secureStorage.saveValue(_settingsStorageKey, settingsJson);
    } catch (e) {
      print('Failed to save settings: $e');
    }
  }

  /// Load statistics from storage
  Future<void> _loadStats() async {
    try {
      final statsJson = await _secureStorage.getValue(_statsStorageKey);
      if (statsJson != null) {
        _currentStats = TasbihStats.fromJson(jsonDecode(statsJson));
      } else {
        _currentStats = _getDefaultStats();
      }
    } catch (e) {
      print('Failed to load stats: $e');
      _currentStats = _getDefaultStats();
    }
  }

  /// Get default statistics
  TasbihStats _getDefaultStats() {
    return TasbihStats(
      totalSessions: 0,
      totalCount: 0,
      totalTime: Duration.zero,
      countsByType: {},
      dailyProgress: {},
      currentStreak: 0,
      longestStreak: 0,
      lastSession: DateTime.now(),
      averageSessionDuration: 0.0,
      achievements: [],
    );
  }

  /// Save statistics to storage
  Future<void> _saveStats() async {
    try {
      if (_currentStats == null) return;
      final statsJson = jsonEncode(_currentStats!.toJson());
      await _secureStorage.saveValue(_statsStorageKey, statsJson);
    } catch (e) {
      print('Failed to save stats: $e');
    }
  }

  /// Load goals from storage
  Future<void> _loadGoals() async {
    try {
      final goalsJson = await _secureStorage.getValue(_goalsStorageKey) ?? '[]';
      final goalsList = (jsonDecode(goalsJson) as List).map((g) => TasbihGoal.fromJson(g)).toList();

      _activeGoals = goalsList.where((g) => g.isActive == true).toList();
    } catch (e) {
      print('Failed to load goals: $e');
      _activeGoals = [];
    }
  }

  /// Save goal to storage
  Future<void> _saveGoal(TasbihGoal goal) async {
    try {
      final goalsJson = await _secureStorage.getValue(_goalsStorageKey) ?? '[]';
      final goals = (jsonDecode(goalsJson) as List).map((g) => TasbihGoal.fromJson(g)).toList();

      // Update existing or add new goal
      final index = goals.indexWhere((g) => g.id == goal.id);
      if (index >= 0) {
        goals[index] = goal;
      } else {
        goals.add(goal);
      }

      final updatedJson = jsonEncode(goals.map((g) => g.toJson()).toList());
      await _secureStorage.saveValue(_goalsStorageKey, updatedJson);

      // Update active goals
      _activeGoals = goals.where((g) => g.isActive == true).toList();
    } catch (e) {
      print('Failed to save goal: $e');
    }
  }

  /// Load achievements from storage
  Future<void> _loadAchievements() async {
    try {
      final achievementsJson = await _secureStorage.getValue(_achievementsStorageKey) ?? '[]';
      _achievements = (jsonDecode(achievementsJson) as List).map((a) => Achievement.fromJson(a)).toList();
    } catch (e) {
      print('Failed to load achievements: $e');
      _achievements = [];
    }
  }

  /// Save achievements to storage
  Future<void> _saveAchievements() async {
    try {
      final achievementsJson = jsonEncode(
        _achievements.map((a) => a.toJson()).toList(),
      );
      await _secureStorage.saveValue(_achievementsStorageKey, achievementsJson);
    } catch (e) {
      print('Failed to save achievements: $e');
    }
  }

  /// Get current session
  TasbihSession? get currentSession => _currentSession;

  /// Get current settings
  TasbihSettings? get currentSettings => _currentSettings;

  /// Get current stats
  TasbihStats? get currentStats => _currentStats;

  /// Get active goals
  List<TasbihGoal> get activeGoals => _activeGoals;

  /// Get achievements
  List<Achievement> get achievements => _achievements;

  /// Dispose service and clean up resources
  void dispose() {
    _sessionController.close();
    _statsController.close();
    _achievementsController.close();
    _sessionTimer?.cancel();
    _speechToText.stop();
    WakelockPlus.disable();
  }
}
