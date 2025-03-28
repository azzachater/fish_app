import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:io';  // Pour gérer les fichiers image
import '../../screens/social_network/comment_page.dart';
import '../../screens/social_network/update_post_page.dart';
import '../../models/post_model.dart';
import '../../controllers/post_controller.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final PostController postController = Get.put(PostController());

  PostWidget({super.key, required this.post}) {
    postController.isLiked.value = post.isLiked;
    postController.likeCount.value = post.likeCount;
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
    titleStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    middleText: "Are you sure you want to delete this post? This action can't be undone.",
    middleTextStyle: TextStyle(fontSize: 14, color: Colors.black54),
    textCancel: "Cancel",
    cancelTextColor: Colors.blueGrey,
    textConfirm: "Delete",
    confirmTextColor: Colors.white,
    buttonColor: Colors.redAccent,  // Utilisation d'un rouge plus moderne
    backgroundColor: Colors.white,
    radius: 8,  // Coins légèrement arrondis
    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),  // Espacement agréable
    onConfirm: () {
      postController.deletePost(post);
      Get.back(); // Fermer la boîte de dialogue après suppression
    },
    onCancel: () => Get.back(),
    barrierDismissible: false,  // Empêcher la fermeture en cliquant à l'extérieur
  );
}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
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
              backgroundImage: AssetImage(post.user.avatar),
              radius: 22,
            ),
            title: Text(
              post.user.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              post.createdAt.toString(),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            contentPadding: EdgeInsets.all(10),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'update') {
                  openUpdatePostPage();
                } else if (value == 'delete') {
                  _showDeleteConfirmationDialog(context);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'update',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue),
                      SizedBox(width: 8),
                      Text("Update"),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                post.postText,
                style: TextStyle(fontSize: 14, height: 1.5),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          if (post.postImage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: post.postImage!.startsWith('assets/')  // Si c'est une image d'asset
                  ? Image.asset(post.postImage!)  // Charger depuis assets
                  : Image.file(File(post.postImage!)),  // Charger depuis la galerie
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
                            color: postController.isLiked.value ? Colors.blue : Colors.grey,
                          ),
                          onPressed: postController.toggleLike,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${postController.likeCount.value} Likes',
                          style: TextStyle(color: postController.isLiked.value ? Colors.blue : Colors.grey),
                        ),
                      ],
                    )),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(FontAwesomeIcons.commentDots, color: Colors.grey),
                      onPressed: navigateToComments,
                    ),
                    SizedBox(width: 4),
                    Text('Comment', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(FontAwesomeIcons.share, color: Colors.grey),
                      onPressed: () {},
                    ),
                    SizedBox(width: 4),
                    Text('Share', style: TextStyle(color: Colors.grey)),
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
