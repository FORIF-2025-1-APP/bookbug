import 'package:bookbug/ui/lists/widgets/empty_review_message.dart';
import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:flutter/material.dart';

class LinkedListPage extends StatelessWidget {
  const LinkedListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> likedReviews = List.generate(10, (index) => {
      'nickname': 'user$index',
      'bookTitle': 'List Item $index',
      'reviewPreview': 'Supporting the text for item $index',
      'date': '2025.05.${(index + 1).toString().padLeft(2, '0')}'
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('좋아요한 리뷰', style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: likedReviews.isEmpty
          ? const EmptyReviewMessage(message: '좋아요한 리뷰가 아직 없어요')
          : ListView.builder(
              itemCount: likedReviews.length,
              itemBuilder: (context, index) {
                final review = likedReviews[index];
                return ListItem(
                  nickname: review['nickname']!,
                  title: review['bookTitle']!,
                  content: review['reviewPreview']!,
                  trailingText: review['date']!,
                  leadingText: review['nickname']![0].toUpperCase(),
                  onTap: () {
                    // 리뷰 상세 페이지 이동
                  },
                );
              },
            ),
    );
  }
}