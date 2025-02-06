import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

part 'user_repository.g.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  Future<AppUser> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return AppUser.fromFirestore(doc);
  }

  Stream<AppUser> watchUser(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) => AppUser.fromFirestore(snapshot));
  }

  Future<void> updateUser(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toJson());
  }

  Future<void> upgradeToCreator(String uid) async {
    await _firestore.collection('users').doc(uid).update({
      'role': UserRole.creator.index,
      'verificationStatus': VerificationStatus.pending.index,
      'earnings': {
        'totalEarnings': 0.0,
        'availableBalance': 0.0,
        'payoutHistory': [],
        'subscriberCounts': {}
      }
    });
  }

  Future<void> updateTier(String uid, SubscriptionTier tier) async {
    await _firestore.collection('users').doc(uid).update({
      'currentTier': tier.index,
      'tierExpiry': DateTime.now().add(const Duration(days: 30))
    });
  }
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepository(FirebaseFirestore.instance);
}
