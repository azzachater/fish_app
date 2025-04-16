import 'package:get/get.dart';

class ForecastController extends GetxController {
  // Données observables
  final activeSpecies = 'Bass'.obs;
  final temperature = 115.obs;
  final moonPhase = 'Waxing Gibbous'.obs;
  final wave = 'Medium'.obs;
  final condition = 'Excellent'.obs;
  final currentTime = '6:00 PM'.obs;
  final probabilityData = <int>[30, 45, 75, 90, 60].obs;

  void updateForecast() {
    // Simulation de mise à jour des données
    temperature.value += 5;
    wave.value = temperature.value > 115 ? 'High' : 'Medium';
    condition.value = temperature.value > 120 ? 'Perfect' : 'Excellent';

    // Mise à jour des données du graphique
    probabilityData.value = [40, 55, 85, 95, 70];

    update();
  }
}
