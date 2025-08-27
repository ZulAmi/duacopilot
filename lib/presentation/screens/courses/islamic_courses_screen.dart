import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/modern_ui_components.dart';
import '../../../core/models/islamic_course_models.dart';
import '../../../services/subscription/subscription_service.dart';
import '../../../services/courses/course_service.dart';
import '../subscription/subscription_screen.dart';

/// Islamic courses marketplace screen
class IslamicCoursesScreen extends StatefulWidget {
  const IslamicCoursesScreen({super.key});

  @override
  State<IslamicCoursesScreen> createState() => _IslamicCoursesScreenState();
}

class _IslamicCoursesScreenState extends State<IslamicCoursesScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final SubscriptionService _subscriptionService = SubscriptionService.instance;
  final CourseService _courseService = CourseService.instance;
  final TextEditingController _searchController = TextEditingController();

  final List<IslamicCourse> _courses = SampleIslamicCourses.courses;
  List<IslamicCourse> _filteredCourses = [];
  CourseCategory? _selectedCategory;
  CourseDifficulty? _selectedDifficulty;
  bool _showOnlyFree = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeCourseService();
    _filteredCourses = _courses;
  }

  void _initializeCourseService() async {
    try {
      await _courseService.initialize();
    } catch (e) {
      print('Failed to initialize CourseService: $e');
    }
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterCourses() {
    setState(() {
      _filteredCourses =
          _courses.where((course) {
            // Search filter
            if (_searchController.text.isNotEmpty) {
              final query = _searchController.text.toLowerCase();
              if (!course.title.toLowerCase().contains(query) &&
                  !course.description.toLowerCase().contains(query) &&
                  !course.instructor.toLowerCase().contains(query)) {
                return false;
              }
            }

            // Category filter
            if (_selectedCategory != null &&
                course.category != _selectedCategory) {
              return false;
            }

            // Difficulty filter
            if (_selectedDifficulty != null &&
                course.difficulty != _selectedDifficulty) {
              return false;
            }

            // Free courses filter
            if (_showOnlyFree && course.price > 0) {
              return false;
            }

            return true;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSearchBar(),
                      const SizedBox(height: 16),
                      _buildFilters(),
                      const SizedBox(height: 24),
                      _buildPopularCoursesSection(),
                      const SizedBox(height: 24),
                      _buildAllCoursesSection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school_rounded, size: 48, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Islamic Courses',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Learn from authenticated Islamic scholars',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Show enrolled courses
          },
          icon: const Icon(Icons.bookmark, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return GlassmorphicContainer(
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search Islamic courses...',
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      _filterCourses();
                    },
                    icon: const Icon(Icons.clear),
                  )
                  : null,
        ),
        onChanged: (_) => _filterCourses(),
      ),
    );
  }

  Widget _buildFilters() {
    return GlassmorphicContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildCategoryFilter(),
          const SizedBox(height: 12),
          _buildDifficultyFilter(),
          const SizedBox(height: 12),
          _buildFreeCoursesToggle(),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: const Text('All'),
              selected: _selectedCategory == null,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? null : _selectedCategory;
                  _filterCourses();
                });
              },
            ),
            ...CourseCategory.values.map((category) {
              return FilterChip(
                label: Text(_getCategoryDisplayName(category)),
                selected: _selectedCategory == category,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = selected ? category : null;
                    _filterCourses();
                  });
                },
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildDifficultyFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Difficulty',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('All Levels'),
              selected: _selectedDifficulty == null,
              onSelected: (selected) {
                setState(() {
                  _selectedDifficulty = selected ? null : _selectedDifficulty;
                  _filterCourses();
                });
              },
            ),
            ...CourseDifficulty.values.map((difficulty) {
              return FilterChip(
                label: Text(difficulty.name.capitalize()),
                selected: _selectedDifficulty == difficulty,
                onSelected: (selected) {
                  setState(() {
                    _selectedDifficulty = selected ? difficulty : null;
                    _filterCourses();
                  });
                },
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildFreeCoursesToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Show only free courses',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        Switch(
          value: _showOnlyFree,
          onChanged: (value) {
            setState(() {
              _showOnlyFree = value;
              _filterCourses();
            });
          },
        ),
      ],
    );
  }

  Widget _buildPopularCoursesSection() {
    final popularCourses = SampleIslamicCourses.getPopularCourses();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Courses',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: popularCourses.length,
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                margin: EdgeInsets.only(
                  right: index < popularCourses.length - 1 ? 16 : 0,
                ),
                child: _buildCourseCard(
                  popularCourses[index],
                  isHorizontal: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAllCoursesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Courses (${_filteredCourses.length})',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _filteredCourses.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: _buildCourseCard(_filteredCourses[index]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCourseCard(IslamicCourse course, {bool isHorizontal = false}) {
    final theme = Theme.of(context);
    final hasAccess =
        _subscriptionService.isFeatureAvailable('islamic_courses') ||
        course.price == 0;
    final isEnrolled = _courseService.isEnrolledInCourse(course.id);
    final progress = _courseService.getCourseProgress(course.id);

    return ModernAnimatedCard(
      onTap: () => _handleCourseSelection(course),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course thumbnail
          Container(
            height: isHorizontal ? 120 : 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.8),
                  theme.colorScheme.secondary.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Placeholder for thumbnail image
                const Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                // Course badges
                Positioned(
                  top: 8,
                  left: 8,
                  child: Wrap(
                    spacing: 4,
                    children: [
                      if (course.isNew)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (course.isPopular)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'POPULAR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Duration
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      course.formattedDuration,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Course information
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and category
                Text(
                  course.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  course.categoryDisplayName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                // Instructor
                Row(
                  children: [
                    const Icon(Icons.person, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        course.instructor,
                        style: theme.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Stats row
                Row(
                  children: [
                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          course.rating.toStringAsFixed(1),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Enrolled count
                    Row(
                      children: [
                        const Icon(Icons.people, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${course.enrolledCount}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Lessons count
                    Row(
                      children: [
                        const Icon(Icons.play_lesson, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${course.lessonCount} lessons',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Price and action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (course.price > 0) ...[
                          if (course.isOnSale) ...[
                            Text(
                              '\$${course.originalPrice.toStringAsFixed(2)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '\$${course.price.toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ] else ...[
                            Text(
                              '\$${course.price.toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ] else ...[
                          Text(
                            'FREE',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                        // Difficulty
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            course.difficultyDisplayName,
                            style: TextStyle(
                              fontSize: 10,
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed:
                          hasAccess
                              ? () => _handleCourseSelection(course)
                              : _showSubscriptionDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isEnrolled
                                ? (progress >= 100
                                    ? Colors.green
                                    : theme.colorScheme.primary)
                                : hasAccess
                                ? theme.colorScheme.primary
                                : Colors.grey,
                      ),
                      child: Text(
                        isEnrolled
                            ? (progress >= 100
                                ? 'Completed'
                                : 'Continue ${progress.toInt()}%')
                            : hasAccess
                            ? (course.price > 0 ? 'Enroll' : 'Start')
                            : 'Premium',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryDisplayName(CourseCategory category) {
    switch (category) {
      case CourseCategory.quran:
        return 'Quran';
      case CourseCategory.hadith:
        return 'Hadith';
      case CourseCategory.fiqh:
        return 'Fiqh';
      case CourseCategory.aqeedah:
        return 'Aqeedah';
      case CourseCategory.history:
        return 'History';
      case CourseCategory.duas:
        return 'Duas';
      case CourseCategory.arabic:
        return 'Arabic';
      case CourseCategory.family:
        return 'Family';
      case CourseCategory.children:
        return 'Children';
      case CourseCategory.spirituality:
        return 'Spirituality';
    }
  }

  void _handleCourseSelection(IslamicCourse course) {
    HapticFeedback.lightImpact();

    // Navigate to course details
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCourseDetailsModal(course),
    );
  }

  Widget _buildCourseDetailsModal(IslamicCourse course) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return GlassmorphicContainer(
          borderRadius: 20,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and basic info
                        Text(
                          course.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'by ${course.instructor}',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          course.instructorTitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),

                        // Course stats
                        Row(
                          children: [
                            _buildStatItem(
                              Icons.star,
                              '${course.rating}',
                              Colors.amber,
                            ),
                            const SizedBox(width: 16),
                            _buildStatItem(
                              Icons.people,
                              '${course.enrolledCount}',
                              Colors.blue,
                            ),
                            const SizedBox(width: 16),
                            _buildStatItem(
                              Icons.access_time,
                              course.formattedDuration,
                              Colors.green,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Description
                        Text(
                          'About this course',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          course.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),

                        // What you'll learn
                        Text(
                          'What you\'ll learn',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...course.features.map(
                          (feature) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(feature)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Topics covered
                        if (course.topics.isNotEmpty) ...[
                          Text(
                            'Topics covered',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                course.topics
                                    .map(
                                      (topic) => Chip(
                                        label: Text(topic),
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.primary.withValues(alpha: 0.1),
                                      ),
                                    )
                                    .toList(),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Prerequisites
                        if (course.prerequisites.isNotEmpty) ...[
                          Text(
                            'Prerequisites',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...course.prerequisites.map(
                            (prereq) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_right, size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(prereq)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ],
                    ),
                  ),
                ),

                // Enrollment button at bottom
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  child: _buildEnrollmentButton(course),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildEnrollmentButton(IslamicCourse course) {
    final theme = Theme.of(context);
    final hasAccess =
        _subscriptionService.isFeatureAvailable('islamic_courses') ||
        course.price == 0;
    final isEnrolled = _courseService.isEnrolledInCourse(course.id);
    final progress = _courseService.getCourseProgress(course.id);

    if (!hasAccess) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _showSubscriptionDialog,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          child: const Text(
            'Upgrade to Premium',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    if (isEnrolled) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _startCourse(course);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                progress >= 100 ? Colors.green : theme.colorScheme.primary,
          ),
          child: Text(
            progress >= 100 ? 'View Certificate' : 'Continue Learning',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => _enrollInCourse(course),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
        ),
        child: Text(
          course.price > 0
              ? 'Enroll Now - \$${course.price.toStringAsFixed(2)}'
              : 'Start Free Course',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _enrollInCourse(IslamicCourse course) async {
    try {
      final userId = 'user_123'; // In a real app, get from auth service
      final success = await _courseService.enrollInCourse(course.id, userId);

      if (success) {
        if (mounted) {
          setState(() {}); // Refresh the UI
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully enrolled in ${course.title}'),
              backgroundColor: Colors.green,
            ),
          );
          _startCourse(course);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to enroll in course'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _startCourse(IslamicCourse course) {
    // Navigate to course player/viewer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting course: ${course.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
    // TODO: Navigate to course player screen
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Premium Required'),
            content: const Text(
              'Access to Islamic courses requires a Premium subscription. Upgrade now to unlock unlimited learning!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SubscriptionScreen(),
                    ),
                  );
                },
                child: const Text('Upgrade'),
              ),
            ],
          ),
    );
  }
}

extension StringCapitalize on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
