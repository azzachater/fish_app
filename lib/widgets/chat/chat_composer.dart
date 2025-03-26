import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import '../../models/user_model.dart';

class ChatComposer extends StatelessWidget {
  final User user;
  final Function(String) onSendMessage;

  const ChatComposer({
    super.key, 
    required this.onSendMessage, 
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    void sendMessage() {
      if (controller.text.isNotEmpty) {
        onSendMessage(controller.text); // Seulement la callback parente
        controller.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message sent')),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      height: 100,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type your message ...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      onSubmitted: (_) => sendMessage(),
                    ),
                  ),
                  Icon(
                    Icons.attach_file,
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: sendMessage,
            child: CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}