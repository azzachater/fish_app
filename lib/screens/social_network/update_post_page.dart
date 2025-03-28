import 'package:fish_app/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // Importer la bibliothèque image_picker
import 'dart:io'; // Pour manipuler les fichiers d'image
import '../../models/post_model.dart';
import '../../controllers/post_controller.dart';


class UpdatePostPage extends StatelessWidget {
  final Post post;
  final PostController postController = Get.put(PostController());

  UpdatePostPage({super.key, required this.post});

  final Rx<String> updatedText = "".obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  late final TextEditingController textController; // Déclarer le contrôleur de texte

  @override
  Widget build(BuildContext context) {
    // Initialisation correcte du contrôleur de texte
    textController = TextEditingController(text: post.postText);
    updatedText.value = post.postText;
    
    if (post.postImage != null && post.postImage!.isNotEmpty) {
  if (post.postImage!.startsWith('assets/')) {
    // Si l'image est un asset, on la garde en tant que String
    selectedImage.value = null; 
  } else {
    // Si c'est une image locale, on la charge avec File()
    selectedImage.value = File(post.postImage!);
  }
}


    Future<void> pickImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    }

    void saveUpdatedPost() {
      String updatedImagePath = selectedImage.value?.path ?? "";
      postController.updatePost(post, updatedText.value, updatedImagePath);
      Get.back();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Update Post", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.white),
            onPressed: saveUpdatedPost,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Edit Your Post",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 20),
            TextField(
              controller: textController, // Utiliser le contrôleur de texte
              onChanged: (value) {
                updatedText.value = value;
              },
              maxLines: 4,
              style: TextStyle(fontSize: 16, color: Colors.black87),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                labelText: "Edit Post",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                labelStyle: TextStyle(color: Colors.blueAccent),
              ),
            ),
            SizedBox(height: 20),
            Obx(() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (selectedImage.value != null) 
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            selectedImage.value!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      if (selectedImage.value == null && post.postImage != null && post.postImage!.startsWith('assets/'))
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            post.postImage!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: pickImage,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text("Add Image", style: TextStyle(fontSize: 16)),
      ),
    ],
  );
}),

          ],
        ),
      ),
    );
  }
}
