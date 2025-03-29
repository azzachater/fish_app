import 'user_model.dart';
import 'comment_model.dart';

class Post {
  final String id;
  final User user;
  final DateTime createdAt;
  String postText;
  String? postImage;
  int likeCount;
  bool isLiked;
  List<Comment> comments;

  Post({
    required this.id,
    required this.user,
    required this.createdAt,
    required this.postText,
    this.postImage,
    this.likeCount = 0,
    this.isLiked = false,
    required this.comments,
  });

  // Méthode pour convertir un JSON en Post
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'].toString(),
      user: User.fromJson(json['user']),
      createdAt: DateTime.parse(json['created_at']),
      postText: json['post_text'] ?? '',
      postImage: json['post_image'],
      likeCount: json['like_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      comments: (json['comments'] as List<dynamic>?)
              ?.map((comment) => Comment.fromJson(comment))
              .toList() ??
          [],
    );
  }

  // Méthode pour convertir un Post en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'created_at': createdAt.toIso8601String(),
      'post_text': postText,
      'post_image': postImage,
      'like_count': likeCount,
      'is_liked': isLiked,
      'comments': comments.map((c) => c.toJson()).toList(),
    };
  }
}
