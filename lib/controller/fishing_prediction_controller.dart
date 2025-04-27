/*import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../service/ia/weather_service.dart';
import '../service/ia/api_service.dart';
import '../models/spot.dart';

class FishingPredictionController extends GetxController {
  final WeatherService weatherService = WeatherService();
  final ApiService apiService = ApiService();

  var selectedLat = 0.0.obs;
  var selectedLng = 0.0.obs;
  var currentWeather = <String, dynamic>{}.obs;
  var forecast = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var predictionResult = "".obs;
  var recommendedSpots = <Spot>[].obs;
  Timer? liveFishingTimer;
  var liveFishingStatus = "".obs;

// bech ki ysokhel lel page toul yal9a l meteo mtaa location actuelle mta3ou
  @override
  void onInit() {
    super.onInit();
    _initLocationAndWeather();
  }

  Future<void> _initLocationAndWeather() async {
    try {
      // 1) on demande la position actuelle
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      // 2) on met à jour la position + charge la météo
      await updateUserPosition(LatLng(pos.latitude, pos.longitude));
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible d’obtenir la position : $e');
    }
  }

  Future<void> updateUserPosition(LatLng newPosition) async {
    selectedLat.value = newPosition.latitude;
    selectedLng.value = newPosition.longitude;
    await fetchWeather(newPosition.latitude, newPosition.longitude);
  }

  Future<void> fetchWeather(double lat, double lng) async {
    try {
      isLoading(true);
      currentWeather.value = await weatherService.getCurrentWeather(lat, lng);
      forecast.value = await weatherService.get7DayForecast(lat, lng);
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger la météo');
    } finally {
      isLoading(false);
    }
  }

  Future<void> predictFishingTime() async {
    try {
      isLoading(true);
      final prediction = await apiService.predictFishingTime(
        currentWeather['temperature'],
        currentWeather['wind'],
        currentWeather['humidity'],
      );
      if (prediction['good_time']) {
        predictionResult.value = "✅ Bon moment pour pêcher !";
        recommendedSpots.value =
            await apiService.getRecommendedSpots(selectedLat.value, selectedLng.value);
      } else {
        predictionResult.value = "❌ Conditions non optimales";
        recommendedSpots.clear();
      }
    } catch (e) {
      predictionResult.value = "Erreur lors de la prédiction";
      Get.snackbar('Erreur', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void startLiveFishing() {
    stopLiveFishing();
    liveFishingTimer = Timer.periodic(Duration(seconds: 10), (_) async {
      try {
        final weather = await weatherService.getCurrentWeather(
          selectedLat.value,
          selectedLng.value,
        );
        currentWeather.value = weather;
        final prediction = await apiService.predictFishingTime(
          weather['temperature'],
          weather['wind'],
          weather['humidity'],
        );
        liveFishingStatus.value = prediction['good_time']
            ? "🎣 Bonne zone de pêche actuellement !"
            : "⚠️ Conditions météo défavorables !";
      } catch (e) {
        liveFishingStatus.value = "Erreur lors de la mise à jour live.";
      }
    });
  }

  void stopLiveFishing() {
    liveFishingTimer?.cancel();
    liveFishingTimer = null;
    liveFishingStatus.value = "";
  }
}
*/