import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../features/models/comment_model.dart';

class InteractionsNotifier extends StateNotifier<void> {
  InteractionsNotifier() : super(null);
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> toggleLike(String postId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final likeRef = _firestore
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(userId);

      final postRef = _firestore.collection('posts').doc(postId);

      final likeDoc = await likeRef.get();
      final batch = _firestore.batch();

      if (likeDoc.exists) {
        // Unlike
        batch.delete(likeRef);
        batch.update(postRef, {'likesCount': FieldValue.increment(-1)});
      } else {
        // Like
        batch.set(likeRef, {
          'userId': userId,
          'createdAt': FieldValue.serverTimestamp(),
        });
        batch.update(postRef, {'likesCount': FieldValue.increment(1)});
      }

      await batch.commit();
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  Future<void> addComment(String postId, String content) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Get user data for the comment
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data();
      final userName = userData?['displayName'] ?? 'Anonymous';

      final commentRef = _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc();

      final postRef = _firestore.collection('posts').doc(postId);

      final batch = _firestore.batch();

      final comment = CommentModel(
        id: commentRef.id,
        postId: postId,
        authorId: userId,
        authorName: userName,
        content: content,
        createdAt: DateTime.now(),
      );

      batch.set(commentRef, comment.toJson());
      batch.update(postRef, {'commentsCount': FieldValue.increment(1)});

      await batch.commit();
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  Future<void> toggleSave(String postId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final savedRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_posts')
          .doc(postId);

      final savedDoc = await savedRef.get();

      if (savedDoc.exists) {
        // Unsave
        await savedRef.delete();
      } else {
        // Save
        await savedRef.set({
          'postId': postId,
          'savedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error toggling save: $e');
    }
  }

  Stream<bool> isLiked(String postId) {
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

  Stream<bool> isSaved(String postId) {
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

  Stream<List<CommentModel>> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                CommentModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }
}

final interactionsProvider =
    StateNotifierProvider<InteractionsNotifier, void>((ref) {
  return InteractionsNotifier();
});
