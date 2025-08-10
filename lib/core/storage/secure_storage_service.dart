import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _secureStorage;

  SecureStorageService(this._secureStorage);

  // API Token Management
  Future<void> saveApiToken(String token) async {
    await _secureStorage.write(key: 'api_token', value: token);
  }

  Future<String?> getApiToken() async {
    return await _secureStorage.read(key: 'api_token');
  }

  Future<void> deleteApiToken() async {
    await _secureStorage.delete(key: 'api_token');
  }

  // RAG API Configuration
  Future<void> saveRagApiUrl(String url) async {
    await _secureStorage.write(key: 'rag_api_url', value: url);
  }

  Future<String?> getRagApiUrl() async {
    return await _secureStorage.read(key: 'rag_api_url');
  }

  // User Credentials
  Future<void> saveUserCredentials(String username, String password) async {
    await _secureStorage.write(key: 'username', value: username);
    await _secureStorage.write(key: 'password', value: password);
  }

  Future<Map<String, String?>> getUserCredentials() async {
    final username = await _secureStorage.read(key: 'username');
    final password = await _secureStorage.read(key: 'password');
    return {'username': username, 'password': password};
  }

  Future<void> deleteUserCredentials() async {
    await _secureStorage.delete(key: 'username');
    await _secureStorage.delete(key: 'password');
  }

  // Generic methods
  Future<void> saveValue(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getValue(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteValue(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
