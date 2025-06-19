class Book {
  final String id;
  final String title;
  final String author;
  final String publisher;
  final String imageUrl;
  final String description;
  final String publishedAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.publisher,
    required this.imageUrl,
    required this.description,
    required this.publishedAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '', 
      title: json['title'] ?? '', 
      author: json['author'] ?? '', 
      publisher: json['publisher'] ?? '', 
      imageUrl: json['imageUrl'] ?? '', 
      description: json['description'] ?? '', 
      publishedAt: json['publishedAt'] ?? '',
    );
  }
}