import '../models/user_model.dart';
//import '../models/post_model.dart';

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
    required this.postId, // Utiliser postId au lieu de post
  });
}