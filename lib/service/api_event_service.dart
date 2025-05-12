import 'dart:convert';
import 'package:fish_app/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'api_auth_service.dart';

class ApiEventService {
  final ApiAuthService _authService = ApiAuthService();
  final String baseUrl = 'http://192.168.1.76:8000/api';

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

    print('API Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      if (data == null || data['data'] == null) {
        return [];
      }

      final eventsList = (data['data'] as List).map((json) {
        // Nettoyez les participants null
        if (json['participants'] is List) {
          json['participants'] = (json['participants'] as List)
              .where((p) => p != null) // Filtre les participants null
              .map((p) => {
                'user_id': p is int ? p : p['user_id'],
                'user': p is Map ? p['user'] : {'id': p, 'name': 'Participant'}
              })
              .toList();
        }
        
        return Event.fromJson(json);
      }).toList();

      return eventsList;
    } else {
      throw Exception('Failed to load events: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ getEvents error: $e');
    throw Exception('Failed to fetch events: ${e.toString()}');
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
          'user_id': event.userId,
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
        'user_id': event.userId,
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

  Future<Event> addParticipant(String eventId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/events/$eventId/participants',
        ), // Vérifiez cette URL
        headers: await _getAuthHeaders(),
        body: jsonEncode({
          'user_id': userId, // Le backend attend seulement user_id
        }),
      );

      print(
        '🎫 Add Participant Response: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // Vérifiez la structure de réponse de votre backend
        if (responseData['event'] != null) {
          return Event.fromJson(responseData['event']);
        } else {
          // Si la réponse ne contient pas l'événement complet, rafraîchissez la liste
          final events = await getEvents();
          return events.firstWhere((e) => e.id == eventId);
        }
      } else {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      print('❌ addParticipant error: $e');
      rethrow;
    }
  }

  Future<Event> joinEvent(String eventId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/events/$eventId/join'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return Event.fromJson(responseData['event']);
      } else {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      print('❌ joinEvent error: $e');
      rethrow;
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
