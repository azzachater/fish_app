import 'package:get/get.dart';
import '../../models/user_model.dart';
import 'package:fish_app/data/user_data.dart'; // Importation de la liste des utilisateurs

class SearchProfileController extends GetxController {
  // Liste des utilisateurs filtrés
  var filteredUsers = <User>[].obs;

  // Liste complète des utilisateurs (stockée dans users_data)
  var allUsers = <User>[];

  // État pour savoir si on est en mode recherche
  var isSearching = false.obs;

  // Initialisation avec la liste complète des utilisateurs
  @override
  void onInit() {
    super.onInit();
    allUsers = usersData; // Utiliser la liste des utilisateurs venant de 'user_data.dart'
    filteredUsers.assignAll(allUsers); // Au départ, on montre tous les utilisateurs
  }

  // Fonction pour filtrer les utilisateurs en fonction du texte saisi
  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.assignAll(allUsers); // Réinitialiser la liste filtrée
    } else {
      filteredUsers.assignAll(allUsers.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase());
      }).toList());
    }
  }

  // Fonction pour activer/désactiver la recherche
  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      filteredUsers.assignAll(allUsers);  // Réinitialiser la liste des utilisateurs
    }
  }
}
