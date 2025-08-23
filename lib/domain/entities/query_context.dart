import 'package:equatable/equatable.dart';
import 'enhanced_query.dart';

/// Contextual information for query enhancement
class QueryContext extends Equatable {
  final DateTime? timestamp;
  final TimeOfDay? timeOfDay;
  final String? islamicDate;
  final PrayerTime? prayerTime;
  final String? seasonalContext;
  final String? weekday;
  final String? location;
  final Map<String, dynamic>? userPreferences;
  final String? deviceLanguage;
  final String? timezone;

  const QueryContext({
    this.timestamp,
    this.timeOfDay,
    this.islamicDate,
    this.prayerTime,
    this.seasonalContext,
    this.weekday,
    this.location,
    this.userPreferences,
    this.deviceLanguage,
    this.timezone,
  });

  @override
  List<Object?> get props => [
    timestamp,
    timeOfDay,
    islamicDate,
    prayerTime,
    seasonalContext,
    weekday,
    location,
    userPreferences,
    deviceLanguage,
    timezone,
  ];

  QueryContext copyWith({
    DateTime? timestamp,
    TimeOfDay? timeOfDay,
    String? islamicDate,
    PrayerTime? prayerTime,
    String? seasonalContext,
    String? weekday,
    String? location,
    Map<String, dynamic>? userPreferences,
    String? deviceLanguage,
    String? timezone,
  }) {
    return QueryContext(
      timestamp: timestamp ?? this.timestamp,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      islamicDate: islamicDate ?? this.islamicDate,
      prayerTime: prayerTime ?? this.prayerTime,
      seasonalContext: seasonalContext ?? this.seasonalContext,
      weekday: weekday ?? this.weekday,
      location: location ?? this.location,
      userPreferences: userPreferences ?? this.userPreferences,
      deviceLanguage: deviceLanguage ?? this.deviceLanguage,
      timezone: timezone ?? this.timezone,
    );
  }

  /// Convert to map for serialization
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp?.toIso8601String(),
      'timeOfDay': timeOfDay?.name,
      'islamicDate': islamicDate,
      'prayerTime': prayerTime?.name,
      'seasonalContext': seasonalContext,
      'weekday': weekday,
      'location': location,
      'userPreferences': userPreferences,
      'deviceLanguage': deviceLanguage,
      'timezone': timezone,
    };
  }

  /// Create from map for deserialization
  factory QueryContext.fromMap(Map<String, dynamic> map) {
    return QueryContext(
      timestamp: map['timestamp'] != null ? DateTime.parse(map['timestamp']) : null,
      timeOfDay:
          map['timeOfDay'] != null
              ? TimeOfDay.values.firstWhere((e) => e.name == map['timeOfDay'], orElse: () => TimeOfDay.morning)
              : null,
      islamicDate: map['islamicDate'],
      prayerTime:
          map['prayerTime'] != null
              ? PrayerTime.values.firstWhere((e) => e.name == map['prayerTime'], orElse: () => PrayerTime.fajr)
              : null,
      seasonalContext: map['seasonalContext'],
      weekday: map['weekday'],
      location: map['location'],
      userPreferences: map['userPreferences'] != null ? Map<String, dynamic>.from(map['userPreferences']) : null,
      deviceLanguage: map['deviceLanguage'],
      timezone: map['timezone'],
    );
  }

  /// Check if context has sufficient information for enhancement
  bool get isRich {
    int contextFactors = 0;
    if (timeOfDay != null) contextFactors++;
    if (prayerTime != null) contextFactors++;
    if (location != null) contextFactors++;
    if (seasonalContext != null) contextFactors++;
    if (userPreferences != null && userPreferences!.isNotEmpty) {
      contextFactors++;
    }

    return contextFactors >= 3;
  }

  /// Get context summary for logging
  String get summary {
    final parts = <String>[];
    if (timeOfDay != null) parts.add('time:${timeOfDay!.name}');
    if (prayerTime != null) parts.add('prayer:${prayerTime!.name}');
    if (location != null) parts.add('location:$location');
    if (seasonalContext != null) parts.add('season:$seasonalContext');

    return parts.isEmpty ? 'minimal' : parts.join(',');
  }
}
