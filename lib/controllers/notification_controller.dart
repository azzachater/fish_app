import 'package:get/get.dart';
import '../models/notification_model.dart';
import '../services/api_notification_service.dart';
import './user_controller.dart'; // Importez le UserController

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;
  final UserController _userController = Get.find<UserController>(); // Accès au UserController

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    isLoading.value = true;
    try {
      // Attendre que l'utilisateur courant soit chargé si ce n'est pas déjà fait
      if (_userController.currentUser.value == null) {
        await _userController.fetchCurrentUser();
      }
      
      // Vérifier que l'utilisateur est bien connecté
      final currentUser = _userController.currentUser.value;
      if (currentUser == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Récupérer toutes les notifications
      final allNotifications = await NotificationApiService.fetchNotifications();
      
      // Filtrer pour ne garder que celles du current user
      notifications.value = allNotifications.where((notif) => 
        notif.receiverId == currentUser.id
      ).toList();

    } catch (e) {
      print('Error loading notifications: $e');
      Get.snackbar(
        'Erreur', 
        'Impossible de charger les notifications: ${e.toString()}',
        duration: Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await NotificationApiService.markAsRead(id);
      notifications.removeWhere((notif) => notif.id == id);
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de marquer la notification comme lue');
    }
  }
  void deleteNotification(int id) async {
  try {
    await NotificationApiService.deleteNotification(id);
    notifications.removeWhere((notif) => notif.id == id);
  } catch (e) {
    Get.snackbar('Erreur', e.toString());
  }
}

}