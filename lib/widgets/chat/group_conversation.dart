/*
// lib/widgets/chat/group_conversation.dart
import 'package:flutter/material.dart';
import '../../models/group_model.dart';
import '../../models/message_model.dart';
import '../../constants/theme.dart';
import '../../data/user_data.dart';

class GroupConversation extends StatelessWidget {
  final Group group;
  final List<Message> messages;

  const GroupConversation({
    super.key,
    required this.group,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        bool isMe = message.sender.id == currentUser.id;
        
        return Container(
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isMe)
                    CircleAvatar(
                      radius: 15,
                      backgroundImage: AssetImage(message.avatar),
                    ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
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
                      message.text,
                      style: AppTheme.bodyTextMessage.copyWith(
                        color: isMe ? Colors.white : Colors.grey[800]),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (!isMe)
                      const SizedBox(width: 40),
                    Icon(
                      Icons.done_all,
                      size: 20,
                      color: AppTheme.bodyTextTime.color,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      message.time,
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
}
*/