import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  String? _token;

  String? get token => _token;

  // 로그인 후 token 설정
  Future<void> setToken(String? token) async {
    _token = token;
    if (token != null) {
      print('[DEBUG] 저장할 토큰: $token');
      await storage.write(key: 'auth_token', value: token);
    }
    notifyListeners();
  }

  // 로그아웃
  Future<void> logout() async {
    _token = null;
    await storage.delete(key: 'auth_token');
    notifyListeners();
  }

  // 토큰을 가져오기
  Future<void> getTokenFromStorage() async {
    _token = await storage.read(key: 'auth_token');
    notifyListeners();
  }
}
