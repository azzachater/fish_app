import 'package:get/get.dart';
import '../models/comment_model.dart';
import '../services/api_comment_service.dart';

class CommentController extends GetxController {
  var comments = <Comment>[].obs; // Liste des commentaires observable
  final ApiCommentService _apiService = ApiCommentService(); // Service API

  // Charger les commentaires pour un post spécifique
  Future<void> loadComments(String postId) async {
    try {
      final fetchedComments = await _apiService.fetchComments(postId);
      comments.assignAll(fetchedComments);
    } catch (e) {
      Get.snackbar("Erreur", "Impossible de charger les commentaires");
      print("❌ Erreur chargement commentaires : $e");
    }
  }

  // Ajouter un commentaire
  // Ajouter un commentaire
Future<void> addComment(String postId, String content) async {
  if (content.trim().isEmpty) {
    Get.snackbar("Erreur", "Le commentaire ne peut pas être vide");
    return;
  }

  try {
    final newComment = await _apiService.addComment(postId, content);
    if (newComment != null) {
      comments.add(newComment);
      comments.refresh();
      await loadComments(postId); // Charger les commentaires après ajout
      Get.snackbar("Succès", "Commentaire ajouté !");
    } else {
      Get.snackbar("Erreur", "Échec de l'ajout du commentaire");
    }
  } catch (e) {
    Get.snackbar("Erreur", "Impossible d'ajouter le commentaire");
    print("❌ Erreur ajout commentaire : $e");
  }
}


  // Supprimer un commentaire
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      bool success = await _apiService.deleteComment(postId, commentId);
      if (success) {
        comments.removeWhere((comment) => comment.id == commentId);
        Get.snackbar("Succès", "Commentaire supprimé !");
      } else {
        Get.snackbar("Erreur", "Échec de la suppression du commentaire");
      }
    } catch (e) {
      Get.snackbar("Erreur", "Impossible de supprimer le commentaire");
      print("❌ Erreur suppression commentaire : $e");
    }
  }
}
