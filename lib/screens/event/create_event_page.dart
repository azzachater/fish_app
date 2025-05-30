import 'package:fish_app/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/controller/event_controller.dart';
import 'package:intl/intl.dart';
import 'package:fish_app/models/event.dart';

class CreateEventPage extends StatefulWidget {
  final Event? event;

  const CreateEventPage({Key? key, this.event}) : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final EventController eventController = Get.find();
  late final TextEditingController titleController;
  late final TextEditingController locationController;
  late final TextEditingController descriptionController;
  late final TextEditingController dateController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.event?.title ?? '');
    locationController = TextEditingController(text: widget.event?.location ?? '');
    descriptionController = TextEditingController(text: widget.event?.description ?? '');
    dateController = TextEditingController(
      text: widget.event != null 
          ? DateFormat('yyyy-MM-dd').format(widget.event!.date) 
          : ''
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.event?.date ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        dateController.text = formattedDate;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      DateTime? eventDate;
      try {
        eventDate = DateFormat('yyyy-MM-dd').parse(dateController.text);
      } catch (e) {
        Get.snackbar('Erreur', 'Format de date invalide.');
        return;
      }

      if (widget.event != null) {
        // Mode édition
        eventController.updateEvent(
          eventId: widget.event!.id!,
          title: titleController.text,
          location: locationController.text,
          description: descriptionController.text,
          date: eventDate,
        );
      } else {
        // Mode création
        eventController.addEvent(
          title: titleController.text,
          location: locationController.text,
          description: descriptionController.text,
          date: eventDate,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.event != null;
    final borderRadius = BorderRadius.circular(12);
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: AppTheme.primaryColor!, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: AppTheme.primaryColor!, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: AppTheme.primaryColor!, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Modifier Événement' : 'Créer un Événement',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              _buildLabeledField(
                icon: Icons.title,
                label: "Titre*",
                controller: titleController,
                hint: "Nom de l'événement",
                decoration: inputDecoration,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le titre est obligatoire';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildLabeledField(
                icon: Icons.location_on,
                label: "Lieu*",
                controller: locationController,
                hint: "Lieu de l'événement",
                decoration: inputDecoration,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le lieu est obligatoire';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildLabeledField(
                icon: Icons.description,
                label: "Description",
                controller: descriptionController,
                hint: "Description (optionnelle)",
                decoration: inputDecoration,
                maxLines: 3,
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: _buildLabeledField(
                    icon: Icons.calendar_today,
                    label: "Date*",
                    controller: dateController,
                    hint: "Sélectionnez une date",
                    decoration: inputDecoration.copyWith(
                      suffixIcon: Icon(Icons.calendar_month, color: AppTheme.primaryColor),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La date est obligatoire';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isEdit ? "Enregistrer les modifications" : "Créer l'événement",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required String hint,
    required InputDecoration decoration,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: decoration.copyWith(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppTheme.primaryColor),
          ),
          validator: validator,
        ),
      ],
    );
  }
}