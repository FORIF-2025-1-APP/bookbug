import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/badge_model.dart';
import '../model/book_model.dart';
import '../model/review_model.dart';
import '../model/notification_model.dart';


class ApiService {
  static const baseUrl = 'https://forifbookbugapi.seongjinemong.app';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

  static Future<List<BadgeItem>> getBadgeList() async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/badges');
    final res = await http.get(url, headers: {'Authorization' : 'Bearer $token'});
    if (res.statusCode == 200) {
      final List<dynamic> list = jsonDecode(res.body);
      return list.map((e) => BadgeItem.fromJson(e)).toList();
    }
    throw Exception('뱃지 목록 불러오기 실패');
  }

  static Future<BadgeDetail> getBadgeDetail(int badgeId) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/badges/$badgeId');
    final res = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (res.statusCode == 200) {
      return BadgeDetail.fromJson(jsonDecode(res.body));
    }
    throw Exception('뱃지 상세 정보 불러오기 실패');
  }

  static Future<void> setMainBadge(int badgeId) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/badges/set_main');
    final res = await http.post(url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
      },
      body: jsonEncode({'badge_id': badgeId}),
    );
    if(res.statusCode != 200) {
      throw Exception('대표 뱃지 설정 실패');
    }
  }

  static Future<List<Book>> getToReadList() async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/books/toread');
    final res = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (res.statusCode == 200) {
      final List<dynamic> list = jsonDecode(res.body);
      return list.map((e) => Book.fromJson(e)).toList();
    }
    throw Exception('읽을 책 목록 불러오기 실패');
  }

  static Future<List<Review>> getMyReviews() async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/reviews/me');
    final res = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (res.statusCode == 200) {
      final List<dynamic> list = jsonDecode(res.body);
      return list.map((e) => Review.fromJson(e)).toList();
    }
    throw Exception('작성한 리뷰 불러오기 실패');
  }

  static Future<List<Review>> getLikedReviews() async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/reviews/liked');
    final res = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (res.statusCode == 200) {
      final List<dynamic> list = jsonDecode(res.body);
      return list.map((e) => Review.fromJson(e)).toList();
    }
    throw Exception('좋아요한 리뷰 불러오기 실패');
  }

  static Future<List<NotificationItem>> getNotifications() async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/notifications');
    final res = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (res.statusCode == 200) {
      final List<dynamic> list = jsonDecode(res.body);
      return list.map((e) => NotificationItem.fromJson(e)).toList();
    }
    throw Exception('알림 불러오기 실패');
  }

  static Future<void> markNotificationRead(int notificationId) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/notifications/$notificationId/read');
    final res = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (res.statusCode != 200) {
      throw Exception('알림 읽음 처리 실패');
    }
  }

  static Future<void> markAllNotificationsRead() async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/notifications/read_all');
    final res = await http.post(url, headers: {'Authorization': 'Bearer $token'});
    if (res.statusCode != 200) {
      throw Exception('모두 읽기 실패');
    }
  }

  static Future<void> deleteAllNotifications() async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/notifications/delete_all');
    final res = await http.post(url, headers: {'Authorization': 'Bearer $token'});
    if (res.statusCode != 200) {
      throw Exception('모두 삭제 실패');
    }
  }
}