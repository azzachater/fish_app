import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../constants/theme.dart';
import '../../models/user_model.dart';
import '../../widgets/chat/chat_composer.dart';
import '../../controllers/chat_controller.dart';
import '../../models/conversation_model.dart';
import '../../models/message_model.dart';

class ChatRoom extends StatefulWidget {
  final User user;
  const ChatRoom({super.key, required this.user});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final ChatController chatController = Get.find();
  late final Conversation? _conversation;

  @override
  void initState() {
    super.initState();
    _conversation = chatController.conversations.firstWhereOrNull(
      (conv) =>
          conv.userOne.id == widget.user.id ||
          conv.userTwo.id == widget.user.id,
    );
    _loadMessages();
  }

  void _loadMessages() {
    if (_conversation != null) {
      chatController.loadMessages(_conversation.id);
      chatController.subscribeToConversationChannel(_conversation.id);
    } else {
      chatController.conversationMessages.assignAll([]);
    }
  }

  ImageProvider _buildImageProvider(String avatarPath) {
    if (avatarPath.isEmpty)
      return const AssetImage('assets/images/default_avatar.png');
    if (avatarPath.startsWith('http')) return NetworkImage(avatarPath);
    if (avatarPath.startsWith('assets/')) return AssetImage(avatarPath);
    return FileImage(File(avatarPath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        toolbarHeight: 100,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: _buildImageProvider(widget.user.avatar),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user.name, style: AppTheme.chatSenderName),
                Text(
                  'online',
                  style: AppTheme.bodyText1.copyWith(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
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
                    final isMe =
                        message.sender.id ==
                        chatController.currentUser.value?.id;
                    return _buildMessageBubble(message, isMe, context);
                  },
                );
              }),
            ),
          ),
          ChatComposer(
            onSendMessage: (text) {
              chatController.sendMessage(text, widget.user.id);
            },
            user: widget.user,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe)
                CircleAvatar(
                  radius: 15,
                  backgroundImage: _buildImageProvider(widget.user.avatar),
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
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isMe) const SizedBox(width: 40),
                Icon(
                  Icons.done_all,
                  size: 20,
                  color:
                      message.isRead
                          ? AppTheme.primaryColor
                          : AppTheme.bodyTextTime.color,
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
  }
}
