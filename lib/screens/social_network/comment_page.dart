import 'package:fish_app/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/post_model.dart';
import '../../controllers/comment_controller.dart';
import '../../controllers/user_controller.dart'; // Importez le UserController
import 'dart:io';

class CommentPage extends StatelessWidget {
  final Post post;

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
    final CommentController commentController = Get.put(CommentController());
    final UserController userController =
        Get.find<UserController>(); // Obtenez le UserController
    final TextEditingController commentControllerText = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      commentController.loadComments(post.id);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Commentaires')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (commentController.comments.isEmpty) {
                  return const Center(
                    child: Text("Aucun commentaire pour l'instant."),
                  );
                }
                return ListView.builder(
                  itemCount: commentController.comments.length,
                  itemBuilder: (context, index) {
                    final comment = commentController.comments[index];
                    final isCurrentUserOwner =
                        userController.currentUser.value?.id == comment.user.id;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: buildAvatarImage(comment.user.avatar),
                      ),
                      title: Text(comment.user.name),
                      subtitle: Text(comment.content),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(comment.formattedTime),
                          if (isCurrentUserOwner) // Affiche les 3 points seulement si l'utilisateur est le propriétaire
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) {
                                if (value == 'delete') {
                                  commentController.deleteComment(
                                    post.id,
                                    comment.id,
                                  );
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('Supprimer'),
                                  ),
                                ];
                              },
                            ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
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
                    icon: const Icon(Icons.send, color: AppTheme.primaryColor),
                    onPressed: () {
                      final text = commentControllerText.text.trim();
                      if (text.isNotEmpty) {
                        commentController.addComment(post.id, text);
                        commentControllerText.clear();
                      } else {
                        Get.snackbar(
                          "Erreur",
                          "Le commentaire ne peut pas être vide.",
                        );
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