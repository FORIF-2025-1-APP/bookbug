// user_api.dart
import 'dart:io';
import 'package:bookbug/ui/profile/widget/usermodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<User> getUserProfile(String token) async {
  final url = Uri.parse('https://forifbookbugapi.seongjinemong.app/api/user');
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode != 200) {
    throw Exception('유저 정보 가져오기 실패: ${response.statusCode}');
  }
  final data = jsonDecode(response.body);
  return User.fromJson(data);
}

Future<void> updateUserProfile({
  required String token,
  String? username,
  String? email,
  String? password,
}) async {
  final url = Uri.parse('https://forifbookbugapi.seongjinemong.app/api/user');
  final body = <String, dynamic>{};
  if (username != null) body['username'] = username;
  if (email != null) body['email'] = email;
  if (password != null) body['password'] = password;

  final response = await http.patch(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(body),
  );
  if (response.statusCode != 200) {
    throw Exception('프로필 업데이트 실패: ${response.statusCode}');
  }
}

Future<void> uploadProfileImage(String token, File imageFile) async {
  final uri = Uri.parse('https://forifbookbugapi.seongjinemong.app/api/user');
  final request = http.MultipartRequest('PATCH', uri);

  request.headers['Authorization'] = 'Bearer $token';

  final multipartFile = await http.MultipartFile.fromPath(
    'image',
    imageFile.path,
  );
  request.files.add(multipartFile);

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode != 200) {
    String serverMessage;
    try {
      final bodyJson = jsonDecode(response.body);
      serverMessage = bodyJson['message']?.toString() ?? response.body;
    } catch (_) {
      serverMessage = response.body;
    }
    throw Exception('이미지 업로드 실패: ${response.statusCode} / $serverMessage');
  }
}
