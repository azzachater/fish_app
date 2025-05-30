import 'package:fish_app/models/fishingJournal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'journal_controller.dart';

class AddJournalController extends GetxController {
  // Contrôleurs de texte
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final speciesController = TextEditingController();
  final conditionsController = TextEditingController();
  final notesController = TextEditingController();

  // Sélecteurs de date/heure
  final selectedDate = DateTime.now().obs;
  final selectedTime = TimeOfDay.now().obs;
  final isEditing = false.obs;
  String? editId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      _initEditData(args as Map<String, dynamic>);
    }
  }

  void _initEditData(Map<String, dynamic> entry) {
    isEditing.value = true;
    editId = entry['id'];
    titleController.text = entry['title'];
    locationController.text = entry['location'];
    speciesController.text = entry['species_caught'];
    conditionsController.text = entry['fishing_conditions'];
    notesController.text = entry['notes'];
    selectedDate.value = DateFormat('yyyy-MM-dd').parse(entry['date']);
    selectedTime.value = _parseTime(entry['time']);
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
    );
    if (picked != null) {
      selectedTime.value = picked;
    }
  }

  void saveJournal() {
    if (!_validateFields()) return;

    final journalData = FishingJournal(
      id: editId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text,
      location: locationController.text,
      species_caught: speciesController.text,
      fishing_conditions: conditionsController.text,
      notes: notesController.text,
      date: DateFormat('yyyy-MM-dd').format(selectedDate.value),
      time: '${selectedTime.value.hour}:${selectedTime.value.minute}',
    );

    final journalController = Get.find<JournalController>();
    if (isEditing.value) {
      journalController.updateEntry(editId!, journalData);
    } else {
      journalController.addEntry(journalData);
    }

    Get.back(result: journalData);
  }

  bool _validateFields() {
    if (titleController.text.isEmpty || locationController.text.isEmpty) {
      Get.snackbar(
        'Champs requis',
        'Veuillez remplir tous les champs obligatoires',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    titleController.dispose();
    locationController.dispose();
    speciesController.dispose();
    conditionsController.dispose();
    notesController.dispose();
    super.onClose();
  }
}