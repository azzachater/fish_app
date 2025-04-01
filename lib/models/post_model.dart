import 'user_model.dart';
import 'comment_model.dart';

class Post {
  final String id;
  final User user;
  final DateTime createdAt;
  final String? postText;  // Peut être null
  final String? postImage; // Peut être null
  int likeCount;
  bool isLiked;
  List<Comment> comments;

  Post({
    required this.id,
    required this.user,
    required this.createdAt,
    this.postText,  // Suppression du `required`
    this.postImage, // Suppression du `required`
    this.likeCount = 0,
    this.isLiked = false,
    required this.comments,
  });


 factory Post.fromJson(Map<String, dynamic> json) {
  try {
    print("🧐 Parsing Post JSON: $json");

    return Post(
      id: json['id'].toString(), // 🔥 Assurer un String
      user: User.fromJson(json['user']), // 🔥 Assurer que l'ID user est un String
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      postText: json['post_text']?.toString()?? '',
      postImage: json['post_image']?.toString()?? '',
      likeCount: (json['like_count'] is int) ? json['like_count'] : int.tryParse(json['like_count'].toString()) ?? 0,
      isLiked: json['is_liked'] == true, // ✅ Assurer un booléen correct
      comments: (json['comments'] as List<dynamic>? ?? [])
          .map((comment) => Comment.fromJson(comment))
          .toList(),
    );
  } catch (e) {
    print("🚨 Error in Post.fromJson: $e");
    print("⚠️ Problematic JSON: $json");
    rethrow;
  }
}



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user.id,
      'created_at': createdAt.toIso8601String(),
      if (postText != null) 'post_text': postText,  // N'inclut que si non null
      if (postImage != null) 'post_image': postImage,// N'inclut que si non null
      'like_count': likeCount,
      'is_liked': isLiked,
      'comments': comments.map((c) => c.toJson()).toList(),
    };
  }
}