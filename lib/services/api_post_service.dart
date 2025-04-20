import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../service/api_auth_service.dart';

class ApiPostService {
  final ApiAuthService _authService = ApiAuthService();
  final String baseUrl = 'http://10.0.2.2:8000/api';

  // Headers for requests
  Map<String, String> get headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      };

  // Fetch authentication headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final headers = await _authService.getAuthHeaders();
    print("🔵 Auth Headers: $headers");
    return headers;
  }

  Future<List<Post>> getPosts() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(Uri.parse('$baseUrl/posts'), headers: headers);

      print("🚀 API Response Status: ${response.statusCode}");
      print("📩 API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.isEmpty) return [];
        
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((postJson) {
          try {
            return Post.fromJson(postJson as Map<String, dynamic>);
          } catch (e) {
            print("⚠️ Error parsing post: $e");
            print("🛑 Problematic post data: $postJson");
            throw Exception("Invalid post format");
          }
        }).toList();
      } else {
        throw Exception("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print('❌ Error in getPosts: $e');
      rethrow;
    }
  }

  Future<Post> createPost(String postText, String postImage) async {
  try {
    final headers = await _getAuthHeaders();
    final body = jsonEncode({
      'post_text': postText,
      'post_image': postImage,
    });

    final response = await http.post(Uri.parse('$baseUrl/posts'), headers: headers, body: body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      
      // Vérification que la réponse contient un ID
      if (!responseData.containsKey('id')) {
        throw Exception("Réponse invalide : l'ID du post est manquant.");
      }

      return Post.fromJson(responseData);
    } else {
      throw Exception(_handleError(response));
    }
  } catch (e) {
    print('❌ Error creating post: $e');
    throw Exception(e.toString());
  }
}


  Future<Post> updatePost(Post post) async {
  try {
    final headers = await _getAuthHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/posts/${post.id}'),
      headers: headers,
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 200) {
      final decodedBody = jsonDecode(response.body);
      print('Post mis à jour avec succès: $decodedBody');
      return Post.fromJson(decodedBody);
    } else {
      final errorMessage = _handleError(response);
      print('Erreur lors de la mise à jour du post: $errorMessage');
      throw Exception(errorMessage);
    }
  } catch (e) {
    print('Erreur inattendue lors de la mise à jour du post: $e');
    throw Exception('Erreur lors de la mise à jour du post: ${e.toString()}');
  }
}


  Future<void> deletePost(String id) async {
    if (id.isEmpty) {
      throw Exception("Invalid post ID");
    }

    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(Uri.parse('$baseUrl/posts/$id'), headers: headers);

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      print('Delete post error: $e');
      throw Exception(e.toString());
    }
  }
  Future<Post> likePost(String postId) async {
  try {
    final headers = await _getAuthHeaders();

    final response = await http.post(
      Uri.parse('$baseUrl/posts/$postId/like'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Post.fromJson(json);
    } else {
      throw Exception(_handleError(response));
    }
  } catch (e) {
    print('❌ Error liking post: $e');
    rethrow;
  }
}

  Future<void> clearToken() async {
    await _authService.clearToken();
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
