import '../models/user_model.dart';

class Comment {
  final String id;
  final User user;
  final String content;
  final String timestamp;
  final String postId; // Stocker uniquement l'ID du post

  Comment({
    required this.id,
    required this.user,
    required this.content,
    required this.timestamp,
    required this.postId,
  });

  // Convertir un JSON en Comment
 factory Comment.fromJson(Map<String, dynamic> json) {
  print("🟢 Parsing Comment JSON: $json");

  return Comment(
    id: json['id'].toString(),
    user: json.containsKey('user') && json['user'] != null
        ? User.fromJson(json['user'])
        : User(id: 0, name: "Unknown", avatar: '', email: '', password: '', bio: '', passwordConfirmation: ''), // ✅ Empêche l'erreur si `user` est null
    content: json['content'] ?? '',
    timestamp: json['created_at'] ?? '',
    postId: json['post_id'].toString(),
  );
}


  // Convertir un Comment en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(), // Assurez-vous que User a aussi un toJson
      'content': content,
      'timestamp': timestamp,
      'post_id': postId,
    };
  }
}
