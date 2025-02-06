import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tier_config.freezed.dart';
part 'tier_config.g.dart';

@freezed
class TierConfig with _$TierConfig {
  factory TierConfig({
    required String tierId,
    required SubscriptionTier tier,
    required double monthlyPrice,
    required String title,
    required String description,
    required List<String> benefits,
    required Map<String, dynamic> permissions,
    @Default(false) bool isFeatured,
    String? badgeColor,
    String? iconName,
    @Default(0) int position,
  }) = _TierConfig;

  factory TierConfig.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TierConfig.fromJson(data).copyWith(tierId: doc.id);
  }

  factory TierConfig.fromJson(Map<String, dynamic> json) =>
      _$TierConfigFromJson(json);
}

enum SubscriptionTier { generalAdmission, backstagePass, innerCircle }
