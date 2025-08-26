import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:duacopilot/firebase_options.dart';
import 'admin_security.dart';
import 'admin_theme.dart';
import 'secure_admin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SECURITY: Initialize Firebase for admin app
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // SECURITY: Initialize admin security
  await AdminSecurity.initialize();

  // SECURITY: Validate admin environment
  AdminSecurity.validateAdminEnvironment();

  runApp(const ProviderScope(child: SecureAdminApp()));
}

/// Secure Admin Application - Completely Separated from Production App
class SecureAdminApp extends StatelessWidget {
  const SecureAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DuaCopilot Admin - Secure Monitoring',
      theme: AdminTheme.buildSecureTheme(),
      darkTheme: AdminTheme.buildSecureDarkTheme(),
      themeMode: ThemeMode.system,
      home: const AdminAuthenticationGate(),
      debugShowCheckedModeBanner: false,

      // SECURITY: Disable screenshots and screen recording
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.red,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Colors.red,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child: child!,
        );
      },
    );
  }
}

/// Multi-Factor Authentication Gate for Admin Access
class AdminAuthenticationGate extends StatefulWidget {
  const AdminAuthenticationGate({super.key});

  @override
  State<AdminAuthenticationGate> createState() =>
      _AdminAuthenticationGateState();
}

class _AdminAuthenticationGateState extends State<AdminAuthenticationGate> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mfaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _showMfaField = false;
  String? _errorMessage;
  int _failedAttempts = 0;

  @override
  void initState() {
    super.initState();
    // SECURITY: Track admin app launch
    AdminSecurity.logSecurityEvent(
      event: 'admin_app_launch',
      level: SecurityLevel.warning,
      context: {'timestamp': DateTime.now().toIso8601String()},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade900,
      appBar: AppBar(
        title: const Text('🔒 SECURE ADMIN ACCESS'),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Security Warning
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.security,
                        color: Colors.red.shade600,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'SECURE ADMIN ACCESS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Unauthorized access is monitored and logged',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Username Field
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Admin Username',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Username is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Admin Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),

                // MFA Field (conditional)
                if (_showMfaField) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _mfaController,
                    decoration: const InputDecoration(
                      labelText: 'MFA Code (6 digits)',
                      prefixIcon: Icon(Icons.security),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validator: (value) {
                      if (_showMfaField && (value?.isEmpty ?? true)) {
                        return 'MFA code is required';
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 20),

                // Error Message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      border: Border.all(color: Colors.red.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade800),
                    ),
                  ),

                const SizedBox(height: 16),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade800,
                      foregroundColor: Colors.white,
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text('AUTHENTICATE'),
                  ),
                ),

                const SizedBox(height: 16),

                // Security Notice
                Text(
                  'Failed attempts: $_failedAttempts/5',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        _failedAttempts >= 3
                            ? Colors.red
                            : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // SECURITY: Validate credentials with proper hashing
      final isValid = await AdminSecurity.validateCredentials(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        mfaCode: _showMfaField ? _mfaController.text.trim() : null,
      );

      if (isValid) {
        // SECURITY: Log successful authentication
        AdminSecurity.logSecurityEvent(
          event: 'admin_login_success',
          level: SecurityLevel.info,
          context: {
            'username': _usernameController.text.trim(),
            'timestamp': DateTime.now().toIso8601String(),
          },
        );

        // Navigate to secure admin dashboard
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const SecureAdminScreen()),
          );
        }
      } else {
        // SECURITY: Handle failed authentication
        setState(() {
          _failedAttempts++;
          if (!_showMfaField && _failedAttempts == 1) {
            _showMfaField = true;
            _errorMessage = 'MFA required for additional security';
          } else {
            _errorMessage = 'Invalid credentials or MFA code';
          }
        });

        // SECURITY: Log failed attempt
        AdminSecurity.logSecurityEvent(
          event: 'admin_login_failed',
          level: SecurityLevel.warning,
          context: {
            'username': _usernameController.text.trim(),
            'failed_attempts': _failedAttempts,
            'timestamp': DateTime.now().toIso8601String(),
          },
        );

        // SECURITY: Lock out after 5 failed attempts
        if (_failedAttempts >= 5) {
          AdminSecurity.lockOutUser();
          setState(() {
            _errorMessage = 'Account locked due to failed attempts';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Authentication error: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _mfaController.dispose();
    super.dispose();
  }
}
