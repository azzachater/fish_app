import 'package:fish_app/controller/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddJournalController extends GetxController {
  // États observables (conservés comme dans votre version)
  var selectedDate = DateTime.now().obs;
  var fromTime = Rx<TimeOfDay?>(null);
  var toTime = Rx<TimeOfDay?>(null);
  var descriptionController = TextEditingController();

  // Sauvegarder le journal (adapté pour le système de dates)
  void saveJournal() {
    final dateKey = DateFormat('yyyy-MM-dd').format(selectedDate.value);
    final timeKey =
        fromTime.value != null
            ? "${fromTime.value!.hour}:${fromTime.value!.minute}"
            : DateFormat('HH:mm').format(DateTime.now());

    if (descriptionController.text.isNotEmpty) {
      final newJournal = {
        "title": "Pêche du ${DateFormat('dd/MM').format(selectedDate.value)}",
        "description": descriptionController.text,
        "status": "Enregistré",
        "icon": _getIconForTime(fromTime.value),
        "date": dateKey,
        "time": timeKey,
      };

      Get.find<TaskController>().addTask(newJournal);
      descriptionController.clear();

      Get.back(result: newJournal);
      Get.snackbar(
        'Succès',
        'Journal enregistré pour le ${DateFormat('dd/MM/yyyy').format(selectedDate.value)}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Erreur',
        'Veuillez entrer une description',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Méthode pour choisir l'icône en fonction de l'heure
  String _getIconForTime(TimeOfDay? time) {
    if (time == null) return "🎣";
    return time.hour < 6
        ? "🌙"
        : time.hour < 12
        ? "🌅"
        : time.hour < 18
        ? "☀️"
        : "🌄";
  }

  // Conservez vos méthodes selectDate et selectTime existantes
  Future<void> selectTime(BuildContext context, bool isFrom) async {
    final initialTime = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      if (isFrom) {
        fromTime.value = picked;
      } else {
        toTime.value = picked;
      }
    }
  }

  void selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }
}
