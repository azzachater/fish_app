import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../data/user_data.dart';
import '../../models/group_model.dart';
import 'package:flutter/material.dart';

class AddUserToGroupController extends GetxController {
  late User currentUser;

  // Listes observables
  RxList<User> selectedUsers = <User>[].obs;
  RxList<User> filteredUsers = usersData.obs; // Liste des utilisateurs filtrés

  // Contrôleur de recherche
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    currentUser = usersData.first; // Initialisation de l'utilisateur actuel
  }

  // Fonction pour filtrer les utilisateurs
  void filterUsers(String query) {
    final results = usersData.where((user) {
      final userName = user.name.toLowerCase();
      final searchQuery = query.toLowerCase();
      return userName.contains(searchQuery);
    }).toList();
    filteredUsers.value = results; // Met à jour la liste filtrée
  }

  // Ajouter des utilisateurs sélectionnés au groupe
  void addUsersToGroup(Group group) {
    group.members.addAll(selectedUsers);
  }
}
