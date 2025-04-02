import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fish_app/models/user_model.dart';

class ApiAuthService {
  //cree une instance securisé pour stocker les tokens
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  //definir un getter pour acceder au stockage securisé
  FlutterSecureStorage get storage => _storage;

  final String baseUrl = 'http://10.0.2.2:8000/api';
  //definir un entete par defaut pour tout les requetes
  Map<String, String> get _headers => {
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
    'Content-Type': 'application/json',
  };
  //Cette fonction permet de récupérer les en-têtes d'authentification en lisant le token depuis le stockage sécurisé et en l'ajoutant aux en-têtes.
  Future<Map<String, String>> _getAuthHeaders() async {
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

  //recuperation de token CSRF
  Future<String?> _getCsrfToken() async {
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

  //verification de la validite de token
  Future<bool> hasValidToken() async {
    final token = await _storage.read(key: 'token');
    return token != null;
  }

  //gestion des erreurs
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

  //erreur dynamique
  dynamic _handleErrorDynamic(dynamic error) {
    throw error;
  }

  //envoie les informations d'inscription via une requete POST
  Future<User> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      final headers = await _getAuthHeaders();
      final csrfToken = await _getCsrfToken();
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

      print("API Response Status: ${response.statusCode}");
      print(
        "API Response Body: ${response.body}",
      ); // Log the full response body
      //si l'inscruption reussit , le token est enregistré et l'utilisateur est retourné
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Decoded Data: $data"); // Log the decoded response
        if (data != null && data.containsKey('User')) {
          final user = User.fromJson(data['User']);
          user.token = data['token'];
          await _storage.write(key: 'token', value: user.token);
          return user;
        } else {
          throw Exception('Invalid response: User data not found.');
        }
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      print('Error registering user: $e');
      throw _handleErrorDynamic(e);
    }
  }

  //login , envoie les infos de cnx via une requete post
  Future<User> login(String email, String password) async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: headers,
        body: jsonEncode({'email': email, 'password': password}),
      );

      print("Login Response Status: ${response.statusCode}");
      print("Login Response Body: ${response.body}");
      //si la cnx est reussite , le token est enregistré pour les requetes futures
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Accepter 201
        final data = jsonDecode(response.body);
        print("Login Response Data: $data");

        if (data != null &&
            data.containsKey('User') &&
            data.containsKey('Token')) {
          // Vérifie bien les clés
          final user = User.fromJson(data['User']);
          final token = data['Token'].toString();

          user.token = token;
          await _storage.write(key: 'token', value: token);
          print("Saved Token: $token");

          return user;
        } else {
          throw Exception('Invalid response: User or Token data not found.');
        }
      } else {
        print("Login API Error: ${response.body}");
        throw _handleError(response);
      }
    } catch (e) {
      print('Error logging in user: $e');
      throw _handleErrorDynamic(e);
    }
  }
}
