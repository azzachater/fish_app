import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/controller/event_controller.dart';

class CreateEventPage extends StatelessWidget {
  final EventController eventController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Créer un événement"),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Titre de l'événement"),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: "Lieu de l'événement"),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: "Date de l'événement"),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                eventController.addEvent(
                  titleController.text,
                  locationController.text,
                  descriptionController.text,
                  dateController.text,
                );
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Ajouter l'événement"),
            ),
          ],
        ),
      ),
    );
  }
}
