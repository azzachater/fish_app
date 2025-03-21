import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import 'package:flutter/cupertino.dart';
import '../../screens/chat/group_chat_page.dart';
import '../../data/group_data.dart';
import '../../models/group_model.dart';
import 'dart:io'; // Import to use FileImage

class RecentGroups extends StatefulWidget {
  const RecentGroups({super.key});

  @override
  RecentGroupsState createState() => RecentGroupsState();
}

class RecentGroupsState extends State<RecentGroups> {
  final List<Group> _recentGroups = recentGroups;

  void markGroupAsRead(int index) {
    setState(() {
      _recentGroups[index] = _recentGroups[index].copyWith(isRead: true, unreadCount: 0);
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
                'Recent Groups',
                style: AppTheme.heading2,
              ),
              Spacer(),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: _recentGroups.length,
          itemBuilder: (context, int index) {
            final recentGroup = _recentGroups[index];

            // Check if the avatar is a file or asset path
            ImageProvider avatarImage;
            if (recentGroup.avatar.startsWith('/')) {
              // If the avatar starts with '/', it's a local file
              avatarImage = FileImage(File(recentGroup.avatar));
            } else {
              // Otherwise, it's an asset image
              avatarImage = AssetImage(recentGroup.avatar);
            }

            return Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: avatarImage, // Use appropriate ImageProvider
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      markGroupAsRead(index);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => GroupChatPage(group: recentGroup),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          recentGroup.name,
                          style: AppTheme.heading2.copyWith(fontSize: 16),
                        ),
                        Text(
                          '${recentGroup.members.length} members',
                          style: AppTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      recentGroup.unreadCount == 0
                          ? Icon(
                              Icons.done_all,
                              color: AppTheme.bodyTextTime.color,
                            )
                          : CircleAvatar(
                              radius: 8,
                              backgroundColor: AppTheme.unreadChatBG,
                              child: Text(
                                recentGroup.unreadCount.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                      SizedBox(height: 10),
                      Text(
                        recentGroup.time,
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
