import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' hide LocationAccuracy;
import 'package:geolocator/geolocator.dart' as geo show LocationAccuracy;
import 'package:sensors_plus/sensors_plus.dart';
import '../../../domain/entities/qibla_entity.dart';
import '../../../core/storage/secure_storage_service.dart';

/// QiblaCompassService - High-precision compass with advanced calibration
class QiblaCompassService {
  static const String _calibrationKey = 'compass_calibration';
  static const String _userLocationKey = 'user_location_qibla';

  // Kaaba coordinates (GPS)
  static const double kaabaLatitude = 21.422487;
  static const double kaabaLongitude = 39.826206;

  final SecureStorageService _secureStorage;

  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  final StreamController<QiblaCompass> _compassController =
      StreamController<QiblaCompass>.broadcast();

  // Sensor data for advanced calibration
  final List<double> _magneticReadings = [];
  final List<double> _accelerometerReadings = [];
  final List<double> _gyroscopeReadings = [];

  // Current compass state
  Position? _currentPosition;
  double _currentHeading = 0.0;
  double _qiblaDirection = 0.0;
  CalibrationQuality _calibrationQuality = CalibrationQuality.uncalibrated;
  DateTime? _lastCalibration;

  QiblaCompassService(this._secureStorage);

  /// Get compass stream for real-time updates
  Stream<QiblaCompass> get compassStream => _compassController.stream;

  /// Initialize compass service with permissions and sensors
  Future<bool> initialize() async {
    try {
      // Request location permissions
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission is required for Qibla compass');
      }

      // Load saved calibration data
      await _loadCalibrationData();

      // Get current location
      await _updateLocation();

      // Start sensor listeners
      await _startSensorListeners();

      return true;
    } catch (e) {
      print('Failed to initialize Qibla compass: $e');
      return false;
    }
  }

  /// Update current location and recalculate Qibla direction
  Future<void> _updateLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      if (_currentPosition != null) {
        _qiblaDirection = _calculateQiblaDirection(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );

        // Save location for offline use
        await _secureStorage.saveValue(
          _userLocationKey,
          '${_currentPosition!.latitude},${_currentPosition!.longitude}',
        );
      }
    } catch (e) {
      print('Failed to get location: $e');
      // Try to load saved location
      await _loadSavedLocation();
    }
  }

  /// Load saved location for offline functionality
  Future<void> _loadSavedLocation() async {
    try {
      final locationData = await _secureStorage.getValue(_userLocationKey);
      if (locationData != null) {
        final coords = locationData.split(',');
        if (coords.length == 2) {
          final lat = double.parse(coords[0]);
          final lng = double.parse(coords[1]);
          _qiblaDirection = _calculateQiblaDirection(lat, lng);
        }
      }
    } catch (e) {
      print('Failed to load saved location: $e');
    }
  }

  /// Calculate Qibla direction using precise spherical trigonometry
  double _calculateQiblaDirection(double userLat, double userLng) {
    final double userLatRad = userLat * pi / 180;
    final double userLngRad = userLng * pi / 180;
    const double kaabaLatRad = kaabaLatitude * pi / 180;
    const double kaabaLngRad = kaabaLongitude * pi / 180;

    final double deltaLng = kaabaLngRad - userLngRad;

    final double y = sin(deltaLng) * cos(kaabaLatRad);
    final double x =
        cos(userLatRad) * sin(kaabaLatRad) -
        sin(userLatRad) * cos(kaabaLatRad) * cos(deltaLng);

    double qiblaDirection = atan2(y, x) * 180 / pi;

    // Normalize to 0-360 degrees
    if (qiblaDirection < 0) {
      qiblaDirection += 360;
    }

    return qiblaDirection;
  }

  /// Start sensor listeners for compass functionality
  Future<void> _startSensorListeners() async {
    // Magnetometer for compass heading
    _magnetometerSubscription = magnetometerEventStream().listen(
      _onMagnetometerEvent,
      onError: (e) => print('Magnetometer error: $e'),
    );

    // Accelerometer for device orientation
    _accelerometerSubscription = accelerometerEventStream().listen(
      _onAccelerometerEvent,
      onError: (e) => print('Accelerometer error: $e'),
    );

    // Gyroscope for stability detection
    _gyroscopeSubscription = gyroscopeEventStream().listen(
      _onGyroscopeEvent,
      onError: (e) => print('Gyroscope error: $e'),
    );
  }

  /// Handle magnetometer events for compass heading
  void _onMagnetometerEvent(MagnetometerEvent event) {
    // Calculate heading from magnetometer data
    final double heading = atan2(event.y, event.x) * 180 / pi;
    _currentHeading = _normalizeAngle(heading);

    // Store reading for calibration analysis
    _magneticReadings.add(heading);
    if (_magneticReadings.length > 100) {
      _magneticReadings.removeAt(0);
    }

    // Update calibration quality based on variance
    _updateCalibrationQuality();

    // Emit updated compass data
    _emitCompassUpdate();
  }

  /// Handle accelerometer events for device orientation
  void _onAccelerometerEvent(AccelerometerEvent event) {
    _accelerometerReadings.addAll([event.x, event.y, event.z]);
    if (_accelerometerReadings.length > 300) {
      _accelerometerReadings.removeRange(0, 3);
    }
  }

  /// Handle gyroscope events for stability detection
  void _onGyroscopeEvent(GyroscopeEvent event) {
    _gyroscopeReadings.addAll([event.x, event.y, event.z]);
    if (_gyroscopeReadings.length > 300) {
      _gyroscopeReadings.removeRange(0, 3);
    }
  }

  /// Update calibration quality based on sensor data variance
  void _updateCalibrationQuality() {
    if (_magneticReadings.length < 10) {
      _calibrationQuality = CalibrationQuality.uncalibrated;
      return;
    }

    // Calculate variance in magnetic readings
    final double mean =
        _magneticReadings.reduce((a, b) => a + b) / _magneticReadings.length;
    final double variance =
        _magneticReadings.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) /
        _magneticReadings.length;

    // Determine quality based on variance
    if (variance < 5) {
      _calibrationQuality = CalibrationQuality.excellent;
    } else if (variance < 10) {
      _calibrationQuality = CalibrationQuality.good;
    } else if (variance < 20) {
      _calibrationQuality = CalibrationQuality.fair;
    } else {
      _calibrationQuality = CalibrationQuality.poor;
    }
  }

  /// Emit compass update to listeners
  void _emitCompassUpdate() {
    if (_currentPosition == null) return;

    final LocationAccuracy accuracy = _getLocationAccuracy();
    final bool needsCalibration =
        _calibrationQuality == CalibrationQuality.poor ||
        _calibrationQuality == CalibrationQuality.uncalibrated;

    final compass = QiblaCompass(
      qiblaDirection: _qiblaDirection,
      currentDirection: _currentHeading,
      deviceHeading: _currentHeading,
      accuracy: accuracy,
      lastUpdated: DateTime.now(),
      isCalibrationNeeded: needsCalibration,
      distanceToKaaba: _calculateDistanceToKaaba(),
      calibrationData: _getCalibrationData(),
    );

    _compassController.add(compass);
  }

  /// Get current location accuracy
  LocationAccuracy _getLocationAccuracy() {
    if (_currentPosition == null) return LocationAccuracy.unavailable;

    if (_currentPosition!.accuracy <= 5) return LocationAccuracy.high;
    if (_currentPosition!.accuracy <= 20) return LocationAccuracy.medium;
    return LocationAccuracy.low;
  }

  /// Calculate distance to Kaaba in kilometers
  double _calculateDistanceToKaaba() {
    if (_currentPosition == null) return 0.0;

    return Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          kaabaLatitude,
          kaabaLongitude,
        ) /
        1000; // Convert to kilometers
  }

  /// Get current calibration data
  QiblaCalibrationData _getCalibrationData() {
    return QiblaCalibrationData(
      magneticDeclination: _calculateMagneticDeclination(),
      lastCalibration: _lastCalibration ?? DateTime.now(),
      quality: _calibrationQuality,
      calibrationReadings: List.from(_magneticReadings.take(10)),
    );
  }

  /// Calculate magnetic declination for location
  double _calculateMagneticDeclination() {
    // Simplified magnetic declination calculation
    // In production, use WMM (World Magnetic Model) library
    if (_currentPosition == null) return 0.0;

    final double lat = _currentPosition!.latitude;
    final double lng = _currentPosition!.longitude;

    // Rough approximation - replace with precise WMM calculation
    return sin(lat * pi / 180) * sin(lng * pi / 180) * 15;
  }

  /// Normalize angle to 0-360 degrees
  double _normalizeAngle(double angle) {
    angle = angle % 360;
    if (angle < 0) angle += 360;
    return angle;
  }

  /// Load calibration data from secure storage
  Future<void> _loadCalibrationData() async {
    try {
      final calibrationData = await _secureStorage.getValue(_calibrationKey);
      if (calibrationData != null) {
        // Parse and load calibration settings
        _lastCalibration = DateTime.parse(calibrationData);
      }
    } catch (e) {
      print('Failed to load calibration data: $e');
    }
  }

  /// Save calibration data to secure storage
  Future<void> _saveCalibrationData() async {
    try {
      await _secureStorage.saveValue(
        _calibrationKey,
        DateTime.now().toIso8601String(),
      );
      _lastCalibration = DateTime.now();
    } catch (e) {
      print('Failed to save calibration data: $e');
    }
  }

  /// Perform compass calibration
  Future<bool> calibrateCompass() async {
    try {
      // Provide haptic feedback
      await HapticFeedback.mediumImpact();

      // Clear existing readings
      _magneticReadings.clear();
      _accelerometerReadings.clear();
      _gyroscopeReadings.clear();

      // Wait for new sensor readings
      await Future.delayed(const Duration(seconds: 2));

      // Update quality after calibration
      _updateCalibrationQuality();

      // Save calibration
      await _saveCalibrationData();

      return _calibrationQuality == CalibrationQuality.good ||
          _calibrationQuality == CalibrationQuality.excellent;
    } catch (e) {
      print('Calibration failed: $e');
      return false;
    }
  }

  /// Find nearby mosques with Qibla alignment info
  Future<List<MosqueLocation>> findNearbyMosques({
    double radiusKm = 5.0,
  }) async {
    if (_currentPosition == null) return [];

    try {
      // This would integrate with a mosque database API
      // For now, return mock data with proper Qibla calculations
      return [
        MosqueLocation(
          id: 'mosque_1',
          name: 'Central Mosque',
          latitude: _currentPosition!.latitude + 0.01,
          longitude: _currentPosition!.longitude + 0.01,
          distanceInMeters: 1200,
          qiblaDirection: _qiblaDirection,
          address: '123 Islamic Center St',
          amenities: ['Parking', 'Wudu facilities', 'Islamic library'],
        ),
      ];
    } catch (e) {
      print('Failed to find mosques: $e');
      return [];
    }
  }

  /// Get current compass state
  QiblaCompass? getCurrentCompass() {
    if (_currentPosition == null) return null;

    return QiblaCompass(
      qiblaDirection: _qiblaDirection,
      currentDirection: _currentHeading,
      deviceHeading: _currentHeading,
      accuracy: _getLocationAccuracy(),
      lastUpdated: DateTime.now(),
      isCalibrationNeeded:
          _calibrationQuality == CalibrationQuality.poor ||
          _calibrationQuality == CalibrationQuality.uncalibrated,
      distanceToKaaba: _calculateDistanceToKaaba(),
      calibrationData: _getCalibrationData(),
    );
  }

  /// Dispose service and clean up resources
  void dispose() {
    _magnetometerSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _compassController.close();
  }
}
