import 'user_model.dart';
import 'comment_model.dart';

class Post {
  final String id;
  final User user;
  final DateTime createdAt;
  final String? postText;
  final String? postImage;
  int likeCount;
  bool isLiked;
  List<Comment> comments;

  Post({
    required this.id,
    required this.user,
    required this.createdAt,
    this.postText,
    this.postImage,
    this.likeCount = 0,
    this.isLiked = false,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    try {
      return Post(
        id: json['id'].toString(),
        user: User.fromJson(json['user']),
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : DateTime.now(),
        postText: json['post_text']?.toString() ?? '',
        postImage: json['post_image']?.toString() ?? '',
        likeCount: (json['like_count'] is int) ? json['like_count'] : int.tryParse(json['like_count'].toString()) ?? 0,
        isLiked: json['is_liked'] == true,
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
      'user_id': user.id,
      'created_at': createdAt.toIso8601String(),
      if (postText != null) 'post_text': postText,
      if (postImage != null) 'post_image': postImage,
      'like_count': likeCount,
      'is_liked': isLiked,
      'comments': comments.map((c) => c.toJson()).toList(),
    };
  }
}
