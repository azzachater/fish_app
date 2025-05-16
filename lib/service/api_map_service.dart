import 'dart:convert';
import 'package:fish_app/models/spot.dart';
import 'package:http/http.dart' as http;
import 'api_auth_service.dart';

class MapService {
  final ApiAuthService _authService = ApiAuthService();
  final String baseUrl = 'http://192.168.1.13:8000/api/spots';

  // Headers for requests
  Map<String, String> get headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };

  // Fetch authentication headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final headers = await _authService.getAuthHeaders();
    return headers;
  }

  Future<List<Spot>> getAllSpots() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: await _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Spot.fromJson(json)).toList();
    }
    throw Exception('Failed to load spots');
  }

  Future<bool> addSpot(Spot spot) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(spot.toJson()),
      );

      if (response.statusCode == 201) {
        return true;
      }
      throw Exception(_handleError(response));
    } catch (e) {
      print("Erreur lors de l'ajout du spot: $e");
      rethrow;
    }
  }

  String _handleError(http.Response response) {
    print('Error Response Status: ${response.statusCode}');
    print('Error Response Headers: ${response.headers}');
    print('Error Response Body: ${response.body}');

    try {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Something went wrong';
    } catch (_) {
      return 'Something went wrong';
    }
  }
}