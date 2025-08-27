import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/revolutionary_islamic_theme.dart';
import '../../../domain/entities/qibla_entity.dart';
import '../../../presentation/widgets/revolutionary_components.dart';
import '../providers/qibla_providers.dart';

/// QiblaCompassScreen - Premium Qibla Compass with Prayer Tracking
class QiblaCompassScreen extends ConsumerStatefulWidget {
  const QiblaCompassScreen({super.key});

  @override
  ConsumerState<QiblaCompassScreen> createState() => _QiblaCompassScreenState();
}

class _QiblaCompassScreenState extends ConsumerState<QiblaCompassScreen>
    with TickerProviderStateMixin {
  late AnimationController _compassController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _compassController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _compassController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compassInit = ref.watch(qiblaCompassInitProvider);
    final compass = ref.watch(qiblaCompassProvider);
    final needsCalibration = ref.watch(needsCalibrationProvider);
    final distanceToKaaba = ref.watch(distanceToKaabaProvider);
    final nextPrayer = ref.watch(nextPrayerProvider);

    return Scaffold(
      appBar: RevolutionaryComponents.modernAppBar(
        title: 'Qibla Compass',
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => _showSettingsDialog(context),
            style: IconButton.styleFrom(
              backgroundColor: RevolutionaryIslamicTheme.neutralGray100,
              foregroundColor: RevolutionaryIslamicTheme.textSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  RevolutionaryIslamicTheme.radiusXl,
                ),
              ),
            ),
          ),
          const SizedBox(width: RevolutionaryIslamicTheme.space2),
        ],
      ),
      body: compassInit.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing Qibla Compass...'),
            ],
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(qiblaCompassInitProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (initialized) {
          if (!initialized) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, color: Colors.orange, size: 48),
                  SizedBox(height: 16),
                  Text('Location permission required'),
                  Text('Please enable location services'),
                ],
              ),
            );
          }

          return compass.when(
            loading: () => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Getting compass data...'),
                ],
              ),
            ),
            error: (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.compass_calibration,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text('Compass Error: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _calibrateCompass(),
                    child: const Text('Calibrate Compass'),
                  ),
                ],
              ),
            ),
            data: (compassData) {
              if (compassData == null) {
                return const Center(child: Text('No compass data available'));
              }

              return Column(
                children: [
                  // Status Bar
                  _buildStatusBar(compassData, needsCalibration),

                  // Main Compass
                  Expanded(flex: 3, child: _buildCompass(compassData)),

                  // Info Panel
                  Expanded(
                    child: _buildInfoPanel(
                      compassData,
                      distanceToKaaba,
                      nextPrayer,
                    ),
                  ),

                  // Action Buttons
                  _buildActionButtons(needsCalibration),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusBar(QiblaCompass compass, bool needsCalibration) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space4),
      decoration: BoxDecoration(
        color: needsCalibration
            ? RevolutionaryIslamicTheme.warningAmber.withOpacity(0.1)
            : RevolutionaryIslamicTheme.successGreen.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: needsCalibration
                ? RevolutionaryIslamicTheme.warningAmber
                : RevolutionaryIslamicTheme.successGreen,
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            needsCalibration
                ? Icons.warning_rounded
                : Icons.check_circle_rounded,
            color: needsCalibration
                ? RevolutionaryIslamicTheme.warningAmber
                : RevolutionaryIslamicTheme.successGreen,
          ),
          const SizedBox(width: RevolutionaryIslamicTheme.space2),
          Expanded(
            child: Text(
              needsCalibration
                  ? 'Compass needs calibration for accuracy'
                  : 'Compass calibrated - ${_getAccuracyText(compass.accuracy)}',
              style: RevolutionaryIslamicTheme.body1.copyWith(
                color: needsCalibration
                    ? RevolutionaryIslamicTheme.warningAmber
                    : RevolutionaryIslamicTheme.successGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompass(QiblaCompass compass) {
    return Container(
      margin: const EdgeInsets.all(RevolutionaryIslamicTheme.space6),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Compass Background
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.1),
                    RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.3),
                  ],
                ),
                border: Border.all(
                  color: RevolutionaryIslamicTheme.primaryEmerald,
                  width: 3,
                ),
                boxShadow: RevolutionaryIslamicTheme.shadowLg,
              ),
            ),

            // Direction Markings
            ...List.generate(4, (index) => _buildDirectionMarking(index * 90)),

            // Qibla Direction Indicator
            Transform.rotate(
              angle: (compass.qiblaDirection - compass.deviceHeading) *
                  math.pi /
                  180,
              child: Container(
                width: 4,
                height: 120,
                decoration: BoxDecoration(
                  color: RevolutionaryIslamicTheme.successGreen,
                  borderRadius: BorderRadius.circular(
                    RevolutionaryIslamicTheme.radiusXs,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: RevolutionaryIslamicTheme.successGreen
                          .withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),

            // Kaaba Icon at center
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 60 + (_pulseController.value * 10),
                  height: 60 + (_pulseController.value * 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: RevolutionaryIslamicTheme.primaryEmerald,
                    boxShadow: [
                      BoxShadow(
                        color: RevolutionaryIslamicTheme.primaryEmerald
                            .withOpacity(0.3),
                        blurRadius: 10 + (_pulseController.value * 5),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.mosque_rounded,
                    color: RevolutionaryIslamicTheme.textOnColor,
                    size: 32,
                  ),
                );
              },
            ),

            // Direction Text
            Positioned(
              top: RevolutionaryIslamicTheme.space5,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: RevolutionaryIslamicTheme.space3,
                  vertical: RevolutionaryIslamicTheme.space2,
                ),
                decoration: BoxDecoration(
                  color: RevolutionaryIslamicTheme.primaryEmerald,
                  borderRadius: BorderRadius.circular(
                    RevolutionaryIslamicTheme.radius2Xl,
                  ),
                ),
                child: Text(
                  'N',
                  style: RevolutionaryIslamicTheme.subtitle1.copyWith(
                    color: RevolutionaryIslamicTheme.textOnColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionMarking(double angle) {
    return Transform.rotate(
      angle: angle * math.pi / 180,
      child: Container(
        width: 2,
        height: 30,
        margin: const EdgeInsets.only(bottom: 140),
        decoration: BoxDecoration(
          color: RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.5),
          borderRadius: BorderRadius.circular(
            RevolutionaryIslamicTheme.radiusXs,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPanel(
    QiblaCompass compass,
    double? distance,
    PrayerCompletion? nextPrayer,
  ) {
    return Container(
      margin: const EdgeInsets.all(RevolutionaryIslamicTheme.space4),
      padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space4),
      decoration: BoxDecoration(
        color: RevolutionaryIslamicTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(RevolutionaryIslamicTheme.radiusXl),
        boxShadow: RevolutionaryIslamicTheme.shadowMd,
        border: Border.all(
          color: RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Qibla Direction',
                  '${compass.qiblaDirection.toInt()}Â°',
                  Icons.navigation_rounded,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  'Distance to Kaaba',
                  distance != null ? '${distance.toInt()} km' : '---',
                  Icons.place_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: RevolutionaryIslamicTheme.space4),
          if (nextPrayer != null) ...[
            Divider(color: RevolutionaryIslamicTheme.borderLight),
            Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  color: RevolutionaryIslamicTheme.primaryEmerald,
                ),
                const SizedBox(width: RevolutionaryIslamicTheme.space2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Prayer: ${_getPrayerName(nextPrayer.type)}',
                        style: RevolutionaryIslamicTheme.subtitle1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _formatTime(nextPrayer.scheduledTime),
                        style: RevolutionaryIslamicTheme.body2.copyWith(
                          color: RevolutionaryIslamicTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1B5E20), size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool needsCalibration) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (needsCalibration) ...[
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _calibrateCompass,
                icon: const Icon(Icons.compass_calibration),
                label: const Text('Calibrate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _findNearbyMosques,
              icon: const Icon(Icons.mosque),
              label: const Text('Find Mosques'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _calibrateCompass() async {
    final calibrationNotifier = ref.read(compassCalibrationProvider.notifier);

    // Show calibration dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.compass_calibration, color: Color(0xFF1B5E20)),
            SizedBox(width: 8),
            Text('Compass Calibration'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Move your phone in a figure-8 pattern'),
            Text('to calibrate the compass sensors.'),
          ],
        ),
      ),
    );

    // Perform calibration
    await calibrationNotifier.calibrateCompass();

    // Close dialog
    if (mounted) Navigator.of(context).pop();
  }

  void _findNearbyMosques() {
    // Navigate to nearby mosques screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Finding nearby mosques...'),
        backgroundColor: Color(0xFF1B5E20),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Compass Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.vibration),
              title: Text('Haptic Feedback'),
              trailing: Switch(value: true, onChanged: null),
            ),
            ListTile(
              leading: Icon(Icons.volume_up),
              title: Text('Sound Alerts'),
              trailing: Switch(value: false, onChanged: null),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _getAccuracyText(LocationAccuracy accuracy) {
    switch (accuracy) {
      case LocationAccuracy.high:
        return 'High Accuracy';
      case LocationAccuracy.medium:
        return 'Medium Accuracy';
      case LocationAccuracy.low:
        return 'Low Accuracy';
      case LocationAccuracy.unavailable:
        return 'Location Unavailable';
    }
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

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
