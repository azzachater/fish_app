import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../models/post_model.dart';
import '../../widgets/social_network/post_widget.dart'; // Import du widget pour afficher les publications
import '../../widgets/social_network/users_profile_header.dart';
import '../../controllers/post_controller.dart'; // Assurez-vous d'avoir un contrôleur pour gérer les posts

class UserProfilePage extends StatelessWidget {
  final User user;

  const UserProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.put(PostController()); // Instanciation du contrôleur PostController

    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        backgroundColor: Colors.blue,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Affichage des informations de l'utilisateur (avatar, nom, etc.)
            UsersProfileHeader(user: user),
            // Affichage des publications de l'utilisateur
            Obx(() {
              // Récupérer et filtrer les posts en fonction de l'utilisateur de manière réactive
              List<Post> userPosts = postController.getUserPosts(user.id);
              return Column(
                children: userPosts.map((post) => PostWidget(post: post)).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
