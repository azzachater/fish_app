import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/theme.dart';
import '../../controllers/group_chat_controller.dart';
import 'group_details_page.dart';
import 'group_chat_page.dart';
import 'dart:io';

class CreateSearchGroup extends StatelessWidget {
  CreateSearchGroup({super.key});

  final GroupChatController controller = Get.find<GroupChatController>();
  final TextEditingController searchController = TextEditingController();

  ImageProvider _buildImageProvider(String avatarPath) {
    if (avatarPath.isEmpty) {
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
    // Réinitialise les membres sélectionnés
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetSelectedUsers();
    });

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search users...',
            hintStyle: TextStyle(color: Colors.white.withAlpha(179)),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: controller.filterUsers,
        ),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        final currentUser = controller.currentUser;
        final otherSelectedUsers = controller.selectedUsers
            .where((user) => user.id != currentUser.id)
            .toList();

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("👥 Create a New Group", style: AppTheme.heading2),
                  SizedBox(height: 8),
                  Text(
                    "Select members to start a new conversation group.",
                    style: AppTheme.subtitleStyle,
                  ),
                  SizedBox(height: 16),

                  if (otherSelectedUsers.isNotEmpty) ...[
                    Text('Selected Members', style: AppTheme.subtitleStyle),
                    SizedBox(height: 8),
                    SizedBox(
  height: 80, // au lieu de 70
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: otherSelectedUsers.length,
    itemBuilder: (context, index) {
      final user = otherSelectedUsers[index];
      return Padding(
        padding: EdgeInsets.only(right: 12),
        child: Column(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: _buildImageProvider(user.avatar),
            ),
            SizedBox(height: 4),
            Text(
              user.name.split(' ')[0],
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    },
  ),
),

                    SizedBox(height: 16),
                  ],

                  Text('Add Members', style: AppTheme.heading2),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = controller.filteredUsers[index];
                        final isCurrentUser = user.id == currentUser.id;
                        final isSelected = controller.selectedUsers.contains(user);

                        return Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: _buildImageProvider(user.avatar),
                                    child: isCurrentUser
                                        ? Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.4),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Icon(Icons.person, color: Colors.white),
                                            ),
                                          )
                                        : null,
                                  ),
                                  if (!isCurrentUser)
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: GestureDetector(
                                        onTap: () => controller.toggleUserSelection(user),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isSelected ? AppTheme.primaryColor : Colors.grey,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2),
                                          ),
                                          padding: EdgeInsets.all(4),
                                          child: Icon(
                                            isSelected ? Icons.check : Icons.add,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                user.name.split(' ')[0],
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: otherSelectedUsers.isNotEmpty
                          ? () => Get.to(() => GroupDetailsPage())
                          : null,
                      icon: Icon(Icons.arrow_forward),
                      label: Text("Continue"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            Divider(height: 1, thickness: 1),

            // List of Existing Groups
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Text('Your Groups', style: AppTheme.heading2.copyWith(fontSize: 16)),
                  ),
                  Expanded(
                    child: Obx(() {
                      final allGroups = controller.allGroups;
                      return ListView.builder(
                        itemCount: allGroups.length,
                        itemBuilder: (context, index) {
                          final group = allGroups[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: group.avatar.startsWith('/')
                                  ? FileImage(File(group.avatar)) as ImageProvider
                                  : AssetImage(group.avatar),
                            ),
                            title: Text(group.name, style: AppTheme.heading2.copyWith(fontSize: 16)),
                            subtitle: Text('${group.members.length} members'),
                            onTap: () => Get.to(() => GroupChatPage(group: group)),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
