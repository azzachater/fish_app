/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/theme.dart';
import '../../controllers/group_detail_controller.dart';
import 'group_details_page.dart';
import 'group_chat_page.dart';
import 'dart:io';

class CreateSearchGroup extends StatelessWidget {
  CreateSearchGroup({super.key});

  final CreateSearchGroupController controller = Get.put(CreateSearchGroupController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search users...',
            hintStyle: TextStyle(color: Colors.white.withAlpha(179)),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          onChanged: controller.filterUsers,
        ),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create Group', style: AppTheme.heading2),
                SizedBox(height: 10),
                SizedBox(
                  height: 80,
                  child: Obx(() => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = controller.filteredUsers[index];
                      final isSelected = controller.selectedUsers.contains(user);
                      return GestureDetector(
                        onTap: () => controller.toggleUserSelection(user),
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(user.avatar),
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Icon(Icons.check_circle, color: Colors.green),
                              ),
                          ],
                        ),
                      );
                    },
                  )),
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final newGroup = await Get.to(() => GroupDetailsPage());
                      if (newGroup != null) {
                        controller.addGroup(newGroup);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text('Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text('All Groups', style: AppTheme.heading2),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.filteredGroups.length,
              itemBuilder: (context, index) {
                final group = controller.filteredGroups[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: group.avatar.startsWith('/')
                        ? FileImage(File(group.avatar)) as ImageProvider
                        : AssetImage(group.avatar),
                  ),
                  title: Text(group.name, style: AppTheme.heading2.copyWith(fontSize: 16)),
                  subtitle: Text('${group.members.length} members'),
                  onTap: () {
                    Get.to(() => GroupChatPage(group: group));
                  },
                );
              },
            )),
          ),
        ],
      ),
    );
  }
}
*/