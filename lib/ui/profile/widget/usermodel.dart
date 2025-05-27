class User {
  final String id;
  final String email;
  final String name;
  final String role;
  final DateTime createdAt;
  final String? image;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      createdAt: DateTime.parse(json['createdAt']),
      image: json['image'] as String?,
    );
  }
}
