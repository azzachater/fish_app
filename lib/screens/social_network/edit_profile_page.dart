import 'dart:io';
import 'package:fish_app/data/user_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../controllers/edit_profile_controller.dart'; // Importer le contrôleur GetX

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenez le contrôleur avec GetX
    final EditProfileController controller = Get.put(EditProfileController());

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Text('Edit Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      CustomTextField(label: 'Username', controller: controller.usernameController),
                      CustomTextField(label: 'Email', controller: controller.emailController),
                      CustomTextField(label: 'Password', controller: controller.passwordController, obscureText: true),
                      CustomTextField(label: 'Password Confirmation', controller: controller.passwordConfirmationController, obscureText: true),
                      CustomTextField(label: 'Bio', controller: controller.bioController, maxLines: 3),
                      SizedBox(height: 20),
                      controller.imagePath != null
                          ? Image.file(File(controller.imagePath!), height: 150, fit: BoxFit.cover)
                          : SizedBox.shrink(),
                      CustomButton(
                        text: 'Save',
                        onPressed: controller.saveProfile,  // Sauvegarder via le contrôleur
                        isPrimary: true,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 15,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: controller.imagePath != null
                        ? FileImage(File(controller.imagePath!)) as ImageProvider
                        : (currentUser.avatar.startsWith('http')
                            ? NetworkImage(currentUser.avatar)
                            : AssetImage(currentUser.avatar) as ImageProvider),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: controller.pickImage,  // Lancer la fonction de sélection d'image
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.edit, color: Colors.black, size: 15),
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
  }
}
