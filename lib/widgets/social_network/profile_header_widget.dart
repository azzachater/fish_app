import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../../screens/social_network/edit_profile_page.dart';

class ProfileHeaderWidget extends StatelessWidget {
  ProfileHeaderWidget({super.key});

  final UserController userController = Get.find<UserController>();

  ImageProvider _buildImageProvider(String? avatarPath) {
    if (avatarPath == null || avatarPath.isEmpty) {
      return const AssetImage('assets/images/default_avatar.png');
    } else if (avatarPath.startsWith('http')) {
      return NetworkImage(avatarPath);
    } else if (avatarPath.startsWith('assets/')) {
      return AssetImage(avatarPath);
    } else {
      return FileImage(File(avatarPath));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = userController.currentUser.value;

      if (user == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover photo
            Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/cover_default_image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -50),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: _buildImageProvider(user.avatar),
                    ),
                    const SizedBox(height: 10),
                    // Name
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Edit button
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Bio
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        user.bio.isNotEmpty == true
                            ? user.bio
                            : "Aucune bio disponible",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
