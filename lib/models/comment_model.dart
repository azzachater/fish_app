import '../models/user_model.dart';

class Comment {
  final String id;
  final User user;
  final String content;
  final DateTime createdAt; // Changé de String à DateTime
  final String postId;

  Comment({
    required this.id,
    required this.user,
    required this.content,
    required DateTime? createdAt, // Maintenant nullable
    required this.postId,
  }) : createdAt = createdAt ?? DateTime.now(); // Valeur par défaut si null

  factory Comment.fromJson(Map<String, dynamic> json) {
    print("🟢 Parsing Comment JSON: $json");

    return Comment(
      id: json['id'].toString(),
      user: json.containsKey('user') && json['user'] != null
          ? User.fromJson(json['user'])
          : User(id: 0, 
          name: "Unknown", 
          email: '', 
          avatar: '', 
          bio: ''),
      content: json['content'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      postId: json['post_id'].toString(),
    );
  }

  // Méthode pour formater le temps comme Facebook
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours} h';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} j';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Il y a $weeks sem';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Il y a $months mois';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Il y a $years ans';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'post_id': postId,
    };
  }
}