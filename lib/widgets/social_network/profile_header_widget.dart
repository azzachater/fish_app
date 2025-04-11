import 'dart:io';
import '../../screens/social_network/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';

class ProfileHeaderWidget extends StatelessWidget {
  ProfileHeaderWidget({super.key});

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    ImageProvider _buildImageProvider(String avatarPath) {
      if (avatarPath.isEmpty) {
        return AssetImage('assets/images/default_avatar.png');
      } else if (avatarPath.startsWith('http')) {
        return NetworkImage(avatarPath);
      } else if (avatarPath.startsWith('assets/')) {
        return AssetImage(avatarPath);
      } else {
        return FileImage(File(avatarPath));
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
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
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.user.value == null) {
          return Center(child: Text('Aucun profil disponible'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Photo
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
              offset: Offset(0, -50),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Aligné à gauche
                  children: [
                    // Profile Picture (aligné à gauche)
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: _buildImageProvider(controller.user.value!.avatar),
                    ),
                    const SizedBox(height: 10),
                    // Name
                    Text(
                      controller.user.value!.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    // Edit Profile Button (aligné à gauche)
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
MaterialPageRoute(builder: (context) => EditProfilePage(user: controller.user.value!)),
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
                        controller.user.value!.bio,
                        textAlign: TextAlign.left,
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
        );
      }),
    );
  }
}
