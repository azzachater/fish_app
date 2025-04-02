import '../models/comment_model.dart';
import 'user_data.dart';

final List<Comment> commentsForPost1 = [
  Comment(
    id: '0',
    user: currentUser,
    content: 'Great post!',
    timestamp: '14:30',
    postId: '0', // ID du post associé
  ),
  Comment(
    id: '1',
    user: virgil,
    content: 'Belle prise ! Tu l’as attrapé avec quel type d’appât ? ',
    timestamp: '14:30',
    postId: '0', // ID du post associé
  ),
  Comment(
    id: '2',
    user: angel,
    content: 'Wow, ça doit être un combat impressionnant pour sortir un poisson comme ça ! Félicitations ! 💪',
    timestamp: '14:30',
    postId: '0', // ID du post associé
  ),
];

final List<Comment> commentsForPost2 = [
  Comment(
    id: '3',
    user: addison,
    content: 'Amazing!',
    timestamp: '14:35',
    postId: '1', // ID du post associé
  ),
  Comment(
    id: '4',
    user: nathan,
    content: 'Rien de mieux qu’une journée en mer pour se ressourcer ! Belle aventure ! 🌊☀️',
    timestamp: '14:35',
    postId: '1', // ID du post associé
  ),
];
final List<Comment> commentsForPost3 = [
  Comment(
    id: '5',
    user: currentUser,
    content: 'Great post!',
    timestamp: '14:30',
    postId: '2', // ID du post associé
  ),
  Comment(
    id: '6',
    user: virgil,
    content: 'Belle prise ! Tu l’as attrapé avec quel type d’appât ? ',
    timestamp: '14:30',
    postId: '2', // ID du post associé
  ),
  Comment(
    id: '7',
    user: angel,
    content: 'Wow, ça doit être un combat impressionnant pour sortir un poisson comme ça ! Félicitations ! 💪',
    timestamp: '14:30',
    postId: '2', // ID du post associé
  ),
];
final List<Comment> commentsForPost4 = [
  Comment(
    id: '8',
    user: addison,
    content: 'Amazing!',
    timestamp: '14:35',
    postId: '3', // ID du post associé
  ),
  Comment(
    id: '9',
    user: nathan,
    content: 'Rien de mieux qu’une journée en mer pour se ressourcer ! Belle aventure ! 🌊☀️',
    timestamp: '14:35',
    postId: '3', // ID du post associé
  ),
];
final List<Comment> commentsForPost5 = [
  Comment(
    id: '10',
    user: judd,
    content: 'Jadore voir des nouvelles techniques, merci pour le partage ! 👌',
    timestamp: ' 14:35',
    postId: '4', // ID du post associé
  ),
  Comment(
    id: '11',
    user: leslie,
    content: 'cette technique a lair efficace, je vais tester ça bientôt ! 💡',
    timestamp: ' 14:35',
    postId: '4', // ID du post associé
  ),
];
final List<Comment> commentsForPost6 = [
  Comment(
    id: '12',
    user: judd,
    content: 'Jadore voir des nouvelles techniques, merci pour le partage ! 👌',
    timestamp: ' 14:35',
    postId: '5', // ID du post associé
  ),
  Comment(
    id: '13',
    user: leslie,
    content: 'cette technique a lair efficace, je vais tester ça bientôt ! 💡',
    timestamp: ' 14:35',
    postId: '5', // ID du post associé
  ),
];
final List<Comment> commentsForPost7 = [
  Comment(
    id: '14',
    user: judd,
    content: 'Jadore voir des nouvelles techniques, merci pour le partage ! 👌',
    timestamp: ' 14:35',
    postId: '6', // ID du post associé
  ),
  Comment(
    id: '15',
    user: leslie,
    content: 'cette technique a lair efficace, je vais tester ça bientôt ! 💡',
    timestamp: ' 14:35',
    postId: '6', // ID du post associé
  ),
];
final List<Comment> commentsForPost8 = [
  Comment(
    id: '16',
    user: currentUser,
    content: 'Great post!',
    timestamp: '14:30',
    postId: '7', // ID du post associé
  ),
  Comment(
    id: '17',
    user: virgil,
    content: 'Belle prise ! Tu l’as attrapé avec quel type d’appât ? ',
    timestamp: '14:30',
    postId: '7', // ID du post associé
  ),
  Comment(
    id: '18',
    user: angel,
    content: 'Wow, ça doit être un combat impressionnant pour sortir un poisson comme ça ! Félicitations ! 💪',
    timestamp: '14:30',
    postId: '7', // ID du post associé
  ),
];
final List<Comment> commentsForPost9 = [
  Comment(
    id: '19',
    user: currentUser,
    content: 'Great post!',
    timestamp: '14:30',
    postId: '8', // ID du post associé
  ),
  Comment(
    id: '20',
    user: virgil,
    content: 'Belle prise ! Tu l’as attrapé avec quel type d’appât ? ',
    timestamp: '14:30',
    postId: '8', // ID du post associé
  ),
  Comment(
    id: '21',
    user: angel,
    content: 'Wow, ça doit être un combat impressionnant pour sortir un poisson comme ça ! Félicitations ! 💪',
    timestamp: '14:30',
    postId: '8', // ID du post associé
  ),
];

final List<Comment> commentsForPost10 = [
  Comment(
    id: '22',
    user: judd,
    content: 'Jadore voir des nouvelles techniques, merci pour le partage ! 👌',
    timestamp: ' 14:35',
    postId: '9', // ID du post associé
  ),
  Comment(
    id: '23',
    user: leslie,
    content: 'cette technique a lair efficace, je vais tester ça bientôt ! 💡',
    timestamp: ' 14:35',
    postId: '9', // ID du post associé
  ),
];
final List<Comment> allComments = [
  ...commentsForPost1,
  ...commentsForPost2,
  ...commentsForPost3,
  ...commentsForPost4,
  ...commentsForPost5,
  ...commentsForPost6,
  ...commentsForPost7,
  ...commentsForPost8,
  ...commentsForPost9,
  ...commentsForPost10,
];