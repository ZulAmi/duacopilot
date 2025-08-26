import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/islamic_university_entity.dart';
import '../../../services/learning/islamic_university_service.dart';
import '../../../services/subscription/subscription_service.dart';

/// Islamic University Screen - Premier Islamic Learning Platform
class IslamicUniversityScreen extends ConsumerStatefulWidget {
  const IslamicUniversityScreen({super.key});

  @override
  ConsumerState<IslamicUniversityScreen> createState() =>
      _IslamicUniversityScreenState();
}

class _IslamicUniversityScreenState
    extends ConsumerState<IslamicUniversityScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final IslamicUniversityService _universityService =
      IslamicUniversityService.instance;

  // Data state
  bool _isLoading = false;
  List<IslamicScholar> _scholars = [];
  List<PremiumCourse> _courses = [];
  List<IslamicLearningPath> _learningPaths = [];
  PersonalizedCurriculum? _userCurriculum;
  LearningAnalytics? _analytics;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _initializeUniversity();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Initialize university service and load data
  Future<void> _initializeUniversity() async {
    setState(() => _isLoading = true);

    try {
      // Validate subscription
      final subscriptionService = SubscriptionService.instance;
      if (!subscriptionService.hasActiveSubscription) {
        _showSubscriptionRequired();
        return;
      }

      await _universityService.initialize();

      // Load all data
      _scholars = _universityService.getScholars();
      _courses = await _universityService.getCourses();
      _learningPaths = await _universityService.getLearningPaths();
      _userCurriculum = _universityService.getUserCurriculum();
      _analytics = await _universityService.getLearningAnalytics();
    } catch (e) {
      _showError('Failed to initialize Islamic University: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoading() : _buildContent(),
      floatingActionButton: _buildCreateCurriculumFAB(),
    );
  }

  /// Build app bar with university branding
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Row(
        children: [
          Icon(Icons.school, color: Colors.white),
          SizedBox(width: 8),
          Text('Islamic University'),
          SizedBox(width: 8),
          Icon(Icons.star, color: Colors.amber, size: 20),
        ],
      ),
      backgroundColor: const Color(0xFFf093fb),
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.analytics),
          onPressed: _showLearningAnalytics,
          tooltip: 'Learning Analytics',
        ),
        IconButton(
          icon: const Icon(Icons.workspace_premium),
          onPressed: _showCertificates,
          tooltip: 'My Certificates',
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        isScrollable: true,
        tabs: const [
          Tab(text: 'Dashboard', icon: Icon(Icons.dashboard)),
          Tab(text: 'Scholars', icon: Icon(Icons.person)),
          Tab(text: 'Courses', icon: Icon(Icons.book)),
          Tab(text: 'Learning Paths', icon: Icon(Icons.route)),
          Tab(text: 'Live Sessions', icon: Icon(Icons.live_tv)),
        ],
      ),
    );
  }

  /// Build loading widget
  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading Islamic University...'),
        ],
      ),
    );
  }

  /// Build main content with tabs
  Widget _buildContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFFf093fb).withOpacity(0.1), Colors.white],
        ),
      ),
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildScholarsTab(),
          _buildCoursesTab(),
          _buildLearningPathsTab(),
          _buildLiveSessionsTab(),
        ],
      ),
    );
  }

  /// Build Dashboard tab with personalized content
  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(),
          const SizedBox(height: 24),
          if (_userCurriculum != null) ...[
            _buildPersonalizedCurriculum(_userCurriculum!),
            const SizedBox(height: 24),
          ],
          _buildLearningProgress(),
          const SizedBox(height: 24),
          _buildRecommendedCourses(),
          const SizedBox(height: 24),
          _buildUpcomingSessions(),
        ],
      ),
    );
  }

  /// Build welcome header
  Widget _buildWelcomeHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFf093fb).withOpacity(0.1),
            const Color(0xFFf5576c).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFf093fb).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.school, color: Color(0xFFf093fb), size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Islamic University',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFf093fb),
                      ),
                    ),
                    Text(
                      'Learn from world-renowned Islamic scholars',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_analytics != null) ...[
            Row(
              children: [
                _buildStatCard(
                  'Courses Completed',
                  _analytics!.completedCourses.toString(),
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  'Study Hours',
                  '${_analytics!.totalStudyTime ~/ 60}h',
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  'Certificates',
                  _analytics!.certificatesEarned.toString(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Build stat card
  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFf093fb),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build personalized curriculum section
  Widget _buildPersonalizedCurriculum(PersonalizedCurriculum curriculum) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology, color: Color(0xFFf093fb)),
                const SizedBox(width: 8),
                Text(
                  'My Learning Journey',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _editCurriculum,
                  child: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(curriculum.title),
            const SizedBox(height: 8),
            Text(
              'Current Level: ${curriculum.currentLevel.name.toUpperCase()}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Target Level: ${curriculum.targetLevel.name.toUpperCase()}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _calculateCurriculumProgress(curriculum),
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFf093fb),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(_calculateCurriculumProgress(curriculum) * 100).toInt()}% Complete',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  /// Build learning progress section
  Widget _buildLearningProgress() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Learning Progress',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildProgressItem('Arabic Foundations', 0.75, 'Continue Learning'),
            const SizedBox(height: 8),
            _buildProgressItem('Islamic Creed', 0.45, 'Resume Course'),
            const SizedBox(height: 8),
            _buildProgressItem(
              'Spiritual Development',
              0.90,
              'Nearly Complete',
            ),
          ],
        ),
      ),
    );
  }

  /// Build progress item
  Widget _buildProgressItem(String title, double progress, String action) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFf093fb)),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => _continueLearning(title),
            child: Text(action),
          ),
        ),
      ],
    );
  }

  /// Build recommended courses
  Widget _buildRecommendedCourses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended Courses',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _courses.take(5).length,
            itemBuilder: (context, index) {
              final course = _courses[index];
              return _buildCourseCard(course);
            },
          ),
        ),
      ],
    );
  }

  /// Build course card
  Widget _buildCourseCard(PremiumCourse course) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        child: InkWell(
          onTap: () => _openCourse(course),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course image/thumbnail
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFf093fb).withOpacity(0.8),
                        const Color(0xFFf5576c),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.play_lesson,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),

              // Course info
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'By ${_getScholarName(course.scholarId)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            course.rating.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                          const Spacer(),
                          Text(
                            '${course.duration ~/ 60}h',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build upcoming sessions
  Widget _buildUpcomingSessions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Live Sessions',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildSessionCard(
          title: 'Live Q&A with Dr. Yasir Qadhi',
          time: 'Today, 8:00 PM GMT',
          topic: 'Contemporary Islamic Issues',
        ),
        const SizedBox(height: 8),
        _buildSessionCard(
          title: 'Arabic Grammar Workshop',
          time: 'Tomorrow, 6:00 PM GMT',
          topic: 'Fundamentals of Arabic Grammar',
        ),
      ],
    );
  }

  /// Build session card
  Widget _buildSessionCard({
    required String title,
    required String time,
    required String topic,
  }) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFf093fb),
          child: Icon(Icons.live_tv, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(time),
            Text(
              topic,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _joinSession(title),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFf093fb),
            foregroundColor: Colors.white,
          ),
          child: const Text('Join'),
        ),
      ),
    );
  }

  /// Build Scholars tab
  Widget _buildScholarsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _scholars.length,
      itemBuilder: (context, index) {
        final scholar = _scholars[index];
        return _buildScholarCard(scholar);
      },
    );
  }

  /// Build scholar card
  Widget _buildScholarCard(IslamicScholar scholar) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showScholarDetails(scholar),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage:
                    scholar.profileImageUrl.isNotEmpty
                        ? NetworkImage(scholar.profileImageUrl)
                        : null,
                child:
                    scholar.profileImageUrl.isEmpty
                        ? Text(scholar.name[0])
                        : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            scholar.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (scholar.isVerified)
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 18,
                          ),
                      ],
                    ),
                    Text(
                      scholar.arabicName,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scholar.specialization,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          scholar.rating.toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.people, color: Colors.grey[600], size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${scholar.totalStudents} students',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _viewScholarCourses(scholar),
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build Courses tab
  Widget _buildCoursesTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _courses.length,
      itemBuilder: (context, index) {
        final course = _courses[index];
        return _buildCourseGridCard(course);
      },
    );
  }

  /// Build course grid card
  Widget _buildCourseGridCard(PremiumCourse course) {
    return Card(
      child: InkWell(
        onTap: () => _openCourse(course),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  gradient: _getCategoryGradient(course.category),
                ),
                child: const Icon(
                  Icons.play_lesson,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'By ${_getScholarName(course.scholarId)}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          course.rating.toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFf093fb),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            course.level.name.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build Learning Paths tab
  Widget _buildLearningPathsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _learningPaths.length,
      itemBuilder: (context, index) {
        final path = _learningPaths[index];
        return _buildLearningPathCard(path);
      },
    );
  }

  /// Build learning path card
  Widget _buildLearningPathCard(IslamicLearningPath path) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _openLearningPath(path),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFf093fb),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.route, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          path.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${path.estimatedHours} hours • ${path.courseIds.length} courses',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFf093fb).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      path.level.name.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFFf093fb),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(path.description, style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children:
                    path.skills
                        .map(
                          (skill) => Chip(
                            label: Text(skill),
                            backgroundColor: Colors.grey[100],
                            labelStyle: const TextStyle(fontSize: 10),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(path.rating.toString()),
                  const SizedBox(width: 16),
                  Icon(Icons.people, color: Colors.grey[600], size: 16),
                  const SizedBox(width: 4),
                  Text('${path.enrolledCount} enrolled'),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => _enrollInPath(path),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFf093fb),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Start Path'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build Live Sessions tab
  Widget _buildLiveSessionsTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.live_tv, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Live Q&A Sessions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Join live sessions with renowned Islamic scholars',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build Create Curriculum FAB
  Widget? _buildCreateCurriculumFAB() {
    if (_userCurriculum != null) return null;

    return FloatingActionButton.extended(
      onPressed: _createPersonalizedCurriculum,
      backgroundColor: const Color(0xFFf093fb),
      foregroundColor: Colors.white,
      icon: const Icon(Icons.psychology),
      label: const Text('Create Curriculum'),
    );
  }

  // Helper methods
  String _getScholarName(String scholarId) {
    final scholar = _scholars.firstWhere(
      (s) => s.id == scholarId,
      orElse:
          () => IslamicScholar(
            id: '',
            name: 'Unknown',
            arabicName: '',
            title: '',
            institution: '',
            country: '',
            specialization: '',
            biography: '',
            arabicBiography: '',
            isVerified: false,
            profileImageUrl: '',
            credentials: [],
            languages: [],
            subjects: [],
            rating: 0,
            totalStudents: 0,
            coursesCount: 0,
            sessionsCount: 0,
            verifiedAt: DateTime.now(),
            createdAt: DateTime.now(),
          ),
    );
    return scholar.name;
  }

  LinearGradient _getCategoryGradient(CourseCategory category) {
    switch (category) {
      case CourseCategory.arabic:
        return const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        );
      case CourseCategory.aqeedah:
        return const LinearGradient(
          colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
        );
      case CourseCategory.spirituality:
        return const LinearGradient(
          colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
        );
    }
  }

  double _calculateCurriculumProgress(PersonalizedCurriculum curriculum) {
    // Calculate based on completed goals
    final completedGoals = curriculum.goals.where((g) => g.isCompleted).length;
    return completedGoals / curriculum.goals.length;
  }

  // Action methods
  void _editCurriculum() {
    // Navigate to curriculum editor
  }

  void _continueLearning(String courseName) {
    // Resume specific course
  }

  void _openCourse(PremiumCourse course) {
    // Navigate to course details
  }

  void _showScholarDetails(IslamicScholar scholar) {
    // Show scholar details modal
  }

  void _viewScholarCourses(IslamicScholar scholar) {
    // Navigate to scholar's courses
  }

  void _openLearningPath(IslamicLearningPath path) {
    // Navigate to learning path details
  }

  void _enrollInPath(IslamicLearningPath path) {
    // Enroll in learning path
  }

  void _joinSession(String sessionTitle) {
    // Join live session
  }

  void _createPersonalizedCurriculum() {
    // Show curriculum creation wizard
    showDialog(
      context: context,
      builder: (context) => _buildCurriculumCreationDialog(),
    );
  }

  Widget _buildCurriculumCreationDialog() {
    return AlertDialog(
      title: const Text('Create Your Learning Journey'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Let us create a personalized Islamic learning curriculum for you',
          ),
          SizedBox(height: 16),
          // Add form fields for interests, level, etc.
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _processCurriculumCreation,
          child: const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _processCurriculumCreation() async {
    Navigator.pop(context);
    // Process curriculum creation with user inputs
    try {
      final curriculum = await _universityService.createPersonalizedCurriculum(
        interests: ['Arabic', 'Aqeedah', 'Spirituality'],
        currentLevel: LearningLevel.beginner,
        targetLevel: LearningLevel.intermediate,
      );

      setState(() {
        _userCurriculum = curriculum;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Personal curriculum created successfully!'),
        ),
      );
    } catch (e) {
      _showError('Failed to create curriculum: $e');
    }
  }

  void _showLearningAnalytics() {
    // Show detailed learning analytics
  }

  void _showCertificates() {
    // Show user's certificates
  }

  void _showSubscriptionRequired() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Premium Subscription Required'),
            content: const Text(
              'Islamic University features require an active subscription. '
              'Upgrade now to access courses from world-renowned scholars.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Later'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to subscription screen
                },
                child: const Text('Upgrade Now'),
              ),
            ],
          ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          textColor: Colors.white,
        ),
      ),
    );
  }
}
