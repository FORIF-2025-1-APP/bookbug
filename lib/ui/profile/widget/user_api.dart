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
  String? name,
  String? email,
  String? password,
}) async {
  final url = Uri.parse('https://forifbookbugapi.seongjinemong.app/api/user');
  final body = <String, dynamic>{};
  if (name != null) body['name'] = name;
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
  final request = http.MultipartRequest(
    'POST',
    Uri.parse('https://forifbookbugapi.seongjinemong.app/api/user'),
  );
  request.headers['Authorization'] = 'Bearer $token';
  request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);
  if (response.statusCode != 200) {
    throw Exception('이미지 업로드에 실패했습니다.');
  }
}
