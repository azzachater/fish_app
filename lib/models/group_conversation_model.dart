import 'user_model.dart';
import 'group_message_model.dart';

class GroupConversation {
  final int id;
  final String name;
  final String avatar;
  final int ownerId;
  List<User> members;
  List<GroupMessage> messages;
  GroupMessage? lastMessage;
  int unreadCount;

  GroupConversation({
    required this.id,
    required this.name,
    required this.avatar,
    required this.ownerId,
    required this.members,
    this.messages = const [],
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory GroupConversation.fromJson(Map<String, dynamic> json) {
    var memberList = (json['members'] as List).map((e) => User.fromJson(e)).toList();
    var messageList = (json['messages'] as List?)?.map((e) => GroupMessage.fromJson(e)).toList() ?? [];
    return GroupConversation(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'] ?? 'assets/images/default_group_avatar.png',
      ownerId: json['owner_id'],
      members: memberList,
      messages: messageList,
      lastMessage: json['last_message'] != null ? GroupMessage.fromJson(json['last_message']) : null,
      unreadCount: json['unread_count'] ?? 0,
    );
  }


User get admin => members.firstWhere((u) => u.id == ownerId, orElse: () => User(id: ownerId, name: "Unknown", avatar: 'assets/images/default_avatar.png', email: '', bio: ''));

  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'owner_id': ownerId,
      'members': members.map((e) => e.toJson()).toList(),
      'messages': messages.map((e) => e.toJson()).toList(),
    };
  }
}