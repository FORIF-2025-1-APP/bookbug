import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:bookbug/ui/book/view_model/book_review_detail_page.dart';

class BookReviewListPage extends StatefulWidget {
  final String bookId;
  final String token;

  const BookReviewListPage({super.key, required this.bookId, required this.token});

  @override
  State<BookReviewListPage> createState() => _BookReviewListPageState();
}

class _BookReviewListPageState extends State<BookReviewListPage> {
  final String baseUrl = 'https://forifbookbugapi.seongjinemong.app';

  String _sort = 'createdAt'; // 기본 정렬: 최신순
  final Map<String, String> _sortOptions = {
    'createdAt': '최신순',
    'likeCount': '추천순',
  };

  Future<List<dynamic>> fetchReviews() async {
    final url = Uri.parse('$baseUrl/api/reviews/book/${widget.bookId}&sort=$_sort');
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
    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰', style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _sort,
              items: _sortOptions.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _sort = value;
                  });
                }
              },
              icon: const Icon(Icons.sort, color: Colors.white),
              dropdownColor: Theme.of(context).colorScheme.surface,
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('리뷰를 불러오는 중 오류가 발생했습니다.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('이 책에 대한 리뷰가 아직 없어요'));
          }

          final reviews = snapshot.data!;
          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return ListItem(
                nickname: review['user']['username'] ?? '',
                title: review['title'] ?? '',
                content: review['content'] ?? '',
                trailingText: review['createdAt']?.substring(0, 10) ?? '',
                leadingText: (review['user']['username'] ?? 'U')[0].toUpperCase(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookReviewDetailPage(
                        bookId: widget.bookId,
                        reviewId: review['id'],
                        token: widget.token
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}