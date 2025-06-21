import 'package:bookbug/ui/lists/widgets/empty_review_message.dart';
import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:flutter/material.dart';
import 'package:bookbug/ui/book/view_model/book_review_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LinkedListPage extends StatefulWidget {
  final String token;

  const LinkedListPage({super.key, required this.token});

  @override
  State<LinkedListPage> createState() => _LinkedListPageState();
}

class _LinkedListPageState extends State<LinkedListPage> {
  final String baseUrl = 'https://forifbookbugapi.seongjinemong.app';

  Future<List<dynamic>> fetchReviews() async {
    final url = Uri.parse('$baseUrl/api/user');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}'
      },
    );
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final String likedList = decodedData['likedReviews'];
      return jsonDecode(likedList);
    } else {
      throw Exception('데이터를 불러오지 못했습니다: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('좋아요한 리뷰', style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          } else {
            final likedReviews = snapshot.data!;
            if (likedReviews.isEmpty) {
              return const EmptyReviewMessage(message: '좋아요한 리뷰가 아직 없어요');
            }
            return ListView.builder(
              itemCount: likedReviews.length,
              itemBuilder: (context, index) {
                final review = likedReviews[index];
                return ListItem(
                  nickname: review['author']['username'],
                  title: review['title'],
                  content: review['description'],
                  trailingText: review['createdAt'],
                  leadingText: review['author']['username']
                      ? review['author']['username'].toUpperCase()
                      : '',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookReviewDetailPage(
                          reviewId: review['id'],
                          bookId: review['bookId'],
                          token: widget.token//wjd
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}