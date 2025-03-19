import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/post_model.dart';
import '../../data/post_data.dart';
import '../../widgets/social_network/post_widget.dart'; // Import du widget pour afficher les publications
import '../../widgets/social_network/users_profile_header.dart';

class UserProfilePage extends StatelessWidget {
  final User user;

  const UserProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Filtrer les publications de l'utilisateur
    List<Post> userPosts = posts.where((post) => post.user.id == user.id).toList();

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
            ...userPosts.map((post) => PostWidget(post: post)),
          ],
        ),
      ),
    );
  }
}
