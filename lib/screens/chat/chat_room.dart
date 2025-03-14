import '../../constants/theme.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../widgets/chat/chat_widgets.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        toolbarHeight: 100,
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                widget.user.avatar,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: AppTheme.chatSenderName,
                ),
                Text(
                  'online',
                  style: AppTheme.bodyText1.copyWith(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.add,
                size: 28,
                color: Colors.white,
              ),
              onPressed: () {})
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
                  child: Conversation(
                    key: widget.key, // Pass the key parameter
                    user: widget.user,
                  ),
                ),
              ),
            ),
            buildChatComposer()
          ],
        ),
      ),
    );
  }
}