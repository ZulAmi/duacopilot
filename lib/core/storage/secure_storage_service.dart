// import 'package:flutter_secure_storage/flutter_secure_storage.dart';  // Temporarily disabled

/// Mock implementation of SecureStorageService for development
/// This uses in-memory storage and is NOT secure - only for development purposes
class SecureStorageService {
  // final FlutterSecureStorage _secureStorage;  // Temporarily disabled

  // Mock in-memory storage (NOT SECURE - for development only)
  static final Map<String, String> _mockStorage = <String, String>{};

  // SecureStorageService(this._secureStorage);  // Temporarily disabled
  SecureStorageService([
    dynamic mockStorage,
  ]); // Accept any parameter for compatibility

  // API Token Management
  Future<void> saveApiToken(String token) async {
    // await _secureStorage.write(key: 'api_token', value: token);  // Original
    _mockStorage['api_token'] = token; // Mock implementation
  }

  Future<String?> getApiToken() async {
    // return await _secureStorage.read(key: 'api_token');  // Original
    return _mockStorage['api_token']; // Mock implementation
  }

  Future<void> deleteApiToken() async {
    // await _secureStorage.delete(key: 'api_token');  // Original
    _mockStorage.remove('api_token'); // Mock implementation
  }

  // RAG API Configuration
  Future<void> saveRagApiUrl(String url) async {
    // await _secureStorage.write(key: 'rag_api_url', value: url);  // Original
    _mockStorage['rag_api_url'] = url; // Mock implementation
  }

  Future<String?> getRagApiUrl() async {
    // return await _secureStorage.read(key: 'rag_api_url');  // Original
    return _mockStorage['rag_api_url']; // Mock implementation
  }

  // User Credentials
  Future<void> saveUserCredentials(String username, String password) async {
    // await _secureStorage.write(key: 'username', value: username);  // Original
    // await _secureStorage.write(key: 'password', value: password);  // Original
    _mockStorage['username'] = username; // Mock implementation
    _mockStorage['password'] = password; // Mock implementation
  }

  Future<Map<String, String?>> getUserCredentials() async {
    // final username = await _secureStorage.read(key: 'username');  // Original
    // final password = await _secureStorage.read(key: 'password');  // Original
    final username = _mockStorage['username']; // Mock implementation
    final password = _mockStorage['password']; // Mock implementation
    return {'username': username, 'password': password};
  }

  Future<void> deleteUserCredentials() async {
    // await _secureStorage.delete(key: 'username');  // Original
    // await _secureStorage.delete(key: 'password');  // Original
    _mockStorage.remove('username'); // Mock implementation
    _mockStorage.remove('password'); // Mock implementation
  }

  // Generic methods
  Future<void> saveValue(String key, String value) async {
    // await _secureStorage.write(key: key, value: value);  // Original
    _mockStorage[key] = value; // Mock implementation
  }

  Future<String?> getValue(String key) async {
    // return await _secureStorage.read(key: key);  // Original
    return _mockStorage[key]; // Mock implementation
  }

  Future<void> deleteValue(String key) async {
    // await _secureStorage.delete(key: key);  // Original
    _mockStorage.remove(key); // Mock implementation
  }

  Future<void> clearAll() async {
    // await _secureStorage.deleteAll();  // Original
    _mockStorage.clear(); // Mock implementation
  }
}
