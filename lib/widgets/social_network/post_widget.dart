import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../screens/social_network/comment_page.dart';
import '../../screens/social_network/update_post_page.dart';
import '../../models/post_model.dart';
import '../../controllers/post_controller.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final PostController postController = Get.find();
  final RxBool isLiked = false.obs;
  final RxInt likeCount = 0.obs;

  PostWidget({super.key, required this.post}) {
    isLiked.value = post.isLiked;
    likeCount.value = post.likeCount;
  }

  void navigateToComments() {
    Get.to(() => CommentPage(post: post));
  }

  void openUpdatePostPage() {
    Get.to(() => UpdatePostPage(post: post));
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Delete Post",
      titleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      middleText: "Are you sure you want to delete this post? This action can't be undone.",
      middleTextStyle: const TextStyle(fontSize: 14, color: Colors.black54),
      textCancel: "Cancel",
      cancelTextColor: Colors.blueGrey,
      textConfirm: "Delete",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      backgroundColor: Colors.white,
      radius: 8,
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      onConfirm: () {
        postController.deletePost(post.id); // Pass the post ID as String
        Get.back();
      },
      onCancel: () => Get.back(),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("User name: ${post.user.name} - Avatar path: ${post.user.avatar}");

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

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 22,
              backgroundImage: buildAvatarImage(post.user.avatar),
            ),
            title: Text(
              post.user.name, // Display the user's name
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              post.formattedTime,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            contentPadding: const EdgeInsets.all(10),
            trailing: postController.currentUserId == post.user.id.toString()
                ? PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'update') {
                        openUpdatePostPage();
                      } else if (value == 'delete') {
                        _showDeleteConfirmationDialog(context);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
                        value: 'update',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.blue),
                            SizedBox(width: 8),
                            Text("Update"),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text("Delete"),
                          ],
                        ),
                      ),
                    ],
                  )
                : null,
          ),
          if (post.postText != null && post.postText!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  post.postText!,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          if (post.postImage != null && post.postImage!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: post.postImage!.startsWith('http')
                  ? Image.network(
                      post.postImage!,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, color: Colors.red, size: 50);
                      },
                    )
                  : (post.postImage!.startsWith('assets/')
                      ? Image.asset(post.postImage!)
                      : Image.file(File(post.postImage!))),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(() => Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.thumbsUp,
                        color: isLiked.value ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () {
                        isLiked.toggle();
                        likeCount.value += isLiked.value ? 1 : -1;
                        postController.likePost(post.id); // API call to like post
                      },
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${likeCount.value} Likes',
                      style: TextStyle(color: isLiked.value ? Colors.blue : Colors.grey),
                    ),
                  ],
                )),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(FontAwesomeIcons.commentDots, color: Colors.grey),
                      onPressed: navigateToComments,
                    ),
                    const SizedBox(width: 4),
                    const Text('Comment', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
