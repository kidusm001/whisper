import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/subscription_model.dart';

part 'subscription_repository.g.dart';

class SubscriptionRepository {
  final FirebaseFirestore _firestore;

  SubscriptionRepository(this._firestore);

  Future<void> createSubscription(Subscription subscription) async {
    await _firestore
        .collection('subscriptions')
        .doc(subscription.subscriptionId)
        .set(subscription.toJson());
  }

  Stream<Subscription> watchSubscription(String subscriptionId) {
    return _firestore
        .collection('subscriptions')
        .doc(subscriptionId)
        .snapshots()
        .map((doc) => Subscription.fromFirestore(doc));
  }

  Stream<List<Subscription>> watchUserSubscriptions(String userId) {
    return _firestore
        .collection('subscriptions')
        .where('userId', isEqualTo: userId)
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Subscription.fromFirestore(doc))
            .toList());
  }

  Future<void> updateSubscriptionStatus({
    required String subscriptionId,
    required SubscriptionStatus status,
  }) async {
    await _firestore.collection('subscriptions').doc(subscriptionId).update({
      'status': status.index,
      if (status == SubscriptionStatus.canceled) 'canceledAt': DateTime.now(),
      if (status == SubscriptionStatus.reactivated)
        'reactivatedAt': DateTime.now(),
    });
  }

  Future<void> handlePaymentSuccess(String subscriptionId) async {
    await _firestore.collection('subscriptions').doc(subscriptionId).update({
      'status': SubscriptionStatus.active.index,
      'failedPaymentAttempts': 0,
      'endDate': FieldValue.increment(30 * 24 * 60 * 60), // Add 30 days
    });
  }

  Future<void> handlePaymentFailure(String subscriptionId) async {
    await _firestore.collection('subscriptions').doc(subscriptionId).update({
      'status': SubscriptionStatus.pastDue.index,
      'failedPaymentAttempts': FieldValue.increment(1),
    });
  }
}

@riverpod
SubscriptionRepository subscriptionRepository(SubscriptionRepositoryRef ref) {
  return SubscriptionRepository(FirebaseFirestore.instance);
}
