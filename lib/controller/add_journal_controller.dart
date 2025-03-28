import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddJournalController extends GetxController {
  // États observables
  final selectedDateIndex = 0.obs;
  final showCalendar = false.obs;
  final fromTime = Rx<TimeOfDay?>(null);
  final toTime = Rx<TimeOfDay?>(null);
  final selectedDate = Rx<DateTime?>(DateTime.now());
  final descriptionController = TextEditingController();
  final isSaving = false.obs;

  // Dictionnaire pour stocker les entrées de journal par date
  final journalEntries = <DateTime, List<Map<String, dynamic>>>{}.obs;

  // Validation du formulaire
  RxBool get isFormValid =>
      (fromTime.value != null &&
              toTime.value != null &&
              descriptionController.text.isNotEmpty &&
              selectedDate.value != null)
          .obs;

  // Liste des dates disponibles
  List<Map<String, dynamic>> getDates() {
    final now = DateTime.now();
    return List.generate(3, (index) {
      final date = now.add(Duration(days: index));
      return {
        "date": date.toIso8601String(),
        "day": DateFormat('d').format(date),
        "weekday": DateFormat('E').format(date),
      };
    });
  }

  // Ajouter un journal pour la date sélectionnée
  void addJournal(DateTime date, String description) {
    // Si la date existe déjà, ajouter le journal, sinon créer une nouvelle entrée
    if (journalEntries.containsKey(date)) {
      journalEntries[date]?.add({
        'from': fromTime.value?.format(Get.context!),
        'to': toTime.value?.format(Get.context!),
        'description': description,
      });
    } else {
      journalEntries[date] = [
        {
          'from': fromTime.value?.format(Get.context!),
          'to': toTime.value?.format(Get.context!),
          'description': description,
        },
      ];
    }
  }

  // Sélection d'une heure
  Future<void> selectTime(BuildContext context, bool isFrom) async {
    final initialTime =
        isFrom
            ? fromTime.value ?? TimeOfDay.now()
            : toTime.value ?? TimeOfDay.now();

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isFrom) {
        fromTime.value = picked;
      } else {
        toTime.value = picked;
      }
    }
  }

  // Sélection d'une date personnalisée
  void selectCustomDate(DateTime date) {
    selectedDate.value = date;
    toggleCalendar(); // Masquer le calendrier
  }

  // Basculer l'affichage du calendrier
  void toggleCalendar() {
    showCalendar.value = !showCalendar.value;
  }

  // Sauvegarder le journal
  void saveJournal(String description) {
    if (selectedDate.value != null) {
      addJournal(selectedDate.value!, description);
    }
  }
}
