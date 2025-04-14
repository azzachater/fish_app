import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/group_conversation_model.dart';
import '../../constants/theme.dart';
import '../../widgets/chat/group_conversation.dart';
import '../../widgets/chat/chat_composer.dart';
import 'add_user_to_group_page.dart';
import '../../controllers/group_chat_controller.dart';
import 'dart:io';

class GroupChatPage extends StatefulWidget {
  final GroupConversation group;

  const GroupChatPage({super.key, required this.group});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final GroupChatController groupController = Get.find<GroupChatController>();
  final ScrollController _scrollController = ScrollController();
    late int currentGroupId;


 @override
  void initState() {
    super.initState();
    currentGroupId = widget.group.id;
    groupController.currentGroupId.value = currentGroupId;
    
    // S'abonner une seule fois
    WidgetsBinding.instance.addPostFrameCallback((_) {
      groupController.subscribeToGroupChannel(currentGroupId);
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  ImageProvider _buildImageProvider(String avatarPath) {
    if (avatarPath.isEmpty) return const AssetImage('assets/images/default_group_avatar.png');
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
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: _buildImageProvider(widget.group.avatar),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.group.name,
                  style: AppTheme.chatSenderName,
                ),
                Text(
                  '${widget.group.members.length} members',
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
              Get.to(() => AddUserToGroupPage(group: widget.group));
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
                child: GetBuilder<GroupChatController>(
  id: 'group_messages_${widget.group.id}',
  builder: (controller) {
    final messages = controller.groupMessages
        .where((m) => m.groupConversationId == widget.group.id)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });

    return GroupConversationWidget(
      group: widget.group,
      messages: messages,
      currentUserId: controller.currentUser.id,
      scrollController: _scrollController,
    );
  },
),
              ),
            ),
            ChatComposer(
              onSendMessage: (text) {
                groupController.sendMessage(widget.group.id, text);
              },
              user: groupController.currentUser,
            ),
          ],
        ),
      ),
    );
  }
}