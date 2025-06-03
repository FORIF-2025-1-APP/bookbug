import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:bookbug/ui/book/view_model/review_write_page.dart';
import 'package:bookbug/ui/book/view_model/book_detail_page.dart';
import 'package:bookbug/ui/profile/view_model/profile.dart';
import 'package:bookbug/ui/core/ui/bookcomponent_base.dart';
import 'package:bookbug/ui/core/ui/iconbutton_base.dart';
import 'package:bookbug/ui/lists/view_model/notifications_page.dart';
import 'package:bookbug/ui/search/view_model/search_page.dart';

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
          MaterialPageRoute(builder: (context) => ReviewWritePage(token: widget.token,)),
        );
        return;
      }

      setState(() {
        _selectedIndex = index;
      });
    }

    Future<List<BookCard>> fetchBooks(String type) async {
      final uri = Uri.parse(
        'https://forifbookbugapi.seongjinemong.app/api/books?type=$type'
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
        if (jsonMap is Map<String, dynamic> && jsonMap['books'] is List) {
          final List<dynamic> booksJson = jsonMap['books'];
          return booksJson.map((json) => BookCard.fromJson(json)).toList();
        } else {
          throw Exception("API 응답 형식이 예상과 다릅니다");
        }
      } else {
        throw Exception('책 데이터를 불러오는 데 실패했습니다 ($type)');
      }
    }

    PreferredSizeWidget? _buildAppBar() {
        switch (_selectedIndex) {
            case 0:
            return AppBar(
                title: const Text('Home'),
                actions: [
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CircleIconButton(
                    icon: Icons.search,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage(token: widget.token,)),
                        ),
                        iconSize: 24,
                        iconColor: Colors.green[900],
                        ),
                    ),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CircleIconButton(
                    icon: Icons.notifications,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationsPage()),
                        ),
                        iconSize: 24,
                        iconColor: Colors.green[900],
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
        return ListView(
            children: [
                _buildBookSection('주간 Top 10', 'weekly_top_10'),
                _buildBookSection('추천 도서', 'recommendation'),
                _buildBookSection('월간 Top 10', 'monthly_top_10'),
            ],
        );
        case 2:
        return const Profile();
        default:
        return const Center(child: Text('페이지 없음'));
        }
    }

    Widget _buildBookSection(String title, String type) {
        return FutureBuilder<List<BookCard>>(
            future: fetchBooks(type),
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                    return Center(child: Text('오류: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('책이 없습니다.'));
                }

                final books = snapshot.data!;
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                            child: Text(
                              title,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                        ),
                        SizedBox(
                            height: 280,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: books.length,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                itemBuilder: (context, index) {
                                    final book = books[index];
                                    return SizedBox(
                                        width: 160,
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
                                                      token: widget.token
                                                    ),
                                                ),
                                            ),
                                        ),
                                    );
                                },
                            ),
                        ),
                    ],
                );
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: _buildAppBar(),
            body: _buildBody(),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                backgroundColor: const Color(0xFFF5F5DC),
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
                items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.bookmark),
                        label: 'Home',
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.add),
                        label: 'Review',
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                    ),
                ],
            ),
        );
    }
}
