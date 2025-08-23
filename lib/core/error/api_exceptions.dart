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
  const GeneralApiException(super.message, {super.statusCode, super.details});
}

/// 400 Bad Request
class BadRequestException extends ApiException {
  const BadRequestException(super.message) : super(statusCode: 400);
}

/// 401 Unauthorized
class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.message) : super(statusCode: 401);
}

/// 403 Forbidden
class ForbiddenException extends ApiException {
  const ForbiddenException(super.message) : super(statusCode: 403);
}

/// 404 Not Found
class NotFoundException extends ApiException {
  const NotFoundException(super.message) : super(statusCode: 404);
}

/// 429 Rate Limit Exceeded
class RateLimitException extends ApiException {
  const RateLimitException(super.message) : super(statusCode: 429);
}

/// 500 Internal Server Error
class ServerException extends ApiException {
  const ServerException(super.message) : super(statusCode: 500);
}

/// Network connectivity issues
class NetworkException extends ApiException {
  const NetworkException(super.message);
}

/// Timeout exceptions
class TimeoutException extends ApiException {
  const TimeoutException(super.message);
}

/// Cache-related exceptions
class CacheException extends ApiException {
  const CacheException(super.message);
}

/// Storage-related exceptions
class StorageException extends ApiException {
  const StorageException(super.message);
}
