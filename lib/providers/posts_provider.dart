import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostsNotifier extends StateNotifier<List<PostModel>> {
  PostsNotifier() : super([]) {
    _initPosts();
  }

  final _firestore = FirebaseFirestore.instance;

  Future<void> _initPosts() async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();

      final posts =
          snapshot.docs.map((doc) => PostModel.fromJson(doc.data())).toList();

      state = posts;
    } catch (e) {
      print('Error initializing posts: $e');
    }
  }

  Future<void> addPost(PostModel post) async {
    try {
      await _firestore.collection('posts').doc(post.id).set(post.toJson());
      state = [post, ...state];
    } catch (e) {
      print('Error adding post: $e');
    }
  }

  Future<void> updatePost(PostModel post) async {
    try {
      await _firestore.collection('posts').doc(post.id).update(post.toJson());
      state = state.map((p) => p.id == post.id ? post : p).toList();
    } catch (e) {
      print('Error updating post: $e');
    }
  }

  Future<void> removePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
      state = state.where((post) => post.id != postId).toList();
    } catch (e) {
      print('Error removing post: $e');
    }
  }

  List<PostModel> getPostsByAuthor(String authorId) {
    return state.where((post) => post.authorId == authorId).toList();
  }
}

final postsProvider =
    StateNotifierProvider<PostsNotifier, List<PostModel>>((ref) {
  return PostsNotifier();
});
