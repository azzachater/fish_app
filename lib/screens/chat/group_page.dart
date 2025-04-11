import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/group_chat_controller.dart';
import '../../widgets/chat/recent_group_chat.dart';
import '../../widgets/chat/all_groups.dart';
import '../../constants/theme.dart';

class GroupPage extends StatelessWidget {
  final GroupChatController controller = Get.put(GroupChatController());

  GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.allGroups.isEmpty ) {
        return Center(
          child: Text('No groups available', style: AppTheme.bodyText1),
        );
      }

      return SingleChildScrollView(
        child: Column(
          children: [
            RecentGroups(),
            AllGroups(),
          ],
        ),
      );
    });
  }
}
