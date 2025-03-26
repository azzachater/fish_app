// lib/views/group_chat/group_chat_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/group_model.dart';
import '../../constants/theme.dart';
import '../../widgets/chat/group_conversation.dart';
import '../../widgets/chat/chat_composer.dart';
import 'add_user_to_group_page.dart';
import '../../controllers/group_controller.dart';
import 'dart:io';
import '../../data/user_data.dart';

class GroupChatPage extends StatelessWidget {
  final Group group;

  const GroupChatPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final GroupController groupController = Get.find<GroupController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        toolbarHeight: 100,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: group.avatar.startsWith('/')
                  ? FileImage(File(group.avatar))
                  : AssetImage(group.avatar) as ImageProvider,
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: AppTheme.chatSenderName,
                ),
                Text(
                  '${group.members.length} members',
                  style: AppTheme.bodyText1.copyWith(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 28, color: Colors.white),
            onPressed: () {
              Get.to(() => AddUserToGroupPage(group: group));
            },
          ),
        ],
        elevation: 0,
      ),
      backgroundColor: AppTheme.primaryColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Obx(() {
                  final messages = groupController.groupMessages
                      .where((m) => m.groupId == group.id)
                      .toList()
                      .reversed
                      .toList();
                  
                  return GroupConversation(
                    group: group,
                    messages: messages,
                  );
                }),
              ),
            ),
           ChatComposer(
  onSendMessage: (text) {
    groupController.sendGroupMessage(text, group.id); // Un seul envoi ici
  },
  user: currentUser,
),
          ],
        ),
      ),
    );
  }
}