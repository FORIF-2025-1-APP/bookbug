import 'package:bookbug/ui/lists/widgets/empty_review_message.dart';
import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:flutter/material.dart';
import 'package:bookbug/ui/book/view_model/book_review_detail_page.dart';

class  WroteListPage extends StatelessWidget {
  const WroteListPage ({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> myReviews = List.generate(10, (index) => {
      'nickname': 'me',
      'bookTitle': 'List Item $index',
      'reviewPreview': 'Supporting the text for item $index',
      'date': '2025.05.${(index + 1).toString().padLeft(2, '0')}'
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('작성한 리뷰', style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: myReviews.isEmpty
          ? const EmptyReviewMessage(message: '작성한 리뷰가 아직 없어요')
          : ListView.builder(
              itemCount: myReviews.length,
              itemBuilder: (context, index) {
                final review = myReviews[index];
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
                        builder: (context) => BookReviewDetailPage(bookId: ,reviewId: review['id'],),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}