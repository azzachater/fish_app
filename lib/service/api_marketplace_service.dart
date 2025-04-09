import 'dart:convert';
import 'dart:io';
import 'package:fish_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'api_auth_service.dart';
import 'package:http_parser/http_parser.dart';

class ApiProductService {
  final ApiAuthService _authService = ApiAuthService();
  final String baseUrl = 'http://192.168.1.42:8000:8000/api';

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

  Future<List<Product>> getProduct() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: await _getAuthHeaders(),
      );

      print('API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        // Debug: Print raw data
        print('Raw API Data: $data');

        List<dynamic> productsList = [];

        if (data is List) {
          productsList = data;
        } else if (data is Map) {
          if (data.containsKey('data')) {
            productsList = data['data'] is List ? data['data'] : [data['data']];
          } else {
            // Try to parse as direct product list
            productsList = data.values.toList();
          }
        }

        // Debug: Print parsed list
        print('Parsed Products: $productsList');

        if (productsList.isEmpty) {
          return Product.sampleProducts(); // Fallback to sample products
        }

        return productsList.map((item) => Product.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Please login again');
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ getProducts error: $e');
      return Product.sampleProducts(); // Fallback to sample products
    }
  }

  Future<Product> createProduct(
    Product product, {
    required File imageFile,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      headers.remove('Content-Type'); // Important for multipart

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/products'),
      );

      // Add headers
      request.headers.addAll(headers);

      // Add text fields
      request.fields.addAll({
        'name': product.name,
        'description': product.description,
        'price': product.price.toString(),
        'unit': product.unit,
        'stock': product.stock.toString(),
        'category': product.category,
      });

      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      // Debug print
      print('Sending multipart request with:');
      print('Fields: ${request.fields}');
      print(
        'Files: ${request.files.map((f) => '${f.field}: ${f.filename}').join(', ')}',
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Create Product Response: ${response.statusCode} - $responseBody');

      if (response.statusCode == 201) {
        return Product.fromJson(jsonDecode(responseBody));
      } else {
        throw Exception(
          _handleError(http.Response(responseBody, response.statusCode)),
        );
      }
    } catch (e) {
      print('❌ Error creating product: $e');
      rethrow;
    }
  }

  Future<Product> updateProduct(Product product) async {
    if (product.id == null) {
      throw Exception('L\'ID du produit ne peut pas être nul.');
    }

    try {
      final headers = await _getAuthHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/products/${product.id}'),
        headers: headers,
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        print('Produit mis à jour avec succès: $decodedBody');
        return Product.fromJson(decodedBody);
      } else {
        final errorMessage = _handleError(response);
        print('Erreur lors de la mise à jour du produit: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Erreur inattendue lors de la mise à jour du produit: $e');
      throw Exception(
        'Erreur lors de la mise à jour du produit: ${e.toString()}',
      );
    }
  }

  Future<void> deleteProduct(String id) async {
    if (id.isEmpty) {
      throw Exception("ID du produit invalide");
    }

    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$id'),
        headers: headers,
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      print('Delete product error: $e');
      throw Exception(e.toString());
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
