import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/chat_controller.dart';
import '../../screens/chat/chat_room.dart';
import '../../constants/theme.dart';

class AllChats extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());

   AllChats({super.key});

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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Text(
                'All Chats',
                style: AppTheme.heading2,
              ),
            ],
          ),
        ),
        Obx(() {
          final currentUser = chatController.currentUser.value;
          if (currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: chatController.conversations.length,
            itemBuilder: (context, int index) {
              final conversation = chatController.conversations[index];

              // Déterminer l'autre utilisateur
              final otherUser = (currentUser.id == conversation.userOne.id)
                  ? conversation.userTwo
                  : conversation.userOne;

              final lastMessage = conversation.messages.isNotEmpty 
                  ? conversation.messages.last 
                  : null;

              return GestureDetector(
                onTap: () {
                  chatController.loadMessages(conversation.id);
                  Get.to(() => ChatRoom(user: otherUser));
                },
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: _buildImageProvider(otherUser.avatar),
                  ),
                  title: Text(
                    otherUser.name,
                    style: AppTheme.heading2.copyWith(fontSize: 16),
                  ),
                  subtitle: Text(
                    lastMessage?.content ?? '',
                    style: AppTheme.bodyText1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      lastMessage?.isRead == true
                          ? Icon(Icons.done_all, color: AppTheme.bodyTextTime.color)
                          : CircleAvatar(
                              radius: 8,
                              backgroundColor: AppTheme.unreadChatBG,
                              child: const Text(
                                '1',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                      const SizedBox(height: 10),
                      Text(
                        lastMessage != null
                            ? DateFormat('HH:mm').format(lastMessage.createdAt)
                            : '',
                        style: AppTheme.bodyTextTime,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}