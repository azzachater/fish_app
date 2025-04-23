import 'dart:io';
import 'package:fish_app/constants/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../controllers/post_controller.dart';
import '../../controllers/user_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class CreatePostPage extends StatelessWidget {
  CreatePostPage({super.key});

  final PostController postController = Get.find();
  final UserController userController = Get.find();
  final ImagePicker _picker = ImagePicker();
  final logger = Logger();
  final uuid = Uuid();
  final Rx<XFile?> _image = Rx<XFile?>(null);
  final TextEditingController _textController = TextEditingController();

  String generatePostId() {
    return uuid.v4();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.name;
      final savedImage = await File(
        pickedFile.path,
      ).copy('${appDir.path}/$fileName');
      _image.value = XFile(savedImage.path);
    }
  }

  ImageProvider _getAvatarImage(String? avatarPath) {
    if (avatarPath == null || avatarPath.isEmpty || avatarPath == 'null') {
      return const AssetImage('assets/images/default_avatar.png');
    } else if (avatarPath.startsWith('http')) {
      return NetworkImage(avatarPath);
    }
    return const AssetImage('assets/images/default_avatar.png');
  }

  void _submitPost() {
    final currentUser = userController.currentUser.value;
    if (currentUser == null) {
      Get.snackbar(
        "Erreur",
        "Utilisateur non connecté",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    String postText = _textController.text.trim();
    if (postText.isNotEmpty || _image.value != null) {
      postController.createPost(postText, _image.value?.path ?? "");

      _textController.clear();
      _image.value = null;
      Get.back();
    } else {
      Get.snackbar(
        "Erreur",
        "Le post ne peut pas être vide",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Créer un post",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        final currentUser = userController.currentUser.value;
        final avatar = currentUser?.avatar;
        final name = currentUser?.name ?? '';

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Affichage de l'utilisateur actuel
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: _getAvatarImage(avatar),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Champ de texte pour le post
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: "Quoi de neuf, $name ?",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 20),

                // Affichage de l'image sélectionnée
                Obx(
                  () =>
                      _image.value != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(_image.value!.path),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                          : const SizedBox(),
                ),

                const SizedBox(height: 20),

                // Bouton pour sélectionner une image
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(
                          Icons.photo_library,
                          color: Colors.green,
                        ),
                        label: const Text(
                          "Photo",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Bouton pour publier
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColorAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Publier",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      // La permission a été accordée
    }
  }
}
