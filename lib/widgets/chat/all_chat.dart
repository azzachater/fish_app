import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat_controller.dart';
import '../../screens/chat/chat_room.dart';
import '../../constants/theme.dart';

class AllChats extends StatelessWidget {
final ChatController chatController = Get.put(ChatController());

   AllChats({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Text(
                'All Chats',
                style: AppTheme.heading2,
              ),
            ],
          ),
        ),
        Obx(() => ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: chatController.allChats.length,
              itemBuilder: (context, int index) {
                final allChat = chatController.allChats[index];
                return GestureDetector(
                  onTap: () {
                    chatController.markMessageAsRead(index, false);
                    Get.to(() => ChatRoom(user: allChat.sender));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(allChat.avatar),
                    ),
                    title: Text(
                      allChat.sender.name,
                      style: AppTheme.heading2.copyWith(fontSize: 16),
                    ),
                    subtitle: Text(allChat.text, style: AppTheme.bodyText1),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        allChat.unreadCount == 0
                            ? Icon(Icons.done_all, color: AppTheme.bodyTextTime.color)
                            : CircleAvatar(
                                radius: 8,
                                backgroundColor: AppTheme.unreadChatBG,
                                child: Text(
                                  allChat.unreadCount.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                        SizedBox(height: 10),
                        Text(allChat.time, style: AppTheme.bodyTextTime),
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
