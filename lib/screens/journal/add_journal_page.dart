import 'package:fish_app/controller/journal_controller.dart';
import 'package:fish_app/models/fishingJournal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddJournalPage extends StatelessWidget {
  final FishingJournal? entry;
  final JournalController journalController = Get.find<JournalController>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _conditionsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final Rx<DateTime> _selectedDate = DateTime.now().obs;
  final Rx<TimeOfDay> _selectedTime = TimeOfDay.now().obs;

  AddJournalPage({super.key, this.entry}) {
    if (entry != null) {
      _titleController.text = entry!.title;
      _locationController.text = entry!.location;
      _speciesController.text = entry!.speciesCaught;
      _conditionsController.text = entry!.fishingConditions;
      _notesController.text = entry!.notes;
      _selectedDate.value = DateFormat('yyyy-MM-dd').parse(entry!.date);
      _selectedTime.value = _parseTime(entry!.time);
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entry == null ? 'Nouvelle entrée' : 'Modifier entrée'),
        actions: [
          if (entry != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDateTimeSelector(context),
            const SizedBox(height: 20),
            _buildTitleField(),
            const SizedBox(height: 16),
            _buildLocationField(),
            const SizedBox(height: 16),
            _buildSpeciesField(),
            const SizedBox(height: 16),
            _buildConditionsField(),
            const SizedBox(height: 16),
            _buildNotesField(),
            const SizedBox(height: 30),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSelector(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => InkWell(
              onTap: () => _selectDate(context),
              borderRadius: BorderRadius.circular(10),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  DateFormat('dd/MM/yyyy').format(_selectedDate.value),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Obx(
            () => InkWell(
              onTap: () => _selectTime(context),
              borderRadius: BorderRadius.circular(10),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Heure',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(_selectedTime.value.format(context)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Titre*',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      maxLength: 50,
    );
  }

  Widget _buildLocationField() {
    return TextField(
      controller: _locationController,
      decoration: InputDecoration(
        labelText: 'Lieu*',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildSpeciesField() {
    return TextField(
      controller: _speciesController,
      decoration: InputDecoration(
        labelText: 'Espèces pêchées',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildConditionsField() {
    return TextField(
      controller: _conditionsController,
      decoration: InputDecoration(
        labelText: 'Conditions de pêche',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Décrivez votre expérience de pêche...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _saveJournal,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          entry == null ? 'Enregistrer' : 'Mettre à jour',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _selectedDate.value = picked;
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime.value,
    );
    if (picked != null) {
      _selectedTime.value = picked;
    }
  }

  void _saveJournal() {
    if (_titleController.text.isEmpty || _locationController.text.isEmpty) {
      Get.snackbar(
        'Champs requis',
        'Veuillez remplir tous les champs obligatoires',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final journalData = FishingJournal(
      id: entry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      location: _locationController.text,
      speciesCaught: _speciesController.text,
      fishingConditions: _conditionsController.text,
      notes: _notesController.text,
      date: DateFormat('yyyy-MM-dd').format(_selectedDate.value),
      time: '${_selectedTime.value.hour}:${_selectedTime.value.minute}',
    );

    if (entry == null) {
      journalController.addEntry(journalData);
    } else {
      journalController.updateEntry(entry!.id, journalData);
    }

    Get.back(result: journalData);
  }

  void _confirmDelete() {
    Get.defaultDialog(
      title: 'Confirmer la suppression',
      content: const Text('Voulez-vous vraiment supprimer cette entrée ?'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
        TextButton(
          onPressed: () {
            journalController.deleteEntry(entry!.id);
            Get.back();
            Get.back();
          },
          child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
