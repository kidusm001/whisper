import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/content_model.dart';
import '../models/user_model.dart';

part 'content_repository.g.dart';

class ContentRepository {
  final FirebaseFirestore _firestore;

  ContentRepository(this._firestore);

  Future<void> createContent(SecretContent content) async {
    await _firestore
        .collection('content')
        .doc(content.contentId)
        .set(content.toJson());
  }

  Stream<List<SecretContent>> getContentForUser({
    required String userId,
    required SubscriptionTier tier,
  }) {
    return _firestore
        .collection('content')
        .where('tierAccess.${tier.name}', isEqualTo: true)
        .orderBy('publishDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SecretContent.fromFirestore(doc))
            .toList());
  }

  Future<List<SecretContent>> getContentForTier(SubscriptionTier tier) async {
    final snapshot = await _firestore
        .collection('content')
        .where('tierAccess.${tier.name}', isEqualTo: true)
        .orderBy('publishDate', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => SecretContent.fromFirestore(doc))
        .toList();
  }

  Future<void> incrementViewCount(String contentId) async {
    await _firestore
        .collection('content')
        .doc(contentId)
        .update({'viewCount': FieldValue.increment(1)});
  }

  Future<void> deleteExpiredContent() async {
    final query = _firestore
        .collection('content')
        .where('expirationDate', isLessThan: DateTime.now());

    final batch = _firestore.batch();
    final snapshots = await query.get();

    for (final doc in snapshots.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}

@riverpod
ContentRepository contentRepository(ContentRepositoryRef ref) {
  return ContentRepository(FirebaseFirestore.instance);
}
