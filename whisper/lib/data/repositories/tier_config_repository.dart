import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/tier_config.dart';

part 'tier_config_repository.g.dart';

class TierConfigRepository {
  final FirebaseFirestore _firestore;

  TierConfigRepository(this._firestore);

  Stream<List<TierConfig>> watchAllTiers() {
    return _firestore.collection('tiers').orderBy('position').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => TierConfig.fromFirestore(doc)).toList());
  }

  Future<TierConfig> getTier(SubscriptionTier tier) async {
    final snapshot = await _firestore
        .collection('tiers')
        .where('tier', isEqualTo: tier.index)
        .limit(1)
        .get();

    return TierConfig.fromFirestore(snapshot.docs.first);
  }
}

@riverpod
TierConfigRepository tierConfigRepository(TierConfigRepositoryRef ref) {
  return TierConfigRepository(FirebaseFirestore.instance);
}
