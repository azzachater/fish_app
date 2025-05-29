import 'dart:io';

import 'package:fish_app/controllers/user_controller.dart';
import 'package:fish_app/service/api_product_service.dart';
import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';
import 'package:fish_app/controller/cart_controller.dart';
import 'package:get_storage/get_storage.dart';

class ProductController extends GetxController {
  final RxMap<String, List<String>> userFavorites =
      <String, List<String>>{}.obs;
  List<String> get favoriteIds => userFavorites[currentUserId] ?? [];
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var isLoading = false.obs;
  var error = RxString('');
  final ApiProductService apiService = ApiProductService();
  final storage = GetStorage();
  //zidt hedhi
  String get currentUserId {
    final userController = Get.find<UserController>();
    return userController.currentUser.value?.id?.toString() ?? '0';
  }

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
    fetchProducts();
  }

  void _loadFavorites() {
    final saved = storage.read<Map>('user_favorites') ?? {};
    userFavorites.assignAll(
      Map<String, List<String>>.from(
        saved.map((k, v) => MapEntry(k, List<String>.from(v))),
      ),
    );
  }

  // Méthode pour récupérer les produits
  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      error('');

      final List<Product> fetchedProducts = await apiService.getProduct();

      // Mettre à jour le statut isFavorite pour chaque produit
      for (var product in fetchedProducts) {
        product.isFavorite = favoriteIds.contains(product.id);
      }

      products.assignAll(fetchedProducts);
      filteredProducts.assignAll(products);

      print('✅ ${products.length} produits chargés');
    } catch (e) {
      error(e.toString());
      Get.snackbar(
        'Erreur',
        'Impossible de charger les produits: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
  /*Future<List<Product>> fetchProducts() async {
    try {
      final response = await apiService.getProduct();
      return response;
    } catch (e) {
      print('Error fetching products: $e');
      Get.snackbar('Erreur', 'Impossible de charger les produits');
      return [];
    }
  }*/

  // Méthode pour ajouter un produit
  Future<void> createProduct(Product product, {required File imageFile}) async {
    try {
      isLoading(true);
      final newProduct = await apiService.createProduct(
        product.copyWith(id: ''), // Reset ID pour la création
        imageFile: imageFile,
      );

      products.add(newProduct);
      filteredProducts.assignAll(products);

      Get.back();
      Get.snackbar('Succès', 'Produit créé avec ID: ${newProduct.id}');
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Échec de création: ${e.toString().replaceAll('Exception: ', '')}',
        snackPosition: SnackPosition.BOTTOM,
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

  List<Product> get favoriteProducts =>
      products.where((p) => isFavorite(p.id)).toList();
  // Méthode pour ajouter/retirer un favori
  void toggleFavorite(String productId) {
    final favs = favoriteIds;
    if (favs.contains(productId)) {
      favs.remove(productId);
    } else {
      favs.add(productId);
    }
    userFavorites[currentUserId] = favs;
    storage.write('user_favorites', userFavorites);
    update();
  }

  bool isFavorite(String productId) => favoriteIds.contains(productId);

  // Récupérer le nombre de favoris
  int get favoriteCount => favoriteIds.length;

  // Récupérer le nombre d'articles dans le panier
  int get cartCount {
    final cartController = Get.find<CartController>();
    return cartController.cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Filtrer les produits par catégorie
  List<Product> getProductsByCategory(String category) {
    return products.where((p) => p.category == category).toList();
  }

  // Dans ProductController
  Future<void> deleteProduct(String productId) async {
    try {
      isLoading(true);
      await apiService.deleteProduct(productId);

      // Retirer le produit des listes locales
      products.removeWhere((p) => p.id == productId);
      filteredProducts.removeWhere((p) => p.id == productId);

      // Retirer des favoris si nécessaire
      if (favoriteIds.contains(productId)) {
        favoriteIds.remove(productId);
      }
    } catch (e) {
      error(e.toString());
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProduct(Product product, {File? imageFile}) async {
    try {
      isLoading(true);

      // Vérification des champs obligatoires
      if (product.name.isEmpty) {
        throw Exception('Le nom du produit est obligatoire');
      }

      final updatedProduct = await apiService.updateProduct(
        product,
        imageFile: imageFile,
      );

      // Mise à jour de la liste locale
      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        products[index] = updatedProduct;
        filteredProducts.assignAll(products);
      }

      Get.back();
      Get.snackbar('Succès', 'Produit mis à jour');
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Échec de la mise à jour: ${e.toString().replaceAll("Exception: ", "")}',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      rethrow;
    } finally {
      isLoading(false);
    }
  }
}