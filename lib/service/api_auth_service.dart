import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fish_app/models/user_model.dart';
//import 'package:fish_app/services/api_push_notif_service.dart';

class ApiAuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  FlutterSecureStorage get storage => _storage;

  final String baseUrl = 'http://192.168.1.13:8000/api';

  Map<String, String> get _headers => {
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
    'Content-Type': 'application/json',
  };

  Future<Map<String, String>> getAuthHeaders() async {
    final headers = Map<String, String>.from(_headers);
    final token = await _storage.read(key: 'token');
    if (token != null) {
      final bearerToken = token.startsWith('Bearer ') ? token : 'Bearer $token';
      headers['Authorization'] = bearerToken;
      print("Token $bearerToken");
    } else {
      print("Token null");
    }
    return headers;
  }

  Future<String?> getCsrfToken() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sanctum/csrf-cookie'),
        headers: {'Accept': 'application/json'},
      );
      print('CSRF Response Status: ${response.statusCode}');
      print('CSRF Response Headers: ${response.headers}');

      final cookies = response.headers['set-cookie'];
      if (cookies != null) {
        final xsrfToken = cookies
            .split(';')
            .firstWhere(
              (cookie) => cookie.trim().startsWith('XSRF-TOKEN='),
              orElse: () => '',
            );
        if (xsrfToken.isNotEmpty) {
          return Uri.decodeComponent(xsrfToken.split('=')[1]);
        }
      }
    } catch (e) {
      print('Error fetching CSRF token: $e');
    }
    return null;
  }

  Future<bool> hasValidToken() async {
    final token = await _storage.read(key: 'token');
    return token != null;
  }

  dynamic _handleError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        throw Exception('Bad Request');
      case 401:
        throw Exception('Unauthorized');
      case 403:
        throw Exception('Forbidden');
      case 404:
        throw Exception('Not Found');
      case 500:
        throw Exception('Server Error');
      default:
        throw Exception('Error: ${response.statusCode}');
    }
  }

  dynamic _handleErrorDynamic(dynamic error) {
    throw error;
  }

  Future<String?> getUserId() async {
    final token = await getToken();
    if (token != null) {
      final decodedToken = _decodeToken(token);
      return decodedToken['user_id'];
    }
    return null;
  }

  Map<String, dynamic> _decodeToken(String token) {
    final parts = token.split('.');
    final payload = parts[1];
    final decodedPayload = base64Url.decode(base64Url.normalize(payload));
    return jsonDecode(utf8.decode(decodedPayload));
  }

  Future<User> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      final headers = await getAuthHeaders();
      final csrfToken = await getCsrfToken();
      if (csrfToken != null) {
        headers['X-XSRF-TOKEN'] = csrfToken;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return User(
          id: data['user_id'],
          name: name,
          email: email,
          avatar: '',
          bio: '',
          emailVerified: false,
        );
      } else {
        throw Exception(data['message'] ?? 'Erreur lors de l\'inscription');
      }
    } catch (e) {
      print('Error registering user: $e');
      throw Exception('Erreur réseau: ${e.toString()}');
    }
  }

  Future<String> getToken() async {
    return await _storage.read(key: 'token') ?? '';
  }

  Future<User> login(String email, String password) async {
    try {
      final headers = await getAuthHeaders();
      // Récupérer et utiliser systématiquement le CSRF token
      final csrfToken = await getCsrfToken();
      headers['X-XSRF-TOKEN'] = csrfToken ?? '';

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: headers,
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data.containsKey('User') && data.containsKey('Token')) {
          final user = User.fromJson(data['User']);

          // Vérification de l'email AVANT de stocker le token
          if (!user.emailVerified) {
            await clearToken();
            throw Exception('EmailNotVerified');
          }

          await _storage.write(key: 'token', value: data['Token']);
          return user;
        }
        throw Exception('Invalid response format');
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      throw _handleErrorDynamic(e);
    }
  }

  Future<void> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: await getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        await _storage.delete(key: 'token');
        print('Logged out successfully.');
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      print('Error during logout: $e');
      throw _handleErrorDynamic(e);
    }
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'token');
  }

  String handleError(dynamic error) {
    if (error is http.Response) {
      print('Error Response Status: ${error.statusCode}');
      print('Error Response Headers: ${error.headers}');
      print('Error Response Body: ${error.body}');
      try {
        final data = jsonDecode(error.body);
        return data['message'] ?? 'Something went wrong';
      } catch (_) {
        return 'Something went wrong';
      }
    }
    return error.toString();
  }

  Future<Map<String, dynamic>> verifyCode(int userId, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-code'),
      headers: await getAuthHeaders(),
      body: jsonEncode({'user_id': userId, 'code': code}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Stocker le token si présent dans la réponse
      if (data.containsKey('token')) {
        await _storage.write(key: 'token', value: data['token']);
      }
      return data;
    } else {
      throw handleError(response);
    }
  }

  Future<void> resendCode(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/resend-code'),
      headers: await getAuthHeaders(),
      body: jsonEncode({'user_id': userId}),
    );
    if (response.statusCode != 200) {
      throw handleError(response);
    }
  }

  
Future<void> sendResetCode(String email) async {
  final response = await http.post(
    Uri.parse('$baseUrl/send-reset-code'),
    headers: _headers,
    body: jsonEncode({'email': email}),
  );

  if (response.statusCode != 200) {
    throw Exception(jsonDecode(response.body)['error'] ?? 'Erreur d’envoi');
  }
}

Future<void> verifyResetCode(String email, String code) async {
  final response = await http.post(
    Uri.parse('$baseUrl/verify-reset-code'),
    headers: _headers,
    body: jsonEncode({'email': email, 'code': code}),
  );

  if (response.statusCode != 200) {
    throw Exception(jsonDecode(response.body)['error'] ?? 'Code invalide');
  }
}

Future<void> updatePassword(String email, String password, String confirmation) async {
  final response = await http.post(
    Uri.parse('$baseUrl/update-password'),
    headers: _headers,
    body: jsonEncode({
      'email': email,
      'password': password,
      'password_confirmation': confirmation,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception(jsonDecode(response.body)['error'] ?? 'Erreur de mise à jour');
  }
}
}