import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../controllers/profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          // Zone blanche scrollable
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
                      const SizedBox(height: 20),
                      Obx(() => controller.imagePath.value.isNotEmpty
                        ? Image.file(
                            File(controller.imagePath.value),
                            height: 150,
                            fit: BoxFit.cover,
                          )
                        : const SizedBox.shrink(),
                      ),
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

          // Bouton retour
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
                final imagePath = controller.imagePath.value;
                final user = controller.user.value;
                
                ImageProvider avatarImage;
                if (imagePath.isNotEmpty) {
                  avatarImage = FileImage(File(imagePath));
                } else if (user?.avatar != null && user!.avatar!.startsWith('http')) {
                  avatarImage = NetworkImage(user.avatar!);
                } else {
                  avatarImage = const AssetImage('assets/images/default_avatar.png');
                }

                return Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: avatarImage,
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: controller.pickImage,
                        child: const CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit,
                              color: Colors.black, size: 15),
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