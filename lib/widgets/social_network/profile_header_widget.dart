import 'dart:io';
import '../../screens/social_network/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';

class ProfileHeaderWidget extends StatelessWidget {
  ProfileHeaderWidget({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        children: [
          // Cover Photo
          Obx(() => Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: controller.user.value.avatar.startsWith('assets/')
    ? AssetImage(controller.user.value.avatar) as ImageProvider
    : FileImage(File(controller.user.value.avatar)),
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          Transform.translate(
            offset: Offset(0, -50),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Obx(() => CircleAvatar(
                            radius: 55,
                            backgroundImage: controller.user.value.avatar.startsWith('assets/')
    ? AssetImage(controller.user.value.avatar) as ImageProvider
    : FileImage(File(controller.user.value.avatar)),
                          )),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.black, size: 20),
                          onPressed: controller.updateProfilePicture,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Name
                  Obx(() => Text(
                        controller.user.value.name,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(height: 10),
                  // Edit Profile Button
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfilePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: Icon(Icons.edit, color: Colors.white),
                    label: Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Bio
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Obx(() => Text(
    controller.user.value.bio, // Utilise la bio du modèle User
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 16,
      color: Colors.grey[700],
      fontStyle: FontStyle.italic,
      height: 1.5,
    ),
  )),
),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
