import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:bookbug/ui/book/view_model/review_write_page.dart';
import 'package:bookbug/ui/book/view_model/book_detail_page.dart';
import 'package:bookbug/ui/profile/view_model/profile.dart';
import 'package:bookbug/ui/core/ui/bookcomponent_base.dart';
import 'package:bookbug/ui/core/ui/iconbutton_base.dart';
import 'package:bookbug/ui/lists/view_model/notifications_page.dart';
import 'package:bookbug/ui/home/view_model/search_page.dart';
import 'package:bookbug/ui/home/widgets/bottomnavigationbar_widget.dart';

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({super.key, required this.token});
  final String baseUrl = 'https://forifbookbugapi.seongjinemong.app';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Future<List<BookCard>> _futureBooks;

  @override
  void initState() {
    super.initState();
    _futureBooks = fetchBooks();
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewWritePage(token: widget.token),
        ),
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<List<BookCard>> fetchBooks() async {
    if (widget.token.isEmpty) {
      throw Exception('토큰이 없습니다. 로그인 상태를 확인해주세요.');
    }

    final uri = Uri.parse('${widget.baseUrl}/api/books/filtered');
    print('[DEBUG] 요청 URI: $uri');

    final response = await http.get(
      uri,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    print('[DEBUG] 응답 코드: ${response.statusCode}');
    print('[DEBUG] 응답 내용: ${response.body}');

    if (response.statusCode == 200) {
      final dynamic result = jsonDecode(response.body);
      List<dynamic> rawItems = [];

      // JSON 구조 디버깅 정보 출력
      print('[DEBUG] result 타입: ${result.runtimeType}');
      if (result is Map<String, dynamic>) {
        result.forEach((key, value) {
          print('[DEBUG] key=\$key, valueType=${value.runtimeType}');
        });

        if (result['items'] is List) {
          rawItems = result['items'];
        } else if (result['data'] is Map<String, dynamic> && result['data']['items'] is List) {
          rawItems = result['data']['items'];
        } else {
          // 첫 번째 List 값을 자동 추출
          rawItems = result.values.firstWhere(
            (v) => v is List<dynamic>,
            orElse: () => <dynamic>[],
          );
        }
      } else if (result is List) {
        rawItems = result;
      }

      if (rawItems.isEmpty) {
        throw Exception('API 응답 형식이 예상과 다릅니다');
      }

      final count = rawItems.length < 9 ? rawItems.length : 9;
      final sliced = rawItems.sublist(0, count);
      return sliced.map((json) => BookCard.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('인증이 필요합니다. 토큰을 확인해주세요.');
    } else if (response.statusCode == 400) {
      throw Exception('잘못된 요청입니다. 쿼리 파라미터를 확인해주세요.');
    }

    return [];
  }

  PreferredSizeWidget? _buildAppBar() {
    switch (_selectedIndex) {
      case 0:
        return AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CircleIconButton(
                icon: Icons.search,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(token: widget.token),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CircleIconButton(
                icon: Icons.notifications,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsPage(),
                  ),
                ),
              ),
            ),
          ],
        );
      case 1:
      case 2:
        return null;
      default:
        return AppBar(title: const Text('오류'));
    }
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return FutureBuilder<List<BookCard>>(
          future: _futureBooks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('오류: ${snapshot.error}'));
            }

            final books = snapshot.data ?? [];
            if (books.isEmpty) {
              return const Center(child: Text('책이 없습니다.'));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.6,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return BookCard(
                    id: book.id,
                    title: book.title,
                    author: book.author,
                    rating: book.rating,
                    imageUrl: book.imageUrl,
                    onTap: () {
                      print('[DEBUG] Navigating to BookDetailPage with isbn: ${book.id}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookDetailPage(
                            bookId: book.id,
                            token: widget.token,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      case 2:
        return const Profile();
      default:
        return const Center(child: Text('페이지 없음'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
