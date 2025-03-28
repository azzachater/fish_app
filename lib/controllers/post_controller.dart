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
  List<Post> getUserPosts(int userId) {
    return posts.where((post) => post.user.id == userId).toList();
  }

  // Méthode pour activer/désactiver le like
  void toggleLike() {
    isLiked.value = !isLiked.value;
    likeCount.value = isLiked.value ? likeCount.value + 1 : likeCount.value - 1;
  }

  // Méthode pour supprimer un post
  void deletePost(Post post) {
    posts.remove(post);
    posts.refresh();
  }

  // Méthode pour mettre à jour un post
  void updatePost(Post post, String newText, String updatedImagePath) {
  int index = posts.indexWhere((p) => p.id == post.id); // Vérifier l'ID au lieu d'utiliser directement l'objet
  if (index != -1) {
    posts[index].postText = newText;
    if (updatedImagePath.isNotEmpty) {
      posts[index].postImage = updatedImagePath; // Mettre à jour l'image si un nouveau chemin est fourni
    }
    posts.refresh(); // Rafraîchir la liste des posts pour refléter les changements
  }
}

}
