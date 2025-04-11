import 'user_model.dart';

class GroupMessage {
  final int id;
  final String content;
  final int senderId;
  final User sender;
  final int groupConversationId;
  final DateTime createdAt;
  final List<int> isReadBy; // 👈 nouveau champ

  GroupMessage({
    required this.id,
    required this.content,
    required this.senderId,
    required this.sender,
    required this.groupConversationId,
    required this.createdAt,
    required this.isReadBy,
  });

  factory GroupMessage.fromJson(Map<String, dynamic> json) {
    return GroupMessage(
      id: json['id'],
      content: json['content'],
      senderId: json['sender_id'],
      sender: User.fromJson(json['sender']),
      groupConversationId: json['group_conversation_id'],
      createdAt: DateTime.parse(json['created_at']),
      isReadBy: List<int>.from(json['is_read_by'] ?? []), // 👈 récupérer les ID
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender_id': senderId,
      'sender': sender.toJson(),
      'group_conversation_id': groupConversationId,
      'created_at': createdAt.toIso8601String(),
      'is_read_by': isReadBy, // 👈 inclure dans le JSON
    };
  }
}
