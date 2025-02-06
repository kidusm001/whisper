import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/push_notification.dart';
import '../data/repositories/push_notification_repository.dart';

part 'push_notification_provider.g.dart';

@riverpod
Stream<List<PushNotification>> userNotifications(
  UserNotificationsRef ref, {
  required String userId,
}) {
  final repo = ref.watch(pushNotificationRepositoryProvider);
  return repo.watchUserNotifications(userId);
}
