import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/group_controller.dart';
import '../../constants/theme.dart';
import '../../screens/chat/group_chat_page.dart';
import 'dart:io';

class RecentGroups extends StatelessWidget {
  final GroupController controller = Get.find();

  RecentGroups({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Row(
            children: [
              Text('Recent Groups', style: AppTheme.heading2),
              Spacer(),
            ],
          ),
        ),
        Obx(() => ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.recentGroups.length,
          itemBuilder: (context, index) {
            final group = controller.recentGroups[index];
            ImageProvider avatarImage = group.avatar.startsWith('/')
                ? FileImage(File(group.avatar))
                : AssetImage(group.avatar);

            return GestureDetector(
              onTap: () {
                controller.markGroupAsRead(group);
                Get.to(() => GroupChatPage(group: group));
              },
              child: ListTile(
                leading: CircleAvatar(radius: 28, backgroundImage: avatarImage),
                title: Text(group.name, style: AppTheme.heading2.copyWith(fontSize: 16)),
                subtitle: Text('${group.members.length} members', style: AppTheme.bodyText1),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    group.unreadCount == 0
                        ? Icon(Icons.done_all, color: AppTheme.bodyTextTime.color)
                        : CircleAvatar(
                        radius: 8,
                        backgroundColor: AppTheme.unreadChatBG,
                        child: Text(group.unreadCount.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
                    SizedBox(height: 10),
                    Text(group.time, style: AppTheme.bodyTextTime),
                  ],
                ),
              ),
            );
          },
        )),
      ],
    );
  }
}
