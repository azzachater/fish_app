import 'package:get/get.dart';
import '../../models/post_model.dart';
import '../../data/post_data.dart'; // Assurez-vous que postsData est bien importé

class PostController extends GetxController {
  var posts = <Post>[].obs;  // Liste réactive des posts
  var isLiked = false.obs;
  var likeCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadPosts();  // Charger les posts au démarrage
  }
  // Méthode pour charger les posts depuis le fichier de données
  void loadPosts() {
    posts.assignAll(postsData);  // Remplir la liste avec les posts
  }

  // Méthode pour ajouter un post
 void addPost(Post post) {
  posts.add(post);
  posts.refresh(); // Forcer la mise à jour des posts dans l'interface
}


  // Méthode pour obtenir les posts d'un utilisateur donné
   // Méthode pour obtenir les posts d'un utilisateur donné
  List<Post> getUserPosts(int userId) {
    return posts.where((post) => post.user.id == userId).toList();
  }

  // Méthode pour activer/désactiver le like
  void toggleLike() {
    isLiked.value = !isLiked.value;
    likeCount.value = isLiked.value ? likeCount.value + 1 : likeCount.value - 1;
  }
}
