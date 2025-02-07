import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../features/models/comment_model.dart';

class PostInteractionsNotifier extends StateNotifier<void> {
  PostInteractionsNotifier() : super(null);
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Like a post
  Future<void> toggleLike(String postId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userName = userDoc.data()?['displayName'] ?? 'Anonymous';

      final likeRef = _firestore
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(userId);

      final postRef = _firestore.collection('posts').doc(postId);

      final batch = _firestore.batch();
      final likeDoc = await likeRef.get();

      if (likeDoc.exists) {
        // Unlike
        batch.delete(likeRef);
        batch.update(postRef, {
          'likesCount': FieldValue.increment(-1),
        });
      } else {
        // Like
        batch.set(likeRef, {
          'userId': userId,
          'userName': userName,
          'createdAt': FieldValue.serverTimestamp(),
        });
        batch.update(postRef, {
          'likesCount': FieldValue.increment(1),
        });
      }

      await batch.commit();
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  // Add a comment
  Future<void> addComment(String postId, String content) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userName = userDoc.data()?['displayName'] ?? 'Anonymous';

      final commentRef = _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc();

      final postRef = _firestore.collection('posts').doc(postId);

      final batch = _firestore.batch();

      final comment = {
        'id': commentRef.id,
        'postId': postId,
        'authorId': userId,
        'authorName': userName,
        'content': content,
        'createdAt': FieldValue.serverTimestamp(),
        'likesCount': 0
      };

      batch.set(commentRef, comment);
      batch.update(postRef, {
        'commentsCount': FieldValue.increment(1),
      });

      await batch.commit();
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  // Save a post
  Future<void> toggleSavePost(String postId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final savedRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_posts')
          .doc(postId);

      final savedDoc = await savedRef.get();
      final postDoc = await _firestore.collection('posts').doc(postId).get();

      if (savedDoc.exists) {
        // Unsave
        await savedRef.delete();
      } else {
        // Save
        await savedRef.set({
          'postId': postId,
          'savedAt': FieldValue.serverTimestamp(),
          'postData': postDoc.data(), // Store post data for quick access
        });
      }
    } catch (e) {
      print('Error toggling save: $e');
    }
  }

  // Get likes for a post
  Stream<QuerySnapshot> getLikes(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get comments for a post
  Stream<QuerySnapshot> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Check if user liked a post
  Stream<bool> hasUserLiked(String postId) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value(false);

    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  // Check if user saved a post
  Stream<bool> hasUserSaved(String postId) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value(false);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_posts')
        .doc(postId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  // Get saved posts for current user
  Stream<QuerySnapshot> getSavedPosts() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_posts')
        .orderBy('savedAt', descending: true)
        .snapshots();
  }
}

final postInteractionsProvider =
    StateNotifierProvider<PostInteractionsNotifier, void>((ref) {
  return PostInteractionsNotifier();
});
