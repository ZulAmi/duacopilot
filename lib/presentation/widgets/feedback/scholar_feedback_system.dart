import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../../services/comprehensive_feedback_service.dart';

/// Scholar authentication levels
enum ScholarLevel {
  student('Student', 'Student of Islamic studies'),
  graduate('Graduate', 'Graduate in Islamic studies'),
  imam('Imam', 'Mosque leader/Imam'),
  scholar('Scholar', 'Recognized Islamic scholar'),
  expert('Expert', 'Expert with published works');

  const ScholarLevel(this.title, this.description);
  final String title;
  final String description;
}

/// Scholar feedback system for content authenticity verification
class ScholarFeedbackSystem {
  final ComprehensiveFeedbackService _feedbackService;

  ScholarFeedbackSystem(this._feedbackService);

  /// Submit scholar feedback for content authenticity
  Future<bool> submitScholarVerification({
    required String contentId,
    required String scholarId,
    required ScholarLevel scholarLevel,
    required bool isAuthentic,
    required String authenticity,
    List<String>? sources,
    String? comments,
    Map<String, String>? credentials,
  }) async {
    try {
      final authenticationData = {
        'scholar_level': scholarLevel.name,
        'authenticity_rating': authenticity,
        'credentials': credentials ?? {},
        'verification_method': 'manual',
      };

      return await _feedbackService.submitScholarFeedback(
        contentId: contentId,
        scholarId: scholarId,
        authenticationData: authenticationData,
        isAuthentic: isAuthentic,
        comments: comments,
        sources: sources,
      );
    } catch (e) {
      debugPrint('Error submitting scholar verification: $e');
      return false;
    }
  }

  /// Get scholar verification status for content
  Future<ScholarVerificationStatus> getVerificationStatus(
    String contentId,
  ) async {
    try {
      // This would typically fetch from your backend
      // For now, return a mock status
      return const ScholarVerificationStatus(
        contentId: 'content_id',
        isVerified: true,
        verificationCount: 3,
        averageRating: 4.5,
        lastUpdated: '2024-01-15',
        verifyingScholars: [
          ScholarInfo(
            id: 'scholar1',
            name: 'Dr. Ahmad Ibn Hassan',
            level: ScholarLevel.scholar,
            institution: 'Al-Azhar University',
          ),
        ],
      );
    } catch (e) {
      debugPrint('Error getting verification status: $e');
      return ScholarVerificationStatus.empty(contentId);
    }
  }
}

/// Scholar verification status data model
class ScholarVerificationStatus {
  final String contentId;
  final bool isVerified;
  final int verificationCount;
  final double averageRating;
  final String lastUpdated;
  final List<ScholarInfo> verifyingScholars;

  const ScholarVerificationStatus({
    required this.contentId,
    required this.isVerified,
    required this.verificationCount,
    required this.averageRating,
    required this.lastUpdated,
    required this.verifyingScholars,
  });

  factory ScholarVerificationStatus.empty(String contentId) {
    return ScholarVerificationStatus(
      contentId: contentId,
      isVerified: false,
      verificationCount: 0,
      averageRating: 0.0,
      lastUpdated: '',
      verifyingScholars: const [],
    );
  }
}

/// Scholar information data model
class ScholarInfo {
  final String id;
  final String name;
  final ScholarLevel level;
  final String? institution;
  final String? specialization;
  final List<String>? credentials;

  const ScholarInfo({
    required this.id,
    required this.name,
    required this.level,
    this.institution,
    this.specialization,
    this.credentials,
  });
}

/// Scholar feedback form widget
class ScholarFeedbackForm extends StatefulWidget {
  final String contentId;
  final String contentType;
  final Function(Map<String, dynamic>) onSubmit;
  final VoidCallback? onCancel;

  const ScholarFeedbackForm({
    super.key,
    required this.contentId,
    required this.contentType,
    required this.onSubmit,
    this.onCancel,
  });

  @override
  State<ScholarFeedbackForm> createState() => _ScholarFeedbackFormState();
}

class _ScholarFeedbackFormState extends State<ScholarFeedbackForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool _isSubmitting = false;
  ScholarLevel _selectedLevel = ScholarLevel.student;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.verified_user,
                      color: theme.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scholar Verification',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Verify content authenticity',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.onCancel != null)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: widget.onCancel,
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // Scholar Level
              Text(
                'Scholar Level',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...ScholarLevel.values.map((level) => _buildLevelOption(level)),

              const SizedBox(height: 20),

              // Credentials
              FormBuilderTextField(
                name: 'institution',
                decoration: _buildInputDecoration(
                  context,
                  'Institution/Organization',
                  Icons.school,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(2),
                ]),
              ),

              const SizedBox(height: 16),

              FormBuilderTextField(
                name: 'specialization',
                decoration: _buildInputDecoration(
                  context,
                  'Area of Specialization (Optional)',
                  Icons.category,
                ),
              ),

              const SizedBox(height: 16),

              FormBuilderTextField(
                name: 'credentials',
                decoration: _buildInputDecoration(
                  context,
                  'Credentials/Qualifications',
                  Icons.badge,
                ),
                maxLines: 2,
                validator: FormBuilderValidators.required(),
              ),

              const SizedBox(height: 20),

              // Content Verification
              Text(
                'Content Verification',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              FormBuilderRadioGroup<String>(
                name: 'authenticity',
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                validator: FormBuilderValidators.required(),
                options: [
                  FormBuilderFieldOption(
                    value: 'authentic',
                    child: _buildVerificationOption(
                      Icons.check_circle,
                      'Authentic',
                      'Content is accurate and authentic',
                      Colors.green,
                    ),
                  ),
                  FormBuilderFieldOption(
                    value: 'needs_revision',
                    child: _buildVerificationOption(
                      Icons.edit,
                      'Needs Revision',
                      'Content has minor issues that need correction',
                      Colors.orange,
                    ),
                  ),
                  FormBuilderFieldOption(
                    value: 'inauthentic',
                    child: _buildVerificationOption(
                      Icons.cancel,
                      'Inauthentic',
                      'Content contains significant errors or is inauthentic',
                      Colors.red,
                    ),
                  ),
                  FormBuilderFieldOption(
                    value: 'requires_expert',
                    child: _buildVerificationOption(
                      Icons.help,
                      'Requires Expert Review',
                      'Content requires review by higher-level scholars',
                      Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Sources
              FormBuilderTextField(
                name: 'sources',
                decoration: _buildInputDecoration(
                  context,
                  'Supporting Sources (Optional)',
                  Icons.library_books,
                ).copyWith(
                  helperText:
                      'Provide Quran verses, Hadith, or scholarly references',
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 16),

              // Comments
              FormBuilderTextField(
                name: 'comments',
                decoration: _buildInputDecoration(
                  context,
                  'Additional Comments',
                  Icons.comment,
                ),
                maxLines: 4,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(10),
                  FormBuilderValidators.maxLength(500),
                ]),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.verified_user, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Submit Verification',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Terms and Privacy
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: theme.primaryColor, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Scholar Verification Terms',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'By submitting this verification, you confirm that:\n'
                      'â€¢ You have the stated qualifications\n'
                      'â€¢ Your assessment is based on scholarly knowledge\n'
                      'â€¢ You understand this will be used to improve content quality\n'
                      'â€¢ Your name and institution may be displayed with the verification',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelOption(ScholarLevel level) {
    final theme = Theme.of(context);
    final isSelected = _selectedLevel == level;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLevel = level;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? theme.primaryColor
                : theme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? theme.primaryColor : Colors.transparent,
                border: Border.all(color: theme.primaryColor, width: 2),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? theme.primaryColor : null,
                    ),
                  ),
                  Text(
                    level.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationOption(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: theme.primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: theme.colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: theme.primaryColor, width: 2),
      ),
      filled: true,
      fillColor: theme.colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final formData = _formKey.currentState!.value;

      final scholarData = {
        'scholar_level': _selectedLevel.name,
        'institution': formData['institution'],
        'specialization': formData['specialization'],
        'credentials': formData['credentials'],
        'authenticity': formData['authenticity'],
        'sources': formData['sources'],
        'comments': formData['comments'],
        'content_id': widget.contentId,
        'content_type': widget.contentType,
        'submission_timestamp': DateTime.now().toIso8601String(),
      };

      await Future.delayed(
        const Duration(milliseconds: 800),
      ); // Simulate processing
      widget.onSubmit(scholarData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.verified_user, color: Colors.white),
                SizedBox(width: 8),
                Text('Scholar verification submitted successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Text('Failed to submit verification: ${e.toString()}'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

/// Scholar verification badge widget
class ScholarVerificationBadge extends StatelessWidget {
  final ScholarVerificationStatus status;
  final VoidCallback? onTap;

  const ScholarVerificationBadge({super.key, required this.status, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!status.isVerified && status.verificationCount == 0) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: status.isVerified
              ? Colors.green.withOpacity(0.1)
              : Colors.orange.withOpacity(0.1),
          border: Border.all(
            color: status.isVerified ? Colors.green : Colors.orange,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              status.isVerified ? Icons.verified_user : Icons.pending,
              size: 14,
              color: status.isVerified ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 4),
            Text(
              status.isVerified ? 'Scholar Verified' : 'Under Review',
              style: theme.textTheme.bodySmall?.copyWith(
                color: status.isVerified ? Colors.green : Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (status.verificationCount > 0) ...[
              const SizedBox(width: 4),
              Text(
                '(${status.verificationCount})',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: status.isVerified ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
