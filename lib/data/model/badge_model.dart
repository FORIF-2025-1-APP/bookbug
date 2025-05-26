class BadgeItem {
  final int id;
  final String name;
  final String icon;

  BadgeItem({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory BadgeItem.fromJson(Map<String, dynamic> json) {
    return BadgeItem(
      id: json['id'],
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class BadgeDetail {
  final int id;
  final String name;
  final String description;
  final String icon;

  BadgeDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });

  factory BadgeDetail.fromJson(Map<String, dynamic> json) {
    return BadgeDetail(
      id: json['id'], 
      name: json['name'] ?? '', 
      description: json['description'] ?? '', 
      icon: json['icon'] ?? '',
    );
  }
}