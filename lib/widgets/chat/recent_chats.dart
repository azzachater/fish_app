import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat_controller.dart';
import '../../screens/chat/chat_room.dart';
import '../../constants/theme.dart';

class RecentChats extends StatelessWidget {
final ChatController chatController = Get.put(ChatController());

   RecentChats({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 30),
          child: Row(
            children: [
              Text(
                'Recent Chats',
                style: AppTheme.heading2,
              ),
              Spacer(),
            ],
          ),
        ),
        Obx(() => ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: chatController.recentChats.length,
              itemBuilder: (context, int index) {
                final recentChat = chatController.recentChats[index];
                return GestureDetector(
                  onTap: () {
                    chatController.markMessageAsRead(index, true);
                    Get.to(() => ChatRoom(user: recentChat.sender));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(recentChat.avatar),
                    ),
                    title: Text(
                      recentChat.sender.name,
                      style: AppTheme.heading2.copyWith(fontSize: 16),
                    ),
                    subtitle: Text(recentChat.text, style: AppTheme.bodyText1),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        recentChat.unreadCount == 0
                            ? Icon(Icons.done_all, color: AppTheme.bodyTextTime.color)
                            : CircleAvatar(
                                radius: 8,
                                backgroundColor: AppTheme.unreadChatBG,
                                child: Text(
                                  recentChat.unreadCount.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                        SizedBox(height: 10),
                        Text(recentChat.time, style: AppTheme.bodyTextTime),
                      ],
                    ),
                  ),
                );
              },
            )),
      ],
    );
  }
}
