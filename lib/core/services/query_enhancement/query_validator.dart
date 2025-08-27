import 'dart:convert';

/// Query validation and sanitization service
class QueryValidator {
  // Security patterns to detect and sanitize
  static const List<String> _maliciousPatterns = [
    r'<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>',
    r'javascript:',
    r'data:text\/html',
    r'eval\s*\(',
    r'document\.',
    r'window\.',
    r'<iframe',
    r'<object',
    r'<embed',
    r'<link',
    r'<meta',
    r'<style',
    r'expression\s*\(',
    r'url\s*\(',
    r'import\s+',
    r'@import',
    r'<?php',
    r'<%',
    r'\${',
    r'{{',
  ];

  // SQL injection patterns
  static const List<String> _sqlInjectionPatterns = [
    r'\bunion\b.*\bselect\b',
    r'\bselect\b.*\bfrom\b',
    r'\binsert\b.*\binto\b',
    r'\bupdate\b.*\bset\b',
    r'\bdelete\b.*\bfrom\b',
    r'\bdrop\b.*\btable\b',
    r'\balter\b.*\btable\b',
    r'\bcreate\b.*\btable\b',
    r'--',
    r'\/\*',
    r'\*\/',
    r'\bor\b.*=.*\bor\b',
    r'\band\b.*=.*\band\b',
    r"'.*'.*=.*'.*'",
    r'".*".*=.*".*"',
  ];

  // Inappropriate content patterns (basic)
  static const List<String> _inappropriatePatterns = [
    r'\b(profanity|inappropriate)\b', // Placeholder - implement proper content filtering
  ];

  /// Validate query for security and appropriateness
  Future<QueryValidationResult> validateQuery(String query) async {
    final errors = <String>[];
    final warnings = <String>[];

    // Basic validation
    if (query.isEmpty) {
      errors.add('Query cannot be empty');
    }

    if (query.length > 1000) {
      errors.add('Query too long (maximum 1000 characters)');
    }

    if (query.length < 2) {
      warnings.add('Query very short, may not provide good results');
    }

    // Security validation
    final securityIssues = await _checkSecurityPatterns(query);
    errors.addAll(securityIssues);

    // Content appropriateness
    final contentIssues = await _checkContentAppropriateness(query);
    warnings.addAll(contentIssues);

    // Character encoding validation
    if (!_isValidEncoding(query)) {
      errors.add('Invalid character encoding detected');
    }

    // Rate limiting check (placeholder)
    if (!await _checkRateLimit()) {
      errors.add(
        'Rate limit exceeded, please wait before submitting another query',
      );
    }

    return QueryValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      sanitizedQuery: sanitizeQuery(query),
    );
  }

  /// Sanitize query by removing/escaping dangerous content
  String sanitizeQuery(String query) {
    String sanitized = query;

    // Remove null bytes and control characters
    sanitized = sanitized.replaceAll(
      RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'),
      '',
    );

    // Remove malicious patterns
    for (final pattern in _maliciousPatterns) {
      sanitized = sanitized.replaceAll(
        RegExp(pattern, caseSensitive: false),
        '',
      );
    }

    // Remove SQL injection patterns
    for (final pattern in _sqlInjectionPatterns) {
      sanitized = sanitized.replaceAll(
        RegExp(pattern, caseSensitive: false),
        '',
      );
    }

    // Escape HTML entities
    sanitized = _escapeHtml(sanitized);

    // Normalize whitespace
    sanitized = sanitized.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Limit length
    if (sanitized.length > 1000) {
      sanitized = sanitized.substring(0, 1000);
    }

    return sanitized;
  }

  /// Check for security-related patterns
  Future<List<String>> _checkSecurityPatterns(String query) async {
    final issues = <String>[];

    // Check for script injections
    for (final pattern in _maliciousPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(query)) {
        issues.add('Potentially malicious content detected');
        break;
      }
    }

    // Check for SQL injection attempts
    for (final pattern in _sqlInjectionPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(query)) {
        issues.add('SQL injection attempt detected');
        break;
      }
    }

    // Check for excessive special characters
    final specialCharCount =
        RegExp(r'[^\w\s\u0600-\u06FF]').allMatches(query).length;
    if (specialCharCount > query.length * 0.3) {
      issues.add('Excessive special characters detected');
    }

    // Check for repeated characters (potential abuse)
    if (RegExp(r'(.)\1{10,}').hasMatch(query)) {
      issues.add('Excessive character repetition detected');
    }

    return issues;
  }

  /// Check content appropriateness
  Future<List<String>> _checkContentAppropriateness(String query) async {
    final warnings = <String>[];

    // Check for inappropriate content patterns
    for (final pattern in _inappropriatePatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(query)) {
        warnings.add('Potentially inappropriate content detected');
        break;
      }
    }

    // Check for non-Islamic content in Islamic context
    if (_containsNonIslamicReligiousContent(query)) {
      warnings.add('Non-Islamic religious content detected');
    }

    return warnings;
  }

  /// Check if string has valid character encoding
  bool _isValidEncoding(String query) {
    try {
      // Try to encode and decode to check for encoding issues
      final bytes = utf8.encode(query);
      final decoded = utf8.decode(bytes);
      return decoded == query;
    } catch (e) {
      return false;
    }
  }

  /// Rate limiting check (placeholder implementation)
  Future<bool> _checkRateLimit() async {
    // In a real implementation, this would check against a rate limiting service
    // For now, always return true
    return true;
  }

  /// Escape HTML entities
  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;');
  }

  /// Check for non-Islamic religious content
  bool _containsNonIslamicReligiousContent(String query) {
    final nonIslamicTerms = [
      'jesus',
      'christ',
      'christian',
      'bible',
      'church',
      'buddha',
      'buddhist',
      'dharma',
      'karma',
      'hindu',
      'krishna',
      'rama',
      'shiva',
      'brahma',
      'jewish',
      'judaism',
      'torah',
      'synagogue',
      'sikh',
      'guru',
      'gurdwara',
    ];

    final lowerQuery = query.toLowerCase();
    return nonIslamicTerms.any((term) => lowerQuery.contains(term));
  }

  /// Validate language code
  bool isValidLanguageCode(String languageCode) {
    const validCodes = ['en', 'ar', 'ur', 'id'];
    return validCodes.contains(languageCode);
  }

  /// Check if query is likely spam
  bool isSpamLike(String query) {
    // Check for spam indicators
    final spamIndicators = [
      query.length > 500 &&
          RegExp(r'(.{10,})\1{3,}').hasMatch(query), // Repetitive content
      RegExp(r'https?://').allMatches(query).length > 2, // Multiple URLs
      RegExp(r'[A-Z]{5,}').allMatches(query).length > 3, // Excessive caps
      RegExp(r'[!?]{3,}').hasMatch(query), // Excessive punctuation
    ];

    return spamIndicators.any((indicator) => indicator);
  }

  /// Extract and validate email addresses (if any)
  List<String> extractEmails(String query) {
    final emailRegex = RegExp(
      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
    );
    return emailRegex
        .allMatches(query)
        .map((match) => match.group(0)!)
        .toList();
  }

  /// Extract and validate URLs (if any)
  List<String> extractUrls(String query) {
    final urlRegex = RegExp(r'https?://[^\s]+');
    return urlRegex.allMatches(query).map((match) => match.group(0)!).toList();
  }

  /// Check if query contains PII (Personally Identifiable Information)
  bool containsPII(String query) {
    // Check for common PII patterns
    final piiPatterns = [
      RegExp(r'\b\d{3}-\d{2}-\d{4}\b'), // SSN pattern
      RegExp(
        r'\b\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}\b',
      ), // Credit card pattern
      RegExp(r'\b\d{3}[-.]?\d{3}[-.]?\d{4}\b'), // Phone number pattern
    ];

    return piiPatterns.any((pattern) => pattern.hasMatch(query));
  }
}

/// Result of query validation
class QueryValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final String sanitizedQuery;

  const QueryValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
    required this.sanitizedQuery,
  });

  /// Check if there are any security issues
  bool get hasSecurityIssues => errors.any(
        (error) =>
            error.contains('malicious') ||
            error.contains('injection') ||
            error.contains('security'),
      );

  /// Check if there are content warnings
  bool get hasContentWarnings => warnings.isNotEmpty;

  /// Get validation summary
  String get summary {
    if (isValid && warnings.isEmpty) return 'Valid';
    if (isValid && warnings.isNotEmpty) return 'Valid with warnings';
    return 'Invalid';
  }

  @override
  String toString() {
    return 'QueryValidationResult(isValid: $isValid, errors: ${errors.length}, warnings: ${warnings.length})';
  }
}
