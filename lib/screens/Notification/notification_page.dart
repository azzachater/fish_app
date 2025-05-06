import 'package:fish_app/screens/Notification/order_notification_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notification_controller.dart';
import '../../widgets/notification/notification_card.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    // Appelle le chargement des notifications une seule fois
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadNotifications();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.notifications.isEmpty) {
          return const Center(child: Text('Aucune notification'));
        } else {
          return ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notif = controller.notifications[index];
              return notif.type == 'new_order'
              ? OrderNotificationCard(
                  notification: notif,
                  onDelete: () => controller.deleteNotification(notif.id),
                )
              : NotificationCard( // Votre widget existant pour les messages
                  notification: notif,
                  onDelete: () => controller.deleteNotification(notif.id),
                );
            },
          );
        }
      }),
    );
  }
}
