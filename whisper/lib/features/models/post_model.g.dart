// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      mediaUrls:
          (json['mediaUrls'] as List<dynamic>).map((e) => e as String).toList(),
      mediaType: json['mediaType'] as String,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      tier: json['tier'] as String?,
      isPublished: json['isPublished'] as bool? ?? true,
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: PostModel._timestampFromJson(json['createdAt']),
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'title': instance.title,
      'content': instance.content,
      'mediaUrls': instance.mediaUrls,
      'mediaType': instance.mediaType,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'tier': instance.tier,
      'isPublished': instance.isPublished,
      'isDeleted': instance.isDeleted,
      'createdAt': PostModel._timestampToJson(instance.createdAt),
    };
