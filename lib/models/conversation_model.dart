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
    dynamic lastMessage;
    if (json['last_message'] is Map) {
      lastMessage = json['last_message'];
    } else if (json['messages'] is List && json['messages'].isNotEmpty) {
      lastMessage = json['messages'][0];
    }

    int unreadCount = 0;
    if (json['unread_count'] is int) {
      unreadCount = json['unread_count'];
    } else if (json['unread_count'] is String) {
      unreadCount = int.tryParse(json['unread_count']) ?? 0;
    }

    // Safely parse 'id' field as integer
    int id = 0;
    if (json['id'] is int) {
      id = json['id'];
    } else if (json['id'] is String) {
      id = int.tryParse(json['id']) ?? 0;
    }

    return Conversation(
      id: id,
      userOne: User.fromJson(json['user_one'] is Map ? json['user_one'] : {}),
      userTwo: User.fromJson(json['user_two'] is Map ? json['user_two'] : {}),
      lastMessage: lastMessage != null ? Message.fromJson(lastMessage) : null,
      unreadCount: unreadCount,
      messages: json['messages'] is List
          ? (json['messages'] as List).map((m) => Message.fromJson(m is Map ? Map<String, dynamic>.from(m) : {})).toList()
          : [],
    );
  } catch (e) {
    print('❌ Error parsing Conversation: $e');
    print('❌ Problematic JSON: $json');
    rethrow;
  }
}


}