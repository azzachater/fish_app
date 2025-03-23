import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddJournalController extends GetxController {
  var selectedDateIndex = 1.obs;
  var fromTime = Rx<TimeOfDay?>(null);
  var toTime = Rx<TimeOfDay?>(null);
  var descriptionController = TextEditingController();

  List<Map<String, String>> getDates() {
    DateTime now = DateTime.now();
    return List.generate(3, (index) {
      DateTime date = now.add(Duration(days: index));
      return {
        "day": "${date.day}",
        "weekday":
            ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][date.weekday - 1],
      };
    });
  }

  Future<void> selectTime(BuildContext context, bool isFrom) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      if (isFrom) {
        fromTime.value = picked;
      } else {
        toTime.value = picked;
      }
    }
  }

  void saveJournal() {
    if (fromTime.value == null ||
        toTime.value == null ||
        descriptionController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      return;
    }

    Get.snackbar(
      "Success",
      "Journal saved successfully!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Get.back(); // Retour à la page précédente
  }
}
