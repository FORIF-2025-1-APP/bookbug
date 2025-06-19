import 'package:flutter/material.dart';
import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:bookbug/ui/core/ui/tag_base.dart';
import 'package:bookbug/ui/book/view_model/book_review_list_page.dart';
import 'package:bookbug/ui/book/view_model/book_review_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookDetailPage extends StatefulWidget{
  final String bookId;
  final String token;
  const BookDetailPage({
    super.key,
    required this.bookId,
    required this.token
  });

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final String baseUrl = 'https://forifbookbugapi.seongjinemong.app';

  bool _isLoading = true;
  Map<String, dynamic>? _bookData;

  @override
  void initState() {
    super.initState();
    _fetchBookDetail();
  }

  Future<void> _fetchBookDetail() async {
    final url = Uri.parse('$baseUrl/api/books/${widget.bookId}');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _bookData = data;
          _isLoading = false;
        });
      } else {
        throw Exception('책 정보 불러오기 실패: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('책 정보를 불러오지 못했습니다.')),
      );
    }
  }

  Future<void> _addToBookmark() async {
    final url = Uri.parse('$baseUrl/api/books/readlist');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}'
        },
        body: jsonEncode({
          'bookId': widget.bookId, // 실제 책 ID 사용
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('북마크에 추가되었습니다!')),
        );
      } else {
        throw Exception('북마크 추가 실패: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('북마크 추가 중 오류가 발생했습니다.')),
      );
    }
  }

  Future<void> _setToFavoriteBook() async {
    final url = Uri.parse('$baseUrl/api/user/favorite-book');

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}'
        },
        body: jsonEncode({
          'bookId': widget.bookId,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('최애 책으로 설정되었습니다!')),
        );
      } else {
        throw Exception('최애 책 설정 실패: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('최애 책 설정 중 오류가 발생했습니다.')),
      );
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상세정보'),
        actions: [
          IconButton(
            onPressed: _setToFavoriteBook,
            icon: const Icon(Icons.collections_bookmark),
            tooltip: '최애 책 지정',
          ),
          IconButton(
            onPressed: _addToBookmark,
            icon: const Icon(Icons.bookmark),
            tooltip: '북마크',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _bookData == null
              ? Center(child: Text('책 정보를 불러올 수 없습니다.'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 132,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondaryContainer,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                              child: _bookData!['coverImage'] != null
                                  ? Image.network(_bookData!['coverImage'], width: 116, height: 163, fit: BoxFit.cover)
                                  : Placeholder(fallbackHeight: 163, fallbackWidth: 116),
                            ),
                            SizedBox(height: 20),
                            Text(
                              _bookData!['title'] ?? '',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Text(
                              _bookData!['author'] ?? '',
                              style: TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            if (_bookData!['tags'] != null && _bookData!['tags'] is List)
                              Wrap(
                                spacing: 4,
                                children: (_bookData!['tags'] as List<dynamic>).take(5).map((tag) {
                                  return TagBase(tagName: tag.toString());
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      reviewsection(context, '리뷰'),
                    ],
                  ),
                ),
    );
  }

  Widget reviewsection(BuildContext context, String title) {
    return FutureBuilder<http.Response>(
      future: http.get(
        Uri.parse('$baseUrl/api/reviews/book/${widget.bookId}&limit=2'),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('리뷰를 불러오는 중 오류가 발생했습니다.');
        } else if (!snapshot.hasData || snapshot.data!.statusCode != 200) {
          return Text('리뷰 데이터를 불러올 수 없습니다.');
        }

        final List<dynamic> jsonData = jsonDecode(snapshot.data!.body);
        if (jsonData.isEmpty) {
          return Text('아직 등록된 리뷰가 없습니다.');
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    '${jsonData.length}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: jsonData.length,
                itemBuilder: (context, index) {
                  final review = jsonData[index];
                  return ListItem(
                    nickname: review['user']['username'] ?? '',
                    title: review['title'] ?? '',//주의
                    content: review['content'] ?? '',
                    leadingText: review['user']['username'] != null && review['user']['username'].isNotEmpty
                        ? review['user']['username']
                        : '?',
                    trailingText: '${review['likeCount'] ?? 0}',//주의
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
              ),
              SizedBox(
                height: 40,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookReviewListPage(
                          bookId: widget.bookId,
                          token: widget.token
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: const [Text('더보기'), Spacer(), Icon(Icons.arrow_forward)],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}