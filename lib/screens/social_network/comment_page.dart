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
    // Initialiser le CommentController
    final CommentController commentController = Get.put(CommentController());

    // Charger les commentaires du post au démarrage
    commentController.loadComments(post.id);

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
                // Utilisation de GetX pour observer la liste des commentaires
                return ListView.builder(
                  itemCount: commentController.comments.length,
                  itemBuilder: (context, index) {
                    final comment = commentController.comments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(comment.user.avatar),
                      ),
                      title: Text(comment.user.name),
                      subtitle: Text(comment.text),
                      trailing: Text(comment.timestamp),
                    );
                  },
                );
              }),
            ),
            // Champ de texte pour ajouter un nouveau commentaire
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: TextEditingController(),
                decoration: InputDecoration(
                  hintText: 'Écrire un commentaire...',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final text = TextEditingController().text.trim();
                      if (text.isNotEmpty) {
                        // Créer un nouveau commentaire
                        final newComment = Comment(
                          id: 'new_comment_${commentController.comments.length}',
                          user: currentUser,
                          text: text,
                          timestamp: DateTime.now().toString(),
                          postId: post.id, // Utiliser l'ID du post
                        );
                        // Ajouter le commentaire avec GetX
                        commentController.addComment(newComment);
                        print('Nouveau commentaire : $text');
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
