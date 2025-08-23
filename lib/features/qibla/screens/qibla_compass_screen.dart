import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/qibla_entity.dart';
import '../providers/qibla_providers.dart';

/// QiblaCompassScreen - Premium Qibla Compass with Prayer Tracking
class QiblaCompassScreen extends ConsumerStatefulWidget {
  const QiblaCompassScreen({super.key});

  @override
  ConsumerState<QiblaCompassScreen> createState() => _QiblaCompassScreenState();
}

class _QiblaCompassScreenState extends ConsumerState<QiblaCompassScreen> with TickerProviderStateMixin {
  late AnimationController _compassController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _compassController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _pulseController = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
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
      appBar: AppBar(
        title: const Text('Qibla Compass'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.settings), onPressed: () => _showSettingsDialog(context))],
      ),
      body: compassInit.when(
        loading:
            () => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Initializing Qibla Compass...')],
              ),
            ),
        error:
            (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text('Error: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () => ref.invalidate(qiblaCompassInitProvider), child: const Text('Retry')),
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
            loading:
                () => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Getting compass data...')],
                  ),
                ),
            error:
                (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.compass_calibration, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text('Compass Error: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: () => _calibrateCompass(), child: const Text('Calibrate Compass')),
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
                  Expanded(child: _buildInfoPanel(compassData, distanceToKaaba, nextPrayer)),

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: needsCalibration ? Colors.orange.shade100 : Colors.green.shade100,
        border: Border(bottom: BorderSide(color: needsCalibration ? Colors.orange : Colors.green, width: 2)),
      ),
      child: Row(
        children: [
          Icon(
            needsCalibration ? Icons.warning : Icons.check_circle,
            color: needsCalibration ? Colors.orange : Colors.green,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              needsCalibration
                  ? 'Compass needs calibration for accuracy'
                  : 'Compass calibrated - ${_getAccuracyText(compass.accuracy)}',
              style: TextStyle(
                color: needsCalibration ? Colors.orange.shade800 : Colors.green.shade800,
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
      margin: const EdgeInsets.all(24),
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
                  colors: [const Color(0xFF2E7D32).withOpacity(0.1), const Color(0xFF1B5E20).withOpacity(0.3)],
                ),
                border: Border.all(color: const Color(0xFF1B5E20), width: 3),
              ),
            ),

            // Direction Markings
            ...List.generate(4, (index) => _buildDirectionMarking(index * 90)),

            // Qibla Direction Indicator
            Transform.rotate(
              angle: (compass.qiblaDirection - compass.deviceHeading) * math.pi / 180,
              child: Container(
                width: 4,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.5), blurRadius: 8, spreadRadius: 2),
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
                    color: const Color(0xFF1B5E20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1B5E20).withOpacity(0.3),
                        blurRadius: 10 + (_pulseController.value * 5),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.mosque, color: Colors.white, size: 32),
                );
              },
            ),

            // Direction Text
            Positioned(
              top: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(16)),
                child: Text(
                  'N',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
          color: const Color(0xFF1B5E20).withOpacity(0.5),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _buildInfoPanel(QiblaCompass compass, double? distance, PrayerCompletion? nextPrayer) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, spreadRadius: 1)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoItem('Qibla Direction', '${compass.qiblaDirection.toInt()}°', Icons.navigation),
              ),
              Expanded(
                child: _buildInfoItem(
                  'Distance to Kaaba',
                  distance != null ? '${distance.toInt()} km' : '---',
                  Icons.place,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (nextPrayer != null) ...[
            const Divider(),
            Row(
              children: [
                const Icon(Icons.schedule, color: Color(0xFF1B5E20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Prayer: ${_getPrayerName(nextPrayer.type)}',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text(_formatTime(nextPrayer.scheduledTime), style: TextStyle(color: Colors.grey.shade600)),
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
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
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
      builder:
          (context) => AlertDialog(
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Finding nearby mosques...'), backgroundColor: Color(0xFF1B5E20)));
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
            actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
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
