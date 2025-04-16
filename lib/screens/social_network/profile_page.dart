import 'package:fish_app/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/social_network/profile_header_widget.dart';
import '../../widgets/social_network/create_post_widget.dart';
import '../../widgets/social_network/post_widget.dart';
import '../../models/post_model.dart';
import '../../controllers/post_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find<PostController>();
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeaderWidget(),
            CreatePostWidget(),
            Obx(() {
              if (userController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (userController.error.value.isNotEmpty) {
                return Center(child: Text(userController.error.value));
              }
              
              final currentUser = userController.currentUser.value;
              if (currentUser == null) {
                return const Center(child: Text('No user data'));
              }
              
              List<Post> userPosts = postController.getCurrentUserPosts();
              List<Post> sortedUserPosts = List.from(userPosts)
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

              if (sortedUserPosts.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('No posts yet', style: TextStyle(fontSize: 16)),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedUserPosts.length,
                itemBuilder: (context, index) {
                  return PostWidget(post: sortedUserPosts[index]);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}