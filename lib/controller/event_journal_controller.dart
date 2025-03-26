import 'package:fish_app/models/event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class JournalController extends GetxController {
  var today = DateTime.now().obs;
  var selectedDay = DateTime.now().obs;
  var eventController = TextEditingController();
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  var locationController = TextEditingController();

  // Liste des événements pour simplifier l'exemple
  var events = <Event>[].obs;

  // Récupère les événements pour une journée donnée
  List<Event> getEventsForDay(DateTime day) {
    // Retourne les événements qui correspondent à la journée
    return events.where((event) => isSameDay(event.startDate, day)).toList();
  }

  // Méthode pour ajouter un événement
  void addEvent() {
    final newEvent = Event(
      title: eventController.text,
      startDate: DateTime.parse(startDateController.text),
      endDate: DateTime.parse(endDateController.text),
      location: locationController.text,
    );
    events.add(newEvent);
    Get.back(); // Ferme le dialogue
  }

  // Retourne les événements à venir
  List<Event> getUpcomingEvents() {
    return events
        .where((event) => event.startDate.isAfter(DateTime.now()))
        .toList();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay.value = selectedDay;
    this.today.value = focusedDay;
  }

  void selectStartDate(BuildContext context) {
    // Logique de sélection de la date de début
  }

  void selectEndDate(BuildContext context) {
    // Logique de sélection de la date de fin
  }
}
