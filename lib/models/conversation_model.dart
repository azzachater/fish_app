/*import 'message_model.dart';
import 'user_model.dart';
class Conversation {
  final int id;
  final User userOne;
  final User userTwo;
  final List<Message> messages;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.userOne,
    required this.userTwo,
    required this.messages,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      userOne: User.fromJson(json['user_one'] ?? json['userOne']),
      userTwo: User.fromJson(json['user_two'] ?? json['userTwo']),
      messages: (json['messages'] as List)
          .map((msg) => Message.fromJson(msg))
          .toList(),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}*/