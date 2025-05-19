import 'package:flutter/material.dart';
import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:bookbug/ui/core/ui/profileimage_base.dart';

class BookReplyDetailPage extends StatefulWidget {
  const BookReplyDetailPage({super.key});

  @override
  State<BookReplyDetailPage> createState() => _BookReplyDetailPageState();
}

class _BookReplyDetailPageState extends State<BookReplyDetailPage> {
  void _editReply() {
    // DB 연결 시 추가 예정
  }

  void _deleteReply() {
    // DB 연결 시 추가 예정
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> comments = List.generate(10, (index) => {
          'nickname': 'user$index',
          'commentPreview': 'Supporting the text for item $index',
          'date': '2025.05.${(index + 1).toString().padLeft(2, '0')}'
        });

    return Scaffold(
      appBar: AppBar(
        title: const Text('댓글 상세정보'),
        actions: [
          IconButton(
            onPressed: _editReply,
            icon: const Icon(Icons.edit),
            tooltip: '수정',
          ),
          IconButton(
            onPressed: _deleteReply,
            icon: const Icon(Icons.delete),
            tooltip: '삭제',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 댓글 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ProfileimageBase(image: 'assets/images/sample.png'), // 기본 이미지
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('name',
                            style: TextStyle(fontSize: 12, color: Colors.black)),
                        SizedBox(height: 4),
                        Text('contents',
                            style: TextStyle(fontSize: 14, color: Colors.black)),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Text('100+',
                        style: TextStyle(fontSize: 11, color: Colors.black)),
                    Icon(Icons.favorite),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            // 답글 수 표시
            Row(
              children: const [
                Text('답글',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                SizedBox(width: 4),
                Text('60',
                    style:
                        TextStyle(fontSize: 16, color: Colors.black)), // 임시 할당
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
                        final review = comments[index];
                        return ListItem(
                          nickname: review['nickname']!,
                          title: '',
                          content: review['commentPreview']!,
                          trailingText: review['date']!,
                          leadingText: review['nickname']![0].toUpperCase(),
                          onTap: () {},
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}