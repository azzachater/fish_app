import 'user_model.dart';
import 'comment_model.dart';

class Post {
  final String id;
  final User user;  // Utilisation de l'objet User
  final String timestamp;
  final String postText;
  final String? postImage;
  int likeCount;
  bool isLiked;
  List<Comment> comments;

  Post({
    required this.id,
    required this.user,
    required this.timestamp,
    required this.postText,
    this.postImage,
    this.likeCount = 0,
    this.isLiked = false,
    required this.comments,
  });
}
