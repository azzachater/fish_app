import '../models/post_model.dart';
import '../data/user_data.dart'; 
import '../data/comment_data.dart';

final List<Post> posts = [
  Post(
    id: '0',
    user: currentUser,
    postText: 'I will visit this place again.',
    postImage: 'assets/images/posts/post1.jpg',
    timestamp: '7 September 2024 14:28',
    comments: commentsForPost1, // Utiliser les commentaires définis
  ),
  Post(
    id: '1',
    user: addison,
    postText: 'Amazing place!',
    postImage: 'assets/images/posts/post2.jpg',
    timestamp: '7 September 2024 14:30',
    comments: commentsForPost2, // Utiliser les commentaires définis
  ),
  Post(
    id: '2',
    user: jason,
    postText: 'Nature is amazing!',
    timestamp: '7 September 2024 14:35',
    comments: [], // Aucun commentaire pour ce post
  ),
];