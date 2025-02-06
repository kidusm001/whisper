import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/push_notification.dart';

part 'push_notification_repository.g.dart';

class PushNotificationRepository {
  final FirebaseFirestore _firestore;

  PushNotificationRepository(this._firestore);

  /// Sends (saves) a new push notification to the 'notifications' collection.
  Future<void> sendNotification(PushNotification notification) async {
    await _firestore
        .collection('notifications')
        .doc(notification.notificationId)
        .set(notification.toJson());
  }

  /// Streams all notifications for a given user, ordered by sent time (newest first).
  Stream<List<PushNotification>> watchUserNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('sentTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PushNotification.fromFirestore(doc))
            .toList());
  }
}

@riverpod
PushNotificationRepository pushNotificationRepository(
    PushNotificationRepositoryRef ref) {
  return PushNotificationRepository(FirebaseFirestore.instance);
}
