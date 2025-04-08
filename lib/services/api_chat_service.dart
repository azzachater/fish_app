import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fish_app/services/api_auth_service.dart';

class ApiChatService {
  final ApiAuthService _authService = ApiAuthService();
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<dynamic>> getMyConversations() async {
    try {
      final headers = await _authService.getAuthHeaders();

      final response = await http.get(
        Uri.parse('$baseUrl/conversations'), // Assurez-vous que cette route existe dans Laravel
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load conversations');
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

    print("Réponse de l'API : ${response.body}"); // Log de la réponse brute

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load messages');
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

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      print('sendMessage error: $e');
      rethrow;
    }
  }
}