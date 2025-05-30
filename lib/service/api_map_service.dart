import 'dart:convert';
import 'package:fish_app/models/spot.dart';
import 'package:fish_app/services/api_user_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'api_auth_service.dart';

class MapService {
  final ApiAuthService _authService = ApiAuthService();
  final ApiUserService apiUserService = ApiUserService();
  final String baseUrl = 'http://192.168.1.85:8000/api/spots';

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

  Future<bool> voteOnSpot({
    required int spotId,
    required bool isUpvote,
    required int userId,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/$spotId/vote'),
        headers: headers,
        body: jsonEncode({'is_upvote': isUpvote}),
      );

      if (response.statusCode == 409) {
        Get.snackbar('Info', 'Vous avez déjà voté pour ce spot');
        return false;
      } else if (response.statusCode == 410) {
        Get.snackbar('Info', 'Ce spot a été supprimé');
        return false;
      }

      return response.statusCode == 200;
    } catch (e) {
      Get.snackbar('Erreur', 'Échec lors du vote: ${e.toString()}');
      return false;
    }
  }
}
