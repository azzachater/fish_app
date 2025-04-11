import 'package:flutter/material.dart';
import '../../models/group_message_model.dart';
import '../../models/group_conversation_model.dart';
import '../../constants/theme.dart';
import 'dart:io';

class GroupConversationWidget extends StatelessWidget {
  final GroupConversation group;
  final List<GroupMessage> messages;
  final int currentUserId;
  final ScrollController? scrollController;

  const GroupConversationWidget({
    super.key,
    required this.group,
    required this.messages,
    required this.currentUserId,
    this.scrollController,
  });

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
    // Les messages sont déjà triés par le contrôleur
    return ListView.builder(
      controller: scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.senderId == currentUserId;

        return Container(
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isMe)
                    CircleAvatar(
                      radius: 15,
                      backgroundImage: _buildImageProvider(message.sender.avatar),
                    ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    decoration: BoxDecoration(
                      color: isMe
                          ? AppTheme.primaryColor
                          : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft:
                            Radius.circular(isMe ? 12 : 0),
                        bottomRight:
                            Radius.circular(isMe ? 0 : 12),
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
                padding: const EdgeInsets.only(top: 5, left: 50, right: 10),
                child: Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.done_all,
                      size: 20,
                      color: AppTheme.bodyTextTime.color,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(message.createdAt),
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
  }

  String _formatTime(DateTime dateTime) {
    final time = TimeOfDay.fromDateTime(dateTime);
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }
}