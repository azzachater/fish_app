import 'package:fish_app/controller/order_controller.dart';
import 'package:fish_app/models/order.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';

class OrderNotificationListener extends GetxService {
  final NotificationController _notificationCtrl = Get.find();
  final OrderController _orderCtrl = Get.find();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  void initialize() {
    ever(_orderCtrl.orders, (List<Order> orders) {
      if (orders.isNotEmpty) {
        final latestOrder = orders.last;
        if (latestOrder.items.isNotEmpty) {
          _notificationCtrl.handleNewOrder({
            'id': latestOrder.id,
            'buyer_id': latestOrder.buyerId,
            'seller_id': latestOrder.items.first.sellerId,
            'total': latestOrder.total,
            'created_at': latestOrder.createdAt?.toIso8601String(),
          });
        }
      }
    });
  }
}