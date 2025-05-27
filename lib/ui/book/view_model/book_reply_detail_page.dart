import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:bookbug/ui/core/ui/profileimage_base.dart';

class BookReplyDetailPage extends StatefulWidget {
  final String replyId;
  final String token;

  const BookReplyDetailPage({super.key, required this.replyId, required this.token});

  @override
  State<BookReplyDetailPage> createState() => _BookReplyDetailPageState();
}

class _BookReplyDetailPageState extends State<BookReplyDetailPage> {
  final String baseUrl = 'https://forifbookbugapi.seongjinemong.app';

  Map<String, dynamic>? replyData;
  List<Map<String, dynamic>> comments = [];
  bool isLoading = true;
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadReplyAndComments();
  }

  Future<void> _loadReplyAndComments() async {
    try {
      final replyRes = await http.get(
        Uri.parse('$baseUrl/api/replies/${widget.replyId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}'
        },
      );
      final commentRes = await http.get(
        Uri.parse('$baseUrl/api/comments/reply/${widget.replyId}'),
          headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}'
        },
      );

      if (replyRes.statusCode == 200 && commentRes.statusCode == 200) {
        setState(() {
          replyData = jsonDecode(replyRes.body);
          comments = List<Map<String, dynamic>>.from(jsonDecode(commentRes.body));
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

  Future<void> _addComment() async {
    final content = commentController.text.trim();
    if (content.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/comments'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}'
        },
        body: jsonEncode({
          'replyId': widget.replyId,
          'content': content,
        }),
      );

      if (response.statusCode == 201) {
        commentController.clear();
        _loadReplyAndComments();
      } else {
        throw Exception('답글 작성 실패');
      }
    } catch (e) {
      debugPrint('답글 작성 오류: $e');
    }
  }

  Future<void> _editReply() async {
    final controller = TextEditingController(text: replyData?['content'] ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('댓글 수정'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newContent = controller.text.trim();
              if (newContent.isEmpty) return;

              try {
                final response = await http.patch(
                  Uri.parse('$baseUrl/api/replies/${widget.replyId}'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ${widget.token}'
                  },
                  body: jsonEncode({'content': newContent}),
                );

                if (response.statusCode == 200) {
                  Navigator.pop(context);
                  _loadReplyAndComments();
                } else {
                  throw Exception('댓글 수정 실패');
                }
              } catch (e) {
                debugPrint('댓글 수정 오류: $e');
              }
            },
            child: const Text('수정'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteReply() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('댓글 삭제'),
        content: const Text('이 댓글을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final response = await http.delete(
          Uri.parse('$baseUrl/api/replies/${widget.replyId}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}'
          },
        );

        if (response.statusCode == 200) {
          Navigator.pop(context); // 이전 페이지로 돌아가기
        } else {
          throw Exception('삭제 실패');
        }
      } catch (e) {
        debugPrint('댓글 삭제 오류: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('댓글 상세정보'),
        actions: [
          IconButton(
            onPressed: _editReply,
            icon: const Icon(Icons.edit),
            tooltip: '댓글 수정',
          ),
          IconButton(
            onPressed: _deleteReply,
            icon: const Icon(Icons.delete),
            tooltip: '댓글 삭제',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 댓글 헤더
                  Row(
                    children: [
                      ProfileimageBase(image: 'assets/images/sample.png'),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(replyData?['nickname'] ?? '익명',
                              style: const TextStyle(fontSize: 12, color: Colors.black)),
                          const SizedBox(height: 4),
                          Text(replyData?['content'] ?? '',
                              style: const TextStyle(fontSize: 14, color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 답글 수 표시
                  Row(
                    children: [
                      const Text('답글',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      Text('${comments.length}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 답글 리스트
                  Expanded(
                    child: comments.isEmpty
                        ? const Center(child: Text('이 댓글에 대한 답글이 아직 없어요'))
                        : ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              return ListItem(
                                nickname: comment['writer']['nickname'] ?? '익명',
                                title: '',
                                content: comment['content'] ?? '',
                                trailingText: comment['createdAt']?.split('T').first ?? '',
                                leadingText: (comment['writer']['nickname']?[0] ?? 'U').toUpperCase(),
                              );
                            },
                          ),
                  ),

                  // 답글 작성창
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: const InputDecoration(hintText: '답글을 입력하세요'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _addComment,
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}