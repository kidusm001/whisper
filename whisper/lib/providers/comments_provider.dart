import 'package:flutter/foundation.dart'; // Add this import for debugPrint
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../features/models/comment_model.dart';

class CommentsNotifier extends StateNotifier<Map<String, List<CommentModel>>> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CommentsNotifier({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        super({});

  Future<void> addComment(CommentModel comment) async {
    try {
      final batch = _firestore.batch();

      // Add comment
      final commentRef = _firestore.collection('comments').doc(comment.id);
      batch.set(commentRef, comment.toJson());

      // Update post comment count
      final postRef = _firestore.collection('posts').doc(comment.postId);
      batch.update(postRef, {'commentCount': FieldValue.increment(1)});

      await batch.commit();

      final currentComments = state[comment.postId] ?? [];
      state = {
        ...state,
        comment.postId: [comment, ...currentComments],
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addReply(CommentModel parentComment, CommentModel reply) async {
    try {
      final batch = _firestore.batch();

      // Add reply as a regular comment with proper parent reference
      final replyRef = _firestore.collection('comments').doc(reply.id);
      batch.set(replyRef, {
        ...reply.toJson(),
        'parentId': parentComment.id,
        'replyToId': parentComment.authorId,
        'replyToName': parentComment.authorName,
      });

      // Update parent comment's reply count
      final parentRef = _firestore.collection('comments').doc(parentComment.id);
      batch.update(parentRef, {'replyCount': FieldValue.increment(1)});

      await batch.commit();

      // Update local state
      final currentComments = state[reply.postId] ?? [];
      state = {
        ...state,
        reply.postId: [reply, ...currentComments],
      };
    } catch (e) {
      debugPrint('Error adding reply: $e');
      rethrow;
    }
  }

  Future<void> toggleLike(String commentId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      final commentRef = _firestore.collection('comments').doc(commentId);
      final doc = await commentRef.get();

      if (!doc.exists) return;

      final data = doc.data()!;
      final likedBy = List<String>.from(data['likedBy'] ?? []);
      final isLiked = likedBy.contains(userId);

      await commentRef.update({
        'likesCount': FieldValue.increment(isLiked ? -1 : 1),
        'likedBy': isLiked
            ? FieldValue.arrayRemove([userId])
            : FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadCommentsForPost(String postId) async {
    try {
      final snapshot = await _firestore
          .collection('comments')
          .where('postId', isEqualTo: postId)
          .orderBy('createdAt', descending: true)
          .get();

      final comments = snapshot.docs
          .map((doc) => CommentModel.fromJson(doc.data()))
          .toList();

      state = {
        ...state,
        postId: comments,
      };
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  List<CommentModel> getCommentsForPost(String postId) {
    return state[postId] ?? [];
  }

  Stream<List<CommentModel>> streamCommentsForPost(String postId) {
    try {
      // Simplified query - only filter by postId
      return _firestore
          .collection('comments')
          .where('postId', isEqualTo: postId)
          .snapshots()
          .map((snapshot) {
        var comments = snapshot.docs
            .map((doc) => CommentModel.fromJson(doc.data()))
            .toList();

        // Sort in memory instead of using orderBy
        comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        // Update state
        state = {...state, postId: comments};

        return comments;
      });
    } catch (e) {
      debugPrint('Error setting up comments stream: $e');
      return Stream.value([]);
    }
  }

  Stream<List<CommentModel>> streamRepliesForComment(String commentId) {
    try {
      return _firestore
          .collection('comments')
          .where('parentId', isEqualTo: commentId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => CommentModel.fromJson(doc.data()))
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
    } catch (e) {
      debugPrint('Error loading replies: $e');
      return Stream.value([]);
    }
  }
}

final commentsProvider =
    StateNotifierProvider<CommentsNotifier, Map<String, List<CommentModel>>>(
  (ref) => CommentsNotifier(),
);

final commentsStreamProvider =
    StreamProvider.family<List<CommentModel>, String>((ref, postId) {
  return ref.read(commentsProvider.notifier).streamCommentsForPost(postId);
});

final commentRepliesProvider =
    StreamProvider.family<List<CommentModel>, String>((ref, commentId) {
  return ref.read(commentsProvider.notifier).streamRepliesForComment(commentId);
});
