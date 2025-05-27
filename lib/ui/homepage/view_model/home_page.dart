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

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    late Future<List<BookCard>> booksFuture;
    int _selectedIndex = 0;

    @override
    void initState() {
        super.initState();
        booksFuture = fetchBooks();
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

    Future<List<BookCard>> fetchBooks() async {
    final response = await http.get(
        Uri.parse('https://forifbookbugapi.seongjinemong.app/api/books'),
        headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}'
        },
    );

    if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        print(jsonList);
        return jsonList.map((json) => BookCard.fromJson(json)).toList();
            } else {
                throw Exception('책 데이터를 불러오는 데 실패했습니다');
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
                        MaterialPageRoute(builder: (context) => const SearchPage()),
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
                _buildBookSection('주간 Top 10'),
                _buildBookSection('추천 도서'),
                _buildBookSection('월간 Top 10'),
            ],
        );
        case 2:
        return const Profile();
        default:
        return const Center(child: Text('페이지 없음'));
        }
    }

    Widget _buildBookSection(String title) {
        return FutureBuilder<List<BookCard>>(
            future: booksFuture,
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
