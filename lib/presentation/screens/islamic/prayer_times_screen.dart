import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/revolutionary_islamic_theme.dart';
import '../../widgets/revolutionary_components.dart';

class PrayerTimesScreen extends ConsumerStatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  ConsumerState<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends ConsumerState<PrayerTimesScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  bool _isLoading = true;
  String _location = 'Detecting location...';
  List<PrayerTime> _prayerTimes = [];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: RevolutionaryIslamicTheme.animationMedium,
      vsync: this,
    );
    _slideController = AnimationController(
      duration: RevolutionaryIslamicTheme.animationSlow,
      vsync: this,
    );
    _loadPrayerTimes();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadPrayerTimes() async {
    // Simulate loading prayer times
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _location = 'New York, USA'; // Mock location
        _prayerTimes = _getMockPrayerTimes();
        _isLoading = false;
      });
      _fadeController.forward();
      _slideController.forward();
    }
  }

  List<PrayerTime> _getMockPrayerTimes() {
    return [
      PrayerTime('Fajr', '05:30', 'Dawn Prayer', Icons.wb_twilight, false),
      PrayerTime('Dhuhr', '12:45', 'Noon Prayer', Icons.wb_sunny, true),
      PrayerTime(
        'Asr',
        '16:20',
        'Afternoon Prayer',
        Icons.wb_sunny_outlined,
        false,
      ),
      PrayerTime(
        'Maghrib',
        '19:15',
        'Sunset Prayer',
        Icons.wb_twighlight,
        false,
      ),
      PrayerTime(
        'Isha',
        '21:00',
        'Night Prayer',
        Icons.nightlight_round,
        false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RevolutionaryIslamicTheme.backgroundPrimary,
      appBar: RevolutionaryComponents.modernAppBar(
        title: 'Prayer Times',
        showBackButton: true,
        showHamburger: false,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: _isLoading ? _buildLoadingState() : _buildContent(),
      floatingActionButton: !_isLoading ? _buildFloatingActionButton() : null,
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space6),
            decoration: BoxDecoration(
              gradient: RevolutionaryIslamicTheme.heroGradient,
              borderRadius: BorderRadius.circular(
                RevolutionaryIslamicTheme.radius3Xl,
              ),
              boxShadow: RevolutionaryIslamicTheme.shadowLg,
            ),
            child: const Icon(
              Icons.access_time_rounded,
              color: RevolutionaryIslamicTheme.textOnColor,
              size: 48,
            ),
          ),
          const SizedBox(height: RevolutionaryIslamicTheme.space6),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              RevolutionaryIslamicTheme.primaryEmerald,
            ),
          ),
          const SizedBox(height: RevolutionaryIslamicTheme.space4),
          Text(
            'Loading prayer times...',
            style: RevolutionaryIslamicTheme.body1.copyWith(
              color: RevolutionaryIslamicTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() => _isLoading = true);
        await _loadPrayerTimes();
      },
      color: RevolutionaryIslamicTheme.primaryEmerald,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationCard(),
            const SizedBox(height: RevolutionaryIslamicTheme.space6),
            _buildNextPrayerCard(),
            const SizedBox(height: RevolutionaryIslamicTheme.space6),
            _buildPrayerTimesList(),
            const SizedBox(height: RevolutionaryIslamicTheme.space6),
            _buildAdditionalInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return FadeTransition(
      opacity: _fadeController,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space5),
        decoration: BoxDecoration(
          gradient: RevolutionaryIslamicTheme.heroGradient,
          borderRadius: BorderRadius.circular(
            RevolutionaryIslamicTheme.radius3Xl,
          ),
          boxShadow: RevolutionaryIslamicTheme.shadowMd,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space3),
              decoration: BoxDecoration(
                color: RevolutionaryIslamicTheme.textOnColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  RevolutionaryIslamicTheme.radius2Xl,
                ),
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: RevolutionaryIslamicTheme.textOnColor,
                size: 24,
              ),
            ),
            const SizedBox(width: RevolutionaryIslamicTheme.space4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Location',
                    style: RevolutionaryIslamicTheme.body2.copyWith(
                      color: RevolutionaryIslamicTheme.textOnColor
                          .withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: RevolutionaryIslamicTheme.space1),
                  Text(
                    _location,
                    style: RevolutionaryIslamicTheme.subtitle1.copyWith(
                      color: RevolutionaryIslamicTheme.textOnColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _loadPrayerTimes(),
              icon: const Icon(
                Icons.refresh_rounded,
                color: RevolutionaryIslamicTheme.textOnColor,
              ),
              style: IconButton.styleFrom(
                backgroundColor:
                    RevolutionaryIslamicTheme.textOnColor.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextPrayerCard() {
    final nextPrayer = _prayerTimes.firstWhere(
      (prayer) => !prayer.isPassed,
      orElse: () => _prayerTimes.first,
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-0.3, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space5),
        decoration: BoxDecoration(
          color: RevolutionaryIslamicTheme.backgroundSecondary,
          borderRadius: BorderRadius.circular(
            RevolutionaryIslamicTheme.radius3Xl,
          ),
          border: Border.all(color: RevolutionaryIslamicTheme.borderLight),
          boxShadow: RevolutionaryIslamicTheme.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(
                    RevolutionaryIslamicTheme.space2,
                  ),
                  decoration: BoxDecoration(
                    color:
                        RevolutionaryIslamicTheme.accentPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      RevolutionaryIslamicTheme.radiusXl,
                    ),
                  ),
                  child: Icon(
                    nextPrayer.icon,
                    color: RevolutionaryIslamicTheme.accentPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: RevolutionaryIslamicTheme.space3),
                Text(
                  'Next Prayer',
                  style: RevolutionaryIslamicTheme.body2.copyWith(
                    color: RevolutionaryIslamicTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: RevolutionaryIslamicTheme.space2,
                    vertical: RevolutionaryIslamicTheme.space1,
                  ),
                  decoration: BoxDecoration(
                    color:
                        RevolutionaryIslamicTheme.successGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      RevolutionaryIslamicTheme.radiusFull,
                    ),
                  ),
                  child: Text(
                    'In 2h 15m',
                    style: RevolutionaryIslamicTheme.caption.copyWith(
                      color: RevolutionaryIslamicTheme.successGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: RevolutionaryIslamicTheme.space4),
            Text(
              nextPrayer.name,
              style: RevolutionaryIslamicTheme.headline2.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: RevolutionaryIslamicTheme.space1),
            Text(
              nextPrayer.time,
              style: RevolutionaryIslamicTheme.display2.copyWith(
                color: RevolutionaryIslamicTheme.primaryEmerald,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimesList() {
    return FadeTransition(
      opacity: _fadeController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Prayer Schedule',
            style: RevolutionaryIslamicTheme.headline3.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: RevolutionaryIslamicTheme.space4),
          ...(_prayerTimes.asMap().entries.map((entry) {
            final index = entry.key;
            final prayer = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < _prayerTimes.length - 1
                    ? RevolutionaryIslamicTheme.space3
                    : 0,
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.3, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _slideController,
                    curve: Interval(
                      index * 0.1,
                      (index * 0.1) + 0.3,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                ),
                child: _buildPrayerTimeCard(prayer),
              ),
            );
          }).toList()),
        ],
      ),
    );
  }

  Widget _buildPrayerTimeCard(PrayerTime prayer) {
    return Container(
      padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space4),
      decoration: BoxDecoration(
        color: prayer.isPassed
            ? RevolutionaryIslamicTheme.neutralGray100
            : RevolutionaryIslamicTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(
          RevolutionaryIslamicTheme.radius2Xl,
        ),
        border: Border.all(
          color: prayer.isPassed
              ? RevolutionaryIslamicTheme.borderLight
              : RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.3),
        ),
        boxShadow: prayer.isPassed ? [] : RevolutionaryIslamicTheme.shadowXs,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space3),
            decoration: BoxDecoration(
              color: prayer.isPassed
                  ? RevolutionaryIslamicTheme.neutralGray300
                  : RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                RevolutionaryIslamicTheme.radiusXl,
              ),
            ),
            child: Icon(
              prayer.icon,
              color: prayer.isPassed
                  ? RevolutionaryIslamicTheme.textTertiary
                  : RevolutionaryIslamicTheme.primaryEmerald,
              size: 24,
            ),
          ),
          const SizedBox(width: RevolutionaryIslamicTheme.space4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayer.name,
                  style: RevolutionaryIslamicTheme.subtitle1.copyWith(
                    color: prayer.isPassed
                        ? RevolutionaryIslamicTheme.textTertiary
                        : RevolutionaryIslamicTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: RevolutionaryIslamicTheme.space1),
                Text(
                  prayer.description,
                  style: RevolutionaryIslamicTheme.body2.copyWith(
                    color: prayer.isPassed
                        ? RevolutionaryIslamicTheme.textTertiary
                        : RevolutionaryIslamicTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                prayer.time,
                style: RevolutionaryIslamicTheme.headline3.copyWith(
                  color: prayer.isPassed
                      ? RevolutionaryIslamicTheme.textTertiary
                      : RevolutionaryIslamicTheme.primaryEmerald,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (prayer.isPassed)
                Container(
                  margin: const EdgeInsets.only(
                    top: RevolutionaryIslamicTheme.space1,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: RevolutionaryIslamicTheme.space2,
                    vertical: RevolutionaryIslamicTheme.space1,
                  ),
                  decoration: BoxDecoration(
                    color: RevolutionaryIslamicTheme.neutralGray400,
                    borderRadius: BorderRadius.circular(
                      RevolutionaryIslamicTheme.radiusFull,
                    ),
                  ),
                  child: Text(
                    'Completed',
                    style: RevolutionaryIslamicTheme.caption.copyWith(
                      color: RevolutionaryIslamicTheme.textOnColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
      ),
      child: Container(
        padding: const EdgeInsets.all(RevolutionaryIslamicTheme.space5),
        decoration: BoxDecoration(
          color: RevolutionaryIslamicTheme.backgroundSecondary,
          borderRadius: BorderRadius.circular(
            RevolutionaryIslamicTheme.radius3Xl,
          ),
          border: Border.all(color: RevolutionaryIslamicTheme.borderLight),
          boxShadow: RevolutionaryIslamicTheme.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prayer Information',
              style: RevolutionaryIslamicTheme.subtitle1.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: RevolutionaryIslamicTheme.space3),
            _buildInfoRow(Icons.wb_sunny_outlined, 'Sunrise', '06:45 AM'),
            const SizedBox(height: RevolutionaryIslamicTheme.space2),
            _buildInfoRow(Icons.wb_twighlight, 'Sunset', '07:15 PM'),
            const SizedBox(height: RevolutionaryIslamicTheme.space2),
            _buildInfoRow(Icons.timer_outlined, 'Qiyam', '03:30 AM'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String time) {
    return Row(
      children: [
        Icon(icon, size: 20, color: RevolutionaryIslamicTheme.textSecondary),
        const SizedBox(width: RevolutionaryIslamicTheme.space3),
        Expanded(
          child: Text(
            label,
            style: RevolutionaryIslamicTheme.body2.copyWith(
              color: RevolutionaryIslamicTheme.textSecondary,
            ),
          ),
        ),
        Text(
          time,
          style: RevolutionaryIslamicTheme.body2.copyWith(
            color: RevolutionaryIslamicTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        RevolutionaryComponents.showModernSnackBar(
          context: context,
          message: 'Prayer reminder set successfully',
          icon: Icons.notifications_rounded,
        );
      },
      backgroundColor: RevolutionaryIslamicTheme.primaryEmerald,
      foregroundColor: RevolutionaryIslamicTheme.textOnColor,
      icon: const Icon(Icons.notifications_rounded),
      label: const Text('Set Reminders'),
    );
  }
}

class PrayerTime {
  final String name;
  final String time;
  final String description;
  final IconData icon;
  final bool isPassed;

  PrayerTime(this.name, this.time, this.description, this.icon, this.isPassed);
}
