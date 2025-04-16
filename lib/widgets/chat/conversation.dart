import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/user_model.dart';
import '../../constants/theme.dart';
import '../../controllers/chat_controller.dart';

class Conversation extends StatelessWidget {
  final User user;
  final ChatController chatController = Get.find();

  Conversation({super.key, required this.user});

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
    return Obx(() {
      final currentUser = chatController.currentUser.value;
      if (currentUser == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView.builder(
        reverse: true,
        itemCount: chatController.conversationMessages.length,
        itemBuilder: (context, int index) {
          final message = chatController.conversationMessages[index];
          final isMe = message.sender.id == currentUser.id;

          return Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: isMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!isMe)
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: _buildImageProvider(user.avatar),
                      ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6,
                      ),
                      decoration: BoxDecoration(
                        color: isMe ? AppTheme.primaryColor : Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMe ? 12 : 0),
                          bottomRight: Radius.circular(isMe ? 0 : 12),
                        ),
                      ),
                      child: Text(
                        message.content,
                        style: AppTheme.bodyTextMessage.copyWith(
                          color: isMe ? Colors.white : Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      if (!isMe) const SizedBox(width: 40),
                      Icon(
                        Icons.done_all,
                        size: 20,
                        color: AppTheme.bodyTextTime.color,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('HH:mm').format(message.createdAt),
                        style: AppTheme.bodyTextTime,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }
}