import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:bookbug/ui/book/view_model/book_reply_detail_page.dart';

class BookReplyListPage extends StatefulWidget {
  final String reviewId;
  final String token;

  const BookReplyListPage({super.key, required this.reviewId, required this.token});

  @override
  State<BookReplyListPage> createState() => _BookReplyListPageState();
}

class _BookReplyListPageState extends State<BookReplyListPage> {
  final String baseUrl = 'https://forifbookbugapi.seongjinemong.app';

  Future<List<dynamic>> fetchReplies() async {
    final url = Uri.parse('$baseUrl/api/replies/review/${widget.reviewId}');

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
      throw Exception('댓글 데이터를 불러오지 못했습니다: ${response.body}');
    }
  }

  void _addReply() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('댓글 작성'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(hintText: '댓글을 입력하세요'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              final content = controller.text.trim();
              if (content.isEmpty) return;

              try {
                final response = await http.post(
                  Uri.parse('$baseUrl/api/replies'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ${widget.token}'
                  },
                  body: jsonEncode({
                    'reply': content,
                    'reviewId': widget.reviewId,
                  }),
                );

                if (response.statusCode == 201) {
                  Navigator.pop(context);
                  setState(() {}); // FutureBuilder 다시 호출
                } else {
                  throw Exception('댓글 작성 실패: ${response.body}');
                }
              } catch (e) {
                debugPrint('댓글 작성 오류: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('댓글 작성에 실패했습니다')),
                );
              }
            },
            child: const Text('작성'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('댓글', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: _addReply,
            icon: const Icon(Icons.add),
            tooltip: '댓글 추가',
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchReplies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('댓글을 불러오는 중 오류가 발생했습니다.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('이 리뷰에 대한 댓글이 아직 없어요'));
          }

          final replies = snapshot.data!;
          return ListView.builder(
            itemCount: replies.length,
            itemBuilder: (context, index) {
              final reply = replies[index];
              return ListItem(
                nickname: reply['author']['username'] ?? '',
                title: '',
                content: reply['reply'] ?? '',
                trailingText: reply['createdAt']?.substring(0, 10) ?? '',
                leadingText: (reply['author']['username'] ?? '?')[0].toUpperCase(),
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
          );
        },
      ),
    );
  }
}