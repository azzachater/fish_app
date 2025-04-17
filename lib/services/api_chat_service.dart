import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fish_app/service/api_auth_service.dart';

class ApiChatService {
  final ApiAuthService _authService = ApiAuthService();
  final String baseUrl = 'http://192.168.1.23:8000/api';

  Future<List<dynamic>> getMyConversations() async {
    try {
      final headers = await _authService.getAuthHeaders();

      final response = await http.get(
        Uri.parse('$baseUrl/conversations'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load conversations. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('getMyConversations error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMessages(int conversationId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/conversations/$conversationId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load messages. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('getMessages error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendMessage(int receiverId, String content) async {
    try {
      final headers = await _authService.getAuthHeaders();
      headers['Content-Type'] = 'application/json';

      final response = await http.post(
        Uri.parse('$baseUrl/message/send/$receiverId'),
        headers: headers,
        body: jsonEncode({'content': content}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        if (responseBody is! Map<String, dynamic>) {
          throw Exception('Invalid response format');
        }
        return responseBody;
      } else {
        throw Exception('Failed to send message. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('sendMessage error: $e');
      rethrow;
    }
  }

  Future<void> markMessagesAsRead(int conversationId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/conversations/$conversationId/mark-as-read'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to mark messages as read. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('markMessagesAsRead error: $e');
      rethrow;
    }
  }

  Future<int> getUnreadCount(int conversationId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/conversations/$conversationId/unread-count'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['unread_count'] as int;
      } else {
        throw Exception('Failed to get unread count. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('getUnreadCount error: $e');
      rethrow;
    }
  }
}