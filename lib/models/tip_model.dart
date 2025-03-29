class Tip {
  final String? id;
  final String userId;
  String title;
  String description;

  Tip({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
  });

  // Convertir JSON en objet Tip
  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      id: json['id']?.toString(),
      userId: json['userId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  // Convertir objet Tip en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
    };
  }
}
