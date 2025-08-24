import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/revolutionary_islamic_theme.dart';
import '../../widgets/revolutionary_components.dart';

class IslamicCalendarScreen extends ConsumerStatefulWidget {
  const IslamicCalendarScreen({super.key});

  @override
  ConsumerState<IslamicCalendarScreen> createState() => _IslamicCalendarScreenState();
}

class _IslamicCalendarScreenState extends ConsumerState<IslamicCalendarScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  DateTime _selectedDate = DateTime.now();
  List<IslamicEvent> _events = [];
  final HijriDate _currentHijriDate = HijriDate.now();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _loadEvents();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _loadEvents() {
    // Mock Islamic events
    _events = [
      IslamicEvent(
        'Ramadan Begins',
        DateTime.now().add(const Duration(days: 30)),
        'The holy month of fasting begins',
        Icons.mosque_rounded,
        Colors.green,
        true,
      ),
      IslamicEvent(
        'Laylat al-Qadr',
        DateTime.now().add(const Duration(days: 57)),
        'The Night of Power - last 10 nights of Ramadan',
        Icons.star_rounded,
        Colors.amber,
        true,
      ),
      IslamicEvent(
        'Eid al-Fitr',
        DateTime.now().add(const Duration(days: 60)),
        'Festival marking the end of Ramadan',
        Icons.celebration_rounded,
        Colors.orange,
        true,
      ),
      IslamicEvent(
        'Eid al-Adha',
        DateTime.now().add(const Duration(days: 130)),
        'Festival of Sacrifice during Hajj',
        Icons.favorite_rounded,
        Colors.red,
        true,
      ),
      IslamicEvent(
        'Day of Arafah',
        DateTime.now().add(const Duration(days: 129)),
        'The most important day of Hajj',
        Icons.landscape_rounded,
        Colors.brown,
        true,
      ),
      IslamicEvent(
        'Islamic New Year',
        DateTime.now().add(const Duration(days: 200)),
        'Beginning of the Hijri calendar year',
        Icons.calendar_today_rounded,
        Colors.blue,
        false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RevolutionaryIslamicTheme.backgroundPrimary,
      appBar: RevolutionaryComponents.modernAppBar(
        title: 'Islamic Calendar',
        showBackButton: true,
        showHamburger: false,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeController,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCurrentDateHeader(),
                const SizedBox(height: 32),
                _buildCalendarView(),
                const SizedBox(height: 32),
                _buildUpcomingEvents(),
                const SizedBox(height: 24),
                _buildIslamicMonths(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentDateHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [RevolutionaryIslamicTheme.primaryEmerald, RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: RevolutionaryIslamicTheme.neutralGray400.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: RevolutionaryIslamicTheme.neutralWhite.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: RevolutionaryIslamicTheme.neutralWhite,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Today\'s Date',
                  style: TextStyle(
                    fontSize: 16,
                    color: RevolutionaryIslamicTheme.neutralWhite,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Gregorian Date
          Text(
            _formatGregorianDate(_selectedDate),
            style: const TextStyle(
              fontSize: 24,
              color: RevolutionaryIslamicTheme.neutralWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),

          // Hijri Date
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: RevolutionaryIslamicTheme.neutralWhite.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mosque_rounded, color: RevolutionaryIslamicTheme.neutralWhite, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${_currentHijriDate.day} ${_currentHijriDate.monthName} ${_currentHijriDate.year} AH',
                  style: const TextStyle(
                    fontSize: 16,
                    color: RevolutionaryIslamicTheme.neutralWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Calendar View',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: RevolutionaryIslamicTheme.textPrimary),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: RevolutionaryIslamicTheme.backgroundSecondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: RevolutionaryIslamicTheme.borderLight),
            boxShadow: [
              BoxShadow(
                color: RevolutionaryIslamicTheme.neutralGray300.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Month/Year Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => _previousMonth(),
                    icon: const Icon(Icons.chevron_left_rounded),
                    color: RevolutionaryIslamicTheme.primaryEmerald,
                  ),
                  Text(
                    _formatMonthYear(_selectedDate),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: RevolutionaryIslamicTheme.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _nextMonth(),
                    icon: const Icon(Icons.chevron_right_rounded),
                    color: RevolutionaryIslamicTheme.primaryEmerald,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Simplified calendar grid
              _buildMiniCalendar(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniCalendar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Day headers
          Row(
            children:
                ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                    .map(
                      (day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: RevolutionaryIslamicTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 8),

          // Simplified calendar days (just show current week)
          for (int week = 0; week < 2; week++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: List.generate(7, (dayIndex) {
                  final dayNum = (week * 7) + dayIndex + 1;
                  final isToday = dayNum == DateTime.now().day;
                  final hasEvent = dayNum <= 30 && (dayNum % 5 == 0); // Mock events

                  return Expanded(
                    child: Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color:
                              isToday
                                  ? RevolutionaryIslamicTheme.primaryEmerald
                                  : hasEvent
                                  ? RevolutionaryIslamicTheme.secondaryNavy.withOpacity(0.2)
                                  : null,
                          borderRadius: BorderRadius.circular(16),
                          border:
                              hasEvent && !isToday ? Border.all(color: RevolutionaryIslamicTheme.secondaryNavy) : null,
                        ),
                        child: Center(
                          child: Text(
                            dayNum <= 31 ? dayNum.toString() : '',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  isToday
                                      ? RevolutionaryIslamicTheme.neutralWhite
                                      : RevolutionaryIslamicTheme.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    final upcomingEvents = _events.where((event) => event.date.isAfter(DateTime.now())).take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Islamic Events',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: RevolutionaryIslamicTheme.textPrimary),
        ),
        const SizedBox(height: 16),

        ...upcomingEvents.map((event) => _buildEventCard(event)),
      ],
    );
  }

  Widget _buildEventCard(IslamicEvent event) {
    final daysUntil = event.date.difference(DateTime.now()).inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RevolutionaryIslamicTheme.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: event.isImportant ? event.color.withOpacity(0.3) : RevolutionaryIslamicTheme.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: RevolutionaryIslamicTheme.neutralGray300.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: event.color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(event.icon, color: event.color, size: 24),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: RevolutionaryIslamicTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.description,
                  style: const TextStyle(fontSize: 13, color: RevolutionaryIslamicTheme.textSecondary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded, size: 14, color: RevolutionaryIslamicTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      daysUntil == 0
                          ? 'Today'
                          : daysUntil == 1
                          ? 'Tomorrow'
                          : 'in $daysUntil days',
                      style: const TextStyle(
                        fontSize: 12,
                        color: RevolutionaryIslamicTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (event.isImportant)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: event.color, borderRadius: BorderRadius.circular(8)),
              child: const Text(
                'IMPORTANT',
                style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIslamicMonths() {
    final islamicMonths = [
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Islamic Months',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: RevolutionaryIslamicTheme.textPrimary),
        ),
        const SizedBox(height: 16),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: islamicMonths.length,
          itemBuilder: (context, index) {
            final month = islamicMonths[index];
            final isCurrentMonth = index + 1 == _currentHijriDate.month;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isCurrentMonth
                        ? RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.1)
                        : RevolutionaryIslamicTheme.backgroundSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isCurrentMonth
                          ? RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.3)
                          : RevolutionaryIslamicTheme.borderLight,
                ),
              ),
              child: Center(
                child: Text(
                  month,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isCurrentMonth ? FontWeight.w600 : FontWeight.w500,
                    color:
                        isCurrentMonth
                            ? RevolutionaryIslamicTheme.primaryEmerald
                            : RevolutionaryIslamicTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatGregorianDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }

  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
    });
  }
}

class IslamicEvent {
  final String title;
  final DateTime date;
  final String description;
  final IconData icon;
  final Color color;
  final bool isImportant;

  IslamicEvent(this.title, this.date, this.description, this.icon, this.color, this.isImportant);
}

class HijriDate {
  final int day;
  final int month;
  final int year;
  final String monthName;

  HijriDate(this.day, this.month, this.year, this.monthName);

  static HijriDate now() {
    // Mock Hijri date calculation
    const islamicMonths = [
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

    // Simplified mock conversion (in real app, use proper Islamic calendar library)
    return HijriDate(15, 8, 1445, islamicMonths[7]); // Mock current Hijri date
  }
}
