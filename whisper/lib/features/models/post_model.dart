import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  final String id;
  final String authorId;
  final String title;
  final String content;
  final List<String> mediaUrls;
  final String mediaType;
  final int likesCount;
  final int commentsCount;
  final String? tier;
  final bool isPublished;

  @JsonKey(defaultValue: false)
  final bool isDeleted;

  @JsonKey(
    fromJson: _timestampFromJson,
    toJson: _timestampToJson,
  )
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.authorId,
    required this.title,
    required this.content,
    required this.mediaUrls,
    required this.mediaType,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.tier,
    this.isPublished = true,
    this.isDeleted = false,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  static DateTime _timestampFromJson(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is DateTime) {
      return timestamp;
    }
    throw ArgumentError('Invalid timestamp format');
  }

  static dynamic _timestampToJson(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  PostModel copyWith({
    String? title,
    String? content,
    List<String>? mediaUrls,
    String? mediaType,
    int? likesCount,
    int? commentsCount,
    String? tier,
    bool? isPublished,
    bool? isDeleted,
  }) {
    return PostModel(
      id: id,
      authorId: authorId,
      title: title ?? this.title,
      content: content ?? this.content,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      mediaType: mediaType ?? this.mediaType,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      tier: tier ?? this.tier,
      isPublished: isPublished ?? this.isPublished,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt,
    );
  }
}
