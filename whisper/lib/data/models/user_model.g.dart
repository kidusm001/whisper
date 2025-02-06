// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(Map<String, dynamic> json) =>
    _$AppUserImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      role:
          $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.fan,
      currentTier:
          $enumDecodeNullable(_$SubscriptionTierEnumMap, json['currentTier']) ??
              SubscriptionTier.generalAdmission,
      tierExpiry: json['tierExpiry'] == null
          ? null
          : DateTime.parse(json['tierExpiry'] as String),
      profileImageUrl: json['profileImageUrl'] as String?,
      accessibleContentIds: (json['accessibleContentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      interactionCredits: (json['interactionCredits'] as Map<String, dynamic>?)
              ?.map(
            (k, e) => MapEntry(
                $enumDecode(_$InteractionTypeEnumMap, k), (e as num).toInt()),
          ) ??
          const {},
      trustedDevices: (json['trustedDevices'] as List<dynamic>?)
              ?.map((e) => DeviceInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      earnings: json['earnings'] == null
          ? null
          : CreatorEarnings.fromJson(json['earnings'] as Map<String, dynamic>),
      verificationStatus: $enumDecodeNullable(
              _$VerificationStatusEnumMap, json['verificationStatus']) ??
          VerificationStatus.unverified,
      followerCount: (json['followerCount'] as num?)?.toInt() ?? 0,
      followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
      joinDate: DateTime.parse(json['joinDate'] as String),
      socialLinks: (json['socialLinks'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      isBanned: json['isBanned'] as bool? ?? false,
      lastActive: json['lastActive'] == null
          ? null
          : DateTime.parse(json['lastActive'] as String),
    );

Map<String, dynamic> _$$AppUserImplToJson(_$AppUserImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'role': _$UserRoleEnumMap[instance.role]!,
      'currentTier': _$SubscriptionTierEnumMap[instance.currentTier]!,
      'tierExpiry': instance.tierExpiry?.toIso8601String(),
      'profileImageUrl': instance.profileImageUrl,
      'accessibleContentIds': instance.accessibleContentIds,
      'interactionCredits': instance.interactionCredits
          .map((k, e) => MapEntry(_$InteractionTypeEnumMap[k]!, e)),
      'trustedDevices': instance.trustedDevices,
      'earnings': instance.earnings,
      'verificationStatus':
          _$VerificationStatusEnumMap[instance.verificationStatus]!,
      'followerCount': instance.followerCount,
      'followingCount': instance.followingCount,
      'joinDate': instance.joinDate.toIso8601String(),
      'socialLinks': instance.socialLinks,
      'isBanned': instance.isBanned,
      'lastActive': instance.lastActive?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.fan: 'fan',
  UserRole.creator: 'creator',
  UserRole.admin: 'admin',
};

const _$SubscriptionTierEnumMap = {
  SubscriptionTier.generalAdmission: 'generalAdmission',
  SubscriptionTier.backstagePass: 'backstagePass',
  SubscriptionTier.innerCircle: 'innerCircle',
};

const _$InteractionTypeEnumMap = {
  InteractionType.directMessage: 'directMessage',
  InteractionType.contentRequest: 'contentRequest',
  InteractionType.voiceCall: 'voiceCall',
};

const _$VerificationStatusEnumMap = {
  VerificationStatus.unverified: 'unverified',
  VerificationStatus.pending: 'pending',
  VerificationStatus.verified: 'verified',
};

_$DeviceInfoImpl _$$DeviceInfoImplFromJson(Map<String, dynamic> json) =>
    _$DeviceInfoImpl(
      deviceId: json['deviceId'] as String,
      model: json['model'] as String,
      os: json['os'] as String,
      ipAddress: json['ipAddress'] as String,
      firstSeen: DateTime.parse(json['firstSeen'] as String),
      lastActive: DateTime.parse(json['lastActive'] as String),
      locationHash: json['locationHash'] as String,
      isTrusted: json['isTrusted'] as bool? ?? false,
    );

Map<String, dynamic> _$$DeviceInfoImplToJson(_$DeviceInfoImpl instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'model': instance.model,
      'os': instance.os,
      'ipAddress': instance.ipAddress,
      'firstSeen': instance.firstSeen.toIso8601String(),
      'lastActive': instance.lastActive.toIso8601String(),
      'locationHash': instance.locationHash,
      'isTrusted': instance.isTrusted,
    };

_$CreatorEarningsImpl _$$CreatorEarningsImplFromJson(
        Map<String, dynamic> json) =>
    _$CreatorEarningsImpl(
      totalEarnings: (json['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      availableBalance: (json['availableBalance'] as num?)?.toDouble() ?? 0.0,
      stripeConnectId: json['stripeConnectId'] as String?,
      payoutHistory: (json['payoutHistory'] as List<dynamic>?)
              ?.map(
                  (e) => PayoutTransaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      subscriberCounts: json['subscriberCounts'] == null
          ? const {}
          : _subscriberCountsFromJson(
              json['subscriberCounts'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CreatorEarningsImplToJson(
        _$CreatorEarningsImpl instance) =>
    <String, dynamic>{
      'totalEarnings': instance.totalEarnings,
      'availableBalance': instance.availableBalance,
      'stripeConnectId': instance.stripeConnectId,
      'payoutHistory': instance.payoutHistory,
      'subscriberCounts': _subscriberCountsToJson(instance.subscriberCounts),
    };

_$PayoutTransactionImpl _$$PayoutTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$PayoutTransactionImpl(
      amount: (json['amount'] as num).toDouble(),
      payoutDate: DateTime.parse(json['payoutDate'] as String),
      status: json['status'] as String,
      transactionId: json['transactionId'] as String,
    );

Map<String, dynamic> _$$PayoutTransactionImplToJson(
        _$PayoutTransactionImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'payoutDate': instance.payoutDate.toIso8601String(),
      'status': instance.status,
      'transactionId': instance.transactionId,
    };
