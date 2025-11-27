import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const _key = 'access_token';
  static const _refresh = 'refresh_token';
  static final _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _key, value: token);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _key);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refresh);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _key);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
