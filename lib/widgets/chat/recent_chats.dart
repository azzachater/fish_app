import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../models/message_model.dart';
//import '../../screens/chat/chat_page.dart';
import '../../screens/chat/chat_room.dart';
import '../../data/message_data.dart';

import '../../constants/theme.dart';

class RecentChats extends StatefulWidget {
  const RecentChats({super.key});

  @override
  RecentChatsState createState() => RecentChatsState();
}

class RecentChatsState extends State<RecentChats> {
  final List<Message> _recentChats = recentChats;

  void markMessageAsRead(int index) {
    setState(() {
      _recentChats[index] = _recentChats[index].copyWith(isRead: true, unreadCount: 0);
    });
  }

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
        ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: _recentChats.length,
          itemBuilder: (context, int index) {
            final recentChat = _recentChats[index];
            return Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(recentChat.avatar),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      markMessageAsRead(index); // Marquer le message comme lu
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ChatRoom(user: recentChat.sender),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          recentChat.sender.name,
                          style: AppTheme.heading2.copyWith(fontSize: 16),
                        ),
                        Text(
                          recentChat.text,
                          style: AppTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      recentChat.unreadCount == 0
                          ? Icon(
                              Icons.done_all,
                              color: AppTheme.bodyTextTime.color,
                            )
                          : CircleAvatar(
                              radius: 8,
                              backgroundColor: AppTheme.unreadChatBG,
                              child: Text(
                                recentChat.unreadCount.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                      SizedBox(height: 10),
                      Text(
                        recentChat.time,
                        style: AppTheme.bodyTextTime,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}