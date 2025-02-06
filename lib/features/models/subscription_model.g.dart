// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      subscriberId: json['subscriberId'] as String,
      tierId: json['tierId'] as String,
      amount: (json['amount'] as num).toDouble(),
      startDate:
          SubscriptionModel._timestampFromJson(json['startDate'] as Timestamp?),
      endDate:
          SubscriptionModel._timestampFromJson(json['endDate'] as Timestamp?),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creatorId': instance.creatorId,
      'subscriberId': instance.subscriberId,
      'tierId': instance.tierId,
      'amount': instance.amount,
      'isActive': instance.isActive,
      'startDate': SubscriptionModel._timestampToJson(instance.startDate),
      'endDate': SubscriptionModel._timestampToJson(instance.endDate),
    };
