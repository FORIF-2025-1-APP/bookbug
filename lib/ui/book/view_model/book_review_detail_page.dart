import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:bookbug/ui/core/ui/bookinfo_base.dart';
import 'package:bookbug/ui/core/ui/tag_base.dart';
import 'package:bookbug/ui/core/ui/profileimage_base.dart';
import 'package:bookbug/ui/book/view_model/book_reply_list_page.dart';
import 'package:bookbug/ui/book/view_model/book_reply_detail_page.dart';
import 'package:bookbug/ui/book/widgets/starrating_base.dart';

class BookReviewDetailPage extends StatefulWidget {
  final String reviewId;
  final String bookId;
  final String token;

  const BookReviewDetailPage({
    super.key,
    required this.reviewId,
    required this.bookId,
    required this.token
  });

  @override
  State<BookReviewDetailPage> createState() => _BookReviewDetailPageState();
}

class _BookReviewDetailPageState extends State<BookReviewDetailPage> {
  final String baseUrl = 'https://forifbookbugapi.seongjinemong.app';

  Map<String, dynamic>? reviewData;
  Map<String, dynamic>? bookData;
  List<dynamic> replies = [];
  bool isLiked = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final reviewRes = await http.get(
        Uri.parse('$baseUrl/api/reviews/${widget.reviewId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}'
        },
      );
      final bookRes = await http.get(
        Uri.parse('$baseUrl/api/books/${widget.bookId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}'
        },
      );
      final replyRes = await http.get(
        Uri.parse('$baseUrl/api/replies/review/${widget.reviewId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}'
        },
      );

      if (reviewRes.statusCode == 200 &&
          bookRes.statusCode == 200 &&
          replyRes.statusCode == 200) {
        setState(() {
          reviewData = jsonDecode(reviewRes.body);
          bookData = jsonDecode(bookRes.body);
          replies = jsonDecode(replyRes.body);
          isLiked = reviewData?['liked'] ?? false;
          isLoading = false;
        });
      } else {
        throw Exception('데이터를 불러오는 데 실패했습니다.');
      }
    } catch (e) {
      debugPrint('오류: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _toggleLike() async {
    try {
      final url = Uri.parse('$baseUrl/api/reviews/${widget.reviewId}/like');
      final response = isLiked
          ? await http.delete(url)
          : await http.post(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          isLiked = !isLiked;
        });
      } else {
        throw Exception('좋아요 처리 실패');
      }
    } catch (e) {
      debugPrint('좋아요 처리 오류: $e');
    }
  }

  void _editReview() {
    final titleController = TextEditingController(text: reviewData?['title'] ?? '');
    final contentController = TextEditingController(text: reviewData?['content'] ?? '');
    double rating = reviewData?['rating']?.toDouble() ?? 0.0;
    List<String> tags = List<String>.from(reviewData?['tags'] ?? []);
    final tagController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('리뷰 수정'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: '제목'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: contentController,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: '내용'),
                ),
                const SizedBox(height: 8),
                StarRatingBase(
                  rating: rating,
                  onRatingChanged: (val) {
                    setStateDialog(() => rating = val);
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: tagController,
                        decoration: const InputDecoration(hintText: '태그 추가'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        final trimmed = tagController.text.trim();
                        if (trimmed.isEmpty || tags.contains(trimmed)) return;
                        setStateDialog(() {
                          tags.add(trimmed);
                          tagController.clear();
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags
                      .map((tag) => Chip(
                            label: Text(tag),
                            onDeleted: () => setStateDialog(() => tags.remove(tag)),
                          ))
                      .toList(),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newTitle = titleController.text.trim();
                final newContent = contentController.text.trim();

                if (newTitle.isEmpty || newContent.isEmpty) return;

                try {
                  final response = await http.patch(
                    Uri.parse('$baseUrl/api/reviews/${widget.reviewId}'),
                    headers: {
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer ${widget.token}'
                    },
                    body: jsonEncode({
                      'title': newTitle,
                      'content': newContent,
                      'rating': rating,
                      'tags': tags,
                    }),
                  );

                  if (response.statusCode == 200) {
                    Navigator.pop(context);
                    _loadData(); // 변경된 데이터 다시 불러오기
                  } else {
                    throw Exception('리뷰 수정 실패: ${response.body}');
                  }
                } catch (e) {
                  debugPrint('리뷰 수정 오류: $e');
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('리뷰 수정에 실패했습니다')),
                  );
                }
              },
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteReview() async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/reviews/${widget.reviewId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}'
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        throw Exception('리뷰 삭제 실패');
      }
    } catch (e) {
      debugPrint('리뷰 삭제 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('리뷰 상세정보'),
        actions: [
          IconButton(
            onPressed: _editReview,
            icon: const Icon(Icons.edit),
            tooltip: '수정',
          ),
          IconButton(
            onPressed: _deleteReview,
            icon: const Icon(Icons.delete),
            tooltip: '삭제',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 책 정보
                  BookinfoBase(
                    imageProvider: NetworkImage(bookData?['coverImageUrl'] ?? ''),
                    author: bookData?['author'] ?? '',
                    title: bookData?['title'] ?? '',
                    publisher: bookData?['publisher'] ?? '',
                    pubDate: bookData?['publicationDate'] ?? '',
                    review: reviewData?['content'] ?? '',
                  ),
                  const SizedBox(height: 16),
                  // 작성자 정보
                  Row(
                    children: [
                      ProfileimageBase(
                        width: 40,
                        height: 40,
                        image: reviewData?['writer']['profileImageUrl'] ?? '',
                      ),
                      const SizedBox(width: 8),
                      Text(
                        reviewData?['writer']['nickname'] ?? '익명',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 리뷰 제목 및 내용
                  Text(
                    reviewData?['title'] ?? '',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reviewData?['content'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 태그
                  Wrap(
                    spacing: 8,
                    children: (reviewData?['tags'] as List<dynamic>?)
                            ?.map((tag) => TagBase(tagName: tag.toString()))
                            .toList() ??
                        [],
                  ),
                  const SizedBox(height: 16),
                  // 댓글 섹션
                  _buildReplySection(context),
                ],
              ),
            ),
    );
  }

  Widget _buildReplySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 댓글 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    '댓글',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${replies.length}',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
              IconButton(
                onPressed: _toggleLike,
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 댓글 목록
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: replies.length > 2 ? 2 : replies.length,
            itemBuilder: (context, index) {
              final reply = replies[index];
              return ListItem(
                nickname: reply['nickname'] ?? '',
                title: '',
                content: reply['content'] ?? '',
                leadingText: (reply['nickname'] ?? 'U')[0].toUpperCase(),
                trailingText: reply['createdAt']?.substring(0, 10) ?? '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookReplyDetailPage(
                        replyId: reply['id'],
                        token: widget.token
                      ),
                    ),
                  );
                },
              );
            },
          ),
          // 더보기 버튼
          SizedBox(
            height: 40,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookReplyListPage(
                      reviewId: widget.reviewId,
                      token: widget.token,
                    ),
                  ),
                );
              },
              child: Row(
                children: const [
                  Text('더보기'),
                  Spacer(),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}