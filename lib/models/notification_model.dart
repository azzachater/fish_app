class NotificationModel {
  final int id;
  final int senderId;
  final int receiverId;
  final String message;
  final String type;
  final int? conversationId;
  final int? groupConversationId;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.type,
    this.conversationId,
    this.groupConversationId,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
  return NotificationModel(
    id: json['id'] as int? ?? 0,
    senderId: json['sender_id'] as int? ?? 0,
    receiverId: int.tryParse(json['receiver_id'].toString()) ?? 0, // Conversion robuste
    message: json['message'] as String? ?? '',
    type: json['type'] as String? ?? 'message',
    conversationId: json['conversation_id'] as int?,
    groupConversationId: json['group_conversation_id'] as int?,
    isRead: (json['is_read'] as int?) == 1,
    createdAt: json['created_at'] != null 
        ? DateTime.parse(json['created_at'] as String) 
        : DateTime.now(),
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'type': type,
      'conversation_id': conversationId,
      'group_conversation_id': groupConversationId,
      'is_read': isRead ? 1 : 0, // Conversion inverse ici
      'created_at': createdAt.toIso8601String(),
    };
  }
}