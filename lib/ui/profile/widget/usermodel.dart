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
    // 만약 { data: { ... } } 구조라면 안쪽으로 들어갑니다.
    final data =
        json.containsKey('data') ? json['data'] as Map<String, dynamic> : json;

    // 모든 필드를 null 안전하게 변환
    final id = data['id']?.toString() ?? '';
    final email = data['email']?.toString() ?? '';
    final username = data['username']?.toString() ?? ''; // 서버는 username 키 사용
    final role = data['role']?.toString() ?? '';

    // createdAt 처리: ISO 문자열 또는 밀리초 타임스탬프 모두 커버
    final rawCreated = data['createdAt'] ?? data['created_at'];
    DateTime parsedCreated;
    if (rawCreated is String && rawCreated.isNotEmpty) {
      parsedCreated = DateTime.parse(rawCreated);
    } else if (rawCreated is int) {
      parsedCreated = DateTime.fromMillisecondsSinceEpoch(rawCreated);
    } else {
      parsedCreated = DateTime.now();
    }

    // image는 nullable
    final image = data['image']?.toString();

    return User(
      id: id,
      email: email,
      name: username,
      role: role,
      createdAt: parsedCreated,
      image: image,
    );
  }
}
