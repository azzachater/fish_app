import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';  
import '../../models/group_model.dart';
import '../../models/user_model.dart';
import '../../constants/theme.dart';
import '../../data/user_data.dart';

class GroupDetailsPage extends StatefulWidget {
  final List<User> selectedUsers;

  const GroupDetailsPage({super.key, required this.selectedUsers});

  @override
  GroupDetailsPageState createState() => GroupDetailsPageState();
}

class GroupDetailsPageState extends State<GroupDetailsPage> {
  TextEditingController groupNameController = TextEditingController();
  String? groupImage; 
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        groupImage = pickedFile.path;
      });
    }
  }

  void createGroup() {
  if (groupNameController.text.isNotEmpty && groupImage != null) {
    // S'assurer que currentUser n'est ajouté qu'une seule fois
    final Set<User> uniqueMembers = {currentUser, ...widget.selectedUsers};

    final newGroup = Group(
      name: groupNameController.text,
      avatar: groupImage!,
      admin: currentUser,
      members: uniqueMembers.toList(), // Convertir en liste unique
      unreadCount: 0,
      isRead: true,
      time: '12:00 PM',
      id: '',
    );

    Navigator.pop(context, newGroup);
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
              child: Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[200],
                child: groupImage == null
                    ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                    : Image.file(File(groupImage!), fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Selected Users',
              style: AppTheme.heading2,
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedUsers.length,
                itemBuilder: (context, index) {
                  final user = widget.selectedUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(user.avatar),
                    ),
                    title: Text(
                      user.name,
                      style: AppTheme.heading2.copyWith(fontSize: 16)),
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
                child: Text(
                  'Done',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}