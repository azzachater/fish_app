import 'package:get/get.dart';
import '../models/comment_model.dart';
import '../services/api_comment_service.dart';

class CommentController extends GetxController {
  var comments = <Comment>[].obs;
  final ApiCommentService _apiService = ApiCommentService();

  Future<void> loadComments(String postId) async {
    try {
      print("🔄 Début du chargement des commentaires pour le post $postId");
      final fetchedComments = await _apiService.fetchComments(postId);
      
      // Log des commentaires récupérés
      print("📥 Commentaires reçus (${fetchedComments.length}):");
      for (var comment in fetchedComments) {
        _logCommentDetails(comment);
      }
      
      comments.assignAll(fetchedComments);
      print("✅ Chargement des commentaires terminé");
    } catch (e) {
      print("❌ Erreur chargement commentaires : $e");
      Get.snackbar("Erreur", "Impossible de charger les commentaires");
    }
  }

  Future<void> addComment(String postId, String content) async {
    if (content.trim().isEmpty) {
      print("⚠️ Tentative d'ajout de commentaire vide");
      Get.snackbar("Erreur", "Le commentaire ne peut pas être vide");
      return;
    }

    try {
      print("🔄 Tentative d'ajout de commentaire: '$content'");
      final newComment = await _apiService.addComment(postId, content);
      
      if (newComment != null) {
        print("➕ Nouveau commentaire ajouté:");
        _logCommentDetails(newComment);
        
        comments.insert(0, newComment);
        comments.refresh();
        
        // Rechargement complet pour vérification
        print("🔄 Rechargement des commentaires...");
        await loadComments(postId);
        
        Get.snackbar("Succès", "Commentaire ajouté !");
      } else {
        print("⚠️ Le nouveau commentaire reçu est null");
        Get.snackbar("Erreur", "Échec de l'ajout du commentaire");
      }
    } catch (e) {
      print("❌ Erreur ajout commentaire : $e");
      Get.snackbar("Erreur", "Impossible d'ajouter le commentaire");
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      print("🔄 Tentative de suppression du commentaire $commentId");
      bool success = await _apiService.deleteComment(postId, commentId);
      
      if (success) {
        print("🗑️ Commentaire supprimé avec succès");
        comments.removeWhere((comment) => comment.id == commentId);
        Get.snackbar("Succès", "Commentaire supprimé !");
      } else {
        print("⚠️ Échec de la suppression côté API");
        Get.snackbar("Erreur", "Échec de la suppression du commentaire");
      }
    } catch (e) {
      print("❌ Erreur suppression commentaire : $e");
      Get.snackbar("Erreur", "Impossible de supprimer le commentaire");
    }
  }

  // Méthode helper pour logger les détails d'un commentaire
  void _logCommentDetails(Comment comment) {
    print("""
    📝 Commentaire ID: ${comment.id}
    ├─ Contenu: ${comment.content}
    ├─ Date: ${comment.createdAt}
    └─ Utilisateur:
       ├─ ID: ${comment.user.id}
       ├─ Nom: ${comment.user.name}
       ├─ Email: ${comment.user.email}
       └─ Avatar: ${comment.user.avatar ?? 'non défini'}
    """);
    
    // Vérification supplémentaire des données utilisateur
    if (comment.user.avatar == null || comment.user.avatar!.isEmpty) {
      print("⚠️ Attention: L'avatar de l'utilisateur est vide ou null");
    } else {
      print("🖼️ Avatar URL: ${comment.user.avatar}");
    }
  }

  // Pour déboguer l'état actuel des commentaires
  void debugCurrentComments() {
    print("\n🔍 ÉTAT ACTUEL DES COMMENTAIRES (${comments.length}):");
    for (var comment in comments) {
      _logCommentDetails(comment);
    }
  }
}