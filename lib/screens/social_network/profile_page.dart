import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/social_network/profile_header_widget.dart';
import '../../widgets/social_network/create_post_widget.dart';
import '../../widgets/social_network/post_widget.dart';
import '../../models/post_model.dart';
import '../../controllers/post_controller.dart';
import '../../data/user_data.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find<PostController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeaderWidget(),
            CreatePostWidget(),
            Obx(() {
  List<Post> userPosts = postController.getUserPosts(currentUser.id);
  List<Post> sortedUserPosts = List.from(userPosts)
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Trier du plus récent au plus ancien

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: sortedUserPosts.length,
    itemBuilder: (context, index) {
      return PostWidget(post: sortedUserPosts[index]);  // Afficher les posts triés
    },
  );
}),
          ],
        ),
      ),
    );
  }
}
