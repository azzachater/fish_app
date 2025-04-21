import './user_model.dart';

class Message {
  final int id;
  final String content;
  final DateTime createdAt;
 bool isRead;
  final User sender;

  Message({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.isRead,
    required this.sender,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
  print("🔍 Message JSON: $json");
  return Message(
    id: json['id'] ?? 0,
    content: json['content'] ?? '',
    createdAt: DateTime.parse(json['created_at']),
    isRead: json['is_read'].toString() == '1',
    sender: User.fromJson(json['sender'] ?? {}),
  );
}
}