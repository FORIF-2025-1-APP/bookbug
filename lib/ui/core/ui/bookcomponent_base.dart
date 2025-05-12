// ignore: file_names
import 'dart:math';

import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final double rating;
  final String imageUrl;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.rating,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        height: 350,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF0EFE1), // 연한 베이지색 배경
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
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
                aspectRatio: 0.9, // 책 표지 비율 조정
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
            Expanded( 
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      author,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          RatingStars(rating: rating),
                          const SizedBox(width: 6),
                          Text(
                          rating.toString(),
                          style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
    this.size = 18,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          // 전체, 반, 빈 별 아이콘 결정
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

// 사용 예시
class BookListExample extends StatelessWidget {
  const BookListExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('실시간 Top 10'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '실시간 Top 10',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 300, // 카드 높이에 맞게 조정
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemBuilder: (context, index) {
                return BookCard(
                  title: 'Book Title',
                  author: 'Author Name',
                  rating: 3.5,
                  imageUrl: 'https://via.placeholder.com/150x200',
                  onTap: () {
                    // 책 상세 페이지로 이동
                    log('책 $index 선택됨' as num);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}