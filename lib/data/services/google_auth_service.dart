import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>?> signInWithGoogle(String apiBaseUrl) async {
  try {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      throw Exception('Google idToken is null');
    }

    final url = Uri.parse('$apiBaseUrl/api/auth/google');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Google login failed: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('[GoogleLogin Error] $e'); // 로깅 추가
    rethrow;
  }
  }
}
