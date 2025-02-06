import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/content_model.dart';
import '../../../data/repositories/content_repository.dart';
import '../../../providers/user_provider.dart';
import '../../../data/models/user_model.dart'; // For SubscriptionTier

part 'content_provider.g.dart';

@riverpod
Future<List<SecretContent>> contentFeed(ContentFeedRef ref) async {
  final user = ref.watch(userProvider);
  final currentTier =
      user.value?.currentTier ?? SubscriptionTier.generalAdmission;
  final repo = ref.watch(contentRepositoryProvider);
  return repo.getContentForTier(currentTier);
}
