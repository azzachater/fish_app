import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../../screens/social_network/create_post_page.dart';

class CreatePostWidget extends StatelessWidget {
  final UserController userController = Get.find();
  
  void _navigateToCreatePost(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePostPage()),
    );
  }

  ImageProvider _getAvatarImage(String? avatarPath) {
    if (avatarPath == null || avatarPath.isEmpty || avatarPath == 'null') {
      return const AssetImage('assets/images/default_avatar.png');
    } else if (avatarPath.startsWith('http')) {
      return NetworkImage(avatarPath);
    }
    return const AssetImage('assets/images/default_avatar.png');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentUser = userController.currentUser.value;
      final avatar = currentUser?.avatar ?? 'assets/images/default_avatar.png';
      final name = currentUser?.name ?? '';

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: _getAvatarImage(avatar),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => _navigateToCreatePost(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        "Quoi de neuf, $name?",
                        style: const TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.photo_library, color: Colors.green),
                  onPressed: () => _navigateToCreatePost(context),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}