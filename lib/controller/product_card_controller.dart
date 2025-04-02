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

  final String baseUrl = 'http://10.0.2.2:8000/api/products';

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Méthode pour récupérer les produits
  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      error('');
      final response = await http.get(
        Uri.parse(baseUrl),
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
        final responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['message'] ?? 'Erreur inconnue';
        throw Exception('Échec du chargement des produits: $errorMessage');
      }
    } catch (e) {
      error(e.toString());
      Get.snackbar(
        'Erreur',
        'Impossible de charger les produits: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      products.assignAll(Product.sampleProducts());
      filteredProducts.assignAll(products);
    } finally {
      isLoading(false);
    }
  }

  // Méthode pour ajouter un produit
  Future<void> addProduct(Product product) async {
    try {
      isLoading(true);
      error('');
      final response = await http.post(
        Uri.parse(baseUrl), // URL corrigée
        headers: await ApiService.getHeaders(), // Correction des en-têtes
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
        final responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['message'] ?? 'Erreur inconnue';
        throw Exception('Échec de l\'ajout du produit: $errorMessage');
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

  // Méthode pour rechercher un produit
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

  // Méthode pour ajouter/retirer un favori
  Future<void> toggleFavorite(String productId) async {
    try {
      if (favoriteIds.contains(productId)) {
        favoriteIds.remove(productId);
      } else {
        favoriteIds.add(productId);
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de mettre à jour les favoris',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Récupérer le nombre de favoris
  int get favoriteCount => favoriteIds.length;

  // Vérifier si un produit est favori
  bool isFavorite(String productId) => favoriteIds.contains(productId);

  // Récupérer le nombre d'articles dans le panier
  int get cartCount {
    final cartController = Get.find<CartController>();
    return cartController.cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Filtrer les produits par catégorie
  List<Product> getProductsByCategory(String category) {
    return products.where((p) => p.category == category).toList();
  }
}
