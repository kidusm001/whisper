// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      coverImage: json['coverImage'] as String?,
      bio: json['bio'] as String?,
      role: json['role'] as String?,
      socialLinks: (json['socialLinks'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      subscriptions: (json['subscriptions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      postsCount: (json['postsCount'] as num?)?.toInt() ?? 0,
      followersCount: (json['followersCount'] as num?)?.toInt() ?? 0,
      followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
      createdAt: UserModel._timestampFromJson(json['createdAt'] as Timestamp?),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'coverImage': instance.coverImage,
      'bio': instance.bio,
      'role': instance.role,
      'socialLinks': instance.socialLinks,
      'subscriptions': instance.subscriptions,
      'postsCount': instance.postsCount,
      'followersCount': instance.followersCount,
      'followingCount': instance.followingCount,
      'createdAt': UserModel._timestampToJson(instance.createdAt),
    };
