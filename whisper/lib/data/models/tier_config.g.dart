// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tier_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TierConfigImpl _$$TierConfigImplFromJson(Map<String, dynamic> json) =>
    _$TierConfigImpl(
      tierId: json['tierId'] as String,
      tier: $enumDecode(_$SubscriptionTierEnumMap, json['tier']),
      monthlyPrice: (json['monthlyPrice'] as num).toDouble(),
      title: json['title'] as String,
      description: json['description'] as String,
      benefits:
          (json['benefits'] as List<dynamic>).map((e) => e as String).toList(),
      permissions: json['permissions'] as Map<String, dynamic>,
      isFeatured: json['isFeatured'] as bool? ?? false,
      badgeColor: json['badgeColor'] as String?,
      iconName: json['iconName'] as String?,
      position: (json['position'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TierConfigImplToJson(_$TierConfigImpl instance) =>
    <String, dynamic>{
      'tierId': instance.tierId,
      'tier': _$SubscriptionTierEnumMap[instance.tier]!,
      'monthlyPrice': instance.monthlyPrice,
      'title': instance.title,
      'description': instance.description,
      'benefits': instance.benefits,
      'permissions': instance.permissions,
      'isFeatured': instance.isFeatured,
      'badgeColor': instance.badgeColor,
      'iconName': instance.iconName,
      'position': instance.position,
    };

const _$SubscriptionTierEnumMap = {
  SubscriptionTier.generalAdmission: 'generalAdmission',
  SubscriptionTier.backstagePass: 'backstagePass',
  SubscriptionTier.innerCircle: 'innerCircle',
};
