// File: comment_model.dart
// Description: Model for post comments

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final String id;
  final String postId;
  final String authorId;
  final String content;
  final int likesCount;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.content,
    this.likesCount = 0,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  static DateTime _timestampFromJson(Timestamp timestamp) => timestamp.toDate();
  static Timestamp _timestampToJson(DateTime dateTime) =>
      Timestamp.fromDate(dateTime);
}
