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

  factory Tip.fromJson(Map<String, dynamic> json) {
    print("🟢 JSON reçu dans Tip.fromJson: $json"); 
    return Tip(
      id: json['id']?.toString(),
      userId: json['userId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.replaceAll(RegExp(r',+$'), '').trim() ?? '',  
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
    };
  }
}
