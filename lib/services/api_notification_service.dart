import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/notification_model.dart';
import 'api_auth_service.dart';

class NotificationApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static final ApiAuthService _authService = ApiAuthService();

  static Future<List<NotificationModel>> fetchNotifications() async {
  try {
    final headers = await _authService.getAuthHeaders();
    print('Headers: $headers'); // Debug
    final response = await http.get(
      Uri.parse('$baseUrl/notifications'),
      headers: headers,
    );
    
    print('Response status: ${response.statusCode}'); // Debug
    print('Response body: ${response.body}'); // Debug
    
    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      throw Exception('Erreur ${response.statusCode}: ${response.body}');
    }
  } catch (e) {
    print('Error in fetchNotifications: $e'); // Debug
    throw Exception('Erreur réseau: $e');
  }
}
  static Future<void> markAsRead(int id) async {
    final headers = await _authService.getAuthHeaders();
    await http.put(
      Uri.parse('$baseUrl/notifications/$id/read'),
      headers: headers,
    );
  }
  static Future<void> deleteNotification(int id) async {
  try {
    final headers = await _authService.getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/notifications/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la suppression : ${response.statusCode}');
    }
  } catch (e) {
    print('Erreur dans deleteNotification: $e');
    throw Exception('Erreur réseau: $e');
  }
}

}
