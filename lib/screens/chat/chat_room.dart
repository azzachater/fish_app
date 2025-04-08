import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../constants/theme.dart';
import '../../models/user_model.dart';
import '../../widgets/chat/chat_composer.dart';
import '../../controllers/chat_controller.dart';

class ChatRoom extends StatelessWidget {
  final User user;
  final ChatController chatController = Get.find();

   ChatRoom({super.key, required this.user});

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
    // Trouver la conversation existante
    final conversation = chatController.conversations.firstWhereOrNull(
      (conv) => conv.userOne.id == user.id || conv.userTwo.id == user.id
    );

    // Charger les messages au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (conversation != null) {
        chatController.loadMessages(conversation.id);
      } else {
        chatController.conversationMessages.assignAll([]);
      }
    });

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
              backgroundImage: _buildImageProvider(user.avatar),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: AppTheme.chatSenderName),
                Text('online', style: AppTheme.bodyText1.copyWith(fontSize: 18)),
              ],
            ),
          ],
        ),
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
                  if (chatController.isLoading.value && 
                      chatController.conversationMessages.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: chatController.conversationMessages.length,
                    itemBuilder: (context, index) {
                      final message = chatController.conversationMessages[index];
                      final isMe = message.sender.id == chatController.currentUser.value?.id;

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
                                    color: isMe 
                                        ? AppTheme.primaryColor 
                                        : Colors.grey[200],
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
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
           ChatComposer(
  user: user,
  onSendMessage: (text) async {
    try {
      await chatController.sendMessage(text, user.id);
    } catch (e) {
      //
    }
  },
),
          ],
        ),
      ),
    );
  }
}