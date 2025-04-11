import 'package:fish_app/screens/event/event_page.dart';
import 'package:fish_app/service/api_event_service.dart';
import 'package:get/get.dart';
import 'package:fish_app/models/event.dart';

class EventController extends GetxController {
  var events = <Event>[].obs;
  var isLoading = false.obs; // Nouvel état de chargement
  final ApiEventService _eventService = ApiEventService();

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      isLoading(true);
      final fetchedEvents = await _eventService.getEvents();
      events.assignAll(fetchedEvents);
    } catch (e) {
      Get.snackbar('Erreur', 'Échec du chargement des événements');
      print('❌ fetchEvents error: $e');
    } finally {
      isLoading(false);
    }
  }

  void joinEvent(int index, String userAvatarUrl) async {
    final event = events[index];

    if (!event.participants.contains(userAvatarUrl)) {
      try {
        // Créez une nouvelle liste de participants
        final updatedParticipants = [...event.participants, userAvatarUrl];

        // Créez un événement mis à jour
        final updatedEvent = Event(
          id: event.id,
          title: event.title,
          description: event.description,
          location: event.location,
          date: event.date, // Conservez la date originale
          participants: updatedParticipants,
        );

        // Envoyez la mise à jour à l'API
        final saved = await _eventService.updateEvent(updatedEvent);

        // Mettez à jour la liste locale
        events[index] = saved;

        Get.snackbar('Succès', 'Participation enregistrée');
      } catch (e) {
        Get.snackbar('Erreur', 'Échec de la participation: ${e.toString()}');
        print('❌ joinEvent error: $e');
      }
    } else {
      Get.snackbar('Info', 'Vous participez déjà');
    }
  }

  Future<void> addEvent({
  required String title,
  required String location,
  required String description,
  required DateTime date,
}) async {
  if (title.isEmpty || location.isEmpty) {
    Get.snackbar('Erreur', 'Titre et lieu sont obligatoires');
    return;
  }

  try {
    isLoading(true);
    final newEvent = Event(
      title: title,
      location: location,
      description: description,
      date: date,
      participants: [],
    );

    final createdEvent = await _eventService.createEvent(newEvent);
    events.add(createdEvent);

    // Solution optimale pour la navigation
    if (Get.isDialogOpen!) Get.back(); // Ferme le dialog si ouvert
    Get.offAll(() => EventPage()); // Force le rafraîchissement complet
    
    Get.snackbar('Succès', 'Événement créé');
  } catch (e) {
    Get.snackbar('Erreur', 'Échec de la création: ${e.toString()}');
  } finally {
    isLoading(false);
  }
}

  Future<void> deleteEvent(String eventId) async {
    try {
      isLoading(true);
      await _eventService.deleteEvent(eventId);
      events.removeWhere((e) => e.id == eventId);
      Get.snackbar('Succès', 'Événement supprimé');
    } catch (e) {
      Get.snackbar('Erreur', 'Échec de la suppression: ${e.toString()}');
      print('❌ deleteEvent error: $e');
    } finally {
      isLoading(false);
    }
  }
}
