import 'dart:convert';
import 'package:fish_app/service/api_auth_service.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiUserService {
  final String baseUrl = 'http://192.168.1.85:8000/api';
  final ApiAuthService _authService;

  ApiUserService({ApiAuthService? authService})
    : _authService = authService ?? ApiAuthService();

  Future<User> getCurrentUser() async {
    try {
      final headers = await _authService.getAuthHeaders();
      print('🔵 Fetching user with headers: $headers');

      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: headers,
      );

      print('🟢 User API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('🟠 Raw profile data: ${data['profile']}'); // Nouveau log

        final user = User.fromJson(data);
        final currentToken = await _authService.getToken();
        user.token = currentToken;

        print('🟣 Parsed user: ${user.toJson()}');
        return user;
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('🔴 Error in getCurrentUser: $e');
      rethrow;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Échec de la récupération: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAllUsers: $e');
      rethrow;
    }
  }

  Future<User> checkUser(String id) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/user/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Utilisateur non trouvé');
      } else {
        throw Exception('Échec de la vérification: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in checkUser: $e');
      rethrow;
    }
  }
}
