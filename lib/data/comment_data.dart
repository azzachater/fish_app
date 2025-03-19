import '../models/comment_model.dart';
import 'user_data.dart';

final List<Comment> commentsForPost1 = [
  Comment(
    id: '0',
    user: currentUser,
    text: 'Great post!',
    timestamp: '7 September 2024 14:30',
    postId: '0', // ID du post associé
  ),
];

final List<Comment> commentsForPost2 = [
  Comment(
    id: '1',
    user: addison,
    text: 'Amazing!',
    timestamp: '7 September 2024 14:35',
    postId: '1', // ID du post associé
  ),
];