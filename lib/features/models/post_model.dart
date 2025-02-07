import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'post_model.g.dart';

@JsonSerializable()
class PostModel {
  final String id;
  final String authorId;
  final String? authorName;
  final String title;
  final String content;
  final List<String> mediaUrls;
  final String mediaType;
  final int likesCount;
  final int commentsCount;
  final String? tier;
  final bool isPublished;

  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.authorId,
    this.authorName,
    required this.title,
    required this.content,
    required this.mediaUrls,
    required this.mediaType,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.tier,
    this.isPublished = true,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  static DateTime _timestampFromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  static Timestamp _timestampToJson(DateTime date) {
    return Timestamp.fromDate(date);
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
    String? authorName,
  }) {
    return PostModel(
      id: id,
      authorId: authorId,
      authorName: authorName ?? this.authorName,
      title: title ?? this.title,
      content: content ?? this.content,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      mediaType: mediaType ?? this.mediaType,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      tier: tier ?? this.tier,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt,
    );
  }
}
