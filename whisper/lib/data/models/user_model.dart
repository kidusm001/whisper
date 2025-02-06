import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String email,
    required String displayName,
    @Default(UserRole.fan) UserRole role,
    @Default(SubscriptionTier.generalAdmission) SubscriptionTier currentTier,
    DateTime? tierExpiry,
    String? profileImageUrl,
    @Default([]) List<String> accessibleContentIds,
    @Default({}) Map<InteractionType, int> interactionCredits,
    @Default([]) List<DeviceInfo> trustedDevices,
    CreatorEarnings? earnings,
    @Default(VerificationStatus.unverified)
    VerificationStatus verificationStatus,
    @Default(0) int followerCount,
    @Default(0) int followingCount,
    required DateTime joinDate,
    @Default({}) Map<String, String> socialLinks,
    @Default(false) bool isBanned,
    DateTime? lastActive,
  }) = _AppUser;

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser.fromJson(data).copyWith(uid: doc.id);
  }

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}

enum UserRole { fan, creator, admin }

enum SubscriptionTier { generalAdmission, backstagePass, innerCircle }

enum VerificationStatus { unverified, pending, verified }

enum InteractionType { directMessage, contentRequest, voiceCall }

@freezed
class DeviceInfo with _$DeviceInfo {
  factory DeviceInfo({
    required String deviceId,
    required String model,
    required String os,
    required String ipAddress,
    required DateTime firstSeen,
    required DateTime lastActive,
    required String locationHash,
    @Default(false) bool isTrusted,
  }) = _DeviceInfo;

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);
}

@freezed
class CreatorEarnings with _$CreatorEarnings {
  factory CreatorEarnings({
    @Default(0.0) double totalEarnings,
    @Default(0.0) double availableBalance,
    String? stripeConnectId,
    @Default([]) List<PayoutTransaction> payoutHistory,
    @JsonKey(
        fromJson: _subscriberCountsFromJson, toJson: _subscriberCountsToJson)
    @Default({})
    Map<SubscriptionTier, int> subscriberCounts,
  }) = _CreatorEarnings;

  factory CreatorEarnings.fromJson(Map<String, dynamic> json) =>
      _$CreatorEarningsFromJson(json);
}

// Custom converters for Map<SubscriptionTier, int>
Map<SubscriptionTier, int> _subscriberCountsFromJson(
    Map<String, dynamic> json) {
  return json.map(
      (key, value) => MapEntry(_subscriptionTierFromString(key), value as int));
}

Map<String, int> _subscriberCountsToJson(Map<SubscriptionTier, int> map) {
  return map
      .map((key, value) => MapEntry(_subscriptionTierToString(key), value));
}

SubscriptionTier _subscriptionTierFromString(String value) =>
    SubscriptionTier.values.firstWhere((e) => e.toString() == value,
        orElse: () => SubscriptionTier.generalAdmission);

String _subscriptionTierToString(SubscriptionTier tier) => tier.toString();

@freezed
class PayoutTransaction with _$PayoutTransaction {
  factory PayoutTransaction({
    required double amount,
    required DateTime payoutDate,
    required String status,
    required String transactionId,
  }) = _PayoutTransaction;

  factory PayoutTransaction.fromJson(Map<String, dynamic> json) =>
      _$PayoutTransactionFromJson(json);
}
