import 'package:fish_app/service/api_order_service.dart';
import 'package:get/get.dart';
import '../models/order.dart';

class OrderController extends GetxController {
  final RxList<Order> orders = <Order>[].obs;
  final isLoading = false.obs;

  final ApiOrderService _orderService = ApiOrderService();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final orders = await _orderService.getOrders();
      this.orders.assignAll(orders);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createOrder(Map<String, dynamic> orderData) async {
    try {
      isLoading.value = true;
      final newOrder = await _orderService.createOrder(orderData);
      orders.add(newOrder);
    } catch (e) {
      Get.snackbar('Error', 'Failed to create order: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}