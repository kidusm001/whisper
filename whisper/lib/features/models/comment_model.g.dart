// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      id: json['id'] as String,
      postId: json['postId'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String?,
      authorImage: json['authorImage'] as String?,
      content: json['content'] as String,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      likedBy:
          (json['likedBy'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt:
          CommentModel._timestampFromJson(json['createdAt'] as Timestamp),
      parentId: json['parentId'] as String?,
      replyToName: json['replyToName'] as String?,
      replyToId: json['replyToId'] as String?,
      replyCount: (json['replyCount'] as num?)?.toInt() ?? 0,
      authorRole: json['authorRole'] as String?,
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'authorImage': instance.authorImage,
      'content': instance.content,
      'likesCount': instance.likesCount,
      'likedBy': instance.likedBy,
      'parentId': instance.parentId,
      'replyToName': instance.replyToName,
      'replyToId': instance.replyToId,
      'replyCount': instance.replyCount,
      'authorRole': instance.authorRole,
      'createdAt': CommentModel._timestampToJson(instance.createdAt),
    };
