import 'package:get/get.dart';
import '../../models/post_model.dart';
import '../../services/api_post_service.dart'; // Import the ApiPostService

class PostController extends GetxController {
  final RxList<Post> posts = <Post>[].obs;
  final ApiPostService _apiPostService = ApiPostService();
  final RxString error = ''.obs;
  final RxBool isLoading = false.obs;
  var isLiked = false.obs;
  var likeCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();  // Load posts when the controller is initialized
  }

  Future<void> fetchPosts() async {
  try {
    isLoading.value = true;
    final fetchedPosts = await _apiPostService.getPosts();
    print("✅ Posts reçus : ${fetchedPosts.length}");
    
    for (var post in fetchedPosts) {
      print("📌 Post ID: ${post.id}");
      print("👤 User: ${post.user.name}");
      print("🖼️ Avatar: ${post.user.avatar}");
    }
    
    posts.value = fetchedPosts;
  } catch (e) {
    print("❌ Erreur: $e");
    error.value = "Impossible de charger les posts";
  } finally {
    isLoading.value = false;
  }
}

  Future<void> createPost(String postText, String postImage) async {
  try {
    isLoading.value = true;
    error.value = "";
    final newPost = await _apiPostService.createPost(postText, postImage);

    if (newPost.id.isNotEmpty) {
      posts.insert(0, newPost);
      posts.refresh();
      await fetchPosts(); // Récupérer la liste des posts mise à jour
    } else {
      throw Exception("Post créé mais ID vide.");
    }
  } catch (e) {
    print("error creating post: $e");
    error.value = e.toString();
  }
}


  Future<void> updatePost(Post post) async {
    try {
      isLoading.value = true;
      error.value = "";
      if (post.id == null || post.id!.isEmpty) {
        throw Exception("Post ID is null or empty!");
      }
      final updatedPost = await _apiPostService.updatePost(post);
      final index = posts.indexWhere((t) => t.id == updatedPost.id);
      if (index != -1) {
        posts[index] = updatedPost;
        posts.refresh();
        await fetchPosts(); // Récupérer la liste des posts mise à jour
      }
    } catch (e) {
      print("error updating post: $e");
      error.value = e.toString();
    } 
  }

  Future<void> deletePost(String id) async {
    try {
      isLoading.value = true;
      error.value = "";
      await _apiPostService.deletePost(id);
      posts.removeWhere((post) => post.id == id);
    } catch (e) {
      print("error deleting post: $e");
      error.value = e.toString();
    }
  }

  void toggleLike() {
    isLiked.value = !isLiked.value;
    likeCount.value = isLiked.value ? likeCount.value + 1 : likeCount.value - 1;
  }


/// Method to get posts for a specific user
  List<Post> getUserPosts(int userId) {
    return posts.where((post) => post.user.id == userId).toList();
  }
  
}
