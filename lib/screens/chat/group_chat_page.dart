import 'package:flutter/material.dart';
import '../../models/group_model.dart';
import '../../models/message_model.dart';
import '../../constants/theme.dart';
import '../../widgets/chat/group_conversation.dart';
import '../../widgets/chat/chat_composer.dart'; // Import the ChatComposer widget
import 'add_user_to_group_page.dart';
import '../../data/user_data.dart'; // Import currentUser
import '../../data/message_data.dart'; // Import groupMessages

class GroupChatPage extends StatefulWidget {
  const GroupChatPage({super.key, required this.group});

  final Group group;

  @override
  GroupChatPageState createState() => GroupChatPageState();
}

class GroupChatPageState extends State<GroupChatPage> {
  List<Message> groupMessagesForThisGroup = [];

  @override
  void initState() {
    super.initState();
    // Load existing messages for the group
    groupMessagesForThisGroup = groupMessages
        .where((message) => message.groupId == widget.group.id)
        .toList();
  }

  void _handleSendMessage(String text) {
    final newMessage = Message(
      sender: currentUser,
      groupId: widget.group.id,
      avatar: currentUser.avatar,
      text: text,
      time: 'Now', // You can replace this with the actual time
      unreadCount: 0,
      isRead: true,
    );

    setState(() {
      groupMessagesForThisGroup.insert(0, newMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        toolbarHeight: 100,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(widget.group.avatar),
            ),
            SizedBox(width: 20),
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
            icon: Icon(Icons.add, size: 28, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddUserToGroupPage(group: widget.group),
                ),
              );
            },
          ),
        ],
        elevation: 0,
      ),
      backgroundColor: AppTheme.primaryColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: GroupConversation(
                    group: widget.group,
                    messages: groupMessagesForThisGroup,
                  ),
                ),
              ),
            ),
            ChatComposer(
              onSendMessage: _handleSendMessage,
            ),
          ],
        ),
      ),
    );
  }
}