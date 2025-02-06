// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whisper_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WhisperMessageImpl _$$WhisperMessageImplFromJson(Map<String, dynamic> json) =>
    _$WhisperMessageImpl(
      messageId: json['messageId'] as String,
      senderId: json['senderId'] as String,
      recipientId: json['recipientId'] as String,
      content: json['content'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
      messageType:
          $enumDecodeNullable(_$MessageTypeEnumMap, json['messageType']) ??
              MessageType.text,
      attachmentUrl: json['attachmentUrl'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WhisperMessageImplToJson(
        _$WhisperMessageImpl instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'senderId': instance.senderId,
      'recipientId': instance.recipientId,
      'content': instance.content,
      'sentAt': instance.sentAt.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
      'isRead': instance.isRead,
      'messageType': _$MessageTypeEnumMap[instance.messageType]!,
      'attachmentUrl': instance.attachmentUrl,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.video: 'video',
  MessageType.file: 'file',
};
