import 'package:flutter/material.dart';
import '../../widgets/chat/chat_widgets.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          RecentChats(key: key),
          AllChats(key: key),
        ],
      ),
    );
  }
}