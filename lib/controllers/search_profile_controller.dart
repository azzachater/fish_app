import 'package:get/get.dart';
import '../../models/user_model.dart';
import 'user_controller.dart';

class SearchProfileController extends GetxController {
  final UserController _userController = Get.find<UserController>();

  var filteredUsers = <User>[].obs;
  var isSearching = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllUsersFromController();
  }

  void fetchAllUsersFromController() async {
    try {
      isLoading(true);

      /// Appel le UserController pour charger les utilisateurs s'ils ne sont pas encore là
      if (_userController.allUsers.isEmpty) {
        await _userController.fetchAllUsers();
      }

      /// Tu copies la liste dans filteredUsers pour l'utiliser localement
      filteredUsers.assignAll(_userController.allUsers);

      /// 🔍 Ajoute des logs
      print('📋 Utilisateurs récupérés via UserController :');
      for (var user in filteredUsers) {
        print('👤 ${user.name} - ${user.email}- Avatar: ${user.avatar}');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les utilisateurs');
      print('❌ Erreur dans fetchAllUsersFromController: $e');
    } finally {
      isLoading(false);
    }
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.assignAll(_userController.allUsers);
    } else {
      filteredUsers.assignAll(
        _userController.allUsers.where(
          (user) => user.name.toLowerCase().contains(query.toLowerCase()),
        ).toList(),
      );
    }

    print('🔎 Filtrage avec "$query", ${filteredUsers.length} résultats trouvés');
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      filteredUsers.assignAll(_userController.allUsers);
    }
  }
}
