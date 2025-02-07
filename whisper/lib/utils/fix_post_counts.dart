import 'package:cloud_firestore/cloud_firestore.dart';

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

    print('Fixed post count for user $userId: $actualCount active posts');
  } catch (e) {
    print('Error fixing post count: $e');
  }
}
