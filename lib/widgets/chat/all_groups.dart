import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../controllers/group_chat_controller.dart';
import '../../constants/theme.dart';
import '../../screens/chat/group_chat_page.dart';

class AllGroups extends StatelessWidget {
  final GroupChatController controller = Get.find();

  AllGroups({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16),
          child: Row(
            children: [
              Text('All Groups', style: AppTheme.heading2),
            ],
          ),
        ),
        Obx(() => ListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: controller.allGroups.length,
  itemBuilder: (context, index) {
    final group = controller.allGroups[index];

                // Avatar image
                ImageProvider<Object> avatarImage;
                if (group.avatar.startsWith('http')) {
                  avatarImage = NetworkImage(group.avatar);
                } else if (group.avatar.startsWith('/')) {
                  avatarImage = FileImage(File(group.avatar));
                } else if (group.avatar.isNotEmpty) {
                  avatarImage = AssetImage(group.avatar);
                } else {
                  avatarImage =
                      const AssetImage('assets/images/default_group_avatar.png');
                }

                // Last message and time
                final lastMessage =
                    group.messages.isNotEmpty ? group.messages.last : null;
                final lastMessageText =
                    lastMessage?.content ?? 'No messages yet';
                final lastMessageTime =
                    lastMessage?.createdAt ?? DateTime.now();

                // Unread count (identique à RecentGroups)
                final unreadCount = group.messages
                    .where((m) =>
                        m.senderId != controller.currentUser.id &&
                        !m.isReadBy.contains(controller.currentUser.id))
                    .length;

                return GestureDetector(
                  onTap: () async {
                    await controller.markMessagesAsRead(group.id);
                    Get.to(() => GroupChatPage(group: group));
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage: avatarImage,
                      onBackgroundImageError: (_, __) {},
                    ),
                    title: Text(
                      group.name,
                      style: AppTheme.heading2.copyWith(fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lastMessageText,
                          style: AppTheme.bodyText1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${group.members.length} members',
                          style: AppTheme.bodyText1.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (unreadCount > 0)
                          CircleAvatar(
                            radius: 8,
                            backgroundColor: AppTheme.unreadChatBG,
                            child: Text(
                              unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          const Icon(
                            Icons.done_all,
                            color: Colors.grey,
                            size: 16,
                          ),
                        const SizedBox(height: 6),
                        Text(
                          lastMessage != null
                              ? _formatTime(lastMessageTime)
                              : '',
                          style: AppTheme.bodyTextTime,
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays == 0) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${time.day}/${time.month}';
    }
  }
}
