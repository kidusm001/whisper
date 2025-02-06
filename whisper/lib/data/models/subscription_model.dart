import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_model.freezed.dart';
part 'subscription_model.g.dart';

@freezed
class Subscription with _$Subscription {
  const Subscription._();

  @JsonSerializable(explicitToJson: true)
  factory Subscription({
    required String subscriptionId,
    required String userId,
    required SubscriptionTier tier,
    required SubscriptionStatus status,
    required DateTime startDate,
    required DateTime endDate,
    required double amount,
    required String currency,
    required String paymentMethodId,
    String? stripeSubscriptionId,
    String? previousTier,
    String? discountCode,
    @Default(false) bool autoRenew,
    @Default(false) bool isTrial,
    DateTime? canceledAt,
    DateTime? reactivatedAt,
    @Default(0) int failedPaymentAttempts,
  }) = _Subscription;

  factory Subscription.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Subscription.fromJson(data).copyWith(subscriptionId: doc.id);
  }

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  bool get isActive =>
      status == SubscriptionStatus.active && endDate.isAfter(DateTime.now());

  bool get isExpiringSoon =>
      isActive && endDate.difference(DateTime.now()).inDays < 3;

  double get proratedAmount {
    final daysRemaining = endDate.difference(DateTime.now()).inDays;
    final totalDays = endDate.difference(startDate).inDays;
    return (amount / totalDays) * daysRemaining;
  }
}

enum SubscriptionTier { generalAdmission, backstagePass, innerCircle }

enum SubscriptionStatus {
  active,
  expired,
  canceled,
  pendingPayment,
  pastDue,
  trialing,
  reactivated,
}
