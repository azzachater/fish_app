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
      print("✅ Posts received: ${fetchedPosts.length}");
      
      for (var post in fetchedPosts) {
        print("📌 Post ID: ${post.id}");
        print("👤 User: ${post.user.name}");
        print("🖼️ Avatar: ${post.user.avatar}");
      }
      
      posts.value = fetchedPosts;
    } catch (e) {
      print("❌ Error: $e");
      error.value = "Unable to load posts";
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
        await fetchPosts(); // Fetch updated posts
      } else {
        throw Exception("Post created, but ID is empty.");
      }
    } catch (e) {
      print("Error creating post: $e");
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
        await fetchPosts(); // Fetch updated posts
      }
    } catch (e) {
      print("Error updating post: $e");
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
      print("Error deleting post: $e");
      error.value = e.toString();
    }
  }

  // Method to get posts for a specific user
  List<Post> getUserPosts(int userId) {
    return posts.where((post) => post.user.id == userId).toList();
  }

  String currentUserId = ''; // Current user ID to filter posts

  List<Post> getCurrentUserPosts() {
    if (currentUserId.isEmpty) return [];
    return posts.where((post) => post.user.id.toString() == currentUserId).toList();
  }

  Future<void> likePost(String postId) async {
    try {
  final updatedPost = await _apiPostService.likePost(postId);
  if (updatedPost != null) {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      posts[index] = updatedPost;
      posts.refresh();
    }
  } else {
    throw Exception("Post not found on server");
  }
} catch (e) {
  print("❌ Error liking post: $e");
  error.value = e.toString();
}
  }
}