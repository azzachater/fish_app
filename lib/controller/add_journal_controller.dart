import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddJournalController extends GetxController {
  // États observables
  var selectedDate = DateTime.now().obs;
  var fromTime = Rx<TimeOfDay?>(null);
  var toTime = Rx<TimeOfDay?>(null);
  var descriptionController = TextEditingController();
  var journals = <String, List<String>>{}.obs;

  // Sauvegarder le journal pour la date sélectionnée
  void saveJournal() {
    String dateKey = DateFormat('yyyy-MM-dd').format(selectedDate.value);
    String description = descriptionController.text.trim();

    if (description.isNotEmpty) {
      journals.update(
        dateKey,
        (existing) => existing..add(description),
        ifAbsent: () => [description],
      );
      descriptionController.clear();
      Get.snackbar(
        'Success',
        'Journal saved for ${DateFormat('dd/MM/yyyy').format(selectedDate.value)}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Please enter a description',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Sélection d'une heure
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

  // Sélection d'une date
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
