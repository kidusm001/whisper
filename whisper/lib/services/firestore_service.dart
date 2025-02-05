import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:riverpod/riverpod.dart';
import '../models/post_model.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

class FirestoreService {
  static const String _postsKey = 'posts';
  late final SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<PostModel>> getPostsForUser(
      String userId, String subscriptionTier) async {
    final postsJson = _prefs.getStringList(_postsKey) ?? [];
    return postsJson
        .map((json) => PostModel.fromJson(jsonDecode(json)))
        .where((post) => post.canAccess(subscriptionTier))
        .toList();
  }

  Future<void> createPost(PostModel post) async {
    final posts = _prefs.getStringList(_postsKey) ?? [];
    posts.add(jsonEncode(post.toJson()));
    await _prefs.setStringList(_postsKey, posts);
  }

  Future<void> toggleLike(String postId, String userId) async {
    final posts = _prefs.getStringList(_postsKey) ?? [];
    final updatedPosts = posts.map((json) {
      final post = PostModel.fromJson(jsonDecode(json));
      if (post.id == postId) {
        final likes = List<String>.from(post.likes);
        if (likes.contains(userId)) {
          likes.remove(userId);
        } else {
          likes.add(userId);
        }
        return jsonEncode(post.copyWith(likes: likes).toJson());
      }
      return json;
    }).toList();
    await _prefs.setStringList(_postsKey, updatedPosts);
  }
}
