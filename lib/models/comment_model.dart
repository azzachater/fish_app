import '../models/user_model.dart';

class Comment {
  final String id;
  final User user;
  final String text;
  final String timestamp;
  final String postId; // Stocker uniquement l'ID du post

  Comment({
    required this.id,
    required this.user,
    required this.text,
    required this.timestamp,
    required this.postId,
  });

  // Convertir un JSON en Comment
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'].toString(),
      user: User.fromJson(json['user']), // Assurez-vous que User a aussi un fromJson
      text: json['text'],
      timestamp: json['timestamp'],
      postId: json['post_id'].toString(),
    );
  }

  // Convertir un Comment en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(), // Assurez-vous que User a aussi un toJson
      'text': text,
      'timestamp': timestamp,
      'post_id': postId,
    };
  }
}
