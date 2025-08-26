import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/revolutionary_islamic_theme.dart';
import '../../widgets/revolutionary_components.dart';

class IslamicCalendarScreen extends ConsumerStatefulWidget {
  const IslamicCalendarScreen({super.key});

  @override
  ConsumerState<IslamicCalendarScreen> createState() =>
      _IslamicCalendarScreenState();
}

class _IslamicCalendarScreenState extends ConsumerState<IslamicCalendarScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  DateTime _selectedDate = DateTime.now();
  List<IslamicEvent> _events = [];
  final HijriDate _currentHijriDate = HijriDate.now();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _loadEvents();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _loadEvents() {
    // Enhanced Islamic events with more dates throughout the year
    final now = DateTime.now();
    _events = [
      // Current month events
      IslamicEvent(
        'Friday Prayer',
        DateTime(now.year, now.month, _getNextFriday(now)),
        'Weekly congregational prayer',
        Icons.mosque_rounded,
        Colors.green,
        false,
      ),
      IslamicEvent(
        'Islamic Study Circle',
        DateTime(now.year, now.month, now.day + 3),
        'Community learning session',
        Icons.book_rounded,
        Colors.blue,
        false,
      ),
      IslamicEvent(
        'Charity Drive',
        DateTime(now.year, now.month, now.day + 7),
        'Monthly community outreach',
        Icons.favorite_rounded,
        Colors.orange,
        false,
      ),

      // Major Islamic events
      IslamicEvent(
        'Ramadan Begins',
        DateTime(now.year, 3, 10), // Approximate date
        'The holy month of fasting begins',
        Icons.mosque_rounded,
        Colors.green,
        true,
      ),
      IslamicEvent(
        'Laylat al-Qadr',
        DateTime(now.year, 4, 6), // Approximate date
        'The Night of Power - last 10 nights of Ramadan',
        Icons.star_rounded,
        Colors.amber,
        true,
      ),
      IslamicEvent(
        'Eid al-Fitr',
        DateTime(now.year, 4, 9), // Approximate date
        'Festival marking the end of Ramadan',
        Icons.celebration_rounded,
        Colors.orange,
        true,
      ),
      IslamicEvent(
        'Day of Arafah',
        DateTime(now.year, 6, 15), // Approximate date
        'The most important day of Hajj',
        Icons.landscape_rounded,
        Colors.brown,
        true,
      ),
      IslamicEvent(
        'Eid al-Adha',
        DateTime(now.year, 6, 16), // Approximate date
        'Festival of Sacrifice during Hajj',
        Icons.favorite_rounded,
        Colors.red,
        true,
      ),
      IslamicEvent(
        'Islamic New Year',
        DateTime(now.year, 7, 17), // Approximate date
        'Beginning of the Hijri calendar year',
        Icons.calendar_today_rounded,
        Colors.blue,
        false,
      ),
      IslamicEvent(
        'Day of Ashura',
        DateTime(now.year, 7, 27), // Approximate date
        '10th day of Muharram - day of fasting',
        Icons.water_drop_rounded,
        Colors.purple,
        true,
      ),
      IslamicEvent(
        'Mawlid an-Nabi',
        DateTime(now.year, 9, 15), // Approximate date
        'Birthday of Prophet Muhammad (PBUH)',
        Icons.auto_stories_rounded,
        Colors.teal,
        true,
      ),
    ];
  }

  int _getNextFriday(DateTime date) {
    final daysUntilFriday = (5 - date.weekday) % 7;
    final nextFriday = date.add(
      Duration(days: daysUntilFriday == 0 ? 7 : daysUntilFriday),
    );
    return nextFriday.day;
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
          colors: [
            RevolutionaryIslamicTheme.primaryEmerald,
            RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.8),
          ],
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
                  color: RevolutionaryIslamicTheme.neutralWhite.withOpacity(
                    0.2,
                  ),
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
                const Icon(
                  Icons.mosque_rounded,
                  color: RevolutionaryIslamicTheme.neutralWhite,
                  size: 16,
                ),
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
        Row(
          children: [
            const Text(
              'Calendar View',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: RevolutionaryIslamicTheme.textPrimary,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: RevolutionaryIslamicTheme.primaryEmerald.withOpacity(
                  0.1,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: RevolutionaryIslamicTheme.primaryEmerald.withOpacity(
                    0.3,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.event_available_rounded,
                    size: 16,
                    color: RevolutionaryIslamicTheme.primaryEmerald,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_getEventsInMonth()} events',
                    style: const TextStyle(
                      fontSize: 12,
                      color: RevolutionaryIslamicTheme.primaryEmerald,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                color: RevolutionaryIslamicTheme.neutralGray300.withOpacity(
                  0.5,
                ),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Enhanced Month/Year Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    // Previous month button
                    Container(
                      decoration: BoxDecoration(
                        color: RevolutionaryIslamicTheme.primaryEmerald
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () => _previousMonth(),
                        icon: const Icon(Icons.chevron_left_rounded),
                        color: RevolutionaryIslamicTheme.primaryEmerald,
                        iconSize: 24,
                      ),
                    ),

                    // Month/Year display
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showMonthYearPicker(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            children: [
                              Text(
                                _formatMonthYear(_selectedDate),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: RevolutionaryIslamicTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_currentHijriDate.monthName} ${_currentHijriDate.year} AH',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color:
                                      RevolutionaryIslamicTheme.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Next month button
                    Container(
                      decoration: BoxDecoration(
                        color: RevolutionaryIslamicTheme.primaryEmerald
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () => _nextMonth(),
                        icon: const Icon(Icons.chevron_right_rounded),
                        color: RevolutionaryIslamicTheme.primaryEmerald,
                        iconSize: 24,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: RevolutionaryIslamicTheme.borderLight),
              const SizedBox(height: 8),

              // Full calendar grid
              _buildMiniCalendar(),

              // Calendar legend
              const SizedBox(height: 16),
              _buildCalendarLegend(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniCalendar() {
    final firstDayOfMonth = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _selectedDate.year,
      _selectedDate.month + 1,
      0,
    );
    final firstDayWeekday =
        firstDayOfMonth.weekday % 7; // Adjust for Sunday = 0
    final daysInMonth = lastDayOfMonth.day;

    // Calculate total cells needed (6 weeks max)
    final totalCells = ((daysInMonth + firstDayWeekday - 1) ~/ 7 + 1) * 7;
    final weeksToShow = (totalCells / 7).ceil();

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
          const SizedBox(height: 12),

          // Full calendar grid
          for (int week = 0; week < weeksToShow; week++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: List.generate(7, (dayIndex) {
                  final cellIndex = (week * 7) + dayIndex;
                  final dayNum = cellIndex - firstDayWeekday + 1;

                  // Check if this cell should show a day from current month
                  final isValidDay = dayNum > 0 && dayNum <= daysInMonth;
                  final cellDate =
                      isValidDay
                          ? DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            dayNum,
                          )
                          : null;

                  // Check states
                  final isToday =
                      cellDate != null &&
                      cellDate.year == DateTime.now().year &&
                      cellDate.month == DateTime.now().month &&
                      cellDate.day == DateTime.now().day;
                  final isSelected =
                      cellDate != null &&
                      cellDate.year == _selectedDate.year &&
                      cellDate.month == _selectedDate.month &&
                      cellDate.day == _selectedDate.day;
                  final hasEvent = isValidDay && _hasEventOnDay(dayNum);

                  // Previous/next month days
                  final isPrevMonth = dayNum <= 0;
                  final isNextMonth = dayNum > daysInMonth;

                  String displayText = '';
                  if (isPrevMonth) {
                    final prevMonth = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      0,
                    );
                    displayText = (prevMonth.day + dayNum).toString();
                  } else if (isNextMonth) {
                    displayText = (dayNum - daysInMonth).toString();
                  } else if (isValidDay) {
                    displayText = dayNum.toString();
                  }

                  return Expanded(
                    child: GestureDetector(
                      onTap:
                          isValidDay ? () => _onDateSelected(cellDate!) : null,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color:
                                isToday
                                    ? RevolutionaryIslamicTheme.primaryEmerald
                                    : isSelected
                                    ? RevolutionaryIslamicTheme.primaryEmerald
                                        .withOpacity(0.3)
                                    : hasEvent
                                    ? RevolutionaryIslamicTheme.secondaryNavy
                                        .withOpacity(0.15)
                                    : null,
                            borderRadius: BorderRadius.circular(18),
                            border:
                                hasEvent && !isToday && !isSelected
                                    ? Border.all(
                                      color: RevolutionaryIslamicTheme
                                          .secondaryNavy
                                          .withOpacity(0.4),
                                      width: 1,
                                    )
                                    : isSelected && !isToday
                                    ? Border.all(
                                      color:
                                          RevolutionaryIslamicTheme
                                              .primaryEmerald,
                                      width: 2,
                                    )
                                    : null,
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  displayText,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        isToday || isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                    color:
                                        isToday
                                            ? RevolutionaryIslamicTheme
                                                .neutralWhite
                                            : (isPrevMonth || isNextMonth)
                                            ? RevolutionaryIslamicTheme
                                                .textSecondary
                                                .withOpacity(0.4)
                                            : isSelected
                                            ? RevolutionaryIslamicTheme
                                                .primaryEmerald
                                            : RevolutionaryIslamicTheme
                                                .textPrimary,
                                  ),
                                ),
                              ),
                              // Event indicator dot
                              if (hasEvent && !isToday)
                                Positioned(
                                  bottom: 4,
                                  right: 0,
                                  left: 0,
                                  child: Center(
                                    child: Container(
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? RevolutionaryIslamicTheme
                                                    .primaryEmerald
                                                : RevolutionaryIslamicTheme
                                                    .secondaryNavy,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
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
    final upcomingEvents =
        _events
            .where((event) => event.date.isAfter(DateTime.now()))
            .take(5)
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Islamic Events',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: RevolutionaryIslamicTheme.textPrimary,
          ),
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
          color:
              event.isImportant
                  ? event.color.withOpacity(0.3)
                  : RevolutionaryIslamicTheme.borderLight,
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
            decoration: BoxDecoration(
              color: event.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
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
                  style: const TextStyle(
                    fontSize: 13,
                    color: RevolutionaryIslamicTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: RevolutionaryIslamicTheme.textSecondary,
                    ),
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
              decoration: BoxDecoration(
                color: event.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'IMPORTANT',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: RevolutionaryIslamicTheme.textPrimary,
          ),
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
                        ? RevolutionaryIslamicTheme.primaryEmerald.withOpacity(
                          0.1,
                        )
                        : RevolutionaryIslamicTheme.backgroundSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isCurrentMonth
                          ? RevolutionaryIslamicTheme.primaryEmerald
                              .withOpacity(0.3)
                          : RevolutionaryIslamicTheme.borderLight,
                ),
              ),
              child: Center(
                child: Text(
                  month,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isCurrentMonth ? FontWeight.w600 : FontWeight.w500,
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

    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

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

  bool _hasEventOnDay(int day) {
    final targetDate = DateTime(_selectedDate.year, _selectedDate.month, day);
    return _events.any(
      (event) =>
          event.date.year == targetDate.year &&
          event.date.month == targetDate.month &&
          event.date.day == targetDate.day,
    );
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });

    // Show events for selected date if any
    final dayEvents =
        _events
            .where(
              (event) =>
                  event.date.year == date.year &&
                  event.date.month == date.month &&
                  event.date.day == date.day,
            )
            .toList();

    if (dayEvents.isNotEmpty) {
      _showEventsDialog(date, dayEvents);
    }
  }

  void _showEventsDialog(DateTime date, List<IslamicEvent> events) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: RevolutionaryIslamicTheme.backgroundSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              _formatGregorianDate(date),
              style: const TextStyle(
                color: RevolutionaryIslamicTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  events
                      .map(
                        (event) => ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: event.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              event.icon,
                              color: event.color,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            event.title,
                            style: const TextStyle(
                              color: RevolutionaryIslamicTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            event.description,
                            style: const TextStyle(
                              color: RevolutionaryIslamicTheme.textSecondary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: RevolutionaryIslamicTheme.primaryEmerald,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  int _getEventsInMonth() {
    return _events
        .where(
          (event) =>
              event.date.year == _selectedDate.year &&
              event.date.month == _selectedDate.month,
        )
        .length;
  }

  Widget _buildCalendarLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: RevolutionaryIslamicTheme.neutralGray50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendItem(RevolutionaryIslamicTheme.primaryEmerald, 'Today'),
          _legendItem(
            RevolutionaryIslamicTheme.primaryEmerald.withOpacity(0.3),
            'Selected',
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: RevolutionaryIslamicTheme.secondaryNavy,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'Event',
                style: TextStyle(
                  fontSize: 10,
                  color: RevolutionaryIslamicTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: RevolutionaryIslamicTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showMonthYearPicker() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: RevolutionaryIslamicTheme.backgroundSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Select Month & Year',
              style: TextStyle(
                color: RevolutionaryIslamicTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: SizedBox(
              width: 300,
              height: 300,
              child: Column(
                children: [
                  // Year selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed:
                            () => setState(() {
                              _selectedDate = DateTime(
                                _selectedDate.year - 1,
                                _selectedDate.month,
                              );
                            }),
                        icon: const Icon(Icons.remove),
                        color: RevolutionaryIslamicTheme.primaryEmerald,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: RevolutionaryIslamicTheme.primaryEmerald
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _selectedDate.year.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: RevolutionaryIslamicTheme.primaryEmerald,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed:
                            () => setState(() {
                              _selectedDate = DateTime(
                                _selectedDate.year + 1,
                                _selectedDate.month,
                              );
                            }),
                        icon: const Icon(Icons.add),
                        color: RevolutionaryIslamicTheme.primaryEmerald,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Month grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        final monthNames = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                          'Jul',
                          'Aug',
                          'Sep',
                          'Oct',
                          'Nov',
                          'Dec',
                        ];
                        final isSelected = index + 1 == _selectedDate.month;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = DateTime(
                                _selectedDate.year,
                                index + 1,
                                1,
                              );
                            });
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? RevolutionaryIslamicTheme.primaryEmerald
                                      : RevolutionaryIslamicTheme
                                          .backgroundSecondary,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? RevolutionaryIslamicTheme
                                            .primaryEmerald
                                        : RevolutionaryIslamicTheme.borderLight,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                monthNames[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isSelected
                                          ? RevolutionaryIslamicTheme
                                              .neutralWhite
                                          : RevolutionaryIslamicTheme
                                              .textPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: RevolutionaryIslamicTheme.primaryEmerald,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}

class IslamicEvent {
  final String title;
  final DateTime date;
  final String description;
  final IconData icon;
  final Color color;
  final bool isImportant;

  IslamicEvent(
    this.title,
    this.date,
    this.description,
    this.icon,
    this.color,
    this.isImportant,
  );
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
