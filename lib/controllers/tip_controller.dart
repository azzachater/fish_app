import 'package:get/get.dart';
import '../models/tip_model.dart';
import '../services/tip_api_service.dart';

class TipController extends GetxController {
  final RxList<Tip> tips = <Tip>[].obs;
  final ApiTipService _apiService = ApiTipService();
  final RxString error = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTips();
  }

  Future<void> fetchTips() async {
    try {
      isLoading.value = true;
      error.value = "";
      final fetchedTips = await _apiService.getTips();
      tips.value = fetchedTips;
    } catch (e) {
      print("error fetching tips: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createTip(String title, String description) async {
    try {
      isLoading.value = true;
      error.value = "";
      final newTip = await _apiService.createTip(title, description);
      tips.insert(0, newTip);
      await fetchTips();
    } catch (e) {
      print("error creating tip: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> addTip(Tip tip) async {
  try {
    isLoading.value = true;
    error.value = "";
    final newTip = await _apiService.createTip(tip.title, tip.description);
    tips.insert(0, newTip);
    await fetchTips();
  } catch (e) {
    print("error adding tip: $e");
    error.value = e.toString();
  } finally {
    isLoading.value = false;
  }
}


  Future<void> updateTip(Tip tip) async {
    try {
      isLoading.value = true;
      error.value = "";
      print("Tip ID before update: ${tip.id}");
      if (tip.id == null || tip.id!.isEmpty) {
      throw Exception("Tip ID is null or empty!");
    }
      final updatedTip = await _apiService.updateTip(tip);
      final index = tips.indexWhere((t) => t.id == updatedTip.id);
      if (index != -1) {
        tips[index] = updatedTip;
        tips.refresh();
      }
    } catch (e) {
      print("error updating tip: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTip(String id) async {
    try {
      isLoading.value = true;
      error.value = "";
      await _apiService.deleteTip(id);
      tips.removeWhere((tip) => tip.id == id);
    } catch (e) {
      print("error deleting tip: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

}