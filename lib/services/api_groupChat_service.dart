import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fish_app/service/api_auth_service.dart';
import '../models/group_conversation_model.dart';
import '../models/group_message_model.dart';


class ApiGroupChatService {
  final String baseUrl = 'http://192.168.3.18:8000/api';
  final ApiAuthService _authService;

  ApiGroupChatService({ApiAuthService? authService}) : _authService = authService ?? ApiAuthService();
  
  Map<String, String> get headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      };
  Future<List<GroupConversation>> getMyGroups() async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/group/my-groups'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => GroupConversation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load groups: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getMyGroups: $e');
      rethrow;
    }
  }

  Future<GroupConversation> createGroup(String name, String avatar, List<int> memberIds) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/group/create'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'avatar': avatar,
          'member_ids': memberIds,
        }),
      );

      if (response.statusCode == 201) {
        return GroupConversation.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create group: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in createGroup: $e');
      rethrow;
    }
  }

  Future<void> sendGroupMessage(int groupId, String content, int id) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/group/$groupId/send'),
        headers: headers,
        body: jsonEncode({'content': content}),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in sendGroupMessage: $e');
      rethrow;
    }
  }

  Future<List<GroupMessage>> getGroupMessages(int groupId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/group/$groupId/messages'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => GroupMessage.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getGroupMessages: $e');
      rethrow;
    }
  }

  Future<void> addUserToGroup(int groupId, int userId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/group/$groupId/add-user'),
        headers: headers,
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in addUserToGroup: $e');
      rethrow;
    }
  }
  Future<int> getGroupUnreadCount(int groupId) async {
  try {
    final headers = await _authService.getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/group/$groupId/unread-count'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['unread_count'] ?? 0;
    } else {
      throw Exception('Failed to get unread count: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in getGroupUnreadCount: $e');
    rethrow;
  }
}
Future<void> markGroupMessagesAsRead(int groupId) async {
  try {
    final headers = await _authService.getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/group/$groupId/mark-as-read'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark messages as read: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in markGroupMessagesAsRead: $e');
    rethrow;
  }
}

}
