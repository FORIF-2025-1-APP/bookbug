import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:flutter/material.dart';
import 'package:bookbug/ui/book/view_model/book_review_detail_page.dart';

class BookReviewListPage extends StatefulWidget {
  const BookReviewListPage({super.key});

  @override
  State<BookReviewListPage> createState() => _BookReviewListPageState();
}
class _BookReviewListPageState extends State<BookReviewListPage> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> reviews = List.generate(10, (index) => {
      'nickname': 'user$index',
      'bookTitle': 'List Item $index',
      'reviewPreview': 'Supporting the text for item $index',
      'date': '2025.05.${(index + 1).toString().padLeft(2, '0')}'
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰 (${reviews.length})', style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // 정렬 기능은 DB 연결 후 추가 예정
      body: reviews.isEmpty
          ? const Center(child: Text('이 책에 대한 리뷰가 아직 없어요'),)
          : ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ListItem(
                  nickname: review['nickname']!,
                  title: review['bookTitle']!,
                  content: review['reviewPreview']!,
                  trailingText: review['date']!,
                  leadingText: review['nickname']![0].toUpperCase(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookReviewDetailPage(),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}