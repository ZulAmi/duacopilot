import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/entities/dua_entity.dart';
import '../../domain/entities/context_entity.dart';

/// LocationService class implementation
class LocationService {
  static LocationService? _instance;
  static LocationService get instance => _instance ??= LocationService._();

  LocationService._();

  bool _isInitialized = false;
  Position? _lastKnownPosition;
  StreamSubscription<Position>? _positionSubscription;

  /// Stream of location-based Du'a suggestions
  final StreamController<List<SmartSuggestion>> _suggestionsController =
      StreamController<List<SmartSuggestion>>.broadcast();
  Stream<List<SmartSuggestion>> get suggestionStream =>
      _suggestionsController.stream;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final hasPermission = await _requestLocationPermission();
      if (!hasPermission) {
        debugPrint('Location permission denied');
        return;
      }

      _isInitialized = true;
      debugPrint('Location service initialized');
    } catch (e) {
      debugPrint('Failed to initialize location service: $e');
      rethrow;
    }
  }

  Future<bool> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permissions are permanently denied');
      return false;
    }

    return true;
  }

  /// Get current location context
  Future<LocationContext?> getCurrentLocationContext() async {
    await _ensureInitialized();

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );

      _lastKnownPosition = position;

      return LocationContext(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        timestamp: position.timestamp,
        address: await _getPlaceName(position),
        type: await _getPlaceType(position),
        nearbyPlaces: await _getNearbyPlaces(position),
      );
    } catch (e) {
      debugPrint('Failed to get current location: $e');

      // Return last known position if available
      if (_lastKnownPosition != null) {
        return LocationContext(
          latitude: _lastKnownPosition!.latitude,
          longitude: _lastKnownPosition!.longitude,
          accuracy: _lastKnownPosition!.accuracy,
          timestamp: _lastKnownPosition!.timestamp,
          address: 'Unknown',
          type: LocationType.unknown,
          nearbyPlaces: [],
        );
      }

      return null;
    }
  }

  /// Start monitoring location for contextual suggestions
  Future<void> startLocationMonitoring(List<DuaEntity> allDuas) async {
    await _ensureInitialized();

    if (_positionSubscription != null) {
      await _positionSubscription!.cancel();
    }

    try {
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          distanceFilter: 100, // Update every 100 meters
        ),
      ).listen(
        (Position position) => _handleLocationUpdate(position, allDuas),
        onError: (error) => debugPrint('Location stream error: $error'),
      );
    } catch (e) {
      debugPrint('Failed to start location monitoring: $e');
    }
  }

  /// Stop location monitoring
  Future<void> stopLocationMonitoring() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  void _handleLocationUpdate(Position position, List<DuaEntity> allDuas) async {
    _lastKnownPosition = position;

    try {
      final locationContext = LocationContext(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        timestamp: position.timestamp,
        address: await _getPlaceName(position),
        type: await _getPlaceType(position),
        nearbyPlaces: await _getNearbyPlaces(position),
      );

      final suggestions = await _generateLocationBasedSuggestions(
        locationContext,
        allDuas,
      );
      _suggestionsController.add(suggestions);
    } catch (e) {
      debugPrint('Error handling location update: $e');
    }
  }

  Future<String> _getPlaceName(Position position) async {
    // In a real implementation, you would use a geocoding service
    // For now, return a generic name based on coordinates
    return 'Location (${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})';
  }

  Future<LocationType> _getPlaceType(Position position) async {
    // In a real implementation, you would use place detection APIs
    // For now, return unknown type
    return LocationType.unknown;
  }

  Future<List<String>> _getNearbyPlaces(Position position) async {
    // In a real implementation, you would query nearby places
    // For now, return empty list
    return [];
  }

  Future<List<SmartSuggestion>> _generateLocationBasedSuggestions(
    LocationContext location,
    List<DuaEntity> allDuas,
  ) async {
    final suggestions = <SmartSuggestion>[];
    final now = DateTime.now();

    // Mosque-related suggestions
    if (location.type == LocationType.mosque) {
      final mosqueRelatedDuas =
          allDuas
              .where(
                (dua) =>
                    dua.category.toLowerCase().contains('mosque') ||
                    dua.category.toLowerCase().contains('prayer') ||
                    dua.category.toLowerCase().contains('salah'),
              )
              .toList();

      for (final dua in mosqueRelatedDuas.take(3)) {
        suggestions.add(
          SmartSuggestion(
            duaId: dua.id,
            type: SuggestionType.locationBased,
            confidence: 0.9,
            reason: 'Perfect Du\'as for when you\'re at the mosque',
            timestamp: now,
            trigger: SuggestionTrigger.locationChange,
          ),
        );
      }
    }

    // Home-related suggestions
    if (location.type == LocationType.home) {
      final homeDuas =
          allDuas
              .where(
                (dua) =>
                    dua.category.toLowerCase().contains('home') ||
                    dua.category.toLowerCase().contains('entering') ||
                    dua.category.toLowerCase().contains('leaving'),
              )
              .toList();

      for (final dua in homeDuas.take(2)) {
        suggestions.add(
          SmartSuggestion(
            duaId: dua.id,
            type: SuggestionType.locationBased,
            confidence: 0.8,
            reason: 'Du\'as for home and family',
            timestamp: now,
            trigger: SuggestionTrigger.locationChange,
          ),
        );
      }
    }

    // Travel-related suggestions
    if (location.type == LocationType.travel) {
      final travelDuas =
          allDuas
              .where(
                (dua) =>
                    dua.category.toLowerCase().contains('travel') ||
                    dua.category.toLowerCase().contains('journey') ||
                    dua.category.toLowerCase().contains('vehicle'),
              )
              .toList();

      for (final dua in travelDuas.take(2)) {
        suggestions.add(
          SmartSuggestion(
            duaId: dua.id,
            type: SuggestionType.locationBased,
            confidence: 0.85,
            reason: 'Travel Du\'as for your journey',
            timestamp: now,
            trigger: SuggestionTrigger.locationChange,
          ),
        );
      }
    }

    // Work-related suggestions
    if (location.type == LocationType.work) {
      final workDuas =
          allDuas
              .where(
                (dua) =>
                    dua.category.toLowerCase().contains('work') ||
                    dua.category.toLowerCase().contains('success') ||
                    dua.category.toLowerCase().contains('knowledge'),
              )
              .toList();

      for (final dua in workDuas.take(2)) {
        suggestions.add(
          SmartSuggestion(
            duaId: dua.id,
            type: SuggestionType.locationBased,
            confidence: 0.7,
            reason: 'Du\'as for work and success',
            timestamp: now,
            trigger: SuggestionTrigger.locationChange,
          ),
        );
      }
    }

    // General location-based suggestions
    if (suggestions.isEmpty) {
      // Suggest general Du'as if no specific location type is detected
      final generalDuas =
          allDuas
              .where(
                (dua) =>
                    dua.category.toLowerCase().contains('general') ||
                    dua.category.toLowerCase().contains('daily'),
              )
              .toList();

      for (final dua in generalDuas.take(1)) {
        suggestions.add(
          SmartSuggestion(
            duaId: dua.id,
            type: SuggestionType.locationBased,
            confidence: 0.5,
            reason: 'General Du\'a for any location',
            timestamp: now,
            trigger: SuggestionTrigger.locationChange,
          ),
        );
      }
    }

    return suggestions;
  }

  /// Check if user is at a specific type of place
  Future<bool> isAtPlaceType(LocationType locationType) async {
    final location = await getCurrentLocationContext();
    return location?.type == locationType;
  }

  /// Get distance between two locations in meters
  double getDistanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Check if user has moved significantly from last known position
  bool hasSignificantLocationChange(
    Position newPosition, {
    double threshold = 100.0,
  }) {
    if (_lastKnownPosition == null) return true;

    final distance = getDistanceBetween(
      _lastKnownPosition!.latitude,
      _lastKnownPosition!.longitude,
      newPosition.latitude,
      newPosition.longitude,
    );

    return distance >= threshold;
  }

  /// Get location-based Du'a suggestions for specific place types
  Future<List<SmartSuggestion>> getSuggestionsForPlaceType(
    LocationType locationType,
    List<DuaEntity> allDuas,
  ) async {
    final mockLocation = LocationContext(
      latitude: 0.0,
      longitude: 0.0,
      accuracy: 0.0,
      timestamp: DateTime.now(),
      address: 'Mock Location',
      type: locationType,
      nearbyPlaces: [],
    );

    return await _generateLocationBasedSuggestions(mockLocation, allDuas);
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  void dispose() {
    _positionSubscription?.cancel();
    _suggestionsController.close();
  }
}
