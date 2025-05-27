import 'package:bookbug/ui/lists/widgets/empty_review_message.dart';
import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:flutter/material.dart';
import 'package:bookbug/data/services/api_service.dart';
import 'package:bookbug/data/model/review_model.dart';
import 'package:bookbug/ui/book/view_model/book_review_detail_page.dart';

class LinkedListPage extends StatefulWidget {
  const LinkedListPage({super.key});

  @override
  State<LinkedListPage> createState() => _LinkedListPageState();
}

class _LinkedListPageState extends State<LinkedListPage> {
  Future<List<Review>>? _likedReviewsFuture;

  @override
  void initState() {
    super.initState();
    _likedReviewsFuture = ApiService.getLikedReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('좋아요한 리뷰', style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<Review>>(
        future: _likedReviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          } else {
            final likedReviews = snapshot.data!;
            if (likedReviews.isEmpty) {
              return const EmptyReviewMessage(message: '좋아요한 리뷰가 아직 없어요');
            }
            return ListView.builder(
              itemCount: likedReviews.length,
              itemBuilder: (context, index) {
                final review = likedReviews[index];
                return ListItem(
                  nickname: review.nickname,
                  title: review.bookTitle,
                  content: review.reviewPreview,
                  trailingText: review.createdAt.substring(0, 10),
                  leadingText: review.nickname.isNotEmpty
                      ? review.nickname[0].toUpperCase()
                      : '',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookReviewDetailPage(reviewId: (review.id).toString(), bookId: (review.bookId).toString()),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}