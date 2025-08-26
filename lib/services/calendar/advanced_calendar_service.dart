import 'dart:async';
import 'dart:convert';

import 'package:device_calendar/device_calendar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/logging/app_logger.dart';
import '../../domain/entities/conversation_entity.dart';
import '../secure_storage/secure_storage_service.dart';
import '../time/islamic_time_service.dart';

/// Advanced calendar integration service for contextual Du'a recommendations
/// Intelligently analyzes calendar events to suggest appropriate Islamic guidance
class AdvancedCalendarService {
  static AdvancedCalendarService? _instance;
  static AdvancedCalendarService get instance =>
      _instance ??= AdvancedCalendarService._();

  AdvancedCalendarService._();

  // Core services
  late DeviceCalendarPlugin _deviceCalendar;
  late IslamicTimeService _islamicTimeService;
  late SecureStorageService _secureStorage;
  SharedPreferences? _prefs;

  // Configuration
  static const Duration _lookAheadWindow = Duration(days: 7);
  static const Duration _reminderWindow = Duration(hours: 24);
  static const String _calendarPrefsKey = 'calendar_integration_prefs';

  // State management
  bool _isInitialized = false;
  bool _hasPermission = false;
  bool _isEnabled = false;
  List<Calendar> _availableCalendars = [];
  List<String> _enabledCalendarIds = [];

  // Event processing
  final Map<String, CalendarEvent> _eventCache = {};

  // Stream controllers
  final _calendarEventsController =
      StreamController<List<CalendarEvent>>.broadcast();
  final _contextualSuggestionsController =
      StreamController<List<ContextualSuggestion>>.broadcast();
  final _reminderNotificationsController =
      StreamController<ReminderNotification>.broadcast();

  // Public streams
  Stream<List<CalendarEvent>> get calendarEventsStream =>
      _calendarEventsController.stream;
  Stream<List<ContextualSuggestion>> get contextualSuggestionsStream =>
      _contextualSuggestionsController.stream;
  Stream<ReminderNotification> get reminderNotificationsStream =>
      _reminderNotificationsController.stream;

  // Islamic event patterns
  static const Map<String, List<String>> _islamicEventPatterns = {
    'prayer': [
      'fajr',
      'dhuhr',
      'asr',
      'maghrib',
      'isha',
      'صلاة',
      'نماز',
      'prayer',
      'salah',
    ],
    'religious_study': [
      'quran',
      'islamic',
      'hadith',
      'sunnah',
      'mosque',
      'madrasah',
      'islamic center',
      'religious class',
    ],
    'travel': [
      'flight',
      'trip',
      'travel',
      'vacation',
      'journey',
      'airport',
      'departure',
      'arrival',
    ],
    'work_meeting': [
      'meeting',
      'conference',
      'presentation',
      'interview',
      'work',
      'office',
      'business',
    ],
    'medical_appointment': [
      'doctor',
      'hospital',
      'medical',
      'appointment',
      'checkup',
      'surgery',
      'dentist',
    ],
    'family_event': [
      'wedding',
      'birthday',
      'anniversary',
      'family',
      'celebration',
      'party',
      'gathering',
    ],
    'exam_study': [
      'exam',
      'test',
      'study',
      'school',
      'university',
      'education',
      'academic',
    ],
  };

  // Du'a recommendations for event types
  static const Map<String, List<String>> _duaRecommendations = {
    'prayer': [
      'Seek Allah\'s guidance and peace',
      'Ask for spiritual purification',
      'Request strength in faith',
    ],
    'travel': [
      'Recite travel Du\'a for protection',
      'Seek Allah\'s blessing for safe journey',
      'Ask for guidance during travel',
    ],
    'work_meeting': [
      'Seek Allah\'s guidance for success',
      'Ask for confidence and clarity',
      'Request blessing in professional matters',
    ],
    'medical_appointment': [
      'Seek Allah\'s healing and mercy',
      'Ask for strength during treatment',
      'Request ease in health matters',
    ],
    'exam_study': [
      'Seek Allah\'s help in learning',
      'Ask for wisdom and understanding',
      'Request success in education',
    ],
  };

  /// Initialize calendar service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('Initializing Advanced Calendar Service...');

      _deviceCalendar = DeviceCalendarPlugin();
      _islamicTimeService = IslamicTimeService.instance;
      _secureStorage = SecureStorageService.instance;
      _prefs = await SharedPreferences.getInstance();

      // Request calendar permissions
      await _requestPermissions();

      if (_hasPermission) {
        // Load user preferences
        await _loadUserPreferences();

        // Retrieve available calendars
        await _loadAvailableCalendars();

        // Start event monitoring if enabled
        if (_isEnabled) {
          await _startEventMonitoring();
        }
      }

      _isInitialized = true;
      AppLogger.info('Advanced Calendar Service initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize Advanced Calendar Service: $e');
      throw Exception('Calendar service initialization failed');
    }
  }

  /// Enable calendar integration
  Future<void> enableIntegration({List<String>? calendarIds}) async {
    await _ensureInitialized();

    if (!_hasPermission) {
      await _requestPermissions();
      if (!_hasPermission) {
        throw Exception('Calendar permission not granted');
      }
    }

    _isEnabled = true;

    if (calendarIds != null) {
      _enabledCalendarIds = calendarIds;
    } else {
      // Enable all available calendars by default
      _enabledCalendarIds = _availableCalendars.map((cal) => cal.id!).toList();
    }

    await _saveUserPreferences();
    await _startEventMonitoring();

    AppLogger.info(
      'Calendar integration enabled with ${_enabledCalendarIds.length} calendars',
    );
  }

  /// Disable calendar integration
  Future<void> disableIntegration() async {
    _isEnabled = false;
    _enabledCalendarIds.clear();
    await _saveUserPreferences();
    await _stopEventMonitoring();

    AppLogger.info('Calendar integration disabled');
  }

  /// Get upcoming events with Islamic context
  Future<List<CalendarEvent>> getUpcomingEvents({
    Duration? lookAhead,
    bool includeIslamicContext = true,
  }) async {
    await _ensureInitialized();

    if (!_isEnabled || !_hasPermission) {
      return [];
    }

    final window = lookAhead ?? _lookAheadWindow;
    final endDate = DateTime.now().add(window);
    final events = <CalendarEvent>[];

    try {
      for (final calendarId in _enabledCalendarIds) {
        final retrievedEvents = await _deviceCalendar.retrieveEvents(
          calendarId,
          RetrieveEventsParams(startDate: DateTime.now(), endDate: endDate),
        );

        if (retrievedEvents.isSuccess && retrievedEvents.data != null) {
          for (final event in retrievedEvents.data!) {
            final calendarEvent = await _processEvent(
              event,
              includeIslamicContext,
            );
            if (calendarEvent != null) {
              events.add(calendarEvent);
              _eventCache[calendarEvent.eventId] = calendarEvent;
            }
          }
        }
      }

      // Sort events by start time
      events.sort((a, b) => a.startTime.compareTo(b.startTime));

      _calendarEventsController.add(events);
      return events;
    } catch (e) {
      AppLogger.error('Failed to retrieve upcoming events: $e');
      return [];
    }
  }

  /// Get contextual suggestions for current time
  Future<List<ContextualSuggestion>> getContextualSuggestions() async {
    await _ensureInitialized();

    if (!_isEnabled) return [];

    final suggestions = <ContextualSuggestion>[];
    final now = DateTime.now();
    final upcomingEvents = await getUpcomingEvents(lookAhead: _reminderWindow);

    try {
      // Analyze upcoming events
      for (final event in upcomingEvents) {
        final timeUntilEvent = event.startTime.difference(now);

        if (timeUntilEvent.inMinutes <= 60 && timeUntilEvent.inMinutes > 0) {
          final eventSuggestions = await _generateEventSuggestions(
            event,
            timeUntilEvent,
          );
          suggestions.addAll(eventSuggestions);
        }
      }

      // Add Islamic time-based suggestions
      final islamicSuggestions = await _generateIslamicTimeSuggestions();
      suggestions.addAll(islamicSuggestions);

      // Sort by relevance score
      suggestions.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

      _contextualSuggestionsController.add(suggestions);
      return suggestions.take(5).toList();
    } catch (e) {
      AppLogger.error('Failed to generate contextual suggestions: $e');
      return [];
    }
  }

  /// Set up event reminders
  Future<void> setupEventReminders(
    String eventId,
    List<Duration> reminderTimes,
  ) async {
    await _ensureInitialized();

    final event = _eventCache[eventId];
    if (event == null) return;

    try {
      for (final reminderTime in reminderTimes) {
        final reminderDateTime = event.startTime.subtract(reminderTime);

        if (reminderDateTime.isAfter(DateTime.now())) {
          await _scheduleReminder(event, reminderTime);
        }
      }

      AppLogger.info(
        'Set up ${reminderTimes.length} reminders for event: ${event.title}',
      );
    } catch (e) {
      AppLogger.error('Failed to setup event reminders: $e');
    }
  }

  /// Get available calendars
  List<Calendar> get availableCalendars =>
      List.unmodifiable(_availableCalendars);

  /// Check if integration is enabled
  bool get isEnabled => _isEnabled;

  /// Check if has permission
  bool get hasPermission => _hasPermission;

  // Private helper methods

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  Future<void> _requestPermissions() async {
    try {
      final status = await Permission.calendarFullAccess.request();
      _hasPermission = status == PermissionStatus.granted;

      if (!_hasPermission) {
        AppLogger.warning('Calendar permission not granted');
      }
    } catch (e) {
      AppLogger.error('Error requesting calendar permission: $e');
      _hasPermission = false;
    }
  }

  Future<void> _loadUserPreferences() async {
    try {
      final prefsJson = _prefs?.getString(_calendarPrefsKey);
      if (prefsJson != null) {
        final prefs = jsonDecode(prefsJson) as Map<String, dynamic>;
        _isEnabled = prefs['enabled'] ?? false;
        _enabledCalendarIds =
            (prefs['enabled_calendars'] as List<dynamic>?)?.cast<String>() ??
            [];
      }
    } catch (e) {
      AppLogger.warning('Failed to load calendar preferences: $e');
    }
  }

  Future<void> _saveUserPreferences() async {
    try {
      final prefs = {
        'enabled': _isEnabled,
        'enabled_calendars': _enabledCalendarIds,
        'last_updated': DateTime.now().toIso8601String(),
      };
      await _prefs?.setString(_calendarPrefsKey, jsonEncode(prefs));
    } catch (e) {
      AppLogger.error('Failed to save calendar preferences: $e');
    }
  }

  Future<void> _loadAvailableCalendars() async {
    try {
      final calendarsResult = await _deviceCalendar.retrieveCalendars();
      if (calendarsResult.isSuccess && calendarsResult.data != null) {
        _availableCalendars =
            calendarsResult.data!
                .where((cal) => cal.isReadOnly == false)
                .toList();
        AppLogger.info(
          'Loaded ${_availableCalendars.length} available calendars',
        );
      }
    } catch (e) {
      AppLogger.error('Failed to load available calendars: $e');
    }
  }

  Future<CalendarEvent?> _processEvent(
    Event event,
    bool includeIslamicContext,
  ) async {
    if (event.title == null || event.start == null || event.end == null) {
      return null;
    }

    // Detect event category
    final eventCategory = _detectEventCategory(
      event.title!,
      event.description ?? '',
    );

    // Check if it's an Islamic event
    final isIslamicEvent = _isIslamicEvent(
      event.title!,
      event.description ?? '',
    );

    // Generate suggested Du'as
    List<String>? suggestedDuas;
    if (includeIslamicContext) {
      suggestedDuas = _generateDuaSuggestions(eventCategory, event);
    }

    return CalendarEvent(
      eventId: event.eventId!,
      title: event.title!,
      startTime: event.start!,
      endTime: event.end!,
      description: event.description ?? '',
      location: event.location ?? '',
      isIslamicEvent: isIslamicEvent,
      suggestedDuas: suggestedDuas,
      metadata: {
        'category': eventCategory,
        'calendar_id': event.calendarId,
        'all_day': event.allDay ?? false,
        'has_attendees': (event.attendees?.isNotEmpty) ?? false,
        'has_reminders': (event.reminders?.isNotEmpty) ?? false,
      },
    );
  }

  String _detectEventCategory(String title, String description) {
    final combinedText = '$title $description'.toLowerCase();

    for (final category in _islamicEventPatterns.keys) {
      final patterns = _islamicEventPatterns[category]!;
      for (final pattern in patterns) {
        if (combinedText.contains(pattern.toLowerCase())) {
          return category;
        }
      }
    }

    return 'general';
  }

  bool _isIslamicEvent(String title, String description) {
    final combinedText = '$title $description'.toLowerCase();
    final islamicKeywords = [
      'prayer',
      'salah',
      'mosque',
      'islamic',
      'quran',
      'hadith',
      'ramadan',
      'eid',
      'hajj',
      'umrah',
      'jummah',
      'tarawih',
    ];

    return islamicKeywords.any((keyword) => combinedText.contains(keyword));
  }

  List<String> _generateDuaSuggestions(String category, Event event) {
    final suggestions = _duaRecommendations[category] ?? [];

    // Add time-specific suggestions
    final timeBasedSuggestions = _getTimeBasedSuggestions(event.start!);

    return [...suggestions, ...timeBasedSuggestions];
  }

  List<String> _getTimeBasedSuggestions(DateTime eventTime) {
    final islamicTime = _islamicTimeService.getCurrentTimeContext();
    final suggestions = <String>[];

    // Add prayer time context
    final nextPrayer = islamicTime.prayerTimes.nextPrayer;
    if (nextPrayer != null) {
      final timeToPrayer = nextPrayer.remaining;
      if (timeToPrayer.inHours < 2) {
        suggestions.add('Prepare for ${nextPrayer.type.name} prayer');
      }
    }

    // Add Islamic calendar context
    if (islamicTime.isRamadan) {
      suggestions.add('Special Ramadan Du\'a for blessings');
    }

    if (islamicTime.isHajjSeason) {
      suggestions.add('Du\'a for those performing Hajj');
    }

    return suggestions;
  }

  Future<List<ContextualSuggestion>> _generateEventSuggestions(
    CalendarEvent event,
    Duration timeUntilEvent,
  ) async {
    final suggestions = <ContextualSuggestion>[];

    final suggestion = ContextualSuggestion(
      id: 'event_${event.eventId}_${DateTime.now().millisecondsSinceEpoch}',
      userId: await _secureStorage.getUserId() ?? 'anonymous',
      suggestionText: _buildSuggestionText(event, timeUntilEvent),
      reason: 'Upcoming calendar event: ${event.title}',
      relevanceScore: _calculateRelevanceScore(event, timeUntilEvent),
      suggestedAt: DateTime.now(),
      category: 'calendar_event',
      context: {
        'event_id': event.eventId,
        'event_title': event.title,
        'event_category': event.metadata['category'],
        'time_until_event_minutes': timeUntilEvent.inMinutes,
        'is_islamic_event': event.isIslamicEvent,
      },
    );

    suggestions.add(suggestion);
    return suggestions;
  }

  Future<List<ContextualSuggestion>> _generateIslamicTimeSuggestions() async {
    final suggestions = <ContextualSuggestion>[];
    final islamicTime = _islamicTimeService.getCurrentTimeContext();

    // Prayer time suggestions
    final nextPrayer = islamicTime.prayerTimes.nextPrayer;
    if (nextPrayer != null && nextPrayer.remaining.inMinutes <= 30) {
      suggestions.add(
        ContextualSuggestion(
          id: 'prayer_reminder_${DateTime.now().millisecondsSinceEpoch}',
          userId: await _secureStorage.getUserId() ?? 'anonymous',
          suggestionText:
              'Prepare for ${nextPrayer.type.name} prayer in ${nextPrayer.remaining.inMinutes} minutes',
          reason: 'Upcoming prayer time',
          relevanceScore: 0.9,
          suggestedAt: DateTime.now(),
          category: 'prayer_time',
          context: {
            'prayer_type': nextPrayer.type.name,
            'prayer_time': nextPrayer.time.toIso8601String(),
            'minutes_remaining': nextPrayer.remaining.inMinutes,
          },
        ),
      );
    }

    return suggestions;
  }

  String _buildSuggestionText(CalendarEvent event, Duration timeUntilEvent) {
    final timeText =
        timeUntilEvent.inMinutes < 60
            ? '${timeUntilEvent.inMinutes} minutes'
            : '${timeUntilEvent.inHours} hours';

    if (event.suggestedDuas?.isNotEmpty == true) {
      return 'You have "${event.title}" in $timeText. Consider: ${event.suggestedDuas!.first}';
    }

    return 'You have "${event.title}" in $timeText. May Allah bless your endeavor.';
  }

  double _calculateRelevanceScore(
    CalendarEvent event,
    Duration timeUntilEvent,
  ) {
    double score = 0.5; // Base score

    // Higher score for Islamic events
    if (event.isIslamicEvent) {
      score += 0.3;
    }

    // Higher score for closer events
    if (timeUntilEvent.inMinutes <= 15) {
      score += 0.2;
    } else if (timeUntilEvent.inMinutes <= 60) {
      score += 0.1;
    }

    // Higher score for important categories
    final category = event.metadata['category'] as String?;
    if (category == 'prayer' || category == 'religious_study') {
      score += 0.2;
    }

    return score.clamp(0.0, 1.0);
  }

  Future<void> _startEventMonitoring() async {
    // This would implement real-time event monitoring
    // For now, we'll set up periodic checks
    Timer.periodic(const Duration(minutes: 15), (timer) {
      if (_isEnabled) {
        _checkForUpcomingEvents();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _stopEventMonitoring() async {
    // Stop any running timers or listeners
  }

  Future<void> _checkForUpcomingEvents() async {
    try {
      final suggestions = await getContextualSuggestions();
      if (suggestions.isNotEmpty) {
        // Process suggestions
        for (final suggestion in suggestions) {
          if (!suggestion.isShown) {
            _reminderNotificationsController.add(
              ReminderNotification(
                id: suggestion.id,
                title: 'Islamic Guidance',
                message: suggestion.suggestionText,
                scheduledTime: DateTime.now(),
                type: 'contextual_suggestion',
                metadata: suggestion.context,
              ),
            );
          }
        }
      }
    } catch (e) {
      AppLogger.error('Error checking for upcoming events: $e');
    }
  }

  Future<void> _scheduleReminder(
    CalendarEvent event,
    Duration reminderTime,
  ) async {
    // This would integrate with the notification service
    final reminderDateTime = event.startTime.subtract(reminderTime);

    if (reminderDateTime.isAfter(DateTime.now())) {
      // Schedule notification
      AppLogger.info(
        'Scheduling reminder for ${event.title} at $reminderDateTime',
      );
    }
  }

  /// Cleanup resources
  void dispose() {
    _calendarEventsController.close();
    _contextualSuggestionsController.close();
    _reminderNotificationsController.close();
  }
}

/// Contextual suggestion for calendar integration
class ContextualSuggestion {
  final String id;
  final String userId;
  final String suggestionText;
  final String reason;
  final double relevanceScore;
  final DateTime suggestedAt;
  final String category;
  final Map<String, dynamic> context;
  final bool isShown;
  final bool isAccepted;
  final DateTime? shownAt;
  final DateTime? respondedAt;

  const ContextualSuggestion({
    required this.id,
    required this.userId,
    required this.suggestionText,
    required this.reason,
    required this.relevanceScore,
    required this.suggestedAt,
    required this.category,
    required this.context,
    this.isShown = false,
    this.isAccepted = false,
    this.shownAt,
    this.respondedAt,
  });
}

/// Reminder notification
class ReminderNotification {
  final String id;
  final String title;
  final String message;
  final DateTime scheduledTime;
  final String type;
  final Map<String, dynamic> metadata;

  const ReminderNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.scheduledTime,
    required this.type,
    required this.metadata,
  });
}
