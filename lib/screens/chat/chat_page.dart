import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/controllers/chat_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../widgets/chat/chat_widgets.dart';

class ChatPage extends StatelessWidget {
    final ChatController controller = Get.put(ChatController());

   ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.conversations.isEmpty ) {
        return Center(
          child: Text('No chat available', style: AppTheme.bodyText1),
        );
      }
      return SingleChildScrollView(
        child: Column(
          children: [
            RecentChats(key: key),
            AllChats(key: key),
          ],
        ),
      );
    });
  }
}
