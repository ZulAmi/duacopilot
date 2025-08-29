import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/revolutionary_islamic_theme.dart';
import '../../../domain/entities/tasbih_entity.dart';
import '../../../presentation/widgets/revolutionary_components.dart';
import '../providers/tasbih_providers.dart';

/// DigitalTasbihScreen - Premium Digital Tasbih with Voice Recognition
class DigitalTasbihScreen extends ConsumerStatefulWidget {
  const DigitalTasbihScreen({super.key});

  @override
  ConsumerState<DigitalTasbihScreen> createState() =>
      _DigitalTasbihScreenState();
}

class _DigitalTasbihScreenState extends ConsumerState<DigitalTasbihScreen>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late AnimationController _countController;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _countController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _countController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasbihInit = ref.watch(tasbihInitProvider);
    final currentSession = ref.watch(currentSessionProvider);
    final currentCount = ref.watch(currentCountProvider);
    final targetCount = ref.watch(targetCountProvider);
    final sessionProgress = ref.watch(sessionProgressProvider);
    final isActive = ref.watch(isSessionActiveProvider);
    final dhikrText = ref.watch(currentDhikrTextProvider);

    // Update progress animation when count changes
    ref.listen(currentCountProvider, (previous, next) {
      if (previous != null && next > previous) {
        _rippleController.forward().then((_) => _rippleController.reset());
        _countController.forward().then((_) => _countController.reset());
      }
    });

    // Update progress bar
    ref.listen(sessionProgressProvider, (previous, next) {
      _progressController.animateTo(next);
    });

    return Scaffold(
      appBar: RevolutionaryComponents.modernAppBar(
        title: 'Digital Tasbih',
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
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
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => _showStatsDialog(context),
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
      body: tasbihInit.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing Digital Tasbih...'),
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
                onPressed: () => ref.invalidate(tasbihInitProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (initialized) {
          return Column(
            children: [
              // Header with progress
              _buildHeader(
                currentCount,
                targetCount,
                sessionProgress,
                isActive,
              ),

              // Main counter area
              Expanded(
                flex: 3,
                child: _buildCounterArea(dhikrText, currentCount, isActive),
              ),

              // Dhikr text display
              _buildDhikrDisplay(dhikrText),

              // Quick actions
              if (!isActive) _buildQuickActions(),

              // Action buttons
              _buildActionButtons(isActive, currentSession),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    int currentCount,
    int targetCount,
    double progress,
    bool isActive,
  ) {
    return Container(
      padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space5),
      decoration: BoxDecoration(
        gradient: RevolutionaryIslamicTheme.heroGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(RevolutionaryIslamicTheme.radius3Xl),
          bottomRight: Radius.circular(RevolutionaryIslamicTheme.radius3Xl),
        ),
      ),
      child: Column(
        children: [
          Text(
            '$currentCount / $targetCount',
            style: RevolutionaryIslamicTheme.headline1.copyWith(
              color: RevolutionaryIslamicTheme.textOnColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: RevolutionaryIslamicTheme.space3),
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _progressController.value,
                backgroundColor:
                    RevolutionaryIslamicTheme.textOnColor.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  RevolutionaryIslamicTheme.textOnColor,
                ),
                minHeight: 6,
                borderRadius: BorderRadius.circular(
                  RevolutionaryIslamicTheme.radiusSm,
                ),
              );
            },
          ),
          const SizedBox(height: RevolutionaryIslamicTheme.space2),
          Text(
            '${(progress * 100).toInt()}% Complete',
            style: RevolutionaryIslamicTheme.body1.copyWith(
              color: RevolutionaryIslamicTheme.textOnColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterArea(String dhikrText, int currentCount, bool isActive) {
    return Container(
      margin: const EdgeInsets.all(RevolutionaryIslamicTheme.space6),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ripple effect
          AnimatedBuilder(
            animation: _rippleController,
            builder: (context, child) {
              return Container(
                width: 300 + (_rippleController.value * 50),
                height: 300 + (_rippleController.value * 50),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 
                      1 - _rippleController.value,
                    ),
                    width: 3,
                  ),
                ),
              );
            },
          ),

          // Main counter button
          GestureDetector(
            onTap: isActive ? _incrementCount : null,
            child: AnimatedBuilder(
              animation: _countController,
              builder: (context, child) {
                final scale = 1.0 + (_countController.value * 0.1);
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 
                            0.1,
                          ),
                          RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 
                            0.3,
                          ),
                        ],
                      ),
                      border: Border.all(
                        color: RevolutionaryIslamicTheme.primaryEmerald,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: RevolutionaryIslamicTheme.primaryEmerald
                              .withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$currentCount',
                            style: RevolutionaryIslamicTheme.display1.copyWith(
                              color: RevolutionaryIslamicTheme.primaryEmerald,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!isActive)
                            Text(
                              'Tap to start',
                              style: RevolutionaryIslamicTheme.body2.copyWith(
                                color: RevolutionaryIslamicTheme.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDhikrDisplay(String dhikrText) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: RevolutionaryIslamicTheme.space6,
      ),
      padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space5),
      decoration: BoxDecoration(
        color: RevolutionaryIslamicTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(
          RevolutionaryIslamicTheme.radius2Xl,
        ),
        boxShadow: RevolutionaryIslamicTheme.shadowMd,
        border: Border.all(
          color: RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          dhikrText,
          style: RevolutionaryIslamicTheme.headline2.copyWith(
            color: RevolutionaryIslamicTheme.primaryEmerald,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final quickTasbih = ref.watch(quickTasbihProvider);

    return Container(
      margin: const EdgeInsets.all(16),
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: quickTasbih.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final entry = quickTasbih.entries.elementAt(index);
          return _buildQuickActionButton(entry.key, entry.value);
        },
      ),
    );
  }

  Widget _buildQuickActionButton(TasbihType type, String text) {
    return GestureDetector(
      onTap: () => _startQuickSession(type),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(
            RevolutionaryIslamicTheme.radiusXl,
          ),
          border: Border.all(
            color: RevolutionaryIslamicTheme.primaryEmerald.withValues(alpha: 0.3),
          ),
          boxShadow: RevolutionaryIslamicTheme.shadowSm,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: RevolutionaryIslamicTheme.subtitle1.copyWith(
                color: RevolutionaryIslamicTheme.primaryEmerald,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: RevolutionaryIslamicTheme.space1),
            Text(
              _getTasbihTypeName(type),
              style: RevolutionaryIslamicTheme.caption.copyWith(
                color: RevolutionaryIslamicTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isActive, TasbihSession? session) {
    return Container(
      padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space4),
      child: Row(
        children: [
          if (isActive) ...[
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _endSession,
                icon: const Icon(Icons.stop_rounded),
                label: const Text('End Session'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RevolutionaryIslamicTheme.errorRose,
                  foregroundColor: RevolutionaryIslamicTheme.textOnColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: RevolutionaryIslamicTheme.space3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      RevolutionaryIslamicTheme.radiusXl,
                    ),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(width: RevolutionaryIslamicTheme.space3),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _showSessionDetails,
                icon: const Icon(Icons.info_outline_rounded),
                label: const Text('Details'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RevolutionaryIslamicTheme.primaryEmerald,
                  foregroundColor: RevolutionaryIslamicTheme.textOnColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: RevolutionaryIslamicTheme.space3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      RevolutionaryIslamicTheme.radiusXl,
                    ),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _showStartDialog,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Start Session'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RevolutionaryIslamicTheme.primaryEmerald,
                  foregroundColor: RevolutionaryIslamicTheme.textOnColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: RevolutionaryIslamicTheme.space3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      RevolutionaryIslamicTheme.radiusXl,
                    ),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _incrementCount() async {
    final sessionNotifier = ref.read(tasbihSessionProvider.notifier);
    await sessionNotifier.addCount();
  }

  void _startQuickSession(TasbihType type) async {
    final sessionNotifier = ref.read(tasbihSessionProvider.notifier);
    await sessionNotifier.startSession(type: type, targetCount: 33);
  }

  void _endSession() async {
    final sessionNotifier = ref.read(tasbihSessionProvider.notifier);
    await sessionNotifier.endSession();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Session completed! Well done.'),
        backgroundColor: RevolutionaryIslamicTheme.primaryEmerald,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            RevolutionaryIslamicTheme.radiusLg,
          ),
        ),
      ),
    );
  }

  void _showStartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Tasbih Session'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select dhikr type and target count:'),
            const SizedBox(height: 16),
            DropdownButtonFormField<TasbihType>(
              decoration: const InputDecoration(
                labelText: 'Dhikr Type',
                border: OutlineInputBorder(),
              ),
              items: TasbihType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getTasbihTypeName(type)),
                );
              }).toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Target Count',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              initialValue: '33',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startQuickSession(TasbihType.subhanallah);
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  void _showSessionDetails() {
    final session = ref.read(currentSessionProvider);
    if (session == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Session Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Duration'),
              subtitle: Text(
                _formatDuration(
                  DateTime.now().difference(session.startTime),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text('Progress'),
              subtitle: Text(
                '${session.currentCount}/${session.targetCount}',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.touch_app),
              title: const Text('Input Method'),
              subtitle: const Text('Touch'),
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

  void _showSettingsDialog(BuildContext context) {
    final settings = ref.watch(tasbihSettingsProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tasbih Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Haptic Feedback'),
              value: settings?.hapticFeedback ?? true,
              onChanged: (value) {
                // Update settings
              },
            ),
            SwitchListTile(
              title: const Text('Sound Feedback'),
              value: settings?.soundFeedback ?? false,
              onChanged: (value) {
                // Update settings
              },
            ),
            SwitchListTile(
              title: const Text('Voice Recognition'),
              value: settings?.voiceRecognition ?? false,
              onChanged: (value) {
                // Update settings
              },
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

  void _showStatsDialog(BuildContext context) {
    final totalSessions = ref.watch(totalSessionsProvider);
    final totalCount = ref.watch(totalCountProvider);
    final totalTime = ref.watch(totalTimeProvider);
    final currentStreak = ref.watch(currentStreakProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tasbih Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Total Sessions'),
              subtitle: Text('$totalSessions'),
            ),
            ListTile(
              leading: const Icon(Icons.format_list_numbered),
              title: const Text('Total Count'),
              subtitle: Text('$totalCount'),
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Total Time'),
              subtitle: Text(_formatDuration(totalTime)),
            ),
            ListTile(
              leading: const Icon(Icons.local_fire_department),
              title: const Text('Current Streak'),
              subtitle: Text('$currentStreak days'),
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

  String _getTasbihTypeName(TasbihType type) {
    switch (type) {
      case TasbihType.subhanallah:
        return 'SubhanAllah';
      case TasbihType.alhamdulillah:
        return 'Alhamdulillah';
      case TasbihType.allahuakbar:
        return 'Allahu Akbar';
      case TasbihType.lailahaillallah:
        return 'La ilaha illallah';
      case TasbihType.astaghfirullah:
        return 'Astaghfirullah';
      default:
        return 'Custom';
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}

