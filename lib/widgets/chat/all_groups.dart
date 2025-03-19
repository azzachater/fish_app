import 'package:flutter/material.dart';
import '../../models/group_model.dart';
import '../../constants/theme.dart';
import 'package:flutter/cupertino.dart'; // Import CupertinoPageRoute
import '../../screens/chat/group_chat_page.dart'; 
import '../../data/group_data.dart';// Import GroupChatPage

class AllGroups extends StatefulWidget {
  const AllGroups({super.key});

  @override
  AllGroupsState createState() => AllGroupsState();
}

class AllGroupsState extends State<AllGroups> {
 final List<Group> _allGroups = allGroups;

  void markGroupAsRead(int index) {
    setState(() {
      _allGroups[index] = _allGroups[index].copyWith(isRead: true, unreadCount: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Text(
                'All Groups',
                style: AppTheme.heading2,
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: _allGroups.length,
          itemBuilder: (context, int index) {
            final allGroup = _allGroups[index];
            return Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(allGroup.avatar),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      markGroupAsRead(index); // Marquer le groupe comme lu
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => GroupChatPage(group: allGroup),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          allGroup.name,
                          style: AppTheme.heading2.copyWith(fontSize: 16),
                        ),
                        Text(
                          '${allGroup.members.length} members',
                          style: AppTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      allGroup.unreadCount == 0
                          ? Icon(
                              Icons.done_all,
                              color: AppTheme.bodyTextTime.color,
                            )
                          : CircleAvatar(
                              radius: 8,
                              backgroundColor: AppTheme.unreadChatBG,
                              child: Text(
                                allGroup.unreadCount.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                      SizedBox(height: 10),
                      Text(
                        allGroup.time,
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