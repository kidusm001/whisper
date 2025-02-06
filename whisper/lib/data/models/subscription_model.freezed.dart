// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) {
  return _Subscription.fromJson(json);
}

/// @nodoc
mixin _$Subscription {
  String get subscriptionId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  SubscriptionTier get tier => throw _privateConstructorUsedError;
  SubscriptionStatus get status => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get paymentMethodId => throw _privateConstructorUsedError;
  String? get stripeSubscriptionId => throw _privateConstructorUsedError;
  String? get previousTier => throw _privateConstructorUsedError;
  String? get discountCode => throw _privateConstructorUsedError;
  bool get autoRenew => throw _privateConstructorUsedError;
  bool get isTrial => throw _privateConstructorUsedError;
  DateTime? get canceledAt => throw _privateConstructorUsedError;
  DateTime? get reactivatedAt => throw _privateConstructorUsedError;
  int get failedPaymentAttempts => throw _privateConstructorUsedError;

  /// Serializes this Subscription to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionCopyWith<Subscription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionCopyWith<$Res> {
  factory $SubscriptionCopyWith(
          Subscription value, $Res Function(Subscription) then) =
      _$SubscriptionCopyWithImpl<$Res, Subscription>;
  @useResult
  $Res call(
      {String subscriptionId,
      String userId,
      SubscriptionTier tier,
      SubscriptionStatus status,
      DateTime startDate,
      DateTime endDate,
      double amount,
      String currency,
      String paymentMethodId,
      String? stripeSubscriptionId,
      String? previousTier,
      String? discountCode,
      bool autoRenew,
      bool isTrial,
      DateTime? canceledAt,
      DateTime? reactivatedAt,
      int failedPaymentAttempts});
}

/// @nodoc
class _$SubscriptionCopyWithImpl<$Res, $Val extends Subscription>
    implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscriptionId = null,
    Object? userId = null,
    Object? tier = null,
    Object? status = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? amount = null,
    Object? currency = null,
    Object? paymentMethodId = null,
    Object? stripeSubscriptionId = freezed,
    Object? previousTier = freezed,
    Object? discountCode = freezed,
    Object? autoRenew = null,
    Object? isTrial = null,
    Object? canceledAt = freezed,
    Object? reactivatedAt = freezed,
    Object? failedPaymentAttempts = null,
  }) {
    return _then(_value.copyWith(
      subscriptionId: null == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as SubscriptionTier,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SubscriptionStatus,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethodId: null == paymentMethodId
          ? _value.paymentMethodId
          : paymentMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      stripeSubscriptionId: freezed == stripeSubscriptionId
          ? _value.stripeSubscriptionId
          : stripeSubscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      previousTier: freezed == previousTier
          ? _value.previousTier
          : previousTier // ignore: cast_nullable_to_non_nullable
              as String?,
      discountCode: freezed == discountCode
          ? _value.discountCode
          : discountCode // ignore: cast_nullable_to_non_nullable
              as String?,
      autoRenew: null == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool,
      isTrial: null == isTrial
          ? _value.isTrial
          : isTrial // ignore: cast_nullable_to_non_nullable
              as bool,
      canceledAt: freezed == canceledAt
          ? _value.canceledAt
          : canceledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reactivatedAt: freezed == reactivatedAt
          ? _value.reactivatedAt
          : reactivatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      failedPaymentAttempts: null == failedPaymentAttempts
          ? _value.failedPaymentAttempts
          : failedPaymentAttempts // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionImplCopyWith<$Res>
    implements $SubscriptionCopyWith<$Res> {
  factory _$$SubscriptionImplCopyWith(
          _$SubscriptionImpl value, $Res Function(_$SubscriptionImpl) then) =
      __$$SubscriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String subscriptionId,
      String userId,
      SubscriptionTier tier,
      SubscriptionStatus status,
      DateTime startDate,
      DateTime endDate,
      double amount,
      String currency,
      String paymentMethodId,
      String? stripeSubscriptionId,
      String? previousTier,
      String? discountCode,
      bool autoRenew,
      bool isTrial,
      DateTime? canceledAt,
      DateTime? reactivatedAt,
      int failedPaymentAttempts});
}

/// @nodoc
class __$$SubscriptionImplCopyWithImpl<$Res>
    extends _$SubscriptionCopyWithImpl<$Res, _$SubscriptionImpl>
    implements _$$SubscriptionImplCopyWith<$Res> {
  __$$SubscriptionImplCopyWithImpl(
      _$SubscriptionImpl _value, $Res Function(_$SubscriptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscriptionId = null,
    Object? userId = null,
    Object? tier = null,
    Object? status = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? amount = null,
    Object? currency = null,
    Object? paymentMethodId = null,
    Object? stripeSubscriptionId = freezed,
    Object? previousTier = freezed,
    Object? discountCode = freezed,
    Object? autoRenew = null,
    Object? isTrial = null,
    Object? canceledAt = freezed,
    Object? reactivatedAt = freezed,
    Object? failedPaymentAttempts = null,
  }) {
    return _then(_$SubscriptionImpl(
      subscriptionId: null == subscriptionId
          ? _value.subscriptionId
          : subscriptionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as SubscriptionTier,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SubscriptionStatus,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethodId: null == paymentMethodId
          ? _value.paymentMethodId
          : paymentMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      stripeSubscriptionId: freezed == stripeSubscriptionId
          ? _value.stripeSubscriptionId
          : stripeSubscriptionId // ignore: cast_nullable_to_non_nullable
              as String?,
      previousTier: freezed == previousTier
          ? _value.previousTier
          : previousTier // ignore: cast_nullable_to_non_nullable
              as String?,
      discountCode: freezed == discountCode
          ? _value.discountCode
          : discountCode // ignore: cast_nullable_to_non_nullable
              as String?,
      autoRenew: null == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool,
      isTrial: null == isTrial
          ? _value.isTrial
          : isTrial // ignore: cast_nullable_to_non_nullable
              as bool,
      canceledAt: freezed == canceledAt
          ? _value.canceledAt
          : canceledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reactivatedAt: freezed == reactivatedAt
          ? _value.reactivatedAt
          : reactivatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      failedPaymentAttempts: null == failedPaymentAttempts
          ? _value.failedPaymentAttempts
          : failedPaymentAttempts // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$SubscriptionImpl extends _Subscription {
  _$SubscriptionImpl(
      {required this.subscriptionId,
      required this.userId,
      required this.tier,
      required this.status,
      required this.startDate,
      required this.endDate,
      required this.amount,
      required this.currency,
      required this.paymentMethodId,
      this.stripeSubscriptionId,
      this.previousTier,
      this.discountCode,
      this.autoRenew = false,
      this.isTrial = false,
      this.canceledAt,
      this.reactivatedAt,
      this.failedPaymentAttempts = 0})
      : super._();

  factory _$SubscriptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionImplFromJson(json);

  @override
  final String subscriptionId;
  @override
  final String userId;
  @override
  final SubscriptionTier tier;
  @override
  final SubscriptionStatus status;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final String paymentMethodId;
  @override
  final String? stripeSubscriptionId;
  @override
  final String? previousTier;
  @override
  final String? discountCode;
  @override
  @JsonKey()
  final bool autoRenew;
  @override
  @JsonKey()
  final bool isTrial;
  @override
  final DateTime? canceledAt;
  @override
  final DateTime? reactivatedAt;
  @override
  @JsonKey()
  final int failedPaymentAttempts;

  @override
  String toString() {
    return 'Subscription(subscriptionId: $subscriptionId, userId: $userId, tier: $tier, status: $status, startDate: $startDate, endDate: $endDate, amount: $amount, currency: $currency, paymentMethodId: $paymentMethodId, stripeSubscriptionId: $stripeSubscriptionId, previousTier: $previousTier, discountCode: $discountCode, autoRenew: $autoRenew, isTrial: $isTrial, canceledAt: $canceledAt, reactivatedAt: $reactivatedAt, failedPaymentAttempts: $failedPaymentAttempts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionImpl &&
            (identical(other.subscriptionId, subscriptionId) ||
                other.subscriptionId == subscriptionId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.paymentMethodId, paymentMethodId) ||
                other.paymentMethodId == paymentMethodId) &&
            (identical(other.stripeSubscriptionId, stripeSubscriptionId) ||
                other.stripeSubscriptionId == stripeSubscriptionId) &&
            (identical(other.previousTier, previousTier) ||
                other.previousTier == previousTier) &&
            (identical(other.discountCode, discountCode) ||
                other.discountCode == discountCode) &&
            (identical(other.autoRenew, autoRenew) ||
                other.autoRenew == autoRenew) &&
            (identical(other.isTrial, isTrial) || other.isTrial == isTrial) &&
            (identical(other.canceledAt, canceledAt) ||
                other.canceledAt == canceledAt) &&
            (identical(other.reactivatedAt, reactivatedAt) ||
                other.reactivatedAt == reactivatedAt) &&
            (identical(other.failedPaymentAttempts, failedPaymentAttempts) ||
                other.failedPaymentAttempts == failedPaymentAttempts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      subscriptionId,
      userId,
      tier,
      status,
      startDate,
      endDate,
      amount,
      currency,
      paymentMethodId,
      stripeSubscriptionId,
      previousTier,
      discountCode,
      autoRenew,
      isTrial,
      canceledAt,
      reactivatedAt,
      failedPaymentAttempts);

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      __$$SubscriptionImplCopyWithImpl<_$SubscriptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionImplToJson(
      this,
    );
  }
}

abstract class _Subscription extends Subscription {
  factory _Subscription(
      {required final String subscriptionId,
      required final String userId,
      required final SubscriptionTier tier,
      required final SubscriptionStatus status,
      required final DateTime startDate,
      required final DateTime endDate,
      required final double amount,
      required final String currency,
      required final String paymentMethodId,
      final String? stripeSubscriptionId,
      final String? previousTier,
      final String? discountCode,
      final bool autoRenew,
      final bool isTrial,
      final DateTime? canceledAt,
      final DateTime? reactivatedAt,
      final int failedPaymentAttempts}) = _$SubscriptionImpl;
  _Subscription._() : super._();

  factory _Subscription.fromJson(Map<String, dynamic> json) =
      _$SubscriptionImpl.fromJson;

  @override
  String get subscriptionId;
  @override
  String get userId;
  @override
  SubscriptionTier get tier;
  @override
  SubscriptionStatus get status;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  double get amount;
  @override
  String get currency;
  @override
  String get paymentMethodId;
  @override
  String? get stripeSubscriptionId;
  @override
  String? get previousTier;
  @override
  String? get discountCode;
  @override
  bool get autoRenew;
  @override
  bool get isTrial;
  @override
  DateTime? get canceledAt;
  @override
  DateTime? get reactivatedAt;
  @override
  int get failedPaymentAttempts;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
