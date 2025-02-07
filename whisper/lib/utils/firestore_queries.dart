import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreQueries {
  // Match exactly how ProfileScreen queries posts
  static Query<Map<String, dynamic>> getExplorePosts() {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true);
  }

  static Query<Map<String, dynamic>> getUserPosts(String userId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('authorId', isEqualTo: userId)
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true);
  }
}
