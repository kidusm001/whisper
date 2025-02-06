// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppUser _$AppUserFromJson(Map<String, dynamic> json) {
  return _AppUser.fromJson(json);
}

/// @nodoc
mixin _$AppUser {
  String get uid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;
  SubscriptionTier get currentTier => throw _privateConstructorUsedError;
  DateTime? get tierExpiry => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  List<String> get accessibleContentIds => throw _privateConstructorUsedError;
  Map<InteractionType, int> get interactionCredits =>
      throw _privateConstructorUsedError;
  List<DeviceInfo> get trustedDevices => throw _privateConstructorUsedError;
  CreatorEarnings? get earnings => throw _privateConstructorUsedError;
  VerificationStatus get verificationStatus =>
      throw _privateConstructorUsedError;
  int get followerCount => throw _privateConstructorUsedError;
  int get followingCount => throw _privateConstructorUsedError;
  DateTime get joinDate => throw _privateConstructorUsedError;
  Map<String, String> get socialLinks => throw _privateConstructorUsedError;
  bool get isBanned => throw _privateConstructorUsedError;
  DateTime? get lastActive => throw _privateConstructorUsedError;

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppUserCopyWith<AppUser> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUserCopyWith<$Res> {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) then) =
      _$AppUserCopyWithImpl<$Res, AppUser>;
  @useResult
  $Res call(
      {String uid,
      String email,
      String displayName,
      UserRole role,
      SubscriptionTier currentTier,
      DateTime? tierExpiry,
      String? profileImageUrl,
      List<String> accessibleContentIds,
      Map<InteractionType, int> interactionCredits,
      List<DeviceInfo> trustedDevices,
      CreatorEarnings? earnings,
      VerificationStatus verificationStatus,
      int followerCount,
      int followingCount,
      DateTime joinDate,
      Map<String, String> socialLinks,
      bool isBanned,
      DateTime? lastActive});

  $CreatorEarningsCopyWith<$Res>? get earnings;
}

/// @nodoc
class _$AppUserCopyWithImpl<$Res, $Val extends AppUser>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = null,
    Object? role = null,
    Object? currentTier = null,
    Object? tierExpiry = freezed,
    Object? profileImageUrl = freezed,
    Object? accessibleContentIds = null,
    Object? interactionCredits = null,
    Object? trustedDevices = null,
    Object? earnings = freezed,
    Object? verificationStatus = null,
    Object? followerCount = null,
    Object? followingCount = null,
    Object? joinDate = null,
    Object? socialLinks = null,
    Object? isBanned = null,
    Object? lastActive = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      currentTier: null == currentTier
          ? _value.currentTier
          : currentTier // ignore: cast_nullable_to_non_nullable
              as SubscriptionTier,
      tierExpiry: freezed == tierExpiry
          ? _value.tierExpiry
          : tierExpiry // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      accessibleContentIds: null == accessibleContentIds
          ? _value.accessibleContentIds
          : accessibleContentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      interactionCredits: null == interactionCredits
          ? _value.interactionCredits
          : interactionCredits // ignore: cast_nullable_to_non_nullable
              as Map<InteractionType, int>,
      trustedDevices: null == trustedDevices
          ? _value.trustedDevices
          : trustedDevices // ignore: cast_nullable_to_non_nullable
              as List<DeviceInfo>,
      earnings: freezed == earnings
          ? _value.earnings
          : earnings // ignore: cast_nullable_to_non_nullable
              as CreatorEarnings?,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as VerificationStatus,
      followerCount: null == followerCount
          ? _value.followerCount
          : followerCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _value.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
      joinDate: null == joinDate
          ? _value.joinDate
          : joinDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      socialLinks: null == socialLinks
          ? _value.socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      isBanned: null == isBanned
          ? _value.isBanned
          : isBanned // ignore: cast_nullable_to_non_nullable
              as bool,
      lastActive: freezed == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CreatorEarningsCopyWith<$Res>? get earnings {
    if (_value.earnings == null) {
      return null;
    }

    return $CreatorEarningsCopyWith<$Res>(_value.earnings!, (value) {
      return _then(_value.copyWith(earnings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppUserImplCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$$AppUserImplCopyWith(
          _$AppUserImpl value, $Res Function(_$AppUserImpl) then) =
      __$$AppUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String email,
      String displayName,
      UserRole role,
      SubscriptionTier currentTier,
      DateTime? tierExpiry,
      String? profileImageUrl,
      List<String> accessibleContentIds,
      Map<InteractionType, int> interactionCredits,
      List<DeviceInfo> trustedDevices,
      CreatorEarnings? earnings,
      VerificationStatus verificationStatus,
      int followerCount,
      int followingCount,
      DateTime joinDate,
      Map<String, String> socialLinks,
      bool isBanned,
      DateTime? lastActive});

  @override
  $CreatorEarningsCopyWith<$Res>? get earnings;
}

/// @nodoc
class __$$AppUserImplCopyWithImpl<$Res>
    extends _$AppUserCopyWithImpl<$Res, _$AppUserImpl>
    implements _$$AppUserImplCopyWith<$Res> {
  __$$AppUserImplCopyWithImpl(
      _$AppUserImpl _value, $Res Function(_$AppUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = null,
    Object? role = null,
    Object? currentTier = null,
    Object? tierExpiry = freezed,
    Object? profileImageUrl = freezed,
    Object? accessibleContentIds = null,
    Object? interactionCredits = null,
    Object? trustedDevices = null,
    Object? earnings = freezed,
    Object? verificationStatus = null,
    Object? followerCount = null,
    Object? followingCount = null,
    Object? joinDate = null,
    Object? socialLinks = null,
    Object? isBanned = null,
    Object? lastActive = freezed,
  }) {
    return _then(_$AppUserImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      currentTier: null == currentTier
          ? _value.currentTier
          : currentTier // ignore: cast_nullable_to_non_nullable
              as SubscriptionTier,
      tierExpiry: freezed == tierExpiry
          ? _value.tierExpiry
          : tierExpiry // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      accessibleContentIds: null == accessibleContentIds
          ? _value._accessibleContentIds
          : accessibleContentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      interactionCredits: null == interactionCredits
          ? _value._interactionCredits
          : interactionCredits // ignore: cast_nullable_to_non_nullable
              as Map<InteractionType, int>,
      trustedDevices: null == trustedDevices
          ? _value._trustedDevices
          : trustedDevices // ignore: cast_nullable_to_non_nullable
              as List<DeviceInfo>,
      earnings: freezed == earnings
          ? _value.earnings
          : earnings // ignore: cast_nullable_to_non_nullable
              as CreatorEarnings?,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as VerificationStatus,
      followerCount: null == followerCount
          ? _value.followerCount
          : followerCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _value.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
      joinDate: null == joinDate
          ? _value.joinDate
          : joinDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      socialLinks: null == socialLinks
          ? _value._socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      isBanned: null == isBanned
          ? _value.isBanned
          : isBanned // ignore: cast_nullable_to_non_nullable
              as bool,
      lastActive: freezed == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppUserImpl implements _AppUser {
  const _$AppUserImpl(
      {required this.uid,
      required this.email,
      required this.displayName,
      this.role = UserRole.fan,
      this.currentTier = SubscriptionTier.generalAdmission,
      this.tierExpiry,
      this.profileImageUrl,
      final List<String> accessibleContentIds = const [],
      final Map<InteractionType, int> interactionCredits = const {},
      final List<DeviceInfo> trustedDevices = const [],
      this.earnings,
      this.verificationStatus = VerificationStatus.unverified,
      this.followerCount = 0,
      this.followingCount = 0,
      required this.joinDate,
      final Map<String, String> socialLinks = const {},
      this.isBanned = false,
      this.lastActive})
      : _accessibleContentIds = accessibleContentIds,
        _interactionCredits = interactionCredits,
        _trustedDevices = trustedDevices,
        _socialLinks = socialLinks;

  factory _$AppUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppUserImplFromJson(json);

  @override
  final String uid;
  @override
  final String email;
  @override
  final String displayName;
  @override
  @JsonKey()
  final UserRole role;
  @override
  @JsonKey()
  final SubscriptionTier currentTier;
  @override
  final DateTime? tierExpiry;
  @override
  final String? profileImageUrl;
  final List<String> _accessibleContentIds;
  @override
  @JsonKey()
  List<String> get accessibleContentIds {
    if (_accessibleContentIds is EqualUnmodifiableListView)
      return _accessibleContentIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_accessibleContentIds);
  }

  final Map<InteractionType, int> _interactionCredits;
  @override
  @JsonKey()
  Map<InteractionType, int> get interactionCredits {
    if (_interactionCredits is EqualUnmodifiableMapView)
      return _interactionCredits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_interactionCredits);
  }

  final List<DeviceInfo> _trustedDevices;
  @override
  @JsonKey()
  List<DeviceInfo> get trustedDevices {
    if (_trustedDevices is EqualUnmodifiableListView) return _trustedDevices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trustedDevices);
  }

  @override
  final CreatorEarnings? earnings;
  @override
  @JsonKey()
  final VerificationStatus verificationStatus;
  @override
  @JsonKey()
  final int followerCount;
  @override
  @JsonKey()
  final int followingCount;
  @override
  final DateTime joinDate;
  final Map<String, String> _socialLinks;
  @override
  @JsonKey()
  Map<String, String> get socialLinks {
    if (_socialLinks is EqualUnmodifiableMapView) return _socialLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_socialLinks);
  }

  @override
  @JsonKey()
  final bool isBanned;
  @override
  final DateTime? lastActive;

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, displayName: $displayName, role: $role, currentTier: $currentTier, tierExpiry: $tierExpiry, profileImageUrl: $profileImageUrl, accessibleContentIds: $accessibleContentIds, interactionCredits: $interactionCredits, trustedDevices: $trustedDevices, earnings: $earnings, verificationStatus: $verificationStatus, followerCount: $followerCount, followingCount: $followingCount, joinDate: $joinDate, socialLinks: $socialLinks, isBanned: $isBanned, lastActive: $lastActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUserImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.currentTier, currentTier) ||
                other.currentTier == currentTier) &&
            (identical(other.tierExpiry, tierExpiry) ||
                other.tierExpiry == tierExpiry) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            const DeepCollectionEquality()
                .equals(other._accessibleContentIds, _accessibleContentIds) &&
            const DeepCollectionEquality()
                .equals(other._interactionCredits, _interactionCredits) &&
            const DeepCollectionEquality()
                .equals(other._trustedDevices, _trustedDevices) &&
            (identical(other.earnings, earnings) ||
                other.earnings == earnings) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.joinDate, joinDate) ||
                other.joinDate == joinDate) &&
            const DeepCollectionEquality()
                .equals(other._socialLinks, _socialLinks) &&
            (identical(other.isBanned, isBanned) ||
                other.isBanned == isBanned) &&
            (identical(other.lastActive, lastActive) ||
                other.lastActive == lastActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      email,
      displayName,
      role,
      currentTier,
      tierExpiry,
      profileImageUrl,
      const DeepCollectionEquality().hash(_accessibleContentIds),
      const DeepCollectionEquality().hash(_interactionCredits),
      const DeepCollectionEquality().hash(_trustedDevices),
      earnings,
      verificationStatus,
      followerCount,
      followingCount,
      joinDate,
      const DeepCollectionEquality().hash(_socialLinks),
      isBanned,
      lastActive);

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      __$$AppUserImplCopyWithImpl<_$AppUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppUserImplToJson(
      this,
    );
  }
}

abstract class _AppUser implements AppUser {
  const factory _AppUser(
      {required final String uid,
      required final String email,
      required final String displayName,
      final UserRole role,
      final SubscriptionTier currentTier,
      final DateTime? tierExpiry,
      final String? profileImageUrl,
      final List<String> accessibleContentIds,
      final Map<InteractionType, int> interactionCredits,
      final List<DeviceInfo> trustedDevices,
      final CreatorEarnings? earnings,
      final VerificationStatus verificationStatus,
      final int followerCount,
      final int followingCount,
      required final DateTime joinDate,
      final Map<String, String> socialLinks,
      final bool isBanned,
      final DateTime? lastActive}) = _$AppUserImpl;

  factory _AppUser.fromJson(Map<String, dynamic> json) = _$AppUserImpl.fromJson;

  @override
  String get uid;
  @override
  String get email;
  @override
  String get displayName;
  @override
  UserRole get role;
  @override
  SubscriptionTier get currentTier;
  @override
  DateTime? get tierExpiry;
  @override
  String? get profileImageUrl;
  @override
  List<String> get accessibleContentIds;
  @override
  Map<InteractionType, int> get interactionCredits;
  @override
  List<DeviceInfo> get trustedDevices;
  @override
  CreatorEarnings? get earnings;
  @override
  VerificationStatus get verificationStatus;
  @override
  int get followerCount;
  @override
  int get followingCount;
  @override
  DateTime get joinDate;
  @override
  Map<String, String> get socialLinks;
  @override
  bool get isBanned;
  @override
  DateTime? get lastActive;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) {
  return _DeviceInfo.fromJson(json);
}

/// @nodoc
mixin _$DeviceInfo {
  String get deviceId => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String get os => throw _privateConstructorUsedError;
  String get ipAddress => throw _privateConstructorUsedError;
  DateTime get firstSeen => throw _privateConstructorUsedError;
  DateTime get lastActive => throw _privateConstructorUsedError;
  String get locationHash => throw _privateConstructorUsedError;
  bool get isTrusted => throw _privateConstructorUsedError;

  /// Serializes this DeviceInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceInfoCopyWith<DeviceInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceInfoCopyWith<$Res> {
  factory $DeviceInfoCopyWith(
          DeviceInfo value, $Res Function(DeviceInfo) then) =
      _$DeviceInfoCopyWithImpl<$Res, DeviceInfo>;
  @useResult
  $Res call(
      {String deviceId,
      String model,
      String os,
      String ipAddress,
      DateTime firstSeen,
      DateTime lastActive,
      String locationHash,
      bool isTrusted});
}

/// @nodoc
class _$DeviceInfoCopyWithImpl<$Res, $Val extends DeviceInfo>
    implements $DeviceInfoCopyWith<$Res> {
  _$DeviceInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? model = null,
    Object? os = null,
    Object? ipAddress = null,
    Object? firstSeen = null,
    Object? lastActive = null,
    Object? locationHash = null,
    Object? isTrusted = null,
  }) {
    return _then(_value.copyWith(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      os: null == os
          ? _value.os
          : os // ignore: cast_nullable_to_non_nullable
              as String,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      firstSeen: null == firstSeen
          ? _value.firstSeen
          : firstSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActive: null == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime,
      locationHash: null == locationHash
          ? _value.locationHash
          : locationHash // ignore: cast_nullable_to_non_nullable
              as String,
      isTrusted: null == isTrusted
          ? _value.isTrusted
          : isTrusted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceInfoImplCopyWith<$Res>
    implements $DeviceInfoCopyWith<$Res> {
  factory _$$DeviceInfoImplCopyWith(
          _$DeviceInfoImpl value, $Res Function(_$DeviceInfoImpl) then) =
      __$$DeviceInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String deviceId,
      String model,
      String os,
      String ipAddress,
      DateTime firstSeen,
      DateTime lastActive,
      String locationHash,
      bool isTrusted});
}

/// @nodoc
class __$$DeviceInfoImplCopyWithImpl<$Res>
    extends _$DeviceInfoCopyWithImpl<$Res, _$DeviceInfoImpl>
    implements _$$DeviceInfoImplCopyWith<$Res> {
  __$$DeviceInfoImplCopyWithImpl(
      _$DeviceInfoImpl _value, $Res Function(_$DeviceInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? model = null,
    Object? os = null,
    Object? ipAddress = null,
    Object? firstSeen = null,
    Object? lastActive = null,
    Object? locationHash = null,
    Object? isTrusted = null,
  }) {
    return _then(_$DeviceInfoImpl(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      os: null == os
          ? _value.os
          : os // ignore: cast_nullable_to_non_nullable
              as String,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      firstSeen: null == firstSeen
          ? _value.firstSeen
          : firstSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActive: null == lastActive
          ? _value.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime,
      locationHash: null == locationHash
          ? _value.locationHash
          : locationHash // ignore: cast_nullable_to_non_nullable
              as String,
      isTrusted: null == isTrusted
          ? _value.isTrusted
          : isTrusted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceInfoImpl implements _DeviceInfo {
  _$DeviceInfoImpl(
      {required this.deviceId,
      required this.model,
      required this.os,
      required this.ipAddress,
      required this.firstSeen,
      required this.lastActive,
      required this.locationHash,
      this.isTrusted = false});

  factory _$DeviceInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceInfoImplFromJson(json);

  @override
  final String deviceId;
  @override
  final String model;
  @override
  final String os;
  @override
  final String ipAddress;
  @override
  final DateTime firstSeen;
  @override
  final DateTime lastActive;
  @override
  final String locationHash;
  @override
  @JsonKey()
  final bool isTrusted;

  @override
  String toString() {
    return 'DeviceInfo(deviceId: $deviceId, model: $model, os: $os, ipAddress: $ipAddress, firstSeen: $firstSeen, lastActive: $lastActive, locationHash: $locationHash, isTrusted: $isTrusted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceInfoImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.os, os) || other.os == os) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.firstSeen, firstSeen) ||
                other.firstSeen == firstSeen) &&
            (identical(other.lastActive, lastActive) ||
                other.lastActive == lastActive) &&
            (identical(other.locationHash, locationHash) ||
                other.locationHash == locationHash) &&
            (identical(other.isTrusted, isTrusted) ||
                other.isTrusted == isTrusted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, deviceId, model, os, ipAddress,
      firstSeen, lastActive, locationHash, isTrusted);

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceInfoImplCopyWith<_$DeviceInfoImpl> get copyWith =>
      __$$DeviceInfoImplCopyWithImpl<_$DeviceInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceInfoImplToJson(
      this,
    );
  }
}

abstract class _DeviceInfo implements DeviceInfo {
  factory _DeviceInfo(
      {required final String deviceId,
      required final String model,
      required final String os,
      required final String ipAddress,
      required final DateTime firstSeen,
      required final DateTime lastActive,
      required final String locationHash,
      final bool isTrusted}) = _$DeviceInfoImpl;

  factory _DeviceInfo.fromJson(Map<String, dynamic> json) =
      _$DeviceInfoImpl.fromJson;

  @override
  String get deviceId;
  @override
  String get model;
  @override
  String get os;
  @override
  String get ipAddress;
  @override
  DateTime get firstSeen;
  @override
  DateTime get lastActive;
  @override
  String get locationHash;
  @override
  bool get isTrusted;

  /// Create a copy of DeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceInfoImplCopyWith<_$DeviceInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatorEarnings _$CreatorEarningsFromJson(Map<String, dynamic> json) {
  return _CreatorEarnings.fromJson(json);
}

/// @nodoc
mixin _$CreatorEarnings {
  double get totalEarnings => throw _privateConstructorUsedError;
  double get availableBalance => throw _privateConstructorUsedError;
  String? get stripeConnectId => throw _privateConstructorUsedError;
  List<PayoutTransaction> get payoutHistory =>
      throw _privateConstructorUsedError;
  @JsonKey(fromJson: _subscriberCountsFromJson, toJson: _subscriberCountsToJson)
  Map<SubscriptionTier, int> get subscriberCounts =>
      throw _privateConstructorUsedError;

  /// Serializes this CreatorEarnings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatorEarnings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatorEarningsCopyWith<CreatorEarnings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatorEarningsCopyWith<$Res> {
  factory $CreatorEarningsCopyWith(
          CreatorEarnings value, $Res Function(CreatorEarnings) then) =
      _$CreatorEarningsCopyWithImpl<$Res, CreatorEarnings>;
  @useResult
  $Res call(
      {double totalEarnings,
      double availableBalance,
      String? stripeConnectId,
      List<PayoutTransaction> payoutHistory,
      @JsonKey(
          fromJson: _subscriberCountsFromJson, toJson: _subscriberCountsToJson)
      Map<SubscriptionTier, int> subscriberCounts});
}

/// @nodoc
class _$CreatorEarningsCopyWithImpl<$Res, $Val extends CreatorEarnings>
    implements $CreatorEarningsCopyWith<$Res> {
  _$CreatorEarningsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatorEarnings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalEarnings = null,
    Object? availableBalance = null,
    Object? stripeConnectId = freezed,
    Object? payoutHistory = null,
    Object? subscriberCounts = null,
  }) {
    return _then(_value.copyWith(
      totalEarnings: null == totalEarnings
          ? _value.totalEarnings
          : totalEarnings // ignore: cast_nullable_to_non_nullable
              as double,
      availableBalance: null == availableBalance
          ? _value.availableBalance
          : availableBalance // ignore: cast_nullable_to_non_nullable
              as double,
      stripeConnectId: freezed == stripeConnectId
          ? _value.stripeConnectId
          : stripeConnectId // ignore: cast_nullable_to_non_nullable
              as String?,
      payoutHistory: null == payoutHistory
          ? _value.payoutHistory
          : payoutHistory // ignore: cast_nullable_to_non_nullable
              as List<PayoutTransaction>,
      subscriberCounts: null == subscriberCounts
          ? _value.subscriberCounts
          : subscriberCounts // ignore: cast_nullable_to_non_nullable
              as Map<SubscriptionTier, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatorEarningsImplCopyWith<$Res>
    implements $CreatorEarningsCopyWith<$Res> {
  factory _$$CreatorEarningsImplCopyWith(_$CreatorEarningsImpl value,
          $Res Function(_$CreatorEarningsImpl) then) =
      __$$CreatorEarningsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double totalEarnings,
      double availableBalance,
      String? stripeConnectId,
      List<PayoutTransaction> payoutHistory,
      @JsonKey(
          fromJson: _subscriberCountsFromJson, toJson: _subscriberCountsToJson)
      Map<SubscriptionTier, int> subscriberCounts});
}

/// @nodoc
class __$$CreatorEarningsImplCopyWithImpl<$Res>
    extends _$CreatorEarningsCopyWithImpl<$Res, _$CreatorEarningsImpl>
    implements _$$CreatorEarningsImplCopyWith<$Res> {
  __$$CreatorEarningsImplCopyWithImpl(
      _$CreatorEarningsImpl _value, $Res Function(_$CreatorEarningsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreatorEarnings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalEarnings = null,
    Object? availableBalance = null,
    Object? stripeConnectId = freezed,
    Object? payoutHistory = null,
    Object? subscriberCounts = null,
  }) {
    return _then(_$CreatorEarningsImpl(
      totalEarnings: null == totalEarnings
          ? _value.totalEarnings
          : totalEarnings // ignore: cast_nullable_to_non_nullable
              as double,
      availableBalance: null == availableBalance
          ? _value.availableBalance
          : availableBalance // ignore: cast_nullable_to_non_nullable
              as double,
      stripeConnectId: freezed == stripeConnectId
          ? _value.stripeConnectId
          : stripeConnectId // ignore: cast_nullable_to_non_nullable
              as String?,
      payoutHistory: null == payoutHistory
          ? _value._payoutHistory
          : payoutHistory // ignore: cast_nullable_to_non_nullable
              as List<PayoutTransaction>,
      subscriberCounts: null == subscriberCounts
          ? _value._subscriberCounts
          : subscriberCounts // ignore: cast_nullable_to_non_nullable
              as Map<SubscriptionTier, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatorEarningsImpl implements _CreatorEarnings {
  _$CreatorEarningsImpl(
      {this.totalEarnings = 0.0,
      this.availableBalance = 0.0,
      this.stripeConnectId,
      final List<PayoutTransaction> payoutHistory = const [],
      @JsonKey(
          fromJson: _subscriberCountsFromJson, toJson: _subscriberCountsToJson)
      final Map<SubscriptionTier, int> subscriberCounts = const {}})
      : _payoutHistory = payoutHistory,
        _subscriberCounts = subscriberCounts;

  factory _$CreatorEarningsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatorEarningsImplFromJson(json);

  @override
  @JsonKey()
  final double totalEarnings;
  @override
  @JsonKey()
  final double availableBalance;
  @override
  final String? stripeConnectId;
  final List<PayoutTransaction> _payoutHistory;
  @override
  @JsonKey()
  List<PayoutTransaction> get payoutHistory {
    if (_payoutHistory is EqualUnmodifiableListView) return _payoutHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payoutHistory);
  }

  final Map<SubscriptionTier, int> _subscriberCounts;
  @override
  @JsonKey(fromJson: _subscriberCountsFromJson, toJson: _subscriberCountsToJson)
  Map<SubscriptionTier, int> get subscriberCounts {
    if (_subscriberCounts is EqualUnmodifiableMapView) return _subscriberCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_subscriberCounts);
  }

  @override
  String toString() {
    return 'CreatorEarnings(totalEarnings: $totalEarnings, availableBalance: $availableBalance, stripeConnectId: $stripeConnectId, payoutHistory: $payoutHistory, subscriberCounts: $subscriberCounts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatorEarningsImpl &&
            (identical(other.totalEarnings, totalEarnings) ||
                other.totalEarnings == totalEarnings) &&
            (identical(other.availableBalance, availableBalance) ||
                other.availableBalance == availableBalance) &&
            (identical(other.stripeConnectId, stripeConnectId) ||
                other.stripeConnectId == stripeConnectId) &&
            const DeepCollectionEquality()
                .equals(other._payoutHistory, _payoutHistory) &&
            const DeepCollectionEquality()
                .equals(other._subscriberCounts, _subscriberCounts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalEarnings,
      availableBalance,
      stripeConnectId,
      const DeepCollectionEquality().hash(_payoutHistory),
      const DeepCollectionEquality().hash(_subscriberCounts));

  /// Create a copy of CreatorEarnings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatorEarningsImplCopyWith<_$CreatorEarningsImpl> get copyWith =>
      __$$CreatorEarningsImplCopyWithImpl<_$CreatorEarningsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatorEarningsImplToJson(
      this,
    );
  }
}

abstract class _CreatorEarnings implements CreatorEarnings {
  factory _CreatorEarnings(
          {final double totalEarnings,
          final double availableBalance,
          final String? stripeConnectId,
          final List<PayoutTransaction> payoutHistory,
          @JsonKey(
              fromJson: _subscriberCountsFromJson,
              toJson: _subscriberCountsToJson)
          final Map<SubscriptionTier, int> subscriberCounts}) =
      _$CreatorEarningsImpl;

  factory _CreatorEarnings.fromJson(Map<String, dynamic> json) =
      _$CreatorEarningsImpl.fromJson;

  @override
  double get totalEarnings;
  @override
  double get availableBalance;
  @override
  String? get stripeConnectId;
  @override
  List<PayoutTransaction> get payoutHistory;
  @override
  @JsonKey(fromJson: _subscriberCountsFromJson, toJson: _subscriberCountsToJson)
  Map<SubscriptionTier, int> get subscriberCounts;

  /// Create a copy of CreatorEarnings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatorEarningsImplCopyWith<_$CreatorEarningsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PayoutTransaction _$PayoutTransactionFromJson(Map<String, dynamic> json) {
  return _PayoutTransaction.fromJson(json);
}

/// @nodoc
mixin _$PayoutTransaction {
  double get amount => throw _privateConstructorUsedError;
  DateTime get payoutDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get transactionId => throw _privateConstructorUsedError;

  /// Serializes this PayoutTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PayoutTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PayoutTransactionCopyWith<PayoutTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayoutTransactionCopyWith<$Res> {
  factory $PayoutTransactionCopyWith(
          PayoutTransaction value, $Res Function(PayoutTransaction) then) =
      _$PayoutTransactionCopyWithImpl<$Res, PayoutTransaction>;
  @useResult
  $Res call(
      {double amount,
      DateTime payoutDate,
      String status,
      String transactionId});
}

/// @nodoc
class _$PayoutTransactionCopyWithImpl<$Res, $Val extends PayoutTransaction>
    implements $PayoutTransactionCopyWith<$Res> {
  _$PayoutTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PayoutTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? payoutDate = null,
    Object? status = null,
    Object? transactionId = null,
  }) {
    return _then(_value.copyWith(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      payoutDate: null == payoutDate
          ? _value.payoutDate
          : payoutDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PayoutTransactionImplCopyWith<$Res>
    implements $PayoutTransactionCopyWith<$Res> {
  factory _$$PayoutTransactionImplCopyWith(_$PayoutTransactionImpl value,
          $Res Function(_$PayoutTransactionImpl) then) =
      __$$PayoutTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double amount,
      DateTime payoutDate,
      String status,
      String transactionId});
}

/// @nodoc
class __$$PayoutTransactionImplCopyWithImpl<$Res>
    extends _$PayoutTransactionCopyWithImpl<$Res, _$PayoutTransactionImpl>
    implements _$$PayoutTransactionImplCopyWith<$Res> {
  __$$PayoutTransactionImplCopyWithImpl(_$PayoutTransactionImpl _value,
      $Res Function(_$PayoutTransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PayoutTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? payoutDate = null,
    Object? status = null,
    Object? transactionId = null,
  }) {
    return _then(_$PayoutTransactionImpl(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      payoutDate: null == payoutDate
          ? _value.payoutDate
          : payoutDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PayoutTransactionImpl implements _PayoutTransaction {
  _$PayoutTransactionImpl(
      {required this.amount,
      required this.payoutDate,
      required this.status,
      required this.transactionId});

  factory _$PayoutTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PayoutTransactionImplFromJson(json);

  @override
  final double amount;
  @override
  final DateTime payoutDate;
  @override
  final String status;
  @override
  final String transactionId;

  @override
  String toString() {
    return 'PayoutTransaction(amount: $amount, payoutDate: $payoutDate, status: $status, transactionId: $transactionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayoutTransactionImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.payoutDate, payoutDate) ||
                other.payoutDate == payoutDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, amount, payoutDate, status, transactionId);

  /// Create a copy of PayoutTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PayoutTransactionImplCopyWith<_$PayoutTransactionImpl> get copyWith =>
      __$$PayoutTransactionImplCopyWithImpl<_$PayoutTransactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PayoutTransactionImplToJson(
      this,
    );
  }
}

abstract class _PayoutTransaction implements PayoutTransaction {
  factory _PayoutTransaction(
      {required final double amount,
      required final DateTime payoutDate,
      required final String status,
      required final String transactionId}) = _$PayoutTransactionImpl;

  factory _PayoutTransaction.fromJson(Map<String, dynamic> json) =
      _$PayoutTransactionImpl.fromJson;

  @override
  double get amount;
  @override
  DateTime get payoutDate;
  @override
  String get status;
  @override
  String get transactionId;

  /// Create a copy of PayoutTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PayoutTransactionImplCopyWith<_$PayoutTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
