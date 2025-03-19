import 'package:flutter/material.dart';
import '../../models/comment_model.dart'; // Importation du modèle Comment
import '../../models/post_model.dart'; // Importation du modèle Post
import '../../data/user_data.dart';  // Importation des données utilisateur

class CommentPage extends StatefulWidget {
  final Post post; // Référence au Post

  const CommentPage({super.key, required this.post});

  @override
  CommentPageState createState() => CommentPageState();
}

class CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              child: ListView.builder(
                itemCount: widget.post.comments.length,
                itemBuilder: (context, index) {
                  final comment = widget.post.comments[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(comment.user.avatar),
                    ),
                    title: Text(comment.user.name),
                    subtitle: Text(comment.text),
                    trailing: Text(comment.timestamp),
                  );
                },
              ),
            ),
            // Champ de texte pour ajouter un nouveau commentaire
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Écrire un commentaire...',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      final text = _commentController.text.trim();
                      if (text.isNotEmpty) {
                        // Ajouter un nouveau commentaire à ce post
                        final newComment = Comment(
                          id: 'new_comment_${widget.post.comments.length}',
                          user: currentUser,
                          text: text,
                          timestamp: DateTime.now().toString(),
                          postId: widget.post.id, // Utiliser l'ID du post
                        );
                        setState(() {
                          widget.post.comments.add(newComment); // Ajouter le commentaire au post
                        });
                        _commentController.clear(); // Effacer le champ de texte
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