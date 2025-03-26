import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/group_controller.dart';
import '../../widgets/chat/recent_group_chat.dart';
import '../../widgets/chat/all_groups.dart';
import '../../constants/theme.dart';

class GroupPage extends StatelessWidget {
  final GroupController controller = Get.put(GroupController());

  GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.allGroups.isEmpty && controller.recentGroups.isEmpty) {
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
