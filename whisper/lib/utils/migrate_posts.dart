import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> migrateExistingPosts() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final firestore = FirebaseFirestore.instance;
  final posts = await firestore
      .collection('posts')
      .where('authorId', isEqualTo: user.uid)
      .get();

  if (posts.docs.isEmpty) return;

  final batch = firestore.batch();

  for (var doc in posts.docs) {
    final data = doc.data();
    if (!data.containsKey('isDeleted')) {
      batch.update(doc.reference, {
        'isDeleted': false,
        'createdAt': data['createdAt'] ?? FieldValue.serverTimestamp(),
      });
    }
  }

  try {
    await batch.commit();
    print('Migration completed successfully');
  } catch (e) {
    print('Migration failed: $e');
  }
}
