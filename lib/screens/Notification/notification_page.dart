import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notification_controller.dart';
import '../../widgets/notification/notification_card.dart';
import 'package:fish_app/constants/theme.dart';
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
  backgroundColor: Colors.white, // fond blanc
  appBar: AppBar(
    backgroundColor: AppTheme.primaryColor,
    title: const Text(
      'Notifications',
      style: TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Colors.white), // Pour la flèche retour en blanc
  ),
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
              return NotificationCard(
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
