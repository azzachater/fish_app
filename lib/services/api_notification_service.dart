import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/notification_model.dart';
import '../service/api_auth_service.dart';

class NotificationApiService {
  static const String baseUrl = 'http://192.168.1.52:8000/api';
  static final ApiAuthService _authService = ApiAuthService();

  static Future<Map<String, dynamic>> fetchNotifications() async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/notifications'),
        headers: headers,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        final bool unread = jsonData['unread'];
        final List<dynamic> notifList = jsonData['notifications'];

        final List<NotificationModel> notifications =
            notifList.map((json) => NotificationModel.fromJson(json)).toList();

        return {'unread': unread, 'notifications': notifications};
      } else {
        throw Exception('Erreur ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Erreur dans fetchNotifications: $e');
      throw Exception('Erreur réseau: $e');
    }
  }

  static Future<void> deleteNotification(int id) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/notifications/$id'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Erreur lors de la suppression : ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Erreur dans deleteNotification: $e');
      throw Exception('Erreur réseau: $e');
    }
  }
}
