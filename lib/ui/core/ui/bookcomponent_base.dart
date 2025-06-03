import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String id;
  final String title;
  final String author;
  final double rating;
  final String imageUrl;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.id,
    required this.title,
    required this.author,
    required this.rating,
    required this.imageUrl,
    this.onTap,
  });

  factory BookCard.fromJson(Map<String, dynamic> json) {
    return BookCard(
      id: json['id'] ?? '',
      title: json['title'] ?? '제목 없음',
      author: json['author'] ?? '작자 미상',
      rating: (json['rating'] ?? 0).toDouble(),
      imageUrl: json['image'] ?? 'https://via.placeholder.com/150x200',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        height: 360,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(25),
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 책 표지 이미지
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: AspectRatio(
                aspectRatio: 0.8,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.book, size: 50, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),
            // 책 정보
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // 저자
                  Text(
                    author,
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // 별점
                  // Row(
                  //   children: [
                  //     RatingStars(rating: rating),
                  //     const SizedBox(width: 6),
                  //     Text(
                  //       rating.toString(),
                  //       style: TextStyle(
                  //         fontSize: 9,
                  //         fontWeight: FontWeight.w500,
                  //         color: Colors.grey[700],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 별점 위젯
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 8,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          (index + 1) <= rating
            ? Icons.star
            : (rating - index >= 0.5)
              ? Icons.star_half
              : Icons.star_border,
          size: size,
          color: index < rating ? activeColor : inactiveColor,
        );
      }),
    );
  }
}