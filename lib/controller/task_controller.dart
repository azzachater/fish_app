import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

class TaskController extends GetxController {
  // Liste principale avec vos enregistrements par défaut
  final RxList<Map<String, dynamic>> tasks =
      <Map<String, dynamic>>[
        {
          "title": "Brochet",
          "description":
              "Lac - Eau calme, vent léger. Observation : Active le matin.",
          "status": "Enregistré",
          "icon": "🐟",
          "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
          "time": DateFormat('HH:mm').format(DateTime.now()),
        },
        {
          "title": "Dorade",
          "description":
              "Mer - Vagues modérées, appât : crevettes. Observation : Bonne prise.",
          "status": "Enregistré",
          "icon": "⚓",
          "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
          "time": DateFormat('HH:mm').format(DateTime.now()),
        },
        {
          "title": "Carpe",
          "description":
              "Étang - Eau trouble, appât : maïs. Observation : Difficile à attraper.",
          "status": "Enregistré",
          "icon": "🎣",
          "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
          "time": DateFormat('HH:mm').format(DateTime.now()),
        },
      ].obs;

  // Méthode pour ajouter un nouveau journal (conservée similaire à votre version)
  void addTask(Map<String, dynamic> newTask) {
    // Ajoute automatiquement la date et l'heure si non fournies
    final taskToAdd = {
      ...newTask,
      'date':
          newTask['date'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'time': newTask['time'] ?? DateFormat('HH:mm').format(DateTime.now()),
    };

    tasks.add(taskToAdd);
    update(); // Notifie les écouteurs
  }

  // Nouvelle méthode pour filtrer par date
  List<Map<String, dynamic>> getTasksForDate(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    return tasks.where((task) => task['date'] == dateStr).toList();
  }

  void removeTask(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
      update(); // Notifie les écouteurs du changement
      Get.snackbar(
        'Succès',
        'Journal supprimé',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  // Optionnel: Méthode pour supprimer par ID si vous en avez un
  void removeJournalById(String id) {
    tasks.removeWhere((journal) => journal['id'] == id);
    update();
  }
}
