// File: social_service.dart
// Description: Service for handling social features

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase/supabase.dart' hide Storage;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/comment_model.dart';
import '../models/follow_model.dart';
import '../models/like_model.dart';

class SocialService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final supabase = SupabaseClient(
    'https://ljwwgbouaqnejyatmkye.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxqd3dnYm91YXFuZWp5YXRta3llIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3OTY4NzcsImV4cCI6MjA1NDM3Mjg3N30.j2cj4kDZj53exoS2bVmb36IQgWnmSNAPtlyH2f_nk7k',
  );

  Future<bool> followUser(String currentUserId, String targetUserId) async {
    try {
      // TODO: Implement follow logic with Firebase/Supabase
      return true;
    } catch (e) {
      print('Error following user: $e');
      return false;
    }
  }

  Future<bool> unfollowUser(String currentUserId, String targetUserId) async {
    try {
      // TODO: Implement unfollow logic with Firebase/Supabase
      return true;
    } catch (e) {
      print('Error unfollowing user: $e');
      return false;
    }
  }

  Future<bool> likePost(String postId, String userId) async {
    try {
      // Use Supabase to insert a like
      await supabase.from('likes').insert([
        {'post_id': postId, 'user_id': userId}
      ]);
      return true;
    } catch (e) {
      print('Error liking post: $e');
      return false;
    }
  }

  Future<bool> unlikePost(String postId, String userId) async {
    try {
      // Use Supabase to delete a like
      await supabase
          .from('likes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', userId);
      return true;
    } catch (e) {
      print('Error unliking post: $e');
      return false;
    }
  }

  Future<bool> createComment(
      String postId, String userId, String content) async {
    try {
      final comment = CommentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postId: postId,
        authorId: userId,
        content: content,
        createdAt: DateTime.now(),
      );
      await supabase.from('comments').insert([comment.toJson()]);
      return true;
    } catch (e) {
      print('Error creating comment: $e');
      return false;
    }
  }

  Stream<List<LikeModel>> getPostLikes(String postId) {
    return _firestore
        .collection('likes')
        .where('post_id', isEqualTo: postId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => LikeModel.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<List<CommentModel>> getPostComments(String postId) {
    return supabase
        .from('comments')
        .select('*')
        .eq('post_id', postId)
        .order('timestamp', ascending: false)
        .then((response) {
      final List<dynamic> data =
          (response as PostgrestResponse).data as List<dynamic>;
      return data.map((comment) => CommentModel.fromJson(comment)).toList();
    }).asStream();
  }

  Stream<List<FollowModel>> getUserFollowers(String userId) {
    return supabase
        .from('follows')
        .select('*')
        .eq('follow_user_id', userId)
        .then((response) {
      final List<dynamic> data =
          (response as PostgrestResponse).data as List<dynamic>;
      return data.map((follow) => FollowModel.fromJson(follow)).toList();
    }).asStream();
  }

  Stream<List<FollowModel>> getUserFollowing(String userId) {
    return supabase
        .from('follows')
        .select('*')
        .eq('user_id', userId)
        .then((response) {
      final List<dynamic> data =
          (response as PostgrestResponse).data as List<dynamic>;
      return data.map((follow) => FollowModel.fromJson(follow)).toList();
    }).asStream();
  }
}
