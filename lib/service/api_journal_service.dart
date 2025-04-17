import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_auth_service.dart';
import 'package:intl/intl.dart';

class ApiJournalService {
  final ApiAuthService _authService = ApiAuthService();
  final String baseUrl = 'http://192.168.1.23:8000/api'; // Adaptez l'URL

  // Headers de base
  Map<String, String> get headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };

  // Récupère les en-têtes d'authentification
  Future<Map<String, String>> _getAuthHeaders() async {
    final headers = await _authService.getAuthHeaders();
    print("🔵 Auth Headers: $headers");
    return headers;
  }

  // Récupère toutes les entrées du journal
  Future<List<Map<String, dynamic>>> getJournalEntries() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/fishing-logs'),
        headers: await _getAuthHeaders(),
      );

      print('API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        List<dynamic> entriesList = [];

        // Gestion des différents formats de réponse
        if (data is List) {
          entriesList = data;
        } else if (data is Map && data.containsKey('data')) {
          entriesList = data['data'] is List ? data['data'] : [data['data']];
        }

        if (entriesList.isEmpty) {
          return _getSampleEntries(); // Entrées fictives si vide
        }

        return entriesList
            .map((entry) => entry as Map<String, dynamic>)
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Non autorisé - Reconnectez-vous');
      } else {
        throw Exception(
          'Échec du chargement des entrées: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ getJournalEntries error: $e');
      return _getSampleEntries(); // Fallback
    }
  }

  // Crée une nouvelle entrée
  Future<Map<String, dynamic>> createJournalEntry(
    Map<String, dynamic> entry,
  ) async {
    try {
      final authHeaders = await _getAuthHeaders();
      final fullHeaders = {...headers, ...authHeaders};

      print('🔵 Sending to API: ${jsonEncode(entry)}');
      print('🔵 Headers: $fullHeaders');

      final response = await http.post(
        Uri.parse('$baseUrl/fishing-logs'),
        headers: fullHeaders,
        body: jsonEncode({'data': entry}), // Notez l'ajout de 'data'
      );

      print('Create Entry Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData['data'] ??
            responseData; // Gestion des différentes structures de réponse
      } else {
        throw Exception(
          _handleError(http.Response(response.body, response.statusCode)),
        );
      }
    } catch (e) {
      print('❌ Error creating journal entry: $e');
      rethrow;
    }
  }

  // Met à jour une entrée existante
  Future<Map<String, dynamic>> updateJournalEntry(
    String id,
    Map<String, dynamic> newData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/fishing-logs/$id'),
        headers: await _getAuthHeaders(),
        body: jsonEncode(newData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      print('❌ Error updating entry: $e');
      rethrow;
    }
  }

  // Supprime une entrée
  Future<void> deleteJournalEntry(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/fishing-logs/$id'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode != 204) {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      print('❌ Error deleting entry: $e');
      rethrow;
    }
  }

  // Entrées fictives (fallback)
  List<Map<String, dynamic>> _getSampleEntries() {
    final now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return [
      {
        'id': '1',
        'title': 'Pêche au brochet',
        'location': 'Lac de Montagne',
        'species_caught': 'Brochet',
        'fishing_conditions': 'Vent modéré, eau claire',
        'notes': 'Utilisé un leurre rouge',
        'date': now,
        'time': '08:30',
      },
      {
        'id': '2',
        'title': 'Pêche en mer',
        'location': 'Côte Atlantique',
        'species_caught': 'Bar',
        'fishing_conditions': 'Marée haute, vagues fortes',
        'notes': 'Appât: calamar',
        'date': now,
        'time': '14:15',
      },
    ];
  }

  // Gestion des erreurs
  String _handleError(http.Response response) {
    print('Error Status: ${response.statusCode}');
    print('Error Body: ${response.body}');

    try {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Erreur inconnue';
    } catch (_) {
      return 'Erreur de serveur (${response.statusCode})';
    }
  }
}
