import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

Future<void> fixPostCounts() async {
  try {
    final users = await FirebaseFirestore.instance.collection('users').get();

    for (var user in users.docs) {
      final posts = await FirebaseFirestore.instance
          .collection('posts')
          .where('authorId', isEqualTo: user.id)
          .where('isDeleted', isEqualTo: false)
          .get();

      await user.reference.update({
        'postsCount': posts.docs.length,
      });

      debugPrint(
          'Updated post count for user ${user.id}: ${posts.docs.length}');
    }

    debugPrint('Finished updating post counts for all users');
  } catch (e) {
    debugPrint('Error fixing post counts: $e');
  }
}

Future<void> fixAllUsersPostCounts() async {
  final firestore = FirebaseFirestore.instance;
  final usersSnapshot = await firestore.collection('users').get();

  for (var userDoc in usersSnapshot.docs) {
    await fixUserPostCount(userDoc.id);
  }
}

Future<void> fixUserPostCount(String userId) async {
  final firestore = FirebaseFirestore.instance;

  try {
    // Get all non-deleted posts for the user
    final postsQuery = await firestore
        .collection('posts')
        .where('authorId', isEqualTo: userId)
        .where('isDeleted', isEqualTo: false)
        .get();

    final actualCount = postsQuery.docs.length;

    // Update user's post count with the actual count
    await firestore
        .collection('users')
        .doc(userId)
        .update({'postsCount': actualCount});

    debugPrint('Fixed post count for user $userId: $actualCount active posts');
  } catch (e) {
    debugPrint('Error fixing post count: $e');
  }
}
