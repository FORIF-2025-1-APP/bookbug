class NotificationItem {
  final int id;
  final String title;
  final String body;
  final String createdAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'], 
      title: json['title'] ?? '', 
      body: json['body'] ?? '', 
      createdAt: json['createdAt'] ?? '',
    );
  }
}