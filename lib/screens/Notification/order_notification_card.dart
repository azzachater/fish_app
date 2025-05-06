import 'package:fish_app/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class OrderNotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onDelete;

  const OrderNotificationCard({
    required this.notification,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shopping_cart, color: Colors.green),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nouvelle commande',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: notification.isRead ? Colors.grey : Colors.black,
                        ),
                      ),
                      Text(
                        notification.message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 20),
                  onPressed: onDelete,
                ),
              ],
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Get.toNamed('/orders/${notification.conversationId}');
              },
              child: Text('Voir les détails'),
            ),
          ],
        ),
      ),
    );
  }
}