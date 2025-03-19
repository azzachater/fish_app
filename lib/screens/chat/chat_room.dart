import '../../constants/theme.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/message_model.dart';
import '../../widgets/chat/chat_widgets.dart';
import '../../widgets/chat/chat_composer.dart';
import '../../data/user_data.dart';
import '../../data/message_data.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key, required this.user});
  final User user;

  @override
  ChatRoomState createState() => ChatRoomState();
}

class ChatRoomState extends State<ChatRoom> {
  List<Message> conversationMessages = [];

  @override
  void initState() {
    super.initState();
    // Charger les messages existants entre l'utilisateur actuel et l'utilisateur sélectionné
    conversationMessages = messages
        .where((message) =>
            (message.sender.id == widget.user.id && message.receiver?.id == currentUser.id) ||
            (message.sender.id == currentUser.id && message.receiver?.id == widget.user.id))
        .toList();
  }

  void _handleSendMessage(String text) {
    final newMessage = Message(
      sender: currentUser,
      receiver: widget.user,
      text: text,
      time: 'Now',
      avatar: 'assets/images/users/addison.png',
      unreadCount: 1,
      isRead: false, // You can replace this with the actual time
    );

    setState(() {
      conversationMessages.insert(0, newMessage);
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
              backgroundImage: AssetImage(widget.user.avatar),
            ),
            SizedBox(width: 20),
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
                  child: ListView.builder(
                    reverse: true,
                    itemCount: conversationMessages.length,
                    itemBuilder: (context, index) {
                      final message = conversationMessages[index];
                      bool isMe = message.sender.id == currentUser.id;
                      return Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!isMe)
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundImage: AssetImage(widget.user.avatar),
                                  ),
                                SizedBox(width: 10),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.6),
                                  decoration: BoxDecoration(
                                    color: isMe ? AppTheme.primaryColor : Colors.grey[200],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
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
                                    SizedBox(width: 40),
                                  Icon(
                                    Icons.done_all,
                                    size: 20,
                                    color: AppTheme.bodyTextTime.color,
                                  ),
                                  SizedBox(width: 8),
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
                  ),
                ),
              ),
            ),
            ChatComposer(onSendMessage: _handleSendMessage),
          ],
        ),
      ),
    );
  }
}