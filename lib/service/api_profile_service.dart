/*import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'api_auth_service.dart';

class ApiProfileService {
  final ApiAuthService _authService = ApiAuthService();
  final String baseUrl = 'http://192.168.1.85:8000/api';

  Future<Map<String, String>> _getAuthHeaders() async {
    final headers = await _authService.getAuthHeaders();
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      ...headers,
    };
  }

  Future<User> showProfile(int userId) async {
  try {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/user/$userId/profile'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Profile data received: $data');  // Log des données du profil
      return User.fromJson(data['profile']);
    } else {
      throw _handleResponseError(response);
    }
  } catch (e) {
    rethrow;
  }
}


  Future<User> updateProfile(String name, String email, String? bio, String? imagePath) async {
  try {
    final headers = await _authService.getAuthHeaders();
    final uri = Uri.parse('$baseUrl/profile');

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    request.fields['name'] = name;
    request.fields['email'] = email;
    if (bio != null) request.fields['bio'] = bio;

    if (imagePath != null && imagePath.isNotEmpty && File(imagePath).existsSync()) {
      request.files.add(await http.MultipartFile.fromPath('avatar', imagePath));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      return User.fromJson(data['user']); // Retourner l'utilisateur mis à jour
    } else {
      throw _handleResponseError(http.Response(responseBody, response.statusCode));
    }
  } catch (e) {
    rethrow;
  }
}



  Exception _handleResponseError(http.Response response) {
    try {
      final errorData = jsonDecode(response.body);
      final message = errorData['message'] ?? 'Erreur inconnue';
      return Exception('$message (Code: ${response.statusCode})');
    } catch (_) {
      return Exception(
          'Erreur serveur (Code: ${response.statusCode})');
    }
  }
}*/
