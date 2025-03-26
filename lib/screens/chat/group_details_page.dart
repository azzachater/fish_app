import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/group_model.dart';
import '../../constants/theme.dart';
import '../../data/user_data.dart';
import '../../controllers/group_detail_controller.dart';

// ignore: must_be_immutable
class GroupDetailsPage extends StatelessWidget {
  GroupDetailsPage({super.key});

  final CreateSearchGroupController controller = Get.find();
  final TextEditingController groupNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  RxString groupImage = ''.obs;

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      groupImage.value = pickedFile.path;
    }
  }

  void createGroup() {
    if (groupNameController.text.isNotEmpty && groupImage.value.isNotEmpty) {
      final newGroup = Group(
        name: groupNameController.text,
        avatar: groupImage.value,
        admin: currentUser,
        members: {currentUser, ...controller.selectedUsers}.toList(),
        unreadCount: 0,
        isRead: true,
        time: '12:00 PM',
        id: '',
        messages: [],
      );

      Get.back(result: newGroup);
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
            TextField(
              controller: groupNameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: pickImage,
              child: Obx(() => Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[200],
                child: groupImage.value.isEmpty
                    ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                    : Image.file(File(groupImage.value), fit: BoxFit.cover),
              )),
            ),
            SizedBox(height: 20),
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
                      backgroundImage: AssetImage(user.avatar),
                    ),
                    title: Text(user.name, style: AppTheme.heading2.copyWith(fontSize: 16)),
                  );
                },
              ),
            ),
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
}
