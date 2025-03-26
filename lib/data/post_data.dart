import '../models/post_model.dart';
import '../data/user_data.dart';
import '../data/comment_data.dart';

final List<Post> postsData = [
  Post(
    id: '0',
    user: currentUser,
    postText: 'I will visit this place again.',
    postImage: 'assets/images/posts/post1.png',
    createdAt: DateTime(2024, 9, 7, 14, 28),
    comments: commentsForPost1,
  ),
  Post(
    id: '1',
    user: addison,
    postText: 'Amazing place!',
    postImage: 'assets/images/posts/post2.png',
    createdAt: DateTime(2024, 9, 7, 14, 28),
    comments: commentsForPost2, // Utiliser les commentaires définis
  ),
  Post(
    id: '2',
    user: jason,
    postText: 'Nature is amazing!',
    createdAt: DateTime(2024, 9, 7, 14, 28),
    comments: commentsForPost3, // Aucun commentaire pour ce post
  ),
  Post(
    id: '3',
    user: judd,
    postText: 'Nature is amazing!',
    postImage: 'assets/images/posts/post3.png',
    createdAt: DateTime(2024, 9, 7, 14, 28),
    comments: commentsForPost4, // Aucun commentaire pour ce post
  ),
  Post(
    id: '5',
    user: nathan,
    postText: 'Nature is amazing!',
    postImage: 'assets/images/posts/post4.png',
    createdAt: DateTime(2024, 9, 7, 14, 28),
    comments: commentsForPost5, // Aucun commentaire pour ce post
  ),
  Post(
    id: '6',
    user: virgil,
    postText: 'Nature is amazing!',
    createdAt: DateTime(2024, 9, 7, 14, 28),
    comments: commentsForPost6, // Aucun commentaire pour ce post
  ),
  Post(
    id: '7',
    user: deanna,
    postText: 'Nature is amazing!',
    postImage: 'assets/images/posts/post5.png',
    createdAt: DateTime(2024, 9, 7, 14, 28),
    comments: commentsForPost7, // Aucun commentaire pour ce post
  ),
  Post(
    id: '8',
    user: angel,
    postText: 'Nature is amazing!',
    postImage: 'assets/images/posts/post6.png',
    createdAt: DateTime(2024, 9, 7, 14, 28),
    comments: commentsForPost8, // Aucun commentaire pour ce post
  ),
  Post(
    id: '9',
    user: stanley,
    postText: 'Nature is amazing!',
    createdAt: DateTime(2024, 9, 7, 14, 28),
    comments: commentsForPost9, // Aucun commentaire pour ce post
  ),
];