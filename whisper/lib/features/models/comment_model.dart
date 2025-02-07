import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final String id;
  final String postId;
  final String authorId;
  final String? authorName;
  final String? authorImage;
  final String content;
  final int likesCount;
  final List<String> likedBy;

  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.authorId,
    this.authorName,
    this.authorImage,
    required this.content,
    this.likesCount = 0,
    List<String>? likedBy,
    required this.createdAt,
  }) : likedBy = likedBy ?? [];

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  static DateTime _timestampFromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  static Timestamp _timestampToJson(DateTime date) {
    return Timestamp.fromDate(date);
  }
}
