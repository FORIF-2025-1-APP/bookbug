import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:flutter/material.dart';
import 'package:bookbug/ui/book/view_model/book_review_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WroteListPage extends StatefulWidget {
  final String token;

  const WroteListPage({super.key, required this.token});

  @override
  State<WroteListPage> createState() => _WroteListPageState();
}

class _WroteListPageState extends State<WroteListPage> {
  final String baseUrl = 'https://forifbookbugapi.seongjinemong.app';

  Future<List<dynamic>> fetchReviews() async {
    final profileUrl = Uri.parse('$baseUrl/api/user');
    final profileResponse = await http.get(
      profileUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}'
      },
    );

    final decodedData = jsonDecode(profileResponse.body);
    final String userId = decodedData['id'];

    final url = Uri.parse('$baseUrl/api/reviews/user/$userId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}'
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('리뷰 데이터를 불러오지 못했습니다: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: colorScheme.onSurface,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '내가 쓴 리뷰',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          } else {
            final reviews = snapshot.data!;
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ListItem(
                  nickname: review['author']['username'] ?? '',
                  title: review['title'] ?? '',
                  content: review['description'] ?? '',
                  leadingText: (review['author']['username'] ?? 'U')[0].toUpperCase(),
                  trailingText: '${review['_count']['likedBy'] ?? 0}',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookReviewDetailPage(
                          reviewId: (review.id).toString(),
                          bookId: (review.bookId).toString(),
                          token: widget.token
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