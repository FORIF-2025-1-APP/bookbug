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
import 'package:english_words/english_words.dart';

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({super.key, required this.token});
  final String baseUrl = 'https://forifbookbugapi.seongjinemong.app';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReviewWritePage(token: widget.token)),
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  Future<List<BookCard>> fetchBooks(String type, {String query = ''}) async {
    if (widget.token.isEmpty) {
      throw Exception('토큰이 없습니다. 로그인 상태를 확인해주세요.');
    }

    final uri = Uri.parse(
      'https://forifbookbugapi.seongjinemong.app/api/books?type=$type&query=$query'
    );

    print("[DEBUG] 최종 요청 URI: $uri");
    print("[DEBUG] 전달된 type 값: $type");

    final response = await http.get(
      uri,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}'
      },
    );

    print("[DEBUG] 응답 상태 코드: ${response.statusCode}");
    print('[DEBUG] 응답 내용: ${response.body}');

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      if (jsonMap is Map<String, dynamic> && jsonMap['items'] is List) {
        final List<dynamic> booksJson = jsonMap['items'];
        return booksJson.map((json) => BookCard.fromJson(json)).toList();
      } else {
        throw Exception("API 응답 형식이 예상과 다릅니다");
      }
    } else if (response.statusCode == 401) {
      throw Exception('인증이 필요합니다. 토큰을 확인해주세요.');
    } else if (response.statusCode == 400) {
      throw Exception('잘못된 요청입니다. 쿼리 파라미터를 확인해주세요.');
    } else {
      throw Exception('책 데이터를 불러오는 데 실패했습니다 ($type)');
    }
  }


  PreferredSizeWidget? _buildAppBar() {
    switch (_selectedIndex) {
      case 0:
        return AppBar(
          // title: const Text('Home'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CircleIconButton(
                icon: Icons.search,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage(token: widget.token)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CircleIconButton(
                icon: Icons.notifications,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsPage()),
                ),
              ),
            ),
          ],
        );
      case 1:
        return null;
      case 2:
        return null;
      default:
        return AppBar(title: const Text('오류'));
    }
  }

  Widget _buildBody() {
  switch (_selectedIndex) {
    case 0:
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              String query = generateRandomWord();
              return FutureBuilder<List<BookCard>>(
                future: fetchBooks('recommendation', query: query),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('오류: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('책이 없습니다.'));
                  }

                  final books = snapshot.data!;
                  final book = books[index % books.length];
                  return Container(
                    decoration: BoxDecoration(
                    ),
                    child: BookCard(
                      id: book.id,
                      title: book.title,
                      author: book.author,
                      rating: book.rating,
                      imageUrl: book.imageUrl,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailPage(
                            bookId: book.id,
                            token: widget.token,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      );
    case 2:
      return const Profile();
    default:
      return const Center(child: Text('페이지 없음'));
  }
}



  String generateRandomWord() {
    final word = WordPair.random().first;
    return word.toLowerCase();
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
