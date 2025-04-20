import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importation de GetX
import '../../models/post_model.dart'; // Importation du modèle Post
import '../../controllers/comment_controller.dart'; // Importation du CommentController
import 'dart:io';


class CommentPage extends StatelessWidget {
  final Post post; // Référence au Post

  const CommentPage({super.key, required this.post});

  ImageProvider buildAvatarImage(String avatarPath) {
  if (avatarPath.isEmpty) {
    return const AssetImage('assets/images/default_avatar.png');
  } else if (avatarPath.startsWith('http')) {
    return NetworkImage(avatarPath);
  } else if (avatarPath.startsWith('assets/')) {
    return AssetImage(avatarPath);
  } else {
    return FileImage(File(avatarPath));
  }
}

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
  backgroundImage: buildAvatarImage(comment.user.avatar),),
                      title: Text(comment.user.name),
                      subtitle: Text(comment.content),
                      trailing: Text( comment.formattedTime),
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
