import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../controllers/profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  ImageProvider _buildImageProvider(String avatarPath, String imagePath) {
    if (imagePath.isNotEmpty) {
      if (imagePath.startsWith('http')) {
        return NetworkImage(imagePath);
      } else {
        return FileImage(File(imagePath));
      }
    } else if (avatarPath.isEmpty) {
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
    final ProfileController controller = Get.find<ProfileController>();

    // This ensures the user profile is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadUserProfile();
    });

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          // Scrollable white zone
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Username',
                        controller: controller.usernameController,
                        hintText: '',
                        obscureText: false,
                      ),
                      CustomTextField(
                        label: 'Email',
                        controller: controller.emailController,
                        hintText: '',
                        obscureText: false,
                      ),
                      CustomTextField(
                        label: 'Bio',
                        controller: controller.bioController,
                        maxLines: 3,
                        hintText: '',
                        obscureText: false,
                      ),
                      Obx(() {
                        final imageProvider = _buildImageProvider(
                          controller.user.value?.avatar ?? '',
                          controller.imagePath.value,
                        );

                        return Image(
                          image: imageProvider,
                          height: 150,
                          fit: BoxFit.cover,
                        );
                      }),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Save',
                        onPressed: controller.saveProfile,
                        isPrimary: true,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 40,
            left: 15,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Avatar
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Obx(() {
                return Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _buildImageProvider(
                        controller.user.value?.avatar ?? '',
                        controller.imagePath.value,
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: controller.pickImage,
                        child: const CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit, color: Colors.black, size: 15),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
