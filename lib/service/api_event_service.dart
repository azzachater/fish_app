import 'dart:convert';
import 'package:fish_app/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'api_auth_service.dart';

class ApiEventService {
  final ApiAuthService _authService = ApiAuthService();
  //final String baseUrl = 'http://192.168.3.18:8000/api';
final String baseUrl = 'http://10.0.2.2:8000/api';
  // Headers
  Map<String, String> get headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };

  Future<Map<String, String>> _getAuthHeaders() async {
    final headers = await _authService.getAuthHeaders();
    print("🔐 Auth Headers: $headers");
    return headers;
  }

  Future<List<Event>> getEvents() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/events'),
      headers: await _getAuthHeaders(),
    );

    print('🔥 API Response: ${response.body}'); // Debug

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Extraction de la liste depuis la clé 'data'
      final eventsList = data['data'] as List; 
      return eventsList.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  } catch (e) {
    print('❌ getEvents error: $e');
    throw Exception('Check your API response format');
  }
}

  Future<Event> createEvent(Event event) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/events'),
        headers: headers,
        body: jsonEncode({
          'title': event.title,
          'location': event.location,
          'description': event.description,
          'date': DateFormat('yyyy-MM-dd').format(event.date),
        }),
      );

      print(
        '📤 Create Event Response: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return Event.fromJson(responseData);
      } else {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      print('❌ createEvent error: $e');
      throw Exception('Failed to create event: ${e.toString()}');
    }
  }

  Future<Event> updateEvent(Event event) async {
    if (event.id == null) throw Exception('ID null');

    final response = await http.put(
      Uri.parse('$baseUrl/events/${event.id}'),
      headers: await _getAuthHeaders(),
      body: jsonEncode({
        'title': event.title,
        'location': event.location,
        'description': event.description,
        'date': DateFormat('yyyy-MM-dd').format(event.date), // Format cohérent
        'participants': event.participants,
      }),
    );

    if (response.statusCode == 200) {
      return Event.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(_handleError(response));
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/events/$id'),
        headers: headers,
      );

      print('🗑️ Delete Event: ${response.statusCode}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      print('❌ deleteEvent error: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> clearToken() async {
    await _authService.clearToken();
  }

  String _handleError(http.Response response) {
    print('🔴 Error Response ${response.statusCode}: ${response.body}');
    try {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Something went wrong';
    } catch (_) {
      return 'Something went wrong';
    }
  }
}
