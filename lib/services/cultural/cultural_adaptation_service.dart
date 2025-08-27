import 'dart:async';
import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/logging/app_logger.dart';
import '../../domain/entities/conversation_entity.dart';
import '../secure_storage/secure_storage_service.dart';

/// Cultural adaptation service with sophisticated geocoding integration
/// Provides region-specific Islamic guidance and cultural context awareness
class CulturalAdaptationService {
  static CulturalAdaptationService? _instance;
  static CulturalAdaptationService get instance =>
      _instance ??= CulturalAdaptationService._();

  CulturalAdaptationService._();

  // Core services
  late SecureStorageService _secureStorage;
  SharedPreferences? _prefs;

  // Configuration
  static const String _culturalContextKey = 'cultural_context';
  static const Duration _locationCacheExpiry = Duration(hours: 24);

  // State management
  bool _isInitialized = false;
  bool _hasLocationPermission = false;
  CulturalContext? _currentContext;
  Position? _lastKnownPosition;
  DateTime? _lastLocationUpdate;

  // Stream controllers
  final _culturalContextController =
      StreamController<CulturalContext>.broadcast();
  final _locationUpdateController =
      StreamController<LocationUpdate>.broadcast();

  // Public streams
  Stream<CulturalContext> get culturalContextStream =>
      _culturalContextController.stream;
  Stream<LocationUpdate> get locationUpdateStream =>
      _locationUpdateController.stream;

  // Islamic school mappings by region
  static const Map<String, Map<String, dynamic>> _regionalIslamicSchools = {
    // Middle East
    'SA': {
      'primary': 'Hanbali',
      'common': ['Wahhabi', 'Salafi'],
    },
    'EG': {
      'primary': 'Shafi\'i',
      'common': ['Hanafi', 'Maliki'],
    },
    'AE': {
      'primary': 'Maliki',
      'common': ['Hanbali', 'Shafi\'i'],
    },
    'JO': {
      'primary': 'Hanafi',
      'common': ['Shafi\'i'],
    },
    'SY': {
      'primary': 'Hanafi',
      'common': ['Shafi\'i'],
    },
    'LB': {
      'primary': 'Hanafi',
      'common': ['Shafi\'i', 'Shia'],
    },
    'IQ': {
      'primary': 'Hanafi',
      'common': ['Shia', 'Shafi\'i'],
    },
    'IR': {
      'primary': 'Shia',
      'common': ['Twelver Shia'],
    },

    // South Asia
    'PK': {
      'primary': 'Hanafi',
      'common': ['Deobandi', 'Barelvi', 'Ahl-e-Hadith'],
    },
    'IN': {
      'primary': 'Hanafi',
      'common': ['Shafi\'i', 'Deobandi', 'Barelvi'],
    },
    'BD': {
      'primary': 'Hanafi',
      'common': ['Sufi'],
    },
    'AF': {
      'primary': 'Hanafi',
      'common': ['Sufi'],
    },

    // Southeast Asia
    'ID': {
      'primary': 'Shafi\'i',
      'common': ['Nahdlatul Ulama', 'Muhammadiyah'],
    },
    'MY': {
      'primary': 'Shafi\'i',
      'common': ['Sufi'],
    },
    'BN': {
      'primary': 'Shafi\'i',
      'common': ['Malay Islamic traditions'],
    },
    'TH': {
      'primary': 'Shafi\'i',
      'common': ['Malay traditions'],
    },

    // Africa
    'MA': {
      'primary': 'Maliki',
      'common': ['Sufi', 'Ash\'ari'],
    },
    'DZ': {
      'primary': 'Maliki',
      'common': ['Sufi'],
    },
    'TN': {
      'primary': 'Maliki',
      'common': ['Sufi'],
    },
    'LY': {
      'primary': 'Maliki',
      'common': ['Sufi'],
    },
    'EH': {
      'primary': 'Maliki',
      'common': ['Sufi'],
    },
    'NG': {
      'primary': 'Maliki',
      'common': ['Sufi', 'Qadiriyya'],
    },
    'SN': {
      'primary': 'Maliki',
      'common': ['Sufi', 'Tijaniyya'],
    },
    'ML': {
      'primary': 'Maliki',
      'common': ['Sufi'],
    },

    // Europe & Americas
    'TR': {
      'primary': 'Hanafi',
      'common': ['Sufi', 'Mevlevi'],
    },
    'US': {
      'primary': 'Mixed',
      'common': ['Sunni', 'Shia', 'Sufi'],
    },
    'CA': {
      'primary': 'Mixed',
      'common': ['Sunni', 'Shia'],
    },
    'GB': {
      'primary': 'Mixed',
      'common': ['Sunni', 'Sufi', 'Deobandi'],
    },
    'DE': {
      'primary': 'Mixed',
      'common': ['Turkish traditions', 'Arab traditions'],
    },
    'FR': {
      'primary': 'Mixed',
      'common': ['Maghrebi traditions', 'Turkish traditions'],
    },
  };

  // Cultural preferences by region
  static const Map<String, Map<String, dynamic>> _culturalPreferences = {
    // Language preferences
    'language_priority': {
      'SA': ['ar', 'en'],
      'EG': ['ar', 'en'],
      'PK': ['ur', 'en', 'ar'],
      'IN': ['ur', 'hi', 'en', 'ar'],
      'ID': ['id', 'ar', 'en'],
      'MY': ['ms', 'ar', 'en'],
      'TR': ['tr', 'ar', 'en'],
      'US': ['en', 'ar', 'ur'],
      'GB': ['en', 'ar', 'ur'],
    },

    // Prayer time calculation methods by region
    'prayer_calculation': {
      'SA': 'umm_al_qura',
      'EG': 'egyptian',
      'PK': 'university_of_karachi',
      'IN': 'university_of_karachi',
      'ID': 'kemenag',
      'MY': 'jakim',
      'TR': 'turkey',
      'US': 'isna',
      'CA': 'isna',
    },

    // Cultural Du'a preferences
    'dua_style': {
      'SA': 'classical_arabic',
      'EG': 'classical_with_colloquial',
      'PK': 'urdu_translation',
      'IN': 'multilingual',
      'ID': 'indonesian_translation',
      'MY': 'malay_translation',
      'TR': 'turkish_translation',
      'US': 'english_focused',
    },

    // Cultural celebration emphasis
    'celebrations': {
      'SA': ['hajj', 'ramadan', 'eid_al_fitr', 'eid_al_adha'],
      'EG': ['ramadan', 'mawlid', 'eid_al_fitr', 'eid_al_adha'],
      'PK': ['ramadan', 'eid_al_fitr', 'eid_al_adha', 'shab_e_barat'],
      'IN': ['ramadan', 'eid_al_fitr', 'eid_al_adha', 'shab_e_barat'],
      'ID': ['ramadan', 'eid_al_fitr', 'eid_al_adha', 'isra_miraj'],
      'TR': ['ramadan', 'kandil_nights', 'eid_al_fitr', 'eid_al_adha'],
    },
  };

  // Regional Du'a adaptations
  static const Map<String, Map<String, List<String>>> _regionalDuaAdaptations =
      {
    'travel': {
      'SA': [
        'Ø§Ù„Ù„Ù‡Ù… Ø¥Ù†Ø§ Ù†Ø³Ø£Ù„Ùƒ ÙÙŠ Ø³ÙØ±Ù†Ø§ Ù‡Ø°Ø§ Ø§Ù„Ø¨Ø± ÙˆØ§Ù„ØªÙ‚ÙˆÙ‰',
        'Travel Du\'a with emphasis on Hajj/Umrah context',
      ],
      'PK': [
        'Ø§Ù„Ù„Ù‡Ù… Ø¥Ù†Ø§ Ù†Ø³Ø£Ù„Ùƒ ÙÙŠ Ø³ÙØ±Ù†Ø§ Ù‡Ø°Ø§ Ø§Ù„Ø¨Ø± ÙˆØ§Ù„ØªÙ‚ÙˆÙ‰',
        'ÛŒØ§ Ø§Ù„Ù„Û ÛÙ…Ø§Ø±ÛŒ Ø§Ø³ Ø³ÙØ± Ù…ÛŒÚº Ø¨Ú¾Ù„Ø§Ø¦ÛŒ Ø§ÙˆØ± ØªÙ‚ÙˆÛŒÙ° Ø¹Ø·Ø§ ÙØ±Ù…Ø§',
      ],
      'ID': [
        'Ø§Ù„Ù„Ù‡Ù… Ø¥Ù†Ø§ Ù†Ø³Ø£Ù„Ùƒ ÙÙŠ Ø³ÙØ±Ù†Ø§ Ù‡Ø°Ø§ Ø§Ù„Ø¨Ø± ÙˆØ§Ù„ØªÙ‚ÙˆÙ‰',
        'Ya Allah, dalam perjalanan ini berikanlah kebaikan dan takwa',
      ],
    },
    'work': {
      'US': [
        'Ø§Ù„Ù„Ù‡Ù… Ø¨Ø§Ø±Ùƒ Ù„Ù†Ø§ ÙÙŠÙ…Ø§ Ø±Ø²Ù‚ØªÙ†Ø§',
        'O Allah, bless us in what You have provided',
        'Professional success with Islamic ethics emphasis',
      ],
      'SA': [
        'Ø§Ù„Ù„Ù‡Ù… Ø¨Ø§Ø±Ùƒ Ù„Ù†Ø§ ÙÙŠÙ…Ø§ Ø±Ø²Ù‚ØªÙ†Ø§ ÙˆÙ‚Ù†Ø§ Ø¹Ø°Ø§Ø¨ Ø§Ù„Ù†Ø§Ø±',
        'Work Du\'a with traditional Arabic emphasis',
      ],
    },
  };

  /// Initialize cultural adaptation service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('Initializing Cultural Adaptation Service...');

      _secureStorage = SecureStorageService.instance;
      _prefs = await SharedPreferences.getInstance();

      // Check location permissions
      await _checkLocationPermissions();

      // Load cached cultural context
      await _loadCachedContext();

      // Update location if needed
      if (_shouldUpdateLocation()) {
        await _updateLocationAndContext();
      }

      _isInitialized = true;
      AppLogger.info('Cultural Adaptation Service initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize Cultural Adaptation Service: $e');
      throw Exception('Cultural adaptation service initialization failed');
    }
  }

  /// Get current cultural context
  Future<CulturalContext?> getCurrentCulturalContext() async {
    await _ensureInitialized();
    return _currentContext;
  }

  /// Update location and cultural context
  Future<void> updateLocationAndContext() async {
    await _ensureInitialized();
    await _updateLocationAndContext();
  }

  /// Get culturally adapted Du'a recommendations
  Future<List<String>> getCulturalDuaRecommendations({
    required String category,
    required String userId,
    EmotionalState? emotionalState,
  }) async {
    await _ensureInitialized();

    final context = _currentContext;
    if (context == null) {
      return _getGenericDuaRecommendations(category);
    }

    final countryCode = context.country;
    final recommendations = <String>[];

    // Get regional adaptations
    final regionalAdaptations = _regionalDuaAdaptations[category];
    if (regionalAdaptations != null &&
        regionalAdaptations.containsKey(countryCode)) {
      recommendations.addAll(regionalAdaptations[countryCode]!);
    }

    // Add language-specific recommendations
    final languagePriorities = _culturalPreferences['language_priority']
        ?[countryCode] as List<String>?;
    if (languagePriorities != null) {
      for (final lang in languagePriorities) {
        final langSpecific = await _getLanguageSpecificDua(category, lang);
        recommendations.addAll(langSpecific);
      }
    }

    // Add Islamic school context
    final schoolInfo = _regionalIslamicSchools[countryCode];
    if (schoolInfo != null) {
      final schoolSpecific = await _getSchoolSpecificDua(category, schoolInfo);
      recommendations.addAll(schoolSpecific);
    }

    // If no specific recommendations found, return generic ones
    if (recommendations.isEmpty) {
      return _getGenericDuaRecommendations(category);
    }

    return recommendations.take(5).toList();
  }

  /// Get cultural prayer time preferences
  Future<String?> getPrayerCalculationMethod() async {
    await _ensureInitialized();

    final context = _currentContext;
    if (context == null) return null;

    return _culturalPreferences['prayer_calculation']?[context.country]
        as String?;
  }

  /// Get preferred languages for user's region
  Future<List<String>> getPreferredLanguages() async {
    await _ensureInitialized();

    final context = _currentContext;
    if (context == null) return ['en'];

    return (_culturalPreferences['language_priority']?[context.country]
                as List<dynamic>?)
            ?.cast<String>() ??
        ['en'];
  }

  /// Get regional Islamic celebrations
  Future<List<String>> getRegionalCelebrations() async {
    await _ensureInitialized();

    final context = _currentContext;
    if (context == null) return [];

    return (_culturalPreferences['celebrations']?[context.country]
                as List<dynamic>?)
            ?.cast<String>() ??
        [];
  }

  /// Set manual cultural context (for users who prefer to specify)
  Future<void> setManualCulturalContext({
    required String country,
    required String region,
    required String primaryLanguage,
    required List<String> preferredLanguages,
    required String islamicSchool,
    Map<String, dynamic>? additionalPreferences,
  }) async {
    await _ensureInitialized();

    final context = CulturalContext(
      userId: await _secureStorage.getUserId() ?? 'anonymous',
      country: country,
      region: region,
      primaryLanguage: primaryLanguage,
      preferredLanguages: preferredLanguages,
      islamicSchool: islamicSchool,
      culturalPreferences: {
        'manual_override': true,
        'source': 'user_specified',
        ...?additionalPreferences,
      },
      lastUpdated: DateTime.now(),
    );

    await _updateCulturalContext(context);
    AppLogger.info('Manual cultural context set for $country/$region');
  }

  /// Check if location permission is available
  bool get hasLocationPermission => _hasLocationPermission;

  /// Get current position if available
  Position? get currentPosition => _lastKnownPosition;

  // Private helper methods

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  Future<void> _checkLocationPermissions() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      _hasLocationPermission = permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;

      if (!_hasLocationPermission) {
        AppLogger.warning(
          'Location permission not granted - cultural adaptation will be limited',
        );
      }
    } catch (e) {
      AppLogger.error('Error checking location permissions: $e');
      _hasLocationPermission = false;
    }
  }

  Future<void> _loadCachedContext() async {
    try {
      final cachedJson = _prefs?.getString(_culturalContextKey);
      if (cachedJson != null) {
        final contextData = jsonDecode(cachedJson);
        _currentContext = CulturalContext.fromJson(contextData);

        final lastUpdate = _currentContext?.lastUpdated;
        _lastLocationUpdate = lastUpdate;

        AppLogger.debug(
          'Loaded cached cultural context: ${_currentContext?.country}/${_currentContext?.region}',
        );
      }
    } catch (e) {
      AppLogger.warning('Failed to load cached cultural context: $e');
    }
  }

  bool _shouldUpdateLocation() {
    if (!_hasLocationPermission) return false;
    if (_lastLocationUpdate == null) return true;

    return DateTime.now()
            .difference(_lastLocationUpdate!)
            .compareTo(_locationCacheExpiry) >
        0;
  }

  Future<void> _updateLocationAndContext() async {
    if (!_hasLocationPermission) {
      AppLogger.warning('Cannot update location - permission not granted');
      return;
    }

    try {
      AppLogger.info('Updating location and cultural context...');

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      _lastKnownPosition = position;

      // Get address from coordinates
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        await _buildCulturalContextFromLocation(placemark);

        _locationUpdateController.add(
          LocationUpdate(
            position: position,
            placemark: placemark,
            timestamp: DateTime.now(),
          ),
        );
      }

      _lastLocationUpdate = DateTime.now();
    } catch (e) {
      AppLogger.error('Failed to update location and context: $e');
    }
  }

  Future<void> _buildCulturalContextFromLocation(Placemark placemark) async {
    try {
      final countryCode = placemark.isoCountryCode ?? 'XX';
      final country = placemark.country ?? 'Unknown';
      final region =
          placemark.administrativeArea ?? placemark.locality ?? 'Unknown';

      // Determine primary language based on country
      final primaryLanguage = _determinePrimaryLanguage(countryCode);

      // Get preferred languages for region
      final preferredLanguages = (_culturalPreferences['language_priority']
                  ?[countryCode] as List<dynamic>?)
              ?.cast<String>() ??
          [primaryLanguage];

      // Determine Islamic school
      final islamicSchool = _determineIslamicSchool(countryCode);

      // Build cultural preferences
      final culturalPreferences = <String, dynamic>{
        'source': 'geocoding',
        'location_accuracy': 'city',
        'prayer_method':
            _culturalPreferences['prayer_calculation']?[countryCode] ?? 'isna',
        'dua_style': _culturalPreferences['dua_style']?[countryCode] ??
            'english_focused',
        'celebrations':
            _culturalPreferences['celebrations']?[countryCode] ?? [],
        'coordinates': {
          'latitude': _lastKnownPosition?.latitude,
          'longitude': _lastKnownPosition?.longitude,
        },
      };

      final context = CulturalContext(
        userId: await _secureStorage.getUserId() ?? 'anonymous',
        country: countryCode,
        region: region,
        primaryLanguage: primaryLanguage,
        preferredLanguages: preferredLanguages,
        islamicSchool: islamicSchool,
        culturalPreferences: culturalPreferences,
        lastUpdated: DateTime.now(),
      );

      await _updateCulturalContext(context);
      AppLogger.info(
        'Cultural context updated: $country ($countryCode) - $islamicSchool school',
      );
    } catch (e) {
      AppLogger.error('Failed to build cultural context from location: $e');
    }
  }

  String _determinePrimaryLanguage(String countryCode) {
    const languageMap = {
      'SA': 'ar',
      'EG': 'ar',
      'AE': 'ar',
      'JO': 'ar',
      'SY': 'ar',
      'LB': 'ar',
      'IQ': 'ar',
      'LY': 'ar',
      'DZ': 'ar',
      'MA': 'ar',
      'TN': 'ar',
      'PK': 'ur',
      'IN': 'hi',
      'BD': 'bn',
      'AF': 'fa',
      'IR': 'fa',
      'ID': 'id',
      'MY': 'ms',
      'BN': 'ms',
      'TR': 'tr',
    };

    return languageMap[countryCode] ?? 'en';
  }

  String _determineIslamicSchool(String countryCode) {
    final schoolInfo = _regionalIslamicSchools[countryCode];
    return schoolInfo?['primary'] ?? 'Sunni';
  }

  Future<void> _updateCulturalContext(CulturalContext context) async {
    _currentContext = context;

    // Save to cache
    await _prefs?.setString(_culturalContextKey, jsonEncode(context.toJson()));

    // Notify listeners
    _culturalContextController.add(context);
  }

  List<String> _getGenericDuaRecommendations(String category) {
    const genericRecommendations = {
      'travel': [
        'Ø§Ù„Ù„Ù‡Ù… Ø¥Ù†Ø§ Ù†Ø³Ø£Ù„Ùƒ ÙÙŠ Ø³ÙØ±Ù†Ø§ Ù‡Ø°Ø§ Ø§Ù„Ø¨Ø± ÙˆØ§Ù„ØªÙ‚ÙˆÙ‰',
        'O Allah, we ask You for righteousness and piety in this journey',
      ],
      'work': [
        'Ø§Ù„Ù„Ù‡Ù… Ø¨Ø§Ø±Ùƒ Ù„Ù†Ø§ ÙÙŠÙ…Ø§ Ø±Ø²Ù‚ØªÙ†Ø§',
        'O Allah, bless us in what You have provided',
      ],
      'health': [
        'Ø§Ù„Ù„Ù‡Ù… Ø§Ø´ÙÙ†ÙŠ ÙØ¥Ù†Ùƒ Ø§Ù„Ø´Ø§ÙÙŠ',
        'O Allah, heal me, for You are the Healer',
      ],
      'guidance': [
        'Ø§Ù„Ù„Ù‡Ù… Ø£Ø±Ù†ÙŠ Ø§Ù„Ø­Ù‚ Ø­Ù‚Ø§Ù‹ ÙˆØ§Ø±Ø²Ù‚Ù†ÙŠ Ø§ØªØ¨Ø§Ø¹Ù‡',
        'O Allah, show me the truth and grant me the ability to follow it',
      ],
    };

    return genericRecommendations[category] ??
        [
          'Ø¨Ø³Ù… Ø§Ù„Ù„Ù‡ Ø§Ù„Ø±Ø­Ù…Ù† Ø§Ù„Ø±Ø­ÙŠÙ…',
          'In the name of Allah, the Most Gracious, the Most Merciful',
        ];
  }

  Future<List<String>> _getLanguageSpecificDua(
    String category,
    String language,
  ) async {
    // This would be enhanced with a proper multilingual Du'a database
    switch (language) {
      case 'ar':
        return ['Arabic Du\'a for $category'];
      case 'ur':
        return ['Urdu translation for $category'];
      case 'id':
        return ['Indonesian translation for $category'];
      case 'ms':
        return ['Malay translation for $category'];
      case 'tr':
        return ['Turkish translation for $category'];
      default:
        return ['English translation for $category'];
    }
  }

  Future<List<String>> _getSchoolSpecificDua(
    String category,
    Map<String, dynamic> schoolInfo,
  ) async {
    final primarySchool = schoolInfo['primary'] as String;

    // This would be enhanced with school-specific Du'a variations
    return ['$primarySchool school guidance for $category'];
  }

  /// Cleanup resources
  void dispose() {
    _culturalContextController.close();
    _locationUpdateController.close();
  }
}

/// Location update notification
class LocationUpdate {
  final Position position;
  final Placemark placemark;
  final DateTime timestamp;

  LocationUpdate({
    required this.position,
    required this.placemark,
    required this.timestamp,
  });
}
