import 'package:fish_app/service/api_order_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/order.dart';

class OrderController extends GetxController {
  final RxList<Order> orders = <Order>[].obs;
  final isLoading = false.obs;
  final error = RxString('');
  final RxString successMessage = RxString('');
  final ApiOrderService _orderService = ApiOrderService();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      error.value = '';
      final fetchedOrders = await _orderService.getOrders();
      orders.assignAll(fetchedOrders);
    } catch (e) {
      _handleError('fetchOrders', e, 
        defaultMessage: 'Impossible de charger les commandes');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createOrder({
    required String phone,
    required String address,
    required String paymentMethod,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      successMessage.value = '';

      final newOrder = await _orderService.createOrder(
        phone: phone,
        address: address,
        paymentMethod: paymentMethod,
      );
      
      orders.insert(0, newOrder);
      successMessage.value = 'Commande créée avec succès';
      Get.snackbar('Succès', 'Votre commande a été enregistrée');
      return true;
    } catch (e) {
      return _handleOrderCreationError(e);
    } finally {
      isLoading.value = false;
    }
  }

  bool _handleOrderCreationError(dynamic e) {
    error.value = 'Échec de la création de commande';
    
    final errorMessage = e.toString().contains('buyer_id')
        ? 'Session expirée. Veuillez vous reconnecter'
        : e.toString().contains('network')
            ? 'Problème de connexion internet'
            : 'Erreur technique. Veuillez réessayer';

    Get.snackbar(
      'Erreur', 
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
    return false;
  }

  void _handleError(String methodName, dynamic e, {String? defaultMessage}) {
    error.value = defaultMessage ?? 'Une erreur est survenue';
    debugPrint('❌ Error in $methodName: ${e.toString()}');
    
    Get.snackbar(
      'Erreur',
      error.value,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void clearMessages() {
    error.value = '';
    successMessage.value = '';
  }
}