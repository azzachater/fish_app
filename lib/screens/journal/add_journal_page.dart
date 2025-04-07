import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fish_app/controller/journal_controller.dart';

class AddJournalPage extends StatelessWidget {
  final JournalController journalController = Get.find();
  final Map<String, dynamic>? entry;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _fishTypeController = TextEditingController();
  final Rx<DateTime> _selectedDate = DateTime.now().obs;
  final Rx<TimeOfDay> _selectedTime = TimeOfDay.now().obs;

  AddJournalPage({super.key, this.entry}) {
    if (entry != null) {
      _titleController.text = entry!['title'];
      _locationController.text = entry!['location'];
      _descriptionController.text = entry!['description'];
      _fishTypeController.text = entry!['fishType'];
      _selectedDate.value = DateFormat('yyyy-MM-dd').parse(entry!['date']);
      _selectedTime.value = _parseTime(entry!['time']);
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
        title: Text(entry == null ? 'Add Journal' : 'Edit Journal'),
        actions: [
          if (entry != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                journalController.deleteEntry(entry!['id']);
                Get.back();
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date & Time Selectors
            _buildDateTimeSelector(context),

            const SizedBox(height: 20),
            // Title Input
            _buildTextField('Title', _titleController),

            const SizedBox(height: 16),
            // Location Input
            _buildTextField('Location', _locationController),

            const SizedBox(height: 16),
            // Fish Type Input
            _buildTextField('Fish Type', _fishTypeController),

            const SizedBox(height: 16),
            // Description Input
            _buildDescriptionField(),

            const SizedBox(height: 30),
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _saveJournal(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save Journal',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Date & Time Selector
  Widget _buildDateTimeSelector(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => InkWell(
              onTap: () => _selectDate(context),
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
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Time',
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

  // Text Input Field Builder
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Description Input Field with custom styling
  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Describe your fishing experience...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  // Date Selection Logic
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

  // Time Selection Logic
  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime.value,
    );
    if (picked != null) {
      _selectedTime.value = picked;
    }
  }

  // Save Journal Logic
  void _saveJournal(BuildContext context) {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final journalData = {
      'id': entry?['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'title': _titleController.text,
      'location': _locationController.text,
      'fishType': _fishTypeController.text,
      'description': _descriptionController.text,
      'date': DateFormat('yyyy-MM-dd').format(_selectedDate.value),
      'time': _selectedTime.value.format(context),
      'createdAt': DateTime.now().toIso8601String(),
    };

    if (entry == null) {
      journalController.addEntry(journalData);
    } else {
      journalController.updateEntry(entry!['id'], journalData);
    }

    Get.back(result: journalData);
  }
}
