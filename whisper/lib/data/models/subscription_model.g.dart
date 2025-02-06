// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionImpl _$$SubscriptionImplFromJson(Map<String, dynamic> json) =>
    _$SubscriptionImpl(
      subscriptionId: json['subscriptionId'] as String,
      userId: json['userId'] as String,
      tier: $enumDecode(_$SubscriptionTierEnumMap, json['tier']),
      status: $enumDecode(_$SubscriptionStatusEnumMap, json['status']),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      paymentMethodId: json['paymentMethodId'] as String,
      stripeSubscriptionId: json['stripeSubscriptionId'] as String?,
      previousTier: json['previousTier'] as String?,
      discountCode: json['discountCode'] as String?,
      autoRenew: json['autoRenew'] as bool? ?? false,
      isTrial: json['isTrial'] as bool? ?? false,
      canceledAt: json['canceledAt'] == null
          ? null
          : DateTime.parse(json['canceledAt'] as String),
      reactivatedAt: json['reactivatedAt'] == null
          ? null
          : DateTime.parse(json['reactivatedAt'] as String),
      failedPaymentAttempts:
          (json['failedPaymentAttempts'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$SubscriptionImplToJson(_$SubscriptionImpl instance) =>
    <String, dynamic>{
      'subscriptionId': instance.subscriptionId,
      'userId': instance.userId,
      'tier': _$SubscriptionTierEnumMap[instance.tier]!,
      'status': _$SubscriptionStatusEnumMap[instance.status]!,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'amount': instance.amount,
      'currency': instance.currency,
      'paymentMethodId': instance.paymentMethodId,
      'stripeSubscriptionId': instance.stripeSubscriptionId,
      'previousTier': instance.previousTier,
      'discountCode': instance.discountCode,
      'autoRenew': instance.autoRenew,
      'isTrial': instance.isTrial,
      'canceledAt': instance.canceledAt?.toIso8601String(),
      'reactivatedAt': instance.reactivatedAt?.toIso8601String(),
      'failedPaymentAttempts': instance.failedPaymentAttempts,
    };

const _$SubscriptionTierEnumMap = {
  SubscriptionTier.generalAdmission: 'generalAdmission',
  SubscriptionTier.backstagePass: 'backstagePass',
  SubscriptionTier.innerCircle: 'innerCircle',
};

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.active: 'active',
  SubscriptionStatus.expired: 'expired',
  SubscriptionStatus.canceled: 'canceled',
  SubscriptionStatus.pendingPayment: 'pendingPayment',
  SubscriptionStatus.pastDue: 'pastDue',
  SubscriptionStatus.trialing: 'trialing',
  SubscriptionStatus.reactivated: 'reactivated',
};
