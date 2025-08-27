import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

/// Comprehensive contextual feedback form for content quality reports
class ContextualFeedbackForm extends StatefulWidget {
  final String contentId;
  final String contentType;
  final Function(Map<String, dynamic>) onSubmit;
  final VoidCallback? onCancel;
  final Map<String, dynamic>? initialData;

  const ContextualFeedbackForm({
    super.key,
    required this.contentId,
    required this.contentType,
    required this.onSubmit,
    this.onCancel,
    this.initialData,
  });

  @override
  State<ContextualFeedbackForm> createState() => _ContextualFeedbackFormState();
}

class _ContextualFeedbackFormState extends State<ContextualFeedbackForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: FormBuilder(
        key: _formKey,
        initialValue: widget.initialData ?? {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.feedback, color: theme.primaryColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Content Feedback',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (widget.onCancel != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: widget.onCancel,
                  ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'Help us improve the quality of ${widget.contentType} content',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),

            const SizedBox(height: 24),

            // Feedback Type
            FormBuilderDropdown<String>(
              name: 'feedback_type',
              decoration: _buildInputDecoration(
                context,
                'Feedback Type',
                Icons.category,
              ),
              validator: FormBuilderValidators.required(),
              items: _getFeedbackTypeItems(widget.contentType)
                  .map(
                    (type) => DropdownMenuItem(
                      value: type['value'] as String,
                      child: Text(type['label'] as String),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 16),

            // Quality Rating
            FormBuilderSlider(
              name: 'quality_rating',
              decoration: _buildInputDecoration(
                context,
                'Content Quality',
                Icons.star,
              ),
              min: 1.0,
              max: 5.0,
              divisions: 4,
              initialValue: 3.0,
              valueTransformer: (value) => value?.round(),
              displayValues: DisplayValues.current,
              semanticFormatterCallback: (double value) {
                return '${value.round()} out of 5 stars';
              },
            ),

            const SizedBox(height: 16),

            // Specific Issues
            FormBuilderCheckboxGroup<String>(
              name: 'specific_issues',
              decoration: _buildInputDecoration(
                context,
                'Specific Issues (Optional)',
                Icons.warning,
              ),
              options: _getIssueOptions(widget.contentType)
                  .map(
                    (issue) => FormBuilderFieldOption(
                      value: issue['value'] as String,
                      child: Text(issue['label'] as String),
                    ),
                  )
                  .toList(),
              wrapSpacing: 8,
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
                FormBuilderValidators.maxLength(500),
              ]),
            ),

            const SizedBox(height: 16),

            // Context Information
            FormBuilderCheckboxGroup<String>(
              name: 'context',
              decoration: _buildInputDecoration(
                context,
                'When did you notice this issue?',
                Icons.access_time,
              ),
              options: const [
                FormBuilderFieldOption(
                  value: 'first_time',
                  child: Text('First time viewing'),
                ),
                FormBuilderFieldOption(
                  value: 'multiple_times',
                  child: Text('Multiple times'),
                ),
                FormBuilderFieldOption(
                  value: 'after_update',
                  child: Text('After recent update'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // User Information (Optional)
            ExpansionTile(
              title: const Text('Additional Information (Optional)'),
              children: [
                const SizedBox(height: 8),
                FormBuilderTextField(
                  name: 'user_expertise',
                  decoration: _buildInputDecoration(
                    context,
                    'Your knowledge level on this topic',
                    Icons.school,
                  ),
                  validator: FormBuilderValidators.maxLength(100),
                ),
                const SizedBox(height: 12),
                FormBuilderTextField(
                  name: 'suggestion',
                  decoration: _buildInputDecoration(
                    context,
                    'Suggestion for improvement',
                    Icons.lightbulb,
                  ),
                  maxLines: 2,
                  validator: FormBuilderValidators.maxLength(200),
                ),
              ],
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
                    : const Text(
                        'Submit Feedback',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 8),

            // Privacy Note
            Text(
              'Your feedback helps improve content quality for all users. Personal information is kept private.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.primaryColor.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.primaryColor.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.primaryColor, width: 2),
      ),
      filled: true,
      fillColor: theme.colorScheme.surface.withOpacity(0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  List<Map<String, String>> _getFeedbackTypeItems(String contentType) {
    final base = [
      {'value': 'quality', 'label': 'Content Quality'},
      {'value': 'accuracy', 'label': 'Accuracy Concern'},
      {'value': 'relevance', 'label': 'Relevance Issue'},
      {'value': 'clarity', 'label': 'Clarity Problem'},
      {'value': 'suggestion', 'label': 'Improvement Suggestion'},
    ];

    if (contentType.toLowerCase() == 'dua') {
      base.addAll([
        {'value': 'translation', 'label': 'Translation Issue'},
        {'value': 'pronunciation', 'label': 'Pronunciation Guide'},
        {'value': 'authenticity', 'label': 'Authenticity Question'},
      ]);
    } else if (contentType.toLowerCase() == 'audio') {
      base.addAll([
        {'value': 'audio_quality', 'label': 'Audio Quality'},
        {'value': 'synchronization', 'label': 'Audio-Text Sync'},
      ]);
    }

    return base;
  }

  List<Map<String, String>> _getIssueOptions(String contentType) {
    final base = [
      {'value': 'typo', 'label': 'Spelling/Grammar Error'},
      {'value': 'formatting', 'label': 'Formatting Issue'},
      {'value': 'missing_info', 'label': 'Missing Information'},
      {'value': 'outdated', 'label': 'Outdated Content'},
      {'value': 'inappropriate', 'label': 'Inappropriate Content'},
    ];

    if (contentType.toLowerCase() == 'dua') {
      base.addAll([
        {'value': 'arabic_error', 'label': 'Arabic Text Error'},
        {'value': 'translation_error', 'label': 'Translation Error'},
        {'value': 'missing_context', 'label': 'Missing Context'},
      ]);
    } else if (contentType.toLowerCase() == 'audio') {
      base.addAll([
        {'value': 'audio_distortion', 'label': 'Audio Distortion'},
        {'value': 'volume_issue', 'label': 'Volume Problem'},
        {'value': 'missing_audio', 'label': 'Missing Audio'},
      ]);
    }

    return base;
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

      // Add metadata
      final enhancedData = {
        ...formData,
        'content_id': widget.contentId,
        'content_type': widget.contentType,
        'submission_timestamp': DateTime.now().toIso8601String(),
        'form_version': '2.0',
      };

      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate processing
      widget.onSubmit(enhancedData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Feedback submitted successfully!'),
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
                Text('Failed to submit feedback: ${e.toString()}'),
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

/// Quick feedback widget for inline feedback collection
class QuickFeedbackWidget extends StatefulWidget {
  final String contentId;
  final String contentType;
  final Function(Map<String, dynamic>) onSubmit;

  const QuickFeedbackWidget({
    super.key,
    required this.contentId,
    required this.contentType,
    required this.onSubmit,
  });

  @override
  State<QuickFeedbackWidget> createState() => _QuickFeedbackWidgetState();
}

class _QuickFeedbackWidgetState extends State<QuickFeedbackWidget> {
  String? _selectedFeedback;
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _quickOptions = [
    {
      'id': 'helpful',
      'label': 'Helpful',
      'icon': Icons.thumb_up,
      'color': Colors.green,
    },
    {
      'id': 'not_helpful',
      'label': 'Not Helpful',
      'icon': Icons.thumb_down,
      'color': Colors.red,
    },
    {
      'id': 'need_more_info',
      'label': 'Need More Info',
      'icon': Icons.info,
      'color': Colors.blue,
    },
    {
      'id': 'report_issue',
      'label': 'Report Issue',
      'icon': Icons.flag,
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Was this helpful?',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _quickOptions.map((option) {
              final isSelected = _selectedFeedback == option['id'];
              return GestureDetector(
                onTap: _isSubmitting
                    ? null
                    : () => _selectOption(option['id'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? option['color'] as Color
                        : Colors.transparent,
                    border: Border.all(color: option['color'] as Color),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        option['icon'] as IconData,
                        size: 16,
                        color: isSelected
                            ? Colors.white
                            : option['color'] as Color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        option['label'] as String,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : option['color'] as Color,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          if (_isSubmitting) ...[
            const SizedBox(height: 8),
            const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ],
      ),
    );
  }

  void _selectOption(String optionId) async {
    setState(() {
      _selectedFeedback = optionId;
      _isSubmitting = true;
    });

    try {
      final feedbackData = {
        'quick_feedback': optionId,
        'content_id': widget.contentId,
        'content_type': widget.contentType,
        'timestamp': DateTime.now().toIso8601String(),
      };

      await Future.delayed(const Duration(milliseconds: 300));
      widget.onSubmit(feedbackData);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
