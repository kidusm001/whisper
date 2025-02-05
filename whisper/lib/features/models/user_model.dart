import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? coverImage;
  final String? bio;
  final String? role;
  final Map<String, String>? socialLinks;
  final List<String>? subscriptions;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.coverImage,
    this.bio,
    this.role,
    this.socialLinks,
    this.subscriptions,
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Ensure uid is present
    if (!json.containsKey('uid')) {
      throw FormatException('Missing uid in UserModel json');
    }
    return _$UserModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  static DateTime? _timestampFromJson(Timestamp? timestamp) {
    return timestamp?.toDate();
  }

  static Timestamp? _timestampToJson(DateTime? date) {
    return date != null ? Timestamp.fromDate(date) : null;
  }

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    String? coverImage,
    String? bio,
    String? role,
    Map<String, String>? socialLinks,
    List<String>? subscriptions,
    int? postsCount,
    int? followersCount,
    int? followingCount,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      coverImage: coverImage ?? this.coverImage,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      socialLinks: socialLinks ?? this.socialLinks,
      subscriptions: subscriptions ?? this.subscriptions,
      postsCount: postsCount ?? this.postsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      createdAt: createdAt,
    );
  }
} 