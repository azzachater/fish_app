import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/chat_controller.dart';
import '../../screens/chat/chat_room.dart';
import '../../models/user_model.dart';
import '../../models/conversation_model.dart';
import '../../constants/theme.dart';

class AllChats extends StatelessWidget {
 final ChatController chatController = Get.put(ChatController());
  AllChats({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Text('All Chats', style: AppTheme.heading2),
            ],
          ),
        ),
        Obx(() {
          final currentUser = chatController.currentUser.value;
          if (currentUser == null) return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: chatController.sortedConversations.length,
            itemBuilder: (context, index) {
              final conversation = chatController.sortedConversations[index];
              final otherUser = chatController.getOtherUser(conversation);
              final unreadCount = chatController.getUnreadCountForConversation(conversation.id);

              return _buildConversationTile(conversation, otherUser, unreadCount, context);
            },
          );
        }),
      ],
    );
  }

  Widget _buildConversationTile(Conversation conversation, User otherUser, int unreadCount, BuildContext context) {
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
        title: Text(otherUser.name, style: AppTheme.heading2.copyWith(fontSize: 16)),
        subtitle: Text(
          conversation.lastMessage?.content ?? '',
          style: AppTheme.bodyText1,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (unreadCount > 0)
              CircleAvatar(
                radius: 12,
                backgroundColor: AppTheme.unreadChatBG,
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              conversation.lastMessage != null
                  ? DateFormat('HH:mm').format(conversation.lastMessage!.createdAt)
                  : '',
              style: AppTheme.bodyTextTime,
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _buildImageProvider(String avatarPath) {
    if (avatarPath.isEmpty) return const AssetImage('assets/images/default_avatar.png');
    if (avatarPath.startsWith('http')) return NetworkImage(avatarPath);
    if (avatarPath.startsWith('assets/')) return AssetImage(avatarPath);
    return FileImage(File(avatarPath));
  }
}