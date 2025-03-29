import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import 'api_auth_service.dart'; // Pour récupérer le token d'authentification

class ApiPostService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/posts';

  // Méthode pour récupérer les posts
  static Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: await _getHeaders(),
      );
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception('Erreur lors du chargement des posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  // Méthode pour créer un post (avec ou sans image)
  static Future<Post> createPost(String postText, String? postImage) async {
    try {
      var request = http.MultipartRequest(
        'POST', Uri.parse(baseUrl),
      );
      request.headers.addAll(await _getHeaders());

      if (postImage != null) {
        request.files.add(await http.MultipartFile.fromPath('post_image', postImage));
      }

      request.fields['post_text'] = postText;

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);
      
      if (response.statusCode == 201) {
        return Post.fromJson(json.decode(responseBody.body));
      } else {
        throw Exception('Erreur lors de la création du post');
      }
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  // Méthode pour supprimer un post
  static Future<void> deletePost(String postId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$postId'),
        headers: await _getHeaders(),
      );
      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la suppression du post');
      }
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  // Méthode pour mettre à jour un post
  static Future<Post> updatePost(String postId, String postText, String? postImage) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$postId'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'post_text': postText,
          'post_image': postImage,
        }),
      );
      if (response.statusCode == 200) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Erreur lors de la mise à jour du post');
      }
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  // Méthode pour liker/unliker un post
  static Future<void> toggleLike(String postId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$postId/like'),
        headers: await _getHeaders(),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data['message']); // Affiche le message de retour du backend
      } else {
        throw Exception('Erreur lors du like/unlike du post');
      }
    } catch (e) {
      throw Exception('Erreur réseau: $e');
    }
  }

  // Méthode pour récupérer les en-têtes avec le token d'authentification
  static Future<Map<String, String>> _getHeaders() async {
    try {
      String token = await ApiAuthService().getToken();
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    } catch (e) {
      throw Exception('Erreur lors de la récupération du token');
    }
  }
}
