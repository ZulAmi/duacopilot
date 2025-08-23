// Custom exceptions for the application

abstract class Failure implements Exception {
  final String message;
  const Failure(this.message);
}

/// ServerFailure class implementation
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// NetworkFailure class implementation
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// CacheFailure class implementation
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// Exceptions for data sources
/// ServerException class implementation
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

/// NetworkException class implementation
class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}

/// CacheException class implementation
class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}
