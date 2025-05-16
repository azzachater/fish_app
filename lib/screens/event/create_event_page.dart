import 'package:fish_app/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/controller/event_controller.dart';
import 'package:intl/intl.dart';
import 'package:fish_app/models/event.dart';

class CreateEventPage extends StatefulWidget {
  final Event? event; // pour savoir si c’est une édition

  const CreateEventPage({super.key, this.event});

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final EventController eventController = Get.find();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    AppTheme.primaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Formatage de la date en 'yyyy-MM-dd' pour correspondre à l'API
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        dateController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: AppTheme.primaryColor,
      border: OutlineInputBorder(borderRadius: borderRadius),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
        borderRadius: borderRadius,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crée un événement ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Color(0xFF4A8BE5),
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildLabeledField(
              icon: Icons.title,
              label: "Titre",
              controller: titleController,
              hint: "Nom de l'événement",
              decoration: inputDecoration,
            ),
            SizedBox(height: 16),
            _buildLabeledField(
              icon: Icons.location_on,
              label: "Lieu",
              controller: locationController,
              hint: "Lieu de l'événement",
              decoration: inputDecoration,
            ),
            SizedBox(height: 16),
            _buildLabeledField(
              icon: Icons.description,
              label: "Description",
              controller: descriptionController,
              hint: "Brève description",
              decoration: inputDecoration,
              maxLines: 3,
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: _buildLabeledField(
                  icon: Icons.calendar_today,
                  label: "Date",
                  controller: dateController,
                  hint: "Sélectionnez une date",
                  decoration: inputDecoration.copyWith(
                    suffixIcon: Icon(
                      Icons.calendar_month,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Convert the string from the date controller to a DateTime object
                  DateTime? eventDate;
                  try {
                    eventDate = DateFormat(
                      'yyyy-MM-dd',
                    ).parse(dateController.text); // Convert string to DateTime
                  } catch (e) {
                    Get.snackbar('Erreur', 'Format de date invalide.');
                    return;
                  }

                  // Pass the DateTime object to addEvent
                  eventController.addEvent(
                    title: titleController.text,
                    location: locationController.text,
                    description: descriptionController.text,
                    date: eventDate,
                  );

                  Get.back();
                },
                icon: Icon(Icons.add),
                label: Text("Ajouter l'événement"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
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
            color: AppTheme.primaryColorGrey,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: decoration.copyWith(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppTheme.primaryColor),
          ),
        ),
      ],
    );
  }
}