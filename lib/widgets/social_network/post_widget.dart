import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../screens/social_network/comment_page.dart';
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
              child: Image.asset(post.postImage!),
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
