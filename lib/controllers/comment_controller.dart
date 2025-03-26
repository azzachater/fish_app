import 'package:get/get.dart';
import '../models/comment_model.dart';
import '../data/comment_data.dart';  // Assurez-vous que le fichier comment_data.dart contient les commentaires

class CommentController extends GetxController {
  // Liste des commentaires
  var comments = <Comment>[].obs;

  // Charger les commentaires pour un post spécifique
  void loadComments(String postId) {
    // Filtrer les commentaires par postId
    comments.value = allComments
        .where((comment) => comment.postId == postId)
        .toList();
  }

  // Ajouter un commentaire
  void addComment(Comment comment) {
    comments.add(comment);
  }
}
