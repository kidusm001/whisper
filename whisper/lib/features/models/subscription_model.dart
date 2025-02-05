import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'subscription_model.g.dart';

@JsonSerializable()
class SubscriptionModel {
  final String id;
  final String creatorId;
  final String subscriberId;
  final String tierId;
  final double amount;
  final bool isActive;
  
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime startDate;
  
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? endDate;

  SubscriptionModel({
    required this.id,
    required this.creatorId,
    required this.subscriberId,
    required this.tierId,
    required this.amount,
    required this.startDate,
    this.endDate,
    this.isActive = true,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) => 
      _$SubscriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);

  static DateTime _timestampFromJson(Timestamp? timestamp) {
    return timestamp?.toDate() ?? DateTime.now();
  }

  static Timestamp? _timestampToJson(DateTime? date) {
    return date != null ? Timestamp.fromDate(date) : null;
  }
} 