// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SecretContent _$SecretContentFromJson(Map<String, dynamic> json) {
  return _SecretContent.fromJson(json);
}

/// @nodoc
mixin _$SecretContent {
  String get contentId => throw _privateConstructorUsedError;
  String get creatorId => throw _privateConstructorUsedError;
  ContentType get type => throw _privateConstructorUsedError;
  Map<SubscriptionTier, bool> get tierAccess =>
      throw _privateConstructorUsedError;
  String? get encryptedBody => throw _privateConstructorUsedError;
  String? get storagePath => throw _privateConstructorUsedError;
  String? get thumbnailPath => throw _privateConstructorUsedError;
  String? get mimeType => throw _privateConstructorUsedError;
  int? get fileSize => throw _privateConstructorUsedError;
  double? get duration => throw _privateConstructorUsedError;
  String? get waveformData => throw _privateConstructorUsedError;
  String? get watermarkSeed => throw _privateConstructorUsedError;
  String? get encryptionKey => throw _privateConstructorUsedError;
  DateTime? get publishDate => throw _privateConstructorUsedError;
  DateTime? get expirationDate => throw _privateConstructorUsedError;
  bool get isEphemeral => throw _privateConstructorUsedError;
  bool get isEncrypted => throw _privateConstructorUsedError;
  int get viewCount => throw _privateConstructorUsedError;
  int get unlockCount => throw _privateConstructorUsedError;
  int get shareCount => throw _privateConstructorUsedError;
  String? get deepLink => throw _privateConstructorUsedError;
  Dimensions? get dimensions => throw _privateConstructorUsedError;

  /// Serializes this SecretContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SecretContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SecretContentCopyWith<SecretContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SecretContentCopyWith<$Res> {
  factory $SecretContentCopyWith(
          SecretContent value, $Res Function(SecretContent) then) =
      _$SecretContentCopyWithImpl<$Res, SecretContent>;
  @useResult
  $Res call(
      {String contentId,
      String creatorId,
      ContentType type,
      Map<SubscriptionTier, bool> tierAccess,
      String? encryptedBody,
      String? storagePath,
      String? thumbnailPath,
      String? mimeType,
      int? fileSize,
      double? duration,
      String? waveformData,
      String? watermarkSeed,
      String? encryptionKey,
      DateTime? publishDate,
      DateTime? expirationDate,
      bool isEphemeral,
      bool isEncrypted,
      int viewCount,
      int unlockCount,
      int shareCount,
      String? deepLink,
      Dimensions? dimensions});
}

/// @nodoc
class _$SecretContentCopyWithImpl<$Res, $Val extends SecretContent>
    implements $SecretContentCopyWith<$Res> {
  _$SecretContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SecretContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentId = null,
    Object? creatorId = null,
    Object? type = null,
    Object? tierAccess = null,
    Object? encryptedBody = freezed,
    Object? storagePath = freezed,
    Object? thumbnailPath = freezed,
    Object? mimeType = freezed,
    Object? fileSize = freezed,
    Object? duration = freezed,
    Object? waveformData = freezed,
    Object? watermarkSeed = freezed,
    Object? encryptionKey = freezed,
    Object? publishDate = freezed,
    Object? expirationDate = freezed,
    Object? isEphemeral = null,
    Object? isEncrypted = null,
    Object? viewCount = null,
    Object? unlockCount = null,
    Object? shareCount = null,
    Object? deepLink = freezed,
    Object? dimensions = freezed,
  }) {
    return _then(_value.copyWith(
      contentId: null == contentId
          ? _value.contentId
          : contentId // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ContentType,
      tierAccess: null == tierAccess
          ? _value.tierAccess
          : tierAccess // ignore: cast_nullable_to_non_nullable
              as Map<SubscriptionTier, bool>,
      encryptedBody: freezed == encryptedBody
          ? _value.encryptedBody
          : encryptedBody // ignore: cast_nullable_to_non_nullable
              as String?,
      storagePath: freezed == storagePath
          ? _value.storagePath
          : storagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailPath: freezed == thumbnailPath
          ? _value.thumbnailPath
          : thumbnailPath // ignore: cast_nullable_to_non_nullable
              as String?,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as double?,
      waveformData: freezed == waveformData
          ? _value.waveformData
          : waveformData // ignore: cast_nullable_to_non_nullable
              as String?,
      watermarkSeed: freezed == watermarkSeed
          ? _value.watermarkSeed
          : watermarkSeed // ignore: cast_nullable_to_non_nullable
              as String?,
      encryptionKey: freezed == encryptionKey
          ? _value.encryptionKey
          : encryptionKey // ignore: cast_nullable_to_non_nullable
              as String?,
      publishDate: freezed == publishDate
          ? _value.publishDate
          : publishDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expirationDate: freezed == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEphemeral: null == isEphemeral
          ? _value.isEphemeral
          : isEphemeral // ignore: cast_nullable_to_non_nullable
              as bool,
      isEncrypted: null == isEncrypted
          ? _value.isEncrypted
          : isEncrypted // ignore: cast_nullable_to_non_nullable
              as bool,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      unlockCount: null == unlockCount
          ? _value.unlockCount
          : unlockCount // ignore: cast_nullable_to_non_nullable
              as int,
      shareCount: null == shareCount
          ? _value.shareCount
          : shareCount // ignore: cast_nullable_to_non_nullable
              as int,
      deepLink: freezed == deepLink
          ? _value.deepLink
          : deepLink // ignore: cast_nullable_to_non_nullable
              as String?,
      dimensions: freezed == dimensions
          ? _value.dimensions
          : dimensions // ignore: cast_nullable_to_non_nullable
              as Dimensions?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SecretContentImplCopyWith<$Res>
    implements $SecretContentCopyWith<$Res> {
  factory _$$SecretContentImplCopyWith(
          _$SecretContentImpl value, $Res Function(_$SecretContentImpl) then) =
      __$$SecretContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String contentId,
      String creatorId,
      ContentType type,
      Map<SubscriptionTier, bool> tierAccess,
      String? encryptedBody,
      String? storagePath,
      String? thumbnailPath,
      String? mimeType,
      int? fileSize,
      double? duration,
      String? waveformData,
      String? watermarkSeed,
      String? encryptionKey,
      DateTime? publishDate,
      DateTime? expirationDate,
      bool isEphemeral,
      bool isEncrypted,
      int viewCount,
      int unlockCount,
      int shareCount,
      String? deepLink,
      Dimensions? dimensions});
}

/// @nodoc
class __$$SecretContentImplCopyWithImpl<$Res>
    extends _$SecretContentCopyWithImpl<$Res, _$SecretContentImpl>
    implements _$$SecretContentImplCopyWith<$Res> {
  __$$SecretContentImplCopyWithImpl(
      _$SecretContentImpl _value, $Res Function(_$SecretContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of SecretContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentId = null,
    Object? creatorId = null,
    Object? type = null,
    Object? tierAccess = null,
    Object? encryptedBody = freezed,
    Object? storagePath = freezed,
    Object? thumbnailPath = freezed,
    Object? mimeType = freezed,
    Object? fileSize = freezed,
    Object? duration = freezed,
    Object? waveformData = freezed,
    Object? watermarkSeed = freezed,
    Object? encryptionKey = freezed,
    Object? publishDate = freezed,
    Object? expirationDate = freezed,
    Object? isEphemeral = null,
    Object? isEncrypted = null,
    Object? viewCount = null,
    Object? unlockCount = null,
    Object? shareCount = null,
    Object? deepLink = freezed,
    Object? dimensions = freezed,
  }) {
    return _then(_$SecretContentImpl(
      contentId: null == contentId
          ? _value.contentId
          : contentId // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ContentType,
      tierAccess: null == tierAccess
          ? _value._tierAccess
          : tierAccess // ignore: cast_nullable_to_non_nullable
              as Map<SubscriptionTier, bool>,
      encryptedBody: freezed == encryptedBody
          ? _value.encryptedBody
          : encryptedBody // ignore: cast_nullable_to_non_nullable
              as String?,
      storagePath: freezed == storagePath
          ? _value.storagePath
          : storagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailPath: freezed == thumbnailPath
          ? _value.thumbnailPath
          : thumbnailPath // ignore: cast_nullable_to_non_nullable
              as String?,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as double?,
      waveformData: freezed == waveformData
          ? _value.waveformData
          : waveformData // ignore: cast_nullable_to_non_nullable
              as String?,
      watermarkSeed: freezed == watermarkSeed
          ? _value.watermarkSeed
          : watermarkSeed // ignore: cast_nullable_to_non_nullable
              as String?,
      encryptionKey: freezed == encryptionKey
          ? _value.encryptionKey
          : encryptionKey // ignore: cast_nullable_to_non_nullable
              as String?,
      publishDate: freezed == publishDate
          ? _value.publishDate
          : publishDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expirationDate: freezed == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEphemeral: null == isEphemeral
          ? _value.isEphemeral
          : isEphemeral // ignore: cast_nullable_to_non_nullable
              as bool,
      isEncrypted: null == isEncrypted
          ? _value.isEncrypted
          : isEncrypted // ignore: cast_nullable_to_non_nullable
              as bool,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      unlockCount: null == unlockCount
          ? _value.unlockCount
          : unlockCount // ignore: cast_nullable_to_non_nullable
              as int,
      shareCount: null == shareCount
          ? _value.shareCount
          : shareCount // ignore: cast_nullable_to_non_nullable
              as int,
      deepLink: freezed == deepLink
          ? _value.deepLink
          : deepLink // ignore: cast_nullable_to_non_nullable
              as String?,
      dimensions: freezed == dimensions
          ? _value.dimensions
          : dimensions // ignore: cast_nullable_to_non_nullable
              as Dimensions?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$SecretContentImpl extends _SecretContent with DiagnosticableTreeMixin {
  _$SecretContentImpl(
      {required this.contentId,
      required this.creatorId,
      required this.type,
      required final Map<SubscriptionTier, bool> tierAccess,
      this.encryptedBody,
      this.storagePath,
      this.thumbnailPath,
      this.mimeType,
      this.fileSize,
      this.duration,
      this.waveformData,
      this.watermarkSeed,
      this.encryptionKey,
      this.publishDate,
      this.expirationDate,
      this.isEphemeral = false,
      this.isEncrypted = false,
      this.viewCount = 0,
      this.unlockCount = 0,
      this.shareCount = 0,
      this.deepLink,
      this.dimensions})
      : _tierAccess = tierAccess,
        super._();

  factory _$SecretContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$SecretContentImplFromJson(json);

  @override
  final String contentId;
  @override
  final String creatorId;
  @override
  final ContentType type;
  final Map<SubscriptionTier, bool> _tierAccess;
  @override
  Map<SubscriptionTier, bool> get tierAccess {
    if (_tierAccess is EqualUnmodifiableMapView) return _tierAccess;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tierAccess);
  }

  @override
  final String? encryptedBody;
  @override
  final String? storagePath;
  @override
  final String? thumbnailPath;
  @override
  final String? mimeType;
  @override
  final int? fileSize;
  @override
  final double? duration;
  @override
  final String? waveformData;
  @override
  final String? watermarkSeed;
  @override
  final String? encryptionKey;
  @override
  final DateTime? publishDate;
  @override
  final DateTime? expirationDate;
  @override
  @JsonKey()
  final bool isEphemeral;
  @override
  @JsonKey()
  final bool isEncrypted;
  @override
  @JsonKey()
  final int viewCount;
  @override
  @JsonKey()
  final int unlockCount;
  @override
  @JsonKey()
  final int shareCount;
  @override
  final String? deepLink;
  @override
  final Dimensions? dimensions;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SecretContent(contentId: $contentId, creatorId: $creatorId, type: $type, tierAccess: $tierAccess, encryptedBody: $encryptedBody, storagePath: $storagePath, thumbnailPath: $thumbnailPath, mimeType: $mimeType, fileSize: $fileSize, duration: $duration, waveformData: $waveformData, watermarkSeed: $watermarkSeed, encryptionKey: $encryptionKey, publishDate: $publishDate, expirationDate: $expirationDate, isEphemeral: $isEphemeral, isEncrypted: $isEncrypted, viewCount: $viewCount, unlockCount: $unlockCount, shareCount: $shareCount, deepLink: $deepLink, dimensions: $dimensions)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SecretContent'))
      ..add(DiagnosticsProperty('contentId', contentId))
      ..add(DiagnosticsProperty('creatorId', creatorId))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('tierAccess', tierAccess))
      ..add(DiagnosticsProperty('encryptedBody', encryptedBody))
      ..add(DiagnosticsProperty('storagePath', storagePath))
      ..add(DiagnosticsProperty('thumbnailPath', thumbnailPath))
      ..add(DiagnosticsProperty('mimeType', mimeType))
      ..add(DiagnosticsProperty('fileSize', fileSize))
      ..add(DiagnosticsProperty('duration', duration))
      ..add(DiagnosticsProperty('waveformData', waveformData))
      ..add(DiagnosticsProperty('watermarkSeed', watermarkSeed))
      ..add(DiagnosticsProperty('encryptionKey', encryptionKey))
      ..add(DiagnosticsProperty('publishDate', publishDate))
      ..add(DiagnosticsProperty('expirationDate', expirationDate))
      ..add(DiagnosticsProperty('isEphemeral', isEphemeral))
      ..add(DiagnosticsProperty('isEncrypted', isEncrypted))
      ..add(DiagnosticsProperty('viewCount', viewCount))
      ..add(DiagnosticsProperty('unlockCount', unlockCount))
      ..add(DiagnosticsProperty('shareCount', shareCount))
      ..add(DiagnosticsProperty('deepLink', deepLink))
      ..add(DiagnosticsProperty('dimensions', dimensions));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SecretContentImpl &&
            (identical(other.contentId, contentId) ||
                other.contentId == contentId) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._tierAccess, _tierAccess) &&
            (identical(other.encryptedBody, encryptedBody) ||
                other.encryptedBody == encryptedBody) &&
            (identical(other.storagePath, storagePath) ||
                other.storagePath == storagePath) &&
            (identical(other.thumbnailPath, thumbnailPath) ||
                other.thumbnailPath == thumbnailPath) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.waveformData, waveformData) ||
                other.waveformData == waveformData) &&
            (identical(other.watermarkSeed, watermarkSeed) ||
                other.watermarkSeed == watermarkSeed) &&
            (identical(other.encryptionKey, encryptionKey) ||
                other.encryptionKey == encryptionKey) &&
            (identical(other.publishDate, publishDate) ||
                other.publishDate == publishDate) &&
            (identical(other.expirationDate, expirationDate) ||
                other.expirationDate == expirationDate) &&
            (identical(other.isEphemeral, isEphemeral) ||
                other.isEphemeral == isEphemeral) &&
            (identical(other.isEncrypted, isEncrypted) ||
                other.isEncrypted == isEncrypted) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.unlockCount, unlockCount) ||
                other.unlockCount == unlockCount) &&
            (identical(other.shareCount, shareCount) ||
                other.shareCount == shareCount) &&
            (identical(other.deepLink, deepLink) ||
                other.deepLink == deepLink) &&
            (identical(other.dimensions, dimensions) ||
                other.dimensions == dimensions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        contentId,
        creatorId,
        type,
        const DeepCollectionEquality().hash(_tierAccess),
        encryptedBody,
        storagePath,
        thumbnailPath,
        mimeType,
        fileSize,
        duration,
        waveformData,
        watermarkSeed,
        encryptionKey,
        publishDate,
        expirationDate,
        isEphemeral,
        isEncrypted,
        viewCount,
        unlockCount,
        shareCount,
        deepLink,
        dimensions
      ]);

  /// Create a copy of SecretContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SecretContentImplCopyWith<_$SecretContentImpl> get copyWith =>
      __$$SecretContentImplCopyWithImpl<_$SecretContentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SecretContentImplToJson(
      this,
    );
  }
}

abstract class _SecretContent extends SecretContent {
  factory _SecretContent(
      {required final String contentId,
      required final String creatorId,
      required final ContentType type,
      required final Map<SubscriptionTier, bool> tierAccess,
      final String? encryptedBody,
      final String? storagePath,
      final String? thumbnailPath,
      final String? mimeType,
      final int? fileSize,
      final double? duration,
      final String? waveformData,
      final String? watermarkSeed,
      final String? encryptionKey,
      final DateTime? publishDate,
      final DateTime? expirationDate,
      final bool isEphemeral,
      final bool isEncrypted,
      final int viewCount,
      final int unlockCount,
      final int shareCount,
      final String? deepLink,
      final Dimensions? dimensions}) = _$SecretContentImpl;
  _SecretContent._() : super._();

  factory _SecretContent.fromJson(Map<String, dynamic> json) =
      _$SecretContentImpl.fromJson;

  @override
  String get contentId;
  @override
  String get creatorId;
  @override
  ContentType get type;
  @override
  Map<SubscriptionTier, bool> get tierAccess;
  @override
  String? get encryptedBody;
  @override
  String? get storagePath;
  @override
  String? get thumbnailPath;
  @override
  String? get mimeType;
  @override
  int? get fileSize;
  @override
  double? get duration;
  @override
  String? get waveformData;
  @override
  String? get watermarkSeed;
  @override
  String? get encryptionKey;
  @override
  DateTime? get publishDate;
  @override
  DateTime? get expirationDate;
  @override
  bool get isEphemeral;
  @override
  bool get isEncrypted;
  @override
  int get viewCount;
  @override
  int get unlockCount;
  @override
  int get shareCount;
  @override
  String? get deepLink;
  @override
  Dimensions? get dimensions;

  /// Create a copy of SecretContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SecretContentImplCopyWith<_$SecretContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
