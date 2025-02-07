import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> fixAllUsersPostCounts() async {
  final firestore = FirebaseFirestore.instance;
  final usersSnapshot = await firestore.collection('users').get();

  for (var userDoc in usersSnapshot.docs) {
    final postsCount = await firestore
        .collection('posts')
        .where('authorId', isEqualTo: userDoc.id)
        .count()
        .get();

    await userDoc.reference.update({'postsCount': postsCount.count});
  }
}
