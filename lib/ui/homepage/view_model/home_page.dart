import 'package:bookbug/ui/book/view_model/review_write_page.dart';
import 'package:flutter/material.dart';
import 'package:bookbug/ui/book/view_model/book_detail_page.dart';
import 'package:bookbug/ui/profile/view_model/profile.dart';
import 'package:bookbug/ui/login/view_model/login_page.dart';
import 'package:bookbug/ui/core/ui/bookcomponent_base.dart';
import 'package:bookbug/ui/core/ui/iconbutton_base.dart';
import 'package:bookbug/ui/lists/view_model/notifications_page.dart';
import 'package:bookbug/ui/search/view_model/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ReviewWritePage()),
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
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
    final List<Map<String, dynamic>> books = List.generate(10, (_) => {
      'title': 'Book Title',
      'author': 'Author',
      'rating': 4.0,
      'imageUrl': 'https://via.placeholder.com/150x200',
    });

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
                  title: book['title'],
                  author: book['author'],
                  rating: book['rating'],
                  imageUrl: book['imageUrl'],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailPage(bookId: book['id']),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
