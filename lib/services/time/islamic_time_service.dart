import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/dua_entity.dart';
import '../../domain/entities/context_entity.dart';

class IslamicTimeService {
  static IslamicTimeService? _instance;
  static IslamicTimeService get instance =>
      _instance ??= IslamicTimeService._();

  IslamicTimeService._();

  bool _isInitialized = false;
  Timer? _timeUpdateTimer;

  /// Stream of time-based Du'a suggestions
  final StreamController<List<SmartSuggestion>> _suggestionsController =
      StreamController<List<SmartSuggestion>>.broadcast();
  Stream<List<SmartSuggestion>> get suggestionStream =>
      _suggestionsController.stream;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _isInitialized = true;
      debugPrint('Islamic time service initialized');
    } catch (e) {
      debugPrint('Failed to initialize Islamic time service: $e');
      rethrow;
    }
  }

  /// Get current time context with Islamic calendar information
  TimeContext getCurrentTimeContext() {
    final now = DateTime.now();
    final islamicDate = _calculateIslamicDate(now);
    final prayerTimes = _calculatePrayerTimes(now);
    final timeOfDay = _determineTimeOfDay(now, prayerTimes);

    return TimeContext(
      currentTime: now,
      timeOfDay: timeOfDay,
      islamicDate: islamicDate,
      prayerTimes: prayerTimes,
      specialOccasions: _getSpecialOccasions(islamicDate),
      isRamadan: _isRamadan(islamicDate),
      isHajjSeason: _isHajjSeason(islamicDate),
    );
  }

  /// Start monitoring time for contextual suggestions
  Future<void> startTimeMonitoring(List<DuaEntity> allDuas) async {
    await _ensureInitialized();

    _timeUpdateTimer?.cancel();

    // Update suggestions every 15 minutes
    _timeUpdateTimer = Timer.periodic(const Duration(minutes: 15), (timer) {
      _handleTimeUpdate(allDuas);
    });

    // Initial update
    _handleTimeUpdate(allDuas);
  }

  /// Stop time monitoring
  Future<void> stopTimeMonitoring() async {
    _timeUpdateTimer?.cancel();
    _timeUpdateTimer = null;
  }

  void _handleTimeUpdate(List<DuaEntity> allDuas) {
    try {
      final timeContext = getCurrentTimeContext();
      final suggestions = _generateTimeBasedSuggestions(timeContext, allDuas);
      _suggestionsController.add(suggestions);
    } catch (e) {
      debugPrint('Error handling time update: $e');
    }
  }

  IslamicDate _calculateIslamicDate(DateTime gregorianDate) {
    // Simplified Islamic date calculation
    // In a real implementation, you would use a proper Islamic calendar library
    const islamicEpoch = Duration(days: 227014); // Approximate
    final daysSinceEpoch =
        gregorianDate.difference(DateTime(622, 7, 16)).inDays;
    final islamicDays = daysSinceEpoch - islamicEpoch.inDays;

    // Rough calculation (Islamic year ≈ 354.37 days)
    final islamicYear = 1 + (islamicDays / 354.37).floor();
    final dayInYear = islamicDays % 354;
    final islamicMonth = (dayInYear / 29.5).floor() + 1;
    final dayInMonth = (dayInYear % 29.5).floor() + 1;

    return IslamicDate(
      year: islamicYear,
      month: islamicMonth.clamp(1, 12),
      day: dayInMonth.clamp(1, 30),
      monthName: _getIslamicMonthName(islamicMonth.clamp(1, 12)),
      isHolyMonth: _isHolyMonth(islamicMonth.clamp(1, 12)),
    );
  }

  String _getIslamicMonthName(int month) {
    const monthNames = [
      'Muharram',
      'Safar',
      'Rabi\' al-awwal',
      'Rabi\' al-thani',
      'Jumada al-awwal',
      'Jumada al-thani',
      'Rajab',
      'Sha\'ban',
      'Ramadan',
      'Shawwal',
      'Dhu al-Qi\'dah',
      'Dhu al-Hijjah',
    ];
    return monthNames[month - 1];
  }

  bool _isHolyMonth(int month) {
    // Holy months: Muharram (1), Rajab (7), Ramadan (9), Dhu al-Hijjah (12)
    return month == 1 || month == 7 || month == 9 || month == 12;
  }

  String _getPrayerName(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return 'Fajr';
      case PrayerType.dhuhr:
        return 'Dhuhr';
      case PrayerType.asr:
        return 'Asr';
      case PrayerType.maghrib:
        return 'Maghrib';
      case PrayerType.isha:
        return 'Isha';
    }
  }

  PrayerTimes _calculatePrayerTimes(DateTime date) {
    // Simplified prayer time calculation
    // In a real implementation, you would use accurate prayer time calculation
    // based on location, taking into account sunrise/sunset times

    final baseDate = DateTime(date.year, date.month, date.day);

    return PrayerTimes(
      fajr: baseDate.add(const Duration(hours: 5, minutes: 30)),
      sunrise: baseDate.add(const Duration(hours: 6, minutes: 45)),
      dhuhr: baseDate.add(const Duration(hours: 12, minutes: 30)),
      asr: baseDate.add(const Duration(hours: 15, minutes: 45)),
      maghrib: baseDate.add(const Duration(hours: 18, minutes: 15)),
      isha: baseDate.add(const Duration(hours: 19, minutes: 45)),
      nextPrayer: _getNextPrayer(baseDate),
    );
  }

  NextPrayer? _getNextPrayer(DateTime baseDate) {
    final now = DateTime.now();
    final prayers = [
      (PrayerType.fajr, baseDate.add(const Duration(hours: 5, minutes: 30))),
      (PrayerType.dhuhr, baseDate.add(const Duration(hours: 12, minutes: 30))),
      (PrayerType.asr, baseDate.add(const Duration(hours: 15, minutes: 45))),
      (
        PrayerType.maghrib,
        baseDate.add(const Duration(hours: 18, minutes: 15)),
      ),
      (PrayerType.isha, baseDate.add(const Duration(hours: 19, minutes: 45))),
    ];

    // Find next prayer
    for (final (type, time) in prayers) {
      if (time.isAfter(now)) {
        final remaining = time.difference(now);
        return NextPrayer(type: type, time: time, remaining: remaining);
      }
    }

    // If no prayer today, return tomorrow's Fajr
    final tomorrowFajr = baseDate.add(
      const Duration(days: 1, hours: 5, minutes: 30),
    );
    return NextPrayer(
      type: PrayerType.fajr,
      time: tomorrowFajr,
      remaining: tomorrowFajr.difference(now),
    );
  }

  TimeOfDay _determineTimeOfDay(DateTime time, PrayerTimes prayerTimes) {
    if (time.isBefore(prayerTimes.fajr)) {
      return TimeOfDay.night;
    } else if (time.isBefore(prayerTimes.sunrise)) {
      return TimeOfDay.fajr;
    } else if (time.isBefore(prayerTimes.dhuhr)) {
      return TimeOfDay.morning;
    } else if (time.isBefore(prayerTimes.asr)) {
      return TimeOfDay.dhuhr;
    } else if (time.isBefore(prayerTimes.maghrib)) {
      return TimeOfDay.asr;
    } else if (time.isBefore(prayerTimes.isha)) {
      return TimeOfDay.maghrib;
    } else {
      return TimeOfDay.isha;
    }
  }

  List<String> _getSpecialOccasions(IslamicDate islamicDate) {
    final occasions = <String>[];

    // Major Islamic occasions
    if (islamicDate.month == 1 && islamicDate.day == 1) {
      occasions.add('Islamic New Year');
    }

    if (islamicDate.month == 1 && islamicDate.day == 10) {
      occasions.add('Day of Ashura');
    }

    if (islamicDate.month == 3 && islamicDate.day == 12) {
      occasions.add('Mawlid an-Nabi');
    }

    if (islamicDate.month == 9) {
      occasions.add('Ramadan');
      if (islamicDate.day >= 21) {
        occasions.add('Laylat al-Qadr (possible)');
      }
    }

    if (islamicDate.month == 10 && islamicDate.day == 1) {
      occasions.add('Eid al-Fitr');
    }

    if (islamicDate.month == 12 && islamicDate.day == 10) {
      occasions.add('Eid al-Adha');
    }

    if (islamicDate.month == 12 &&
        islamicDate.day >= 8 &&
        islamicDate.day <= 12) {
      occasions.add('Hajj Season');
    }

    return occasions;
  }

  bool _isRamadan(IslamicDate islamicDate) {
    return islamicDate.month == 9;
  }

  bool _isHajjSeason(IslamicDate islamicDate) {
    return islamicDate.month == 12 &&
        islamicDate.day >= 8 &&
        islamicDate.day <= 12;
  }

  List<SmartSuggestion> _generateTimeBasedSuggestions(
    TimeContext timeContext,
    List<DuaEntity> allDuas,
  ) {
    final suggestions = <SmartSuggestion>[];
    final now = timeContext.currentTime;

    // Prayer time suggestions
    if (timeContext.prayerTimes.nextPrayer != null) {
      final nextPrayer = timeContext.prayerTimes.nextPrayer!;
      final minutesUntilPrayer = nextPrayer.remaining.inMinutes;
      final prayerName = _getPrayerName(nextPrayer.type);

      if (minutesUntilPrayer <= 30 && minutesUntilPrayer > 0) {
        final prayerDuas =
            allDuas
                .where(
                  (dua) =>
                      dua.category.toLowerCase().contains('prayer') ||
                      dua.category.toLowerCase().contains('salah') ||
                      dua.category.toLowerCase().contains(
                        prayerName.toLowerCase(),
                      ),
                )
                .toList();

        for (final dua in prayerDuas.take(2)) {
          suggestions.add(
            SmartSuggestion(
              duaId: dua.id,
              type: SuggestionType.timeBased,
              confidence: 0.9,
              reason: '$prayerName prayer is in $minutesUntilPrayer minutes',
              timestamp: now,
              trigger: SuggestionTrigger.prayerTime,
            ),
          );
        }
      }
    }

    // Time-of-day specific suggestions
    switch (timeContext.timeOfDay) {
      case TimeOfDay.fajr:
        final fajrDuas =
            allDuas
                .where(
                  (dua) =>
                      dua.category.toLowerCase().contains('morning') ||
                      dua.category.toLowerCase().contains('fajr'),
                )
                .toList();

        for (final dua in fajrDuas.take(2)) {
          suggestions.add(
            SmartSuggestion(
              duaId: dua.id,
              type: SuggestionType.timeBased,
              confidence: 0.85,
              reason: 'Beautiful morning Du\'as for Fajr time',
              timestamp: now,
              trigger: SuggestionTrigger.timePattern,
            ),
          );
        }
        break;

      case TimeOfDay.evening:
      case TimeOfDay.maghrib:
        final eveningDuas =
            allDuas
                .where(
                  (dua) =>
                      dua.category.toLowerCase().contains('evening') ||
                      dua.category.toLowerCase().contains('maghrib'),
                )
                .toList();

        for (final dua in eveningDuas.take(2)) {
          suggestions.add(
            SmartSuggestion(
              duaId: dua.id,
              type: SuggestionType.timeBased,
              confidence: 0.8,
              reason: 'Evening Du\'as for reflection and gratitude',
              timestamp: now,
              trigger: SuggestionTrigger.timePattern,
            ),
          );
        }
        break;

      case TimeOfDay.night:
      case TimeOfDay.isha:
        final nightDuas =
            allDuas
                .where(
                  (dua) =>
                      dua.category.toLowerCase().contains('night') ||
                      dua.category.toLowerCase().contains('sleep'),
                )
                .toList();

        for (final dua in nightDuas.take(1)) {
          suggestions.add(
            SmartSuggestion(
              duaId: dua.id,
              type: SuggestionType.timeBased,
              confidence: 0.75,
              reason: 'Night Du\'as for peaceful sleep',
              timestamp: now,
              trigger: SuggestionTrigger.timePattern,
            ),
          );
        }
        break;

      default:
        // General time-based suggestions for other times
        break;
    }

    // Ramadan-specific suggestions
    if (timeContext.isRamadan) {
      final ramadanDuas =
          allDuas
              .where(
                (dua) =>
                    dua.category.toLowerCase().contains('ramadan') ||
                    dua.category.toLowerCase().contains('fasting'),
              )
              .toList();

      for (final dua in ramadanDuas.take(2)) {
        suggestions.add(
          SmartSuggestion(
            duaId: dua.id,
            type: SuggestionType.timeBased,
            confidence: 0.95,
            reason: 'Special Du\'as for the blessed month of Ramadan',
            timestamp: now,
            trigger: SuggestionTrigger.specialOccasion,
          ),
        );
      }
    }

    // Hajj season suggestions
    if (timeContext.isHajjSeason) {
      final hajjDuas =
          allDuas
              .where(
                (dua) =>
                    dua.category.toLowerCase().contains('hajj') ||
                    dua.category.toLowerCase().contains('pilgrimage'),
              )
              .toList();

      for (final dua in hajjDuas.take(1)) {
        suggestions.add(
          SmartSuggestion(
            duaId: dua.id,
            type: SuggestionType.timeBased,
            confidence: 0.9,
            reason: 'Du\'as for the blessed Hajj season',
            timestamp: now,
            trigger: SuggestionTrigger.specialOccasion,
          ),
        );
      }
    }

    // Special occasion suggestions
    for (final occasion in timeContext.specialOccasions) {
      final occasionDuas =
          allDuas
              .where(
                (dua) =>
                    dua.category.toLowerCase().contains(
                      occasion.toLowerCase(),
                    ) ||
                    dua.tags.any(
                      (tag) =>
                          tag.toLowerCase().contains(occasion.toLowerCase()),
                    ),
              )
              .toList();

      for (final dua in occasionDuas.take(1)) {
        suggestions.add(
          SmartSuggestion(
            duaId: dua.id,
            type: SuggestionType.timeBased,
            confidence: 0.85,
            reason: 'Special Du\'a for $occasion',
            timestamp: now,
            trigger: SuggestionTrigger.specialOccasion,
          ),
        );
      }
    }

    return suggestions;
  }

  /// Get minutes until next prayer
  int getMinutesUntilNextPrayer() {
    final timeContext = getCurrentTimeContext();
    return timeContext.prayerTimes.nextPrayer?.remaining.inMinutes ?? 0;
  }

  /// Check if it's currently prayer time (within 10 minutes)
  bool isNearPrayerTime() {
    return getMinutesUntilNextPrayer() <= 10;
  }

  /// Get current Islamic date as formatted string
  String getFormattedIslamicDate() {
    final islamicDate = getCurrentTimeContext().islamicDate;
    return '${islamicDate.day} ${islamicDate.monthName} ${islamicDate.year} AH';
  }

  /// Get formatted prayer times for today
  Map<String, String> getFormattedPrayerTimes() {
    final prayerTimes = getCurrentTimeContext().prayerTimes;
    final formatter = DateFormat('h:mm a');

    return {
      'Fajr': formatter.format(prayerTimes.fajr),
      'Sunrise': formatter.format(prayerTimes.sunrise),
      'Dhuhr': formatter.format(prayerTimes.dhuhr),
      'Asr': formatter.format(prayerTimes.asr),
      'Maghrib': formatter.format(prayerTimes.maghrib),
      'Isha': formatter.format(prayerTimes.isha),
    };
  }

  /// Get Du'a suggestions for specific Islamic occasions
  Future<List<SmartSuggestion>> getSuggestionsForOccasion(
    String occasion,
    List<DuaEntity> allDuas,
  ) async {
    final now = DateTime.now();
    final occasionDuas =
        allDuas
            .where(
              (dua) =>
                  dua.category.toLowerCase().contains(occasion.toLowerCase()) ||
                  dua.tags.any(
                    (tag) => tag.toLowerCase().contains(occasion.toLowerCase()),
                  ),
            )
            .toList();

    return occasionDuas
        .take(5)
        .map(
          (dua) => SmartSuggestion(
            duaId: dua.id,
            type: SuggestionType.timeBased,
            confidence: 0.9,
            reason: 'Perfect Du\'a for $occasion',
            timestamp: now,
            trigger: SuggestionTrigger.specialOccasion,
          ),
        )
        .toList();
  }

  /// Check if current time is within a specific time range
  bool isWithinTimeRange(TimeOfDay startTime, TimeOfDay endTime) {
    final currentTimeOfDay = getCurrentTimeContext().timeOfDay;

    // Simple check - in a real implementation you'd handle edge cases
    final timeOrder = [
      TimeOfDay.fajr,
      TimeOfDay.morning,
      TimeOfDay.dhuhr,
      TimeOfDay.afternoon,
      TimeOfDay.asr,
      TimeOfDay.maghrib,
      TimeOfDay.evening,
      TimeOfDay.isha,
      TimeOfDay.night,
    ];

    final currentIndex = timeOrder.indexOf(currentTimeOfDay);
    final startIndex = timeOrder.indexOf(startTime);
    final endIndex = timeOrder.indexOf(endTime);

    if (startIndex <= endIndex) {
      return currentIndex >= startIndex && currentIndex <= endIndex;
    } else {
      // Handle overnight ranges
      return currentIndex >= startIndex || currentIndex <= endIndex;
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  void dispose() {
    _timeUpdateTimer?.cancel();
    _suggestionsController.close();
  }
}
