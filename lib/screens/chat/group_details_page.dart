import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../constants/theme.dart';
import '../../controllers/group_chat_controller.dart';

class GroupDetailsPage extends StatelessWidget {
  GroupDetailsPage({super.key});

  final GroupChatController controller = Get.find();
  final TextEditingController groupNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final ValueNotifier<String> groupImage = ValueNotifier<String>('');

  // Pick an image from gallery
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      groupImage.value = pickedFile.path;
    }
  }

  // Create the group with name, image, and selected users
  void createGroup() async {
    if (groupNameController.text.isNotEmpty && groupImage.value.isNotEmpty) {
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final name = groupNameController.text;
      final avatar = groupImage.value;
      final memberIds = controller.selectedUsers.map((u) => u.id).toList();

      await controller.createGroup(name, avatar, memberIds);
      
      Get.back(); // Ferme le loader
      Get.back(); // Retour à la liste de groupes
    } else {
      Get.snackbar('Erreur', 'Nom du groupe ou image manquants');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Details', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group name input field
            TextField(
              controller: groupNameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Image picker
            GestureDetector(
              onTap: pickImage,
              child: ValueListenableBuilder<String>(
                valueListenable: groupImage,
                builder: (context, value, child) => Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: value.isEmpty
                      ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                      : Image.file(File(value), fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Display selected users
            Text('Selected Users', style: AppTheme.heading2),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: controller.selectedUsers.length,
                itemBuilder: (context, index) {
                  final user = controller.selectedUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: _getAvatarImage(user.avatar),
                    ),
                    title: Text(user.name, style: AppTheme.heading2.copyWith(fontSize: 16)),
                  );
                },
              ),
            ),

            // Done button to create the group
            Center(
              child: ElevatedButton(
                onPressed: createGroup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  ImageProvider _getAvatarImage(String? avatarUrl) {
    if (avatarUrl != null && avatarUrl.isNotEmpty && avatarUrl.startsWith('http')) {
      return NetworkImage(avatarUrl);
    }
    return const AssetImage('assets/images/default_avatar.png');
  }
}
