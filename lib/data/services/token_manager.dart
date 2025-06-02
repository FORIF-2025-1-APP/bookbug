import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _tokenKey = 'token';
  static const String _autoLoginKey = 'auto_login';

  // 자동 로그인 여부 저장
  static Future<void> setAutoLogin(bool enabled) async {
    await _storage.write(key: _autoLoginKey, value: enabled.toString());
  }

  static Future<bool> isAutoLoginEnabled() async {
    final value = await _storage.read(key: _autoLoginKey);
    return value == 'true';
  }

  // 토큰 저장
  static Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      print('토큰 저장 실패: $e');
    }
  }

  // 토큰 가져오기
  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      print('토큰 읽기 실패: $e');
      return null;
    }
  }

  // 토큰 삭제
  static Future<void> clearToken() async {
    try {
      await _storage.delete(key: _tokenKey);
    } catch (e) {
      print('토큰 삭제 실패: $e');
    }
  }

  // 모든 키 제거
  static Future<void> clearAll() async {
    try {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _autoLoginKey);
    } catch (e) {
      print('전체 삭제 실패: $e');
    }
  }
}
