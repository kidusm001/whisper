// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TierModel _$TierModelFromJson(Map<String, dynamic> json) => TierModel(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      benefits:
          (json['benefits'] as List<dynamic>).map((e) => e as String).toList(),
      subscriberCount: (json['subscriberCount'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: TierModel._timestampFromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$TierModelToJson(TierModel instance) => <String, dynamic>{
      'id': instance.id,
      'creatorId': instance.creatorId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'benefits': instance.benefits,
      'subscriberCount': instance.subscriberCount,
      'isActive': instance.isActive,
      'createdAt': TierModel._timestampToJson(instance.createdAt),
    };
