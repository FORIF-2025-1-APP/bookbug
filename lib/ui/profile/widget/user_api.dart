// user_api.dart
import 'dart:io';
import 'package:bookbug/ui/profile/widget/usermodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<User> getUserProfile(String token) async {
  // 예시 URL: /api/user/profile
  final response = await http.get(
    Uri.parse('https://forifbookbugapi.seongjinemong.app/api/user'),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    return User.fromJson(json.decode(response.body));
  } else {
    throw Exception('프로필 정보를 가져오지 못했습니다.');
  }
}

Future<void> updateUserProfile({
  required String token,
  String? password,
  // 그 외 수정 가능한 필드 있으면 파라미터에 추가
}) async {
  final body = <String, dynamic>{};
  if (password != null && password.isNotEmpty) {
    body['password'] = password;
  }
  // 그 외 수정 가능한 필드가 있다면 body에 추가

  final response = await http.put(
    Uri.parse('https://forifbookbugapi.seongjinemong.app/api/user'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode(body),
  );
  if (response.statusCode != 200) {
    throw Exception('프로필 업데이트에 실패했습니다.');
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
