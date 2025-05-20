import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:flutter/material.dart';

class BookReplyListPage extends StatefulWidget {
  const BookReplyListPage({super.key});

  @override
  State<BookReplyListPage> createState() => _BookReplyListPageState();
}
class _BookReplyListPageState extends State<BookReplyListPage> {

  void _addReply(){
    // DB 연결 후 추가 예정
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> replies = List.generate(10, (index) => {
      'nickname': 'user$index',
      'replyPreview': 'Supporting the text for item $index',
      'date': '2025.05.${(index + 1).toString().padLeft(2, '0')}'
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('댓글 (${replies.length})', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: _addReply, 
            icon: const Icon(Icons.add),
            tooltip: '댓글 추가',
          ),
        ],
      ),
      body: replies.isEmpty
          ? const Center(child: Text('이 리뷰에 대한 댓글이 아직 없어요'),)
          : ListView.builder(
              itemCount: replies.length,
              itemBuilder: (context, index) {
                final review = replies[index];
                return ListItem(
                  nickname: review['nickname']!,
                  title: '',
                  content: review['replyPreview']!,
                  trailingText: review['date']!,
                  leadingText: review['nickname']![0].toUpperCase(),
                  onTap: () {
                    // 댓글 상세 페이지 이동
                  },
                );
              },
            ),
    );
  }
}