import 'dart:convert';
import 'dart:io';
import 'package:fish_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'api_auth_service.dart';
import 'package:http_parser/http_parser.dart';

class ApiProductService {
  final ApiAuthService _authService = ApiAuthService();
  final String baseUrl = 'http://192.168.1.52:8000/api';

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
      headers.remove('Content-Type');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/products'),
      );
      request.headers.addAll(headers);

      // Validation des champs obligatoires
      if (product.name.isEmpty) throw Exception('Le nom est obligatoire');
      if (imageFile.path.isEmpty) throw Exception('L\'image est obligatoire');

      request.fields.addAll({
        'name': product.name,
        'description': product.description,
        'price': product.price.toString(),
        'unit': product.unit,
        'stock': product.stock.toString(),
        'category': product.category,
      });

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final responseData = jsonDecode(responseBody);
        if (responseData['data'] == null) {
          throw Exception('Données du produit manquantes dans la réponse');
        }
        return Product.fromJson(responseData['data']);
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

  // Dans ApiProductService
  Future<Product> updateProduct(Product product, {File? imageFile}) async {
    try {
      final headers = await _getAuthHeaders();
      headers.remove('Content-Type');

      var request = http.MultipartRequest(
        'POST', // Ou 'PUT' selon votre API
        Uri.parse('$baseUrl/products/${product.id}'),
      );
      request.headers.addAll(headers);

      request.fields.addAll({
        'name': product.name,
        'description': product.description,
        'price': product.price.toString(),
        'unit': product.unit,
        'stock': product.stock.toString(),
        'category': product.category,
        '_method': 'PUT', // Si votre API nécessite cette méthode
      });

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final responseData = jsonDecode(responseBody);
        return Product.fromJson(responseData['data']);
      } else {
        throw Exception(
          _handleError(http.Response(responseBody, response.statusCode)),
        );
      }
    } catch (e) {
      print('❌ Error updating product: $e');
      rethrow;
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
