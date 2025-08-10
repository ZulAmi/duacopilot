/// Custom exceptions for API interactions
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? details;

  const ApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() => 'ApiException: $message';
}

/// General API exception for unexpected errors
class GeneralApiException extends ApiException {
  const GeneralApiException(
    String message, {
    int? statusCode,
    Map<String, dynamic>? details,
  }) : super(message, statusCode: statusCode, details: details);
}

/// 400 Bad Request
class BadRequestException extends ApiException {
  const BadRequestException(String message) : super(message, statusCode: 400);
}

/// 401 Unauthorized
class UnauthorizedException extends ApiException {
  const UnauthorizedException(String message) : super(message, statusCode: 401);
}

/// 403 Forbidden
class ForbiddenException extends ApiException {
  const ForbiddenException(String message) : super(message, statusCode: 403);
}

/// 404 Not Found
class NotFoundException extends ApiException {
  const NotFoundException(String message) : super(message, statusCode: 404);
}

/// 429 Rate Limit Exceeded
class RateLimitException extends ApiException {
  const RateLimitException(String message) : super(message, statusCode: 429);
}

/// 500 Internal Server Error
class ServerException extends ApiException {
  const ServerException(String message) : super(message, statusCode: 500);
}

/// Network connectivity issues
class NetworkException extends ApiException {
  const NetworkException(String message) : super(message);
}

/// Timeout exceptions
class TimeoutException extends ApiException {
  const TimeoutException(String message) : super(message);
}

/// Cache-related exceptions
class CacheException extends ApiException {
  const CacheException(String message) : super(message);
}

/// Storage-related exceptions
class StorageException extends ApiException {
  const StorageException(String message) : super(message);
}
