import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'tier_model.g.dart';

@JsonSerializable()
class TierModel {
  final String id;
  final String creatorId;
  final String name;
  final String description;
  final double price;
  final List<String> benefits;
  final int subscriberCount;
  final bool isActive;
  
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime createdAt;

  TierModel({
    required this.id,
    required this.creatorId,
    required this.name,
    required this.description,
    required this.price,
    required this.benefits,
    this.subscriberCount = 0,
    this.isActive = true,
    required this.createdAt,
  });

  factory TierModel.fromJson(Map<String, dynamic> json) => 
      _$TierModelFromJson(json);

  Map<String, dynamic> toJson() => _$TierModelToJson(this);

  static DateTime _timestampFromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  static Timestamp _timestampToJson(DateTime date) {
    return Timestamp.fromDate(date);
  }
} 