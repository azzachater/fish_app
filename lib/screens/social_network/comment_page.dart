import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importation de GetX
import '../../models/comment_model.dart'; // Importation du modèle Comment
import '../../models/post_model.dart'; // Importation du modèle Post
import '../../data/user_data.dart';  // Importation des données utilisateur
import '../../controllers/comment_controller.dart'; // Importation du CommentController

class CommentPage extends StatelessWidget {
  final Post post; // Référence au Post

  const CommentPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
  final CommentController commentController = Get.put(CommentController()); // Instanciation ici
    final TextEditingController commentControllerText = TextEditingController(); // Correct initialisation

    // Charger les commentaires au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commentController.loadComments(post.id);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Commentaires'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Liste des commentaires
            Expanded(
              child: Obx(() {
                if (commentController.comments.isEmpty) {
                  return const Center(child: Text("Aucun commentaire pour l'instant."));
                }
                return ListView.builder(
                  itemCount: commentController.comments.length,
                  itemBuilder: (context, index) {
                    final comment = commentController.comments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(comment.user.avatar), // Correction de l'affichage
                      ),
                      title: Text(comment.user.name),
                      subtitle: Text(comment.content),
                      trailing: Text(comment.timestamp),
                    );
                  },
                );
              }),
            ),
            // Champ de texte pour ajouter un nouveau commentaire
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentControllerText,
                      decoration: const InputDecoration(
                        hintText: 'Écrire un commentaire...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      final text = commentControllerText.text.trim();
                      if (text.isNotEmpty) {
                        commentController.addComment(post.id, text);
                        commentControllerText.clear(); // Effacer le champ après envoi
                      } else {
                        Get.snackbar("Erreur", "Le commentaire ne peut pas être vide.");
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
