import 'package:get/get.dart';
import 'package:fish_app/models/event.dart';

class EventController extends GetxController {
  var events = <Event>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Ajouter des événements par défaut
    addDefaultEvents();
  }

  // Méthode pour ajouter des événements par défaut
  void addDefaultEvents() {
    events.addAll([
      Event(
        title: 'Pêche au matin',
        date: '2025-03-28',
        location: 'Lac de Tunis',
        description: 'Un événement pour tous les passionnés.',
        participants: ['Alice', 'Bob'],
      ),
      Event(
        title: 'Compétition de pêche',
        date: '2025-04-05',
        location: 'Plage de Hammamet',
        description: 'Venez participer à une compétition excitante.',
        participants: ['Jean', 'Sarah'],
      ),
      Event(
        title: 'Sortie pêche relax',
        date: '2025-04-10',
        location: 'Île de Djerba',
        description: 'Détente et pêche entre amis.',
        participants: ['Marc', 'Chloé'],
      ),
    ]);
  }

  void joinEvent(int index, String user) {
    events[index].participants.add(user);
    events.refresh(); // Mise à jour UI
  }

  void addEvent(
    String title,
    String location,
    String description,
    String date,
  ) {
    Event newEvent = Event(
      title: title,
      location: location,
      description: description,
      date: date,
      participants: [],
    );
    events.add(newEvent);
  }
}
