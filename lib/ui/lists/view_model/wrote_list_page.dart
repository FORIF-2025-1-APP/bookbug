import 'package:bookbug/ui/core/ui/listitem_base.dart';
import 'package:flutter/material.dart';
import 'package:bookbug/ui/book/view_model/book_review_detail_page.dart';
import 'package:bookbug/data/model/review_model.dart';
import 'package:bookbug/data/services/api_service.dart';

class WroteListPage extends StatefulWidget {
  final String token;

  const WroteListPage({super.key, required this.token});

  @override
  State<WroteListPage> createState() => _WroteListPageState();
}

class _WroteListPageState extends State<WroteListPage> {
  Future<List<Review>>? _myReviewsFuture;
  int reviewCount = 0;

  @override
  void initState() {
    super.initState();
    _myReviewsFuture = ApiService.getMyReviews().then((list) {
      setState(() {
        reviewCount = list.length;
      });
      return list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: colorScheme.onSurface,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '내가 쓴 리뷰 ($reviewCount)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<Review>>(
        future: _myReviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          } else {
            final reviews = snapshot.data!;
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ListItem(
                  nickname: review.nickname,
                  title: review.bookTitle,
                  content: review.reviewPreview,
                  leadingText: review.nickname.substring(0, 1).toUpperCase(),
                  trailingText: review.createdAt.substring(0, 10),
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