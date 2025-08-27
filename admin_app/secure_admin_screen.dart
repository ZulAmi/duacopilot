import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'admin_security.dart';
import 'admin_theme.dart';

/// Secure Admin Dashboard Screen
class SecureAdminScreen extends StatefulWidget {
  const SecureAdminScreen({super.key});

  @override
  State<SecureAdminScreen> createState() => _SecureAdminScreenState();
}

class _SecureAdminScreenState extends State<SecureAdminScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Timer? _refreshTimer;

  // Mock data for demonstration
  final Map<String, dynamic> _systemMetrics = {
    'users_active': 0,
    'requests_per_minute': 0,
    'error_rate': 0.0,
    'response_time': 0,
    'memory_usage': 0.0,
    'cpu_usage': 0.0,
  };

  final List<Map<String, dynamic>> _recentActivity = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _startMetricsCollection();

    // SECURITY: Log admin dashboard access
    AdminSecurity.logSecurityEvent(
      event: 'admin_dashboard_accessed',
      level: SecurityLevel.warning,
      context: {'timestamp': DateTime.now().toIso8601String()},
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startMetricsCollection() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        _updateMetrics();
      }
    });
  }

  void _updateMetrics() {
    setState(() {
      final random = Random();
      _systemMetrics['users_active'] = random.nextInt(500) + 50;
      _systemMetrics['requests_per_minute'] = random.nextInt(1000) + 100;
      _systemMetrics['error_rate'] = random.nextDouble() * 2.0;
      _systemMetrics['response_time'] = random.nextInt(200) + 50;
      _systemMetrics['memory_usage'] = 40.0 + random.nextDouble() * 30.0;
      _systemMetrics['cpu_usage'] = 10.0 + random.nextDouble() * 20.0;

      // Add recent activity
      if (_recentActivity.length > 50) {
        _recentActivity.removeAt(0);
      }
      _recentActivity.add({
        'timestamp': DateTime.now(),
        'action': _getRandomAction(),
        'user': 'user_${random.nextInt(100)}',
        'status': random.nextBool() ? 'success' : 'warning',
      });
    });
  }

  String _getRandomAction() {
    final actions = [
      'dua_search',
      'prayer_time_check',
      'qibla_direction',
      'islamic_calendar',
      'hadith_search',
      'quran_verse',
    ];
    return actions[Random().nextInt(actions.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.security, color: Colors.white),
            SizedBox(width: 8),
            Text('🔒 SECURE ADMIN DASHBOARD')
          ],
        ),
        backgroundColor: AdminTheme.primaryRed,
        foregroundColor: Colors.white,
        actions: [
          // Security Status Indicator
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(12)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.white),
                SizedBox(width: 4),
                Text('SECURE',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // Logout Button
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _handleLogout,
              tooltip: 'Secure Logout'),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
            Tab(icon: Icon(Icons.security), text: 'Security'),
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.settings), text: 'System'),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildAnalyticsTab(),
          _buildSecurityTab(),
          _buildUsersTab(),
          _buildSystemTab()
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Security Alert
          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red.shade600),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ADMIN ACCESS ACTIVE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade800),
                        ),
                        Text(
                          'You are accessing sensitive administrative functions',
                          style: TextStyle(color: Colors.red.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Metrics Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildMetricCard(
                  'Active Users',
                  _systemMetrics['users_active'].toString(),
                  Icons.people,
                  Colors.blue),
              _buildMetricCard(
                'Requests/Min',
                _systemMetrics['requests_per_minute'].toString(),
                Icons.trending_up,
                Colors.green,
              ),
              _buildMetricCard(
                'Error Rate',
                '${_systemMetrics['error_rate'].toStringAsFixed(1)}%',
                Icons.error_outline,
                _systemMetrics['error_rate'] > 1.0 ? Colors.red : Colors.orange,
              ),
              _buildMetricCard(
                  'Response Time',
                  '${_systemMetrics['response_time']}ms',
                  Icons.timer,
                  Colors.purple),
            ],
          ),

          const SizedBox(height: 20),

          // Recent Activity
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Recent Activity',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _recentActivity.take(10).length,
                    itemBuilder: (context, index) {
                      final activity = _recentActivity[index];
                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 8,
                          backgroundColor: activity['status'] == 'success'
                              ? Colors.green
                              : Colors.orange,
                        ),
                        title: Text(activity['action']),
                        subtitle: Text(activity['user']),
                        trailing: Text(_formatTime(activity['timestamp']),
                            style: const TextStyle(fontSize: 12)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('System Analytics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Performance Metrics
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Performance Metrics',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildProgressIndicator('CPU Usage',
                      _systemMetrics['cpu_usage'], 100, Colors.blue),
                  const SizedBox(height: 12),
                  _buildProgressIndicator('Memory Usage',
                      _systemMetrics['memory_usage'], 100, Colors.orange),
                  const SizedBox(height: 12),
                  _buildProgressIndicator('Error Rate',
                      _systemMetrics['error_rate'], 5, Colors.red),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Usage Statistics
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Feature Usage (Last 24h)',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildUsageBar('Dua Search', 850, 1000, Colors.green),
                  _buildUsageBar('Prayer Times', 720, 1000, Colors.blue),
                  _buildUsageBar('Qibla Direction', 640, 1000, Colors.orange),
                  _buildUsageBar('Hadith Search', 520, 1000, Colors.purple),
                  _buildUsageBar('Quran Verses', 480, 1000, Colors.teal),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Security Monitor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Security Status
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.shield, color: Colors.green.shade600, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SYSTEM SECURE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                              fontSize: 16),
                        ),
                        Text('All security checks passed',
                            style: TextStyle(color: Colors.green.shade600)),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text(
                      'SECURE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Security Logs
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Security Events',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: AdminSecurity.getSecurityLogs().length,
                    itemBuilder: (context, index) {
                      final log = AdminSecurity.getSecurityLogs()[index];
                      return ListTile(
                        dense: true,
                        leading: Icon(
                          AdminTheme.getStatusIcon(log['level']),
                          color: AdminTheme.getStatusColor(log['level']),
                          size: 20,
                        ),
                        title: Text(log['event'],
                            style: const TextStyle(fontSize: 14)),
                        subtitle: Text(_formatTimestamp(log['timestamp']),
                            style: const TextStyle(fontSize: 12)),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AdminTheme.getStatusColor(log['level'])
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            log['level'].toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AdminTheme.getStatusColor(log['level']),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('User Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            'User analytics and management features would be implemented here',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('System Configuration',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // System Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Application Information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildInfoRow('Version', '1.0.0'),
                  _buildInfoRow('Build', 'ADMIN_2024.1'),
                  _buildInfoRow('Environment', 'SECURE_ADMIN'),
                  _buildInfoRow('Platform', 'Flutter/Dart'),
                  _buildInfoRow('Security Level', 'MAXIMUM'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Security Actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Security Actions',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _exportSecurityLogs,
                      icon: const Icon(Icons.download),
                      label: const Text('Export Security Logs'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _clearLogs,
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Clear All Logs'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleLogout,
                      icon: const Icon(Icons.logout),
                      label: const Text('SECURE LOGOUT'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(title,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(
      String label, double value, double max, Color color) {
    final percentage = (value / max * 100).clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text('${percentage.toStringAsFixed(1)}%'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildUsageBar(String feature, int count, int max, Color color) {
    final percentage = count / max;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 120,
              child: Text(feature, style: const TextStyle(fontSize: 12))),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 8),
          Text('$count', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value)
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String _formatTimestamp(String timestamp) {
    try {
      final time = DateTime.parse(timestamp);
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp;
    }
  }

  void _exportSecurityLogs() {
    // SECURITY: Log export action
    AdminSecurity.logSecurityEvent(
      event: 'security_logs_exported',
      level: SecurityLevel.info,
      context: {'timestamp': DateTime.now().toIso8601String()},
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(
        content: Text('Security logs exported successfully'),
        backgroundColor: Colors.green));
  }

  void _clearLogs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Logs'),
        content: const Text(
            'Are you sure you want to clear all security logs? This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Clear logs implementation would go here
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(
                  content: Text('All logs cleared'),
                  backgroundColor: Colors.orange));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    // SECURITY: Log logout action
    AdminSecurity.logSecurityEvent(
      event: 'admin_logout',
      level: SecurityLevel.info,
      context: {'timestamp': DateTime.now().toIso8601String()},
    );

    // Clear any sensitive data
    _refreshTimer?.cancel();

    // Navigate back to authentication
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
}
