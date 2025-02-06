// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'whisper_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WhisperMessage _$WhisperMessageFromJson(Map<String, dynamic> json) {
  return _WhisperMessage.fromJson(json);
}

/// @nodoc
mixin _$WhisperMessage {
  /// Unique identifier for the message.
  String get messageId => throw _privateConstructorUsedError;

  /// The sender's user ID.
  String get senderId => throw _privateConstructorUsedError;

  /// The recipient's user ID.
  String get recipientId => throw _privateConstructorUsedError;

  /// The text or description content.
  String get content => throw _privateConstructorUsedError;

  /// The time the message was sent.
  DateTime get sentAt => throw _privateConstructorUsedError;

  /// Optional time when the message was read.
  DateTime? get readAt => throw _privateConstructorUsedError;

  /// Whether the message has been read.
  bool get isRead => throw _privateConstructorUsedError;

  /// Type of the message.
  MessageType get messageType => throw _privateConstructorUsedError;

  /// Optional attachment URL (e.g. image, file).
  String? get attachmentUrl => throw _privateConstructorUsedError;

  /// Optional timestamp when the message was last updated.
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this WhisperMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WhisperMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WhisperMessageCopyWith<WhisperMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WhisperMessageCopyWith<$Res> {
  factory $WhisperMessageCopyWith(
          WhisperMessage value, $Res Function(WhisperMessage) then) =
      _$WhisperMessageCopyWithImpl<$Res, WhisperMessage>;
  @useResult
  $Res call(
      {String messageId,
      String senderId,
      String recipientId,
      String content,
      DateTime sentAt,
      DateTime? readAt,
      bool isRead,
      MessageType messageType,
      String? attachmentUrl,
      DateTime? updatedAt});
}

/// @nodoc
class _$WhisperMessageCopyWithImpl<$Res, $Val extends WhisperMessage>
    implements $WhisperMessageCopyWith<$Res> {
  _$WhisperMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WhisperMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = null,
    Object? senderId = null,
    Object? recipientId = null,
    Object? content = null,
    Object? sentAt = null,
    Object? readAt = freezed,
    Object? isRead = null,
    Object? messageType = null,
    Object? attachmentUrl = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      recipientId: null == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as MessageType,
      attachmentUrl: freezed == attachmentUrl
          ? _value.attachmentUrl
          : attachmentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WhisperMessageImplCopyWith<$Res>
    implements $WhisperMessageCopyWith<$Res> {
  factory _$$WhisperMessageImplCopyWith(_$WhisperMessageImpl value,
          $Res Function(_$WhisperMessageImpl) then) =
      __$$WhisperMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String messageId,
      String senderId,
      String recipientId,
      String content,
      DateTime sentAt,
      DateTime? readAt,
      bool isRead,
      MessageType messageType,
      String? attachmentUrl,
      DateTime? updatedAt});
}

/// @nodoc
class __$$WhisperMessageImplCopyWithImpl<$Res>
    extends _$WhisperMessageCopyWithImpl<$Res, _$WhisperMessageImpl>
    implements _$$WhisperMessageImplCopyWith<$Res> {
  __$$WhisperMessageImplCopyWithImpl(
      _$WhisperMessageImpl _value, $Res Function(_$WhisperMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of WhisperMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = null,
    Object? senderId = null,
    Object? recipientId = null,
    Object? content = null,
    Object? sentAt = null,
    Object? readAt = freezed,
    Object? isRead = null,
    Object? messageType = null,
    Object? attachmentUrl = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$WhisperMessageImpl(
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      recipientId: null == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as MessageType,
      attachmentUrl: freezed == attachmentUrl
          ? _value.attachmentUrl
          : attachmentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$WhisperMessageImpl implements _WhisperMessage {
  const _$WhisperMessageImpl(
      {required this.messageId,
      required this.senderId,
      required this.recipientId,
      required this.content,
      required this.sentAt,
      this.readAt,
      this.isRead = false,
      this.messageType = MessageType.text,
      this.attachmentUrl,
      this.updatedAt});

  factory _$WhisperMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$WhisperMessageImplFromJson(json);

  /// Unique identifier for the message.
  @override
  final String messageId;

  /// The sender's user ID.
  @override
  final String senderId;

  /// The recipient's user ID.
  @override
  final String recipientId;

  /// The text or description content.
  @override
  final String content;

  /// The time the message was sent.
  @override
  final DateTime sentAt;

  /// Optional time when the message was read.
  @override
  final DateTime? readAt;

  /// Whether the message has been read.
  @override
  @JsonKey()
  final bool isRead;

  /// Type of the message.
  @override
  @JsonKey()
  final MessageType messageType;

  /// Optional attachment URL (e.g. image, file).
  @override
  final String? attachmentUrl;

  /// Optional timestamp when the message was last updated.
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'WhisperMessage(messageId: $messageId, senderId: $senderId, recipientId: $recipientId, content: $content, sentAt: $sentAt, readAt: $readAt, isRead: $isRead, messageType: $messageType, attachmentUrl: $attachmentUrl, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WhisperMessageImpl &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.attachmentUrl, attachmentUrl) ||
                other.attachmentUrl == attachmentUrl) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, messageId, senderId, recipientId,
      content, sentAt, readAt, isRead, messageType, attachmentUrl, updatedAt);

  /// Create a copy of WhisperMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WhisperMessageImplCopyWith<_$WhisperMessageImpl> get copyWith =>
      __$$WhisperMessageImplCopyWithImpl<_$WhisperMessageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WhisperMessageImplToJson(
      this,
    );
  }
}

abstract class _WhisperMessage implements WhisperMessage {
  const factory _WhisperMessage(
      {required final String messageId,
      required final String senderId,
      required final String recipientId,
      required final String content,
      required final DateTime sentAt,
      final DateTime? readAt,
      final bool isRead,
      final MessageType messageType,
      final String? attachmentUrl,
      final DateTime? updatedAt}) = _$WhisperMessageImpl;

  factory _WhisperMessage.fromJson(Map<String, dynamic> json) =
      _$WhisperMessageImpl.fromJson;

  /// Unique identifier for the message.
  @override
  String get messageId;

  /// The sender's user ID.
  @override
  String get senderId;

  /// The recipient's user ID.
  @override
  String get recipientId;

  /// The text or description content.
  @override
  String get content;

  /// The time the message was sent.
  @override
  DateTime get sentAt;

  /// Optional time when the message was read.
  @override
  DateTime? get readAt;

  /// Whether the message has been read.
  @override
  bool get isRead;

  /// Type of the message.
  @override
  MessageType get messageType;

  /// Optional attachment URL (e.g. image, file).
  @override
  String? get attachmentUrl;

  /// Optional timestamp when the message was last updated.
  @override
  DateTime? get updatedAt;

  /// Create a copy of WhisperMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WhisperMessageImplCopyWith<_$WhisperMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
