import 'package:fish_app/controllers/post_controller.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/api_user_service.dart';

class UserController extends GetxController {
  final ApiUserService _apiUserService = ApiUserService();
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxList<User> allUsers = <User>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentUser();
  }

  Future<void> fetchCurrentUser() async {
  try {
    isLoading(true);
    error('');
    
    final user = await _apiUserService.getCurrentUser();
    currentUser.value = user;
    // ✅ Ajoute cette ligne ici :
final postController = Get.put(PostController());
postController.currentUserId = user.id.toString();
    print('✅ Current user fetched: ${user.toJson()}');
  } catch (e) {
    error(e.toString());
    print('❌ Error fetching user: $e');
    
    if (e.toString().contains('401')) {
      Get.offAllNamed('/login');
    } else {
      Get.snackbar('Error', 'Failed to fetch user data',
          snackPosition: SnackPosition.BOTTOM);
    }
  } finally {
    isLoading(false);
  }
}


  Future<void> fetchAllUsers() async {
    try {
      isLoading(true);
      error('');
      final users = await _apiUserService.getAllUsers();
      allUsers.assignAll(users);
    } catch (e) {
      error(e.toString());
      Get.snackbar('Erreur', error.value,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<User?> checkUser(String id) async {
  try {
    isLoading(true);
    error('');
    final user = await _apiUserService.checkUser(id);
    return user;
  } catch (e) {
    error(e.toString());
    Get.snackbar('Erreur', error.value,
        snackPosition: SnackPosition.BOTTOM);
    return null;
  } finally {
    isLoading(false);
  }
}

}