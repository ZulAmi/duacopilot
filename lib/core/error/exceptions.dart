/// ServerException class implementation
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

/// CacheException class implementation
class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

/// NetworkException class implementation
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

/// ValidationException class implementation
class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}

/// AuthenticationException class implementation
class AuthenticationException implements Exception {
  final String message;
  AuthenticationException(this.message);
}

/// PermissionException class implementation
class PermissionException implements Exception {
  final String message;
  PermissionException(this.message);
}
