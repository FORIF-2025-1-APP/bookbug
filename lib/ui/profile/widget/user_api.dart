// lib/api/user_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'usermodel.dart';
import 'dart:io';

Future<User> getUserProfile(String token) async {
  final response = await http.get(
    Uri.parse(
      'https://forifbookbugapi.seongjinemong.app/api/user',
    ), // 여기에 실제 API 주소 입력
    headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    return User.fromJson(json.decode(response.body));
  } else if (response.statusCode == 401) {
    throw Exception('로그인이 필요합니다.');
  } else {
    throw Exception('유저 정보를 불러오지 못했습니다.');
  }
}

Future<void> uploadProfileImage(String token, File imageFile) async {
  // 1) File → bytes → Base64
  final bytes = await imageFile.readAsBytes();
  final base64Image = base64Encode(bytes);

  // 2) 요청 URI, 헤더, 바디 준비
  final uri = Uri.parse('https://forifbookbugapi.seongjinemong.app/api/user');
  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  final body = jsonEncode({'image': base64Image});

  // 3) PATCH 요청
  final resp = await http.patch(uri, headers: headers, body: body);

  // 4) 응답 처리
  if (resp.statusCode == 200) {
    // 성공
    return;
  } else if (resp.statusCode == 401) {
    throw Exception('인증 실패: 로그인 상태를 확인하세요.');
  } else {
    throw Exception('이미지 업로드 실패: ${resp.statusCode} ${resp.body}');
  }
}
