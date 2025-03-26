import 'package:get/get.dart';
import '../../data/user_data.dart'; // Supposons que ça contient currentUser
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  // Utilisateur observable
  var user = currentUser.obs;

  // Met à jour la photo de profil
  void updateProfilePicture() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    user.update((val) {
      if (val != null) {
        val.avatar = pickedFile.path;
      }
    });
  }
}

}
