import 'dart:io';

import 'package:fish_app/service/api_product_service.dart';
import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';
import 'package:fish_app/controller/cart_controller.dart';
import 'package:get_storage/get_storage.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var isLoading = false.obs;
  var error = RxString('');
  final RxList<String> favoriteIds = <String>[].obs;

  final ApiProductService apiService = ApiProductService();
  final storage = GetStorage();
  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
    fetchProducts();
  }
  void _loadFavorites() {
    final saved = storage.read<List>('favorites');
    if (saved != null) {
      favoriteIds.assignAll(saved.cast<String>());
    }
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
    if (favoriteIds.contains(productId)) {
      favoriteIds.remove(productId);
    } else {
      favoriteIds.add(productId);
    }
    storage.write('favorites', favoriteIds); // Persist localement
    update(); // Force le refresh
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
    final updatedProduct = await apiService.updateProduct(
      product,
      imageFile: imageFile,
    );

    // Mettre à jour la liste
    final index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      products[index] = updatedProduct;
      filteredProducts.assignAll(products);
    }

    Get.back();
    Get.snackbar('Succès', 'Produit mis à jour');
  } catch (e) {
    Get.snackbar('Erreur', 'Échec de la mise à jour: ${e.toString()}');
    throw e;
  } finally {
    isLoading(false);
  }
}

}