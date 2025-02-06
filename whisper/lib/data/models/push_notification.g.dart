// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PushNotificationImpl _$$PushNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$PushNotificationImpl(
      notificationId: json['notificationId'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      sentTime: DateTime.parse(json['sentTime'] as String),
    );

Map<String, dynamic> _$$PushNotificationImplToJson(
        _$PushNotificationImpl instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'userId': instance.userId,
      'title': instance.title,
      'body': instance.body,
      'sentTime': instance.sentTime.toIso8601String(),
    };
