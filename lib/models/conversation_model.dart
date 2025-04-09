import 'message_model.dart';
import 'user_model.dart';

class Conversation {
  final int id;
  final User userOne;
  final User userTwo;
  final Message? lastMessage;
  final int unreadCount;
  final List<Message> messages;

  Conversation({
    required this.id,
    required this.userOne,
    required this.userTwo,
    this.lastMessage,
    this.unreadCount = 0,
    this.messages = const [],
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    try {
      return Conversation(
        id: json['id'] as int,
        userOne: User.fromJson(json['user_one']),
        userTwo: User.fromJson(json['user_two']),
        lastMessage: json['last_message'] != null 
            ? Message.fromJson(json['last_message'])
            : null,
        unreadCount: (json['unread_count'] as int?) ?? 0,
        messages: json['messages'] is List 
            ? (json['messages'] as List).map((m) => Message.fromJson(m)).toList()
            : [],
      );
    } catch (e) {
      print('Error parsing Conversation: $e');
      rethrow;
    }
  }
}