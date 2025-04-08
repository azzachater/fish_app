import './user_model.dart';

class Message {
  final int id;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final User sender;

  Message({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.isRead,
    required this.sender,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      isRead: json['is_read'] ?? false,
      sender: User.fromJson(json['sender']),
    );
  }
}
