import 'package:fish_app/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/post_model.dart';
import '../../controllers/post_controller.dart';

class UpdatePostPage extends StatefulWidget {
  final Post post;

  const UpdatePostPage({super.key, required this.post});

  @override
  State<UpdatePostPage> createState() => _UpdatePostPageState();
}

class _UpdatePostPageState extends State<UpdatePostPage> {
  final PostController postController = Get.find();
  late final TextEditingController textController;
  final Rx<File?> selectedImage = Rx<File?>(null);
  String? imageUrl; // To keep track of the original image URL

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.post.postText ?? '');
    imageUrl = widget.post.postImage;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> saveUpdatedPost() async {
    try {
      final updatedPost = Post(
        id: widget.post.id,
        user: widget.post.user,
        createdAt: widget.post.createdAt,
        postText: textController.text,
        postImage: selectedImage.value?.path ?? imageUrl ?? '',
        likeCount: widget.post.likeCount,
        isLiked: widget.post.isLiked,
        comments: widget.post.comments,
      );

      await postController.updatePost(updatedPost);
      Get.back(result: 'success');
    } catch (e) {
    Get.back(result: 'error');
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Update Post", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: saveUpdatedPost,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Edit Your Post",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: textController,
              maxLines: 4,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                labelText: "Edit Post",
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                labelStyle: const TextStyle(color: Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 20),
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
                  if (selectedImage.value == null && imageUrl != null && imageUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: imageUrl!.startsWith('assets/')
                          ? Image.asset(
                              imageUrl!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(imageUrl!),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("Add Image", style: TextStyle(fontSize: 16)),
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