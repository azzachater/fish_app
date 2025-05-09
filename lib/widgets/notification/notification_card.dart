import 'package:flutter/material.dart';
import '../../models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onDelete;

  const NotificationCard({required this.notification, required this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Utilise 'color' au lieu de 'backgroundColor'
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: const Text('🔔', style: TextStyle(fontSize: 24)),
        title: Text(notification.message),
        subtitle: Text(
          '${notification.createdAt.toLocal()}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
