import 'package:get/get.dart';
import '../models/notification_model.dart';
import '../services/api_notification_service.dart';
import './user_controller.dart'; // Importez le UserController

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;
  var unreadStatus = false.obs;
  var unreadCount = 0.obs;

  final UserController _userController = Get.find<UserController>(); // Accès au UserController

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
  isLoading.value = true;
  try {
    // S’assurer que l’utilisateur est bien chargé
    if (_userController.currentUser.value == null) {
      await _userController.fetchCurrentUser();
    }

    final currentUser = _userController.currentUser.value;
    if (currentUser == null) {
      throw Exception('Utilisateur non connecté');
    }

    // Appel de l’API
    final response = await NotificationApiService.fetchNotifications();

    // Récupération des données
    final bool unread = response['unread'];
    final List<NotificationModel> allNotifications = response['notifications'];

    // Filtrer les notifications de l'utilisateur courant (optionnel si Laravel filtre déjà)
    final userNotifications = allNotifications.where((notif) =>
        notif.receiverId == currentUser.id).toList();

    // Mise à jour des observables
    notifications.value = userNotifications;
    unreadStatus.value = unread; // <- pour afficher le badge
    unreadCount.value = userNotifications.where((notif) => !notif.isRead).length;

  } catch (e) {
    print('Erreur lors du chargement des notifications: $e');
    Get.snackbar(
      'Erreur',
      'Impossible de charger les notifications: ${e.toString()}',
      duration: const Duration(seconds: 4),
    );
  } finally {
    isLoading.value = false;
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


  void addNotification(NotificationModel notification) {
  notifications.insert(0, notification);
  unreadStatus.value = true; // <--- toujours cette seule source de vérité
  }

}