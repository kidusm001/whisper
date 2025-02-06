import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/tier_config.dart';
import '../data/repositories/tier_config_repository.dart';

part 'tier_config_provider.g.dart';

@riverpod
Stream<List<TierConfig>> tierConfigs(TierConfigsRef ref) {
  return ref.watch(tierConfigRepositoryProvider).watchAllTiers();
}

@riverpod
Future<TierConfig> tierConfigByType(
    TierConfigByTypeRef ref, SubscriptionTier tier) {
  return ref.watch(tierConfigRepositoryProvider).getTier(tier);
}
