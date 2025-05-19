import 'package:bookbug/ui/lists/view_model/badge_list_page.dart';
import 'package:bookbug/ui/lists/view_model/notifications_page.dart';
import 'package:bookbug/ui/lists/view_model/toread_list_page.dart';
import 'package:bookbug/ui/search/view_model/search_page.dart';
import 'package:bookbug/ui/start/view_model/start_page.dart';
import 'package:bookbug/ui/lists/view_model/wrote_list_page.dart';
import 'package:flutter/material.dart';
import './ui/core/themes/theme.dart';
import 'ui/core/ui/bookcomponent_base.dart';
import 'ui/core/ui/iconbutton_base.dart';
import 'package:bookbug/ui/lists/view_model/linked_list_page.dart';

void main() {
  runApp(const MyApp());
}

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 테마 색상 사용 예시
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('도서 리뷰'),
        actions: [
          CircleIconButtonRow(
            buttons: [
              CircleIconButton(
                icon: Icons.bookmark_border,
                onPressed: () => print('북마크 버튼 클릭'),
                iconSize: 24,
                iconColor: Colors.green[900],
                // 색상을 명시적으로 지정하지 않으면 테마 색상이 자동으로 적용됩니다
              ),
              CircleIconButton(
                icon: Icons.nightlight_round,
                onPressed: () => print('다크모드 버튼 클릭'),
                iconSize: 24,
                iconColor: Colors.green[900],
                // 원하는 경우 개별 버튼에 커스텀 색상 적용 가능
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
              CircleIconButton(
                icon: Icons.logout,
                onPressed: () => print('로그아웃 버튼 클릭'),
                iconSize: 24,
                iconColor: Colors.green[900],
              ),
            ],
          ),
        ],
      ),
      body: const Center(child: Text('도서 리뷰 앱 본문')),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '책 리뷰 앱',
      theme: ThemeData(
        colorScheme:
            MediaQuery.platformBrightnessOf(context) == Brightness.dark
                ? MaterialTheme.darkScheme().toColorScheme()
                : MaterialTheme.lightScheme().toColorScheme(),
        fontFamily: 'Pretendard', // 한글 폰트
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Color(0xFF556B2F))),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          CircleIconButtonRow(
            buttons: [
              CircleIconButton(
                icon: Icons.search,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
                iconSize: 24,
                iconColor: Colors.green[900],
              ),
              CircleIconButton(
                icon: Icons.notifications,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationsPage()),
                  );
                },
                iconSize: 24,
                iconColor: Colors.green[900],
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildBookSection(context, '실시간 Top 10'),
          _buildBookSection(context, '실시간 Top 10'),
          _buildBookSection(context, '실시간 Top 10'),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StartPage(),
                  ),
                );
              }, 
            child: const Text('시작 빈 페이지'),
            ),
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BadgeListPage(),
                  ),
                );
              }, 
            child: const Text('뱃지 페이지'),
            ),
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LinkedListPage(),
                  ),
                );
              }, 
            child: const Text('좋아요한 리뷰'),
            ),
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WroteListPage(),
                  ),
                );
              }, 
            child: const Text('작성한 리뷰'),
            ),
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ToreadListPage(),
                  ),
                );
              }, 
            child: const Text('읽을 책 리스트'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF5F5DC),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Review'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildBookSection(BuildContext context, String title) {
    // 예시 도서 데이터
    final List<Map<String, dynamic>> books = [
      {
        'title': 'Book',
        'author': 'Author',
        'rating': 3.5,
        'imageUrl': 'https://via.placeholder.com/150x200',
      },
      {
        'title': 'Book',
        'author': 'Author',
        'rating': 3.5,
        'imageUrl': 'https://via.placeholder.com/150x200',
      },
      {
        'title': 'Book',
        'author': 'Author',
        'rating': 3.5,
        'imageUrl': 'https://via.placeholder.com/150x200',
      },
      {
        'title': 'Book',
        'author': 'Author',
        'rating': 3.5,
        'imageUrl': 'https://via.placeholder.com/150x200',
      },
      {
        'title': 'Book',
        'author': 'Author',
        'rating': 3.5,
        'imageUrl': 'https://via.placeholder.com/150x200',
      },
      {
        'title': 'Book',
        'author': 'Author',
        'rating': 3.5,
        'imageUrl': 'https://via.placeholder.com/150x200',
      },
      {
        'title': 'Book',
        'author': 'Author',
        'rating': 3.5,
        'imageUrl': 'https://via.placeholder.com/150x200',
      },
      {
        'title': 'Book',
        'author': 'Author',
        'rating': 3.5,
        'imageUrl': 'https://via.placeholder.com/150x200',
      },
      {
        'title': 'Book',
        'author': 'Author',
        'rating': 3.5,
        'imageUrl': 'https://via.placeholder.com/150x200',
      },
      {
        'title': 'Book',
        'author': 'Author',
        'rating': 3.5,
        'imageUrl': 'https://via.placeholder.com/150x200',
      },
      // 더 많은 책 정보 추가 가능
    ];

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
          height: 280, // BookCard 위젯 높이에 맞게 조정
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) {
              final book = books[index];
              return SizedBox(
                width: 160,
                child: BookCard(
                  title: book['title'],
                  author: book['author'],
                  rating: book['rating'],
                  imageUrl: book['imageUrl'],
                  onTap: () {
                    // 책 상세 페이지로 이동
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void log(num num) {}
}
