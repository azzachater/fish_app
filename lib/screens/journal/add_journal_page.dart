import 'package:fish_app/controller/journal_controller.dart';
import 'package:fish_app/models/fishingJournal.dart';
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

  DateTime _selectedDate = DateTime.now();
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

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
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
        prefixIcon: icon != null ? Icon(icon, color: Colors.blue[700]) : null,
        filled: true,
        fillColor: Colors.blue[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Remplacez la méthode _saveJournal() par :
  // Modifiez la méthode _saveJournal pour utiliser la date exacte
  void _saveJournal() {
    // Formattez la date sélectionnée en yyyy-MM-dd
    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    print("Enregistrement pour la date: $formattedDate"); // Debug

    final journal = FishingJournal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      location: _locationController.text,
      speciesCaught: _speciesController.text,
      fishingConditions: _conditionsController.text,
      notes: _notesController.text,
      date: formattedDate, // Utilisez la date formatée
      time: '${_selectedTime.hour}:${_selectedTime.minute}',
    );

    final controller = Get.find<JournalController>();
    controller.addEntry(journal).then((_) {
      // Filtre à nouveau pour la date actuelle
      controller.filterByDate(_selectedDate);
      Get.back();
      Get.snackbar("Succès", "Journal enregistré !");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un Journal de Pêche"),
        backgroundColor: Colors.blue[700],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.blue[700],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _selectTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.access_time, color: Colors.blue[700]),
                              const SizedBox(width: 8),
                              Text(
                                _selectedTime.format(context),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
                  icon: Icons.water, // more intuitive than iso
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                  ),
                  onPressed: _saveJournal,
                  child: const Text(
                    'Enregistrer',
                    style: TextStyle(fontSize: 18),
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
