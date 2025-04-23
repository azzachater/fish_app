import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/controller/journal_controller.dart';
import 'package:fish_app/controller/data_selector_controller.dart';
import 'package:fish_app/models/fishingJournal.dart';
import 'package:fish_app/screens/journal/data_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddJournalPage extends StatefulWidget {
  final FishingJournal? entry;
  const AddJournalPage({Key? key, this.entry}) : super(key: key);

  @override
  State<AddJournalPage> createState() => _AddJournalPageState();
}

class _AddJournalPageState extends State<AddJournalPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _conditionsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final DateSelectorController _dateSelectorController = Get.put(
    DateSelectorController(),
  );
  TimeOfDay _selectedTime = TimeOfDay.now();

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _locationController.dispose();
    _speciesController.dispose();
    _conditionsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    int maxLines = 1,
    int? maxLength,
    String? hint,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: AppTheme.textDark),
        prefixIcon:
            icon != null ? Icon(icon, color: AppTheme.primaryColor) : null,
        filled: true,
        fillColor: AppTheme.primaryLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _saveJournal() {
    final selectedDate =
        _dateSelectorController.dates[_dateSelectorController
            .selectedIndex
            .value];
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    final journal = FishingJournal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      location: _locationController.text,
      speciesCaught: _speciesController.text,
      fishingConditions: _conditionsController.text,
      notes: _notesController.text,
      date: formattedDate,
      time: '${_selectedTime.hour}:${_selectedTime.minute}',
    );

    final controller = Get.find<JournalController>();
    controller.addEntry(journal).then((_) {
      controller.filterByDate(selectedDate);
      Get.back();
      Get.snackbar("Succès", "Journal enregistré !");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un Journal de Pêche"),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Choisir une date",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                DateSelector(),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _selectTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          _selectedTime.format(context),
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildStyledTextField(
                  controller: _titleController,
                  label: 'Titre*',
                  icon: Icons.title,
                  maxLength: 50,
                ),
                const SizedBox(height: 16),
                _buildStyledTextField(
                  controller: _locationController,
                  label: 'Lieu de pêche',
                  icon: Icons.place,
                ),
                const SizedBox(height: 16),
                _buildStyledTextField(
                  controller: _speciesController,
                  label: 'Espèces pêchées',
                  icon: Icons.water,
                ),
                const SizedBox(height: 16),
                _buildStyledTextField(
                  controller: _conditionsController,
                  label: 'Conditions météo',
                  icon: Icons.wb_sunny,
                ),
                const SizedBox(height: 16),
                _buildStyledTextField(
                  controller: _notesController,
                  label: 'Notes supplémentaires',
                  icon: Icons.notes,
                  maxLines: 3,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _saveJournal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    "Enregistrer le journal",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}