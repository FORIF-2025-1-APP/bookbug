class Review {
  final int id;
  final int bookId;
  final String nickname;
  final String bookTitle;
  final String reviewPreview;
  final String content;
  final double rating;
  final String createdAt;

  Review({
    required this.id,
    required this.bookId,
    required this.nickname,
    required this.bookTitle,
    required this.reviewPreview,
    required this.content,
    required this.rating,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'], 
      bookId: json['book_id'] ?? 0,
      nickname: json['nickname'] ?? '', 
      bookTitle: json['bookTitle'] ?? '', 
      reviewPreview: json['reviewPreview'] ?? '', 
      content: json['content'] ?? '', 
      rating: (json['rating'] is int) 
          ? (json['rating'] as int).toDouble()
          : (json['rating'] ?? 0.0),
      createdAt: json['createdAt'] ?? '',
    );
  }
}