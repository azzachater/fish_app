import 'package:fish_app/service/api_marketplace_service.dart';
import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';
import 'package:fish_app/controller/cart_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var isLoading = false.obs;
  var error = RxString('');
  final RxList<String> favoriteIds = <String>[].obs;

  final String baseUrl =
      'http://10.0.2.2:8000/api/products'; // Remplacez par votre URL

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Dans product_controller.dart
  // Correction de la méthode fetchProducts()
  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      error('');
      final response = await http.get(
        Uri.parse('$baseUrl'), // Utilisez directement votre endpoint API
        headers: await ApiService.getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          products.assignAll(
            (data['data'] as List)
                .map((json) => Product.fromJson(json))
                .toList(),
          );
          filteredProducts.assignAll(products);
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      error(e.toString());
      Get.snackbar(
        'Erreur',
        'Impossible de charger les produits: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Fallback aux produits de démo
      products.assignAll(Product.sampleProducts());
      filteredProducts.assignAll(products);
    } finally {
      isLoading(false);
    }
  }
  // Méthode temporaire sans auth
  /*Future<void> fetchProductsPublic() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('$baseUrl/products/public'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        products.assignAll((data['data'] as List)
            .map((json) => Product.fromJson(json))
            .toList());
      } else {
        throw Exception('Erreur ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
      // Fallback avec données de démo
    } finally {
      isLoading(false);
    }
  }*/

  Future<void> addProduct(Product product) async {
    try {
      isLoading(true);
      error('');
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );

      if (response.statusCode == 201) {
        final newProduct = Product.fromJson(json.decode(response.body));
        products.add(newProduct);
        filteredProducts.refresh();
        Get.back();
        Get.snackbar(
          'Succès',
          'Produit ajouté avec succès',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      } else {
        throw Exception('Failed to add product: ${response.statusCode}');
      }
    } catch (e) {
      error(e.toString());
      Get.snackbar(
        'Erreur',
        'Échec de l\'ajout du produit: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading(false);
    }
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products.where(
          (product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  // Ajoutez cette méthode
  /*Future<void> toggleFavorite(String productId) async {
    try {
      // Mise à jour optimiste de l'UI
      if (favoriteIds.contains(productId)) {
        favoriteIds.remove(productId);
      } else {
        favoriteIds.add(productId);
      }

      // Appel API
      final response = await http.post(
        Uri.parse('$baseUrl/products/$productId/toggle-favorite'),
        headers: await ApiService.getHeaders(),
      );

      if (response.statusCode != 200) {
        // Annuler en cas d'erreur
        if (favoriteIds.contains(productId)) {
          favoriteIds.remove(productId);
        } else {
          favoriteIds.add(productId);
        }
        throw Exception('Failed to update favorite');
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de mettre à jour les favoris',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }*/
  Future<void> toggleFavorite(String productId) async {
    // Solution temporaire sans appel API
    if (favoriteIds.contains(productId)) {
      favoriteIds.remove(productId);
    } else {
      favoriteIds.add(productId);
    }
  }

  // Modifiez le getter favoriteCount
  int get favoriteCount => favoriteIds.length;

  // Ajoutez cette méthode pour vérifier si un produit est favori
  bool isFavorite(String productId) => favoriteIds.contains(productId);

  int get cartCount {
    final cartController = Get.find<CartController>();
    return cartController.cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  List<Product> getProductsByCategory(String category) {
    return products.where((p) => p.category == category).toList();
  }
}
