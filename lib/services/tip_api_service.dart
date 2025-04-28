import 'dart:convert';
import 'package:fish_app/service/api_auth_service.dart';
import 'package:http/http.dart' as http;
import '../models/tip_model.dart';

class ApiTipService {
  final ApiAuthService _authService = ApiAuthService();
  final String baseUrl = 'http://192.168.1.52:8000/api';

  Map<String, String> get headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };

  Future<Map<String, String>> _getAuthHeaders() async {
    final headers = await _authService.getAuthHeaders();
    print("🔵 Auth Headers: $headers");
    return headers;
  }

  Future<String?> getCsrfToken() async {
    return await _authService.getCsrfToken();
  }

  Future<List<Tip>> getTips() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/tips'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);

        if (jsonResponse is List) {
          return jsonResponse.map((tip) => Tip.fromJson(tip)).toList();
        } else if (jsonResponse is Map<String, dynamic>) {
          final List<dynamic> data = jsonResponse['tips'] ?? [];
          return data.map((tip) => Tip.fromJson(tip)).toList();
        } else {
          throw Exception("Unexpected API response format");
        }
      } else {
        print("Error getting tips: ${response.body}");
        throw _handleError(response);
      }
    } catch (e) {
      print('Error getting tips: $e');
      throw _handleError(e);
    }
  }

  Future<Tip> createTip(String title, String description) async {
    try {
      final headers = await _getAuthHeaders();
      final body = jsonEncode({'title': title, 'description': description});

      print("🔵 Sending request to $baseUrl/tips");
      print("🟡 Headers: $headers");
      print("🟢 Body: $body");

      final response = await http.post(
        Uri.parse('$baseUrl/tips'),
        headers: headers,
        body: body,
      );

      print("🔴 Response Code: ${response.statusCode}");
      print("🟠 Response Body: ${response.body}");

      if (response.statusCode == 201) {
        return Tip.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      print('🔴 Create tip error: $e');
      throw _handleError(e);
    }
  }

  Future<Tip> updateTip(Tip tip) async {
    try {
      final headers = await _getAuthHeaders();
      print("Updating tip: ${tip.toJson()}");
      final response = await http.put(
        Uri.parse('$baseUrl/tips/${tip.id}'),
        headers: headers,
        body: jsonEncode(tip.toJson()),
      );

      if (response.statusCode == 200) {
        return Tip.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      print('Update tip error: $e');
      throw _handleError(e);
    }
  }

  Future<void> deleteTip(String id) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/tips/$id'),
        headers: headers,
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      print('Delete tip error: $e');
      throw _handleError(e);
    }
  }

  Future<void> clearToken() async {
    await _authService.clearToken();
  }

  String _handleError(dynamic error) {
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
}
