import '../../models/message_model.dart';
//import '../../screens/chat/chat_page.dart';
import '../../screens/chat/chat_room.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/theme.dart';

class AllChats extends StatelessWidget {
  const AllChats({Key? key}) : super(key: key);
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
        ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: allChats.length,
            itemBuilder: (context, int index) {
              final allChat = allChats[index];
              return Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage(allChat.avatar),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return ChatRoom(user: allChat.sender);
                          }));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              allChat.sender.name,
                              style: AppTheme.heading2.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              allChat.text,
                              style: AppTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          allChat.unreadCount == 0
                              ? Icon(
                                  Icons.done_all,
                                  color: AppTheme.bodyTextTime.color,
                                )
                              : CircleAvatar(
                                  radius: 8,
                                  backgroundColor: AppTheme.unreadChatBG,
                                  child: Text(
                                    allChat.unreadCount.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            allChat.time,
                            style: AppTheme.bodyTextTime,
                          )
                        ],
                      ),
                    ],
                  ));
            })
      ],
    );
  }
}