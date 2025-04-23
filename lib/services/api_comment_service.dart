import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comment_model.dart';
import '../service/api_auth_service.dart'; // Pour récupérer le token d'auth

class ApiCommentService {
  final ApiAuthService _authService = ApiAuthService();
  static const String baseUrl = "http://192.168.3.18:8000/api"; // Remplace par ton URL backend

  // Headers pour les requêtes sans authentification
  Map<String, String> get headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      };

  // Obtenir les headers avec authentification
  Future<Map<String, String>> _getAuthHeaders() async {
    final headers = await _authService.getAuthHeaders();
    print("🔵 Auth Headers: $headers");
    return headers;
  }

  // Récupérer les commentaires d'un post
  Future<List<Comment>> fetchComments(String postId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(Uri.parse('$baseUrl/posts/$postId/comments'), headers: headers);

      print("🚀 API Response Status: ${response.statusCode}");
      print("📩 API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.isEmpty) return [];
        
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((commentJson) {
          try {
            return Comment.fromJson(commentJson as Map<String, dynamic>);
          } catch (e) {
            print("⚠️ Error parsing comment: $e");
            print("🛑 Problematic comment data: $commentJson");
            throw Exception("Invalid comment format");
          }
        }).toList();
      } else {
        throw Exception("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print('❌ Error in fetchComments: $e');
      rethrow;
    }
  }

  // Ajouter un commentaire
  Future<Comment?> addComment(String postId, String content) async {
  try {
    final authHeaders = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/posts/$postId/comments'),
      headers: authHeaders,
      body: json.encode({'content': content}),
    );

    print("🔴 Response Status: ${response.statusCode}");
    print("🔴 Response Body: ${response.body}");

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);

print("📌 Response Data: $responseData");
print("📌 Comment Key Exists: ${responseData.containsKey('comment')}");
print("📌 Comment Value: ${responseData['comment']}");

if (responseData.containsKey('comment') && responseData['comment'] != null) {
  return Comment.fromJson(responseData['comment'] as Map<String, dynamic>);
} else {
  throw Exception("Réponse invalide : ${response.body}");
}


    } else {
      throw Exception("Échec de l'ajout du commentaire: ${response.body}");
    }
  } catch (e) {
    print("❌ Erreur ajout commentaire : $e");
    throw Exception('Erreur lors de l\'ajout du commentaire: $e');
  }
}

  // Supprimer un commentaire
  Future<bool> deleteComment(String postId, String commentId) async {
    try {
      final authHeaders = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/posts/$postId/comments/$commentId'),
        headers: authHeaders,
      );

      return response.statusCode == 204;
    } catch (e) {
      throw Exception('Erreur lors de la suppression du commentaire: $e');
    }
  }

  // Nettoyer le token d'auth
  Future<void> clearToken() async {
    await _authService.clearToken();
  }

  // Gestion des erreurs
}