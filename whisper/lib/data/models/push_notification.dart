import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_notification.freezed.dart';
part 'push_notification.g.dart';

@freezed
class PushNotification with _$PushNotification {
  /// The main constructor for a push notification.
  const factory PushNotification({
    required String notificationId,
    required String userId,
    required String title,
    required String body,
    required DateTime sentTime,
  }) = _PushNotification;

  /// Creates a [PushNotification] instance from Firestore document data.
  factory PushNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PushNotification.fromJson({
      ...data,
      'notificationId': doc.id,
      // Convert Firestore Timestamp to ISO8601 string
      'sentTime': (data['sentTime'] as Timestamp).toDate().toIso8601String(),
    });
  }

  /// JSON deserialization.
  factory PushNotification.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationFromJson(json);
}
