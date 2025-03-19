import 'package:flutter/material.dart';
import '../../widgets/social_network/profile_header_widget.dart';
import '../../widgets/social_network/create_post_widget.dart';
import '../../widgets/social_network/post_widget.dart';
import '../../data/post_data.dart';
import '../../models/post_model.dart';
import '../../data/user_data.dart';
// Importer SidebarPage

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Filtrer les posts du currentUser
    final List<Post> userPosts = posts.where((post) => post.user.id == currentUser.id).toList();

    return Scaffold(
  appBar: AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios), // Icône de retour
      onPressed: () {
        // Naviguer vers la page SocialHomePage
        Navigator.pop(context); // Cela va retourner à la page précédente dans la pile de navigation
      },
    ),
    title: const Text('Profile'),
  ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeaderWidget(user: currentUser),
            CreatePostWidget(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: userPosts.length,
              itemBuilder: (context, index) {
                return PostWidget(post: userPosts[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
