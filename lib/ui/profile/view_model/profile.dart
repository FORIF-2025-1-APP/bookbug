import 'package:bookbug/ui/core/ui/badgebutton_base.dart';
import 'package:bookbug/ui/core/ui/iconbutton_base.dart';
import 'package:bookbug/ui/profile/view_model/profile_edit.dart';
import 'package:flutter/material.dart';
import 'package:bookbug/ui/core/ui/profileimage_Base.dart';
import 'package:bookbug/ui/core/ui/bookcomponent_base.dart';
import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:bookbug/ui/profile/view_model/profile_edit.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    String name = 'hanyang';
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Text('Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Row(
              children: [
                CircleIconButton(
                  // iconbuttonbase 위젯
                  icon: Icons.bookmark,
                  size: 40,
                  iconSize: 20,
                  onPressed: () {},
                ),
                SizedBox(width: 8),
                CircleIconButton(
                  icon: Icons.dark_mode,
                  size: 40,
                  iconSize: 20,
                  onPressed: () {},
                ),
                SizedBox(width: 8),
                CircleIconButton(
                  icon: Icons.logout,
                  size: 40,
                  iconSize: 20,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Center(
                child: ProfileimageBase(
                  image: 'assets/hyu.jpeg',
                  badge: 'assets/hyu.jpeg',
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  name,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileEdit()),
                    );
                  },
                  child: Text('수정하기'), // 임시 배치, 위치, 모양 등 정해야함
                ),
              ),
              Center(
                child: Row(
                  children: [
                    Expanded(child: booksection(context, '최애 책')),
                    Expanded(child: badgesection(context, '뱃지(0)')),
                  ],
                ),
              ),
              reviewsection(context, '작성한 리뷰'),
              reviewsection(context, '좋아요한 리뷰'),
            ],
          ),
        ),
      ),
    );
  }

  Widget booksection(BuildContext context, String title) {
    // 예시 도서 데이터
    final Map<String, dynamic> book = {
      'title': 'Book',
      'author': 'Author',
      'rating': 3.5,
      'imageUrl': 'https://via.placeholder.com/150x200',
    };
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: 260,
              width: 160,
              child: BookCard(
                title: book['title'],
                author: book['author'],
                rating: book['rating'],
                imageUrl: book['imageUrl'],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget badgesection(BuildContext context, String title) {
    String badge = 'assets/hyu.jpeg';
    // 예시 도서 데이터
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              height: 260,
              width: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFF0EFE1),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: BadgebuttonBase(badge: badge, badgename: 'HYU'),
                  ),
                  Spacer(), // 끝 배치
                  SizedBox(
                    height: 50,
                    width: double.infinity, //부모 container에 맞춤
                    child: TextButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Text('더보기'),
                          Spacer(),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget reviewsection(BuildContext context, String title) {
    final List<Map<String, String>> reviews = [
      {
        'nickname': 'nickname',
        'title': 'title',
        'content': 'content',
        'leadingText': 'A',
        'trailingText': '30',
      },
      {
        'nickname': 'nickname',
        'title': 'title',
        'content': 'content',
        'leadingText': 'A',
        'trailingText': '100+',
      },
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return ListItem(
                nickname: review['nickname'] ?? '',
                title: review['title'] ?? '',
                content: review['content'] ?? '',
                leadingText: review['leadingText'],
                leadingImageUrl: review['leadingImageUrl'],
                trailingText: review['trailingText'] ?? '',
                onTap: () {},
              );
            },
          ),
          SizedBox(
            height: 40,
            child: TextButton(
              onPressed: () {},
              child: Row(
                children: [Text('더보기'), Spacer(), Icon(Icons.arrow_forward)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
